Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751422Ab1HIOxE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 10:53:04 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:47788 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750773Ab1HIOxC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 10:53:02 -0400
Date: Tue, 9 Aug 2011 23:52:53 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Ashish Jangam <Ashish.Jangam@kpitcummins.com>
Cc: "sameo@openedhand.com" <sameo@openedhand.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dajun <dajun.chen@diasemi.com>,
        "linaro-dev@lists.linaro.org" <linaro-dev@lists.linaro.org>
Subject: Re: [PATCH v3 01/11] MFD: DA9052 MFD core module
Message-ID: <20110809145252.GC15861@opensource.wolfsonmicro.com>
References: <1312552424.5572.145.camel@L-0532.kpit.com>
 <20110806133829.GA28267@opensource.wolfsonmicro.com>
 <C3AE124F08223B42BC95AEB82F0F6CEDC805@KCHJEXMB02.kpit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <C3AE124F08223B42BC95AEB82F0F6CEDC805@KCHJEXMB02.kpit.com>
X-Cookie: Be careful!  UGLY strikes 9 out of 10!
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 09, 2011 at 08:45:47AM +0000, Ashish Jangam wrote:

> > Could do with blank lines between blocks.  Though looking at the code
> > here I don't understand why these are compile options at all, or if they
> > need to be compile options for some reason why they're not independantly
> > selectable?

> DA9052 PMIC chip id may get OTP therefore chip id cannot be used as 
> a distinguishing factor. Hence these compile time options were introduced.
> DA9053 is a higher version of DA9052 therefore not independently selectable.
> This means that there can be either DA9052 or DA9053 on system. I need to correct
> this Kconfig to take care of this. 

No, this is not acceptable in the kernel.  One kernel can support many
different boards so you need to be able to compile support for all chips
in simultaneously.  If you can't identify based on the hardware you need
to rely on the device being registered correctly by the user.

> > This should be runtime detected based on the device name, either from
> > the device registration or by reading back chip identification.

> As said above getting chip info will not work in DA9053/53 case. Also DA9052 code 
> works for DA9053 except for few minor changes in MFD and regulator module.
> In this case registering different device will also require a preprocessor directive
> Or separate DA9053 file therefore this option was not opt. 

No, this is not acceptable.  One kernel build should be able to support
many different boards.  Like I said in my quote above you need to either
use the device registration or chip registers - if chip registers are
not suitable I guess that means you need to use the device registration.
There are a large number of examples of this in the kernel.

I know the Linaro guys have offered to help you out with this stuff, can
you please work with them?  You are obviously experiencing a lot of
difficulties with understanding the requirements and standards for
getting your code into the standard kernel, they really know what
they're doing.
