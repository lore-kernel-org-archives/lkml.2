Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753358Ab0IIM6W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 08:58:22 -0400
Received: from smtp.nokia.com ([192.100.105.134]:47766 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752194Ab0IIM6V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 08:58:21 -0400
Message-ID: <4C88D97F.2080804@nokia.com>
Date: Thu, 09 Sep 2010 15:56:31 +0300
From: Adrian Hunter <adrian.hunter@nokia.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100411)
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Linus Walleij <linus.walleij@stericsson.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Liam Girdwood <lrg@slimlogic.co.uk>, Tony Lindgren <tony@atomide.com>,
        Robert Jarzmik <robert.jarzmik@free.fr>,
        Sundar Iyer <sundar.iyer@stericsson.com>,
        Daniel Mack <daniel@caiaq.de>, Pierre Ossman <pierre@ossman.eu>,
        Matt Fleming <matt@console-pimps.org>,
        David Brownell <dbrownell@users.sourceforge.net>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Eric Miao <eric.y.miao@gmail.com>,
        Cliff Brake <cbrake@bec-systems.com>,
        "Lavinen Jarkko (Nokia-MS/Helsinki)" <jarkko.lavinen@nokia.com>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] MMC: move regulator handling closer to core v3
References: <1283677538-31121-1-git-send-email-linus.walleij@stericsson.com> <20100908155114.880463fc.akpm@linux-foundation.org> <4C887837.6060508@nokia.com> <20100909093810.GA1988@rakim.wolfsonmicro.main>
In-Reply-To: <20100909093810.GA1988@rakim.wolfsonmicro.main>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 09 Sep 2010 12:56:32.0288 (UTC) FILETIME=[6D483200:01CB501E]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Brown wrote:
> On Thu, Sep 09, 2010 at 09:01:27AM +0300, Adrian Hunter wrote:
> 
>> As an aside, I would like to enhance the regulator framework to
>> enable boards to hook their code directly into the regulator.
> 
> What do you mean when you say that you would like boards to "hook
> directly into the regulator" - what do you want to be able to do?
> Is this the notifiers?  Do you need more of them?

There would need to be notifiers before and after any change to the
voltage.  However the notifiers would have to be set up before or
during regulator initialisation because initialisation already can
change the voltage e.g. in set_machine_constraints.

> 
>> Arguably this is essential to allow pbias configuration (without
>> which the board may be damaged) so that regulator_enable/disable
>> can be used independently of the board, or for example to allow
> 
> I can't parse this at all I'm afraid.  Could you be more specific about
> what you mean by using enable and disable independantly of the board -
> clearly the consumer drivers are already able to be board independant?

For OMAP3 (and OMAP2 in some cases) the 1st SD/SDIO/MMC controller
can operate at either 1.8V or 3V, however at 3V the board must apply
voltage level shifting (PBIAS configuation).  Currently the
level-shifting is done by board code that must be called before and
after the voltage changes.  The omap_hsmmc driver calls the board
code via callbacks in platform data (.before_set_reg and
.after_set_reg).

> 
>> the regulator core to turn the regulator on/off at initialisation.
> 
> The regulator core already supports enabling or disabling regulators
> from the machine constraints which I *think* is what you're looking for
> but since I can't follow what you're saying above I'm not sure.

Yes that is what I would like, but it won't work at present because
the core does not do the PBIAS configuration.

> --
> To unsubscribe from this list: send the line "unsubscribe linux-mmc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

