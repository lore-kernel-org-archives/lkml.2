Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753104Ab1JCJP1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 05:15:27 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:60256 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751936Ab1JCJPU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 05:15:20 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: Tony Lindgren <tony@atomide.com>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 28/30] ARM: omap: select CPU_FREQ_TABLE where needed
Date: Mon, 03 Oct 2011 11:15:17 +0200
Message-ID: <5173921.eT2vCfT35d@wuerfel>
User-Agent: KMail/4.7.1 (Linux/3.1.0-rc8nosema+; KDE/4.7.1; x86_64; ; )
In-Reply-To: <4E894A95.5030107@ti.com>
References: <1317566760-25681-1-git-send-email-arnd@arndb.de> <1317566760-25681-29-git-send-email-arnd@arndb.de> <4E894A95.5030107@ti.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:YnnzwSoRQ8T3wkNu/ve9jMGv0qk2HHMzV8vK6AAQzNB
 mffiYdHhOTJSRVZPo3Mvb/g+zo68i9vwYSNYInEpuOPm4W4kww
 d6pN+BD+Tfy23LbG6mMt4pol/Px2camacSvXeTCOmDrlL+ZRx0
 gVmCfFZnnPzlSz9U3tL5p9GbTBWmZsEDXLB+FzwbyhREnrqUuH
 DJxk0wIbw2HdoAwwlgL3lDL3SRyJD2U4Vcaw2PK4EcFLjHXkEH
 99oVFbIm7jIs+jwdFDcoKmOoaOVOam7+B5uKbrYc1xjpArrFT0
 1wb4R/HEJQw419RTWB0bTsJTfvhGpGLruzPhCu/uX47v5s/WAQ
 5dTUnNlSo4x7ZJbYXCKs=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 03 October 2011 11:09:33 Santosh Shilimkar wrote:
> > diff --git a/arch/arm/plat-omap/Kconfig b/arch/arm/plat-omap/Kconfig
> > index bb8f4a6..f7ef9f4 100644
> > --- a/arch/arm/plat-omap/Kconfig
> > +++ b/arch/arm/plat-omap/Kconfig
> > @@ -217,6 +217,11 @@ config OMAP_PM_NOOP
> >  
> >  endchoice
> >  
> > +config OMAP_CPU_FREQ
> > +     def_bool "y"
> > +     depends on CPU_FREQ
> > +     select CPU_FREQ_TABLE
> > +
> >  endmenu
> With CPUFREQ series from Kevin [1], I don't think we need this any-more.

I guess if it's needed, it should at least be moved to the new cpufreq
location.

> More so, I didn't find OMAP_CPU_FREQ is being used anywhere on mainline.

Yes, OMAP_CPU_FREQ is a symbol that is intentionally unused, with the
only purpose of selecting CPU_FREQ_TABLE if any omap platform together
with CPU_FREQ is enabled.

Let's drop this patch for now, if it is still needed as I think, I can
do a patch during the 3.2 cycle for the right location.

	Arnd
