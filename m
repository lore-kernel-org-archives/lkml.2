Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753320Ab1LBT1J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 14:27:09 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:58021 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751704Ab1LBT1I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 14:27:08 -0500
Date: Fri, 2 Dec 2011 14:27:04 -0500 (EST)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: =?ISO-8859-15?Q?Uwe_Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
cc: Paul Gortmaker <paul.gortmaker@windriver.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, Arnd Bergmann <arnd@arndb.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] arm: add default value for PHYS_OFFSET Kconfig setting
In-Reply-To: <20111202190716.GA4585@pengutronix.de>
Message-ID: <alpine.LFD.2.02.1112021426420.2357@xanadu.home>
References: <1322711557-8279-1-git-send-email-paul.gortmaker@windriver.com> <201112011419.46751.arnd@arndb.de> <CAP=VYLrp1zqyOzU-xzatF3jE3wL6wBjEDMR=sEXimP2ZvkQ0Lg@mail.gmail.com> <alpine.LFD.2.02.1112020005270.2357@xanadu.home> <alpine.LFD.2.02.1112020024370.2357@xanadu.home>
 <20111202092124.GR26618@pengutronix.de> <4ED8FD76.3000802@windriver.com> <20111202190716.GA4585@pengutronix.de>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-858183275-1322854026=:2357"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-858183275-1322854026=:2357
Content-Type: TEXT/PLAIN; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT

On Fri, 2 Dec 2011, Uwe Kleine-König wrote:

> Hello,
> 
> On Fri, Dec 02, 2011 at 11:31:50AM -0500, Paul Gortmaker wrote:
> > On 11-12-02 04:21 AM, Uwe Kleine-König wrote:
> > > Hello Nicolas,
> > > 
> > > On Fri, Dec 02, 2011 at 12:33:26AM -0500, Nicolas Pitre wrote:
> > 
> > [...]
> > 
> > >> And it seems that at91x40 is the only defconfig with MMU=n, so the only 
> > >> option is really to provide a default CONFIG_PHYS_OFFSET.  So what about 
> > >> this:
> > >>
> > >> diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
> > >> index e084b7e981..a24672924f 100644
> > >> --- a/arch/arm/Kconfig
> > >> +++ b/arch/arm/Kconfig
> > >> @@ -222,6 +222,7 @@ config NEED_MACH_MEMORY_H
> > >>  config PHYS_OFFSET
> > >>  	hex "Physical address of main memory"
> > >>  	depends on !ARM_PATCH_PHYS_VIRT && !NEED_MACH_MEMORY_H
> > >> +	default DRAM_BASE if !MMU
> > >>  	help
> > >>  	  Please provide the physical address corresponding to the
> > >>  	  location of main memory in your system.
> > >>
> > >> Eventually the DRAM_BASE config option could simply be replaced by 
> > >> PHYS_OFFSET directly, but that's a larger change.
> > > I'm working on a MMU-less machine, too and had that change already in my
> > > working copy. I was about to commit and it send out later today.
> > > 
> > > So: Acked-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> > 
> > Looks fine to me as well; I had no particular attachment to the
> > original patch, and you guys have a much better understanding of
> > the specifics of the system.
> A post-ack comment: would it make sense to make this:
> 
> 	config PHYS_OFFSET
> 		hex "Physical address of main memory" if MMU
> 	...
> 
> such that !MMU build don't get a chance to misconfigure it?

Sure.


Nicolas
--8323328-858183275-1322854026=:2357--
