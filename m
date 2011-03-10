Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751977Ab1CJPxo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 10:53:44 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:60635 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751681Ab1CJPxn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 10:53:43 -0500
Date: Thu, 10 Mar 2011 15:53:41 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Linus Walleij <linus.walleij@stericsson.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>, linux-kernel@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>,
        Bengt Jonsson <bengt.g.jonsson@stericsson.com>
Subject: Re: [PATCH 2/4] regulator: add ab8500 per-regulator startup delay
Message-ID: <20110310155341.GA27206@opensource.wolfsonmicro.com>
References: <1299764621-2532-1-git-send-email-linus.walleij@stericsson.com>
 <20110310134953.GE22195@opensource.wolfsonmicro.com>
 <AANLkTim5Qw_PQJ234YsNvvmsg7L-RGfTsuMaTHvUmLHK@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTim5Qw_PQJ234YsNvvmsg7L-RGfTsuMaTHvUmLHK@mail.gmail.com>
X-Cookie: Your step will soil many countries.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 10, 2011 at 04:43:50PM +0100, Linus Walleij wrote:
> On Thu, Mar 10, 2011 at 2:49 PM, Mark Brown

> > You should be implementing the enable_time() operation for the regulator
> > for this.

> I looked into it, but the core implicitly only does delays after
> enable(), and our delays affect disable() and set_voltage()

You should add the appropriate generic operations, then.  This is hardly
unique to your hardware and having the information exposed in the driver
ops will allow the core to do helpfult hings with bulk operations.

> as well. disable() may look superfluous but I bet there may be
> cases where not having a voltage fully disabled before doing
> something will cause immesurable harm.

Given how heavily dependant collapsing the voltage is on the external
circuitry I'm not sure the driver can say too much useful here.  Usually
you're either going to collapse very quickly due to active discharge and
load or you're heavily dependant on the board.

> I was thinking about extending the present mechanism in
> core by refactoring the signature of the enable_time()
> as such:

Just add separate operations for each query - set_voltage() needs more
information to tell you a number anyway as it'll need to know the target
it's going to be asked about.
