Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755394Ab2CUHoE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 03:44:04 -0400
Received: from utopia.booyaka.com ([72.9.107.138]:50725 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752162Ab2CUHoC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 03:44:02 -0400
Date: Wed, 21 Mar 2012 01:44:01 -0600 (MDT)
From: Paul Walmsley <paul@pwsan.com>
To: Saravana Kannan <skannan@codeaurora.org>
cc: Nicolas Pitre <nicolas.pitre@linaro.org>,
        Sascha Hauer <s.hauer@pengutronix.de>, Arnd Bergmann <arnd@arndb.de>,
        linux-arm-kernel@lists.infradead.org,
        Amit Kucheria <amit.kucheria@linaro.org>, linaro-dev@lists.linaro.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Jeremy Kerr <jeremy.kerr@canonical.com>,
        Mike Turquette <mturquette@ti.com>,
        Mike Turquette <mturquette@linaro.org>,
        Magnus Damm <magnus.damm@gmail.com>,
        Deepak Saxena <dsaxena@linaro.org>, patches@linaro.org,
        Rob Herring <rob.herring@calxeda.com>,
        Russell King <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>,
        Richard Zhao <richard.zhao@linaro.org>,
        Shawn Guo <shawn.guo@freescale.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Stephen Boyd <sboyd@codeaurora.org>, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 1/3] Documentation: common clk API
In-Reply-To: <4F694A6A.4050706@codeaurora.org>
Message-ID: <alpine.DEB.2.00.1203210130520.30543@utopia.booyaka.com>
References: <1331878280-2758-1-git-send-email-mturquette@linaro.org> <CAP245DXV5oE+-y+PQCcSM016h-J+UgTi1efmdrcyeQge4k1Cfw@mail.gmail.com> <201203161218.05125.arnd.bergmann@linaro.org> <201203162057.58706.arnd@arndb.de> <alpine.DEB.2.00.1203161509470.4395@utopia.booyaka.com>
 <20120316234706.GJ3852@pengutronix.de> <alpine.DEB.2.00.1203201611330.22974@utopia.booyaka.com> <alpine.LFD.2.02.1203202233340.24151@xanadu.home> <4F694A6A.4050706@codeaurora.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Saravana,

On Tue, 20 Mar 2012, Saravana Kannan wrote:

> To add a few more thoughts, while I agree with Paul that there is room for
> improvement in the APIs, I think the difference in opinion comes when we ask
> the question:
> 
> "When we eventually refine the APIs in the future to be more expressive, do we
> think that the current APIs can or cannot be made as wrappers around the new
> more expressive APIs?"
> 
> Absolutes are almost never right, so I can't give an absolute answer. 
> But I'm strongly leaning towards "we can" as the answer to the question.  
> That combined with the reasons Nicholas mentioned is why I think the 
> APIs should not be marked as experimental in anyway.

The resistance to documenting that the clock interface is not 
well-defined, and that therefore it is likely to change, and that users 
should not expect it to be stable, is perplexing to me.

Certainly a Kconfig help text change seems trivial enough.  But even the 
resistance to CONFIG_EXPERIMENTAL has been quite surprising to me, given 
that every single defconfig in arch/arm/defconfig sets it:

$ find arch/arm/configs -type f  | wc -l
122
$ fgrep -r CONFIG_EXPERIMENTAL=y arch/arm/configs | wc -l
122
$

(that includes iMX, by the way...)

Certainly, neither Kconfig change is going to prevent us on OMAP from 
figuring out what else is needed to convert our platform to the common 
clock code.  And given the level of enthusiasm on the lists, I don't think 
it's going to prevent many of the other ARM platforms from experimenting 
with the conversion, either.

So it would be interesting to know more about why you (or anyone else) 
perceive that the Kconfig changes would be harmful.


- Paul
