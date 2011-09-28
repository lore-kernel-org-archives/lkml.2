Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752091Ab1I1GqZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 02:46:25 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:34221 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750900Ab1I1GqY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 02:46:24 -0400
Date: Wed, 28 Sep 2011 08:46:14 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Vinod Koul <vinod.koul@intel.com>, Dan Williams <dan.j.williams@intel.com>,
        linux-kernel@vger.kernel.org, kernel@pengutronix.de,
        linux-arm-kernel@lists.infradead.org, linux-kbuild@vger.kernel.org,
        Michal Marek <mmarek@suse.cz>
Subject: Re: [PATCH] dma/imx-sdma+imx-dma: explicitly #include
 <linux/module.h>
Message-ID: <20110928064614.GN20550@pengutronix.de>
References: <1317018379-8897-1-git-send-email-u.kleine-koenig@pengutronix.de>
 <4E824821.8040105@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4E824821.8040105@windriver.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Cc: += linux-kbuild@v.k.o + Michal Marek]

Hello,

On Tue, Sep 27, 2011 at 06:03:13PM -0400, Paul Gortmaker wrote:
> On 11-09-26 02:26 AM, Uwe Kleine-König wrote:
> > This is needed after commit
> > 
> > 	include: replace linux/module.h with "struct module" wherever possible
> > 
> > (currently 25215aa in next).
> > 
> > Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
> > Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> > ---
> > Hello,
> > 
> > maybe it's sensible for Paul to take that before his commit?
> 
> Thanks, I'll blend it into the commit adding module.h to the other
> drivers/dma files.  It seems the imx boards don't have a defconfig
> in the arch/arm/configs that enables this (CONFIG_IMX_[S]DMA).
> 
> What is really interesting (at least to me anyway) is that I
> didn't get one iMX build in some 6000+ ARM randconfig builds....
> 
> I would have thought it would have showed up at least a couple
> times, given that number of builds.  Maybe randconfig doesn't
> deal so well with "choice" Kconfig items?
> 
> ~/git/module.h/linux-2.6.git$ ls -1 ../build-10*arm |wc -l
> 6399
> ~/git/module.h/linux-2.6.git$ grep CONFIG_ARCH_[A-Z0-9]*=y ../build-10*arm*/.config | sed 's/.*CON/CON/'|sort |uniq
> CONFIG_ARCH_EBSA110=y
> CONFIG_ARCH_H7201=y
> CONFIG_ARCH_H7202=y
> CONFIG_ARCH_H720X=y
> CONFIG_ARCH_VERSATILE=y

I don't understand why you did that sed, but AFAICT it doesn't hurt,
too. Maybe adding -c to uniq in your command line is interesting for the
kbuild people?!

> ~/git/module.h/linux-2.6.git$ 
> 
> No ARCH_MXC, no ARCH_MXS, PXA, or any of the other 20+ variants.
> Definitely not a random spread there, with all 6000 builds falling
> in just 5 buckets.
How did you test? Generate a .config, test without your change and if
that succeeds test with it? If so, maybe the problem isn't that
randconfig doesn't generate more random configs but that you got many
failures in the first run?!

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
