Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755425Ab2ENI5X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 04:57:23 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:63395 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754863Ab2ENI5V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 04:57:21 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Sascha Hauer <s.hauer@pengutronix.de>
Subject: Re: Making ARM multiplatform kernels DT-only?
Date: Mon, 14 May 2012 08:54:18 +0000
User-Agent: KMail/1.12.2 (Linux/3.4.0-rc3; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, Kukjin Kim <kgene.kim@samsung.com>,
        linaro-dev@lists.linaro.org, Jason Cooper <jason@lakedaemon.net>,
        Nicolas Pitre <nico@fluxnic.net>, Tony Lindgren <tony@atomide.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Magnus Damm <magnus.damm@gmail.com>, linux-kernel@vger.kernel.org,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Deepak Saxena <dsaxena@linaro.org>, Olof Johansson <olof@lixom.net>,
        "Russell King - ARM Linux" <linux@arm.linux.org.uk>,
        David Brown <davidb@codeaurora.org>, shawn.guo@linaro.org,
        "Jean-Christophe PLAGNIOL-VILLARD" <plagnioj@jcrosoft.com>
References: <201205031350.35476.arnd@arndb.de> <20120505080936.GP4141@pengutronix.de> <201205051317.40357.arnd@arndb.de>
In-Reply-To: <201205051317.40357.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201205140854.18335.arnd@arndb.de>
X-Provags-ID: V02:K0:BPhaqZGr8olHTVIUCQvFYqeisU/1G5Ge4IfBMz6q7Ix
 ofHUps8uiXbu3qLgtt6w9XL1Be+FucWg1O+jqCbkiTjHqTC7fu
 9iUhYNarlUq8yw8NmLA3HZsX0NnPl3SAAbsQzzpPYh9JL5i3JQ
 AWUDxoFL/8UcHCDf56HemQAGBXGebbJz/mioEfMGgXtGxLYHDn
 FE6U2LP6Br00yQAy0iR/pSWaWVxqINrSwrq+O3oB6CTRDSP/pY
 sseHLrfgrgLAHRPDlqijjxI7i/Ddwmx7P8KboJhmKdBXCLXxXk
 XA91yuDiMj1UA2Tkcv8aEbX5RQcQuvftnvGJ8AffVPtgeBiICA
 DJL43IRaD1g4yISNMeYo=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 05 May 2012, Arnd Bergmann wrote:

> From the statements made so far, I can see no clear policy that we can
> apply to everyone. My take on this is that for any work I spend on
> multiplatform kernel, I concentrate on the DT-based board files and
> get them to work together first, but leave it up to the individual
> subarch maintainers whether they want to add other board files into
> the mix.

A small update that I already posted as a comment in the lwn article
covering this discussion:

| Over the last week, I've actually tried out building kernels for
| multiple platforms combined to get a better feeling for the remaining
| problems. The result is in the testing/multiplatform branch of
| git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git and it
| can build arbitrary combinations of four of the five subarchitectures
| that the Linaro organization is most interested in (imx, omap, ux500 and
| vexpress, but not exynos for now). Most other platforms should actually
| be simpler to convert.
| 
| However, this kernel is not yet going to be useful on real hardware
| because I had to disable or add hacks for a number of features (SMP,
| sparseirq, clocks) that are still being worked on, but as soon as one
| oatform has all that work done, we can actually build a kernel with
| everything enabled and run on that particular platform and see what
| else breaks.
|
| Unlike I suggested earlier, this kernel at the moment actually allows
| enabling all the board files including non-DT ones because that was
| easier to do with the Kconfig dependencies, but I found two real technical
| issues that would be solved by making the combined kernel DT-only:
|
| 1. The exynos platform defines static platform devices from files
| shared with five other Samsung platforms that are mutually exclusive
| because the device definitions depend on platform specific compile-time
| constants. Using DT probing we can just drop those static platform device
| definitions and make the conflict go away.
|
| 2. With sparse IRQs, a lot of the hardcoded interrupt numbers in static
| platform device definitions are broken, while the definitions from DT
| still work. Sparse IRQs are currently needed to build multiplatform
| kernels and I expect that requirement to stay.

	Arnd
