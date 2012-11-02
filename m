Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759588Ab2KBJW2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 05:22:28 -0400
Received: from antcom.de ([188.40.178.216]:41487 "EHLO chuck.antcom.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756600Ab2KBJW0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 05:22:26 -0400
Message-ID: <509390CE.90402@antcom.de>
Date: Fri, 02 Nov 2012 10:22:22 +0100
From: Roland Stigge <stigge@antcom.de>
Organization: ANTCOM IT Research & Development
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.9) Gecko/20121015 Icedove/10.0.9
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>
CC: gregkh@linuxfoundation.org, linus.walleij@linaro.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        w.sang@pengutronix.de, jbe@pengutronix.de, plagnioj@jcrosoft.com,
        highguy@gmail.com, broonie@opensource.wolfsonmicro.com,
        daniel-gl@gmx.net, rmallon@gmail.com
Subject: Re: [PATCH RESEND 1/5 v6] gpio: Add a block GPIO API to gpiolib
References: <1351457210-25222-1-git-send-email-stigge@antcom.de> <1351457210-25222-2-git-send-email-stigge@antcom.de> <CACxGe6vgryMPygc8SKFLKqP8Wq=pcGiJe_dPCiDC-evzf32UMA@mail.gmail.com> <50915DBC.2000802@antcom.de> <CACxGe6vEr5fd0_ZuzV=nOXVfwA7_FB5L6KJsEwMEHmVj0rDA=g@mail.gmail.com>
In-Reply-To: <CACxGe6vEr5fd0_ZuzV=nOXVfwA7_FB5L6KJsEwMEHmVj0rDA=g@mail.gmail.com>
X-Enigmail-Version: 1.4
OpenPGP: url=subkeys.pgp.net
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/31/2012 07:59 PM, Grant Likely wrote:
>> Pin direction currently needs to be set up separately, analogous to
>> requesting gpios. Need to document this better, right. The assumption is
>> that I/O needs to be efficient primarily, before bloating the API with
>> direction functions. Or should I add functions for this?
> 
> Since this is a userspace facing ABI, once it is merged it cannot be
> changed in an incompatible way. I cannot merge it until there is at
> least a plan for how to handle all of the reasonable use cases. That
> means it must support set/clear or mask operations. Also, if it sticks
> with the design of grouping pins from multiple controllers, then it
> needs to handle explicitly constraining what order operations are
> performed in at the time of the operation. At the time of setup
> doesn't work since constraints between pins may not always be in the
> same order.
> 
> I really think you should consider implementing a command stream type
> of interface.

Yes, understand. What do you consider a good example of a command stream
type interface? Link or hint appreciated!

There was already mentioned the idea of a device node which can be
interfaced to via ioctl() for the various operations. Can it be a
"struct miscdevice" or do you require sth. more sophisticated?

Thanks in advance,

Roland
