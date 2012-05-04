Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759407Ab2EDS4a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 14:56:30 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:64562 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753647Ab2EDS4Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 14:56:25 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Rob Herring <robherring2@gmail.com>
Subject: Re: Making ARM multiplatform kernels DT-only?
Date: Fri, 4 May 2012 18:56:08 +0000
User-Agent: KMail/1.12.2 (Linux/3.4.0-rc3; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, Kukjin Kim <kgene.kim@samsung.com>,
        linaro-dev@lists.linaro.org, Jason Cooper <jason@lakedaemon.net>,
        Nicolas Pitre <nico@fluxnic.net>, Tony Lindgren <tony@atomide.com>,
        Magnus Damm <magnus.damm@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Nicolas Ferre <nicolas.ferre@atmel.com>, linux-kernel@vger.kernel.org,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Deepak Saxena <dsaxena@linaro.org>, Olof Johansson <olof@lixom.net>,
        "Russell King - ARM Linux" <linux@arm.linux.org.uk>,
        David Brown <davidb@codeaurora.org>, shawn.guo@linaro.org,
        "Jean-Christophe PLAGNIOL-VILLARD" <plagnioj@jcrosoft.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Marc Zyngier <marc.zyngier@arm.com>
References: <201205031350.35476.arnd@arndb.de> <201205041220.24747.arnd@arndb.de> <4FA40642.5040203@gmail.com>
In-Reply-To: <4FA40642.5040203@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201205041856.08413.arnd@arndb.de>
X-Provags-ID: V02:K0:pz951JWF4LmP5qASozZVWOnqaxBeMcbB55tHGyTK6lE
 wy4VqziMQP/vBtwUC9NvaYYu8rC+XM7YmNJE9bWYTM+j77UBhj
 bCxvQD5KRLo0y/HtIy6/+19Ox4yj013Sa0Fefiy6wDP7+Vsejt
 jypsCGOizZssm+FrniEHfMH8Qj1qmz2P8ps5Kbdn0VnShjYFV+
 FnHw1d7FNuRTaThh8ddZaiqgcj7YLf5+Ed2Rlp3AvD4G5wZTW/
 C2oV5XBGp4tDUVCuKU1Zmr3rvD48LPrcCkIV9jxHo6hppP04Jn
 dd6GZ776qNixy/Z2ktCJyK4nSYnjmIPJIJDGrJyO6WRWne6j6a
 AbZvyZ2FoeJe88zMTRSc=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 04 May 2012, Rob Herring wrote:
> On 05/04/2012 07:20 AM, Arnd Bergmann wrote:
> > On Thursday 03 May 2012, Russell King - ARM Linux wrote:

> > My plan is to have multiplatform kernels in parallel with what we have now,
> > so we can avoid breaking working machines but also play with multiplatform
> > configurations at the same time for a subset of the platforms and with
> > certain restrictions (not all board files, not all drivers, no generic
> > early printk, ...).
> > 
> 
> Many of the headers are simply platform_data structs which may still be
> needed on DT platforms, but could be moved elsewhere

Yes, as Russell pointed out, these really should go to
include/linux/platform_data/. My patchset take a few shortcuts there right
now, adding an ugly hack to redirect the header files from their current
locations so I can avoid all the hard work to do that.

> > 
> >> We still have irqs.h being SoC dependent, and we still haven't taken
> >> debug-macros.S far enough along to get rid of that.
> > 
> > I believe the irqs.h conflict is only for the NR_IRQS constant, all other
> > defines in there should only be used inside of the mach-* directory,
> > or not at all for fully DT-based platforms.
> 
> A DT-enabled platform does not need irqs.h or NR_IRQS. SPARSE_IRQ should
> be selected for DT. However, some DT enabled platforms don't have all
> irq chips converted to domains and may still need to set the mach .nr_irqs.

Ah, good to know. I hadn't realized that the #include <mach/irqs.h> in asm/irq.h
is already conditional.

	Arnd
