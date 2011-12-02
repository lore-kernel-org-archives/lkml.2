Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752212Ab1LBTHm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 14:07:42 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:56390 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751346Ab1LBTHl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 14:07:41 -0500
Date: Fri, 2 Dec 2011 20:07:16 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Nicolas Pitre <nicolas.pitre@linaro.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, Arnd Bergmann <arnd@arndb.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] arm: add default value for PHYS_OFFSET Kconfig setting
Message-ID: <20111202190716.GA4585@pengutronix.de>
References: <1322711557-8279-1-git-send-email-paul.gortmaker@windriver.com>
 <201112011419.46751.arnd@arndb.de>
 <CAP=VYLrp1zqyOzU-xzatF3jE3wL6wBjEDMR=sEXimP2ZvkQ0Lg@mail.gmail.com>
 <alpine.LFD.2.02.1112020005270.2357@xanadu.home>
 <alpine.LFD.2.02.1112020024370.2357@xanadu.home>
 <20111202092124.GR26618@pengutronix.de>
 <4ED8FD76.3000802@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4ED8FD76.3000802@windriver.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Fri, Dec 02, 2011 at 11:31:50AM -0500, Paul Gortmaker wrote:
> On 11-12-02 04:21 AM, Uwe Kleine-König wrote:
> > Hello Nicolas,
> > 
> > On Fri, Dec 02, 2011 at 12:33:26AM -0500, Nicolas Pitre wrote:
> 
> [...]
> 
> >> And it seems that at91x40 is the only defconfig with MMU=n, so the only 
> >> option is really to provide a default CONFIG_PHYS_OFFSET.  So what about 
> >> this:
> >>
> >> diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
> >> index e084b7e981..a24672924f 100644
> >> --- a/arch/arm/Kconfig
> >> +++ b/arch/arm/Kconfig
> >> @@ -222,6 +222,7 @@ config NEED_MACH_MEMORY_H
> >>  config PHYS_OFFSET
> >>  	hex "Physical address of main memory"
> >>  	depends on !ARM_PATCH_PHYS_VIRT && !NEED_MACH_MEMORY_H
> >> +	default DRAM_BASE if !MMU
> >>  	help
> >>  	  Please provide the physical address corresponding to the
> >>  	  location of main memory in your system.
> >>
> >> Eventually the DRAM_BASE config option could simply be replaced by 
> >> PHYS_OFFSET directly, but that's a larger change.
> > I'm working on a MMU-less machine, too and had that change already in my
> > working copy. I was about to commit and it send out later today.
> > 
> > So: Acked-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> 
> Looks fine to me as well; I had no particular attachment to the
> original patch, and you guys have a much better understanding of
> the specifics of the system.
A post-ack comment: would it make sense to make this:

	config PHYS_OFFSET
		hex "Physical address of main memory" if MMU
	...

such that !MMU build don't get a chance to misconfigure it?

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
