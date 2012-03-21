Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755760Ab2CUHaX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 03:30:23 -0400
Received: from utopia.booyaka.com ([72.9.107.138]:38568 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755467Ab2CUHaP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 03:30:15 -0400
Date: Wed, 21 Mar 2012 01:30:13 -0600 (MDT)
From: Paul Walmsley <paul@pwsan.com>
To: Nicolas Pitre <nicolas.pitre@linaro.org>
cc: Sascha Hauer <s.hauer@pengutronix.de>, Arnd Bergmann <arnd@arndb.de>,
        linux-arm-kernel@lists.infradead.org,
        Amit Kucheria <amit.kucheria@linaro.org>, linaro-dev@lists.linaro.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Saravana Kannan <skannan@codeaurora.org>,
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
In-Reply-To: <alpine.LFD.2.02.1203202233340.24151@xanadu.home>
Message-ID: <alpine.DEB.2.00.1203210018260.30543@utopia.booyaka.com>
References: <1331878280-2758-1-git-send-email-mturquette@linaro.org> <CAP245DXV5oE+-y+PQCcSM016h-J+UgTi1efmdrcyeQge4k1Cfw@mail.gmail.com> <201203161218.05125.arnd.bergmann@linaro.org> <201203162057.58706.arnd@arndb.de> <alpine.DEB.2.00.1203161509470.4395@utopia.booyaka.com>
 <20120316234706.GJ3852@pengutronix.de> <alpine.DEB.2.00.1203201611330.22974@utopia.booyaka.com> <alpine.LFD.2.02.1203202233340.24151@xanadu.home>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Nico,

On Tue, 20 Mar 2012, Nicolas Pitre wrote:

> This common clk API has been under development for over *two* years 
> already, with several attempts to merge it.  And each previous merge 
> attempt aborted because someone came along at the last minute to do 
> exactly what you are doing i.e. underline all the flaws and call for a 
> redesign.  This is becoming a bad joke.

There is a misunderstanding.  I am not calling for a redesign.  I am 
simply stating that the current maturity level of the API and code should 
be documented in the Kconfig dependencies or description text before the 
code goes upstream.  The objectives are to make future changes easier, set 
expectations, and clearly disclose the extent to which the API and code 
will need to change.

> The code will be easier to change once it is in mainline, simply due to 
> the fact that you can also change all its users at once.  And it is well 
> possible that most users won't have to deal with the same magnitude of 
> complexity as yours, again reducing the scope for resistance to changes.

I hope you are right.  To me, these conclusions seem unlikely.  It seems 
equally likely that these rationales will make it much more difficult to 
change the code once it's upstream and platforms are depending on it.  
Particularly given the ongoing sensitivity to reducing "churn" of mainline 
code, so publicly discussed.  So it seems like a good idea to attempt to 
address these potential roadblocks and criticisms to major clock framework 
changes early.

> And APIs in the Linux kernel do change all the time.  There is no stable 
> API in the kernel.  Extensions will come about eventually, and existing 
> users (simple ones by definition if the current API already meets their 
> needs) should be converted over easily.

Yes, simple extensions should be straightforward.  Of greater concern are 
changes to the existing interface that will probably be required.  These 
could involve significant changes to driver or platform code.  It seems 
likely that there will be strong inertia to making these changes after 
platforms and drivers are converted.

However, if we clearly state that these API changes are likely until the 
API is well-defined, we will hopefully reduce some angst by disclosing
what some of us know.

...

One last comment to address which is orthogonal to the technical content 
of this discussion.

> Otherwise one might ask where were you during those development years if 
> you claim that the behavior and/or API of the common clock code still 
> need to change significantly?

One might ask this.  If one were to ask this, another might briefly 
outline the participation in public and private clock discussions at 
Linaro Connect in Budapest and Redwood Shores, at LPC in Santa Rosa, at 
ELCE/KS in Prague, at ELC in Redwood Shores, in conference calls, IRC 
sessions, and private E-mails with many of the people included in the 
header of this message, not to mention the list posts.

None of the concerns that have been described are new.  There has been an 
endeavour to discuss them with anyone who seemed even remotely interested.

Of course it is a personal source of regret that the participation could 
not have been greater, but this regret is hardly limited to the common 
clock project.


regards,

- Paul

