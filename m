Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933195Ab2DKURt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 16:17:49 -0400
Received: from na3sys009aog110.obsmtp.com ([74.125.149.203]:47445 "EHLO
	na3sys009aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933181Ab2DKURq convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 16:17:46 -0400
MIME-Version: 1.0
In-Reply-To: <4F85E238.9050102@codeaurora.org>
References: <CAJOA=zN2cSSpM92oRnW0RyU_ZzyoQ=jthc-fAkf-P3z37uWt7w@mail.gmail.com>
 <1332214706-675-1-git-send-email-skannan@codeaurora.org> <1332214706-675-2-git-send-email-skannan@codeaurora.org>
 <20120320072018.GC32469@S2101-09.ap.freescale.net> <cbd6490459b9fd68875fec4a7c7de073.squirrel@www.codeaurora.org>
 <20120320094031.GI3852@pengutronix.de> <20120320141811.GF32469@S2101-09.ap.freescale.net>
 <20120320181050.GN3852@pengutronix.de> <4F68E34A.70207@codeaurora.org>
 <20120320231242.GP3852@pengutronix.de> <CAJOA=zOGTW7OqACWgJQW6HSPLVev+apdNhv4vNXjHTcp=7N+uQ@mail.gmail.com>
 <4F694484.1030706@codeaurora.org> <4F714397.6080608@codeaurora.org>
 <CAJOA=zOq=kYfZUEnnQT_D4w=Kpp5n7R=k9oOCrxF59P5W-nw-w@mail.gmail.com>
 <4F7E4752.4020007@codeaurora.org> <CAJOA=zMEN_im3-T+_uXB_mTu842o_fRkr9-7h=X18fKBoH46aQ@mail.gmail.com>
 <4F85E238.9050102@codeaurora.org>
From: "Turquette, Mike" <mturquette@ti.com>
Date: Wed, 11 Apr 2012 13:17:20 -0700
Message-ID: <CAJOA=zOKE7hyvvjB3HLh_iAX8HGCbFQtUHijU3BM+0r+9-b72A@mail.gmail.com>
Subject: Re: [PATCH 2/2] clk: Move init fields from clk to clk_hw
To: Saravana Kannan <skannan@codeaurora.org>
Cc: Sascha Hauer <s.hauer@pengutronix.de>, Andrew Lunn <andrew@lunn.ch>,
        Grant Likely <grant.likely@secretlab.ca>,
        Jamie Iles <jamie@jamieiles.com>,
        Jeremy Kerr <jeremy.kerr@canonical.com>,
        Magnus Damm <magnus.damm@gmail.com>,
        Deepak Saxena <dsaxena@linaro.org>,
        linux-arm-kernel@lists.infradead.org,
        Arnd Bergman <arnd.bergmann@linaro.org>, linux-arm-msm@vger.kernel.org,
        Rob Herring <rob.herring@calxeda.com>,
        Russell King <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>,
        Richard Zhao <richard.zhao@linaro.org>,
        Shawn Guo <shawn.guo@freescale.com>, Paul Walmsley <paul@pwsan.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Stephen Boyd <sboyd@codeaurora.org>, linux-kernel@vger.kernel.org,
        Amit Kucheria <amit.kucheria@linaro.org>,
        Shawn Guo <shawn.guo@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 11, 2012 at 12:57 PM, Saravana Kannan
<skannan@codeaurora.org> wrote:
> On 04/11/2012 10:59 AM, Turquette, Mike wrote:
>> On Thu, Apr 5, 2012 at 6:30 PM, Saravana Kannan<skannan@codeaurora.org>
>> My only concern with this series is that platform clock code will
>> access struct clk_hw members without the appropriate lock held (namely
>> prepare_lock).  I'm a bit worried that there might be a case where
>> some clock code access clk_hw->name when clk_hw has somehow been
>> destroyed/altered (e.g. if clk_put every finally gets implemented...).
>>  Besides clk_put are there any real instances where this might happen?
>
> This problem is true for any struct/field marked as __init_data. So, I don't
> think this is a real problem. If someone is stupid enough to mark their data
> as __init_data and access them later, then there is not much we can do.
> Also, I believe the compiler throws out some warning when you try to access
> __init_data from non-init code.

I'm referring to platform clock code accessing clk_hw->name or
clk_hw->parent_names AFTER the core code has copied the initialization
data.  So this isn't an __initdata problem as much as it is a design
issue with exposing some members of struct clk_hw.  I think that this
is basically OK since the benefits of not having to use so many
helpers functions in platform clock code is obvious and if a platform
gets bitten by this then they will learn the hard way to honor the
locking semantics outlined in Documentation/clk.txt

>> I'll be pushing my fixes branch out to the list soon.  Do you want to
>> rebase this change on top of it taking into account the __initdata
>> bits?
>
> I thought it might be easier for you to base your changes on top of my
> patch. But I can try to rebase mine on top of your changes. Hopefully your
> fixes aren't crazy big/complex.

I don't think the fixes are a big deal, especially in the core code.

> This is a busy week for me at work. I will try to send a patch in a day or
> two.

OK.  I might take a swing at it myself if I have time.

Regards,
Mike
