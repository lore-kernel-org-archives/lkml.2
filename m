Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755338Ab2HUPMe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 11:12:34 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:53726 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754271Ab2HUPMI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 11:12:08 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: [RFC 0/4] ARM: multiplatform: rename all mach headers
Date: Tue, 21 Aug 2012 17:11:16 +0200
Message-Id: <1345561880-13231-1-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.10
X-Provags-ID: V02:K0:IUer2lUGfeLy8ehATxsAHd8bwLYJ78/AznL7FYnp+d6
 NbiZTHlvr/Ivb3w3kwB5SXREFbbyz7hJgfOh+6Co4x6s0d9h3p
 f/T7FjUmEN0iniOEiPXYKRLf6uLlKLFIBX6PCwgAhtNPjJQTh6
 tfo/Llg6SNqeNnR06RnutMxvDT/WYBDjr3qXugEO8sw4j0bc1A
 KJ33Rel6hLLU45FiV+Wk48ML3Msdi8iWwtEdNcTlJs0ekBDAoH
 jFAlvwqepUoYUImlhV912hzRvuiCM3FToO66g0oeFHHoC5LiW8
 gXVulBGBA8RJ4mB77kySMJgBykqQ+jIX5W1j+1XZbimrtiXBCB
 8j0YgY/1QdXzylJlnjb3VqTfc875LiGyZC6tG3LQltj/DpLV+n
 HKwEqa61xeRaw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've created this series some time ago, and updated it now to
v3.6-rc1. The idea is to get us a big step closer to the
single zImage kernel across multiple ARM platforms by
untangling the duplicate header file names.

There are two branches available in the arm-soc tree:

1. This series,
   http://git.kernel.org/?p=linux/kernel/git/arm/arm-soc.git;a=shortlog;h=refs/heads/testing/mach-headers
   This just moves header files around and changes most of the
   files including them. There are a few remaining drivers
   and platform files that keep including a generic file name
   like <mach/uncompress.h>. It remains possible to do that,
   and I've run extensive tests to ensure I did not break
   anything with this. However, each of these instances means
   that there is something that stops working when you get to
   the real multiplatform kernel and we still need to deal
   with them one by one.

2. Actually enabling CONFIG_ARCH_MULTIPLATFORM
   http://git.kernel.org/?p=linux/kernel/git/arm/arm-soc.git;a=shortlog;h=refs/heads/testing/multiplatform
   This builds on top of the first series, but is much more
   experimental. It shows how a multiplatform kernel can look
   like, by allowing to build vexpress, ux500, imx and omap2
   together in one kernel, but at the same time breaking some of
   their features.

I would like to get the first series merged in v3.7 if we can agree
on the general approach. So far, feedback in Linaro internal
meetings has been very positive, but Russell had concerns when
we first discussed it a few months ago.

A patch set this large means a lot of churn, and there are a few
ways we could deal with this:

a) Put the branch into linux-next now, and have everyone who
encounters conflicts pull it into their own branch to resolve
the conflicts. This can be a lot of work, and it means we
cannot rebase this branch any more.

b) Involve Linus Torvalds in the process and get him to
take the series at the end of the v3.7 merge window, after
rebasing it on top of all the other branches he merged.
This means it happens pretty much ad-hoc and there is little
testing on the patches that actually get merged.

c) Split the series and submit the first two branches at
the start of the merge window, and do the changes to all
the drivers either at the end of the v3.7 merge window
(after rebasing) or merge them through the subsystem
maintainer trees in small chunks for v3.8. This can minimize
the problems of the other two approaches, but means the process
takes longer to get to the same result.

	Arnd

Arnd Bergmann (4):
  [RFC] ARM: autogenerate mach-foo/* and plat-foo/* header redirects
  [RFC] ARM: mass move of mach-*/plat-* header files
  [RFC] ARM: treewide: scripted conversion to mach-*/*.h
  [RFC] ARM: treewide: manually change more mach-*/*.h includes

 Documentation/spi/ep93xx_spi                       |    2 +-
 arch/arm/Makefile                                  |    1 +
 arch/arm/boot/compressed/head-shmobile.S           |    2 +-
 arch/arm/boot/compressed/sdhi-shmobile.c           |    2 +-
 arch/arm/mach-at91/at91rm9200.c                    |   10 +-
 arch/arm/mach-at91/at91rm9200_devices.c            |    8 +-
 arch/arm/mach-at91/at91rm9200_time.c               |    2 +-
 arch/arm/mach-at91/at91sam9260.c                   |   12 +-
 arch/arm/mach-at91/at91sam9260_devices.c           |   14 +-
 arch/arm/mach-at91/at91sam9261.c                   |   10 +-
 arch/arm/mach-at91/at91sam9261_devices.c           |   10 +-
 arch/arm/mach-at91/at91sam9263.c                   |    8 +-
 arch/arm/mach-at91/at91sam9263_devices.c           |   10 +-
 arch/arm/mach-at91/at91sam926x_time.c              |    2 +-
 arch/arm/mach-at91/at91sam9_alt_reset.S            |    6 +-
 arch/arm/mach-at91/at91sam9g45.c                   |    8 +-
 arch/arm/mach-at91/at91sam9g45_devices.c           |   16 +-
 arch/arm/mach-at91/at91sam9g45_reset.S             |    6 +-
 arch/arm/mach-at91/at91sam9n12.c                   |    8 +-
 arch/arm/mach-at91/at91sam9rl.c                    |   12 +-
 arch/arm/mach-at91/at91sam9rl_devices.c            |   12 +-
 arch/arm/mach-at91/at91sam9x5.c                    |    8 +-
 arch/arm/mach-at91/at91x40.c                       |    8 +-
 arch/arm/mach-at91/at91x40_time.c                  |    4 +-
 arch/arm/mach-at91/board-1arm.c                    |    8 +-
 arch/arm/mach-at91/board-afeb-9260v1.c             |    6 +-
 arch/arm/mach-at91/board-cam60.c                   |    8 +-
 arch/arm/mach-at91/board-carmeva.c                 |    6 +-
 arch/arm/mach-at91/board-cpu9krea.c                |   12 +-
 arch/arm/mach-at91/board-cpuat91.c                 |   12 +-
 arch/arm/mach-at91/board-csb337.c                  |    6 +-
 arch/arm/mach-at91/board-csb637.c                  |    6 +-
 arch/arm/mach-at91/board-dt.c                      |    4 +-
 arch/arm/mach-at91/board-eb01.c                    |    6 +-
 arch/arm/mach-at91/board-eb9200.c                  |    6 +-
 arch/arm/mach-at91/board-ecbat91.c                 |    8 +-
 arch/arm/mach-at91/board-eco920.c                  |   10 +-
 arch/arm/mach-at91/board-flexibity.c               |    6 +-
 arch/arm/mach-at91/board-foxg20.c                  |    8 +-
 arch/arm/mach-at91/board-gsia18s.c                 |   10 +-
 arch/arm/mach-at91/board-kafa.c                    |    8 +-
 arch/arm/mach-at91/board-kb9202.c                  |   12 +-
 arch/arm/mach-at91/board-neocore926.c              |    8 +-
 arch/arm/mach-at91/board-pcontrol-g20.c            |    8 +-
 arch/arm/mach-at91/board-picotux200.c              |   10 +-
 arch/arm/mach-at91/board-qil-a9260.c               |   10 +-
 arch/arm/mach-at91/board-rm9200dk.c                |   10 +-
 arch/arm/mach-at91/board-rm9200ek.c                |   10 +-
 arch/arm/mach-at91/board-rsi-ews.c                 |    6 +-
 arch/arm/mach-at91/board-sam9-l9260.c              |    8 +-
 arch/arm/mach-at91/board-sam9260ek.c               |   12 +-
 arch/arm/mach-at91/board-sam9261ek.c               |   12 +-
 arch/arm/mach-at91/board-sam9263ek.c               |   12 +-
 arch/arm/mach-at91/board-sam9g20ek.c               |   10 +-
 arch/arm/mach-at91/board-sam9m10g45ek.c            |   12 +-
 arch/arm/mach-at91/board-sam9rlek.c                |   10 +-
 arch/arm/mach-at91/board-snapper9260.c             |    8 +-
 arch/arm/mach-at91/board-stamp9g20.c               |    6 +-
 arch/arm/mach-at91/board-usb-a926x.c               |   10 +-
 arch/arm/mach-at91/board-yl-9200.c                 |   12 +-
 arch/arm/mach-at91/clock.c                         |    6 +-
 arch/arm/mach-at91/cpuidle.c                       |    2 +-
 arch/arm/mach-at91/gpio.c                          |    4 +-
 .../include/{mach => mach-at91}/at91_adc.h         |    0
 .../include/{mach => mach-at91}/at91_aic.h         |    0
 .../include/{mach => mach-at91}/at91_dbgu.h        |    0
 .../include/{mach => mach-at91}/at91_matrix.h      |    0
 .../include/{mach => mach-at91}/at91_pio.h         |    0
 .../include/{mach => mach-at91}/at91_pit.h         |    0
 .../include/{mach => mach-at91}/at91_pmc.h         |    0
 arch/arm/mach-at91/include/mach-at91/at91_ramc.h   |   32 +
 .../include/{mach => mach-at91}/at91_rstc.h        |    0
 .../include/{mach => mach-at91}/at91_rtc.h         |    0
 .../include/{mach => mach-at91}/at91_rtt.h         |    0
 .../include/{mach => mach-at91}/at91_shdwc.h       |    0
 .../include/{mach => mach-at91}/at91_st.h          |    0
 .../include/{mach => mach-at91}/at91_tc.h          |    0
 .../include/{mach => mach-at91}/at91_twi.h         |    0
 .../include/{mach => mach-at91}/at91rm9200.h       |    0
 .../include/{mach => mach-at91}/at91rm9200_emac.h  |    0
 .../include/{mach => mach-at91}/at91rm9200_mc.h    |    0
 .../{mach => mach-at91}/at91rm9200_sdramc.h        |    0
 .../include/{mach => mach-at91}/at91sam9260.h      |    0
 .../{mach => mach-at91}/at91sam9260_matrix.h       |    0
 .../include/{mach => mach-at91}/at91sam9261.h      |    0
 .../{mach => mach-at91}/at91sam9261_matrix.h       |    0
 .../include/{mach => mach-at91}/at91sam9263.h      |    0
 .../{mach => mach-at91}/at91sam9263_matrix.h       |    0
 .../include/{mach => mach-at91}/at91sam9_ddrsdr.h  |    0
 .../include/{mach => mach-at91}/at91sam9_sdramc.h  |    0
 .../arm/mach-at91/include/mach-at91/at91sam9_smc.h |  100 ++
 .../include/{mach => mach-at91}/at91sam9g45.h      |    0
 .../{mach => mach-at91}/at91sam9g45_matrix.h       |    0
 .../include/{mach => mach-at91}/at91sam9n12.h      |    0
 .../{mach => mach-at91}/at91sam9n12_matrix.h       |    0
 .../include/{mach => mach-at91}/at91sam9rl.h       |    0
 .../{mach => mach-at91}/at91sam9rl_matrix.h        |    0
 .../include/{mach => mach-at91}/at91sam9x5.h       |    0
 .../{mach => mach-at91}/at91sam9x5_matrix.h        |    0
 .../include/{mach => mach-at91}/at91x40.h          |    0
 .../include/{mach => mach-at91}/at_hdmac.h         |    0
 arch/arm/mach-at91/include/mach-at91/atmel-mci.h   |   24 +
 .../mach-at91/include/{mach => mach-at91}/board.h  |    0
 .../mach-at91/include/{mach => mach-at91}/cpu.h    |    0
 arch/arm/mach-at91/include/mach-at91/debug-macro.S |   43 +
 .../mach-at91/include/{mach => mach-at91}/gpio.h   |    0
 .../include/{mach => mach-at91}/gsia18s.h          |    0
 arch/arm/mach-at91/include/mach-at91/hardware.h    |  110 ++
 .../arm/mach-at91/include/{mach => mach-at91}/io.h |    0
 arch/arm/mach-at91/include/mach-at91/memory.h      |   26 +
 .../include/{mach => mach-at91}/stamp9g20.h        |    0
 .../include/{mach => mach-at91}/system_rev.h       |    0
 arch/arm/mach-at91/include/mach-at91/timex.h       |   37 +
 arch/arm/mach-at91/include/mach-at91/uncompress.h  |  201 +++
 arch/arm/mach-at91/include/mach/at91_ramc.h        |   32 -
 arch/arm/mach-at91/include/mach/at91sam9_smc.h     |  100 --
 arch/arm/mach-at91/include/mach/atmel-mci.h        |   24 -
 arch/arm/mach-at91/include/mach/debug-macro.S      |   43 -
 arch/arm/mach-at91/include/mach/hardware.h         |  110 --
 arch/arm/mach-at91/include/mach/memory.h           |   26 -
 arch/arm/mach-at91/include/mach/timex.h            |   37 -
 arch/arm/mach-at91/include/mach/uncompress.h       |  201 ---
 arch/arm/mach-at91/irq.c                           |    4 +-
 arch/arm/mach-at91/leds.c                          |    2 +-
 arch/arm/mach-at91/pm.c                            |   10 +-
 arch/arm/mach-at91/pm.h                            |    4 +-
 arch/arm/mach-at91/pm_slowclock.S                  |    6 +-
 arch/arm/mach-at91/sam9_smc.c                      |    2 +-
 arch/arm/mach-at91/setup.c                         |   10 +-
 arch/arm/mach-bcmring/arch.c                       |   10 +-
 arch/arm/mach-bcmring/clock.c                      |    8 +-
 arch/arm/mach-bcmring/clock.h                      |    2 +-
 arch/arm/mach-bcmring/core.c                       |   10 +-
 arch/arm/mach-bcmring/csp/chipc/chipcHw.c          |    4 +-
 arch/arm/mach-bcmring/csp/chipc/chipcHw_init.c     |    4 +-
 arch/arm/mach-bcmring/csp/chipc/chipcHw_reset.c    |    4 +-
 arch/arm/mach-bcmring/csp/chipc/chipcHw_str.c      |    2 +-
 arch/arm/mach-bcmring/csp/dmac/dmacHw.c            |    6 +-
 arch/arm/mach-bcmring/csp/dmac/dmacHw_extra.c      |    4 +-
 arch/arm/mach-bcmring/csp/tmr/tmrHw.c              |    2 +-
 arch/arm/mach-bcmring/dma.c                        |    4 +-
 arch/arm/mach-bcmring/include/csp/dmacHw.h         |    2 +-
 arch/arm/mach-bcmring/include/csp/intcHw.h         |    2 +-
 arch/arm/mach-bcmring/include/csp/reg.h            |    2 +-
 .../include/{mach => mach-bcmring}/csp/cap.h       |    0
 .../include/mach-bcmring/csp/cap_inline.h          |  409 +++++
 .../include/mach-bcmring/csp/chipcHw_def.h         | 1123 +++++++++++++
 .../include/mach-bcmring/csp/chipcHw_inline.h      | 1673 ++++++++++++++++++++
 .../include/mach-bcmring/csp/chipcHw_reg.h         |  530 +++++++
 .../include/mach-bcmring/csp/ddrcReg.h             |  872 ++++++++++
 .../{mach => mach-bcmring}/csp/dmacHw_priv.h       |    0
 .../include/mach-bcmring/csp/dmacHw_reg.h          |  406 +++++
 .../mach-bcmring/include/mach-bcmring/csp/hw_cfg.h |   73 +
 .../include/mach-bcmring/csp/intcHw_reg.h          |  246 +++
 .../include/{mach => mach-bcmring}/csp/mm_addr.h   |    0
 .../mach-bcmring/include/mach-bcmring/csp/mm_io.h  |  147 ++
 .../include/mach-bcmring/csp/secHw_def.h           |  100 ++
 .../{mach => mach-bcmring}/csp/secHw_inline.h      |    0
 .../include/mach-bcmring/csp/tmrHw_reg.h           |   82 +
 arch/arm/mach-bcmring/include/mach-bcmring/dma.h   |  630 ++++++++
 .../include/mach-bcmring/entry-macro.S             |   76 +
 .../mach-bcmring/include/mach-bcmring/hardware.h   |   57 +
 .../include/{mach => mach-bcmring}/irqs.h          |    0
 .../{mach => mach-bcmring}/memory_settings.h       |    0
 .../mach-bcmring/include/mach-bcmring/reg_nand.h   |   66 +
 .../mach-bcmring/include/mach-bcmring/reg_umi.h    |  237 +++
 .../include/{mach => mach-bcmring}/timer.h         |    0
 .../include/{mach => mach-bcmring}/timex.h         |    0
 .../mach-bcmring/include/mach-bcmring/uncompress.h |   43 +
 .../arm/mach-bcmring/include/mach/csp/cap_inline.h |  409 -----
 .../mach-bcmring/include/mach/csp/chipcHw_def.h    | 1123 -------------
 .../mach-bcmring/include/mach/csp/chipcHw_inline.h | 1673 --------------------
 .../mach-bcmring/include/mach/csp/chipcHw_reg.h    |  530 -------
 arch/arm/mach-bcmring/include/mach/csp/ddrcReg.h   |  872 ----------
 .../arm/mach-bcmring/include/mach/csp/dmacHw_reg.h |  406 -----
 arch/arm/mach-bcmring/include/mach/csp/hw_cfg.h    |   73 -
 .../arm/mach-bcmring/include/mach/csp/intcHw_reg.h |  246 ---
 arch/arm/mach-bcmring/include/mach/csp/mm_io.h     |  147 --
 arch/arm/mach-bcmring/include/mach/csp/secHw_def.h |  100 --
 arch/arm/mach-bcmring/include/mach/csp/tmrHw_reg.h |   82 -
 arch/arm/mach-bcmring/include/mach/dma.h           |  630 --------
 arch/arm/mach-bcmring/include/mach/entry-macro.S   |   76 -
 arch/arm/mach-bcmring/include/mach/hardware.h      |   57 -
 arch/arm/mach-bcmring/include/mach/reg_nand.h      |   66 -
 arch/arm/mach-bcmring/include/mach/reg_umi.h       |  237 ---
 arch/arm/mach-bcmring/include/mach/uncompress.h    |   43 -
 arch/arm/mach-bcmring/irq.c                        |    6 +-
 arch/arm/mach-bcmring/mm.c                         |    4 +-
 arch/arm/mach-bcmring/timer.c                      |    2 +-
 arch/arm/mach-clps711x/autcpu12.c                  |    4 +-
 arch/arm/mach-clps711x/cdb89712.c                  |    2 +-
 arch/arm/mach-clps711x/ceiva.c                     |    2 +-
 arch/arm/mach-clps711x/common.c                    |    2 +-
 arch/arm/mach-clps711x/edb7211-mm.c                |    2 +-
 arch/arm/mach-clps711x/fortunet.c                  |    2 +-
 .../include/{mach => mach-clps711x}/autcpu12.h     |    0
 .../include/{mach => mach-clps711x}/clps711x.h     |    0
 .../include/mach-clps711x/debug-macro.S            |   44 +
 .../include/mach-clps711x/entry-macro.S            |   51 +
 .../mach-clps711x/include/mach-clps711x/hardware.h |  175 ++
 .../include/{mach => mach-clps711x}/irqs.h         |    0
 .../include/{mach => mach-clps711x}/memory.h       |    0
 .../include/{mach => mach-clps711x}/syspld.h       |    0
 .../include/{mach => mach-clps711x}/timex.h        |    0
 .../include/mach-clps711x/uncompress.h             |   57 +
 arch/arm/mach-clps711x/include/mach/debug-macro.S  |   44 -
 arch/arm/mach-clps711x/include/mach/entry-macro.S  |   51 -
 arch/arm/mach-clps711x/include/mach/hardware.h     |  175 --
 arch/arm/mach-clps711x/include/mach/uncompress.h   |   57 -
 arch/arm/mach-clps711x/p720t-leds.c                |    2 +-
 arch/arm/mach-clps711x/p720t.c                     |    4 +-
 arch/arm/mach-cns3xxx/cns3420vb.c                  |    4 +-
 arch/arm/mach-cns3xxx/core.c                       |    2 +-
 arch/arm/mach-cns3xxx/devices.c                    |    6 +-
 .../include/{mach => mach-cns3xxx}/cns3xxx.h       |    0
 .../include/{mach => mach-cns3xxx}/debug-macro.S   |    0
 arch/arm/mach-cns3xxx/include/mach-cns3xxx/irqs.h  |   24 +
 .../include/{mach => mach-cns3xxx}/pm.h            |    0
 .../include/{mach => mach-cns3xxx}/timex.h         |    0
 .../mach-cns3xxx/include/mach-cns3xxx/uncompress.h |   54 +
 arch/arm/mach-cns3xxx/include/mach/irqs.h          |   24 -
 arch/arm/mach-cns3xxx/include/mach/uncompress.h    |   54 -
 arch/arm/mach-cns3xxx/pcie.c                       |    2 +-
 arch/arm/mach-cns3xxx/pm.c                         |    4 +-
 arch/arm/mach-davinci/aemif.c                      |    2 +-
 arch/arm/mach-davinci/board-da830-evm.c            |   14 +-
 arch/arm/mach-davinci/board-da850-evm.c            |   12 +-
 arch/arm/mach-davinci/board-dm355-evm.c            |   10 +-
 arch/arm/mach-davinci/board-dm355-leopard.c        |   10 +-
 arch/arm/mach-davinci/board-dm365-evm.c            |   14 +-
 arch/arm/mach-davinci/board-dm644x-evm.c           |   16 +-
 arch/arm/mach-davinci/board-dm646x-evm.c           |   14 +-
 arch/arm/mach-davinci/board-mityomapl138.c         |   12 +-
 arch/arm/mach-davinci/board-neuros-osd2.c          |   14 +-
 arch/arm/mach-davinci/board-omapl138-hawk.c        |    6 +-
 arch/arm/mach-davinci/board-sffsdr.c               |   10 +-
 arch/arm/mach-davinci/board-tnetv107x-evm.c        |   10 +-
 arch/arm/mach-davinci/cdce949.c                    |    4 +-
 arch/arm/mach-davinci/clock.c                      |    8 +-
 arch/arm/mach-davinci/common.c                     |    4 +-
 arch/arm/mach-davinci/cp_intc.c                    |    4 +-
 arch/arm/mach-davinci/cpufreq.c                    |    6 +-
 arch/arm/mach-davinci/cpuidle.c                    |    4 +-
 arch/arm/mach-davinci/da830.c                      |   14 +-
 arch/arm/mach-davinci/da850.c                      |   18 +-
 arch/arm/mach-davinci/davinci.h                    |    6 +-
 arch/arm/mach-davinci/devices-da8xx.c              |   10 +-
 arch/arm/mach-davinci/devices-tnetv107x.c          |    8 +-
 arch/arm/mach-davinci/devices.c                    |   16 +-
 arch/arm/mach-davinci/dm355.c                      |   22 +-
 arch/arm/mach-davinci/dm365.c                      |   24 +-
 arch/arm/mach-davinci/dm644x.c                     |   20 +-
 arch/arm/mach-davinci/dm646x.c                     |   20 +-
 arch/arm/mach-davinci/dma.c                        |    2 +-
 .../include/{mach => mach-davinci}/aemif.h         |    0
 arch/arm/mach-davinci/include/mach-davinci/asp.h   |  137 ++
 .../mach-davinci/include/mach-davinci/cdce949.h    |   19 +
 .../include/{mach => mach-davinci}/clock.h         |    0
 .../include/{mach => mach-davinci}/common.h        |    0
 .../include/{mach => mach-davinci}/cp_intc.h       |    0
 .../include/{mach => mach-davinci}/cpufreq.h       |    0
 .../include/{mach => mach-davinci}/cpuidle.h       |    0
 .../mach-davinci/include/mach-davinci/cputype.h    |   94 ++
 arch/arm/mach-davinci/include/mach-davinci/da8xx.h |  134 ++
 .../include/{mach => mach-davinci}/ddr2.h          |    0
 .../include/mach-davinci/debug-macro.S             |   67 +
 .../include/{mach => mach-davinci}/edma.h          |    0
 .../include/mach-davinci/entry-macro.S             |   39 +
 .../include/mach-davinci/gpio-davinci.h            |   91 ++
 .../include/{mach => mach-davinci}/gpio.h          |    0
 .../include/{mach => mach-davinci}/hardware.h      |    0
 .../include/{mach => mach-davinci}/i2c.h           |    0
 .../include/{mach => mach-davinci}/irqs.h          |    0
 .../include/{mach => mach-davinci}/keyscan.h       |    0
 .../include/{mach => mach-davinci}/mmc.h           |    0
 .../include/{mach => mach-davinci}/mux.h           |    0
 .../include/{mach => mach-davinci}/nand.h          |    0
 .../include/{mach => mach-davinci}/pm.h            |    0
 .../include/{mach => mach-davinci}/psc.h           |    0
 .../arm/mach-davinci/include/mach-davinci/serial.h |   48 +
 arch/arm/mach-davinci/include/mach-davinci/spi.h   |   89 ++
 .../include/{mach => mach-davinci}/sram.h          |    0
 .../include/{mach => mach-davinci}/time.h          |    0
 .../include/{mach => mach-davinci}/timex.h         |    0
 .../mach-davinci/include/mach-davinci/tnetv107x.h  |   61 +
 .../mach-davinci/include/mach-davinci/uncompress.h |   98 ++
 .../include/{mach => mach-davinci}/usb.h           |    0
 arch/arm/mach-davinci/include/mach/asp.h           |  137 --
 arch/arm/mach-davinci/include/mach/cdce949.h       |   19 -
 arch/arm/mach-davinci/include/mach/cputype.h       |   94 --
 arch/arm/mach-davinci/include/mach/da8xx.h         |  134 --
 arch/arm/mach-davinci/include/mach/debug-macro.S   |   67 -
 arch/arm/mach-davinci/include/mach/entry-macro.S   |   39 -
 arch/arm/mach-davinci/include/mach/gpio-davinci.h  |   91 --
 arch/arm/mach-davinci/include/mach/serial.h        |   48 -
 arch/arm/mach-davinci/include/mach/spi.h           |   89 --
 arch/arm/mach-davinci/include/mach/tnetv107x.h     |   61 -
 arch/arm/mach-davinci/include/mach/uncompress.h    |   98 --
 arch/arm/mach-davinci/irq.c                        |    6 +-
 arch/arm/mach-davinci/mux.c                        |    4 +-
 arch/arm/mach-davinci/mux.h                        |    2 +-
 arch/arm/mach-davinci/pm.c                         |    6 +-
 arch/arm/mach-davinci/psc.c                        |    4 +-
 arch/arm/mach-davinci/serial.c                     |    4 +-
 arch/arm/mach-davinci/sleep.S                      |    4 +-
 arch/arm/mach-davinci/sram.c                       |    4 +-
 arch/arm/mach-davinci/time.c                       |    6 +-
 arch/arm/mach-davinci/tnetv107x.c                  |   18 +-
 arch/arm/mach-davinci/usb.c                        |    8 +-
 arch/arm/mach-dove/addr-map.c                      |    4 +-
 arch/arm/mach-dove/cm-a510.c                       |    2 +-
 arch/arm/mach-dove/common.c                        |   12 +-
 arch/arm/mach-dove/dove-db-setup.c                 |    2 +-
 arch/arm/mach-dove/include/mach-dove/bridge-regs.h |   55 +
 arch/arm/mach-dove/include/mach-dove/debug-macro.S |   19 +
 .../mach-dove/include/{mach => mach-dove}/dove.h   |    0
 arch/arm/mach-dove/include/mach-dove/entry-macro.S |   33 +
 arch/arm/mach-dove/include/mach-dove/gpio.h        |    9 +
 .../include/{mach => mach-dove}/hardware.h         |    0
 .../arm/mach-dove/include/{mach => mach-dove}/io.h |    0
 .../mach-dove/include/{mach => mach-dove}/irqs.h   |    0
 arch/arm/mach-dove/include/mach-dove/pm.h          |   54 +
 .../mach-dove/include/{mach => mach-dove}/timex.h  |    0
 arch/arm/mach-dove/include/mach-dove/uncompress.h  |   37 +
 arch/arm/mach-dove/include/mach/bridge-regs.h      |   55 -
 arch/arm/mach-dove/include/mach/debug-macro.S      |   19 -
 arch/arm/mach-dove/include/mach/entry-macro.S      |   33 -
 arch/arm/mach-dove/include/mach/gpio.h             |    9 -
 arch/arm/mach-dove/include/mach/pm.h               |   54 -
 arch/arm/mach-dove/include/mach/uncompress.h       |   37 -
 arch/arm/mach-dove/irq.c                           |    6 +-
 arch/arm/mach-dove/mpp.c                           |    4 +-
 arch/arm/mach-dove/pcie.c                          |    8 +-
 arch/arm/mach-ebsa110/core.c                       |    2 +-
 .../include/{mach => mach-ebsa110}/debug-macro.S   |    0
 .../include/{mach => mach-ebsa110}/entry-macro.S   |    0
 .../include/{mach => mach-ebsa110}/hardware.h      |    0
 .../include/{mach => mach-ebsa110}/io.h            |    0
 .../include/{mach => mach-ebsa110}/irqs.h          |    0
 .../include/{mach => mach-ebsa110}/memory.h        |    0
 .../include/{mach => mach-ebsa110}/timex.h         |    0
 .../include/{mach => mach-ebsa110}/uncompress.h    |    0
 arch/arm/mach-ebsa110/io.c                         |    2 +-
 arch/arm/mach-ebsa110/leds.c                       |    2 +-
 arch/arm/mach-ep93xx/adssphere.c                   |    2 +-
 arch/arm/mach-ep93xx/clock.c                       |    2 +-
 arch/arm/mach-ep93xx/core.c                        |   10 +-
 arch/arm/mach-ep93xx/crunch-bits.S                 |    2 +-
 arch/arm/mach-ep93xx/dma.c                         |    4 +-
 arch/arm/mach-ep93xx/edb93xx.c                     |    8 +-
 arch/arm/mach-ep93xx/gesbc9312.c                   |    2 +-
 .../mach-ep93xx/include/mach-ep93xx/debug-macro.S  |   21 +
 .../include/{mach => mach-ep93xx}/dma.h            |    0
 .../include/{mach => mach-ep93xx}/ep93xx-regs.h    |    0
 .../include/{mach => mach-ep93xx}/ep93xx_keypad.h  |    0
 .../include/{mach => mach-ep93xx}/ep93xx_spi.h     |    0
 .../mach-ep93xx/include/{mach => mach-ep93xx}/fb.h |    0
 .../mach-ep93xx/include/mach-ep93xx/gpio-ep93xx.h  |  110 ++
 .../include/{mach => mach-ep93xx}/gpio.h           |    0
 .../arm/mach-ep93xx/include/mach-ep93xx/hardware.h |   24 +
 .../include/{mach => mach-ep93xx}/irqs.h           |    0
 .../include/{mach => mach-ep93xx}/memory.h         |    0
 .../include/{mach => mach-ep93xx}/platform.h       |    0
 .../include/{mach => mach-ep93xx}/timex.h          |    0
 .../include/{mach => mach-ep93xx}/ts72xx.h         |    0
 .../mach-ep93xx/include/mach-ep93xx/uncompress.h   |   94 ++
 arch/arm/mach-ep93xx/include/mach/debug-macro.S    |   21 -
 arch/arm/mach-ep93xx/include/mach/gpio-ep93xx.h    |  110 --
 arch/arm/mach-ep93xx/include/mach/hardware.h       |   24 -
 arch/arm/mach-ep93xx/include/mach/uncompress.h     |   94 --
 arch/arm/mach-ep93xx/micro9.c                      |    2 +-
 arch/arm/mach-ep93xx/simone.c                      |    6 +-
 arch/arm/mach-ep93xx/snappercl15.c                 |    6 +-
 arch/arm/mach-ep93xx/soc.h                         |    2 +-
 arch/arm/mach-ep93xx/ts72xx.c                      |    4 +-
 arch/arm/mach-ep93xx/vision_ep9307.c               |    8 +-
 arch/arm/mach-exynos/clock-exynos4.c               |   22 +-
 arch/arm/mach-exynos/clock-exynos4210.c            |   24 +-
 arch/arm/mach-exynos/clock-exynos4212.c            |   24 +-
 arch/arm/mach-exynos/clock-exynos5.c               |   22 +-
 arch/arm/mach-exynos/common.c                      |   34 +-
 arch/arm/mach-exynos/cpuidle.c                     |    6 +-
 arch/arm/mach-exynos/dev-ahci.c                    |    8 +-
 arch/arm/mach-exynos/dev-audio.c                   |   12 +-
 arch/arm/mach-exynos/dev-drm.c                     |    2 +-
 arch/arm/mach-exynos/dev-dwmci.c                   |    4 +-
 arch/arm/mach-exynos/dev-ohci.c                    |   10 +-
 arch/arm/mach-exynos/dev-sysmmu.c                  |    8 +-
 arch/arm/mach-exynos/dev-uart.c                    |    6 +-
 arch/arm/mach-exynos/dma.c                         |   12 +-
 arch/arm/mach-exynos/hotplug.c                     |    2 +-
 .../include/{mach => mach-exynos}/cpufreq.h        |    0
 .../mach-exynos/include/mach-exynos/debug-macro.S  |   39 +
 arch/arm/mach-exynos/include/mach-exynos/dma.h     |   26 +
 .../include/{mach => mach-exynos}/dwmci.h          |    0
 .../include/{mach => mach-exynos}/gpio.h           |    0
 .../include/{mach => mach-exynos}/hardware.h       |    0
 arch/arm/mach-exynos/include/mach-exynos/irqs.h    |  469 ++++++
 arch/arm/mach-exynos/include/mach-exynos/map.h     |  278 ++++
 .../include/{mach => mach-exynos}/memory.h         |    0
 .../include/{mach => mach-exynos}/ohci.h           |    0
 arch/arm/mach-exynos/include/mach-exynos/pm-core.h |   65 +
 .../include/{mach => mach-exynos}/pmu.h            |    0
 .../include/{mach => mach-exynos}/regs-audss.h     |    0
 .../mach-exynos/include/mach-exynos/regs-clock.h   |  353 +++++
 .../mach-exynos/include/mach-exynos/regs-gpio.h    |   40 +
 .../arm/mach-exynos/include/mach-exynos/regs-irq.h |   19 +
 .../arm/mach-exynos/include/mach-exynos/regs-mct.h |   53 +
 .../arm/mach-exynos/include/mach-exynos/regs-mem.h |   23 +
 .../arm/mach-exynos/include/mach-exynos/regs-pmu.h |  370 +++++
 .../include/{mach => mach-exynos}/regs-usb-phy.h   |    0
 .../include/{mach => mach-exynos}/sysmmu.h         |    0
 .../include/{mach => mach-exynos}/timex.h          |    0
 .../mach-exynos/include/mach-exynos/uncompress.h   |   52 +
 arch/arm/mach-exynos/include/mach/debug-macro.S    |   39 -
 arch/arm/mach-exynos/include/mach/dma.h            |   26 -
 arch/arm/mach-exynos/include/mach/irqs.h           |  469 ------
 arch/arm/mach-exynos/include/mach/map.h            |  278 ----
 arch/arm/mach-exynos/include/mach/pm-core.h        |   65 -
 arch/arm/mach-exynos/include/mach/regs-clock.h     |  353 -----
 arch/arm/mach-exynos/include/mach/regs-gpio.h      |   40 -
 arch/arm/mach-exynos/include/mach/regs-irq.h       |   19 -
 arch/arm/mach-exynos/include/mach/regs-mct.h       |   53 -
 arch/arm/mach-exynos/include/mach/regs-mem.h       |   23 -
 arch/arm/mach-exynos/include/mach/regs-pmu.h       |  370 -----
 arch/arm/mach-exynos/include/mach/uncompress.h     |   52 -
 arch/arm/mach-exynos/mach-armlex4210.c             |   16 +-
 arch/arm/mach-exynos/mach-exynos4-dt.c             |    6 +-
 arch/arm/mach-exynos/mach-exynos5-dt.c             |    6 +-
 arch/arm/mach-exynos/mach-nuri.c                   |   34 +-
 arch/arm/mach-exynos/mach-origen.c                 |   30 +-
 arch/arm/mach-exynos/mach-smdk4x12.c               |   28 +-
 arch/arm/mach-exynos/mach-smdkv310.c               |   34 +-
 arch/arm/mach-exynos/mach-universal_c210.c         |   32 +-
 arch/arm/mach-exynos/mct.c                         |    8 +-
 arch/arm/mach-exynos/platsmp.c                     |    8 +-
 arch/arm/mach-exynos/pm.c                          |   22 +-
 arch/arm/mach-exynos/pm_domains.c                  |    4 +-
 arch/arm/mach-exynos/pmu.c                         |    4 +-
 arch/arm/mach-exynos/setup-fimc.c                  |    4 +-
 arch/arm/mach-exynos/setup-fimd0.c                 |    6 +-
 arch/arm/mach-exynos/setup-i2c0.c                  |    6 +-
 arch/arm/mach-exynos/setup-i2c1.c                  |    4 +-
 arch/arm/mach-exynos/setup-i2c2.c                  |    4 +-
 arch/arm/mach-exynos/setup-i2c3.c                  |    4 +-
 arch/arm/mach-exynos/setup-i2c4.c                  |    4 +-
 arch/arm/mach-exynos/setup-i2c5.c                  |    4 +-
 arch/arm/mach-exynos/setup-i2c6.c                  |    4 +-
 arch/arm/mach-exynos/setup-i2c7.c                  |    4 +-
 arch/arm/mach-exynos/setup-keypad.c                |    2 +-
 arch/arm/mach-exynos/setup-sdhci-gpio.c            |    6 +-
 arch/arm/mach-exynos/setup-spi.c                   |    2 +-
 arch/arm/mach-exynos/setup-usb-phy.c               |    8 +-
 arch/arm/mach-footbridge/ebsa285-leds.c            |    2 +-
 .../include/mach-footbridge/debug-macro.S          |   56 +
 .../include/mach-footbridge/entry-macro.S          |  107 ++
 .../include/{mach => mach-footbridge}/hardware.h   |    0
 .../include/{mach => mach-footbridge}/io.h         |    0
 .../include/{mach => mach-footbridge}/irqs.h       |    0
 .../include/{mach => mach-footbridge}/isa-dma.h    |    0
 .../include/{mach => mach-footbridge}/memory.h     |    0
 .../include/{mach => mach-footbridge}/timex.h      |    0
 .../include/{mach => mach-footbridge}/uncompress.h |    0
 .../arm/mach-footbridge/include/mach/debug-macro.S |   56 -
 .../arm/mach-footbridge/include/mach/entry-macro.S |  107 --
 arch/arm/mach-footbridge/isa-irq.c                 |    2 +-
 arch/arm/mach-footbridge/netwinder-leds.c          |    2 +-
 arch/arm/mach-gemini/board-nas4220b.c              |    4 +-
 arch/arm/mach-gemini/devices.c                     |    6 +-
 arch/arm/mach-gemini/gpio.c                        |    4 +-
 .../mach-gemini/include/mach-gemini/debug-macro.S  |   21 +
 .../mach-gemini/include/mach-gemini/entry-macro.S  |   33 +
 .../include/{mach => mach-gemini}/global_reg.h     |    0
 arch/arm/mach-gemini/include/mach-gemini/gpio.h    |   20 +
 .../include/{mach => mach-gemini}/hardware.h       |    0
 .../include/{mach => mach-gemini}/irqs.h           |    0
 arch/arm/mach-gemini/include/mach-gemini/system.h  |   23 +
 .../include/{mach => mach-gemini}/timex.h          |    0
 .../mach-gemini/include/mach-gemini/uncompress.h   |   44 +
 arch/arm/mach-gemini/include/mach/debug-macro.S    |   21 -
 arch/arm/mach-gemini/include/mach/entry-macro.S    |   33 -
 arch/arm/mach-gemini/include/mach/gpio.h           |   20 -
 arch/arm/mach-gemini/include/mach/system.h         |   23 -
 arch/arm/mach-gemini/include/mach/uncompress.h     |   44 -
 arch/arm/mach-gemini/irq.c                         |    2 +-
 arch/arm/mach-gemini/mm.c                          |    2 +-
 arch/arm/mach-gemini/time.c                        |    4 +-
 arch/arm/mach-h720x/common.c                       |    4 +-
 arch/arm/mach-h720x/cpu-h7201.c                    |    4 +-
 arch/arm/mach-h720x/cpu-h7202.c                    |    4 +-
 arch/arm/mach-h720x/h7201-eval.c                   |    2 +-
 arch/arm/mach-h720x/h7202-eval.c                   |    4 +-
 .../include/{mach => mach-h720x}/boards.h          |    0
 .../mach-h720x/include/mach-h720x/debug-macro.S    |   40 +
 .../include/{mach => mach-h720x}/entry-macro.S     |    0
 .../include/{mach => mach-h720x}/h7201-regs.h      |    0
 .../include/{mach => mach-h720x}/h7202-regs.h      |    0
 .../include/{mach => mach-h720x}/hardware.h        |    0
 .../mach-h720x/include/{mach => mach-h720x}/irqs.h |    0
 .../include/{mach => mach-h720x}/isa-dma.h         |    0
 .../include/{mach => mach-h720x}/timex.h           |    0
 .../arm/mach-h720x/include/mach-h720x/uncompress.h |   37 +
 arch/arm/mach-h720x/include/mach/debug-macro.S     |   40 -
 arch/arm/mach-h720x/include/mach/uncompress.h      |   37 -
 .../include/{mach => mach-highbank}/debug-macro.S  |    0
 .../include/{mach => mach-highbank}/gpio.h         |    0
 .../include/{mach => mach-highbank}/timex.h        |    0
 .../include/{mach => mach-highbank}/uncompress.h   |    0
 arch/arm/mach-imx/clk-imx1.c                       |    4 +-
 arch/arm/mach-imx/clk-imx21.c                      |    4 +-
 arch/arm/mach-imx/clk-imx25.c                      |    6 +-
 arch/arm/mach-imx/clk-imx27.c                      |    4 +-
 arch/arm/mach-imx/clk-imx31.c                      |    6 +-
 arch/arm/mach-imx/clk-imx35.c                      |    4 +-
 arch/arm/mach-imx/clk-imx51-imx53.c                |    4 +-
 arch/arm/mach-imx/clk-imx6q.c                      |    2 +-
 arch/arm/mach-imx/clk-pllv1.c                      |    6 +-
 arch/arm/mach-imx/clk.h                            |    2 +-
 arch/arm/mach-imx/cpu-imx25.c                      |    4 +-
 arch/arm/mach-imx/cpu-imx27.c                      |    2 +-
 arch/arm/mach-imx/cpu-imx31.c                      |    6 +-
 arch/arm/mach-imx/cpu-imx35.c                      |    4 +-
 arch/arm/mach-imx/cpu-imx5.c                       |    2 +-
 arch/arm/mach-imx/cpu_op-mx51.c                    |    2 +-
 arch/arm/mach-imx/devices-imx1.h                   |    4 +-
 arch/arm/mach-imx/devices-imx21.h                  |    4 +-
 arch/arm/mach-imx/devices-imx25.h                  |    4 +-
 arch/arm/mach-imx/devices-imx27.h                  |    4 +-
 arch/arm/mach-imx/devices-imx31.h                  |    4 +-
 arch/arm/mach-imx/devices-imx35.h                  |    4 +-
 arch/arm/mach-imx/devices-imx50.h                  |    4 +-
 arch/arm/mach-imx/devices-imx51.h                  |    4 +-
 arch/arm/mach-imx/devices-imx53.h                  |    4 +-
 arch/arm/mach-imx/ehci-imx25.c                     |    4 +-
 arch/arm/mach-imx/ehci-imx27.c                     |    4 +-
 arch/arm/mach-imx/ehci-imx31.c                     |    4 +-
 arch/arm/mach-imx/ehci-imx35.c                     |    4 +-
 arch/arm/mach-imx/ehci-imx5.c                      |    4 +-
 arch/arm/mach-imx/eukrea_mbimx27-baseboard.c       |    6 +-
 arch/arm/mach-imx/eukrea_mbimxsd25-baseboard.c     |    8 +-
 arch/arm/mach-imx/eukrea_mbimxsd35-baseboard.c     |    6 +-
 arch/arm/mach-imx/eukrea_mbimxsd51-baseboard.c     |    6 +-
 arch/arm/mach-imx/hotplug.c                        |    2 +-
 arch/arm/mach-imx/imx27-dt.c                       |    4 +-
 arch/arm/mach-imx/imx31-dt.c                       |    4 +-
 arch/arm/mach-imx/imx51-dt.c                       |    4 +-
 arch/arm/mach-imx/imx53-dt.c                       |    4 +-
 .../include/mach-imx}/3ds_debugboard.h             |    0
 .../include/mach-imx}/board-mx31lilly.h            |    0
 .../include/mach-imx}/board-mx31lite.h             |    0
 .../include/mach-imx}/board-mx31moboard.h          |    0
 .../include/mach-imx}/board-pcm038.h               |    0
 .../mach => mach-imx/include/mach-imx}/clock.h     |    0
 .../mach => mach-imx/include/mach-imx}/common.h    |    0
 .../mach => mach-imx/include/mach-imx}/cpuidle.h   |    0
 arch/arm/mach-imx/include/mach-imx/debug-macro.S   |   51 +
 .../arm/mach-imx/include/mach-imx/devices-common.h |  333 ++++
 arch/arm/mach-imx/include/mach-imx/dma-mx1-mx2.h   |   10 +
 .../mach => mach-imx/include/mach-imx}/dma.h       |    0
 .../mach => mach-imx/include/mach-imx}/esdhc.h     |    0
 .../include/mach-imx}/eukrea-baseboards.h          |    0
 .../mach => mach-imx/include/mach-imx}/gpio.h      |    0
 arch/arm/mach-imx/include/mach-imx/hardware.h      |  134 ++
 .../mach => mach-imx/include/mach-imx}/i2c.h       |    0
 .../mach => mach-imx/include/mach-imx}/iim.h       |    0
 .../mach => mach-imx/include/mach-imx}/imx-uart.h  |    0
 .../mach => mach-imx/include/mach-imx}/imxfb.h     |    0
 arch/arm/mach-imx/include/mach-imx/iomux-mx1.h     |  155 ++
 arch/arm/mach-imx/include/mach-imx/iomux-mx21.h    |  122 ++
 arch/arm/mach-imx/include/mach-imx/iomux-mx25.h    |  524 ++++++
 arch/arm/mach-imx/include/mach-imx/iomux-mx27.h    |  205 +++
 .../include/mach-imx}/iomux-mx2x.h                 |    0
 .../mach => mach-imx/include/mach-imx}/iomux-mx3.h |    0
 arch/arm/mach-imx/include/mach-imx/iomux-mx35.h    | 1267 +++++++++++++++
 arch/arm/mach-imx/include/mach-imx/iomux-mx50.h    |  977 ++++++++++++
 arch/arm/mach-imx/include/mach-imx/iomux-mx51.h    |  827 ++++++++++
 arch/arm/mach-imx/include/mach-imx/iomux-mx53.h    | 1219 ++++++++++++++
 .../mach => mach-imx/include/mach-imx}/iomux-v1.h  |    0
 .../mach => mach-imx/include/mach-imx}/iomux-v3.h  |    0
 .../mach => mach-imx/include/mach-imx}/ipu.h       |    0
 .../mach => mach-imx/include/mach-imx}/iram.h      |    0
 .../mach => mach-imx/include/mach-imx}/irqs.h      |    0
 .../mach => mach-imx/include/mach-imx}/mmc.h       |    0
 .../mach => mach-imx/include/mach-imx}/mx1.h       |    0
 .../include/mach-imx}/mx1_camera.h                 |    0
 .../include/mach-imx}/mx21-usbhost.h               |    0
 .../mach => mach-imx/include/mach-imx}/mx21.h      |    0
 .../mach => mach-imx/include/mach-imx}/mx25.h      |    0
 .../mach => mach-imx/include/mach-imx}/mx27.h      |    0
 .../mach => mach-imx/include/mach-imx}/mx2_cam.h   |    0
 .../mach => mach-imx/include/mach-imx}/mx2x.h      |    0
 .../mach => mach-imx/include/mach-imx}/mx31.h      |    0
 .../mach => mach-imx/include/mach-imx}/mx35.h      |    0
 .../include/mach-imx}/mx3_camera.h                 |    0
 .../mach => mach-imx/include/mach-imx}/mx3fb.h     |    0
 .../mach => mach-imx/include/mach-imx}/mx3x.h      |    0
 .../mach => mach-imx/include/mach-imx}/mx50.h      |    0
 .../mach => mach-imx/include/mach-imx}/mx51.h      |    0
 .../mach => mach-imx/include/mach-imx}/mx53.h      |    0
 .../mach => mach-imx/include/mach-imx}/mx6q.h      |    0
 .../mach => mach-imx/include/mach-imx}/mxc.h       |    0
 .../mach => mach-imx/include/mach-imx}/mxc_ehci.h  |    0
 .../mach => mach-imx/include/mach-imx}/mxc_nand.h  |    0
 .../mach => mach-imx/include/mach-imx}/sdma.h      |    0
 .../mach => mach-imx/include/mach-imx}/spi.h       |    0
 .../mach => mach-imx/include/mach-imx}/ssi.h       |    0
 .../mach => mach-imx/include/mach-imx}/timex.h     |    0
 .../mach => mach-imx/include/mach-imx}/ulpi.h      |    0
 .../include/mach-imx}/uncompress.h                 |    0
 .../mach => mach-imx/include/mach-imx}/usb.h       |    0
 arch/arm/mach-imx/include/mach/dma-mx1-mx2.h       |   10 -
 arch/arm/mach-imx/iomux-imx31.c                    |    4 +-
 arch/arm/mach-imx/lluart.c                         |    2 +-
 arch/arm/mach-imx/mach-apf9328.c                   |    6 +-
 arch/arm/mach-imx/mach-armadillo5x0.c              |    8 +-
 arch/arm/mach-imx/mach-bug.c                       |    6 +-
 arch/arm/mach-imx/mach-cpuimx27.c                  |   10 +-
 arch/arm/mach-imx/mach-cpuimx35.c                  |    8 +-
 arch/arm/mach-imx/mach-cpuimx51sd.c                |    8 +-
 arch/arm/mach-imx/mach-eukrea_cpuimx25.c           |   10 +-
 arch/arm/mach-imx/mach-imx27_visstrim_m10.c        |    6 +-
 arch/arm/mach-imx/mach-imx27ipcam.c                |    6 +-
 arch/arm/mach-imx/mach-imx27lite.c                 |    6 +-
 arch/arm/mach-imx/mach-imx6q.c                     |    6 +-
 arch/arm/mach-imx/mach-kzm_arm11_01.c              |    8 +-
 arch/arm/mach-imx/mach-mx1ads.c                    |    6 +-
 arch/arm/mach-imx/mach-mx21ads.c                   |    6 +-
 arch/arm/mach-imx/mach-mx25_3ds.c                  |    8 +-
 arch/arm/mach-imx/mach-mx27_3ds.c                  |   10 +-
 arch/arm/mach-imx/mach-mx27ads.c                   |    6 +-
 arch/arm/mach-imx/mach-mx31_3ds.c                  |   10 +-
 arch/arm/mach-imx/mach-mx31ads.c                   |    4 +-
 arch/arm/mach-imx/mach-mx31lilly.c                 |   10 +-
 arch/arm/mach-imx/mach-mx31lite.c                  |   10 +-
 arch/arm/mach-imx/mach-mx31moboard.c               |   12 +-
 arch/arm/mach-imx/mach-mx35_3ds.c                  |    8 +-
 arch/arm/mach-imx/mach-mx50_rdp.c                  |    6 +-
 arch/arm/mach-imx/mach-mx51_3ds.c                  |    8 +-
 arch/arm/mach-imx/mach-mx51_babbage.c              |    6 +-
 arch/arm/mach-imx/mach-mx51_efikamx.c              |    6 +-
 arch/arm/mach-imx/mach-mx51_efikasb.c              |    8 +-
 arch/arm/mach-imx/mach-mx53_ard.c                  |    6 +-
 arch/arm/mach-imx/mach-mx53_evk.c                  |    6 +-
 arch/arm/mach-imx/mach-mx53_loco.c                 |    6 +-
 arch/arm/mach-imx/mach-mx53_smd.c                  |    6 +-
 arch/arm/mach-imx/mach-mxt_td60.c                  |    6 +-
 arch/arm/mach-imx/mach-pca100.c                    |    8 +-
 arch/arm/mach-imx/mach-pcm037.c                    |    8 +-
 arch/arm/mach-imx/mach-pcm037_eet.c                |    4 +-
 arch/arm/mach-imx/mach-pcm038.c                    |   10 +-
 arch/arm/mach-imx/mach-pcm043.c                    |    8 +-
 arch/arm/mach-imx/mach-qong.c                      |    6 +-
 arch/arm/mach-imx/mach-scb9328.c                   |    6 +-
 arch/arm/mach-imx/mach-vpr200.c                    |    6 +-
 arch/arm/mach-imx/mm-imx1.c                        |    6 +-
 arch/arm/mach-imx/mm-imx21.c                       |    8 +-
 arch/arm/mach-imx/mm-imx25.c                       |   10 +-
 arch/arm/mach-imx/mm-imx27.c                       |    8 +-
 arch/arm/mach-imx/mm-imx3.c                        |    8 +-
 arch/arm/mach-imx/mm-imx5.c                        |    8 +-
 arch/arm/mach-imx/mx1-camera-fiq-ksym.c            |    2 +-
 arch/arm/mach-imx/mx31lilly-db.c                   |    8 +-
 arch/arm/mach-imx/mx31lite-db.c                    |    8 +-
 arch/arm/mach-imx/mx31moboard-devboard.c           |    8 +-
 arch/arm/mach-imx/mx31moboard-marxbot.c            |    8 +-
 arch/arm/mach-imx/mx31moboard-smartbot.c           |   10 +-
 arch/arm/mach-imx/mx51_efika.c                     |    8 +-
 arch/arm/mach-imx/pcm970-baseboard.c               |    6 +-
 arch/arm/mach-imx/platsmp.c                        |    4 +-
 arch/arm/mach-imx/pm-imx27.c                       |    2 +-
 arch/arm/mach-imx/pm-imx3.c                        |    6 +-
 arch/arm/mach-imx/pm-imx5.c                        |    6 +-
 arch/arm/mach-imx/pm-imx6q.c                       |    4 +-
 arch/arm/mach-integrator/core.c                    |    8 +-
 arch/arm/mach-integrator/cpu.c                     |    4 +-
 arch/arm/mach-integrator/impd1.c                   |    4 +-
 .../include/{mach => mach-integrator}/cm.h         |    0
 .../{mach => mach-integrator}/debug-macro.S        |    0
 .../include/{mach => mach-integrator}/hardware.h   |    0
 .../include/{mach => mach-integrator}/impd1.h      |    0
 .../include/{mach => mach-integrator}/io.h         |    0
 .../include/{mach => mach-integrator}/irqs.h       |    0
 .../include/{mach => mach-integrator}/lm.h         |    0
 .../include/{mach => mach-integrator}/memory.h     |    0
 .../include/{mach => mach-integrator}/platform.h   |    0
 .../include/{mach => mach-integrator}/timex.h      |    0
 .../include/{mach => mach-integrator}/uncompress.h |    0
 arch/arm/mach-integrator/integrator_ap.c           |   10 +-
 arch/arm/mach-integrator/integrator_cp.c           |   16 +-
 arch/arm/mach-integrator/leds.c                    |    6 +-
 arch/arm/mach-integrator/lm.c                      |    2 +-
 arch/arm/mach-integrator/pci.c                     |    2 +-
 arch/arm/mach-integrator/pci_v3.c                  |    6 +-
 arch/arm/mach-iop13xx/include/mach-iop13xx/adma.h  |  647 ++++++++
 .../include/{mach => mach-iop13xx}/debug-macro.S   |    0
 .../include/{mach => mach-iop13xx}/entry-macro.S   |    0
 .../include/{mach => mach-iop13xx}/hardware.h      |    0
 .../include/{mach => mach-iop13xx}/io.h            |    0
 .../include/{mach => mach-iop13xx}/iop13xx.h       |    0
 .../include/{mach => mach-iop13xx}/iq81340.h       |    0
 .../include/{mach => mach-iop13xx}/irqs.h          |    0
 .../arm/mach-iop13xx/include/mach-iop13xx/memory.h |   72 +
 .../include/{mach => mach-iop13xx}/msi.h           |    0
 arch/arm/mach-iop13xx/include/mach-iop13xx/pci.h   |   57 +
 .../include/{mach => mach-iop13xx}/time.h          |    0
 .../include/{mach => mach-iop13xx}/timex.h         |    0
 .../mach-iop13xx/include/mach-iop13xx/uncompress.h |   23 +
 arch/arm/mach-iop13xx/include/mach/adma.h          |  647 --------
 arch/arm/mach-iop13xx/include/mach/memory.h        |   72 -
 arch/arm/mach-iop13xx/include/mach/pci.h           |   57 -
 arch/arm/mach-iop13xx/include/mach/uncompress.h    |   23 -
 arch/arm/mach-iop13xx/io.c                         |    2 +-
 arch/arm/mach-iop13xx/iq81340mc.c                  |    6 +-
 arch/arm/mach-iop13xx/iq81340sc.c                  |    6 +-
 arch/arm/mach-iop13xx/irq.c                        |    6 +-
 arch/arm/mach-iop13xx/pci.c                        |    4 +-
 arch/arm/mach-iop13xx/setup.c                      |    2 +-
 arch/arm/mach-iop32x/em7210.c                      |    4 +-
 arch/arm/mach-iop32x/glantank.c                    |    4 +-
 .../include/{mach => mach-iop32x}/adma.h           |    0
 .../include/{mach => mach-iop32x}/debug-macro.S    |    0
 .../mach-iop32x/include/mach-iop32x/entry-macro.S  |   33 +
 .../include/{mach => mach-iop32x}/glantank.h       |    0
 .../include/{mach => mach-iop32x}/gpio.h           |    0
 .../include/{mach => mach-iop32x}/hardware.h       |    0
 .../mach-iop32x/include/{mach => mach-iop32x}/io.h |    0
 .../include/{mach => mach-iop32x}/iop32x.h         |    0
 .../include/{mach => mach-iop32x}/iq31244.h        |    0
 .../include/{mach => mach-iop32x}/iq80321.h        |    0
 .../include/{mach => mach-iop32x}/irqs.h           |    0
 .../include/{mach => mach-iop32x}/n2100.h          |    0
 .../include/{mach => mach-iop32x}/time.h           |    0
 .../include/{mach => mach-iop32x}/timex.h          |    0
 .../mach-iop32x/include/mach-iop32x/uncompress.h   |   39 +
 arch/arm/mach-iop32x/include/mach/entry-macro.S    |   33 -
 arch/arm/mach-iop32x/include/mach/uncompress.h     |   39 -
 arch/arm/mach-iop32x/iq31244.c                     |    4 +-
 arch/arm/mach-iop32x/iq80321.c                     |    4 +-
 arch/arm/mach-iop32x/irq.c                         |    2 +-
 arch/arm/mach-iop32x/n2100.c                       |    4 +-
 .../include/{mach => mach-iop33x}/adma.h           |    0
 .../include/{mach => mach-iop33x}/debug-macro.S    |    0
 .../mach-iop33x/include/mach-iop33x/entry-macro.S  |   34 +
 .../include/{mach => mach-iop33x}/gpio.h           |    0
 .../include/{mach => mach-iop33x}/hardware.h       |    0
 .../mach-iop33x/include/{mach => mach-iop33x}/io.h |    0
 .../include/{mach => mach-iop33x}/iop33x.h         |    0
 .../include/{mach => mach-iop33x}/iq80331.h        |    0
 .../include/{mach => mach-iop33x}/iq80332.h        |    0
 .../include/{mach => mach-iop33x}/irqs.h           |    0
 .../include/{mach => mach-iop33x}/time.h           |    0
 .../include/{mach => mach-iop33x}/timex.h          |    0
 .../mach-iop33x/include/mach-iop33x/uncompress.h   |   37 +
 arch/arm/mach-iop33x/include/mach/entry-macro.S    |   34 -
 arch/arm/mach-iop33x/include/mach/uncompress.h     |   37 -
 arch/arm/mach-iop33x/iq80331.c                     |    4 +-
 arch/arm/mach-iop33x/iq80332.c                     |    4 +-
 arch/arm/mach-iop33x/irq.c                         |    2 +-
 arch/arm/mach-iop33x/uart.c                        |    2 +-
 arch/arm/mach-ixp4xx/avila-pci.c                   |    2 +-
 arch/arm/mach-ixp4xx/avila-setup.c                 |    2 +-
 arch/arm/mach-ixp4xx/common-pci.c                  |    2 +-
 arch/arm/mach-ixp4xx/common.c                      |    6 +-
 arch/arm/mach-ixp4xx/coyote-pci.c                  |    2 +-
 arch/arm/mach-ixp4xx/coyote-setup.c                |    2 +-
 arch/arm/mach-ixp4xx/gateway7001-pci.c             |    2 +-
 arch/arm/mach-ixp4xx/gateway7001-setup.c           |    2 +-
 arch/arm/mach-ixp4xx/gtwx5715-pci.c                |    2 +-
 arch/arm/mach-ixp4xx/gtwx5715-setup.c              |    2 +-
 .../include/{mach => mach-ixp4xx}/cpu.h            |    0
 .../include/{mach => mach-ixp4xx}/debug-macro.S    |    0
 .../mach-ixp4xx/include/mach-ixp4xx/entry-macro.S  |   41 +
 .../include/{mach => mach-ixp4xx}/gpio.h           |    0
 .../arm/mach-ixp4xx/include/mach-ixp4xx/hardware.h |   36 +
 arch/arm/mach-ixp4xx/include/mach-ixp4xx/io.h      |  502 ++++++
 .../include/{mach => mach-ixp4xx}/irqs.h           |    0
 .../include/{mach => mach-ixp4xx}/ixp46x_ts.h      |    0
 .../include/{mach => mach-ixp4xx}/ixp4xx-regs.h    |    0
 .../include/{mach => mach-ixp4xx}/npe.h            |    0
 .../arm/mach-ixp4xx/include/mach-ixp4xx/platform.h |  175 ++
 .../include/{mach => mach-ixp4xx}/qmgr.h           |    0
 arch/arm/mach-ixp4xx/include/mach-ixp4xx/timex.h   |   16 +
 .../include/{mach => mach-ixp4xx}/udc.h            |    0
 .../include/{mach => mach-ixp4xx}/uncompress.h     |    0
 arch/arm/mach-ixp4xx/include/mach/entry-macro.S    |   41 -
 arch/arm/mach-ixp4xx/include/mach/hardware.h       |   36 -
 arch/arm/mach-ixp4xx/include/mach/io.h             |  502 ------
 arch/arm/mach-ixp4xx/include/mach/platform.h       |  175 --
 arch/arm/mach-ixp4xx/include/mach/timex.h          |   16 -
 arch/arm/mach-ixp4xx/ixdp425-pci.c                 |    2 +-
 arch/arm/mach-ixp4xx/ixdp425-setup.c               |    2 +-
 arch/arm/mach-ixp4xx/ixdpg425-pci.c                |    2 +-
 arch/arm/mach-ixp4xx/ixp4xx_npe.c                  |    2 +-
 arch/arm/mach-ixp4xx/ixp4xx_qmgr.c                 |    2 +-
 arch/arm/mach-ixp4xx/miccpt-pci.c                  |    2 +-
 arch/arm/mach-ixp4xx/wg302v2-pci.c                 |    2 +-
 arch/arm/mach-ixp4xx/wg302v2-setup.c               |    2 +-
 arch/arm/mach-kirkwood/addr-map.c                  |    4 +-
 arch/arm/mach-kirkwood/board-dnskw.c               |    4 +-
 arch/arm/mach-kirkwood/board-dreamplug.c           |    6 +-
 arch/arm/mach-kirkwood/board-dt.c                  |    4 +-
 arch/arm/mach-kirkwood/board-goflexnet.c           |    6 +-
 arch/arm/mach-kirkwood/board-ib62x0.c              |    2 +-
 arch/arm/mach-kirkwood/board-iconnect.c            |    2 +-
 arch/arm/mach-kirkwood/board-lsxl.c                |    2 +-
 arch/arm/mach-kirkwood/board-ts219.c               |    2 +-
 arch/arm/mach-kirkwood/common.c                    |   22 +-
 arch/arm/mach-kirkwood/cpuidle.c                   |    2 +-
 arch/arm/mach-kirkwood/d2net_v2-setup.c            |    4 +-
 arch/arm/mach-kirkwood/db88f6281-bp-setup.c        |    4 +-
 arch/arm/mach-kirkwood/dockstar-setup.c            |    4 +-
 arch/arm/mach-kirkwood/guruplug-setup.c            |    4 +-
 .../include/mach-kirkwood/bridge-regs.h            |   81 +
 .../include/mach-kirkwood/debug-macro.S            |   19 +
 .../include/mach-kirkwood/entry-macro.S            |   34 +
 .../arm/mach-kirkwood/include/mach-kirkwood/gpio.h |    9 +
 .../include/{mach => mach-kirkwood}/hardware.h     |    0
 .../include/{mach => mach-kirkwood}/io.h           |    0
 .../include/{mach => mach-kirkwood}/irqs.h         |    0
 .../include/{mach => mach-kirkwood}/kirkwood.h     |    0
 .../include/{mach => mach-kirkwood}/leds-netxbig.h |    0
 .../include/{mach => mach-kirkwood}/leds-ns2.h     |    0
 .../include/{mach => mach-kirkwood}/timex.h        |    0
 .../include/mach-kirkwood/uncompress.h             |   47 +
 arch/arm/mach-kirkwood/include/mach/bridge-regs.h  |   81 -
 arch/arm/mach-kirkwood/include/mach/debug-macro.S  |   19 -
 arch/arm/mach-kirkwood/include/mach/entry-macro.S  |   34 -
 arch/arm/mach-kirkwood/include/mach/gpio.h         |    9 -
 arch/arm/mach-kirkwood/include/mach/uncompress.h   |   47 -
 arch/arm/mach-kirkwood/irq.c                       |    4 +-
 arch/arm/mach-kirkwood/lacie_v2-common.c           |    6 +-
 arch/arm/mach-kirkwood/mpp.c                       |    4 +-
 arch/arm/mach-kirkwood/mv88f6281gtw_ge-setup.c     |    2 +-
 arch/arm/mach-kirkwood/netspace_v2-setup.c         |    4 +-
 arch/arm/mach-kirkwood/netxbig_v2-setup.c          |    4 +-
 arch/arm/mach-kirkwood/openrd-setup.c              |    4 +-
 arch/arm/mach-kirkwood/pcie.c                      |    6 +-
 arch/arm/mach-kirkwood/rd88f6192-nas-setup.c       |    2 +-
 arch/arm/mach-kirkwood/rd88f6281-setup.c           |    4 +-
 arch/arm/mach-kirkwood/sheevaplug-setup.c          |    4 +-
 arch/arm/mach-kirkwood/t5325-setup.c               |    2 +-
 arch/arm/mach-kirkwood/ts219-setup.c               |    2 +-
 arch/arm/mach-kirkwood/ts41x-setup.c               |    4 +-
 arch/arm/mach-kirkwood/tsx1x-common.c              |    2 +-
 arch/arm/mach-ks8695/board-acs5k.c                 |    4 +-
 arch/arm/mach-ks8695/board-dsm320.c                |    4 +-
 arch/arm/mach-ks8695/board-micrel.c                |    4 +-
 arch/arm/mach-ks8695/cpu.c                         |    6 +-
 arch/arm/mach-ks8695/devices.c                     |   12 +-
 .../mach-ks8695/include/mach-ks8695/debug-macro.S  |   36 +
 .../include/{mach => mach-ks8695}/devices.h        |    0
 .../mach-ks8695/include/mach-ks8695/entry-macro.S  |   47 +
 .../include/{mach => mach-ks8695}/gpio-ks8695.h    |    0
 .../include/{mach => mach-ks8695}/gpio.h           |    0
 .../include/{mach => mach-ks8695}/hardware.h       |    0
 .../include/{mach => mach-ks8695}/irqs.h           |    0
 arch/arm/mach-ks8695/include/mach-ks8695/memory.h  |   55 +
 .../include/{mach => mach-ks8695}/regs-gpio.h      |    0
 .../include/{mach => mach-ks8695}/regs-hpna.h      |    0
 .../include/{mach => mach-ks8695}/regs-irq.h       |    0
 .../include/{mach => mach-ks8695}/regs-lan.h       |    0
 .../include/{mach => mach-ks8695}/regs-mem.h       |    0
 .../include/{mach => mach-ks8695}/regs-misc.h      |    0
 .../include/{mach => mach-ks8695}/regs-pci.h       |    0
 .../include/{mach => mach-ks8695}/regs-switch.h    |    0
 .../include/{mach => mach-ks8695}/regs-sys.h       |    0
 .../include/{mach => mach-ks8695}/regs-timer.h     |    0
 .../include/{mach => mach-ks8695}/regs-uart.h      |    0
 .../include/{mach => mach-ks8695}/regs-wan.h       |    0
 arch/arm/mach-ks8695/include/mach-ks8695/timex.h   |   21 +
 .../mach-ks8695/include/mach-ks8695/uncompress.h   |   37 +
 arch/arm/mach-ks8695/include/mach/debug-macro.S    |   36 -
 arch/arm/mach-ks8695/include/mach/entry-macro.S    |   47 -
 arch/arm/mach-ks8695/include/mach/memory.h         |   55 -
 arch/arm/mach-ks8695/include/mach/timex.h          |   21 -
 arch/arm/mach-ks8695/include/mach/uncompress.h     |   37 -
 arch/arm/mach-ks8695/irq.c                         |    6 +-
 arch/arm/mach-ks8695/leds.c                        |    2 +-
 arch/arm/mach-ks8695/pci.c                         |    6 +-
 arch/arm/mach-ks8695/time.c                        |    4 +-
 .../include/{mach => mach-l7200}/debug-macro.S     |    0
 arch/arm/mach-lpc32xx/clock.c                      |    4 +-
 arch/arm/mach-lpc32xx/common.c                     |    4 +-
 arch/arm/mach-lpc32xx/common.h                     |    2 +-
 .../include/{mach => mach-lpc32xx}/board.h         |    0
 .../include/{mach => mach-lpc32xx}/debug-macro.S   |    0
 .../include/mach-lpc32xx/entry-macro.S             |   37 +
 .../include/{mach => mach-lpc32xx}/gpio-lpc32xx.h  |    0
 .../include/{mach => mach-lpc32xx}/gpio.h          |    0
 .../include/{mach => mach-lpc32xx}/hardware.h      |    0
 .../include/{mach => mach-lpc32xx}/irqs.h          |    0
 .../include/{mach => mach-lpc32xx}/platform.h      |    0
 .../include/{mach => mach-lpc32xx}/timex.h         |    0
 .../mach-lpc32xx/include/mach-lpc32xx/uncompress.h |   60 +
 arch/arm/mach-lpc32xx/include/mach/entry-macro.S   |   37 -
 arch/arm/mach-lpc32xx/include/mach/uncompress.h    |   60 -
 arch/arm/mach-lpc32xx/irq.c                        |    6 +-
 arch/arm/mach-lpc32xx/phy3250.c                    |    8 +-
 arch/arm/mach-lpc32xx/pm.c                         |    4 +-
 arch/arm/mach-lpc32xx/serial.c                     |    4 +-
 arch/arm/mach-lpc32xx/suspend.S                    |    4 +-
 arch/arm/mach-lpc32xx/timer.c                      |    4 +-
 arch/arm/mach-mmp/aspenite.c                       |   10 +-
 arch/arm/mach-mmp/avengers_lite.c                  |    8 +-
 arch/arm/mach-mmp/brownstone.c                     |    8 +-
 arch/arm/mach-mmp/clock.c                          |    2 +-
 arch/arm/mach-mmp/common.c                         |    4 +-
 arch/arm/mach-mmp/devices.c                        |    8 +-
 arch/arm/mach-mmp/flint.c                          |    8 +-
 arch/arm/mach-mmp/gplugd.c                         |    6 +-
 .../mach-mmp/include/{mach => mach-mmp}/addr-map.h |    0
 .../mach-mmp/include/{mach => mach-mmp}/cputype.h  |    0
 arch/arm/mach-mmp/include/mach-mmp/debug-macro.S   |   22 +
 .../mach-mmp/include/{mach => mach-mmp}/devices.h  |    0
 arch/arm/mach-mmp/include/mach-mmp/dma.h           |   13 +
 arch/arm/mach-mmp/include/mach-mmp/entry-macro.S   |   26 +
 arch/arm/mach-mmp/include/mach-mmp/gpio.h          |    8 +
 .../mach-mmp/include/{mach => mach-mmp}/hardware.h |    0
 .../arm/mach-mmp/include/{mach => mach-mmp}/irqs.h |    0
 arch/arm/mach-mmp/include/mach-mmp/mfp-mmp2.h      |  395 +++++
 arch/arm/mach-mmp/include/mach-mmp/mfp-pxa168.h    |  354 +++++
 arch/arm/mach-mmp/include/mach-mmp/mfp-pxa910.h    |  170 ++
 arch/arm/mach-mmp/include/mach-mmp/mfp.h           |   34 +
 arch/arm/mach-mmp/include/mach-mmp/mmp2.h          |  104 ++
 arch/arm/mach-mmp/include/mach-mmp/pm-mmp2.h       |   61 +
 .../include/{mach => mach-mmp}/pm-pxa910.h         |    0
 arch/arm/mach-mmp/include/mach-mmp/pxa168.h        |  136 ++
 arch/arm/mach-mmp/include/mach-mmp/pxa910.h        |   85 +
 arch/arm/mach-mmp/include/mach-mmp/regs-apbc.h     |  119 ++
 arch/arm/mach-mmp/include/mach-mmp/regs-apmu.h     |   48 +
 arch/arm/mach-mmp/include/mach-mmp/regs-icu.h      |   71 +
 arch/arm/mach-mmp/include/mach-mmp/regs-rtc.h      |   23 +
 arch/arm/mach-mmp/include/mach-mmp/regs-smc.h      |   37 +
 arch/arm/mach-mmp/include/mach-mmp/regs-timers.h   |   44 +
 .../mach-mmp/include/{mach => mach-mmp}/regs-usb.h |    0
 .../arm/mach-mmp/include/{mach => mach-mmp}/sram.h |    0
 .../include/{mach => mach-mmp}/teton_bga.h         |    0
 .../mach-mmp/include/{mach => mach-mmp}/timex.h    |    0
 arch/arm/mach-mmp/include/mach-mmp/uncompress.h    |   51 +
 arch/arm/mach-mmp/include/mach/debug-macro.S       |   22 -
 arch/arm/mach-mmp/include/mach/dma.h               |   13 -
 arch/arm/mach-mmp/include/mach/entry-macro.S       |   26 -
 arch/arm/mach-mmp/include/mach/gpio.h              |    8 -
 arch/arm/mach-mmp/include/mach/mfp-mmp2.h          |  395 -----
 arch/arm/mach-mmp/include/mach/mfp-pxa168.h        |  354 -----
 arch/arm/mach-mmp/include/mach/mfp-pxa910.h        |  170 --
 arch/arm/mach-mmp/include/mach/mfp.h               |   34 -
 arch/arm/mach-mmp/include/mach/mmp2.h              |  104 --
 arch/arm/mach-mmp/include/mach/pm-mmp2.h           |   61 -
 arch/arm/mach-mmp/include/mach/pxa168.h            |  136 --
 arch/arm/mach-mmp/include/mach/pxa910.h            |   85 -
 arch/arm/mach-mmp/include/mach/regs-apbc.h         |  119 --
 arch/arm/mach-mmp/include/mach/regs-apmu.h         |   48 -
 arch/arm/mach-mmp/include/mach/regs-icu.h          |   71 -
 arch/arm/mach-mmp/include/mach/regs-rtc.h          |   23 -
 arch/arm/mach-mmp/include/mach/regs-smc.h          |   37 -
 arch/arm/mach-mmp/include/mach/regs-timers.h       |   44 -
 arch/arm/mach-mmp/include/mach/uncompress.h        |   51 -
 arch/arm/mach-mmp/irq.c                            |    6 +-
 arch/arm/mach-mmp/jasper.c                         |    8 +-
 arch/arm/mach-mmp/mmp-dt.c                         |    2 +-
 arch/arm/mach-mmp/mmp2-dt.c                        |    4 +-
 arch/arm/mach-mmp/mmp2.c                           |   18 +-
 arch/arm/mach-mmp/pm-mmp2.c                        |   12 +-
 arch/arm/mach-mmp/pm-pxa910.c                      |   12 +-
 arch/arm/mach-mmp/pxa168.c                         |   20 +-
 arch/arm/mach-mmp/pxa910.c                         |   16 +-
 arch/arm/mach-mmp/sram.c                           |    2 +-
 arch/arm/mach-mmp/tavorevb.c                       |    8 +-
 arch/arm/mach-mmp/teton_bga.c                      |   12 +-
 arch/arm/mach-mmp/time.c                           |   10 +-
 arch/arm/mach-mmp/ttc_dkb.c                        |   10 +-
 arch/arm/mach-msm/acpuclock-arm11.c                |    4 +-
 arch/arm/mach-msm/board-halibut.c                  |    8 +-
 arch/arm/mach-msm/board-mahimahi.c                 |    6 +-
 arch/arm/mach-msm/board-msm7x27.c                  |   10 +-
 arch/arm/mach-msm/board-msm7x30.c                  |    8 +-
 arch/arm/mach-msm/board-msm8960.c                  |    4 +-
 arch/arm/mach-msm/board-msm8x60.c                  |    4 +-
 arch/arm/mach-msm/board-qsd8x50.c                  |   10 +-
 arch/arm/mach-msm/board-sapphire.c                 |    8 +-
 arch/arm/mach-msm/board-trout-mmc.c                |    4 +-
 arch/arm/mach-msm/board-trout-panel.c              |    4 +-
 arch/arm/mach-msm/board-trout.c                    |    6 +-
 arch/arm/mach-msm/board-trout.h                    |    4 +-
 arch/arm/mach-msm/clock-pcom.c                     |    2 +-
 arch/arm/mach-msm/clock.h                          |    2 +-
 arch/arm/mach-msm/devices-iommu.c                  |    4 +-
 arch/arm/mach-msm/devices-msm7x00.c                |    6 +-
 arch/arm/mach-msm/devices-msm7x30.c                |   10 +-
 arch/arm/mach-msm/devices-msm8960.c                |    4 +-
 arch/arm/mach-msm/devices-qsd8x50.c                |   10 +-
 arch/arm/mach-msm/dma.c                            |    2 +-
 arch/arm/mach-msm/gpiomux-v2.c                     |    2 +-
 arch/arm/mach-msm/gpiomux.h                        |    2 +-
 arch/arm/mach-msm/include/mach-msm/board.h         |   56 +
 arch/arm/mach-msm/include/{mach => mach-msm}/clk.h |    0
 arch/arm/mach-msm/include/{mach => mach-msm}/cpu.h |    0
 arch/arm/mach-msm/include/mach-msm/debug-macro.S   |   65 +
 arch/arm/mach-msm/include/mach-msm/dma.h           |  177 +++
 arch/arm/mach-msm/include/mach-msm/entry-macro.S   |   36 +
 .../mach => mach-msm/include/mach-msm}/gpio.h      |    0
 .../mach-msm/include/{mach => mach-msm}/hardware.h |    0
 .../mach-msm/include/{mach => mach-msm}/iommu.h    |    0
 .../include/{mach => mach-msm}/iommu_hw-8xxx.h     |    0
 .../include/{mach => mach-msm}/irqs-7x00.h         |    0
 .../include/{mach => mach-msm}/irqs-7x30.h         |    0
 .../include/{mach => mach-msm}/irqs-8960.h         |    0
 .../include/{mach => mach-msm}/irqs-8x50.h         |    0
 .../include/{mach => mach-msm}/irqs-8x60.h         |    0
 .../arm/mach-msm/include/{mach => mach-msm}/irqs.h |    0
 arch/arm/mach-msm/include/{mach => mach-msm}/mmc.h |    0
 .../mach-msm/include/{mach => mach-msm}/msm_fb.h   |    0
 .../include/{mach => mach-msm}/msm_gpiomux.h       |    0
 .../include/{mach => mach-msm}/msm_iomap-7x00.h    |    0
 .../include/{mach => mach-msm}/msm_iomap-7x30.h    |    0
 .../include/{mach => mach-msm}/msm_iomap-8960.h    |    0
 .../include/{mach => mach-msm}/msm_iomap-8x50.h    |    0
 .../include/{mach => mach-msm}/msm_iomap-8x60.h    |    0
 .../include/{mach => mach-msm}/msm_iomap.h         |    0
 .../mach-msm/include/{mach => mach-msm}/msm_smd.h  |    0
 arch/arm/mach-msm/include/mach-msm/sirc.h          |   98 ++
 .../mach-msm/include/{mach => mach-msm}/system.h   |    0
 .../mach-msm/include/{mach => mach-msm}/timex.h    |    0
 arch/arm/mach-msm/include/mach-msm/uncompress.h    |   67 +
 .../arm/mach-msm/include/{mach => mach-msm}/vreg.h |    0
 arch/arm/mach-msm/include/mach/board.h             |   56 -
 arch/arm/mach-msm/include/mach/debug-macro.S       |   65 -
 arch/arm/mach-msm/include/mach/dma.h               |  177 ---
 arch/arm/mach-msm/include/mach/entry-macro.S       |   36 -
 arch/arm/mach-msm/include/mach/sirc.h              |   98 --
 arch/arm/mach-msm/include/mach/uncompress.h        |   67 -
 arch/arm/mach-msm/io.c                             |    6 +-
 arch/arm/mach-msm/irq-vic.c                        |    4 +-
 arch/arm/mach-msm/irq.c                            |    4 +-
 arch/arm/mach-msm/platsmp.c                        |    2 +-
 arch/arm/mach-msm/proc_comm.c                      |    4 +-
 arch/arm/mach-msm/smd.c                            |    4 +-
 arch/arm/mach-msm/smd_debug.c                      |    2 +-
 arch/arm/mach-msm/smd_private.h                    |    2 +-
 arch/arm/mach-msm/timer.c                          |    6 +-
 arch/arm/mach-msm/vreg.c                           |    2 +-
 arch/arm/mach-mv78xx0/addr-map.c                   |    2 +-
 arch/arm/mach-mv78xx0/buffalo-wxl-setup.c          |    2 +-
 arch/arm/mach-mv78xx0/common.c                     |   16 +-
 arch/arm/mach-mv78xx0/db78x00-bp-setup.c           |    2 +-
 .../include/mach-mv78xx0/bridge-regs.h             |   36 +
 .../include/mach-mv78xx0/debug-macro.S             |   19 +
 .../include/mach-mv78xx0/entry-macro.S             |   41 +
 arch/arm/mach-mv78xx0/include/mach-mv78xx0/gpio.h  |    9 +
 .../include/{mach => mach-mv78xx0}/hardware.h      |    0
 .../include/{mach => mach-mv78xx0}/io.h            |    0
 .../include/{mach => mach-mv78xx0}/irqs.h          |    0
 .../include/{mach => mach-mv78xx0}/mv78xx0.h       |    0
 .../include/{mach => mach-mv78xx0}/timex.h         |    0
 .../mach-mv78xx0/include/mach-mv78xx0/uncompress.h |   47 +
 arch/arm/mach-mv78xx0/include/mach/bridge-regs.h   |   36 -
 arch/arm/mach-mv78xx0/include/mach/debug-macro.S   |   19 -
 arch/arm/mach-mv78xx0/include/mach/entry-macro.S   |   41 -
 arch/arm/mach-mv78xx0/include/mach/gpio.h          |    9 -
 arch/arm/mach-mv78xx0/include/mach/uncompress.h    |   47 -
 arch/arm/mach-mv78xx0/irq.c                        |    4 +-
 arch/arm/mach-mv78xx0/mpp.c                        |    4 +-
 arch/arm/mach-mv78xx0/pcie.c                       |    4 +-
 arch/arm/mach-mv78xx0/rd78x00-masa-setup.c         |    2 +-
 arch/arm/mach-mvebu/armada-370-xp.c                |    2 +-
 .../include/{mach => mach-mvebu}/armada-370-xp.h   |    0
 .../mach-mvebu/include/mach-mvebu/debug-macro.S    |   24 +
 .../include/{mach => mach-mvebu}/timex.h           |    0
 .../arm/mach-mvebu/include/mach-mvebu/uncompress.h |   43 +
 arch/arm/mach-mvebu/include/mach/debug-macro.S     |   24 -
 arch/arm/mach-mvebu/include/mach/uncompress.h      |   43 -
 arch/arm/mach-mxs/devices-mx23.h                   |    4 +-
 arch/arm/mach-mxs/devices-mx28.h                   |    4 +-
 arch/arm/mach-mxs/devices/platform-auart.c         |    6 +-
 arch/arm/mach-mxs/devices/platform-dma.c           |    6 +-
 arch/arm/mach-mxs/devices/platform-fec.c           |    4 +-
 arch/arm/mach-mxs/devices/platform-flexcan.c       |    4 +-
 arch/arm/mach-mxs/devices/platform-gpio-mxs.c      |    6 +-
 arch/arm/mach-mxs/devices/platform-gpmi-nand.c     |    6 +-
 arch/arm/mach-mxs/devices/platform-mxs-i2c.c       |    4 +-
 arch/arm/mach-mxs/devices/platform-mxs-mmc.c       |    6 +-
 arch/arm/mach-mxs/devices/platform-mxs-pwm.c       |    2 +-
 arch/arm/mach-mxs/devices/platform-mxs-saif.c      |    6 +-
 arch/arm/mach-mxs/devices/platform-mxsfb.c         |    6 +-
 arch/arm/mach-mxs/devices/platform-rtc-stmp3xxx.c  |    6 +-
 arch/arm/mach-mxs/icoll.c                          |    4 +-
 .../mach-mxs/include/{mach => mach-mxs}/common.h   |    0
 arch/arm/mach-mxs/include/mach-mxs/debug-macro.S   |   30 +
 .../include/{mach => mach-mxs}/devices-common.h    |    0
 .../mach-mxs/include/{mach => mach-mxs}/digctl.h   |    0
 arch/arm/mach-mxs/include/mach-mxs/entry-macro.S   |   35 +
 .../mach => mach-mxs/include/mach-mxs}/gpio.h      |    0
 .../mach-mxs/include/{mach => mach-mxs}/hardware.h |    0
 arch/arm/mach-mxs/include/mach-mxs/iomux-mx23.h    |  355 +++++
 arch/arm/mach-mxs/include/mach-mxs/iomux-mx28.h    |  537 +++++++
 .../mach-mxs/include/{mach => mach-mxs}/iomux.h    |    0
 .../arm/mach-mxs/include/{mach => mach-mxs}/irqs.h |    0
 arch/arm/mach-mxs/include/mach-mxs/mx23.h          |  169 ++
 arch/arm/mach-mxs/include/mach-mxs/mx28.h          |  225 +++
 arch/arm/mach-mxs/include/mach-mxs/mxs.h           |  117 ++
 .../mach-mxs/include/{mach => mach-mxs}/timex.h    |    0
 .../include/{mach => mach-mxs}/uncompress.h        |    0
 arch/arm/mach-mxs/include/mach/debug-macro.S       |   30 -
 arch/arm/mach-mxs/include/mach/entry-macro.S       |   35 -
 arch/arm/mach-mxs/include/mach/iomux-mx23.h        |  355 -----
 arch/arm/mach-mxs/include/mach/iomux-mx28.h        |  537 -------
 arch/arm/mach-mxs/include/mach/mx23.h              |  169 --
 arch/arm/mach-mxs/include/mach/mx28.h              |  225 ---
 arch/arm/mach-mxs/include/mach/mxs.h               |  117 --
 arch/arm/mach-mxs/iomux.c                          |    4 +-
 arch/arm/mach-mxs/mach-apx4devkit.c                |    6 +-
 arch/arm/mach-mxs/mach-m28evk.c                    |    4 +-
 arch/arm/mach-mxs/mach-mx23evk.c                   |    4 +-
 arch/arm/mach-mxs/mach-mx28evk.c                   |    6 +-
 arch/arm/mach-mxs/mach-mxs.c                       |    2 +-
 arch/arm/mach-mxs/mach-stmp378x_devb.c             |    4 +-
 arch/arm/mach-mxs/mach-tx28.c                      |    4 +-
 arch/arm/mach-mxs/mm.c                             |    8 +-
 arch/arm/mach-mxs/module-tx28.c                    |    2 +-
 arch/arm/mach-mxs/ocotp.c                          |    2 +-
 arch/arm/mach-mxs/system.c                         |    4 +-
 arch/arm/mach-mxs/timer.c                          |    4 +-
 arch/arm/mach-netx/fb.c                            |    4 +-
 arch/arm/mach-netx/generic.c                       |    4 +-
 .../include/{mach => mach-netx}/debug-macro.S      |    0
 .../mach-netx/include/{mach => mach-netx}/eth.h    |    0
 .../include/{mach => mach-netx}/hardware.h         |    0
 .../mach-netx/include/{mach => mach-netx}/irqs.h   |    0
 .../include/{mach => mach-netx}/netx-regs.h        |    0
 .../mach-netx/include/{mach => mach-netx}/param.h  |    0
 .../mach-netx/include/{mach => mach-netx}/pfifo.h  |    0
 .../mach-netx/include/{mach => mach-netx}/timex.h  |    0
 .../include/{mach => mach-netx}/uncompress.h       |    0
 .../arm/mach-netx/include/{mach => mach-netx}/xc.h |    0
 arch/arm/mach-netx/nxdb500.c                       |    6 +-
 arch/arm/mach-netx/nxdkn.c                         |    6 +-
 arch/arm/mach-netx/nxeb500hmi.c                    |    6 +-
 arch/arm/mach-netx/pfifo.c                         |    6 +-
 arch/arm/mach-netx/time.c                          |    4 +-
 arch/arm/mach-netx/xc.c                            |    8 +-
 arch/arm/mach-nomadik/board-nhk8815.c              |    8 +-
 arch/arm/mach-nomadik/cpu-8815.c                   |    6 +-
 arch/arm/mach-nomadik/i2c-8815nhk.c                |    4 +-
 .../include/{mach => mach-nomadik}/debug-macro.S   |    0
 arch/arm/mach-nomadik/include/mach-nomadik/fsmc.h  |   29 +
 .../include/{mach => mach-nomadik}/gpio.h          |    0
 .../include/{mach => mach-nomadik}/hardware.h      |    0
 arch/arm/mach-nomadik/include/mach-nomadik/irqs.h  |   81 +
 .../include/{mach => mach-nomadik}/nand.h          |    0
 .../include/{mach => mach-nomadik}/timex.h         |    0
 .../mach-nomadik/include/mach-nomadik/uncompress.h |   63 +
 arch/arm/mach-nomadik/include/mach/fsmc.h          |   29 -
 arch/arm/mach-nomadik/include/mach/irqs.h          |   81 -
 arch/arm/mach-nomadik/include/mach/uncompress.h    |   63 -
 arch/arm/mach-omap1/ams-delta-fiq-handler.S        |    4 +-
 arch/arm/mach-omap1/ams-delta-fiq.c                |    4 +-
 arch/arm/mach-omap1/board-ams-delta.c              |   18 +-
 arch/arm/mach-omap1/board-fsample.c                |   16 +-
 arch/arm/mach-omap1/board-generic.c                |    8 +-
 arch/arm/mach-omap1/board-h2-mmc.c                 |    2 +-
 arch/arm/mach-omap1/board-h2.c                     |   18 +-
 arch/arm/mach-omap1/board-h3-mmc.c                 |    2 +-
 arch/arm/mach-omap1/board-h3.c                     |   18 +-
 arch/arm/mach-omap1/board-htcherald.c              |   12 +-
 arch/arm/mach-omap1/board-innovator.c              |   18 +-
 arch/arm/mach-omap1/board-nokia770.c               |   18 +-
 arch/arm/mach-omap1/board-osk.c                    |   12 +-
 arch/arm/mach-omap1/board-palmte.c                 |   18 +-
 arch/arm/mach-omap1/board-palmtt.c                 |   22 +-
 arch/arm/mach-omap1/board-palmz71.c                |   20 +-
 arch/arm/mach-omap1/board-perseus2.c               |   16 +-
 arch/arm/mach-omap1/board-sx1-mmc.c                |    6 +-
 arch/arm/mach-omap1/board-sx1.c                    |   22 +-
 arch/arm/mach-omap1/board-voiceblue.c              |   16 +-
 arch/arm/mach-omap1/clock.c                        |   12 +-
 arch/arm/mach-omap1/clock.h                        |    2 +-
 arch/arm/mach-omap1/clock_data.c                   |   16 +-
 arch/arm/mach-omap1/common.h                       |    2 +-
 arch/arm/mach-omap1/devices.c                      |   18 +-
 arch/arm/mach-omap1/dma.c                          |    6 +-
 arch/arm/mach-omap1/flash.c                        |    6 +-
 arch/arm/mach-omap1/fpga.c                         |    4 +-
 arch/arm/mach-omap1/i2c.c                          |    6 +-
 arch/arm/mach-omap1/id.c                           |    4 +-
 .../mach-omap1/include/mach-omap1/ams-delta-fiq.h  |   79 +
 .../include/{mach => mach-omap1}/camera.h          |    0
 .../mach-omap1/include/mach-omap1/debug-macro.S    |  101 ++
 .../mach-omap1/include/mach-omap1/entry-macro.S    |   41 +
 arch/arm/mach-omap1/include/mach-omap1/gpio.h      |    5 +
 arch/arm/mach-omap1/include/mach-omap1/hardware.h  |   41 +
 .../mach-omap1/include/{mach => mach-omap1}/io.h   |    0
 arch/arm/mach-omap1/include/mach-omap1/irqs.h      |    5 +
 .../include/{mach => mach-omap1}/lcd_dma.h         |    0
 .../mach-omap1/include/{mach => mach-omap1}/lcdc.h |    0
 arch/arm/mach-omap1/include/mach-omap1/memory.h    |   57 +
 arch/arm/mach-omap1/include/mach-omap1/mtd-xip.h   |   61 +
 arch/arm/mach-omap1/include/mach-omap1/smp.h       |    5 +
 arch/arm/mach-omap1/include/mach-omap1/timex.h     |    5 +
 .../arm/mach-omap1/include/mach-omap1/uncompress.h |    5 +
 .../mach-omap1/include/{mach => mach-omap1}/usb.h  |    0
 arch/arm/mach-omap1/include/mach/ams-delta-fiq.h   |   79 -
 arch/arm/mach-omap1/include/mach/debug-macro.S     |  101 --
 arch/arm/mach-omap1/include/mach/entry-macro.S     |   41 -
 arch/arm/mach-omap1/include/mach/gpio.h            |    5 -
 arch/arm/mach-omap1/include/mach/hardware.h        |   41 -
 arch/arm/mach-omap1/include/mach/irqs.h            |    5 -
 arch/arm/mach-omap1/include/mach/memory.h          |   57 -
 arch/arm/mach-omap1/include/mach/mtd-xip.h         |   61 -
 arch/arm/mach-omap1/include/mach/smp.h             |    5 -
 arch/arm/mach-omap1/include/mach/timex.h           |    5 -
 arch/arm/mach-omap1/include/mach/uncompress.h      |    5 -
 arch/arm/mach-omap1/io.c                           |    6 +-
 arch/arm/mach-omap1/irq.c                          |    4 +-
 arch/arm/mach-omap1/lcd_dma.c                      |    6 +-
 arch/arm/mach-omap1/leds-h2p2-debug.c              |    4 +-
 arch/arm/mach-omap1/leds-innovator.c               |    2 +-
 arch/arm/mach-omap1/leds-osk.c                     |    2 +-
 arch/arm/mach-omap1/leds.c                         |    2 +-
 arch/arm/mach-omap1/mailbox.c                      |    2 +-
 arch/arm/mach-omap1/mcbsp.c                        |   10 +-
 arch/arm/mach-omap1/mux.c                          |    4 +-
 arch/arm/mach-omap1/ocpi.c                         |    2 +-
 arch/arm/mach-omap1/opp_data.c                     |    2 +-
 arch/arm/mach-omap1/pm.c                           |   18 +-
 arch/arm/mach-omap1/pm_bus.c                       |    4 +-
 arch/arm/mach-omap1/reset.c                        |    4 +-
 arch/arm/mach-omap1/serial.c                       |    6 +-
 arch/arm/mach-omap1/sram.S                         |    2 +-
 arch/arm/mach-omap1/time.c                         |    2 +-
 arch/arm/mach-omap1/timer.c                        |    4 +-
 arch/arm/mach-omap1/timer32k.c                     |    4 +-
 arch/arm/mach-omap1/usb.c                          |    4 +-
 arch/arm/mach-omap2/am35xx-emac.c                  |    4 +-
 arch/arm/mach-omap2/board-2430sdp.c                |   10 +-
 arch/arm/mach-omap2/board-3430sdp.c                |   14 +-
 arch/arm/mach-omap2/board-3630sdp.c                |    8 +-
 arch/arm/mach-omap2/board-4430sdp.c                |   10 +-
 arch/arm/mach-omap2/board-am3517crane.c            |    6 +-
 arch/arm/mach-omap2/board-am3517evm.c              |    8 +-
 arch/arm/mach-omap2/board-apollon.c                |    8 +-
 arch/arm/mach-omap2/board-cm-t35.c                 |   14 +-
 arch/arm/mach-omap2/board-cm-t3517.c               |   10 +-
 arch/arm/mach-omap2/board-devkit8000.c             |   14 +-
 arch/arm/mach-omap2/board-flash.c                  |   10 +-
 arch/arm/mach-omap2/board-flash.h                  |    2 +-
 arch/arm/mach-omap2/board-generic.c                |    4 +-
 arch/arm/mach-omap2/board-h4.c                     |   10 +-
 arch/arm/mach-omap2/board-igep0020.c               |   10 +-
 arch/arm/mach-omap2/board-ldp.c                    |   14 +-
 arch/arm/mach-omap2/board-n8x0.c                   |   14 +-
 arch/arm/mach-omap2/board-omap3beagle.c            |   12 +-
 arch/arm/mach-omap2/board-omap3evm.c               |   12 +-
 arch/arm/mach-omap2/board-omap3logic.c             |   14 +-
 arch/arm/mach-omap2/board-omap3pandora.c           |   10 +-
 arch/arm/mach-omap2/board-omap3stalker.c           |   14 +-
 arch/arm/mach-omap2/board-omap3touchbook.c         |   12 +-
 arch/arm/mach-omap2/board-omap4panda.c             |    8 +-
 arch/arm/mach-omap2/board-overo.c                  |   16 +-
 arch/arm/mach-omap2/board-rm680.c                  |   10 +-
 arch/arm/mach-omap2/board-rx51-peripherals.c       |   14 +-
 arch/arm/mach-omap2/board-rx51-video.c             |    6 +-
 arch/arm/mach-omap2/board-rx51.c                   |   12 +-
 arch/arm/mach-omap2/board-ti8168evm.c              |    8 +-
 arch/arm/mach-omap2/board-zoom-debugboard.c        |    6 +-
 arch/arm/mach-omap2/board-zoom-display.c           |    4 +-
 arch/arm/mach-omap2/board-zoom-peripherals.c       |    4 +-
 arch/arm/mach-omap2/board-zoom.c                   |    6 +-
 arch/arm/mach-omap2/clkt2xxx_apll.c                |    4 +-
 arch/arm/mach-omap2/clkt2xxx_dpll.c                |    2 +-
 arch/arm/mach-omap2/clkt2xxx_dpllcore.c            |    6 +-
 arch/arm/mach-omap2/clkt2xxx_osc.c                 |    2 +-
 arch/arm/mach-omap2/clkt2xxx_sys.c                 |    2 +-
 arch/arm/mach-omap2/clkt2xxx_virt_prcm_set.c       |    8 +-
 arch/arm/mach-omap2/clkt34xx_dpll3m2.c             |    6 +-
 arch/arm/mach-omap2/clkt_clksel.c                  |    2 +-
 arch/arm/mach-omap2/clkt_dpll.c                    |    4 +-
 arch/arm/mach-omap2/clkt_iclk.c                    |    4 +-
 arch/arm/mach-omap2/clock.c                        |    6 +-
 arch/arm/mach-omap2/clock.h                        |    2 +-
 arch/arm/mach-omap2/clock2420_data.c               |    4 +-
 arch/arm/mach-omap2/clock2430.c                    |    4 +-
 arch/arm/mach-omap2/clock2430_data.c               |    4 +-
 arch/arm/mach-omap2/clock2xxx.c                    |    4 +-
 arch/arm/mach-omap2/clock33xx_data.c               |    4 +-
 arch/arm/mach-omap2/clock34xx.c                    |    2 +-
 arch/arm/mach-omap2/clock3517.c                    |    2 +-
 arch/arm/mach-omap2/clock36xx.c                    |    2 +-
 arch/arm/mach-omap2/clock3xxx.c                    |    4 +-
 arch/arm/mach-omap2/clock3xxx_data.c               |    4 +-
 arch/arm/mach-omap2/clock44xx_data.c               |    4 +-
 arch/arm/mach-omap2/clockdomain.c                  |    2 +-
 arch/arm/mach-omap2/clockdomain.h                  |    6 +-
 arch/arm/mach-omap2/clockdomain2xxx_3xxx.c         |    2 +-
 arch/arm/mach-omap2/cm2xxx_3xxx.c                  |    2 +-
 arch/arm/mach-omap2/cm33xx.c                       |    2 +-
 arch/arm/mach-omap2/common-board-devices.c         |    4 +-
 arch/arm/mach-omap2/common.c                       |    8 +-
 arch/arm/mach-omap2/common.h                       |    2 +-
 arch/arm/mach-omap2/control.c                      |    4 +-
 arch/arm/mach-omap2/control.h                      |   10 +-
 arch/arm/mach-omap2/cpuidle34xx.c                  |    4 +-
 arch/arm/mach-omap2/devices.c                      |   18 +-
 arch/arm/mach-omap2/display.c                      |    6 +-
 arch/arm/mach-omap2/dma.c                          |    6 +-
 arch/arm/mach-omap2/dpll3xxx.c                     |    4 +-
 arch/arm/mach-omap2/dpll44xx.c                     |    4 +-
 arch/arm/mach-omap2/drm.c                          |    4 +-
 arch/arm/mach-omap2/dsp.c                          |    4 +-
 arch/arm/mach-omap2/emu.c                          |    2 +-
 arch/arm/mach-omap2/gpio.c                         |    6 +-
 arch/arm/mach-omap2/gpmc-nand.c                    |    8 +-
 arch/arm/mach-omap2/gpmc-onenand.c                 |    8 +-
 arch/arm/mach-omap2/gpmc-smc91x.c                  |    6 +-
 arch/arm/mach-omap2/gpmc-smsc911x.c                |    6 +-
 arch/arm/mach-omap2/gpmc.c                         |    4 +-
 arch/arm/mach-omap2/hdq1w.c                        |    6 +-
 arch/arm/mach-omap2/hsmmc.c                        |   10 +-
 arch/arm/mach-omap2/hwspinlock.c                   |    4 +-
 arch/arm/mach-omap2/i2c.c                          |    6 +-
 arch/arm/mach-omap2/id.c                           |    4 +-
 .../include/{mach => mach-omap2}/am35xx.h          |    0
 .../include/{mach => mach-omap2}/barriers.h        |    0
 .../include/{mach => mach-omap2}/board-rx51.h      |    0
 .../include/{mach => mach-omap2}/board-zoom.h      |    0
 .../{mach => mach-omap2}/ctrl_module_core_44xx.h   |    0
 .../ctrl_module_pad_core_44xx.h                    |    0
 .../ctrl_module_pad_wkup_44xx.h                    |    0
 .../{mach => mach-omap2}/ctrl_module_wkup_44xx.h   |    0
 .../mach-omap2/include/mach-omap2/debug-macro.S    |  165 ++
 arch/arm/mach-omap2/include/mach-omap2/gpio.h      |    5 +
 arch/arm/mach-omap2/include/mach-omap2/hardware.h  |    5 +
 .../mach-omap2/include/{mach => mach-omap2}/id.h   |    0
 arch/arm/mach-omap2/include/mach-omap2/irqs.h      |    5 +
 .../include/{mach => mach-omap2}/omap-secure.h     |    0
 .../include/{mach => mach-omap2}/omap-wakeupgen.h  |    0
 arch/arm/mach-omap2/include/mach-omap2/smp.h       |    5 +
 arch/arm/mach-omap2/include/mach-omap2/timex.h     |    5 +
 .../arm/mach-omap2/include/mach-omap2/uncompress.h |    5 +
 arch/arm/mach-omap2/include/mach/debug-macro.S     |  165 --
 arch/arm/mach-omap2/include/mach/gpio.h            |    5 -
 arch/arm/mach-omap2/include/mach/hardware.h        |    5 -
 arch/arm/mach-omap2/include/mach/irqs.h            |    5 -
 arch/arm/mach-omap2/include/mach/smp.h             |    5 -
 arch/arm/mach-omap2/include/mach/timex.h           |    5 -
 arch/arm/mach-omap2/include/mach/uncompress.h      |    5 -
 arch/arm/mach-omap2/io.c                           |   14 +-
 arch/arm/mach-omap2/iommu2.c                       |    2 +-
 arch/arm/mach-omap2/irq.c                          |    2 +-
 arch/arm/mach-omap2/mailbox.c                      |    4 +-
 arch/arm/mach-omap2/mcbsp.c                        |   10 +-
 arch/arm/mach-omap2/msdi.c                         |    6 +-
 arch/arm/mach-omap2/mux.c                          |    2 +-
 arch/arm/mach-omap2/omap-hotplug.c                 |    2 +-
 arch/arm/mach-omap2/omap-iommu.c                   |    4 +-
 arch/arm/mach-omap2/omap-mpuss-lowpower.c          |    2 +-
 arch/arm/mach-omap2/omap-secure.c                  |    4 +-
 arch/arm/mach-omap2/omap-smp.c                     |    6 +-
 arch/arm/mach-omap2/omap-wakeupgen.c               |    4 +-
 arch/arm/mach-omap2/omap4-common.c                 |   12 +-
 arch/arm/mach-omap2/omap_hwmod.c                   |    8 +-
 arch/arm/mach-omap2/omap_hwmod_2420_data.c         |   24 +-
 arch/arm/mach-omap2/omap_hwmod_2430_data.c         |   24 +-
 .../omap_hwmod_2xxx_3xxx_interconnect_data.c       |    4 +-
 .../mach-omap2/omap_hwmod_2xxx_3xxx_ipblock_data.c |   12 +-
 .../mach-omap2/omap_hwmod_2xxx_interconnect_data.c |    8 +-
 arch/arm/mach-omap2/omap_hwmod_2xxx_ipblock_data.c |   16 +-
 arch/arm/mach-omap2/omap_hwmod_3xxx_data.c         |   28 +-
 arch/arm/mach-omap2/omap_hwmod_44xx_data.c         |   20 +-
 arch/arm/mach-omap2/omap_hwmod_common_data.c       |    2 +-
 arch/arm/mach-omap2/omap_hwmod_common_data.h       |    2 +-
 arch/arm/mach-omap2/omap_opp_data.h                |    2 +-
 arch/arm/mach-omap2/omap_phy_internal.c            |    2 +-
 arch/arm/mach-omap2/opp.c                          |    2 +-
 arch/arm/mach-omap2/opp2420_data.c                 |    2 +-
 arch/arm/mach-omap2/opp2430_data.c                 |    2 +-
 arch/arm/mach-omap2/opp3xxx_data.c                 |    2 +-
 arch/arm/mach-omap2/opp4xxx_data.c                 |    2 +-
 arch/arm/mach-omap2/pm-debug.c                     |    8 +-
 arch/arm/mach-omap2/pm.c                           |    4 +-
 arch/arm/mach-omap2/pm24xx.c                       |   10 +-
 arch/arm/mach-omap2/pm34xx.c                       |   10 +-
 arch/arm/mach-omap2/powerdomain.c                  |    4 +-
 arch/arm/mach-omap2/powerdomain.h                  |    2 +-
 arch/arm/mach-omap2/powerdomain2xxx_3xxx.c         |    2 +-
 arch/arm/mach-omap2/powerdomain33xx.c              |    2 +-
 arch/arm/mach-omap2/powerdomain44xx.c              |    2 +-
 arch/arm/mach-omap2/powerdomains3xxx_data.c        |    2 +-
 arch/arm/mach-omap2/prcm.c                         |    4 +-
 arch/arm/mach-omap2/prm2xxx_3xxx.c                 |    6 +-
 arch/arm/mach-omap2/prm33xx.c                      |    2 +-
 arch/arm/mach-omap2/prm44xx.c                      |    6 +-
 arch/arm/mach-omap2/prm_common.c                   |    6 +-
 arch/arm/mach-omap2/sdram-hynix-h8mbx00u0mer-0em.h |    2 +-
 arch/arm/mach-omap2/sdram-micron-mt46h32m32lf-6.h  |    2 +-
 arch/arm/mach-omap2/sdram-nokia.c                  |    4 +-
 arch/arm/mach-omap2/sdram-numonyx-m65kxxxxam.h     |    2 +-
 .../mach-omap2/sdram-qimonda-hyb18m512160af-6.h    |    2 +-
 arch/arm/mach-omap2/sdrc.c                         |    6 +-
 arch/arm/mach-omap2/sdrc.h                         |    2 +-
 arch/arm/mach-omap2/sdrc2xxx.c                     |    8 +-
 arch/arm/mach-omap2/serial.c                       |   12 +-
 arch/arm/mach-omap2/sleep24xx.S                    |    2 +-
 arch/arm/mach-omap2/sleep34xx.S                    |    4 +-
 arch/arm/mach-omap2/sleep44xx.S                    |    4 +-
 arch/arm/mach-omap2/sr_device.c                    |    2 +-
 arch/arm/mach-omap2/sram242x.S                     |    2 +-
 arch/arm/mach-omap2/sram243x.S                     |    2 +-
 arch/arm/mach-omap2/sram34xx.S                     |    2 +-
 arch/arm/mach-omap2/timer.c                        |    8 +-
 arch/arm/mach-omap2/twl-common.c                   |    4 +-
 arch/arm/mach-omap2/twl-common.h                   |    2 +-
 arch/arm/mach-omap2/usb-host.c                     |    8 +-
 arch/arm/mach-omap2/usb-musb.c                     |   10 +-
 arch/arm/mach-omap2/usb-tusb6010.c                 |    2 +-
 arch/arm/mach-omap2/vc.c                           |    2 +-
 arch/arm/mach-omap2/voltage.h                      |    2 +-
 arch/arm/mach-omap2/voltagedomains3xxx_data.c      |    2 +-
 arch/arm/mach-omap2/wd_timer.c                     |    2 +-
 arch/arm/mach-omap2/wd_timer.h                     |    2 +-
 arch/arm/mach-orion5x/addr-map.c                   |    4 +-
 arch/arm/mach-orion5x/common.c                     |   16 +-
 arch/arm/mach-orion5x/d2net-setup.c                |    2 +-
 arch/arm/mach-orion5x/db88f5281-setup.c            |    4 +-
 arch/arm/mach-orion5x/dns323-setup.c               |    2 +-
 arch/arm/mach-orion5x/edmini_v2-setup.c            |    2 +-
 .../include/mach-orion5x/bridge-regs.h             |   39 +
 .../include/mach-orion5x/debug-macro.S             |   21 +
 .../include/mach-orion5x/entry-macro.S             |   25 +
 arch/arm/mach-orion5x/include/mach-orion5x/gpio.h  |    9 +
 .../include/{mach => mach-orion5x}/hardware.h      |    0
 arch/arm/mach-orion5x/include/mach-orion5x/io.h    |   22 +
 .../include/{mach => mach-orion5x}/irqs.h          |    0
 .../include/{mach => mach-orion5x}/orion5x.h       |    0
 .../include/{mach => mach-orion5x}/timex.h         |    0
 .../mach-orion5x/include/mach-orion5x/uncompress.h |   49 +
 arch/arm/mach-orion5x/include/mach/bridge-regs.h   |   39 -
 arch/arm/mach-orion5x/include/mach/debug-macro.S   |   21 -
 arch/arm/mach-orion5x/include/mach/entry-macro.S   |   25 -
 arch/arm/mach-orion5x/include/mach/gpio.h          |    9 -
 arch/arm/mach-orion5x/include/mach/io.h            |   22 -
 arch/arm/mach-orion5x/include/mach/uncompress.h    |   49 -
 arch/arm/mach-orion5x/irq.c                        |    4 +-
 arch/arm/mach-orion5x/kurobox_pro-setup.c          |    4 +-
 arch/arm/mach-orion5x/ls-chl-setup.c               |    2 +-
 arch/arm/mach-orion5x/ls_hgl-setup.c               |    2 +-
 arch/arm/mach-orion5x/lsmini-setup.c               |    2 +-
 arch/arm/mach-orion5x/mpp.c                        |    4 +-
 arch/arm/mach-orion5x/mss2-setup.c                 |    4 +-
 arch/arm/mach-orion5x/mv2120-setup.c               |    2 +-
 arch/arm/mach-orion5x/net2big-setup.c              |    2 +-
 arch/arm/mach-orion5x/pci.c                        |    6 +-
 arch/arm/mach-orion5x/rd88f5181l-fxo-setup.c       |    2 +-
 arch/arm/mach-orion5x/rd88f5181l-ge-setup.c        |    2 +-
 arch/arm/mach-orion5x/rd88f5182-setup.c            |    2 +-
 arch/arm/mach-orion5x/rd88f6183ap-ge-setup.c       |    2 +-
 arch/arm/mach-orion5x/terastation_pro2-setup.c     |    2 +-
 arch/arm/mach-orion5x/ts209-setup.c                |    2 +-
 arch/arm/mach-orion5x/ts409-setup.c                |    2 +-
 arch/arm/mach-orion5x/ts78xx-setup.c               |    2 +-
 arch/arm/mach-orion5x/tsx09-common.c               |    2 +-
 arch/arm/mach-orion5x/wnr854t-setup.c              |    2 +-
 arch/arm/mach-orion5x/wrt350n-v2-setup.c           |    2 +-
 arch/arm/mach-picoxcell/common.c                   |    4 +-
 .../include/mach-picoxcell/debug-macro.S           |   35 +
 .../include/mach-picoxcell}/gpio.h                 |    0
 .../include/mach-picoxcell/hardware.h              |   21 +
 .../include/{mach => mach-picoxcell}/map.h         |    0
 .../{mach => mach-picoxcell}/picoxcell_soc.h       |    0
 .../include/{mach => mach-picoxcell}/timex.h       |    0
 .../include/{mach => mach-picoxcell}/uncompress.h  |    0
 arch/arm/mach-picoxcell/include/mach/debug-macro.S |   35 -
 arch/arm/mach-picoxcell/include/mach/hardware.h    |   21 -
 arch/arm/mach-pnx4008/clock.c                      |    4 +-
 arch/arm/mach-pnx4008/core.c                       |    8 +-
 arch/arm/mach-pnx4008/dma.c                        |    6 +-
 arch/arm/mach-pnx4008/gpio.c                       |    6 +-
 arch/arm/mach-pnx4008/i2c.c                        |    4 +-
 .../include/{mach => mach-pnx4008}/clock.h         |    0
 .../include/{mach => mach-pnx4008}/debug-macro.S   |    0
 .../include/{mach => mach-pnx4008}/dma.h           |    0
 .../include/{mach => mach-pnx4008}/entry-macro.S   |    0
 .../include/{mach => mach-pnx4008}/gpio-pnx4008.h  |    0
 .../mach-pnx4008/include/mach-pnx4008/hardware.h   |   32 +
 .../include/{mach => mach-pnx4008}/irq.h           |    0
 .../include/{mach => mach-pnx4008}/irqs.h          |    0
 .../include/{mach => mach-pnx4008}/param.h         |    0
 .../include/{mach => mach-pnx4008}/platform.h      |    0
 .../include/{mach => mach-pnx4008}/pm.h            |    0
 .../include/{mach => mach-pnx4008}/timex.h         |    0
 .../include/{mach => mach-pnx4008}/uncompress.h    |    0
 arch/arm/mach-pnx4008/include/mach/hardware.h      |   32 -
 arch/arm/mach-pnx4008/irq.c                        |    4 +-
 arch/arm/mach-pnx4008/pm.c                         |    6 +-
 arch/arm/mach-pnx4008/serial.c                     |    8 +-
 arch/arm/mach-pnx4008/sleep.S                      |    2 +-
 arch/arm/mach-pnx4008/time.c                       |    2 +-
 arch/arm/mach-pnx4008/time.h                       |    2 +-
 arch/arm/mach-prima2/clock.c                       |    2 +-
 .../include/{mach => mach-prima2}/clkdev.h         |    0
 .../mach-prima2/include/mach-prima2/debug-macro.S  |   29 +
 .../mach-prima2/include/mach-prima2/entry-macro.S  |   22 +
 .../include/{mach => mach-prima2}/gpio.h           |    0
 .../arm/mach-prima2/include/mach-prima2/hardware.h |   15 +
 .../include/{mach => mach-prima2}/irqs.h           |    0
 .../include/{mach => mach-prima2}/map.h            |    0
 .../include/{mach => mach-prima2}/timex.h          |    0
 .../include/{mach => mach-prima2}/uart.h           |    0
 .../mach-prima2/include/mach-prima2/uncompress.h   |   40 +
 arch/arm/mach-prima2/include/mach/debug-macro.S    |   29 -
 arch/arm/mach-prima2/include/mach/entry-macro.S    |   22 -
 arch/arm/mach-prima2/include/mach/hardware.h       |   15 -
 arch/arm/mach-prima2/include/mach/uncompress.h     |   40 -
 arch/arm/mach-prima2/irq.c                         |    2 +-
 arch/arm/mach-prima2/lluart.c                      |    4 +-
 arch/arm/mach-prima2/timer.c                       |    2 +-
 arch/arm/mach-pxa/am200epd.c                       |    6 +-
 arch/arm/mach-pxa/am300epd.c                       |    6 +-
 arch/arm/mach-pxa/balloon3.c                       |   18 +-
 arch/arm/mach-pxa/capc7117.c                       |    4 +-
 arch/arm/mach-pxa/clock-pxa2xx.c                   |    2 +-
 arch/arm/mach-pxa/clock-pxa3xx.c                   |    4 +-
 arch/arm/mach-pxa/cm-x255.c                        |    2 +-
 arch/arm/mach-pxa/cm-x270.c                        |    6 +-
 arch/arm/mach-pxa/cm-x2xx.c                        |   10 +-
 arch/arm/mach-pxa/cm-x300.c                        |   16 +-
 arch/arm/mach-pxa/colibri-evalboard.c              |   12 +-
 arch/arm/mach-pxa/colibri-pxa270-income.c          |   12 +-
 arch/arm/mach-pxa/colibri-pxa270.c                 |    6 +-
 arch/arm/mach-pxa/colibri-pxa300.c                 |   10 +-
 arch/arm/mach-pxa/colibri-pxa320.c                 |   14 +-
 arch/arm/mach-pxa/colibri-pxa3xx.c                 |   14 +-
 arch/arm/mach-pxa/corgi.c                          |   14 +-
 arch/arm/mach-pxa/corgi_pm.c                       |    8 +-
 arch/arm/mach-pxa/cpufreq-pxa2xx.c                 |    4 +-
 arch/arm/mach-pxa/cpufreq-pxa3xx.c                 |    2 +-
 arch/arm/mach-pxa/csb726.c                         |   12 +-
 arch/arm/mach-pxa/devices.c                        |   24 +-
 arch/arm/mach-pxa/em-x270.c                        |   16 +-
 arch/arm/mach-pxa/eseries.c                        |   14 +-
 arch/arm/mach-pxa/ezx.c                            |   12 +-
 arch/arm/mach-pxa/generic.c                        |    8 +-
 arch/arm/mach-pxa/gumstix.c                        |   10 +-
 arch/arm/mach-pxa/h5000.c                          |    8 +-
 arch/arm/mach-pxa/himalaya.c                       |    2 +-
 arch/arm/mach-pxa/hx4700.c                         |    8 +-
 arch/arm/mach-pxa/icontrol.c                       |    4 +-
 arch/arm/mach-pxa/idp.c                            |   12 +-
 .../mach-pxa/include/{mach => mach-pxa}/addr-map.h |    0
 .../include/{mach => mach-pxa}/arcom-pcmcia.h      |    0
 .../mach-pxa/include/{mach => mach-pxa}/audio.h    |    0
 .../mach-pxa/include/{mach => mach-pxa}/balloon3.h |    0
 .../mach-pxa/include/{mach => mach-pxa}/bitfield.h |    0
 .../mach-pxa/include/{mach => mach-pxa}/camera.h   |    0
 arch/arm/mach-pxa/include/mach-pxa/colibri.h       |   69 +
 .../mach-pxa/include/{mach => mach-pxa}/corgi.h    |    0
 .../mach-pxa/include/{mach => mach-pxa}/csb726.h   |    0
 .../include/{mach => mach-pxa}/debug-macro.S       |    0
 arch/arm/mach-pxa/include/mach-pxa/dma.h           |   21 +
 .../include/{mach => mach-pxa}/eseries-gpio.h      |    0
 .../include/{mach => mach-pxa}/eseries-irq.h       |    0
 arch/arm/mach-pxa/include/mach-pxa/gpio.h          |   32 +
 .../mach-pxa/include/{mach => mach-pxa}/gumstix.h  |    0
 arch/arm/mach-pxa/include/mach-pxa/h5000.h         |  113 ++
 arch/arm/mach-pxa/include/mach-pxa/hardware.h      |  338 ++++
 .../mach-pxa/include/{mach => mach-pxa}/hx4700.h   |    0
 arch/arm/mach-pxa/include/{mach => mach-pxa}/idp.h |    0
 arch/arm/mach-pxa/include/{mach => mach-pxa}/io.h  |    0
 .../arm/mach-pxa/include/{mach => mach-pxa}/irda.h |    0
 .../arm/mach-pxa/include/{mach => mach-pxa}/irqs.h |    0
 .../include/{mach => mach-pxa}/littleton.h         |    0
 .../mach-pxa/include/{mach => mach-pxa}/lpd270.h   |    0
 .../mach-pxa/include/{mach => mach-pxa}/lubbock.h  |    0
 arch/arm/mach-pxa/include/mach-pxa/magician.h      |  120 ++
 arch/arm/mach-pxa/include/mach-pxa/mainstone.h     |  141 ++
 arch/arm/mach-pxa/include/mach-pxa/mfp-pxa25x.h    |  225 +++
 arch/arm/mach-pxa/include/mach-pxa/mfp-pxa27x.h    |  468 ++++++
 arch/arm/mach-pxa/include/mach-pxa/mfp-pxa2xx.h    |  142 ++
 arch/arm/mach-pxa/include/mach-pxa/mfp-pxa300.h    |  575 +++++++
 arch/arm/mach-pxa/include/mach-pxa/mfp-pxa320.h    |  461 ++++++
 arch/arm/mach-pxa/include/mach-pxa/mfp-pxa3xx.h    |  158 ++
 arch/arm/mach-pxa/include/mach-pxa/mfp-pxa930.h    |  498 ++++++
 arch/arm/mach-pxa/include/mach-pxa/mfp.h           |   21 +
 .../mach-pxa/include/{mach => mach-pxa}/mioa701.h  |    0
 arch/arm/mach-pxa/include/{mach => mach-pxa}/mmc.h |    0
 arch/arm/mach-pxa/include/mach-pxa/mtd-xip.h       |   35 +
 .../mach-pxa/include/{mach => mach-pxa}/mxm8x10.h  |    0
 .../arm/mach-pxa/include/{mach => mach-pxa}/ohci.h |    0
 .../mach-pxa/include/{mach => mach-pxa}/palm27x.h  |    0
 .../mach-pxa/include/{mach => mach-pxa}/palmasoc.h |    0
 .../mach-pxa/include/{mach => mach-pxa}/palmld.h   |    0
 .../mach-pxa/include/{mach => mach-pxa}/palmt5.h   |    0
 .../mach-pxa/include/{mach => mach-pxa}/palmtc.h   |    0
 .../mach-pxa/include/{mach => mach-pxa}/palmte2.h  |    0
 .../mach-pxa/include/{mach => mach-pxa}/palmtreo.h |    0
 .../mach-pxa/include/{mach => mach-pxa}/palmtx.h   |    0
 .../mach-pxa/include/{mach => mach-pxa}/palmz72.h  |    0
 .../mach-pxa/include/{mach => mach-pxa}/pata_pxa.h |    0
 .../mach-pxa/include/{mach => mach-pxa}/pcm027.h   |    0
 .../mach-pxa/include/mach-pxa/pcm990_baseboard.h   |  211 +++
 arch/arm/mach-pxa/include/{mach => mach-pxa}/pm.h  |    0
 .../mach-pxa/include/{mach => mach-pxa}/poodle.h   |    0
 .../include/{mach => mach-pxa}/pxa25x-udc.h        |    0
 arch/arm/mach-pxa/include/mach-pxa/pxa25x.h        |   17 +
 .../include/{mach => mach-pxa}/pxa27x-udc.h        |    0
 arch/arm/mach-pxa/include/mach-pxa/pxa27x.h        |   29 +
 arch/arm/mach-pxa/include/mach-pxa/pxa2xx-regs.h   |  187 +++
 arch/arm/mach-pxa/include/mach-pxa/pxa300.h        |    7 +
 arch/arm/mach-pxa/include/mach-pxa/pxa320.h        |    8 +
 arch/arm/mach-pxa/include/mach-pxa/pxa3xx-regs.h   |  205 +++
 .../include/{mach => mach-pxa}/pxa3xx-u2d.h        |    0
 arch/arm/mach-pxa/include/mach-pxa/pxa3xx.h        |   14 +
 arch/arm/mach-pxa/include/mach-pxa/pxa930.h        |    7 +
 .../include/{mach => mach-pxa}/pxa930_rotary.h     |    0
 .../include/{mach => mach-pxa}/pxa930_trkball.h    |    0
 arch/arm/mach-pxa/include/mach-pxa/pxa95x.h        |    7 +
 arch/arm/mach-pxa/include/mach-pxa/pxafb.h         |  175 ++
 arch/arm/mach-pxa/include/mach-pxa/regs-ac97.h     |  101 ++
 arch/arm/mach-pxa/include/mach-pxa/regs-lcd.h      |  197 +++
 arch/arm/mach-pxa/include/mach-pxa/regs-ost.h      |   34 +
 arch/arm/mach-pxa/include/mach-pxa/regs-rtc.h      |   23 +
 arch/arm/mach-pxa/include/mach-pxa/regs-u2d.h      |  200 +++
 .../include/{mach => mach-pxa}/regs-uart.h         |    0
 .../mach-pxa/include/{mach => mach-pxa}/reset.h    |    0
 .../include/{mach => mach-pxa}/sharpsl_pm.h        |    0
 .../mach-pxa/include/{mach => mach-pxa}/smemc.h    |    0
 .../mach-pxa/include/{mach => mach-pxa}/spitz.h    |    0
 .../mach-pxa/include/{mach => mach-pxa}/timex.h    |    0
 .../arm/mach-pxa/include/{mach => mach-pxa}/tosa.h |    0
 .../mach-pxa/include/{mach => mach-pxa}/tosa_bt.h  |    0
 .../mach-pxa/include/{mach => mach-pxa}/trizeps4.h |    0
 arch/arm/mach-pxa/include/{mach => mach-pxa}/udc.h |    0
 .../include/{mach => mach-pxa}/uncompress.h        |    0
 .../mach-pxa/include/{mach => mach-pxa}/viper.h    |    0
 .../mach-pxa/include/{mach => mach-pxa}/vpac270.h  |    0
 arch/arm/mach-pxa/include/{mach => mach-pxa}/z2.h  |    0
 .../arm/mach-pxa/include/{mach => mach-pxa}/zeus.h |    0
 .../mach-pxa/include/{mach => mach-pxa}/zylonite.h |    0
 arch/arm/mach-pxa/include/mach/colibri.h           |   69 -
 arch/arm/mach-pxa/include/mach/dma.h               |   21 -
 arch/arm/mach-pxa/include/mach/gpio.h              |   32 -
 arch/arm/mach-pxa/include/mach/h5000.h             |  113 --
 arch/arm/mach-pxa/include/mach/hardware.h          |  338 ----
 arch/arm/mach-pxa/include/mach/magician.h          |  120 --
 arch/arm/mach-pxa/include/mach/mainstone.h         |  141 --
 arch/arm/mach-pxa/include/mach/mfp-pxa25x.h        |  225 ---
 arch/arm/mach-pxa/include/mach/mfp-pxa27x.h        |  468 ------
 arch/arm/mach-pxa/include/mach/mfp-pxa2xx.h        |  142 --
 arch/arm/mach-pxa/include/mach/mfp-pxa300.h        |  575 -------
 arch/arm/mach-pxa/include/mach/mfp-pxa320.h        |  461 ------
 arch/arm/mach-pxa/include/mach/mfp-pxa3xx.h        |  158 --
 arch/arm/mach-pxa/include/mach/mfp-pxa930.h        |  498 ------
 arch/arm/mach-pxa/include/mach/mfp.h               |   21 -
 arch/arm/mach-pxa/include/mach/mtd-xip.h           |   35 -
 arch/arm/mach-pxa/include/mach/pcm990_baseboard.h  |  211 ---
 arch/arm/mach-pxa/include/mach/pxa25x.h            |   17 -
 arch/arm/mach-pxa/include/mach/pxa27x.h            |   29 -
 arch/arm/mach-pxa/include/mach/pxa2xx-regs.h       |  187 ---
 arch/arm/mach-pxa/include/mach/pxa300.h            |    7 -
 arch/arm/mach-pxa/include/mach/pxa320.h            |    8 -
 arch/arm/mach-pxa/include/mach/pxa3xx-regs.h       |  205 ---
 arch/arm/mach-pxa/include/mach/pxa3xx.h            |   14 -
 arch/arm/mach-pxa/include/mach/pxa930.h            |    7 -
 arch/arm/mach-pxa/include/mach/pxa95x.h            |    7 -
 arch/arm/mach-pxa/include/mach/pxafb.h             |  175 --
 arch/arm/mach-pxa/include/mach/regs-ac97.h         |  101 --
 arch/arm/mach-pxa/include/mach/regs-lcd.h          |  197 ---
 arch/arm/mach-pxa/include/mach/regs-ost.h          |   34 -
 arch/arm/mach-pxa/include/mach/regs-rtc.h          |   23 -
 arch/arm/mach-pxa/include/mach/regs-u2d.h          |  200 ---
 arch/arm/mach-pxa/irq.c                            |    4 +-
 arch/arm/mach-pxa/leds-idp.c                       |    6 +-
 arch/arm/mach-pxa/leds-lubbock.c                   |    6 +-
 arch/arm/mach-pxa/leds-mainstone.c                 |    6 +-
 arch/arm/mach-pxa/littleton.c                      |   14 +-
 arch/arm/mach-pxa/lpd270.c                         |   18 +-
 arch/arm/mach-pxa/lubbock.c                        |   20 +-
 arch/arm/mach-pxa/magician.c                       |   14 +-
 arch/arm/mach-pxa/mainstone.c                      |   20 +-
 arch/arm/mach-pxa/mfp-pxa2xx.c                     |    4 +-
 arch/arm/mach-pxa/mfp-pxa3xx.c                     |    6 +-
 arch/arm/mach-pxa/mioa701.c                        |   22 +-
 arch/arm/mach-pxa/mp900.c                          |    2 +-
 arch/arm/mach-pxa/mxm8x10.c                        |   12 +-
 arch/arm/mach-pxa/palm27x.c                        |   16 +-
 arch/arm/mach-pxa/palmld.c                         |   18 +-
 arch/arm/mach-pxa/palmt5.c                         |   20 +-
 arch/arm/mach-pxa/palmtc.c                         |   14 +-
 arch/arm/mach-pxa/palmte2.c                        |   16 +-
 arch/arm/mach-pxa/palmtreo.c                       |   28 +-
 arch/arm/mach-pxa/palmtx.c                         |   20 +-
 arch/arm/mach-pxa/palmz72.c                        |   26 +-
 arch/arm/mach-pxa/pcm027.c                         |    4 +-
 arch/arm/mach-pxa/pcm990-baseboard.c               |   14 +-
 arch/arm/mach-pxa/pm.c                             |    2 +-
 arch/arm/mach-pxa/poodle.c                         |   14 +-
 arch/arm/mach-pxa/pxa25x.c                         |   14 +-
 arch/arm/mach-pxa/pxa27x.c                         |   16 +-
 arch/arm/mach-pxa/pxa2xx.c                         |   10 +-
 arch/arm/mach-pxa/pxa300.c                         |    2 +-
 arch/arm/mach-pxa/pxa320.c                         |    2 +-
 arch/arm/mach-pxa/pxa3xx-ulpi.c                    |    6 +-
 arch/arm/mach-pxa/pxa3xx.c                         |   16 +-
 arch/arm/mach-pxa/pxa930.c                         |    2 +-
 arch/arm/mach-pxa/pxa95x.c                         |   12 +-
 arch/arm/mach-pxa/raumfeld.c                       |   10 +-
 arch/arm/mach-pxa/reset.c                          |    4 +-
 arch/arm/mach-pxa/saar.c                           |    4 +-
 arch/arm/mach-pxa/saarb.c                          |   10 +-
 arch/arm/mach-pxa/sharpsl_pm.c                     |    8 +-
 arch/arm/mach-pxa/sleep.S                          |    6 +-
 arch/arm/mach-pxa/smemc.c                          |    4 +-
 arch/arm/mach-pxa/spitz.c                          |   20 +-
 arch/arm/mach-pxa/spitz_pm.c                       |    8 +-
 arch/arm/mach-pxa/standby.S                        |    4 +-
 arch/arm/mach-pxa/stargate2.c                      |   10 +-
 arch/arm/mach-pxa/tavorevb.c                       |    6 +-
 arch/arm/mach-pxa/tavorevb3.c                      |    2 +-
 arch/arm/mach-pxa/time.c                           |    4 +-
 arch/arm/mach-pxa/tosa-bt.c                        |    2 +-
 arch/arm/mach-pxa/tosa.c                           |   18 +-
 arch/arm/mach-pxa/trizeps4.c                       |   16 +-
 arch/arm/mach-pxa/viper.c                          |   12 +-
 arch/arm/mach-pxa/vpac270.c                        |   18 +-
 arch/arm/mach-pxa/xcep.c                           |    6 +-
 arch/arm/mach-pxa/z2.c                             |   14 +-
 arch/arm/mach-pxa/zeus.c                           |   24 +-
 arch/arm/mach-pxa/zylonite.c                       |   16 +-
 arch/arm/mach-pxa/zylonite_pxa300.c                |    4 +-
 arch/arm/mach-pxa/zylonite_pxa320.c                |    4 +-
 arch/arm/mach-realview/core.c                      |   10 +-
 .../include/{mach => mach-realview}/barriers.h     |    0
 .../mach-realview/include/mach-realview/board-eb.h |   96 ++
 .../include/mach-realview/board-pb1176.h           |   83 +
 .../include/mach-realview/board-pb11mp.h           |   98 ++
 .../include/mach-realview/board-pba8.h             |   73 +
 .../include/mach-realview/board-pbx.h              |  108 ++
 .../mach-realview/include/mach-realview/clkdev.h   |   16 +
 .../include/{mach => mach-realview}/debug-macro.S  |    0
 .../include/mach-realview}/gpio.h                  |    0
 .../include/{mach => mach-realview}/hardware.h     |    0
 .../include/{mach => mach-realview}/irqs-eb.h      |    0
 .../include/{mach => mach-realview}/irqs-pb1176.h  |    0
 .../include/{mach => mach-realview}/irqs-pb11mp.h  |    0
 .../include/{mach => mach-realview}/irqs-pba8.h    |    0
 .../include/{mach => mach-realview}/irqs-pbx.h     |    0
 .../arm/mach-realview/include/mach-realview/irqs.h |   40 +
 .../include/{mach => mach-realview}/memory.h       |    0
 .../include/{mach => mach-realview}/platform.h     |    0
 .../include/{mach => mach-realview}/timex.h        |    0
 .../include/mach-realview/uncompress.h             |   78 +
 arch/arm/mach-realview/include/mach/board-eb.h     |   96 --
 arch/arm/mach-realview/include/mach/board-pb1176.h |   83 -
 arch/arm/mach-realview/include/mach/board-pb11mp.h |   98 --
 arch/arm/mach-realview/include/mach/board-pba8.h   |   73 -
 arch/arm/mach-realview/include/mach/board-pbx.h    |  108 --
 arch/arm/mach-realview/include/mach/clkdev.h       |   16 -
 arch/arm/mach-realview/include/mach/irqs.h         |   40 -
 arch/arm/mach-realview/include/mach/uncompress.h   |   78 -
 arch/arm/mach-realview/platsmp.c                   |    8 +-
 arch/arm/mach-realview/realview_eb.c               |    6 +-
 arch/arm/mach-realview/realview_pb1176.c           |    6 +-
 arch/arm/mach-realview/realview_pb11mp.c           |    6 +-
 arch/arm/mach-realview/realview_pba8.c             |    6 +-
 arch/arm/mach-realview/realview_pbx.c              |    6 +-
 arch/arm/mach-rpc/dma.c                            |    2 +-
 arch/arm/mach-rpc/ecard.c                          |    2 +-
 arch/arm/mach-rpc/fiq.S                            |    4 +-
 .../mach-rpc/include/{mach => mach-rpc}/acornfb.h  |    0
 .../include/{mach => mach-rpc}/debug-macro.S       |    0
 arch/arm/mach-rpc/include/mach-rpc/entry-macro.S   |   12 +
 arch/arm/mach-rpc/include/mach-rpc/hardware.h      |   76 +
 arch/arm/mach-rpc/include/mach-rpc/io.h            |   31 +
 .../arm/mach-rpc/include/{mach => mach-rpc}/irqs.h |    0
 .../mach-rpc/include/{mach => mach-rpc}/isa-dma.h  |    0
 .../mach-rpc/include/{mach => mach-rpc}/memory.h   |    0
 .../mach-rpc/include/{mach => mach-rpc}/timex.h    |    0
 arch/arm/mach-rpc/include/mach-rpc/uncompress.h    |  196 +++
 arch/arm/mach-rpc/include/mach/entry-macro.S       |   12 -
 arch/arm/mach-rpc/include/mach/hardware.h          |   76 -
 arch/arm/mach-rpc/include/mach/io.h                |   31 -
 arch/arm/mach-rpc/include/mach/uncompress.h        |  196 ---
 arch/arm/mach-rpc/riscpc.c                         |    2 +-
 arch/arm/mach-rpc/time.c                           |    2 +-
 arch/arm/mach-s3c2410/cpu-freq.c                   |    8 +-
 arch/arm/mach-s3c2410/pll.c                        |    4 +-
 arch/arm/mach-s3c2412/cpu-freq.c                   |   10 +-
 arch/arm/mach-s3c2412/gpio.c                       |    6 +-
 arch/arm/mach-s3c2440/dsc.c                        |   10 +-
 arch/arm/mach-s3c2440/s3c2440-cpufreq.c            |   10 +-
 arch/arm/mach-s3c2440/s3c2440-pll-12000000.c       |    4 +-
 arch/arm/mach-s3c2440/s3c2440-pll-16934400.c       |    4 +-
 arch/arm/mach-s3c24xx/bast-ide.c                   |    6 +-
 arch/arm/mach-s3c24xx/bast-irq.c                   |   10 +-
 arch/arm/mach-s3c24xx/clock-s3c2412.c              |   14 +-
 arch/arm/mach-s3c24xx/clock-s3c2416.c              |   16 +-
 arch/arm/mach-s3c24xx/clock-s3c2440.c              |   10 +-
 arch/arm/mach-s3c24xx/clock-s3c2443.c              |   14 +-
 arch/arm/mach-s3c24xx/clock-s3c244x.c              |    8 +-
 arch/arm/mach-s3c24xx/common-s3c2443.c             |   10 +-
 arch/arm/mach-s3c24xx/common-smdk.c                |   16 +-
 arch/arm/mach-s3c24xx/common.c                     |   30 +-
 arch/arm/mach-s3c24xx/dma-s3c2410.c                |   30 +-
 arch/arm/mach-s3c24xx/dma-s3c2412.c                |   28 +-
 arch/arm/mach-s3c24xx/dma-s3c2440.c                |   26 +-
 arch/arm/mach-s3c24xx/dma-s3c2443.c                |   24 +-
 arch/arm/mach-s3c24xx/h1940-bluetooth.c            |    8 +-
 .../include/{mach => mach-s3c24xx}/anubis-cpld.h   |    0
 .../include/{mach => mach-s3c24xx}/anubis-irq.h    |    0
 .../include/{mach => mach-s3c24xx}/anubis-map.h    |    0
 .../include/{mach => mach-s3c24xx}/bast-cpld.h     |    0
 .../include/{mach => mach-s3c24xx}/bast-irq.h      |    0
 .../include/{mach => mach-s3c24xx}/bast-map.h      |    0
 .../include/mach-s3c24xx/debug-macro.S             |  101 ++
 arch/arm/mach-s3c24xx/include/mach-s3c24xx/dma.h   |  214 +++
 .../include/mach-s3c24xx/entry-macro.S             |   70 +
 arch/arm/mach-s3c24xx/include/mach-s3c24xx/fb.h    |    1 +
 .../mach-s3c24xx/include/mach-s3c24xx/gpio-fns.h   |    1 +
 .../include/{mach => mach-s3c24xx}/gpio-nrs.h      |    0
 .../mach-s3c24xx/include/mach-s3c24xx/gpio-track.h |   33 +
 arch/arm/mach-s3c24xx/include/mach-s3c24xx/gpio.h  |   35 +
 arch/arm/mach-s3c24xx/include/mach-s3c24xx/gta02.h |   15 +
 .../include/{mach => mach-s3c24xx}/h1940-latch.h   |    0
 .../include/{mach => mach-s3c24xx}/h1940.h         |    0
 .../mach-s3c24xx/include/mach-s3c24xx/hardware.h   |   42 +
 .../include/{mach => mach-s3c24xx}/idle.h          |    0
 arch/arm/mach-s3c24xx/include/mach-s3c24xx/io.h    |  211 +++
 .../include/{mach => mach-s3c24xx}/irqs.h          |    0
 .../include/{mach => mach-s3c24xx}/leds-gpio.h     |    0
 arch/arm/mach-s3c24xx/include/mach-s3c24xx/map.h   |  170 ++
 .../include/{mach => mach-s3c24xx}/osiris-cpld.h   |    0
 .../include/{mach => mach-s3c24xx}/osiris-map.h    |    0
 .../include/{mach => mach-s3c24xx}/otom-map.h      |    0
 .../include/{mach => mach-s3c24xx}/pm-core.h       |    0
 .../include/{mach => mach-s3c24xx}/regs-clock.h    |    0
 .../include/{mach => mach-s3c24xx}/regs-dsc.h      |    0
 .../mach-s3c24xx/include/mach-s3c24xx/regs-gpio.h  |  615 +++++++
 .../include/{mach => mach-s3c24xx}/regs-irq.h      |    0
 .../include/{mach => mach-s3c24xx}/regs-lcd.h      |    0
 .../include/{mach => mach-s3c24xx}/regs-mem.h      |    0
 .../include/{mach => mach-s3c24xx}/regs-power.h    |    0
 .../{mach => mach-s3c24xx}/regs-s3c2412-mem.h      |    0
 .../include/{mach => mach-s3c24xx}/regs-s3c2412.h  |    0
 .../{mach => mach-s3c24xx}/regs-s3c2416-mem.h      |    0
 .../include/{mach => mach-s3c24xx}/regs-s3c2416.h  |    0
 .../{mach => mach-s3c24xx}/regs-s3c2443-clock.h    |    0
 .../include/{mach => mach-s3c24xx}/regs-sdi.h      |    0
 .../include/{mach => mach-s3c24xx}/tick.h          |    0
 .../include/{mach => mach-s3c24xx}/timex.h         |    0
 .../mach-s3c24xx/include/mach-s3c24xx/uncompress.h |   54 +
 .../include/{mach => mach-s3c24xx}/vr1000-cpld.h   |    0
 .../include/{mach => mach-s3c24xx}/vr1000-irq.h    |    0
 .../mach-s3c24xx/include/mach-s3c24xx/vr1000-map.h |  110 ++
 arch/arm/mach-s3c24xx/include/mach/debug-macro.S   |  101 --
 arch/arm/mach-s3c24xx/include/mach/dma.h           |  214 ---
 arch/arm/mach-s3c24xx/include/mach/entry-macro.S   |   70 -
 arch/arm/mach-s3c24xx/include/mach/fb.h            |    1 -
 arch/arm/mach-s3c24xx/include/mach/gpio-fns.h      |    1 -
 arch/arm/mach-s3c24xx/include/mach/gpio-track.h    |   33 -
 arch/arm/mach-s3c24xx/include/mach/gpio.h          |   35 -
 arch/arm/mach-s3c24xx/include/mach/gta02.h         |   15 -
 arch/arm/mach-s3c24xx/include/mach/hardware.h      |   42 -
 arch/arm/mach-s3c24xx/include/mach/io.h            |  211 ---
 arch/arm/mach-s3c24xx/include/mach/map.h           |  170 --
 arch/arm/mach-s3c24xx/include/mach/regs-gpio.h     |  615 -------
 arch/arm/mach-s3c24xx/include/mach/uncompress.h    |   54 -
 arch/arm/mach-s3c24xx/include/mach/vr1000-map.h    |  110 --
 arch/arm/mach-s3c24xx/irq-pm.c                     |    6 +-
 arch/arm/mach-s3c24xx/irq-s3c2412.c                |   14 +-
 arch/arm/mach-s3c24xx/irq-s3c2416.c                |   12 +-
 arch/arm/mach-s3c24xx/irq-s3c2440.c                |   12 +-
 arch/arm/mach-s3c24xx/irq-s3c2443.c                |   12 +-
 arch/arm/mach-s3c24xx/irq-s3c244x.c                |   12 +-
 arch/arm/mach-s3c24xx/mach-amlm5900.c              |   18 +-
 arch/arm/mach-s3c24xx/mach-anubis.c                |   28 +-
 arch/arm/mach-s3c24xx/mach-at2440evb.c             |   24 +-
 arch/arm/mach-s3c24xx/mach-bast.c                  |   36 +-
 arch/arm/mach-s3c24xx/mach-gta02.c                 |   38 +-
 arch/arm/mach-s3c24xx/mach-h1940.c                 |   46 +-
 arch/arm/mach-s3c24xx/mach-jive.c                  |   30 +-
 arch/arm/mach-s3c24xx/mach-mini2440.c              |   32 +-
 arch/arm/mach-s3c24xx/mach-n30.c                   |   26 +-
 arch/arm/mach-s3c24xx/mach-nexcoder.c              |   22 +-
 arch/arm/mach-s3c24xx/mach-osiris-dvs.c            |    2 +-
 arch/arm/mach-s3c24xx/mach-osiris.c                |   28 +-
 arch/arm/mach-s3c24xx/mach-otom.c                  |   18 +-
 arch/arm/mach-s3c24xx/mach-qt2410.c                |   28 +-
 arch/arm/mach-s3c24xx/mach-rx1950.c                |   34 +-
 arch/arm/mach-s3c24xx/mach-rx3715.c                |   22 +-
 arch/arm/mach-s3c24xx/mach-smdk2410.c              |   12 +-
 arch/arm/mach-s3c24xx/mach-smdk2413.c              |   34 +-
 arch/arm/mach-s3c24xx/mach-smdk2416.c              |   42 +-
 arch/arm/mach-s3c24xx/mach-smdk2440.c              |   26 +-
 arch/arm/mach-s3c24xx/mach-smdk2443.c              |   26 +-
 arch/arm/mach-s3c24xx/mach-tct_hammer.c            |   10 +-
 arch/arm/mach-s3c24xx/mach-vr1000.c                |   26 +-
 arch/arm/mach-s3c24xx/mach-vstms.c                 |   26 +-
 arch/arm/mach-s3c24xx/pm-h1940.S                   |    6 +-
 arch/arm/mach-s3c24xx/pm-s3c2410.c                 |   10 +-
 arch/arm/mach-s3c24xx/pm-s3c2412.c                 |   14 +-
 arch/arm/mach-s3c24xx/pm-s3c2416.c                 |    8 +-
 arch/arm/mach-s3c24xx/pm.c                         |   14 +-
 arch/arm/mach-s3c24xx/s3c2410.c                    |   28 +-
 arch/arm/mach-s3c24xx/s3c2412.c                    |   36 +-
 arch/arm/mach-s3c24xx/s3c2416.c                    |   34 +-
 arch/arm/mach-s3c24xx/s3c2440.c                    |   16 +-
 arch/arm/mach-s3c24xx/s3c2442.c                    |   18 +-
 arch/arm/mach-s3c24xx/s3c2443.c                    |   26 +-
 arch/arm/mach-s3c24xx/s3c244x.c                    |   34 +-
 arch/arm/mach-s3c24xx/setup-i2c.c                  |    8 +-
 arch/arm/mach-s3c24xx/setup-sdhci-gpio.c           |    4 +-
 arch/arm/mach-s3c24xx/setup-spi.c                  |    6 +-
 arch/arm/mach-s3c24xx/setup-ts.c                   |    2 +-
 arch/arm/mach-s3c24xx/simtec-audio.c               |   14 +-
 arch/arm/mach-s3c24xx/simtec-nor.c                 |    6 +-
 arch/arm/mach-s3c24xx/simtec-pm.c                  |   10 +-
 arch/arm/mach-s3c24xx/simtec-usb.c                 |   10 +-
 arch/arm/mach-s3c24xx/sleep-s3c2410.S              |   12 +-
 arch/arm/mach-s3c24xx/sleep-s3c2412.S              |    6 +-
 arch/arm/mach-s3c24xx/sleep.S                      |   12 +-
 arch/arm/mach-s3c64xx/clock.c                      |   24 +-
 arch/arm/mach-s3c64xx/common.c                     |   28 +-
 arch/arm/mach-s3c64xx/cpuidle.c                    |    6 +-
 arch/arm/mach-s3c64xx/dev-audio.c                  |   12 +-
 arch/arm/mach-s3c64xx/dev-uart.c                   |    6 +-
 arch/arm/mach-s3c64xx/dma.c                        |    8 +-
 .../include/{mach => mach-s3c64xx}/crag6410.h      |    0
 .../include/mach-s3c64xx/debug-macro.S             |   38 +
 arch/arm/mach-s3c64xx/include/mach-s3c64xx/dma.h   |  132 ++
 .../include/{mach => mach-s3c64xx}/gpio.h          |    0
 .../include/{mach => mach-s3c64xx}/hardware.h      |    0
 .../include/{mach => mach-s3c64xx}/irqs.h          |    0
 arch/arm/mach-s3c64xx/include/mach-s3c64xx/map.h   |  125 ++
 .../mach-s3c64xx/include/mach-s3c64xx/pm-core.h    |  119 ++
 .../include/{mach => mach-s3c64xx}/regs-clock.h    |    0
 .../{mach => mach-s3c64xx}/regs-gpio-memport.h     |    0
 .../include/{mach => mach-s3c64xx}/regs-gpio.h     |    0
 .../include/{mach => mach-s3c64xx}/regs-irq.h      |    0
 .../include/{mach => mach-s3c64xx}/regs-modem.h    |    0
 .../include/{mach => mach-s3c64xx}/regs-srom.h     |    0
 .../include/{mach => mach-s3c64xx}/regs-sys.h      |    0
 .../{mach => mach-s3c64xx}/regs-syscon-power.h     |    0
 .../include/{mach => mach-s3c64xx}/tick.h          |    0
 .../include/{mach => mach-s3c64xx}/timex.h         |    0
 .../mach-s3c64xx/include/mach-s3c64xx/uncompress.h |   28 +
 arch/arm/mach-s3c64xx/include/mach/debug-macro.S   |   38 -
 arch/arm/mach-s3c64xx/include/mach/dma.h           |  132 --
 arch/arm/mach-s3c64xx/include/mach/map.h           |  125 --
 arch/arm/mach-s3c64xx/include/mach/pm-core.h       |  119 --
 arch/arm/mach-s3c64xx/include/mach/uncompress.h    |   28 -
 arch/arm/mach-s3c64xx/irq-pm.c                     |   12 +-
 arch/arm/mach-s3c64xx/mach-anw6410.c               |   22 +-
 arch/arm/mach-s3c64xx/mach-crag6410-module.c       |    4 +-
 arch/arm/mach-s3c64xx/mach-crag6410.c              |   48 +-
 arch/arm/mach-s3c64xx/mach-hmt.c                   |   20 +-
 arch/arm/mach-s3c64xx/mach-mini6410.c              |   26 +-
 arch/arm/mach-s3c64xx/mach-ncp.c                   |   18 +-
 arch/arm/mach-s3c64xx/mach-real6410.c              |   26 +-
 arch/arm/mach-s3c64xx/mach-smartq.c                |   28 +-
 arch/arm/mach-s3c64xx/mach-smartq5.c               |   16 +-
 arch/arm/mach-s3c64xx/mach-smartq7.c               |   16 +-
 arch/arm/mach-s3c64xx/mach-smdk6400.c              |   14 +-
 arch/arm/mach-s3c64xx/mach-smdk6410.c              |   40 +-
 arch/arm/mach-s3c64xx/pm.c                         |   26 +-
 arch/arm/mach-s3c64xx/s3c6400.c                    |   20 +-
 arch/arm/mach-s3c64xx/s3c6410.c                    |   26 +-
 arch/arm/mach-s3c64xx/setup-fb-24bpp.c             |    4 +-
 arch/arm/mach-s3c64xx/setup-i2c0.c                 |    4 +-
 arch/arm/mach-s3c64xx/setup-i2c1.c                 |    4 +-
 arch/arm/mach-s3c64xx/setup-ide.c                  |    8 +-
 arch/arm/mach-s3c64xx/setup-keypad.c               |    4 +-
 arch/arm/mach-s3c64xx/setup-sdhci-gpio.c           |    4 +-
 arch/arm/mach-s3c64xx/setup-spi.c                  |    2 +-
 arch/arm/mach-s3c64xx/setup-usb-phy.c              |   10 +-
 arch/arm/mach-s3c64xx/sleep.S                      |    4 +-
 arch/arm/mach-s5p64x0/clock-s5p6440.c              |   22 +-
 arch/arm/mach-s5p64x0/clock-s5p6450.c              |   22 +-
 arch/arm/mach-s5p64x0/clock.c                      |   20 +-
 arch/arm/mach-s5p64x0/common.c                     |   32 +-
 arch/arm/mach-s5p64x0/dev-audio.c                  |   10 +-
 arch/arm/mach-s5p64x0/dma.c                        |   14 +-
 arch/arm/mach-s5p64x0/gpiolib.c                    |   16 +-
 .../include/mach-s5p64x0/debug-macro.S             |   33 +
 arch/arm/mach-s5p64x0/include/mach-s5p64x0/dma.h   |   26 +
 .../include/{mach => mach-s5p64x0}/gpio.h          |    0
 .../include/{mach => mach-s5p64x0}/hardware.h      |    0
 .../include/{mach => mach-s5p64x0}/i2c.h           |    0
 arch/arm/mach-s5p64x0/include/mach-s5p64x0/irqs.h  |  150 ++
 arch/arm/mach-s5p64x0/include/mach-s5p64x0/map.h   |   95 ++
 .../mach-s5p64x0/include/mach-s5p64x0/pm-core.h    |  117 ++
 .../mach-s5p64x0/include/mach-s5p64x0/regs-clock.h |   98 ++
 .../mach-s5p64x0/include/mach-s5p64x0/regs-gpio.h  |   68 +
 .../mach-s5p64x0/include/mach-s5p64x0/regs-irq.h   |   19 +
 .../include/{mach => mach-s5p64x0}/s5p64x0-clock.h |    0
 .../include/{mach => mach-s5p64x0}/tick.h          |    0
 .../include/{mach => mach-s5p64x0}/timex.h         |    0
 .../mach-s5p64x0/include/mach-s5p64x0/uncompress.h |  212 +++
 arch/arm/mach-s5p64x0/include/mach/debug-macro.S   |   33 -
 arch/arm/mach-s5p64x0/include/mach/dma.h           |   26 -
 arch/arm/mach-s5p64x0/include/mach/irqs.h          |  150 --
 arch/arm/mach-s5p64x0/include/mach/map.h           |   95 --
 arch/arm/mach-s5p64x0/include/mach/pm-core.h       |  117 --
 arch/arm/mach-s5p64x0/include/mach/regs-clock.h    |   98 --
 arch/arm/mach-s5p64x0/include/mach/regs-gpio.h     |   68 -
 arch/arm/mach-s5p64x0/include/mach/regs-irq.h      |   19 -
 arch/arm/mach-s5p64x0/include/mach/uncompress.h    |  212 ---
 arch/arm/mach-s5p64x0/irq-pm.c                     |    6 +-
 arch/arm/mach-s5p64x0/mach-smdk6440.c              |   40 +-
 arch/arm/mach-s5p64x0/mach-smdk6450.c              |   40 +-
 arch/arm/mach-s5p64x0/pm.c                         |   12 +-
 arch/arm/mach-s5p64x0/setup-fb-24bpp.c             |    6 +-
 arch/arm/mach-s5p64x0/setup-i2c0.c                 |    6 +-
 arch/arm/mach-s5p64x0/setup-i2c1.c                 |    6 +-
 arch/arm/mach-s5p64x0/setup-sdhci-gpio.c           |   10 +-
 arch/arm/mach-s5p64x0/setup-spi.c                  |    2 +-
 arch/arm/mach-s5pc100/clock.c                      |   18 +-
 arch/arm/mach-s5pc100/common.c                     |   30 +-
 arch/arm/mach-s5pc100/dev-audio.c                  |   10 +-
 arch/arm/mach-s5pc100/dma.c                        |   10 +-
 .../include/mach-s5pc100/debug-macro.S             |   39 +
 arch/arm/mach-s5pc100/include/mach-s5pc100/dma.h   |   26 +
 .../include/{mach => mach-s5pc100}/entry-macro.S   |    0
 .../include/{mach => mach-s5pc100}/gpio.h          |    0
 .../include/{mach => mach-s5pc100}/hardware.h      |    0
 arch/arm/mach-s5pc100/include/mach-s5pc100/irqs.h  |  117 ++
 arch/arm/mach-s5pc100/include/mach-s5pc100/map.h   |  136 ++
 .../mach-s5pc100/include/mach-s5pc100/regs-clock.h |   80 +
 .../mach-s5pc100/include/mach-s5pc100/regs-gpio.h  |   38 +
 .../mach-s5pc100/include/mach-s5pc100/regs-irq.h   |   19 +
 .../include/{mach => mach-s5pc100}/tick.h          |    0
 .../include/{mach => mach-s5pc100}/timex.h         |    0
 .../mach-s5pc100/include/mach-s5pc100/uncompress.h |   28 +
 arch/arm/mach-s5pc100/include/mach/debug-macro.S   |   39 -
 arch/arm/mach-s5pc100/include/mach/dma.h           |   26 -
 arch/arm/mach-s5pc100/include/mach/irqs.h          |  117 --
 arch/arm/mach-s5pc100/include/mach/map.h           |  136 --
 arch/arm/mach-s5pc100/include/mach/regs-clock.h    |   80 -
 arch/arm/mach-s5pc100/include/mach/regs-gpio.h     |   38 -
 arch/arm/mach-s5pc100/include/mach/regs-irq.h      |   19 -
 arch/arm/mach-s5pc100/include/mach/uncompress.h    |   28 -
 arch/arm/mach-s5pc100/mach-smdkc100.c              |   34 +-
 arch/arm/mach-s5pc100/setup-fb-24bpp.c             |    6 +-
 arch/arm/mach-s5pc100/setup-i2c0.c                 |    4 +-
 arch/arm/mach-s5pc100/setup-i2c1.c                 |    4 +-
 arch/arm/mach-s5pc100/setup-ide.c                  |    4 +-
 arch/arm/mach-s5pc100/setup-keypad.c               |    2 +-
 arch/arm/mach-s5pc100/setup-sdhci-gpio.c           |    6 +-
 arch/arm/mach-s5pc100/setup-spi.c                  |    2 +-
 arch/arm/mach-s5pv210/clock.c                      |   18 +-
 arch/arm/mach-s5pv210/common.c                     |   30 +-
 arch/arm/mach-s5pv210/dev-audio.c                  |   12 +-
 arch/arm/mach-s5pv210/dma.c                        |   10 +-
 .../include/mach-s5pv210/debug-macro.S             |   41 +
 arch/arm/mach-s5pv210/include/mach-s5pv210/dma.h   |   26 +
 .../include/{mach => mach-s5pv210}/gpio.h          |    0
 .../include/{mach => mach-s5pv210}/hardware.h      |    0
 arch/arm/mach-s5pv210/include/mach-s5pv210/irqs.h  |  139 ++
 arch/arm/mach-s5pv210/include/mach-s5pv210/map.h   |  157 ++
 .../include/{mach => mach-s5pv210}/memory.h        |    0
 .../include/{mach => mach-s5pv210}/pm-core.h       |    0
 .../include/{mach => mach-s5pv210}/regs-audss.h    |    0
 .../mach-s5pv210/include/mach-s5pv210/regs-clock.h |  206 +++
 .../mach-s5pv210/include/mach-s5pv210/regs-gpio.h  |   41 +
 .../mach-s5pv210/include/mach-s5pv210/regs-irq.h   |   19 +
 .../include/{mach => mach-s5pv210}/regs-sys.h      |    0
 .../include/{mach => mach-s5pv210}/tick.h          |    0
 .../include/{mach => mach-s5pv210}/timex.h         |    0
 .../mach-s5pv210/include/mach-s5pv210/uncompress.h |   24 +
 arch/arm/mach-s5pv210/include/mach/debug-macro.S   |   41 -
 arch/arm/mach-s5pv210/include/mach/dma.h           |   26 -
 arch/arm/mach-s5pv210/include/mach/irqs.h          |  139 --
 arch/arm/mach-s5pv210/include/mach/map.h           |  157 --
 arch/arm/mach-s5pv210/include/mach/regs-clock.h    |  206 ---
 arch/arm/mach-s5pv210/include/mach/regs-gpio.h     |   41 -
 arch/arm/mach-s5pv210/include/mach/regs-irq.h      |   19 -
 arch/arm/mach-s5pv210/include/mach/uncompress.h    |   24 -
 arch/arm/mach-s5pv210/mach-aquila.c                |   24 +-
 arch/arm/mach-s5pv210/mach-goni.c                  |   32 +-
 arch/arm/mach-s5pv210/mach-smdkc110.c              |   22 +-
 arch/arm/mach-s5pv210/mach-smdkv210.c              |   40 +-
 arch/arm/mach-s5pv210/mach-torbreck.c              |   16 +-
 arch/arm/mach-s5pv210/pm.c                         |   10 +-
 arch/arm/mach-s5pv210/setup-fb-24bpp.c             |    8 +-
 arch/arm/mach-s5pv210/setup-fimc.c                 |    4 +-
 arch/arm/mach-s5pv210/setup-i2c0.c                 |    4 +-
 arch/arm/mach-s5pv210/setup-i2c1.c                 |    4 +-
 arch/arm/mach-s5pv210/setup-i2c2.c                 |    4 +-
 arch/arm/mach-s5pv210/setup-ide.c                  |    2 +-
 arch/arm/mach-s5pv210/setup-keypad.c               |    2 +-
 arch/arm/mach-s5pv210/setup-sdhci-gpio.c           |    6 +-
 arch/arm/mach-s5pv210/setup-spi.c                  |    2 +-
 arch/arm/mach-s5pv210/setup-usb-phy.c              |   10 +-
 arch/arm/mach-sa1100/assabet.c                     |    8 +-
 arch/arm/mach-sa1100/badge4.c                      |    6 +-
 arch/arm/mach-sa1100/cerf.c                        |    8 +-
 arch/arm/mach-sa1100/clock.c                       |    2 +-
 arch/arm/mach-sa1100/collie.c                      |    8 +-
 arch/arm/mach-sa1100/cpu-sa1100.c                  |    2 +-
 arch/arm/mach-sa1100/cpu-sa1110.c                  |    2 +-
 arch/arm/mach-sa1100/generic.c                     |    4 +-
 arch/arm/mach-sa1100/h3100.c                       |    4 +-
 arch/arm/mach-sa1100/h3600.c                       |    4 +-
 arch/arm/mach-sa1100/h3xxx.c                       |    2 +-
 arch/arm/mach-sa1100/hackkit.c                     |    4 +-
 .../include/{mach => mach-sa1100}/SA-1100.h        |    0
 arch/arm/mach-sa1100/include/mach-sa1100/SA-1101.h |  925 +++++++++++
 .../include/{mach => mach-sa1100}/SA-1111.h        |    0
 .../include/{mach => mach-sa1100}/assabet.h        |    0
 arch/arm/mach-sa1100/include/mach-sa1100/badge4.h  |   75 +
 .../include/{mach => mach-sa1100}/bitfield.h       |    0
 .../include/{mach => mach-sa1100}/cerf.h           |    0
 .../include/{mach => mach-sa1100}/collie.h         |    0
 .../mach-sa1100/include/mach-sa1100/debug-macro.S  |   62 +
 .../include/{mach => mach-sa1100}/entry-macro.S    |    0
 arch/arm/mach-sa1100/include/mach-sa1100/gpio.h    |   55 +
 .../include/{mach => mach-sa1100}/h3xxx.h          |    0
 .../include/{mach => mach-sa1100}/hardware.h       |    0
 .../include/{mach => mach-sa1100}/irqs.h           |    0
 .../include/{mach => mach-sa1100}/jornada720.h     |    0
 .../include/{mach => mach-sa1100}/lart.h           |    0
 .../include/{mach => mach-sa1100}/mcp.h            |    0
 .../include/{mach => mach-sa1100}/memory.h         |    0
 arch/arm/mach-sa1100/include/mach-sa1100/mtd-xip.h |   26 +
 .../mach-sa1100/include/mach-sa1100/nanoengine.h   |   52 +
 .../include/{mach => mach-sa1100}/neponset.h       |    0
 .../include/{mach => mach-sa1100}/reset.h          |    0
 .../include/{mach => mach-sa1100}/shannon.h        |    0
 .../include/{mach => mach-sa1100}/simpad.h         |    0
 .../include/{mach => mach-sa1100}/timex.h          |    0
 .../include/{mach => mach-sa1100}/uncompress.h     |    0
 arch/arm/mach-sa1100/include/mach/SA-1101.h        |  925 -----------
 arch/arm/mach-sa1100/include/mach/badge4.h         |   75 -
 arch/arm/mach-sa1100/include/mach/debug-macro.S    |   62 -
 arch/arm/mach-sa1100/include/mach/gpio.h           |   55 -
 arch/arm/mach-sa1100/include/mach/mtd-xip.h        |   26 -
 arch/arm/mach-sa1100/include/mach/nanoengine.h     |   52 -
 arch/arm/mach-sa1100/irq.c                         |    4 +-
 arch/arm/mach-sa1100/jornada720.c                  |    4 +-
 arch/arm/mach-sa1100/jornada720_ssp.c              |    4 +-
 arch/arm/mach-sa1100/lart.c                        |    6 +-
 arch/arm/mach-sa1100/leds-assabet.c                |    4 +-
 arch/arm/mach-sa1100/leds-badge4.c                 |    2 +-
 arch/arm/mach-sa1100/leds-cerf.c                   |    2 +-
 arch/arm/mach-sa1100/leds-hackkit.c                |    2 +-
 arch/arm/mach-sa1100/leds-lart.c                   |    2 +-
 arch/arm/mach-sa1100/nanoengine.c                  |    6 +-
 arch/arm/mach-sa1100/neponset.c                    |    8 +-
 arch/arm/mach-sa1100/pci-nanoengine.c              |    4 +-
 arch/arm/mach-sa1100/pleb.c                        |    4 +-
 arch/arm/mach-sa1100/pm.c                          |    2 +-
 arch/arm/mach-sa1100/shannon.c                     |    8 +-
 arch/arm/mach-sa1100/simpad.c                      |    8 +-
 arch/arm/mach-sa1100/sleep.S                       |    2 +-
 arch/arm/mach-sa1100/ssp.c                         |    4 +-
 arch/arm/mach-sa1100/time.c                        |    4 +-
 .../include/{mach => mach-shark}/debug-macro.S     |    0
 .../include/{mach => mach-shark}/entry-macro.S     |    0
 .../include/{mach => mach-shark}/framebuffer.h     |    0
 .../include/{mach => mach-shark}/hardware.h        |    0
 .../mach-shark/include/{mach => mach-shark}/io.h   |    0
 .../mach-shark/include/{mach => mach-shark}/irqs.h |    0
 .../include/{mach => mach-shark}/isa-dma.h         |    0
 .../include/{mach => mach-shark}/memory.h          |    0
 .../include/{mach => mach-shark}/timex.h           |    0
 .../include/{mach => mach-shark}/uncompress.h      |    0
 arch/arm/mach-shmobile/board-ag5evm.c              |    8 +-
 arch/arm/mach-shmobile/board-ap4evb.c              |    6 +-
 arch/arm/mach-shmobile/board-armadillo800eva.c     |    6 +-
 arch/arm/mach-shmobile/board-bonito.c              |    6 +-
 arch/arm/mach-shmobile/board-g3evm.c               |    6 +-
 arch/arm/mach-shmobile/board-g4evm.c               |    6 +-
 arch/arm/mach-shmobile/board-kota2.c               |    8 +-
 arch/arm/mach-shmobile/board-kzm9d.c               |    4 +-
 arch/arm/mach-shmobile/board-kzm9g.c               |    6 +-
 arch/arm/mach-shmobile/board-mackerel.c            |    6 +-
 arch/arm/mach-shmobile/board-marzen.c              |    8 +-
 arch/arm/mach-shmobile/clock-emev2.c               |    2 +-
 arch/arm/mach-shmobile/clock-r8a7740.c             |    4 +-
 arch/arm/mach-shmobile/clock-r8a7779.c             |    2 +-
 arch/arm/mach-shmobile/clock-sh7367.c              |    2 +-
 arch/arm/mach-shmobile/clock-sh7372.c              |    2 +-
 arch/arm/mach-shmobile/clock-sh7377.c              |    2 +-
 arch/arm/mach-shmobile/clock-sh73a0.c              |    2 +-
 arch/arm/mach-shmobile/common.c                    |    2 +-
 arch/arm/mach-shmobile/console.c                   |    2 +-
 arch/arm/mach-shmobile/hotplug.c                   |    2 +-
 .../include/{mach => mach-shmobile}/clkdev.h       |    0
 .../include/{mach => mach-shmobile}/common.h       |    0
 .../include/{mach => mach-shmobile}/dma-register.h |    0
 .../include/{mach => mach-shmobile}/dma.h          |    0
 .../include/{mach => mach-shmobile}/emev2.h        |    0
 .../include/{mach => mach-shmobile}/gpio.h         |    0
 .../include/{mach => mach-shmobile}/hardware.h     |    0
 .../{mach => mach-shmobile}/head-ap4evb.txt        |    0
 .../{mach => mach-shmobile}/head-mackerel.txt      |    0
 .../include/{mach => mach-shmobile}/intc.h         |    0
 .../include/{mach => mach-shmobile}/irqs.h         |    0
 .../include/{mach => mach-shmobile}/memory.h       |    0
 .../include/{mach => mach-shmobile}/mmc-ap4eb.h    |    0
 .../include/{mach => mach-shmobile}/mmc-mackerel.h |    0
 .../include/{mach => mach-shmobile}/mmc.h          |    0
 .../include/{mach => mach-shmobile}/pm-rmobile.h   |    0
 .../mach-shmobile/include/mach-shmobile/r8a7740.h  |  615 +++++++
 .../include/{mach => mach-shmobile}/r8a7779.h      |    0
 .../include/{mach => mach-shmobile}/sdhi-sh7372.h  |    0
 .../include/{mach => mach-shmobile}/sdhi.h         |    0
 .../include/{mach => mach-shmobile}/sh7367.h       |    0
 .../mach-shmobile/include/mach-shmobile/sh7372.h   |  498 ++++++
 .../include/{mach => mach-shmobile}/sh7377.h       |    0
 .../include/{mach => mach-shmobile}/sh73a0.h       |    0
 .../include/{mach => mach-shmobile}/system.h       |    0
 .../include/{mach => mach-shmobile}/timex.h        |    0
 .../include/{mach => mach-shmobile}/uncompress.h   |    0
 .../mach-shmobile/include/mach-shmobile/zboot.h    |   23 +
 .../include/{mach => mach-shmobile}/zboot_macros.h |    0
 arch/arm/mach-shmobile/include/mach/r8a7740.h      |  615 -------
 arch/arm/mach-shmobile/include/mach/sh7372.h       |  498 ------
 arch/arm/mach-shmobile/include/mach/zboot.h        |   23 -
 arch/arm/mach-shmobile/intc-r8a7740.c              |    4 +-
 arch/arm/mach-shmobile/intc-r8a7779.c              |    6 +-
 arch/arm/mach-shmobile/intc-sh7367.c               |    4 +-
 arch/arm/mach-shmobile/intc-sh7372.c               |    4 +-
 arch/arm/mach-shmobile/intc-sh7377.c               |    4 +-
 arch/arm/mach-shmobile/intc-sh73a0.c               |    6 +-
 arch/arm/mach-shmobile/pfc-r8a7740.c               |    4 +-
 arch/arm/mach-shmobile/pfc-r8a7779.c               |    2 +-
 arch/arm/mach-shmobile/pfc-sh7367.c                |    2 +-
 arch/arm/mach-shmobile/pfc-sh7372.c                |    4 +-
 arch/arm/mach-shmobile/pfc-sh7377.c                |    2 +-
 arch/arm/mach-shmobile/pfc-sh73a0.c                |    4 +-
 arch/arm/mach-shmobile/platsmp.c                   |    4 +-
 arch/arm/mach-shmobile/pm-r8a7740.c                |    2 +-
 arch/arm/mach-shmobile/pm-r8a7779.c                |    4 +-
 arch/arm/mach-shmobile/pm-rmobile.c                |    2 +-
 arch/arm/mach-shmobile/pm-sh7372.c                 |    6 +-
 arch/arm/mach-shmobile/setup-emev2.c               |    8 +-
 arch/arm/mach-shmobile/setup-r8a7740.c             |   10 +-
 arch/arm/mach-shmobile/setup-r8a7779.c             |    8 +-
 arch/arm/mach-shmobile/setup-sh7367.c              |    6 +-
 arch/arm/mach-shmobile/setup-sh7372.c              |   10 +-
 arch/arm/mach-shmobile/setup-sh7377.c              |    6 +-
 arch/arm/mach-shmobile/setup-sh73a0.c              |   10 +-
 arch/arm/mach-shmobile/smp-emev2.c                 |    4 +-
 arch/arm/mach-shmobile/smp-r8a7779.c               |    4 +-
 arch/arm/mach-shmobile/smp-sh73a0.c                |    2 +-
 .../include/{mach => mach-socfpga}/debug-macro.S   |    0
 .../include/{mach => mach-socfpga}/timex.h         |    0
 .../include/{mach => mach-socfpga}/uncompress.h    |    0
 .../include/mach-spear13xx/debug-macro.S           |   14 +
 .../include/{mach => mach-spear13xx}/dma.h         |    0
 .../include/{mach => mach-spear13xx}/generic.h     |    0
 .../mach-spear13xx/include/mach-spear13xx/gpio.h   |   19 +
 .../include/{mach => mach-spear13xx}/hardware.h    |    0
 .../include/{mach => mach-spear13xx}/irqs.h        |    0
 .../include/{mach => mach-spear13xx}/spear.h       |    0
 .../{mach => mach-spear13xx}/spear1310_misc_regs.h |    0
 .../{mach => mach-spear13xx}/spear1340_misc_regs.h |    0
 .../mach-spear13xx/include/mach-spear13xx/timex.h  |   19 +
 .../include/mach-spear13xx/uncompress.h            |   19 +
 arch/arm/mach-spear13xx/include/mach/debug-macro.S |   14 -
 arch/arm/mach-spear13xx/include/mach/gpio.h        |   19 -
 arch/arm/mach-spear13xx/include/mach/timex.h       |   19 -
 arch/arm/mach-spear13xx/include/mach/uncompress.h  |   19 -
 arch/arm/mach-spear13xx/platsmp.c                  |    2 +-
 arch/arm/mach-spear13xx/spear1310.c                |    4 +-
 arch/arm/mach-spear13xx/spear1340.c                |    6 +-
 arch/arm/mach-spear13xx/spear13xx.c                |    6 +-
 .../include/mach-spear3xx/debug-macro.S            |   14 +
 .../include/{mach => mach-spear3xx}/generic.h      |    0
 .../arm/mach-spear3xx/include/mach-spear3xx/gpio.h |   19 +
 .../include/{mach => mach-spear3xx}/hardware.h     |    0
 .../include/{mach => mach-spear3xx}/irqs.h         |    0
 .../include/mach-spear3xx/misc_regs.h              |   22 +
 .../include/{mach => mach-spear3xx}/spear.h        |    0
 .../mach-spear3xx/include/mach-spear3xx/timex.h    |   19 +
 .../include/mach-spear3xx/uncompress.h             |   19 +
 arch/arm/mach-spear3xx/include/mach/debug-macro.S  |   14 -
 arch/arm/mach-spear3xx/include/mach/gpio.h         |   19 -
 arch/arm/mach-spear3xx/include/mach/misc_regs.h    |   22 -
 arch/arm/mach-spear3xx/include/mach/timex.h        |   19 -
 arch/arm/mach-spear3xx/include/mach/uncompress.h   |   19 -
 arch/arm/mach-spear3xx/spear300.c                  |    6 +-
 arch/arm/mach-spear3xx/spear310.c                  |    6 +-
 arch/arm/mach-spear3xx/spear320.c                  |    6 +-
 arch/arm/mach-spear3xx/spear3xx.c                  |    6 +-
 .../include/mach-spear6xx/debug-macro.S            |   14 +
 .../include/{mach => mach-spear6xx}/generic.h      |    0
 .../arm/mach-spear6xx/include/mach-spear6xx/gpio.h |   19 +
 .../include/{mach => mach-spear6xx}/hardware.h     |    0
 .../include/{mach => mach-spear6xx}/irqs.h         |    0
 .../include/mach-spear6xx/misc_regs.h              |   22 +
 .../include/{mach => mach-spear6xx}/spear.h        |    0
 .../mach-spear6xx/include/mach-spear6xx/timex.h    |   19 +
 .../include/mach-spear6xx/uncompress.h             |   19 +
 arch/arm/mach-spear6xx/include/mach/debug-macro.S  |   14 -
 arch/arm/mach-spear6xx/include/mach/gpio.h         |   19 -
 arch/arm/mach-spear6xx/include/mach/misc_regs.h    |   22 -
 arch/arm/mach-spear6xx/include/mach/timex.h        |   19 -
 arch/arm/mach-spear6xx/include/mach/uncompress.h   |   19 -
 arch/arm/mach-spear6xx/spear6xx.c                  |    6 +-
 arch/arm/mach-tegra/apbio.c                        |    4 +-
 arch/arm/mach-tegra/board-dt-tegra20.c             |    4 +-
 arch/arm/mach-tegra/board-dt-tegra30.c             |    2 +-
 arch/arm/mach-tegra/board-harmony-power.c          |    2 +-
 arch/arm/mach-tegra/board-harmony.c                |    8 +-
 arch/arm/mach-tegra/board-harmony.h                |    2 +-
 arch/arm/mach-tegra/board-paz00.c                  |    6 +-
 arch/arm/mach-tegra/board-paz00.h                  |    2 +-
 arch/arm/mach-tegra/board-pinmux.h                 |    2 +-
 arch/arm/mach-tegra/board-trimslice.c              |    4 +-
 arch/arm/mach-tegra/board-trimslice.h              |    2 +-
 arch/arm/mach-tegra/clock.c                        |    2 +-
 arch/arm/mach-tegra/clock.h                        |    2 +-
 arch/arm/mach-tegra/common.c                       |    4 +-
 arch/arm/mach-tegra/cpu-tegra.c                    |    2 +-
 arch/arm/mach-tegra/cpuidle.c                      |    2 +-
 arch/arm/mach-tegra/devices.c                      |    8 +-
 arch/arm/mach-tegra/devices.h                      |    2 +-
 arch/arm/mach-tegra/dma.c                          |    8 +-
 arch/arm/mach-tegra/flowctrl.c                     |    2 +-
 arch/arm/mach-tegra/fuse.c                         |    2 +-
 arch/arm/mach-tegra/headsmp.S                      |    2 +-
 .../mach-tegra/include/{mach => mach-tegra}/clk.h  |    0
 .../mach-tegra/include/mach-tegra/debug-macro.S    |  100 ++
 .../mach-tegra/include/{mach => mach-tegra}/dma.h  |    0
 .../arm/mach-tegra/include/mach-tegra/gpio-tegra.h |   28 +
 .../mach => mach-tegra/include/mach-tegra}/gpio.h  |    0
 .../mach-tegra/include/{mach => mach-tegra}/io.h   |    0
 .../include/{mach => mach-tegra}/iomap.h           |    0
 .../include/{mach => mach-tegra}/irammap.h         |    0
 .../mach-tegra/include/{mach => mach-tegra}/irqs.h |    0
 .../mach-tegra/include/{mach => mach-tegra}/kbc.h  |    0
 .../include/{mach => mach-tegra}/pinconf-tegra.h   |    0
 .../include/{mach => mach-tegra}/powergate.h       |    0
 .../include/{mach => mach-tegra}/sdhci.h           |    0
 .../mach-tegra/include/{mach => mach-tegra}/smmu.h |    0
 .../include/{mach => mach-tegra}/suspend.h         |    0
 .../include/{mach => mach-tegra}/tegra-ahb.h       |    0
 .../{mach => mach-tegra}/tegra_wm8903_pdata.h      |    0
 .../include/{mach => mach-tegra}/timex.h           |    0
 .../arm/mach-tegra/include/mach-tegra/uncompress.h |  236 +++
 .../include/{mach => mach-tegra}/usb_phy.h         |    0
 arch/arm/mach-tegra/include/mach/debug-macro.S     |  100 --
 arch/arm/mach-tegra/include/mach/gpio-tegra.h      |   28 -
 arch/arm/mach-tegra/include/mach/uncompress.h      |  236 ---
 arch/arm/mach-tegra/io.c                           |    2 +-
 arch/arm/mach-tegra/irq.c                          |    2 +-
 arch/arm/mach-tegra/pcie.c                         |    6 +-
 arch/arm/mach-tegra/platsmp.c                      |    6 +-
 arch/arm/mach-tegra/pmc.c                          |    2 +-
 arch/arm/mach-tegra/powergate.c                    |    6 +-
 arch/arm/mach-tegra/reset.c                        |    4 +-
 arch/arm/mach-tegra/sleep.S                        |    2 +-
 arch/arm/mach-tegra/tegra2_clocks.c                |    4 +-
 arch/arm/mach-tegra/tegra2_emc.c                   |    2 +-
 arch/arm/mach-tegra/tegra30_clocks.c               |    2 +-
 arch/arm/mach-tegra/timer.c                        |    6 +-
 arch/arm/mach-tegra/usb_phy.c                      |    6 +-
 arch/arm/mach-u300/core.c                          |   10 +-
 arch/arm/mach-u300/i2c.c                           |    2 +-
 .../mach-u300/include/{mach => mach-u300}/clkdev.h |    0
 .../include/{mach => mach-u300}/coh901318.h        |    0
 arch/arm/mach-u300/include/mach-u300/debug-macro.S |   21 +
 .../include/{mach => mach-u300}/dma_channels.h     |    0
 .../include/{mach => mach-u300}/gpio-u300.h        |    0
 .../mach => mach-u300/include/mach-u300}/gpio.h    |    0
 arch/arm/mach-u300/include/mach-u300/hardware.h    |    5 +
 .../mach-u300/include/{mach => mach-u300}/irqs.h   |    0
 .../include/{mach => mach-u300}/platform.h         |    0
 .../mach-u300/include/{mach => mach-u300}/syscon.h |    0
 .../mach-u300/include/{mach => mach-u300}/timex.h  |    0
 .../include/{mach => mach-u300}/u300-regs.h        |    0
 .../include/{mach => mach-u300}/uncompress.h       |    0
 arch/arm/mach-u300/include/mach/debug-macro.S      |   21 -
 arch/arm/mach-u300/include/mach/hardware.h         |    5 -
 arch/arm/mach-u300/regulator.c                     |    4 +-
 arch/arm/mach-u300/spi.c                           |    4 +-
 arch/arm/mach-u300/timer.c                         |    2 +-
 arch/arm/mach-u300/u300.c                          |    4 +-
 arch/arm/mach-ux500/board-mop500-msp.c             |   16 +-
 arch/arm/mach-ux500/board-mop500-pins.c            |    6 +-
 arch/arm/mach-ux500/board-mop500-sdi.c             |    6 +-
 arch/arm/mach-ux500/board-mop500-u8500uib.c        |    2 +-
 arch/arm/mach-ux500/board-mop500-uib.c             |    2 +-
 arch/arm/mach-ux500/board-mop500.c                 |   16 +-
 arch/arm/mach-ux500/board-mop500.h                 |    2 +-
 arch/arm/mach-ux500/cache-l2x0.c                   |    4 +-
 arch/arm/mach-ux500/clock.c                        |    4 +-
 arch/arm/mach-ux500/cpu-db8500.c                   |   12 +-
 arch/arm/mach-ux500/cpu.c                          |    6 +-
 arch/arm/mach-ux500/devices-common.c               |    4 +-
 arch/arm/mach-ux500/devices-common.h               |    2 +-
 arch/arm/mach-ux500/devices-db8500.c               |    6 +-
 arch/arm/mach-ux500/devices.c                      |    4 +-
 arch/arm/mach-ux500/id.c                           |    4 +-
 .../mach-ux500/include/mach-ux500/crypto-ux500.h   |   22 +
 .../include/{mach => mach-ux500}/db8500-regs.h     |    0
 .../mach-ux500/include/mach-ux500/debug-macro.S    |   39 +
 .../include/{mach => mach-ux500}/devices.h         |    0
 .../mach-ux500/include/{mach => mach-ux500}/gpio.h |    0
 arch/arm/mach-ux500/include/mach-ux500/hardware.h  |   48 +
 .../mach-ux500/include/{mach => mach-ux500}/id.h   |    0
 .../{mach => mach-ux500}/irqs-board-mop500.h       |    0
 .../include/{mach => mach-ux500}/irqs-db8500.h     |    0
 arch/arm/mach-ux500/include/mach-ux500/irqs.h      |   51 +
 arch/arm/mach-ux500/include/mach-ux500/msp.h       |   29 +
 .../include/{mach => mach-ux500}/setup.h           |    0
 .../include/{mach => mach-ux500}/timex.h           |    0
 .../arm/mach-ux500/include/mach-ux500/uncompress.h |   59 +
 .../mach-ux500/include/{mach => mach-ux500}/usb.h  |    0
 arch/arm/mach-ux500/include/mach/crypto-ux500.h    |   22 -
 arch/arm/mach-ux500/include/mach/debug-macro.S     |   39 -
 arch/arm/mach-ux500/include/mach/hardware.h        |   48 -
 arch/arm/mach-ux500/include/mach/irqs.h            |   51 -
 arch/arm/mach-ux500/include/mach/msp.h             |   29 -
 arch/arm/mach-ux500/include/mach/uncompress.h      |   59 -
 arch/arm/mach-ux500/platsmp.c                      |    4 +-
 arch/arm/mach-ux500/timer.c                        |    8 +-
 arch/arm/mach-ux500/usb.c                          |    6 +-
 arch/arm/mach-versatile/core.c                     |   10 +-
 .../mach-versatile/include/mach-versatile/clkdev.h |   16 +
 .../include/{mach => mach-versatile}/debug-macro.S |    0
 .../include/mach-versatile}/gpio.h                 |    0
 .../include/{mach => mach-versatile}/hardware.h    |    0
 .../include/{mach => mach-versatile}/io.h          |    0
 .../mach-versatile/include/mach-versatile/irqs.h   |  134 ++
 .../include/{mach => mach-versatile}/platform.h    |    0
 .../include/{mach => mach-versatile}/timex.h       |    0
 .../include/{mach => mach-versatile}/uncompress.h  |    0
 arch/arm/mach-versatile/include/mach/clkdev.h      |   16 -
 arch/arm/mach-versatile/include/mach/irqs.h        |  134 --
 arch/arm/mach-versatile/pci.c                      |    2 +-
 arch/arm/mach-versatile/versatile_ab.c             |    2 +-
 arch/arm/mach-versatile/versatile_pb.c             |    2 +-
 arch/arm/mach-vexpress/ct-ca9x4.c                  |    6 +-
 .../include/{mach => mach-vexpress}/ct-ca9x4.h     |    0
 .../include/{mach => mach-vexpress}/debug-macro.S  |    0
 .../include/mach-vexpress}/gpio.h                  |    0
 .../include/{mach => mach-vexpress}/hardware.h     |    0
 .../include/{mach => mach-vexpress}/irqs.h         |    0
 .../include/{mach => mach-vexpress}/motherboard.h  |    0
 .../include/{mach => mach-vexpress}/timex.h        |    0
 .../include/{mach => mach-vexpress}/uncompress.h   |    0
 arch/arm/mach-vexpress/platsmp.c                   |    2 +-
 arch/arm/mach-vexpress/v2m.c                       |    6 +-
 arch/arm/mach-vt8500/bv07.c                        |    2 +-
 arch/arm/mach-vt8500/devices-vt8500.c              |    6 +-
 arch/arm/mach-vt8500/devices-wm8505.c              |    6 +-
 arch/arm/mach-vt8500/devices.c                     |    4 +-
 .../include/{mach => mach-vt8500}/debug-macro.S    |    0
 .../include/{mach => mach-vt8500}/entry-macro.S    |    0
 .../include/mach-vt8500}/gpio.h                    |    0
 .../include/{mach => mach-vt8500}/hardware.h       |    0
 .../include/{mach => mach-vt8500}/i8042.h          |    0
 .../include/{mach => mach-vt8500}/irqs.h           |    0
 .../include/{mach => mach-vt8500}/restart.h        |    0
 .../include/{mach => mach-vt8500}/timex.h          |    0
 .../include/{mach => mach-vt8500}/uncompress.h     |    0
 .../include/{mach => mach-vt8500}/vt8500_irqs.h    |    0
 .../include/{mach => mach-vt8500}/vt8500_regs.h    |    0
 .../include/{mach => mach-vt8500}/vt8500fb.h       |    0
 .../include/{mach => mach-vt8500}/wm8505_irqs.h    |    0
 .../include/{mach => mach-vt8500}/wm8505_regs.h    |    0
 arch/arm/mach-vt8500/wm8505_7in.c                  |    2 +-
 arch/arm/mach-w90x900/clksel.c                     |    4 +-
 arch/arm/mach-w90x900/clock.c                      |    2 +-
 arch/arm/mach-w90x900/cpu.c                        |   10 +-
 arch/arm/mach-w90x900/dev.c                        |   12 +-
 arch/arm/mach-w90x900/gpio.c                       |    2 +-
 .../include/mach-w90x900/entry-macro.S             |   26 +
 .../include/{mach => mach-w90x900}/fb.h            |    0
 arch/arm/mach-w90x900/include/mach-w90x900/gpio.h  |   30 +
 .../mach-w90x900/include/mach-w90x900/hardware.h   |   24 +
 .../include/{mach => mach-w90x900}/i2c.h           |    0
 .../include/{mach => mach-w90x900}/irqs.h          |    0
 .../include/{mach => mach-w90x900}/map.h           |    0
 .../include/{mach => mach-w90x900}/mfp.h           |    0
 .../include/{mach => mach-w90x900}/nuc900_spi.h    |    0
 .../include/{mach => mach-w90x900}/regs-clock.h    |    0
 .../include/{mach => mach-w90x900}/regs-ebi.h      |    0
 .../include/{mach => mach-w90x900}/regs-gcr.h      |    0
 .../include/{mach => mach-w90x900}/regs-irq.h      |    0
 .../mach-w90x900/include/mach-w90x900/regs-ldm.h   |  253 +++
 .../include/{mach => mach-w90x900}/regs-serial.h   |    0
 .../include/{mach => mach-w90x900}/regs-timer.h    |    0
 .../include/{mach => mach-w90x900}/regs-usb.h      |    0
 .../include/{mach => mach-w90x900}/timex.h         |    0
 .../mach-w90x900/include/mach-w90x900/uncompress.h |   50 +
 .../{mach => mach-w90x900}/w90p910_keypad.h        |    0
 arch/arm/mach-w90x900/include/mach/entry-macro.S   |   26 -
 arch/arm/mach-w90x900/include/mach/gpio.h          |   30 -
 arch/arm/mach-w90x900/include/mach/hardware.h      |   24 -
 arch/arm/mach-w90x900/include/mach/regs-ldm.h      |  253 ---
 arch/arm/mach-w90x900/include/mach/uncompress.h    |   50 -
 arch/arm/mach-w90x900/irq.c                        |    4 +-
 arch/arm/mach-w90x900/mach-nuc910evb.c             |    2 +-
 arch/arm/mach-w90x900/mach-nuc950evb.c             |    4 +-
 arch/arm/mach-w90x900/mach-nuc960evb.c             |    2 +-
 arch/arm/mach-w90x900/mfp.c                        |    2 +-
 arch/arm/mach-w90x900/nuc910.c                     |    2 +-
 arch/arm/mach-w90x900/nuc950.c                     |    2 +-
 arch/arm/mach-w90x900/nuc960.c                     |    2 +-
 arch/arm/mach-w90x900/time.c                       |    4 +-
 arch/arm/mach-zynq/common.c                        |    4 +-
 arch/arm/mach-zynq/include/mach-zynq/clkdev.h      |   32 +
 arch/arm/mach-zynq/include/mach-zynq/debug-macro.S |   36 +
 .../include/{mach => mach-zynq}/hardware.h         |    0
 .../mach-zynq/include/{mach => mach-zynq}/irqs.h   |    0
 .../mach-zynq/include/{mach => mach-zynq}/timex.h  |    0
 .../mach-zynq/include/{mach => mach-zynq}/uart.h   |    0
 arch/arm/mach-zynq/include/mach-zynq/uncompress.h  |   51 +
 .../include/{mach => mach-zynq}/zynq_soc.h         |    0
 arch/arm/mach-zynq/include/mach/clkdev.h           |   32 -
 arch/arm/mach-zynq/include/mach/debug-macro.S      |   36 -
 arch/arm/mach-zynq/include/mach/uncompress.h       |   51 -
 arch/arm/mach-zynq/timer.c                         |    2 +-
 arch/arm/mm/cache-feroceon-l2.c                    |    2 +-
 arch/arm/plat-mxc/3ds_debugboard.c                 |    2 +-
 arch/arm/plat-mxc/avic.c                           |    6 +-
 arch/arm/plat-mxc/clock.c                          |    4 +-
 arch/arm/plat-mxc/cpu.c                            |    2 +-
 arch/arm/plat-mxc/cpufreq.c                        |    4 +-
 arch/arm/plat-mxc/devices.c                        |    2 +-
 arch/arm/plat-mxc/devices/platform-ahci-imx.c      |    4 +-
 arch/arm/plat-mxc/devices/platform-fec.c           |    4 +-
 arch/arm/plat-mxc/devices/platform-flexcan.c       |    4 +-
 arch/arm/plat-mxc/devices/platform-fsl-usb2-udc.c  |    4 +-
 arch/arm/plat-mxc/devices/platform-gpio-mxc.c      |    2 +-
 arch/arm/plat-mxc/devices/platform-gpio_keys.c     |    4 +-
 arch/arm/plat-mxc/devices/platform-imx-dma.c       |    2 +-
 arch/arm/plat-mxc/devices/platform-imx-fb.c        |    4 +-
 arch/arm/plat-mxc/devices/platform-imx-i2c.c       |    4 +-
 arch/arm/plat-mxc/devices/platform-imx-keypad.c    |    4 +-
 arch/arm/plat-mxc/devices/platform-imx-ssi.c       |    4 +-
 arch/arm/plat-mxc/devices/platform-imx-uart.c      |    4 +-
 arch/arm/plat-mxc/devices/platform-imx2-wdt.c      |    4 +-
 arch/arm/plat-mxc/devices/platform-imx21-hcd.c     |    4 +-
 arch/arm/plat-mxc/devices/platform-imx_udc.c       |    4 +-
 arch/arm/plat-mxc/devices/platform-imxdi_rtc.c     |    4 +-
 arch/arm/plat-mxc/devices/platform-ipu-core.c      |    4 +-
 arch/arm/plat-mxc/devices/platform-mx1-camera.c    |    4 +-
 arch/arm/plat-mxc/devices/platform-mx2-camera.c    |    4 +-
 arch/arm/plat-mxc/devices/platform-mxc-ehci.c      |    4 +-
 arch/arm/plat-mxc/devices/platform-mxc-mmc.c       |    4 +-
 arch/arm/plat-mxc/devices/platform-mxc_nand.c      |    4 +-
 arch/arm/plat-mxc/devices/platform-mxc_pwm.c       |    4 +-
 arch/arm/plat-mxc/devices/platform-mxc_rnga.c      |    4 +-
 arch/arm/plat-mxc/devices/platform-mxc_rtc.c       |    4 +-
 arch/arm/plat-mxc/devices/platform-mxc_w1.c        |    4 +-
 arch/arm/plat-mxc/devices/platform-pata_imx.c      |    4 +-
 .../plat-mxc/devices/platform-sdhci-esdhc-imx.c    |    6 +-
 arch/arm/plat-mxc/devices/platform-spi_imx.c       |    4 +-
 arch/arm/plat-mxc/epit.c                           |    4 +-
 arch/arm/plat-mxc/include/mach/debug-macro.S       |   51 -
 arch/arm/plat-mxc/include/mach/devices-common.h    |  333 ----
 arch/arm/plat-mxc/include/mach/hardware.h          |  134 --
 arch/arm/plat-mxc/include/mach/iomux-mx1.h         |  155 --
 arch/arm/plat-mxc/include/mach/iomux-mx21.h        |  122 --
 arch/arm/plat-mxc/include/mach/iomux-mx25.h        |  524 ------
 arch/arm/plat-mxc/include/mach/iomux-mx27.h        |  205 ---
 arch/arm/plat-mxc/include/mach/iomux-mx35.h        | 1267 ---------------
 arch/arm/plat-mxc/include/mach/iomux-mx50.h        |  977 ------------
 arch/arm/plat-mxc/include/mach/iomux-mx51.h        |  827 ----------
 arch/arm/plat-mxc/include/mach/iomux-mx53.h        | 1219 --------------
 arch/arm/plat-mxc/iomux-v1.c                       |    4 +-
 arch/arm/plat-mxc/iomux-v3.c                       |    4 +-
 arch/arm/plat-mxc/iram_alloc.c                     |    2 +-
 arch/arm/plat-mxc/ssi-fiq-ksym.c                   |    2 +-
 arch/arm/plat-mxc/system.c                         |    4 +-
 arch/arm/plat-mxc/time.c                           |    4 +-
 arch/arm/plat-mxc/tzic.c                           |    6 +-
 arch/arm/plat-mxc/ulpi.c                           |    2 +-
 .../include/{plat => plat-nomadik}/gpio-nomadik.h  |    0
 .../include/{plat => plat-nomadik}/mtu.h           |    0
 .../include/{plat => plat-nomadik}/pincfg.h        |    0
 .../include/{plat => plat-nomadik}/ske.h           |    0
 .../include/{plat => plat-nomadik}/ste_dma40.h     |    0
 arch/arm/plat-omap/clock.c                         |    2 +-
 arch/arm/plat-omap/common.c                        |   12 +-
 arch/arm/plat-omap/counter_32k.c                   |    8 +-
 arch/arm/plat-omap/debug-devices.c                 |    2 +-
 arch/arm/plat-omap/debug-leds.c                    |    2 +-
 arch/arm/plat-omap/devices.c                       |   10 +-
 arch/arm/plat-omap/dma.c                           |    4 +-
 arch/arm/plat-omap/dmtimer.c                       |    4 +-
 arch/arm/plat-omap/fb.c                            |    2 +-
 arch/arm/plat-omap/i2c.c                           |    8 +-
 .../plat-omap/include/{plat => plat-omap}/am33xx.h |    0
 .../include/{plat => plat-omap}/board-ams-delta.h  |    0
 .../include/{plat => plat-omap}/board-sx1.h        |    0
 .../include/{plat => plat-omap}/board-voiceblue.h  |    0
 arch/arm/plat-omap/include/plat-omap/board.h       |  138 ++
 .../include/{plat => plat-omap}/clkdev_omap.h      |    0
 .../plat-omap/include/{plat => plat-omap}/clock.h  |    0
 arch/arm/plat-omap/include/plat-omap/common.h      |   42 +
 arch/arm/plat-omap/include/plat-omap/cpu.h         |  495 ++++++
 .../include/{plat => plat-omap}/dma-44xx.h         |    0
 arch/arm/plat-omap/include/plat-omap/dma.h         |  544 +++++++
 .../include/{plat => plat-omap}/dmtimer.h          |    0
 .../plat-omap/include/{plat => plat-omap}/dsp.h    |    0
 .../plat-omap/include/{plat => plat-omap}/flash.h  |    0
 .../plat-omap/include/{plat => plat-omap}/fpga.h   |    0
 .../include/{plat => plat-omap}/gpio-switch.h      |    0
 .../plat-omap/include/{plat => plat-omap}/gpio.h   |    0
 .../include/{plat => plat-omap}/gpmc-smc91x.h      |    0
 .../include/{plat => plat-omap}/gpmc-smsc911x.h    |    0
 .../plat-omap/include/{plat => plat-omap}/gpmc.h   |    0
 arch/arm/plat-omap/include/plat-omap/hardware.h    |  293 ++++
 arch/arm/plat-omap/include/plat-omap/hdq1w.h       |   36 +
 .../plat-omap/include/{plat => plat-omap}/i2c.h    |    0
 arch/arm/plat-omap/include/plat-omap/iommu.h       |  206 +++
 .../plat-omap/include/{plat => plat-omap}/iommu2.h |    0
 .../include/{plat => plat-omap}/iopgtable.h        |    0
 .../plat-omap/include/{plat => plat-omap}/iovmm.h  |    0
 .../plat-omap/include/{plat => plat-omap}/irda.h   |    0
 .../include/{plat => plat-omap}/irqs-44xx.h        |    0
 .../plat-omap/include/{plat => plat-omap}/irqs.h   |    0
 .../plat-omap/include/{plat => plat-omap}/keypad.h |    0
 .../include/{plat => plat-omap}/l3_2xxx.h          |    0
 .../include/{plat => plat-omap}/l3_3xxx.h          |    0
 .../include/{plat => plat-omap}/l4_2xxx.h          |    0
 .../include/{plat => plat-omap}/l4_3xxx.h          |    0
 .../include/{plat => plat-omap}/lcd_mipid.h        |    0
 .../plat-omap/include/{plat => plat-omap}/led.h    |    0
 .../include/{plat => plat-omap}/mailbox.h          |    0
 .../plat-omap/include/{plat => plat-omap}/mcbsp.h  |    0
 .../plat-omap/include/{plat => plat-omap}/mcspi.h  |    0
 .../include/{plat => plat-omap}/menelaus.h         |    0
 arch/arm/plat-omap/include/plat-omap/mmc.h         |  189 +++
 .../plat-omap/include/{plat => plat-omap}/multi.h  |    0
 .../plat-omap/include/{plat => plat-omap}/mux.h    |    0
 arch/arm/plat-omap/include/plat-omap/nand.h        |   44 +
 .../include/{plat => plat-omap}/omap-pm.h          |    0
 .../include/{plat => plat-omap}/omap-secure.h      |    0
 arch/arm/plat-omap/include/plat-omap/omap-serial.h |  140 ++
 .../include/{plat => plat-omap}/omap1510.h         |    0
 .../include/{plat => plat-omap}/omap16xx.h         |    0
 .../include/{plat => plat-omap}/omap24xx.h         |    0
 .../include/{plat => plat-omap}/omap34xx.h         |    0
 .../include/{plat => plat-omap}/omap4-keypad.h     |    0
 .../include/{plat => plat-omap}/omap44xx.h         |    0
 .../include/{plat => plat-omap}/omap54xx.h         |    0
 .../include/{plat => plat-omap}/omap7xx.h          |    0
 arch/arm/plat-omap/include/plat-omap/omap_device.h |  170 ++
 arch/arm/plat-omap/include/plat-omap/omap_hwmod.h  |  664 ++++++++
 .../include/{plat => plat-omap}/onenand.h          |    0
 .../plat-omap/include/{plat => plat-omap}/param.h  |    0
 .../plat-omap/include/{plat => plat-omap}/prcm.h   |    0
 .../include/{plat => plat-omap}/remoteproc.h       |    0
 .../plat-omap/include/{plat => plat-omap}/sdrc.h   |    0
 .../plat-omap/include/{plat => plat-omap}/serial.h |    0
 .../plat-omap/include/{plat => plat-omap}/sram.h   |    0
 .../arm/plat-omap/include/{plat => plat-omap}/tc.h |    0
 .../plat-omap/include/{plat => plat-omap}/ti81xx.h |    0
 .../plat-omap/include/{plat => plat-omap}/timex.h  |    0
 arch/arm/plat-omap/include/plat-omap/uncompress.h  |  206 +++
 arch/arm/plat-omap/include/plat-omap/usb.h         |  173 ++
 .../include/{plat => plat-omap}/voltage.h          |    0
 .../plat-omap/include/{plat => plat-omap}/vram.h   |    0
 .../plat-omap/include/{plat => plat-omap}/vrfb.h   |    0
 arch/arm/plat-omap/include/plat/board.h            |  138 --
 arch/arm/plat-omap/include/plat/common.h           |   42 -
 arch/arm/plat-omap/include/plat/cpu.h              |  495 ------
 arch/arm/plat-omap/include/plat/dma.h              |  544 -------
 arch/arm/plat-omap/include/plat/hardware.h         |  293 ----
 arch/arm/plat-omap/include/plat/hdq1w.h            |   36 -
 arch/arm/plat-omap/include/plat/iommu.h            |  206 ---
 arch/arm/plat-omap/include/plat/mmc.h              |  189 ---
 arch/arm/plat-omap/include/plat/nand.h             |   44 -
 arch/arm/plat-omap/include/plat/omap-serial.h      |  140 --
 arch/arm/plat-omap/include/plat/omap_device.h      |  170 --
 arch/arm/plat-omap/include/plat/omap_hwmod.h       |  664 --------
 arch/arm/plat-omap/include/plat/uncompress.h       |  206 ---
 arch/arm/plat-omap/include/plat/usb.h              |  173 --
 arch/arm/plat-omap/mailbox.c                       |    2 +-
 arch/arm/plat-omap/mux.c                           |    4 +-
 arch/arm/plat-omap/omap-pm-noop.c                  |    4 +-
 arch/arm/plat-omap/omap_device.c                   |    6 +-
 arch/arm/plat-omap/sram.c                          |    6 +-
 arch/arm/plat-orion/addr-map.c                     |    2 +-
 arch/arm/plat-orion/common.c                       |    4 +-
 arch/arm/plat-orion/gpio.c                         |    2 +-
 .../include/{plat => plat-orion}/addr-map.h        |    0
 .../include/{plat => plat-orion}/audio.h           |    0
 .../{plat => plat-orion}/cache-feroceon-l2.h       |    0
 .../include/{plat => plat-orion}/common.h          |    0
 .../include/{plat => plat-orion}/ehci-orion.h      |    0
 .../plat-orion/include/{plat => plat-orion}/gpio.h |    0
 .../plat-orion/include/{plat => plat-orion}/irq.h  |    0
 .../plat-orion/include/{plat => plat-orion}/mpp.h  |    0
 .../include/{plat => plat-orion}/mv_xor.h          |    0
 .../include/{plat => plat-orion}/mvsdio.h          |    0
 .../include/{plat => plat-orion}/orion_nand.h      |    0
 .../plat-orion/include/{plat => plat-orion}/pcie.h |    0
 .../plat-orion/include/{plat => plat-orion}/time.h |    0
 arch/arm/plat-orion/irq.c                          |    4 +-
 arch/arm/plat-orion/mpp.c                          |    2 +-
 arch/arm/plat-orion/pcie.c                         |    4 +-
 arch/arm/plat-pxa/include/{plat => plat-pxa}/dma.h |    0
 arch/arm/plat-pxa/include/{plat => plat-pxa}/mfp.h |    0
 .../include/{plat => plat-pxa}/pxa27x_keypad.h     |    0
 .../include/{plat => plat-pxa}/pxa3xx_nand.h       |    0
 arch/arm/plat-pxa/mfp.c                            |    2 +-
 arch/arm/plat-s3c24xx/clock-dclk.c                 |    8 +-
 arch/arm/plat-s3c24xx/cpu-freq-debugfs.c           |    2 +-
 arch/arm/plat-s3c24xx/cpu-freq.c                   |    8 +-
 arch/arm/plat-s3c24xx/dma.c                        |   10 +-
 arch/arm/plat-s3c24xx/irq.c                        |    8 +-
 arch/arm/plat-s3c24xx/s3c2410-clock.c              |   14 +-
 arch/arm/plat-s3c24xx/s3c2410-cpufreq-utils.c      |    8 +-
 arch/arm/plat-s3c24xx/s3c2410-iotiming.c           |    8 +-
 arch/arm/plat-s3c24xx/s3c2412-iotiming.c           |    8 +-
 arch/arm/plat-samsung/adc.c                        |    4 +-
 arch/arm/plat-samsung/clock-clksrc.c               |    6 +-
 arch/arm/plat-samsung/clock.c                      |    8 +-
 arch/arm/plat-samsung/cpu.c                        |    2 +-
 arch/arm/plat-samsung/dev-backlight.c              |    6 +-
 arch/arm/plat-samsung/dev-uart.c                   |    2 +-
 arch/arm/plat-samsung/devs.c                       |   42 +-
 .../include/{plat => plat-samsung}/adc-core.h      |    0
 .../include/{plat => plat-samsung}/adc.h           |    0
 .../include/{plat => plat-samsung}/ata-core.h      |    0
 .../include/{plat => plat-samsung}/ata.h           |    0
 .../include/{plat => plat-samsung}/audio-simtec.h  |    0
 .../include/{plat => plat-samsung}/audio.h         |    0
 .../include/{plat => plat-samsung}/backlight.h     |    0
 .../include/{plat => plat-samsung}/camport.h       |    0
 .../include/{plat => plat-samsung}/clock-clksrc.h  |    0
 .../include/{plat => plat-samsung}/clock.h         |    0
 .../include/{plat => plat-samsung}/common-smdk.h   |    0
 .../include/plat-samsung/cpu-freq-core.h           |  293 ++++
 .../include/{plat => plat-samsung}/cpu-freq.h      |    0
 .../include/{plat => plat-samsung}/cpu.h           |    0
 .../include/plat-samsung/debug-macro.S             |   87 +
 .../include/{plat => plat-samsung}/devs.h          |    0
 .../include/{plat => plat-samsung}/dma-core.h      |    0
 .../include/{plat => plat-samsung}/dma-ops.h       |    0
 .../plat-samsung/include/plat-samsung/dma-pl330.h  |  122 ++
 .../include/plat-samsung/dma-s3c24xx.h             |   78 +
 arch/arm/plat-samsung/include/plat-samsung/dma.h   |  130 ++
 .../include/{plat => plat-samsung}/ehci.h          |    0
 .../include/{plat => plat-samsung}/fb-core.h       |    0
 .../include/{plat => plat-samsung}/fb-s3c2410.h    |    0
 .../include/{plat => plat-samsung}/fb.h            |    0
 .../include/{plat => plat-samsung}/fimc-core.h     |    0
 .../include/{plat => plat-samsung}/fiq.h           |    0
 .../{plat => plat-samsung}/gpio-cfg-helpers.h      |    0
 .../include/{plat => plat-samsung}/gpio-cfg.h      |    0
 .../plat-samsung/include/plat-samsung/gpio-core.h  |  124 ++
 .../plat-samsung/include/plat-samsung/gpio-fns.h   |   98 ++
 .../include/{plat => plat-samsung}/hwmon.h         |    0
 .../include/{plat => plat-samsung}/iic-core.h      |    0
 .../include/{plat => plat-samsung}/iic.h           |    0
 .../include/{plat => plat-samsung}/irq-uart.h      |    0
 .../include/{plat => plat-samsung}/irq-vic-timer.h |    0
 .../include/{plat => plat-samsung}/irq.h           |    0
 .../include/{plat => plat-samsung}/irqs.h          |    0
 .../include/{plat => plat-samsung}/keypad-core.h   |    0
 .../include/{plat => plat-samsung}/keypad.h        |    0
 .../include/{plat => plat-samsung}/map-base.h      |    0
 .../plat-samsung/include/plat-samsung/map-s3c.h    |   84 +
 .../plat-samsung/include/plat-samsung/map-s5p.h    |   61 +
 .../include/{plat => plat-samsung}/mci.h           |    0
 .../include/{plat => plat-samsung}/mfc.h           |    0
 .../include/{plat => plat-samsung}/mipi_csis.h     |    0
 .../include/{plat => plat-samsung}/nand-core.h     |    0
 .../include/{plat => plat-samsung}/nand.h          |    0
 .../include/{plat => plat-samsung}/onenand-core.h  |    0
 .../include/{plat => plat-samsung}/pll.h           |    0
 .../include/{plat => plat-samsung}/pm.h            |    0
 .../include/{plat => plat-samsung}/pwm-clock.h     |    0
 .../include/{plat => plat-samsung}/regs-ac97.h     |    0
 .../include/{plat => plat-samsung}/regs-adc.h      |    0
 .../include/{plat => plat-samsung}/regs-ata.h      |    0
 .../include/{plat => plat-samsung}/regs-dma.h      |    0
 .../plat-samsung/include/plat-samsung/regs-fb-v4.h |  159 ++
 .../include/{plat => plat-samsung}/regs-fb.h       |    0
 .../include/{plat => plat-samsung}/regs-iic.h      |    0
 .../include/{plat => plat-samsung}/regs-iis.h      |    0
 .../include/{plat => plat-samsung}/regs-irqtype.h  |    0
 .../include/{plat => plat-samsung}/regs-nand.h     |    0
 .../include/{plat => plat-samsung}/regs-onenand.h  |    0
 .../include/{plat => plat-samsung}/regs-rtc.h      |    0
 .../include/{plat => plat-samsung}/regs-sdhci.h    |    0
 .../include/{plat => plat-samsung}/regs-serial.h   |    0
 .../include/{plat => plat-samsung}/regs-spi.h      |    0
 .../include/{plat => plat-samsung}/regs-srom.h     |    0
 .../include/{plat => plat-samsung}/regs-timer.h    |    0
 .../include/{plat => plat-samsung}/regs-udc.h      |    0
 .../{plat => plat-samsung}/regs-usb-hsotg-phy.h    |    0
 .../include/{plat => plat-samsung}/regs-watchdog.h |    0
 .../include/{plat => plat-samsung}/rtc-core.h      |    0
 .../include/{plat => plat-samsung}/s3c2410.h       |    0
 .../include/{plat => plat-samsung}/s3c2412.h       |    0
 .../include/{plat => plat-samsung}/s3c2416.h       |    0
 .../include/{plat => plat-samsung}/s3c2443.h       |    0
 .../include/{plat => plat-samsung}/s3c244x.h       |    0
 .../include/{plat => plat-samsung}/s3c64xx-spi.h   |    0
 .../include/{plat => plat-samsung}/s5p-clock.h     |    0
 .../include/{plat => plat-samsung}/s5p-time.h      |    0
 arch/arm/plat-samsung/include/plat-samsung/sdhci.h |  380 +++++
 .../include/{plat => plat-samsung}/ts.h            |    0
 .../include/{plat => plat-samsung}/tv-core.h       |    0
 .../include/{plat => plat-samsung}/udc.h           |    0
 .../plat-samsung/include/plat-samsung/uncompress.h |  186 +++
 .../include/{plat => plat-samsung}/usb-control.h   |    0
 .../include/{plat => plat-samsung}/usb-phy.h       |    0
 .../include/{plat => plat-samsung}/wakeup-mask.h   |    0
 .../include/plat-samsung/watchdog-reset.h          |   46 +
 arch/arm/plat-samsung/include/plat/cpu-freq-core.h |  293 ----
 arch/arm/plat-samsung/include/plat/debug-macro.S   |   87 -
 arch/arm/plat-samsung/include/plat/dma-pl330.h     |  122 --
 arch/arm/plat-samsung/include/plat/dma-s3c24xx.h   |   78 -
 arch/arm/plat-samsung/include/plat/dma.h           |  130 --
 arch/arm/plat-samsung/include/plat/gpio-core.h     |  124 --
 arch/arm/plat-samsung/include/plat/gpio-fns.h      |   98 --
 arch/arm/plat-samsung/include/plat/map-s3c.h       |   84 -
 arch/arm/plat-samsung/include/plat/map-s5p.h       |   61 -
 arch/arm/plat-samsung/include/plat/regs-fb-v4.h    |  159 --
 arch/arm/plat-samsung/include/plat/sdhci.h         |  380 -----
 arch/arm/plat-samsung/include/plat/uncompress.h    |  186 ---
 .../arm/plat-samsung/include/plat/watchdog-reset.h |   46 -
 arch/arm/plat-samsung/init.c                       |    8 +-
 arch/arm/plat-samsung/irq-vic-timer.c              |    6 +-
 arch/arm/plat-samsung/platformdata.c               |    4 +-
 arch/arm/plat-samsung/pm-check.c                   |    2 +-
 arch/arm/plat-samsung/pm-gpio.c                    |    4 +-
 arch/arm/plat-samsung/pm.c                         |    4 +-
 arch/arm/plat-samsung/pwm-clock.c                  |    8 +-
 arch/arm/plat-samsung/s5p-clock.c                  |    6 +-
 arch/arm/plat-samsung/s5p-dev-mfc.c                |    6 +-
 arch/arm/plat-samsung/s5p-dev-uart.c               |    2 +-
 arch/arm/plat-samsung/s5p-irq-eint.c               |    8 +-
 arch/arm/plat-samsung/s5p-irq-gpioint.c            |    4 +-
 arch/arm/plat-samsung/s5p-irq-pm.c                 |    6 +-
 arch/arm/plat-samsung/s5p-irq.c                    |    6 +-
 arch/arm/plat-samsung/s5p-pm.c                     |    2 +-
 arch/arm/plat-samsung/s5p-time.c                   |    6 +-
 arch/arm/plat-samsung/time.c                       |    6 +-
 arch/arm/plat-samsung/wakeup-mask.c                |    4 +-
 .../include/{plat => plat-spear}/debug-macro.S     |    0
 .../plat-spear/include/{plat => plat-spear}/gpio.h |    0
 .../include/{plat => plat-spear}/keyboard.h        |    0
 .../include/{plat => plat-spear}/pl080.h           |    0
 .../include/{plat => plat-spear}/shirq.h           |    0
 .../include/{plat => plat-spear}/timex.h           |    0
 .../include/{plat => plat-spear}/uncompress.h      |    0
 arch/arm/plat-spear/shirq.c                        |    2 +-
 arch/arm/plat-versatile/clcd.c                     |    2 +-
 arch/arm/plat-versatile/fpga-irq.c                 |    2 +-
 .../include/{plat => plat-versatile}/clcd.h        |    0
 .../include/{plat => plat-versatile}/clock.h       |    0
 .../include/{plat => plat-versatile}/fpga-irq.h    |    0
 .../include/{plat => plat-versatile}/sched_clock.h |    0
 arch/arm/plat-versatile/sched-clock.c              |    2 +-
 arch/arm/tools/Makefile                            |    5 +
 arch/arm/tools/gen-headers                         |   57 +
 drivers/ata/pata_at91.c                            |    4 +-
 drivers/ata/pata_palmld.c                          |    2 +-
 drivers/ata/pata_pxa.c                             |    6 +-
 drivers/ata/pata_samsung_cf.c                      |    4 +-
 drivers/char/ds1620.c                              |    2 +-
 drivers/char/hw_random/ixp4xx-rng.c                |    2 +-
 drivers/char/hw_random/omap-rng.c                  |    2 +-
 drivers/char/msm_smd_pkt.c                         |    2 +-
 drivers/clk/clk-u300.c                             |    2 +-
 drivers/clk/mxs/clk-imx23.c                        |    4 +-
 drivers/clk/mxs/clk-imx28.c                        |    4 +-
 drivers/clocksource/clksrc-dbx500-prcmu.c          |    4 +-
 drivers/cpufreq/db8500-cpufreq.c                   |    2 +-
 drivers/cpufreq/exynos-cpufreq.c                   |    4 +-
 drivers/cpufreq/exynos4210-cpufreq.c               |    4 +-
 drivers/cpufreq/exynos4x12-cpufreq.c               |    4 +-
 drivers/cpufreq/exynos5250-cpufreq.c               |    6 +-
 drivers/cpufreq/omap-cpufreq.c                     |   10 +-
 drivers/cpufreq/s5pv210-cpufreq.c                  |    2 +-
 drivers/crypto/ixp4xx_crypto.c                     |    4 +-
 drivers/crypto/omap-aes.c                          |    4 +-
 drivers/crypto/omap-sham.c                         |    6 +-
 drivers/crypto/s5p-sss.c                           |    4 +-
 drivers/crypto/tegra-aes.c                         |    2 +-
 drivers/crypto/ux500/cryp/cryp_core.c              |    6 +-
 drivers/crypto/ux500/hash/hash_core.c              |    4 +-
 drivers/devfreq/exynos4_bus.c                      |    4 +-
 drivers/dma/at_hdmac_regs.h                        |    2 +-
 drivers/dma/coh901318.c                            |    2 +-
 drivers/dma/coh901318_lli.c                        |    2 +-
 drivers/dma/coh901318_lli.h                        |    2 +-
 drivers/dma/ep93xx_dma.c                           |    2 +-
 drivers/dma/imx-dma.c                              |    4 +-
 drivers/dma/imx-sdma.c                             |    6 +-
 drivers/dma/ipu/ipu_idmac.c                        |    2 +-
 drivers/dma/ipu/ipu_irq.c                          |    2 +-
 drivers/dma/mmp_tdma.c                             |    4 +-
 drivers/dma/mv_xor.c                               |    2 +-
 drivers/dma/omap-dma.c                             |    2 +-
 drivers/dma/ste_dma40.c                            |    2 +-
 drivers/dma/ste_dma40_ll.c                         |    2 +-
 drivers/gpio/gpio-ep93xx.c                         |    4 +-
 drivers/gpio/gpio-ks8695.c                         |    6 +-
 drivers/gpio/gpio-lpc32xx.c                        |    8 +-
 drivers/gpio/gpio-msm-v1.c                         |    6 +-
 drivers/gpio/gpio-msm-v2.c                         |    4 +-
 drivers/gpio/gpio-omap.c                           |    4 +-
 drivers/gpio/gpio-pxa.c                            |    8 +-
 drivers/gpio/gpio-samsung.c                        |   12 +-
 drivers/gpio/gpio-tegra.c                          |    4 +-
 drivers/gpio/gpio-tnetv107x.c                      |    4 +-
 drivers/gpu/drm/exynos/exynos_drm_fimd.c           |    2 +-
 drivers/hwmon/s3c-hwmon.c                          |    4 +-
 drivers/i2c/busses/i2c-acorn.c                     |    2 +-
 drivers/i2c/busses/i2c-at91.c                      |    6 +-
 drivers/i2c/busses/i2c-davinci.c                   |    4 +-
 drivers/i2c/busses/i2c-imx.c                       |    4 +-
 drivers/i2c/busses/i2c-nuc900.c                    |    4 +-
 drivers/i2c/busses/i2c-s3c2410.c                   |    4 +-
 drivers/i2c/busses/i2c-tegra.c                     |    2 +-
 drivers/iio/adc/at91_adc.c                         |    2 +-
 drivers/input/keyboard/davinci_keyscan.c           |    6 +-
 drivers/input/keyboard/ep93xx_keypad.c             |    4 +-
 drivers/input/keyboard/jornada720_kbd.c            |    6 +-
 drivers/input/keyboard/nomadik-ske-keypad.c        |    2 +-
 drivers/input/keyboard/omap-keypad.c               |    6 +-
 drivers/input/keyboard/pxa27x_keypad.c             |    2 +-
 drivers/input/keyboard/pxa930_rotary.c             |    2 +-
 drivers/input/keyboard/spear-keyboard.c            |    2 +-
 drivers/input/keyboard/tegra-kbc.c                 |    4 +-
 drivers/input/keyboard/w90p910_keypad.c            |    2 +-
 drivers/input/misc/ixp4xx-beeper.c                 |    2 +-
 drivers/input/mouse/pxa930_trkball.c               |    4 +-
 drivers/input/mouse/rpcmouse.c                     |    2 +-
 drivers/input/serio/ams_delta_serio.c              |    4 +-
 drivers/input/serio/rpckbd.c                       |    2 +-
 drivers/input/touchscreen/atmel_tsadcc.c           |    4 +-
 drivers/input/touchscreen/h3600_ts_input.c         |    4 +-
 drivers/input/touchscreen/jornada720_ts.c          |    6 +-
 drivers/input/touchscreen/mainstone-wm97xx.c       |    2 +-
 drivers/input/touchscreen/s3c2410_ts.c             |    6 +-
 drivers/input/touchscreen/tnetv107x-ts.c           |    2 +-
 drivers/input/touchscreen/zylonite-wm97xx.c        |    6 +-
 drivers/iommu/exynos-iommu.c                       |    2 +-
 drivers/iommu/msm_iommu.c                          |    4 +-
 drivers/iommu/msm_iommu_dev.c                      |    6 +-
 drivers/iommu/omap-iommu-debug.c                   |    6 +-
 drivers/iommu/omap-iommu.c                         |    4 +-
 drivers/iommu/omap-iovmm.c                         |    6 +-
 drivers/iommu/tegra-smmu.c                         |    6 +-
 drivers/leds/leds-fsg.c                            |    2 +-
 drivers/leds/leds-netxbig.c                        |    2 +-
 drivers/leds/leds-ns2.c                            |    2 +-
 drivers/leds/leds-s3c24xx.c                        |    6 +-
 drivers/media/video/davinci/isif.c                 |    2 +-
 drivers/media/video/davinci/vpbe_display.c         |    2 +-
 drivers/media/video/davinci/vpbe_osd.c             |    4 +-
 drivers/media/video/davinci/vpbe_venc.c            |    6 +-
 drivers/media/video/davinci/vpif.c                 |    2 +-
 drivers/media/video/davinci/vpss.c                 |    2 +-
 drivers/media/video/mx1_camera.c                   |    8 +-
 drivers/media/video/mx2_camera.c                   |    4 +-
 drivers/media/video/mx3_camera.c                   |    6 +-
 drivers/media/video/omap/omap_vout.c               |    4 +-
 drivers/media/video/omap/omap_vout_vrfb.c          |    4 +-
 drivers/media/video/omap/omap_voutdef.h            |    2 +-
 drivers/media/video/omap/omap_voutlib.c            |    2 +-
 drivers/media/video/omap1_camera.c                 |    2 +-
 drivers/media/video/omap3isp/isp.h                 |    4 +-
 drivers/media/video/omap3isp/ispreg.h              |    2 +-
 drivers/media/video/omap3isp/ispstat.h             |    2 +-
 drivers/media/video/omap3isp/ispvideo.c            |    6 +-
 drivers/media/video/pxa_camera.c                   |    4 +-
 drivers/media/video/s5p-fimc/mipi-csis.c           |    2 +-
 drivers/media/video/s5p-tv/sii9234_drv.c           |    2 +-
 drivers/mfd/db8500-prcmu.c                         |    8 +-
 drivers/mfd/dbx500-prcmu-regs.h                    |    2 +-
 drivers/mfd/mcp-sa11x0.c                           |    4 +-
 drivers/mfd/menelaus.c                             |    2 +-
 drivers/mfd/omap-usb-host.c                        |    4 +-
 drivers/mfd/ucb1x00-ts.c                           |    2 +-
 drivers/misc/ep93xx_pwm.c                          |    2 +-
 drivers/misc/spear13xx_pcie_gadget.c               |    4 +-
 drivers/mmc/host/at91_mci.c                        |    4 +-
 drivers/mmc/host/davinci_mmc.c                     |    4 +-
 drivers/mmc/host/msm_sdcc.c                        |    8 +-
 drivers/mmc/host/mvsdio.c                          |    2 +-
 drivers/mmc/host/mxcmmc.c                          |    6 +-
 drivers/mmc/host/omap.c                            |   10 +-
 drivers/mmc/host/omap_hsmmc.c                      |    8 +-
 drivers/mmc/host/pxamci.c                          |    6 +-
 drivers/mmc/host/s3cmci.c                          |    6 +-
 drivers/mmc/host/sdhci-cns3xxx.c                   |    2 +-
 drivers/mmc/host/sdhci-esdhc-imx.c                 |    2 +-
 drivers/mmc/host/sdhci-s3c.c                       |    4 +-
 drivers/mmc/host/sdhci-tegra.c                     |    4 +-
 drivers/mtd/maps/autcpu12-nvram.c                  |    4 +-
 drivers/mtd/maps/cdb89712.c                        |    2 +-
 drivers/mtd/maps/h720x-flash.c                     |    2 +-
 drivers/mtd/maps/pxa2xx-flash.c                    |    2 +-
 drivers/mtd/maps/sa1100-flash.c                    |    2 +-
 drivers/mtd/nand/ams-delta.c                       |    4 +-
 drivers/mtd/nand/autcpu12.c                        |    4 +-
 drivers/mtd/nand/bcm_umi_nand.c                    |    8 +-
 drivers/mtd/nand/cmx270_nand.c                     |    2 +-
 drivers/mtd/nand/davinci_nand.c                    |    4 +-
 drivers/mtd/nand/mxc_nand.c                        |    4 +-
 drivers/mtd/nand/nand_bcm_umi.c                    |    2 +-
 drivers/mtd/nand/nand_bcm_umi.h                    |    4 +-
 drivers/mtd/nand/nomadik_nand.c                    |    4 +-
 drivers/mtd/nand/omap2.c                           |    6 +-
 drivers/mtd/nand/orion_nand.c                      |    2 +-
 drivers/mtd/nand/pxa3xx_nand.c                     |    2 +-
 drivers/mtd/nand/s3c2410.c                         |    4 +-
 drivers/mtd/nand/sharpsl.c                         |    2 +-
 drivers/mtd/onenand/omap2.c                        |    8 +-
 drivers/mtd/onenand/samsung.c                      |    2 +-
 drivers/net/can/at91_can.c                         |    2 +-
 drivers/net/ethernet/amd/am79c961a.c               |    2 +-
 drivers/net/ethernet/cadence/at91_ether.c          |    4 +-
 drivers/net/ethernet/cirrus/ep93xx_eth.c           |    2 +-
 drivers/net/ethernet/micrel/ks8695net.c            |    6 +-
 drivers/net/ethernet/netx-eth.c                    |   10 +-
 drivers/net/ethernet/nxp/lpc_eth.c                 |    6 +-
 drivers/net/ethernet/smsc/smc911x.h                |    2 +-
 drivers/net/ethernet/smsc/smc91x.h                 |    4 +-
 drivers/net/ethernet/xscale/ixp4xx_eth.c           |    6 +-
 drivers/net/irda/ep7211-sir.c                      |    2 +-
 drivers/net/irda/pxaficp_ir.c                      |    8 +-
 drivers/net/irda/sa1100_ir.c                       |    2 +-
 drivers/net/wan/ixp4xx_hss.c                       |    4 +-
 drivers/pcmcia/at91_cf.c                           |    8 +-
 drivers/pcmcia/omap_cf.c                           |    6 +-
 drivers/pcmcia/pxa2xx_balloon3.c                   |    2 +-
 drivers/pcmcia/pxa2xx_base.c                       |    6 +-
 drivers/pcmcia/pxa2xx_cm_x2xx.c                    |    2 +-
 drivers/pcmcia/pxa2xx_e740.c                       |    2 +-
 drivers/pcmcia/pxa2xx_hx4700.c                     |    2 +-
 drivers/pcmcia/pxa2xx_mainstone.c                  |    4 +-
 drivers/pcmcia/pxa2xx_palmld.c                     |    2 +-
 drivers/pcmcia/pxa2xx_palmtc.c                     |    2 +-
 drivers/pcmcia/pxa2xx_palmtx.c                     |    2 +-
 drivers/pcmcia/pxa2xx_trizeps4.c                   |    4 +-
 drivers/pcmcia/pxa2xx_viper.c                      |    2 +-
 drivers/pcmcia/pxa2xx_vpac270.c                    |    2 +-
 drivers/pcmcia/sa1100_assabet.c                    |    2 +-
 drivers/pcmcia/sa1100_cerf.c                       |    4 +-
 drivers/pcmcia/sa1100_h3600.c                      |    4 +-
 drivers/pcmcia/sa1100_nanoengine.c                 |    4 +-
 drivers/pcmcia/sa1100_shannon.c                    |    4 +-
 drivers/pcmcia/sa1100_simpad.c                     |    4 +-
 drivers/pcmcia/sa1111_badge4.c                     |    4 +-
 drivers/pcmcia/sa1111_jornada720.c                 |    2 +-
 drivers/pcmcia/sa1111_lubbock.c                    |    4 +-
 drivers/pcmcia/sa1111_neponset.c                   |    4 +-
 drivers/pcmcia/sa11xx_base.c                       |    2 +-
 drivers/pinctrl/pinctrl-coh901.c                   |    2 +-
 drivers/pinctrl/pinctrl-nomadik.c                  |    4 +-
 drivers/pinctrl/pinctrl-nomadik.h                  |    2 +-
 drivers/pinctrl/pinctrl-tegra.c                    |    2 +-
 drivers/power/avs/smartreflex.c                    |    1 +
 drivers/power/collie_battery.c                     |    2 +-
 drivers/power/s3c_adc_battery.c                    |    2 +-
 drivers/power/tosa_battery.c                       |    2 +-
 drivers/ptp/ptp_ixp46x.c                           |    2 +-
 drivers/pwm/pwm-imx.c                              |    2 +-
 drivers/pwm/pwm-samsung.c                          |    2 +-
 drivers/remoteproc/omap_remoteproc.c               |    4 +-
 drivers/rtc/rtc-at91rm9200.c                       |    2 +-
 drivers/rtc/rtc-at91sam9.c                         |    6 +-
 drivers/rtc/rtc-mxc.c                              |    2 +-
 drivers/rtc/rtc-pxa.c                              |    2 +-
 drivers/rtc/rtc-s3c.c                              |    2 +-
 drivers/rtc/rtc-stmp3xxx.c                         |    2 +-
 drivers/scsi/arm/acornscsi-io.S                    |    2 +-
 drivers/spi/spi-davinci.c                          |    4 +-
 drivers/spi/spi-ep93xx.c                           |    4 +-
 drivers/spi/spi-imx.c                              |    2 +-
 drivers/spi/spi-nuc900.c                           |    2 +-
 drivers/spi/spi-omap-100k.c                        |    2 +-
 drivers/spi/spi-omap-uwire.c                       |    6 +-
 drivers/spi/spi-omap2-mcspi.c                      |    4 +-
 drivers/spi/spi-s3c24xx-fiq.S                      |    6 +-
 drivers/spi/spi-s3c24xx.c                          |    4 +-
 drivers/spi/spi-s3c64xx.c                          |    2 +-
 drivers/spi/spi-tegra.c                            |    2 +-
 drivers/staging/nvec/nvec.c                        |    4 +-
 drivers/staging/omapdrm/omap_dmm_tiler.h           |    2 +-
 .../staging/ste_rmi4/board-mop500-u8500uib-rmi4.c  |    4 +-
 drivers/staging/tidspbridge/core/dsp-clock.c       |    4 +-
 drivers/staging/tidspbridge/core/tiomap3430.c      |    2 +-
 drivers/staging/tidspbridge/core/tiomap3430_pwr.c  |    2 +-
 drivers/staging/tidspbridge/core/tiomap_io.c       |    2 +-
 drivers/staging/tidspbridge/core/ue_deh.c          |    2 +-
 .../tidspbridge/include/dspbridge/host_os.h        |    4 +-
 drivers/staging/tidspbridge/rmgr/drv_interface.c   |    2 +-
 drivers/tty/serial/21285.c                         |    2 +-
 drivers/tty/serial/atmel_serial.c                  |    6 +-
 drivers/tty/serial/clps711x.c                      |    2 +-
 drivers/tty/serial/imx.c                           |    2 +-
 drivers/tty/serial/msm_serial_hs.c                 |    4 +-
 drivers/tty/serial/msm_smd_tty.c                   |    2 +-
 drivers/tty/serial/netx-serial.c                   |    4 +-
 drivers/tty/serial/omap-serial.c                   |    6 +-
 drivers/tty/serial/sa1100.c                        |    4 +-
 drivers/tty/serial/samsung.c                       |    4 +-
 drivers/tty/serial/serial_ks8695.c                 |    4 +-
 drivers/uio/uio_pruss.c                            |    2 +-
 drivers/usb/gadget/at91_udc.c                      |   10 +-
 drivers/usb/gadget/atmel_usba_udc.c                |    4 +-
 drivers/usb/gadget/fsl_mxc_udc.c                   |    2 +-
 drivers/usb/gadget/imx_udc.c                       |    4 +-
 drivers/usb/gadget/omap_udc.c                      |    2 +-
 drivers/usb/gadget/pxa25x_udc.c                    |    4 +-
 drivers/usb/gadget/pxa25x_udc.h                    |    2 +-
 drivers/usb/gadget/pxa27x_udc.c                    |    4 +-
 drivers/usb/gadget/s3c-hsudc.c                     |    2 +-
 drivers/usb/gadget/s3c2410_udc.c                   |    4 +-
 drivers/usb/host/ehci-cns3xxx.c                    |    4 +-
 drivers/usb/host/ehci-mxc.c                        |    4 +-
 drivers/usb/host/ehci-omap.c                       |    2 +-
 drivers/usb/host/ehci-orion.c                      |    2 +-
 drivers/usb/host/ehci-s5p.c                        |    4 +-
 drivers/usb/host/ehci-tegra.c                      |    4 +-
 drivers/usb/host/imx21-hcd.h                       |    2 +-
 drivers/usb/host/ohci-at91.c                       |    6 +-
 drivers/usb/host/ohci-cns3xxx.c                    |    4 +-
 drivers/usb/host/ohci-da8xx.c                      |    4 +-
 drivers/usb/host/ohci-exynos.c                     |    4 +-
 drivers/usb/host/ohci-omap.c                       |    4 +-
 drivers/usb/host/ohci-omap3.c                      |    2 +-
 drivers/usb/host/ohci-pxa27x.c                     |    6 +-
 drivers/usb/host/ohci-s3c2410.c                    |    2 +-
 drivers/usb/host/ohci-sa1111.c                     |    4 +-
 drivers/usb/musb/am35x.c                           |    2 +-
 drivers/usb/musb/da8xx.c                           |    4 +-
 drivers/usb/musb/davinci.c                         |    4 +-
 drivers/usb/musb/musb_dsps.c                       |    2 +-
 drivers/usb/musb/omap2430.h                        |    2 +-
 drivers/usb/musb/tusb6010_omap.c                   |    4 +-
 drivers/usb/musb/ux500_dma.c                       |    2 +-
 drivers/usb/otg/isp1301_omap.c                     |    2 +-
 drivers/usb/otg/msm_otg.c                          |    2 +-
 drivers/video/acornfb.c                            |    4 +-
 drivers/video/backlight/jornada720_bl.c            |    4 +-
 drivers/video/backlight/jornada720_lcd.c           |    4 +-
 drivers/video/backlight/omap1_bl.c                 |    6 +-
 drivers/video/backlight/tosa_bl.c                  |    2 +-
 drivers/video/backlight/tosa_lcd.c                 |    2 +-
 drivers/video/clps711xfb.c                         |    4 +-
 drivers/video/cyber2000fb.c                        |    2 +-
 drivers/video/ep93xx-fb.c                          |    2 +-
 drivers/video/exynos/exynos_mipi_dsi.c             |    2 +-
 drivers/video/exynos/exynos_mipi_dsi_common.c      |    2 +-
 drivers/video/exynos/exynos_mipi_dsi_lowlevel.c    |    2 +-
 drivers/video/imxfb.c                              |    4 +-
 drivers/video/msm/mddi.c                           |    8 +-
 drivers/video/msm/mddi_client_dummy.c              |    2 +-
 drivers/video/msm/mddi_client_nt35399.c            |    2 +-
 drivers/video/msm/mddi_client_toshiba.c            |    2 +-
 drivers/video/msm/mdp.c                            |    4 +-
 drivers/video/msm/mdp_hw.h                         |    4 +-
 drivers/video/msm/mdp_ppp.c                        |    2 +-
 drivers/video/msm/msm_fb.c                         |    4 +-
 drivers/video/mx3fb.c                              |    8 +-
 drivers/video/nuc900fb.c                           |    8 +-
 drivers/video/nuc900fb.h                           |    4 +-
 drivers/video/omap/hwa742.c                        |    2 +-
 drivers/video/omap/lcd_ams_delta.c                 |    4 +-
 drivers/video/omap/lcd_inn1510.c                   |    2 +-
 drivers/video/omap/lcd_mipid.c                     |    2 +-
 drivers/video/omap/lcd_osk.c                       |    2 +-
 drivers/video/omap/lcd_palmte.c                    |    2 +-
 drivers/video/omap/lcdc.c                          |    4 +-
 drivers/video/omap/omapfb_main.c                   |    2 +-
 drivers/video/omap/sossi.c                         |    2 +-
 drivers/video/omap2/dss/dispc.c                    |    2 +-
 drivers/video/omap2/dss/dpi.c                      |    2 +-
 drivers/video/omap2/dss/dsi.c                      |    2 +-
 drivers/video/omap2/dss/dss.c                      |    4 +-
 drivers/video/omap2/dss/dss_features.c             |    2 +-
 drivers/video/omap2/dss/overlay.c                  |    2 +-
 drivers/video/omap2/dss/venc.c                     |    2 +-
 drivers/video/omap2/omapfb/omapfb-ioctl.c          |    4 +-
 drivers/video/omap2/omapfb/omapfb-main.c           |    4 +-
 drivers/video/omap2/omapfb/omapfb-sysfs.c          |    2 +-
 drivers/video/omap2/vram.c                         |    4 +-
 drivers/video/omap2/vrfb.c                         |    4 +-
 drivers/video/pnx4008/dum.h                        |    2 +-
 drivers/video/pxafb.c                              |    6 +-
 drivers/video/s3c-fb.c                             |    4 +-
 drivers/video/sa1100fb.c                           |    4 +-
 drivers/video/vt8500lcdfb.c                        |    2 +-
 drivers/video/wm8505fb.c                           |    2 +-
 drivers/w1/masters/omap_hdq.c                      |    2 +-
 drivers/watchdog/at91rm9200_wdt.c                  |    2 +-
 drivers/watchdog/imx2_wdt.c                        |    2 +-
 drivers/watchdog/ixp4xx_wdt.c                      |    2 +-
 drivers/watchdog/ks8695_wdt.c                      |    4 +-
 drivers/watchdog/omap_wdt.c                        |    2 +-
 drivers/watchdog/s3c2410_wdt.c                     |    2 +-
 drivers/watchdog/wdt285.c                          |    2 +-
 include/linux/mfd/davinci_voicecodec.h             |    2 +-
 include/linux/mfd/dbx500-prcmu.h                   |    2 +-
 include/linux/omapfb.h                             |    2 +-
 include/linux/platform_data/atmel-aes.h            |    2 +-
 include/linux/power/smartreflex.h                  |    2 +-
 include/linux/spi/pxa2xx_spi.h                     |    2 +-
 sound/arm/pxa2xx-ac97-lib.c                        |    6 +-
 sound/arm/pxa2xx-ac97.c                            |    4 +-
 sound/arm/pxa2xx-pcm-lib.c                         |    2 +-
 sound/arm/pxa2xx-pcm.h                             |    2 +-
 sound/atmel/ac97c.c                                |    6 +-
 sound/oss/vidc.c                                   |    2 +-
 sound/oss/vidc_fill.S                              |    2 +-
 sound/oss/waveartist.c                             |    2 +-
 sound/soc/atmel/atmel_ssc_dai.c                    |    2 +-
 sound/soc/atmel/sam9g20_wm8731.c                   |    4 +-
 sound/soc/atmel/snd-soc-afeb9260.c                 |    2 +-
 sound/soc/davinci/davinci-evm.c                    |    6 +-
 sound/soc/davinci/davinci-i2s.c                    |    2 +-
 sound/soc/davinci/davinci-mcasp.h                  |    2 +-
 sound/soc/davinci/davinci-pcm.c                    |    4 +-
 sound/soc/davinci/davinci-pcm.h                    |    4 +-
 sound/soc/davinci/davinci-sffsdr.c                 |    2 +-
 sound/soc/ep93xx/edb93xx.c                         |    2 +-
 sound/soc/ep93xx/ep93xx-ac97.c                     |    2 +-
 sound/soc/ep93xx/ep93xx-i2s.c                      |    6 +-
 sound/soc/ep93xx/ep93xx-pcm.c                      |    6 +-
 sound/soc/ep93xx/simone.c                          |    2 +-
 sound/soc/ep93xx/snappercl15.c                     |    2 +-
 sound/soc/fsl/imx-pcm-fiq.c                        |    4 +-
 sound/soc/fsl/imx-ssi.c                            |    4 +-
 sound/soc/fsl/mx27vis-aic32x4.c                    |    2 +-
 sound/soc/kirkwood/kirkwood-i2s.c                  |    2 +-
 sound/soc/kirkwood/kirkwood-openrd.c               |    4 +-
 sound/soc/kirkwood/kirkwood-t5325.c                |    4 +-
 sound/soc/mxs/mxs-saif.c                           |    4 +-
 sound/soc/nuc900/nuc900-ac97.c                     |    2 +-
 sound/soc/nuc900/nuc900-pcm.c                      |    2 +-
 sound/soc/omap/am3517evm.c                         |    6 +-
 sound/soc/omap/ams-delta.c                         |    4 +-
 sound/soc/omap/igep0020.c                          |    6 +-
 sound/soc/omap/mcbsp.c                             |    2 +-
 sound/soc/omap/n810.c                              |    4 +-
 sound/soc/omap/omap-abe-twl6040.c                  |    4 +-
 sound/soc/omap/omap-dmic.c                         |    2 +-
 sound/soc/omap/omap-hdmi.c                         |    2 +-
 sound/soc/omap/omap-mcbsp.c                        |    4 +-
 sound/soc/omap/omap-mcpdm.c                        |    4 +-
 sound/soc/omap/omap-pcm.c                          |    2 +-
 sound/soc/omap/omap3beagle.c                       |    6 +-
 sound/soc/omap/omap3evm.c                          |    6 +-
 sound/soc/omap/omap3pandora.c                      |    2 +-
 sound/soc/omap/osk5912.c                           |    4 +-
 sound/soc/omap/overo.c                             |    6 +-
 sound/soc/omap/rx51.c                              |    2 +-
 sound/soc/omap/sdp3430.c                           |    6 +-
 sound/soc/omap/zoom2.c                             |    8 +-
 sound/soc/pxa/corgi.c                              |    4 +-
 sound/soc/pxa/e740_wm9705.c                        |    4 +-
 sound/soc/pxa/e750_wm9705.c                        |    4 +-
 sound/soc/pxa/e800_wm9712.c                        |    4 +-
 sound/soc/pxa/em-x270.c                            |    2 +-
 sound/soc/pxa/hx4700.c                             |    2 +-
 sound/soc/pxa/magician.c                           |    2 +-
 sound/soc/pxa/mioa701_wm9713.c                     |    2 +-
 sound/soc/pxa/mmp-pcm.c                            |    2 +-
 sound/soc/pxa/palm27x.c                            |    4 +-
 sound/soc/pxa/poodle.c                             |    4 +-
 sound/soc/pxa/pxa-ssp.c                            |    4 +-
 sound/soc/pxa/pxa2xx-ac97.c                        |    8 +-
 sound/soc/pxa/pxa2xx-i2s.c                         |    6 +-
 sound/soc/pxa/spitz.c                              |    2 +-
 sound/soc/pxa/tosa.c                               |    4 +-
 sound/soc/pxa/z2.c                                 |    6 +-
 sound/soc/samsung/ac97.c                           |    4 +-
 sound/soc/samsung/h1940_uda1380.c                  |    4 +-
 sound/soc/samsung/i2s.c                            |    2 +-
 sound/soc/samsung/neo1973_wm8753.c                 |    4 +-
 sound/soc/samsung/pcm.c                            |    4 +-
 sound/soc/samsung/rx1950_uda1380.c                 |    2 +-
 sound/soc/samsung/s3c24xx-i2s.c                    |    2 +-
 sound/soc/samsung/s3c24xx_simtec.c                 |    2 +-
 sound/soc/samsung/s3c24xx_uda134x.c                |    2 +-
 sound/soc/samsung/spdif.c                          |    2 +-
 sound/soc/tegra/tegra30_ahub.c                     |    4 +-
 sound/soc/tegra/tegra_pcm.h                        |    2 +-
 sound/soc/tegra/tegra_wm8903.c                     |    2 +-
 sound/soc/ux500/mop500_ab8500.c                    |    2 +-
 sound/soc/ux500/ux500_msp_dai.c                    |    4 +-
 sound/soc/ux500/ux500_msp_i2s.c                    |    4 +-
 sound/soc/ux500/ux500_msp_i2s.h                    |    2 +-
 sound/soc/ux500/ux500_pcm.c                        |    2 +-
 3291 files changed, 48901 insertions(+), 48829 deletions(-)
 rename arch/arm/mach-at91/include/{mach => mach-at91}/at91_adc.h (100%)
 rename arch/arm/mach-at91/include/{mach => mach-at91}/at91_aic.h (100%)
 rename arch/arm/mach-at91/include/{mach => mach-at91}/at91_dbgu.h (100%)
 rename arch/arm/mach-at91/include/{mach => mach-at91}/at91_matrix.h (100%)
 rename arch/arm/mach-at91/include/{mach => mach-at91}/at91_pio.h (100%)
 rename arch/arm/mach-at91/include/{mach => mach-at91}/at91_pit.h (100%)
 rename arch/arm/mach-at91/include/{mach => mach-at91}/at91_pmc.h (100%)
 create mode 100644 arch/arm/mach-at91/include/mach-at91/at91_ramc.h
 rename arch/arm/mach-at91/include/{mach => mach-at91}/at91_rstc.h (100%)
 rename arch/arm/mach-at91/include/{mach => mach-at91}/at91_rtc.h (100%)
 rename arch/arm/mach-at91/include/{mach => mach-at91}/at91_rtt.h (100%)
 rename arch/arm/mach-at91/include/{mach => mach-at91}/at91_shdwc.h (100%)
 rename arch/arm/mach-at91/include/{mach => mach-at91}/at91_st.h (100%)
 rename arch/arm/mach-at91/include/{mach => mach-at91}/at91_tc.h (100%)
 rename arch/arm/mach-at91/include/{mach => mach-at91}/at91_twi.h (100%)
 rename arch/arm/mach-at91/include/{mach => mach-at91}/at91rm9200.h (100%)
 rename arch/arm/mach-at91/include/{mach => mach-at91}/at91rm9200_emac.h (100%)
 rename arch/arm/mach-at91/include/{mach => mach-at91}/at91rm9200_mc.h (100%)
 rename arch/arm/mach-at91/include/{mach => mach-at91}/at91rm9200_sdramc.h (100%)
 rename arch/arm/mach-at91/include/{mach => mach-at91}/at91sam9260.h (100%)
 rename arch/arm/mach-at91/include/{mach => mach-at91}/at91sam9260_matrix.h (100%)
 rename arch/arm/mach-at91/include/{mach => mach-at91}/at91sam9261.h (100%)
 rename arch/arm/mach-at91/include/{mach => mach-at91}/at91sam9261_matrix.h (100%)
 rename arch/arm/mach-at91/include/{mach => mach-at91}/at91sam9263.h (100%)
 rename arch/arm/mach-at91/include/{mach => mach-at91}/at91sam9263_matrix.h (100%)
 rename arch/arm/mach-at91/include/{mach => mach-at91}/at91sam9_ddrsdr.h (100%)
 rename arch/arm/mach-at91/include/{mach => mach-at91}/at91sam9_sdramc.h (100%)
 create mode 100644 arch/arm/mach-at91/include/mach-at91/at91sam9_smc.h
 rename arch/arm/mach-at91/include/{mach => mach-at91}/at91sam9g45.h (100%)
 rename arch/arm/mach-at91/include/{mach => mach-at91}/at91sam9g45_matrix.h (100%)
 rename arch/arm/mach-at91/include/{mach => mach-at91}/at91sam9n12.h (100%)
 rename arch/arm/mach-at91/include/{mach => mach-at91}/at91sam9n12_matrix.h (100%)
 rename arch/arm/mach-at91/include/{mach => mach-at91}/at91sam9rl.h (100%)
 rename arch/arm/mach-at91/include/{mach => mach-at91}/at91sam9rl_matrix.h (100%)
 rename arch/arm/mach-at91/include/{mach => mach-at91}/at91sam9x5.h (100%)
 rename arch/arm/mach-at91/include/{mach => mach-at91}/at91sam9x5_matrix.h (100%)
 rename arch/arm/mach-at91/include/{mach => mach-at91}/at91x40.h (100%)
 rename arch/arm/mach-at91/include/{mach => mach-at91}/at_hdmac.h (100%)
 create mode 100644 arch/arm/mach-at91/include/mach-at91/atmel-mci.h
 rename arch/arm/mach-at91/include/{mach => mach-at91}/board.h (100%)
 rename arch/arm/mach-at91/include/{mach => mach-at91}/cpu.h (100%)
 create mode 100644 arch/arm/mach-at91/include/mach-at91/debug-macro.S
 rename arch/arm/mach-at91/include/{mach => mach-at91}/gpio.h (100%)
 rename arch/arm/mach-at91/include/{mach => mach-at91}/gsia18s.h (100%)
 create mode 100644 arch/arm/mach-at91/include/mach-at91/hardware.h
 rename arch/arm/mach-at91/include/{mach => mach-at91}/io.h (100%)
 create mode 100644 arch/arm/mach-at91/include/mach-at91/memory.h
 rename arch/arm/mach-at91/include/{mach => mach-at91}/stamp9g20.h (100%)
 rename arch/arm/mach-at91/include/{mach => mach-at91}/system_rev.h (100%)
 create mode 100644 arch/arm/mach-at91/include/mach-at91/timex.h
 create mode 100644 arch/arm/mach-at91/include/mach-at91/uncompress.h
 delete mode 100644 arch/arm/mach-at91/include/mach/at91_ramc.h
 delete mode 100644 arch/arm/mach-at91/include/mach/at91sam9_smc.h
 delete mode 100644 arch/arm/mach-at91/include/mach/atmel-mci.h
 delete mode 100644 arch/arm/mach-at91/include/mach/debug-macro.S
 delete mode 100644 arch/arm/mach-at91/include/mach/hardware.h
 delete mode 100644 arch/arm/mach-at91/include/mach/memory.h
 delete mode 100644 arch/arm/mach-at91/include/mach/timex.h
 delete mode 100644 arch/arm/mach-at91/include/mach/uncompress.h
 rename arch/arm/mach-bcmring/include/{mach => mach-bcmring}/csp/cap.h (100%)
 create mode 100644 arch/arm/mach-bcmring/include/mach-bcmring/csp/cap_inline.h
 create mode 100644 arch/arm/mach-bcmring/include/mach-bcmring/csp/chipcHw_def.h
 create mode 100644 arch/arm/mach-bcmring/include/mach-bcmring/csp/chipcHw_inline.h
 create mode 100644 arch/arm/mach-bcmring/include/mach-bcmring/csp/chipcHw_reg.h
 create mode 100644 arch/arm/mach-bcmring/include/mach-bcmring/csp/ddrcReg.h
 rename arch/arm/mach-bcmring/include/{mach => mach-bcmring}/csp/dmacHw_priv.h (100%)
 create mode 100644 arch/arm/mach-bcmring/include/mach-bcmring/csp/dmacHw_reg.h
 create mode 100644 arch/arm/mach-bcmring/include/mach-bcmring/csp/hw_cfg.h
 create mode 100644 arch/arm/mach-bcmring/include/mach-bcmring/csp/intcHw_reg.h
 rename arch/arm/mach-bcmring/include/{mach => mach-bcmring}/csp/mm_addr.h (100%)
 create mode 100644 arch/arm/mach-bcmring/include/mach-bcmring/csp/mm_io.h
 create mode 100644 arch/arm/mach-bcmring/include/mach-bcmring/csp/secHw_def.h
 rename arch/arm/mach-bcmring/include/{mach => mach-bcmring}/csp/secHw_inline.h (100%)
 create mode 100644 arch/arm/mach-bcmring/include/mach-bcmring/csp/tmrHw_reg.h
 create mode 100644 arch/arm/mach-bcmring/include/mach-bcmring/dma.h
 create mode 100644 arch/arm/mach-bcmring/include/mach-bcmring/entry-macro.S
 create mode 100644 arch/arm/mach-bcmring/include/mach-bcmring/hardware.h
 rename arch/arm/mach-bcmring/include/{mach => mach-bcmring}/irqs.h (100%)
 rename arch/arm/mach-bcmring/include/{mach => mach-bcmring}/memory_settings.h (100%)
 create mode 100644 arch/arm/mach-bcmring/include/mach-bcmring/reg_nand.h
 create mode 100644 arch/arm/mach-bcmring/include/mach-bcmring/reg_umi.h
 rename arch/arm/mach-bcmring/include/{mach => mach-bcmring}/timer.h (100%)
 rename arch/arm/mach-bcmring/include/{mach => mach-bcmring}/timex.h (100%)
 create mode 100644 arch/arm/mach-bcmring/include/mach-bcmring/uncompress.h
 delete mode 100644 arch/arm/mach-bcmring/include/mach/csp/cap_inline.h
 delete mode 100644 arch/arm/mach-bcmring/include/mach/csp/chipcHw_def.h
 delete mode 100644 arch/arm/mach-bcmring/include/mach/csp/chipcHw_inline.h
 delete mode 100644 arch/arm/mach-bcmring/include/mach/csp/chipcHw_reg.h
 delete mode 100644 arch/arm/mach-bcmring/include/mach/csp/ddrcReg.h
 delete mode 100644 arch/arm/mach-bcmring/include/mach/csp/dmacHw_reg.h
 delete mode 100644 arch/arm/mach-bcmring/include/mach/csp/hw_cfg.h
 delete mode 100644 arch/arm/mach-bcmring/include/mach/csp/intcHw_reg.h
 delete mode 100644 arch/arm/mach-bcmring/include/mach/csp/mm_io.h
 delete mode 100644 arch/arm/mach-bcmring/include/mach/csp/secHw_def.h
 delete mode 100644 arch/arm/mach-bcmring/include/mach/csp/tmrHw_reg.h
 delete mode 100644 arch/arm/mach-bcmring/include/mach/dma.h
 delete mode 100644 arch/arm/mach-bcmring/include/mach/entry-macro.S
 delete mode 100644 arch/arm/mach-bcmring/include/mach/hardware.h
 delete mode 100644 arch/arm/mach-bcmring/include/mach/reg_nand.h
 delete mode 100644 arch/arm/mach-bcmring/include/mach/reg_umi.h
 delete mode 100644 arch/arm/mach-bcmring/include/mach/uncompress.h
 rename arch/arm/mach-clps711x/include/{mach => mach-clps711x}/autcpu12.h (100%)
 rename arch/arm/mach-clps711x/include/{mach => mach-clps711x}/clps711x.h (100%)
 create mode 100644 arch/arm/mach-clps711x/include/mach-clps711x/debug-macro.S
 create mode 100644 arch/arm/mach-clps711x/include/mach-clps711x/entry-macro.S
 create mode 100644 arch/arm/mach-clps711x/include/mach-clps711x/hardware.h
 rename arch/arm/mach-clps711x/include/{mach => mach-clps711x}/irqs.h (100%)
 rename arch/arm/mach-clps711x/include/{mach => mach-clps711x}/memory.h (100%)
 rename arch/arm/mach-clps711x/include/{mach => mach-clps711x}/syspld.h (100%)
 rename arch/arm/mach-clps711x/include/{mach => mach-clps711x}/timex.h (100%)
 create mode 100644 arch/arm/mach-clps711x/include/mach-clps711x/uncompress.h
 delete mode 100644 arch/arm/mach-clps711x/include/mach/debug-macro.S
 delete mode 100644 arch/arm/mach-clps711x/include/mach/entry-macro.S
 delete mode 100644 arch/arm/mach-clps711x/include/mach/hardware.h
 delete mode 100644 arch/arm/mach-clps711x/include/mach/uncompress.h
 rename arch/arm/mach-cns3xxx/include/{mach => mach-cns3xxx}/cns3xxx.h (100%)
 rename arch/arm/mach-cns3xxx/include/{mach => mach-cns3xxx}/debug-macro.S (100%)
 create mode 100644 arch/arm/mach-cns3xxx/include/mach-cns3xxx/irqs.h
 rename arch/arm/mach-cns3xxx/include/{mach => mach-cns3xxx}/pm.h (100%)
 rename arch/arm/mach-cns3xxx/include/{mach => mach-cns3xxx}/timex.h (100%)
 create mode 100644 arch/arm/mach-cns3xxx/include/mach-cns3xxx/uncompress.h
 delete mode 100644 arch/arm/mach-cns3xxx/include/mach/irqs.h
 delete mode 100644 arch/arm/mach-cns3xxx/include/mach/uncompress.h
 rename arch/arm/mach-davinci/include/{mach => mach-davinci}/aemif.h (100%)
 create mode 100644 arch/arm/mach-davinci/include/mach-davinci/asp.h
 create mode 100644 arch/arm/mach-davinci/include/mach-davinci/cdce949.h
 rename arch/arm/mach-davinci/include/{mach => mach-davinci}/clock.h (100%)
 rename arch/arm/mach-davinci/include/{mach => mach-davinci}/common.h (100%)
 rename arch/arm/mach-davinci/include/{mach => mach-davinci}/cp_intc.h (100%)
 rename arch/arm/mach-davinci/include/{mach => mach-davinci}/cpufreq.h (100%)
 rename arch/arm/mach-davinci/include/{mach => mach-davinci}/cpuidle.h (100%)
 create mode 100644 arch/arm/mach-davinci/include/mach-davinci/cputype.h
 create mode 100644 arch/arm/mach-davinci/include/mach-davinci/da8xx.h
 rename arch/arm/mach-davinci/include/{mach => mach-davinci}/ddr2.h (100%)
 create mode 100644 arch/arm/mach-davinci/include/mach-davinci/debug-macro.S
 rename arch/arm/mach-davinci/include/{mach => mach-davinci}/edma.h (100%)
 create mode 100644 arch/arm/mach-davinci/include/mach-davinci/entry-macro.S
 create mode 100644 arch/arm/mach-davinci/include/mach-davinci/gpio-davinci.h
 rename arch/arm/mach-davinci/include/{mach => mach-davinci}/gpio.h (100%)
 rename arch/arm/mach-davinci/include/{mach => mach-davinci}/hardware.h (100%)
 rename arch/arm/mach-davinci/include/{mach => mach-davinci}/i2c.h (100%)
 rename arch/arm/mach-davinci/include/{mach => mach-davinci}/irqs.h (100%)
 rename arch/arm/mach-davinci/include/{mach => mach-davinci}/keyscan.h (100%)
 rename arch/arm/mach-davinci/include/{mach => mach-davinci}/mmc.h (100%)
 rename arch/arm/mach-davinci/include/{mach => mach-davinci}/mux.h (100%)
 rename arch/arm/mach-davinci/include/{mach => mach-davinci}/nand.h (100%)
 rename arch/arm/mach-davinci/include/{mach => mach-davinci}/pm.h (100%)
 rename arch/arm/mach-davinci/include/{mach => mach-davinci}/psc.h (100%)
 create mode 100644 arch/arm/mach-davinci/include/mach-davinci/serial.h
 create mode 100644 arch/arm/mach-davinci/include/mach-davinci/spi.h
 rename arch/arm/mach-davinci/include/{mach => mach-davinci}/sram.h (100%)
 rename arch/arm/mach-davinci/include/{mach => mach-davinci}/time.h (100%)
 rename arch/arm/mach-davinci/include/{mach => mach-davinci}/timex.h (100%)
 create mode 100644 arch/arm/mach-davinci/include/mach-davinci/tnetv107x.h
 create mode 100644 arch/arm/mach-davinci/include/mach-davinci/uncompress.h
 rename arch/arm/mach-davinci/include/{mach => mach-davinci}/usb.h (100%)
 delete mode 100644 arch/arm/mach-davinci/include/mach/asp.h
 delete mode 100644 arch/arm/mach-davinci/include/mach/cdce949.h
 delete mode 100644 arch/arm/mach-davinci/include/mach/cputype.h
 delete mode 100644 arch/arm/mach-davinci/include/mach/da8xx.h
 delete mode 100644 arch/arm/mach-davinci/include/mach/debug-macro.S
 delete mode 100644 arch/arm/mach-davinci/include/mach/entry-macro.S
 delete mode 100644 arch/arm/mach-davinci/include/mach/gpio-davinci.h
 delete mode 100644 arch/arm/mach-davinci/include/mach/serial.h
 delete mode 100644 arch/arm/mach-davinci/include/mach/spi.h
 delete mode 100644 arch/arm/mach-davinci/include/mach/tnetv107x.h
 delete mode 100644 arch/arm/mach-davinci/include/mach/uncompress.h
 create mode 100644 arch/arm/mach-dove/include/mach-dove/bridge-regs.h
 create mode 100644 arch/arm/mach-dove/include/mach-dove/debug-macro.S
 rename arch/arm/mach-dove/include/{mach => mach-dove}/dove.h (100%)
 create mode 100644 arch/arm/mach-dove/include/mach-dove/entry-macro.S
 create mode 100644 arch/arm/mach-dove/include/mach-dove/gpio.h
 rename arch/arm/mach-dove/include/{mach => mach-dove}/hardware.h (100%)
 rename arch/arm/mach-dove/include/{mach => mach-dove}/io.h (100%)
 rename arch/arm/mach-dove/include/{mach => mach-dove}/irqs.h (100%)
 create mode 100644 arch/arm/mach-dove/include/mach-dove/pm.h
 rename arch/arm/mach-dove/include/{mach => mach-dove}/timex.h (100%)
 create mode 100644 arch/arm/mach-dove/include/mach-dove/uncompress.h
 delete mode 100644 arch/arm/mach-dove/include/mach/bridge-regs.h
 delete mode 100644 arch/arm/mach-dove/include/mach/debug-macro.S
 delete mode 100644 arch/arm/mach-dove/include/mach/entry-macro.S
 delete mode 100644 arch/arm/mach-dove/include/mach/gpio.h
 delete mode 100644 arch/arm/mach-dove/include/mach/pm.h
 delete mode 100644 arch/arm/mach-dove/include/mach/uncompress.h
 rename arch/arm/mach-ebsa110/include/{mach => mach-ebsa110}/debug-macro.S (100%)
 rename arch/arm/mach-ebsa110/include/{mach => mach-ebsa110}/entry-macro.S (100%)
 rename arch/arm/mach-ebsa110/include/{mach => mach-ebsa110}/hardware.h (100%)
 rename arch/arm/mach-ebsa110/include/{mach => mach-ebsa110}/io.h (100%)
 rename arch/arm/mach-ebsa110/include/{mach => mach-ebsa110}/irqs.h (100%)
 rename arch/arm/mach-ebsa110/include/{mach => mach-ebsa110}/memory.h (100%)
 rename arch/arm/mach-ebsa110/include/{mach => mach-ebsa110}/timex.h (100%)
 rename arch/arm/mach-ebsa110/include/{mach => mach-ebsa110}/uncompress.h (100%)
 create mode 100644 arch/arm/mach-ep93xx/include/mach-ep93xx/debug-macro.S
 rename arch/arm/mach-ep93xx/include/{mach => mach-ep93xx}/dma.h (100%)
 rename arch/arm/mach-ep93xx/include/{mach => mach-ep93xx}/ep93xx-regs.h (100%)
 rename arch/arm/mach-ep93xx/include/{mach => mach-ep93xx}/ep93xx_keypad.h (100%)
 rename arch/arm/mach-ep93xx/include/{mach => mach-ep93xx}/ep93xx_spi.h (100%)
 rename arch/arm/mach-ep93xx/include/{mach => mach-ep93xx}/fb.h (100%)
 create mode 100644 arch/arm/mach-ep93xx/include/mach-ep93xx/gpio-ep93xx.h
 rename arch/arm/mach-ep93xx/include/{mach => mach-ep93xx}/gpio.h (100%)
 create mode 100644 arch/arm/mach-ep93xx/include/mach-ep93xx/hardware.h
 rename arch/arm/mach-ep93xx/include/{mach => mach-ep93xx}/irqs.h (100%)
 rename arch/arm/mach-ep93xx/include/{mach => mach-ep93xx}/memory.h (100%)
 rename arch/arm/mach-ep93xx/include/{mach => mach-ep93xx}/platform.h (100%)
 rename arch/arm/mach-ep93xx/include/{mach => mach-ep93xx}/timex.h (100%)
 rename arch/arm/mach-ep93xx/include/{mach => mach-ep93xx}/ts72xx.h (100%)
 create mode 100644 arch/arm/mach-ep93xx/include/mach-ep93xx/uncompress.h
 delete mode 100644 arch/arm/mach-ep93xx/include/mach/debug-macro.S
 delete mode 100644 arch/arm/mach-ep93xx/include/mach/gpio-ep93xx.h
 delete mode 100644 arch/arm/mach-ep93xx/include/mach/hardware.h
 delete mode 100644 arch/arm/mach-ep93xx/include/mach/uncompress.h
 rename arch/arm/mach-exynos/include/{mach => mach-exynos}/cpufreq.h (100%)
 create mode 100644 arch/arm/mach-exynos/include/mach-exynos/debug-macro.S
 create mode 100644 arch/arm/mach-exynos/include/mach-exynos/dma.h
 rename arch/arm/mach-exynos/include/{mach => mach-exynos}/dwmci.h (100%)
 rename arch/arm/mach-exynos/include/{mach => mach-exynos}/gpio.h (100%)
 rename arch/arm/mach-exynos/include/{mach => mach-exynos}/hardware.h (100%)
 create mode 100644 arch/arm/mach-exynos/include/mach-exynos/irqs.h
 create mode 100644 arch/arm/mach-exynos/include/mach-exynos/map.h
 rename arch/arm/mach-exynos/include/{mach => mach-exynos}/memory.h (100%)
 rename arch/arm/mach-exynos/include/{mach => mach-exynos}/ohci.h (100%)
 create mode 100644 arch/arm/mach-exynos/include/mach-exynos/pm-core.h
 rename arch/arm/mach-exynos/include/{mach => mach-exynos}/pmu.h (100%)
 rename arch/arm/mach-exynos/include/{mach => mach-exynos}/regs-audss.h (100%)
 create mode 100644 arch/arm/mach-exynos/include/mach-exynos/regs-clock.h
 create mode 100644 arch/arm/mach-exynos/include/mach-exynos/regs-gpio.h
 create mode 100644 arch/arm/mach-exynos/include/mach-exynos/regs-irq.h
 create mode 100644 arch/arm/mach-exynos/include/mach-exynos/regs-mct.h
 create mode 100644 arch/arm/mach-exynos/include/mach-exynos/regs-mem.h
 create mode 100644 arch/arm/mach-exynos/include/mach-exynos/regs-pmu.h
 rename arch/arm/mach-exynos/include/{mach => mach-exynos}/regs-usb-phy.h (100%)
 rename arch/arm/mach-exynos/include/{mach => mach-exynos}/sysmmu.h (100%)
 rename arch/arm/mach-exynos/include/{mach => mach-exynos}/timex.h (100%)
 create mode 100644 arch/arm/mach-exynos/include/mach-exynos/uncompress.h
 delete mode 100644 arch/arm/mach-exynos/include/mach/debug-macro.S
 delete mode 100644 arch/arm/mach-exynos/include/mach/dma.h
 delete mode 100644 arch/arm/mach-exynos/include/mach/irqs.h
 delete mode 100644 arch/arm/mach-exynos/include/mach/map.h
 delete mode 100644 arch/arm/mach-exynos/include/mach/pm-core.h
 delete mode 100644 arch/arm/mach-exynos/include/mach/regs-clock.h
 delete mode 100644 arch/arm/mach-exynos/include/mach/regs-gpio.h
 delete mode 100644 arch/arm/mach-exynos/include/mach/regs-irq.h
 delete mode 100644 arch/arm/mach-exynos/include/mach/regs-mct.h
 delete mode 100644 arch/arm/mach-exynos/include/mach/regs-mem.h
 delete mode 100644 arch/arm/mach-exynos/include/mach/regs-pmu.h
 delete mode 100644 arch/arm/mach-exynos/include/mach/uncompress.h
 create mode 100644 arch/arm/mach-footbridge/include/mach-footbridge/debug-macro.S
 create mode 100644 arch/arm/mach-footbridge/include/mach-footbridge/entry-macro.S
 rename arch/arm/mach-footbridge/include/{mach => mach-footbridge}/hardware.h (100%)
 rename arch/arm/mach-footbridge/include/{mach => mach-footbridge}/io.h (100%)
 rename arch/arm/mach-footbridge/include/{mach => mach-footbridge}/irqs.h (100%)
 rename arch/arm/mach-footbridge/include/{mach => mach-footbridge}/isa-dma.h (100%)
 rename arch/arm/mach-footbridge/include/{mach => mach-footbridge}/memory.h (100%)
 rename arch/arm/mach-footbridge/include/{mach => mach-footbridge}/timex.h (100%)
 rename arch/arm/mach-footbridge/include/{mach => mach-footbridge}/uncompress.h (100%)
 delete mode 100644 arch/arm/mach-footbridge/include/mach/debug-macro.S
 delete mode 100644 arch/arm/mach-footbridge/include/mach/entry-macro.S
 create mode 100644 arch/arm/mach-gemini/include/mach-gemini/debug-macro.S
 create mode 100644 arch/arm/mach-gemini/include/mach-gemini/entry-macro.S
 rename arch/arm/mach-gemini/include/{mach => mach-gemini}/global_reg.h (100%)
 create mode 100644 arch/arm/mach-gemini/include/mach-gemini/gpio.h
 rename arch/arm/mach-gemini/include/{mach => mach-gemini}/hardware.h (100%)
 rename arch/arm/mach-gemini/include/{mach => mach-gemini}/irqs.h (100%)
 create mode 100644 arch/arm/mach-gemini/include/mach-gemini/system.h
 rename arch/arm/mach-gemini/include/{mach => mach-gemini}/timex.h (100%)
 create mode 100644 arch/arm/mach-gemini/include/mach-gemini/uncompress.h
 delete mode 100644 arch/arm/mach-gemini/include/mach/debug-macro.S
 delete mode 100644 arch/arm/mach-gemini/include/mach/entry-macro.S
 delete mode 100644 arch/arm/mach-gemini/include/mach/gpio.h
 delete mode 100644 arch/arm/mach-gemini/include/mach/system.h
 delete mode 100644 arch/arm/mach-gemini/include/mach/uncompress.h
 rename arch/arm/mach-h720x/include/{mach => mach-h720x}/boards.h (100%)
 create mode 100644 arch/arm/mach-h720x/include/mach-h720x/debug-macro.S
 rename arch/arm/mach-h720x/include/{mach => mach-h720x}/entry-macro.S (100%)
 rename arch/arm/mach-h720x/include/{mach => mach-h720x}/h7201-regs.h (100%)
 rename arch/arm/mach-h720x/include/{mach => mach-h720x}/h7202-regs.h (100%)
 rename arch/arm/mach-h720x/include/{mach => mach-h720x}/hardware.h (100%)
 rename arch/arm/mach-h720x/include/{mach => mach-h720x}/irqs.h (100%)
 rename arch/arm/mach-h720x/include/{mach => mach-h720x}/isa-dma.h (100%)
 rename arch/arm/mach-h720x/include/{mach => mach-h720x}/timex.h (100%)
 create mode 100644 arch/arm/mach-h720x/include/mach-h720x/uncompress.h
 delete mode 100644 arch/arm/mach-h720x/include/mach/debug-macro.S
 delete mode 100644 arch/arm/mach-h720x/include/mach/uncompress.h
 rename arch/arm/mach-highbank/include/{mach => mach-highbank}/debug-macro.S (100%)
 rename arch/arm/mach-highbank/include/{mach => mach-highbank}/gpio.h (100%)
 rename arch/arm/mach-highbank/include/{mach => mach-highbank}/timex.h (100%)
 rename arch/arm/mach-highbank/include/{mach => mach-highbank}/uncompress.h (100%)
 rename arch/arm/{plat-mxc/include/mach => mach-imx/include/mach-imx}/3ds_debugboard.h (100%)
 rename arch/arm/{plat-mxc/include/mach => mach-imx/include/mach-imx}/board-mx31lilly.h (100%)
 rename arch/arm/{plat-mxc/include/mach => mach-imx/include/mach-imx}/board-mx31lite.h (100%)
 rename arch/arm/{plat-mxc/include/mach => mach-imx/include/mach-imx}/board-mx31moboard.h (100%)
 rename arch/arm/{plat-mxc/include/mach => mach-imx/include/mach-imx}/board-pcm038.h (100%)
 rename arch/arm/{plat-mxc/include/mach => mach-imx/include/mach-imx}/clock.h (100%)
 rename arch/arm/{plat-mxc/include/mach => mach-imx/include/mach-imx}/common.h (100%)
 rename arch/arm/{plat-mxc/include/mach => mach-imx/include/mach-imx}/cpuidle.h (100%)
 create mode 100644 arch/arm/mach-imx/include/mach-imx/debug-macro.S
 create mode 100644 arch/arm/mach-imx/include/mach-imx/devices-common.h
 create mode 100644 arch/arm/mach-imx/include/mach-imx/dma-mx1-mx2.h
 rename arch/arm/{plat-mxc/include/mach => mach-imx/include/mach-imx}/dma.h (100%)
 rename arch/arm/{plat-mxc/include/mach => mach-imx/include/mach-imx}/esdhc.h (100%)
 rename arch/arm/{plat-mxc/include/mach => mach-imx/include/mach-imx}/eukrea-baseboards.h (100%)
 rename arch/arm/{mach-msm/include/mach => mach-imx/include/mach-imx}/gpio.h (100%)
 create mode 100644 arch/arm/mach-imx/include/mach-imx/hardware.h
 rename arch/arm/{plat-mxc/include/mach => mach-imx/include/mach-imx}/i2c.h (100%)
 rename arch/arm/{plat-mxc/include/mach => mach-imx/include/mach-imx}/iim.h (100%)
 rename arch/arm/{plat-mxc/include/mach => mach-imx/include/mach-imx}/imx-uart.h (100%)
 rename arch/arm/{plat-mxc/include/mach => mach-imx/include/mach-imx}/imxfb.h (100%)
 create mode 100644 arch/arm/mach-imx/include/mach-imx/iomux-mx1.h
 create mode 100644 arch/arm/mach-imx/include/mach-imx/iomux-mx21.h
 create mode 100644 arch/arm/mach-imx/include/mach-imx/iomux-mx25.h
 create mode 100644 arch/arm/mach-imx/include/mach-imx/iomux-mx27.h
 rename arch/arm/{plat-mxc/include/mach => mach-imx/include/mach-imx}/iomux-mx2x.h (100%)
 rename arch/arm/{plat-mxc/include/mach => mach-imx/include/mach-imx}/iomux-mx3.h (100%)
 create mode 100644 arch/arm/mach-imx/include/mach-imx/iomux-mx35.h
 create mode 100644 arch/arm/mach-imx/include/mach-imx/iomux-mx50.h
 create mode 100644 arch/arm/mach-imx/include/mach-imx/iomux-mx51.h
 create mode 100644 arch/arm/mach-imx/include/mach-imx/iomux-mx53.h
 rename arch/arm/{plat-mxc/include/mach => mach-imx/include/mach-imx}/iomux-v1.h (100%)
 rename arch/arm/{plat-mxc/include/mach => mach-imx/include/mach-imx}/iomux-v3.h (100%)
 rename arch/arm/{plat-mxc/include/mach => mach-imx/include/mach-imx}/ipu.h (100%)
 rename arch/arm/{plat-mxc/include/mach => mach-imx/include/mach-imx}/iram.h (100%)
 rename arch/arm/{plat-mxc/include/mach => mach-imx/include/mach-imx}/irqs.h (100%)
 rename arch/arm/{plat-mxc/include/mach => mach-imx/include/mach-imx}/mmc.h (100%)
 rename arch/arm/{plat-mxc/include/mach => mach-imx/include/mach-imx}/mx1.h (100%)
 rename arch/arm/{plat-mxc/include/mach => mach-imx/include/mach-imx}/mx1_camera.h (100%)
 rename arch/arm/{plat-mxc/include/mach => mach-imx/include/mach-imx}/mx21-usbhost.h (100%)
 rename arch/arm/{plat-mxc/include/mach => mach-imx/include/mach-imx}/mx21.h (100%)
 rename arch/arm/{plat-mxc/include/mach => mach-imx/include/mach-imx}/mx25.h (100%)
 rename arch/arm/{plat-mxc/include/mach => mach-imx/include/mach-imx}/mx27.h (100%)
 rename arch/arm/{plat-mxc/include/mach => mach-imx/include/mach-imx}/mx2_cam.h (100%)
 rename arch/arm/{plat-mxc/include/mach => mach-imx/include/mach-imx}/mx2x.h (100%)
 rename arch/arm/{plat-mxc/include/mach => mach-imx/include/mach-imx}/mx31.h (100%)
 rename arch/arm/{plat-mxc/include/mach => mach-imx/include/mach-imx}/mx35.h (100%)
 rename arch/arm/{plat-mxc/include/mach => mach-imx/include/mach-imx}/mx3_camera.h (100%)
 rename arch/arm/{plat-mxc/include/mach => mach-imx/include/mach-imx}/mx3fb.h (100%)
 rename arch/arm/{plat-mxc/include/mach => mach-imx/include/mach-imx}/mx3x.h (100%)
 rename arch/arm/{plat-mxc/include/mach => mach-imx/include/mach-imx}/mx50.h (100%)
 rename arch/arm/{plat-mxc/include/mach => mach-imx/include/mach-imx}/mx51.h (100%)
 rename arch/arm/{plat-mxc/include/mach => mach-imx/include/mach-imx}/mx53.h (100%)
 rename arch/arm/{plat-mxc/include/mach => mach-imx/include/mach-imx}/mx6q.h (100%)
 rename arch/arm/{plat-mxc/include/mach => mach-imx/include/mach-imx}/mxc.h (100%)
 rename arch/arm/{plat-mxc/include/mach => mach-imx/include/mach-imx}/mxc_ehci.h (100%)
 rename arch/arm/{plat-mxc/include/mach => mach-imx/include/mach-imx}/mxc_nand.h (100%)
 rename arch/arm/{plat-mxc/include/mach => mach-imx/include/mach-imx}/sdma.h (100%)
 rename arch/arm/{plat-mxc/include/mach => mach-imx/include/mach-imx}/spi.h (100%)
 rename arch/arm/{plat-mxc/include/mach => mach-imx/include/mach-imx}/ssi.h (100%)
 rename arch/arm/{plat-mxc/include/mach => mach-imx/include/mach-imx}/timex.h (100%)
 rename arch/arm/{plat-mxc/include/mach => mach-imx/include/mach-imx}/ulpi.h (100%)
 rename arch/arm/{plat-mxc/include/mach => mach-imx/include/mach-imx}/uncompress.h (100%)
 rename arch/arm/{plat-mxc/include/mach => mach-imx/include/mach-imx}/usb.h (100%)
 delete mode 100644 arch/arm/mach-imx/include/mach/dma-mx1-mx2.h
 rename arch/arm/mach-integrator/include/{mach => mach-integrator}/cm.h (100%)
 rename arch/arm/mach-integrator/include/{mach => mach-integrator}/debug-macro.S (100%)
 rename arch/arm/mach-integrator/include/{mach => mach-integrator}/hardware.h (100%)
 rename arch/arm/mach-integrator/include/{mach => mach-integrator}/impd1.h (100%)
 rename arch/arm/mach-integrator/include/{mach => mach-integrator}/io.h (100%)
 rename arch/arm/mach-integrator/include/{mach => mach-integrator}/irqs.h (100%)
 rename arch/arm/mach-integrator/include/{mach => mach-integrator}/lm.h (100%)
 rename arch/arm/mach-integrator/include/{mach => mach-integrator}/memory.h (100%)
 rename arch/arm/mach-integrator/include/{mach => mach-integrator}/platform.h (100%)
 rename arch/arm/mach-integrator/include/{mach => mach-integrator}/timex.h (100%)
 rename arch/arm/mach-integrator/include/{mach => mach-integrator}/uncompress.h (100%)
 create mode 100644 arch/arm/mach-iop13xx/include/mach-iop13xx/adma.h
 rename arch/arm/mach-iop13xx/include/{mach => mach-iop13xx}/debug-macro.S (100%)
 rename arch/arm/mach-iop13xx/include/{mach => mach-iop13xx}/entry-macro.S (100%)
 rename arch/arm/mach-iop13xx/include/{mach => mach-iop13xx}/hardware.h (100%)
 rename arch/arm/mach-iop13xx/include/{mach => mach-iop13xx}/io.h (100%)
 rename arch/arm/mach-iop13xx/include/{mach => mach-iop13xx}/iop13xx.h (100%)
 rename arch/arm/mach-iop13xx/include/{mach => mach-iop13xx}/iq81340.h (100%)
 rename arch/arm/mach-iop13xx/include/{mach => mach-iop13xx}/irqs.h (100%)
 create mode 100644 arch/arm/mach-iop13xx/include/mach-iop13xx/memory.h
 rename arch/arm/mach-iop13xx/include/{mach => mach-iop13xx}/msi.h (100%)
 create mode 100644 arch/arm/mach-iop13xx/include/mach-iop13xx/pci.h
 rename arch/arm/mach-iop13xx/include/{mach => mach-iop13xx}/time.h (100%)
 rename arch/arm/mach-iop13xx/include/{mach => mach-iop13xx}/timex.h (100%)
 create mode 100644 arch/arm/mach-iop13xx/include/mach-iop13xx/uncompress.h
 delete mode 100644 arch/arm/mach-iop13xx/include/mach/adma.h
 delete mode 100644 arch/arm/mach-iop13xx/include/mach/memory.h
 delete mode 100644 arch/arm/mach-iop13xx/include/mach/pci.h
 delete mode 100644 arch/arm/mach-iop13xx/include/mach/uncompress.h
 rename arch/arm/mach-iop32x/include/{mach => mach-iop32x}/adma.h (100%)
 rename arch/arm/mach-iop32x/include/{mach => mach-iop32x}/debug-macro.S (100%)
 create mode 100644 arch/arm/mach-iop32x/include/mach-iop32x/entry-macro.S
 rename arch/arm/mach-iop32x/include/{mach => mach-iop32x}/glantank.h (100%)
 rename arch/arm/mach-iop32x/include/{mach => mach-iop32x}/gpio.h (100%)
 rename arch/arm/mach-iop32x/include/{mach => mach-iop32x}/hardware.h (100%)
 rename arch/arm/mach-iop32x/include/{mach => mach-iop32x}/io.h (100%)
 rename arch/arm/mach-iop32x/include/{mach => mach-iop32x}/iop32x.h (100%)
 rename arch/arm/mach-iop32x/include/{mach => mach-iop32x}/iq31244.h (100%)
 rename arch/arm/mach-iop32x/include/{mach => mach-iop32x}/iq80321.h (100%)
 rename arch/arm/mach-iop32x/include/{mach => mach-iop32x}/irqs.h (100%)
 rename arch/arm/mach-iop32x/include/{mach => mach-iop32x}/n2100.h (100%)
 rename arch/arm/mach-iop32x/include/{mach => mach-iop32x}/time.h (100%)
 rename arch/arm/mach-iop32x/include/{mach => mach-iop32x}/timex.h (100%)
 create mode 100644 arch/arm/mach-iop32x/include/mach-iop32x/uncompress.h
 delete mode 100644 arch/arm/mach-iop32x/include/mach/entry-macro.S
 delete mode 100644 arch/arm/mach-iop32x/include/mach/uncompress.h
 rename arch/arm/mach-iop33x/include/{mach => mach-iop33x}/adma.h (100%)
 rename arch/arm/mach-iop33x/include/{mach => mach-iop33x}/debug-macro.S (100%)
 create mode 100644 arch/arm/mach-iop33x/include/mach-iop33x/entry-macro.S
 rename arch/arm/mach-iop33x/include/{mach => mach-iop33x}/gpio.h (100%)
 rename arch/arm/mach-iop33x/include/{mach => mach-iop33x}/hardware.h (100%)
 rename arch/arm/mach-iop33x/include/{mach => mach-iop33x}/io.h (100%)
 rename arch/arm/mach-iop33x/include/{mach => mach-iop33x}/iop33x.h (100%)
 rename arch/arm/mach-iop33x/include/{mach => mach-iop33x}/iq80331.h (100%)
 rename arch/arm/mach-iop33x/include/{mach => mach-iop33x}/iq80332.h (100%)
 rename arch/arm/mach-iop33x/include/{mach => mach-iop33x}/irqs.h (100%)
 rename arch/arm/mach-iop33x/include/{mach => mach-iop33x}/time.h (100%)
 rename arch/arm/mach-iop33x/include/{mach => mach-iop33x}/timex.h (100%)
 create mode 100644 arch/arm/mach-iop33x/include/mach-iop33x/uncompress.h
 delete mode 100644 arch/arm/mach-iop33x/include/mach/entry-macro.S
 delete mode 100644 arch/arm/mach-iop33x/include/mach/uncompress.h
 rename arch/arm/mach-ixp4xx/include/{mach => mach-ixp4xx}/cpu.h (100%)
 rename arch/arm/mach-ixp4xx/include/{mach => mach-ixp4xx}/debug-macro.S (100%)
 create mode 100644 arch/arm/mach-ixp4xx/include/mach-ixp4xx/entry-macro.S
 rename arch/arm/mach-ixp4xx/include/{mach => mach-ixp4xx}/gpio.h (100%)
 create mode 100644 arch/arm/mach-ixp4xx/include/mach-ixp4xx/hardware.h
 create mode 100644 arch/arm/mach-ixp4xx/include/mach-ixp4xx/io.h
 rename arch/arm/mach-ixp4xx/include/{mach => mach-ixp4xx}/irqs.h (100%)
 rename arch/arm/mach-ixp4xx/include/{mach => mach-ixp4xx}/ixp46x_ts.h (100%)
 rename arch/arm/mach-ixp4xx/include/{mach => mach-ixp4xx}/ixp4xx-regs.h (100%)
 rename arch/arm/mach-ixp4xx/include/{mach => mach-ixp4xx}/npe.h (100%)
 create mode 100644 arch/arm/mach-ixp4xx/include/mach-ixp4xx/platform.h
 rename arch/arm/mach-ixp4xx/include/{mach => mach-ixp4xx}/qmgr.h (100%)
 create mode 100644 arch/arm/mach-ixp4xx/include/mach-ixp4xx/timex.h
 rename arch/arm/mach-ixp4xx/include/{mach => mach-ixp4xx}/udc.h (100%)
 rename arch/arm/mach-ixp4xx/include/{mach => mach-ixp4xx}/uncompress.h (100%)
 delete mode 100644 arch/arm/mach-ixp4xx/include/mach/entry-macro.S
 delete mode 100644 arch/arm/mach-ixp4xx/include/mach/hardware.h
 delete mode 100644 arch/arm/mach-ixp4xx/include/mach/io.h
 delete mode 100644 arch/arm/mach-ixp4xx/include/mach/platform.h
 delete mode 100644 arch/arm/mach-ixp4xx/include/mach/timex.h
 create mode 100644 arch/arm/mach-kirkwood/include/mach-kirkwood/bridge-regs.h
 create mode 100644 arch/arm/mach-kirkwood/include/mach-kirkwood/debug-macro.S
 create mode 100644 arch/arm/mach-kirkwood/include/mach-kirkwood/entry-macro.S
 create mode 100644 arch/arm/mach-kirkwood/include/mach-kirkwood/gpio.h
 rename arch/arm/mach-kirkwood/include/{mach => mach-kirkwood}/hardware.h (100%)
 rename arch/arm/mach-kirkwood/include/{mach => mach-kirkwood}/io.h (100%)
 rename arch/arm/mach-kirkwood/include/{mach => mach-kirkwood}/irqs.h (100%)
 rename arch/arm/mach-kirkwood/include/{mach => mach-kirkwood}/kirkwood.h (100%)
 rename arch/arm/mach-kirkwood/include/{mach => mach-kirkwood}/leds-netxbig.h (100%)
 rename arch/arm/mach-kirkwood/include/{mach => mach-kirkwood}/leds-ns2.h (100%)
 rename arch/arm/mach-kirkwood/include/{mach => mach-kirkwood}/timex.h (100%)
 create mode 100644 arch/arm/mach-kirkwood/include/mach-kirkwood/uncompress.h
 delete mode 100644 arch/arm/mach-kirkwood/include/mach/bridge-regs.h
 delete mode 100644 arch/arm/mach-kirkwood/include/mach/debug-macro.S
 delete mode 100644 arch/arm/mach-kirkwood/include/mach/entry-macro.S
 delete mode 100644 arch/arm/mach-kirkwood/include/mach/gpio.h
 delete mode 100644 arch/arm/mach-kirkwood/include/mach/uncompress.h
 create mode 100644 arch/arm/mach-ks8695/include/mach-ks8695/debug-macro.S
 rename arch/arm/mach-ks8695/include/{mach => mach-ks8695}/devices.h (100%)
 create mode 100644 arch/arm/mach-ks8695/include/mach-ks8695/entry-macro.S
 rename arch/arm/mach-ks8695/include/{mach => mach-ks8695}/gpio-ks8695.h (100%)
 rename arch/arm/mach-ks8695/include/{mach => mach-ks8695}/gpio.h (100%)
 rename arch/arm/mach-ks8695/include/{mach => mach-ks8695}/hardware.h (100%)
 rename arch/arm/mach-ks8695/include/{mach => mach-ks8695}/irqs.h (100%)
 create mode 100644 arch/arm/mach-ks8695/include/mach-ks8695/memory.h
 rename arch/arm/mach-ks8695/include/{mach => mach-ks8695}/regs-gpio.h (100%)
 rename arch/arm/mach-ks8695/include/{mach => mach-ks8695}/regs-hpna.h (100%)
 rename arch/arm/mach-ks8695/include/{mach => mach-ks8695}/regs-irq.h (100%)
 rename arch/arm/mach-ks8695/include/{mach => mach-ks8695}/regs-lan.h (100%)
 rename arch/arm/mach-ks8695/include/{mach => mach-ks8695}/regs-mem.h (100%)
 rename arch/arm/mach-ks8695/include/{mach => mach-ks8695}/regs-misc.h (100%)
 rename arch/arm/mach-ks8695/include/{mach => mach-ks8695}/regs-pci.h (100%)
 rename arch/arm/mach-ks8695/include/{mach => mach-ks8695}/regs-switch.h (100%)
 rename arch/arm/mach-ks8695/include/{mach => mach-ks8695}/regs-sys.h (100%)
 rename arch/arm/mach-ks8695/include/{mach => mach-ks8695}/regs-timer.h (100%)
 rename arch/arm/mach-ks8695/include/{mach => mach-ks8695}/regs-uart.h (100%)
 rename arch/arm/mach-ks8695/include/{mach => mach-ks8695}/regs-wan.h (100%)
 create mode 100644 arch/arm/mach-ks8695/include/mach-ks8695/timex.h
 create mode 100644 arch/arm/mach-ks8695/include/mach-ks8695/uncompress.h
 delete mode 100644 arch/arm/mach-ks8695/include/mach/debug-macro.S
 delete mode 100644 arch/arm/mach-ks8695/include/mach/entry-macro.S
 delete mode 100644 arch/arm/mach-ks8695/include/mach/memory.h
 delete mode 100644 arch/arm/mach-ks8695/include/mach/timex.h
 delete mode 100644 arch/arm/mach-ks8695/include/mach/uncompress.h
 rename arch/arm/mach-l7200/include/{mach => mach-l7200}/debug-macro.S (100%)
 rename arch/arm/mach-lpc32xx/include/{mach => mach-lpc32xx}/board.h (100%)
 rename arch/arm/mach-lpc32xx/include/{mach => mach-lpc32xx}/debug-macro.S (100%)
 create mode 100644 arch/arm/mach-lpc32xx/include/mach-lpc32xx/entry-macro.S
 rename arch/arm/mach-lpc32xx/include/{mach => mach-lpc32xx}/gpio-lpc32xx.h (100%)
 rename arch/arm/mach-lpc32xx/include/{mach => mach-lpc32xx}/gpio.h (100%)
 rename arch/arm/mach-lpc32xx/include/{mach => mach-lpc32xx}/hardware.h (100%)
 rename arch/arm/mach-lpc32xx/include/{mach => mach-lpc32xx}/irqs.h (100%)
 rename arch/arm/mach-lpc32xx/include/{mach => mach-lpc32xx}/platform.h (100%)
 rename arch/arm/mach-lpc32xx/include/{mach => mach-lpc32xx}/timex.h (100%)
 create mode 100644 arch/arm/mach-lpc32xx/include/mach-lpc32xx/uncompress.h
 delete mode 100644 arch/arm/mach-lpc32xx/include/mach/entry-macro.S
 delete mode 100644 arch/arm/mach-lpc32xx/include/mach/uncompress.h
 rename arch/arm/mach-mmp/include/{mach => mach-mmp}/addr-map.h (100%)
 rename arch/arm/mach-mmp/include/{mach => mach-mmp}/cputype.h (100%)
 create mode 100644 arch/arm/mach-mmp/include/mach-mmp/debug-macro.S
 rename arch/arm/mach-mmp/include/{mach => mach-mmp}/devices.h (100%)
 create mode 100644 arch/arm/mach-mmp/include/mach-mmp/dma.h
 create mode 100644 arch/arm/mach-mmp/include/mach-mmp/entry-macro.S
 create mode 100644 arch/arm/mach-mmp/include/mach-mmp/gpio.h
 rename arch/arm/mach-mmp/include/{mach => mach-mmp}/hardware.h (100%)
 rename arch/arm/mach-mmp/include/{mach => mach-mmp}/irqs.h (100%)
 create mode 100644 arch/arm/mach-mmp/include/mach-mmp/mfp-mmp2.h
 create mode 100644 arch/arm/mach-mmp/include/mach-mmp/mfp-pxa168.h
 create mode 100644 arch/arm/mach-mmp/include/mach-mmp/mfp-pxa910.h
 create mode 100644 arch/arm/mach-mmp/include/mach-mmp/mfp.h
 create mode 100644 arch/arm/mach-mmp/include/mach-mmp/mmp2.h
 create mode 100644 arch/arm/mach-mmp/include/mach-mmp/pm-mmp2.h
 rename arch/arm/mach-mmp/include/{mach => mach-mmp}/pm-pxa910.h (100%)
 create mode 100644 arch/arm/mach-mmp/include/mach-mmp/pxa168.h
 create mode 100644 arch/arm/mach-mmp/include/mach-mmp/pxa910.h
 create mode 100644 arch/arm/mach-mmp/include/mach-mmp/regs-apbc.h
 create mode 100644 arch/arm/mach-mmp/include/mach-mmp/regs-apmu.h
 create mode 100644 arch/arm/mach-mmp/include/mach-mmp/regs-icu.h
 create mode 100644 arch/arm/mach-mmp/include/mach-mmp/regs-rtc.h
 create mode 100644 arch/arm/mach-mmp/include/mach-mmp/regs-smc.h
 create mode 100644 arch/arm/mach-mmp/include/mach-mmp/regs-timers.h
 rename arch/arm/mach-mmp/include/{mach => mach-mmp}/regs-usb.h (100%)
 rename arch/arm/mach-mmp/include/{mach => mach-mmp}/sram.h (100%)
 rename arch/arm/mach-mmp/include/{mach => mach-mmp}/teton_bga.h (100%)
 rename arch/arm/mach-mmp/include/{mach => mach-mmp}/timex.h (100%)
 create mode 100644 arch/arm/mach-mmp/include/mach-mmp/uncompress.h
 delete mode 100644 arch/arm/mach-mmp/include/mach/debug-macro.S
 delete mode 100644 arch/arm/mach-mmp/include/mach/dma.h
 delete mode 100644 arch/arm/mach-mmp/include/mach/entry-macro.S
 delete mode 100644 arch/arm/mach-mmp/include/mach/gpio.h
 delete mode 100644 arch/arm/mach-mmp/include/mach/mfp-mmp2.h
 delete mode 100644 arch/arm/mach-mmp/include/mach/mfp-pxa168.h
 delete mode 100644 arch/arm/mach-mmp/include/mach/mfp-pxa910.h
 delete mode 100644 arch/arm/mach-mmp/include/mach/mfp.h
 delete mode 100644 arch/arm/mach-mmp/include/mach/mmp2.h
 delete mode 100644 arch/arm/mach-mmp/include/mach/pm-mmp2.h
 delete mode 100644 arch/arm/mach-mmp/include/mach/pxa168.h
 delete mode 100644 arch/arm/mach-mmp/include/mach/pxa910.h
 delete mode 100644 arch/arm/mach-mmp/include/mach/regs-apbc.h
 delete mode 100644 arch/arm/mach-mmp/include/mach/regs-apmu.h
 delete mode 100644 arch/arm/mach-mmp/include/mach/regs-icu.h
 delete mode 100644 arch/arm/mach-mmp/include/mach/regs-rtc.h
 delete mode 100644 arch/arm/mach-mmp/include/mach/regs-smc.h
 delete mode 100644 arch/arm/mach-mmp/include/mach/regs-timers.h
 delete mode 100644 arch/arm/mach-mmp/include/mach/uncompress.h
 create mode 100644 arch/arm/mach-msm/include/mach-msm/board.h
 rename arch/arm/mach-msm/include/{mach => mach-msm}/clk.h (100%)
 rename arch/arm/mach-msm/include/{mach => mach-msm}/cpu.h (100%)
 create mode 100644 arch/arm/mach-msm/include/mach-msm/debug-macro.S
 create mode 100644 arch/arm/mach-msm/include/mach-msm/dma.h
 create mode 100644 arch/arm/mach-msm/include/mach-msm/entry-macro.S
 rename arch/arm/{mach-mxs/include/mach => mach-msm/include/mach-msm}/gpio.h (100%)
 rename arch/arm/mach-msm/include/{mach => mach-msm}/hardware.h (100%)
 rename arch/arm/mach-msm/include/{mach => mach-msm}/iommu.h (100%)
 rename arch/arm/mach-msm/include/{mach => mach-msm}/iommu_hw-8xxx.h (100%)
 rename arch/arm/mach-msm/include/{mach => mach-msm}/irqs-7x00.h (100%)
 rename arch/arm/mach-msm/include/{mach => mach-msm}/irqs-7x30.h (100%)
 rename arch/arm/mach-msm/include/{mach => mach-msm}/irqs-8960.h (100%)
 rename arch/arm/mach-msm/include/{mach => mach-msm}/irqs-8x50.h (100%)
 rename arch/arm/mach-msm/include/{mach => mach-msm}/irqs-8x60.h (100%)
 rename arch/arm/mach-msm/include/{mach => mach-msm}/irqs.h (100%)
 rename arch/arm/mach-msm/include/{mach => mach-msm}/mmc.h (100%)
 rename arch/arm/mach-msm/include/{mach => mach-msm}/msm_fb.h (100%)
 rename arch/arm/mach-msm/include/{mach => mach-msm}/msm_gpiomux.h (100%)
 rename arch/arm/mach-msm/include/{mach => mach-msm}/msm_iomap-7x00.h (100%)
 rename arch/arm/mach-msm/include/{mach => mach-msm}/msm_iomap-7x30.h (100%)
 rename arch/arm/mach-msm/include/{mach => mach-msm}/msm_iomap-8960.h (100%)
 rename arch/arm/mach-msm/include/{mach => mach-msm}/msm_iomap-8x50.h (100%)
 rename arch/arm/mach-msm/include/{mach => mach-msm}/msm_iomap-8x60.h (100%)
 rename arch/arm/mach-msm/include/{mach => mach-msm}/msm_iomap.h (100%)
 rename arch/arm/mach-msm/include/{mach => mach-msm}/msm_smd.h (100%)
 create mode 100644 arch/arm/mach-msm/include/mach-msm/sirc.h
 rename arch/arm/mach-msm/include/{mach => mach-msm}/system.h (100%)
 rename arch/arm/mach-msm/include/{mach => mach-msm}/timex.h (100%)
 create mode 100644 arch/arm/mach-msm/include/mach-msm/uncompress.h
 rename arch/arm/mach-msm/include/{mach => mach-msm}/vreg.h (100%)
 delete mode 100644 arch/arm/mach-msm/include/mach/board.h
 delete mode 100644 arch/arm/mach-msm/include/mach/debug-macro.S
 delete mode 100644 arch/arm/mach-msm/include/mach/dma.h
 delete mode 100644 arch/arm/mach-msm/include/mach/entry-macro.S
 delete mode 100644 arch/arm/mach-msm/include/mach/sirc.h
 delete mode 100644 arch/arm/mach-msm/include/mach/uncompress.h
 create mode 100644 arch/arm/mach-mv78xx0/include/mach-mv78xx0/bridge-regs.h
 create mode 100644 arch/arm/mach-mv78xx0/include/mach-mv78xx0/debug-macro.S
 create mode 100644 arch/arm/mach-mv78xx0/include/mach-mv78xx0/entry-macro.S
 create mode 100644 arch/arm/mach-mv78xx0/include/mach-mv78xx0/gpio.h
 rename arch/arm/mach-mv78xx0/include/{mach => mach-mv78xx0}/hardware.h (100%)
 rename arch/arm/mach-mv78xx0/include/{mach => mach-mv78xx0}/io.h (100%)
 rename arch/arm/mach-mv78xx0/include/{mach => mach-mv78xx0}/irqs.h (100%)
 rename arch/arm/mach-mv78xx0/include/{mach => mach-mv78xx0}/mv78xx0.h (100%)
 rename arch/arm/mach-mv78xx0/include/{mach => mach-mv78xx0}/timex.h (100%)
 create mode 100644 arch/arm/mach-mv78xx0/include/mach-mv78xx0/uncompress.h
 delete mode 100644 arch/arm/mach-mv78xx0/include/mach/bridge-regs.h
 delete mode 100644 arch/arm/mach-mv78xx0/include/mach/debug-macro.S
 delete mode 100644 arch/arm/mach-mv78xx0/include/mach/entry-macro.S
 delete mode 100644 arch/arm/mach-mv78xx0/include/mach/gpio.h
 delete mode 100644 arch/arm/mach-mv78xx0/include/mach/uncompress.h
 rename arch/arm/mach-mvebu/include/{mach => mach-mvebu}/armada-370-xp.h (100%)
 create mode 100644 arch/arm/mach-mvebu/include/mach-mvebu/debug-macro.S
 rename arch/arm/mach-mvebu/include/{mach => mach-mvebu}/timex.h (100%)
 create mode 100644 arch/arm/mach-mvebu/include/mach-mvebu/uncompress.h
 delete mode 100644 arch/arm/mach-mvebu/include/mach/debug-macro.S
 delete mode 100644 arch/arm/mach-mvebu/include/mach/uncompress.h
 rename arch/arm/mach-mxs/include/{mach => mach-mxs}/common.h (100%)
 create mode 100644 arch/arm/mach-mxs/include/mach-mxs/debug-macro.S
 rename arch/arm/mach-mxs/include/{mach => mach-mxs}/devices-common.h (100%)
 rename arch/arm/mach-mxs/include/{mach => mach-mxs}/digctl.h (100%)
 create mode 100644 arch/arm/mach-mxs/include/mach-mxs/entry-macro.S
 rename arch/arm/{mach-picoxcell/include/mach => mach-mxs/include/mach-mxs}/gpio.h (100%)
 rename arch/arm/mach-mxs/include/{mach => mach-mxs}/hardware.h (100%)
 create mode 100644 arch/arm/mach-mxs/include/mach-mxs/iomux-mx23.h
 create mode 100644 arch/arm/mach-mxs/include/mach-mxs/iomux-mx28.h
 rename arch/arm/mach-mxs/include/{mach => mach-mxs}/iomux.h (100%)
 rename arch/arm/mach-mxs/include/{mach => mach-mxs}/irqs.h (100%)
 create mode 100644 arch/arm/mach-mxs/include/mach-mxs/mx23.h
 create mode 100644 arch/arm/mach-mxs/include/mach-mxs/mx28.h
 create mode 100644 arch/arm/mach-mxs/include/mach-mxs/mxs.h
 rename arch/arm/mach-mxs/include/{mach => mach-mxs}/timex.h (100%)
 rename arch/arm/mach-mxs/include/{mach => mach-mxs}/uncompress.h (100%)
 delete mode 100644 arch/arm/mach-mxs/include/mach/debug-macro.S
 delete mode 100644 arch/arm/mach-mxs/include/mach/entry-macro.S
 delete mode 100644 arch/arm/mach-mxs/include/mach/iomux-mx23.h
 delete mode 100644 arch/arm/mach-mxs/include/mach/iomux-mx28.h
 delete mode 100644 arch/arm/mach-mxs/include/mach/mx23.h
 delete mode 100644 arch/arm/mach-mxs/include/mach/mx28.h
 delete mode 100644 arch/arm/mach-mxs/include/mach/mxs.h
 rename arch/arm/mach-netx/include/{mach => mach-netx}/debug-macro.S (100%)
 rename arch/arm/mach-netx/include/{mach => mach-netx}/eth.h (100%)
 rename arch/arm/mach-netx/include/{mach => mach-netx}/hardware.h (100%)
 rename arch/arm/mach-netx/include/{mach => mach-netx}/irqs.h (100%)
 rename arch/arm/mach-netx/include/{mach => mach-netx}/netx-regs.h (100%)
 rename arch/arm/mach-netx/include/{mach => mach-netx}/param.h (100%)
 rename arch/arm/mach-netx/include/{mach => mach-netx}/pfifo.h (100%)
 rename arch/arm/mach-netx/include/{mach => mach-netx}/timex.h (100%)
 rename arch/arm/mach-netx/include/{mach => mach-netx}/uncompress.h (100%)
 rename arch/arm/mach-netx/include/{mach => mach-netx}/xc.h (100%)
 rename arch/arm/mach-nomadik/include/{mach => mach-nomadik}/debug-macro.S (100%)
 create mode 100644 arch/arm/mach-nomadik/include/mach-nomadik/fsmc.h
 rename arch/arm/mach-nomadik/include/{mach => mach-nomadik}/gpio.h (100%)
 rename arch/arm/mach-nomadik/include/{mach => mach-nomadik}/hardware.h (100%)
 create mode 100644 arch/arm/mach-nomadik/include/mach-nomadik/irqs.h
 rename arch/arm/mach-nomadik/include/{mach => mach-nomadik}/nand.h (100%)
 rename arch/arm/mach-nomadik/include/{mach => mach-nomadik}/timex.h (100%)
 create mode 100644 arch/arm/mach-nomadik/include/mach-nomadik/uncompress.h
 delete mode 100644 arch/arm/mach-nomadik/include/mach/fsmc.h
 delete mode 100644 arch/arm/mach-nomadik/include/mach/irqs.h
 delete mode 100644 arch/arm/mach-nomadik/include/mach/uncompress.h
 create mode 100644 arch/arm/mach-omap1/include/mach-omap1/ams-delta-fiq.h
 rename arch/arm/mach-omap1/include/{mach => mach-omap1}/camera.h (100%)
 create mode 100644 arch/arm/mach-omap1/include/mach-omap1/debug-macro.S
 create mode 100644 arch/arm/mach-omap1/include/mach-omap1/entry-macro.S
 create mode 100644 arch/arm/mach-omap1/include/mach-omap1/gpio.h
 create mode 100644 arch/arm/mach-omap1/include/mach-omap1/hardware.h
 rename arch/arm/mach-omap1/include/{mach => mach-omap1}/io.h (100%)
 create mode 100644 arch/arm/mach-omap1/include/mach-omap1/irqs.h
 rename arch/arm/mach-omap1/include/{mach => mach-omap1}/lcd_dma.h (100%)
 rename arch/arm/mach-omap1/include/{mach => mach-omap1}/lcdc.h (100%)
 create mode 100644 arch/arm/mach-omap1/include/mach-omap1/memory.h
 create mode 100644 arch/arm/mach-omap1/include/mach-omap1/mtd-xip.h
 create mode 100644 arch/arm/mach-omap1/include/mach-omap1/smp.h
 create mode 100644 arch/arm/mach-omap1/include/mach-omap1/timex.h
 create mode 100644 arch/arm/mach-omap1/include/mach-omap1/uncompress.h
 rename arch/arm/mach-omap1/include/{mach => mach-omap1}/usb.h (100%)
 delete mode 100644 arch/arm/mach-omap1/include/mach/ams-delta-fiq.h
 delete mode 100644 arch/arm/mach-omap1/include/mach/debug-macro.S
 delete mode 100644 arch/arm/mach-omap1/include/mach/entry-macro.S
 delete mode 100644 arch/arm/mach-omap1/include/mach/gpio.h
 delete mode 100644 arch/arm/mach-omap1/include/mach/hardware.h
 delete mode 100644 arch/arm/mach-omap1/include/mach/irqs.h
 delete mode 100644 arch/arm/mach-omap1/include/mach/memory.h
 delete mode 100644 arch/arm/mach-omap1/include/mach/mtd-xip.h
 delete mode 100644 arch/arm/mach-omap1/include/mach/smp.h
 delete mode 100644 arch/arm/mach-omap1/include/mach/timex.h
 delete mode 100644 arch/arm/mach-omap1/include/mach/uncompress.h
 rename arch/arm/mach-omap2/include/{mach => mach-omap2}/am35xx.h (100%)
 rename arch/arm/mach-omap2/include/{mach => mach-omap2}/barriers.h (100%)
 rename arch/arm/mach-omap2/include/{mach => mach-omap2}/board-rx51.h (100%)
 rename arch/arm/mach-omap2/include/{mach => mach-omap2}/board-zoom.h (100%)
 rename arch/arm/mach-omap2/include/{mach => mach-omap2}/ctrl_module_core_44xx.h (100%)
 rename arch/arm/mach-omap2/include/{mach => mach-omap2}/ctrl_module_pad_core_44xx.h (100%)
 rename arch/arm/mach-omap2/include/{mach => mach-omap2}/ctrl_module_pad_wkup_44xx.h (100%)
 rename arch/arm/mach-omap2/include/{mach => mach-omap2}/ctrl_module_wkup_44xx.h (100%)
 create mode 100644 arch/arm/mach-omap2/include/mach-omap2/debug-macro.S
 create mode 100644 arch/arm/mach-omap2/include/mach-omap2/gpio.h
 create mode 100644 arch/arm/mach-omap2/include/mach-omap2/hardware.h
 rename arch/arm/mach-omap2/include/{mach => mach-omap2}/id.h (100%)
 create mode 100644 arch/arm/mach-omap2/include/mach-omap2/irqs.h
 rename arch/arm/mach-omap2/include/{mach => mach-omap2}/omap-secure.h (100%)
 rename arch/arm/mach-omap2/include/{mach => mach-omap2}/omap-wakeupgen.h (100%)
 create mode 100644 arch/arm/mach-omap2/include/mach-omap2/smp.h
 create mode 100644 arch/arm/mach-omap2/include/mach-omap2/timex.h
 create mode 100644 arch/arm/mach-omap2/include/mach-omap2/uncompress.h
 delete mode 100644 arch/arm/mach-omap2/include/mach/debug-macro.S
 delete mode 100644 arch/arm/mach-omap2/include/mach/gpio.h
 delete mode 100644 arch/arm/mach-omap2/include/mach/hardware.h
 delete mode 100644 arch/arm/mach-omap2/include/mach/irqs.h
 delete mode 100644 arch/arm/mach-omap2/include/mach/smp.h
 delete mode 100644 arch/arm/mach-omap2/include/mach/timex.h
 delete mode 100644 arch/arm/mach-omap2/include/mach/uncompress.h
 create mode 100644 arch/arm/mach-orion5x/include/mach-orion5x/bridge-regs.h
 create mode 100644 arch/arm/mach-orion5x/include/mach-orion5x/debug-macro.S
 create mode 100644 arch/arm/mach-orion5x/include/mach-orion5x/entry-macro.S
 create mode 100644 arch/arm/mach-orion5x/include/mach-orion5x/gpio.h
 rename arch/arm/mach-orion5x/include/{mach => mach-orion5x}/hardware.h (100%)
 create mode 100644 arch/arm/mach-orion5x/include/mach-orion5x/io.h
 rename arch/arm/mach-orion5x/include/{mach => mach-orion5x}/irqs.h (100%)
 rename arch/arm/mach-orion5x/include/{mach => mach-orion5x}/orion5x.h (100%)
 rename arch/arm/mach-orion5x/include/{mach => mach-orion5x}/timex.h (100%)
 create mode 100644 arch/arm/mach-orion5x/include/mach-orion5x/uncompress.h
 delete mode 100644 arch/arm/mach-orion5x/include/mach/bridge-regs.h
 delete mode 100644 arch/arm/mach-orion5x/include/mach/debug-macro.S
 delete mode 100644 arch/arm/mach-orion5x/include/mach/entry-macro.S
 delete mode 100644 arch/arm/mach-orion5x/include/mach/gpio.h
 delete mode 100644 arch/arm/mach-orion5x/include/mach/io.h
 delete mode 100644 arch/arm/mach-orion5x/include/mach/uncompress.h
 create mode 100644 arch/arm/mach-picoxcell/include/mach-picoxcell/debug-macro.S
 rename arch/arm/{mach-realview/include/mach => mach-picoxcell/include/mach-picoxcell}/gpio.h (100%)
 create mode 100644 arch/arm/mach-picoxcell/include/mach-picoxcell/hardware.h
 rename arch/arm/mach-picoxcell/include/{mach => mach-picoxcell}/map.h (100%)
 rename arch/arm/mach-picoxcell/include/{mach => mach-picoxcell}/picoxcell_soc.h (100%)
 rename arch/arm/mach-picoxcell/include/{mach => mach-picoxcell}/timex.h (100%)
 rename arch/arm/mach-picoxcell/include/{mach => mach-picoxcell}/uncompress.h (100%)
 delete mode 100644 arch/arm/mach-picoxcell/include/mach/debug-macro.S
 delete mode 100644 arch/arm/mach-picoxcell/include/mach/hardware.h
 rename arch/arm/mach-pnx4008/include/{mach => mach-pnx4008}/clock.h (100%)
 rename arch/arm/mach-pnx4008/include/{mach => mach-pnx4008}/debug-macro.S (100%)
 rename arch/arm/mach-pnx4008/include/{mach => mach-pnx4008}/dma.h (100%)
 rename arch/arm/mach-pnx4008/include/{mach => mach-pnx4008}/entry-macro.S (100%)
 rename arch/arm/mach-pnx4008/include/{mach => mach-pnx4008}/gpio-pnx4008.h (100%)
 create mode 100644 arch/arm/mach-pnx4008/include/mach-pnx4008/hardware.h
 rename arch/arm/mach-pnx4008/include/{mach => mach-pnx4008}/irq.h (100%)
 rename arch/arm/mach-pnx4008/include/{mach => mach-pnx4008}/irqs.h (100%)
 rename arch/arm/mach-pnx4008/include/{mach => mach-pnx4008}/param.h (100%)
 rename arch/arm/mach-pnx4008/include/{mach => mach-pnx4008}/platform.h (100%)
 rename arch/arm/mach-pnx4008/include/{mach => mach-pnx4008}/pm.h (100%)
 rename arch/arm/mach-pnx4008/include/{mach => mach-pnx4008}/timex.h (100%)
 rename arch/arm/mach-pnx4008/include/{mach => mach-pnx4008}/uncompress.h (100%)
 delete mode 100644 arch/arm/mach-pnx4008/include/mach/hardware.h
 rename arch/arm/mach-prima2/include/{mach => mach-prima2}/clkdev.h (100%)
 create mode 100644 arch/arm/mach-prima2/include/mach-prima2/debug-macro.S
 create mode 100644 arch/arm/mach-prima2/include/mach-prima2/entry-macro.S
 rename arch/arm/mach-prima2/include/{mach => mach-prima2}/gpio.h (100%)
 create mode 100644 arch/arm/mach-prima2/include/mach-prima2/hardware.h
 rename arch/arm/mach-prima2/include/{mach => mach-prima2}/irqs.h (100%)
 rename arch/arm/mach-prima2/include/{mach => mach-prima2}/map.h (100%)
 rename arch/arm/mach-prima2/include/{mach => mach-prima2}/timex.h (100%)
 rename arch/arm/mach-prima2/include/{mach => mach-prima2}/uart.h (100%)
 create mode 100644 arch/arm/mach-prima2/include/mach-prima2/uncompress.h
 delete mode 100644 arch/arm/mach-prima2/include/mach/debug-macro.S
 delete mode 100644 arch/arm/mach-prima2/include/mach/entry-macro.S
 delete mode 100644 arch/arm/mach-prima2/include/mach/hardware.h
 delete mode 100644 arch/arm/mach-prima2/include/mach/uncompress.h
 rename arch/arm/mach-pxa/include/{mach => mach-pxa}/addr-map.h (100%)
 rename arch/arm/mach-pxa/include/{mach => mach-pxa}/arcom-pcmcia.h (100%)
 rename arch/arm/mach-pxa/include/{mach => mach-pxa}/audio.h (100%)
 rename arch/arm/mach-pxa/include/{mach => mach-pxa}/balloon3.h (100%)
 rename arch/arm/mach-pxa/include/{mach => mach-pxa}/bitfield.h (100%)
 rename arch/arm/mach-pxa/include/{mach => mach-pxa}/camera.h (100%)
 create mode 100644 arch/arm/mach-pxa/include/mach-pxa/colibri.h
 rename arch/arm/mach-pxa/include/{mach => mach-pxa}/corgi.h (100%)
 rename arch/arm/mach-pxa/include/{mach => mach-pxa}/csb726.h (100%)
 rename arch/arm/mach-pxa/include/{mach => mach-pxa}/debug-macro.S (100%)
 create mode 100644 arch/arm/mach-pxa/include/mach-pxa/dma.h
 rename arch/arm/mach-pxa/include/{mach => mach-pxa}/eseries-gpio.h (100%)
 rename arch/arm/mach-pxa/include/{mach => mach-pxa}/eseries-irq.h (100%)
 create mode 100644 arch/arm/mach-pxa/include/mach-pxa/gpio.h
 rename arch/arm/mach-pxa/include/{mach => mach-pxa}/gumstix.h (100%)
 create mode 100644 arch/arm/mach-pxa/include/mach-pxa/h5000.h
 create mode 100644 arch/arm/mach-pxa/include/mach-pxa/hardware.h
 rename arch/arm/mach-pxa/include/{mach => mach-pxa}/hx4700.h (100%)
 rename arch/arm/mach-pxa/include/{mach => mach-pxa}/idp.h (100%)
 rename arch/arm/mach-pxa/include/{mach => mach-pxa}/io.h (100%)
 rename arch/arm/mach-pxa/include/{mach => mach-pxa}/irda.h (100%)
 rename arch/arm/mach-pxa/include/{mach => mach-pxa}/irqs.h (100%)
 rename arch/arm/mach-pxa/include/{mach => mach-pxa}/littleton.h (100%)
 rename arch/arm/mach-pxa/include/{mach => mach-pxa}/lpd270.h (100%)
 rename arch/arm/mach-pxa/include/{mach => mach-pxa}/lubbock.h (100%)
 create mode 100644 arch/arm/mach-pxa/include/mach-pxa/magician.h
 create mode 100644 arch/arm/mach-pxa/include/mach-pxa/mainstone.h
 create mode 100644 arch/arm/mach-pxa/include/mach-pxa/mfp-pxa25x.h
 create mode 100644 arch/arm/mach-pxa/include/mach-pxa/mfp-pxa27x.h
 create mode 100644 arch/arm/mach-pxa/include/mach-pxa/mfp-pxa2xx.h
 create mode 100644 arch/arm/mach-pxa/include/mach-pxa/mfp-pxa300.h
 create mode 100644 arch/arm/mach-pxa/include/mach-pxa/mfp-pxa320.h
 create mode 100644 arch/arm/mach-pxa/include/mach-pxa/mfp-pxa3xx.h
 create mode 100644 arch/arm/mach-pxa/include/mach-pxa/mfp-pxa930.h
 create mode 100644 arch/arm/mach-pxa/include/mach-pxa/mfp.h
 rename arch/arm/mach-pxa/include/{mach => mach-pxa}/mioa701.h (100%)
 rename arch/arm/mach-pxa/include/{mach => mach-pxa}/mmc.h (100%)
 create mode 100644 arch/arm/mach-pxa/include/mach-pxa/mtd-xip.h
 rename arch/arm/mach-pxa/include/{mach => mach-pxa}/mxm8x10.h (100%)
 rename arch/arm/mach-pxa/include/{mach => mach-pxa}/ohci.h (100%)
 rename arch/arm/mach-pxa/include/{mach => mach-pxa}/palm27x.h (100%)
 rename arch/arm/mach-pxa/include/{mach => mach-pxa}/palmasoc.h (100%)
 rename arch/arm/mach-pxa/include/{mach => mach-pxa}/palmld.h (100%)
 rename arch/arm/mach-pxa/include/{mach => mach-pxa}/palmt5.h (100%)
 rename arch/arm/mach-pxa/include/{mach => mach-pxa}/palmtc.h (100%)
 rename arch/arm/mach-pxa/include/{mach => mach-pxa}/palmte2.h (100%)
 rename arch/arm/mach-pxa/include/{mach => mach-pxa}/palmtreo.h (100%)
 rename arch/arm/mach-pxa/include/{mach => mach-pxa}/palmtx.h (100%)
 rename arch/arm/mach-pxa/include/{mach => mach-pxa}/palmz72.h (100%)
 rename arch/arm/mach-pxa/include/{mach => mach-pxa}/pata_pxa.h (100%)
 rename arch/arm/mach-pxa/include/{mach => mach-pxa}/pcm027.h (100%)
 create mode 100644 arch/arm/mach-pxa/include/mach-pxa/pcm990_baseboard.h
 rename arch/arm/mach-pxa/include/{mach => mach-pxa}/pm.h (100%)
 rename arch/arm/mach-pxa/include/{mach => mach-pxa}/poodle.h (100%)
 rename arch/arm/mach-pxa/include/{mach => mach-pxa}/pxa25x-udc.h (100%)
 create mode 100644 arch/arm/mach-pxa/include/mach-pxa/pxa25x.h
 rename arch/arm/mach-pxa/include/{mach => mach-pxa}/pxa27x-udc.h (100%)
 create mode 100644 arch/arm/mach-pxa/include/mach-pxa/pxa27x.h
 create mode 100644 arch/arm/mach-pxa/include/mach-pxa/pxa2xx-regs.h
 create mode 100644 arch/arm/mach-pxa/include/mach-pxa/pxa300.h
 create mode 100644 arch/arm/mach-pxa/include/mach-pxa/pxa320.h
 create mode 100644 arch/arm/mach-pxa/include/mach-pxa/pxa3xx-regs.h
 rename arch/arm/mach-pxa/include/{mach => mach-pxa}/pxa3xx-u2d.h (100%)
 create mode 100644 arch/arm/mach-pxa/include/mach-pxa/pxa3xx.h
 create mode 100644 arch/arm/mach-pxa/include/mach-pxa/pxa930.h
 rename arch/arm/mach-pxa/include/{mach => mach-pxa}/pxa930_rotary.h (100%)
 rename arch/arm/mach-pxa/include/{mach => mach-pxa}/pxa930_trkball.h (100%)
 create mode 100644 arch/arm/mach-pxa/include/mach-pxa/pxa95x.h
 create mode 100644 arch/arm/mach-pxa/include/mach-pxa/pxafb.h
 create mode 100644 arch/arm/mach-pxa/include/mach-pxa/regs-ac97.h
 create mode 100644 arch/arm/mach-pxa/include/mach-pxa/regs-lcd.h
 create mode 100644 arch/arm/mach-pxa/include/mach-pxa/regs-ost.h
 create mode 100644 arch/arm/mach-pxa/include/mach-pxa/regs-rtc.h
 create mode 100644 arch/arm/mach-pxa/include/mach-pxa/regs-u2d.h
 rename arch/arm/mach-pxa/include/{mach => mach-pxa}/regs-uart.h (100%)
 rename arch/arm/mach-pxa/include/{mach => mach-pxa}/reset.h (100%)
 rename arch/arm/mach-pxa/include/{mach => mach-pxa}/sharpsl_pm.h (100%)
 rename arch/arm/mach-pxa/include/{mach => mach-pxa}/smemc.h (100%)
 rename arch/arm/mach-pxa/include/{mach => mach-pxa}/spitz.h (100%)
 rename arch/arm/mach-pxa/include/{mach => mach-pxa}/timex.h (100%)
 rename arch/arm/mach-pxa/include/{mach => mach-pxa}/tosa.h (100%)
 rename arch/arm/mach-pxa/include/{mach => mach-pxa}/tosa_bt.h (100%)
 rename arch/arm/mach-pxa/include/{mach => mach-pxa}/trizeps4.h (100%)
 rename arch/arm/mach-pxa/include/{mach => mach-pxa}/udc.h (100%)
 rename arch/arm/mach-pxa/include/{mach => mach-pxa}/uncompress.h (100%)
 rename arch/arm/mach-pxa/include/{mach => mach-pxa}/viper.h (100%)
 rename arch/arm/mach-pxa/include/{mach => mach-pxa}/vpac270.h (100%)
 rename arch/arm/mach-pxa/include/{mach => mach-pxa}/z2.h (100%)
 rename arch/arm/mach-pxa/include/{mach => mach-pxa}/zeus.h (100%)
 rename arch/arm/mach-pxa/include/{mach => mach-pxa}/zylonite.h (100%)
 delete mode 100644 arch/arm/mach-pxa/include/mach/colibri.h
 delete mode 100644 arch/arm/mach-pxa/include/mach/dma.h
 delete mode 100644 arch/arm/mach-pxa/include/mach/gpio.h
 delete mode 100644 arch/arm/mach-pxa/include/mach/h5000.h
 delete mode 100644 arch/arm/mach-pxa/include/mach/hardware.h
 delete mode 100644 arch/arm/mach-pxa/include/mach/magician.h
 delete mode 100644 arch/arm/mach-pxa/include/mach/mainstone.h
 delete mode 100644 arch/arm/mach-pxa/include/mach/mfp-pxa25x.h
 delete mode 100644 arch/arm/mach-pxa/include/mach/mfp-pxa27x.h
 delete mode 100644 arch/arm/mach-pxa/include/mach/mfp-pxa2xx.h
 delete mode 100644 arch/arm/mach-pxa/include/mach/mfp-pxa300.h
 delete mode 100644 arch/arm/mach-pxa/include/mach/mfp-pxa320.h
 delete mode 100644 arch/arm/mach-pxa/include/mach/mfp-pxa3xx.h
 delete mode 100644 arch/arm/mach-pxa/include/mach/mfp-pxa930.h
 delete mode 100644 arch/arm/mach-pxa/include/mach/mfp.h
 delete mode 100644 arch/arm/mach-pxa/include/mach/mtd-xip.h
 delete mode 100644 arch/arm/mach-pxa/include/mach/pcm990_baseboard.h
 delete mode 100644 arch/arm/mach-pxa/include/mach/pxa25x.h
 delete mode 100644 arch/arm/mach-pxa/include/mach/pxa27x.h
 delete mode 100644 arch/arm/mach-pxa/include/mach/pxa2xx-regs.h
 delete mode 100644 arch/arm/mach-pxa/include/mach/pxa300.h
 delete mode 100644 arch/arm/mach-pxa/include/mach/pxa320.h
 delete mode 100644 arch/arm/mach-pxa/include/mach/pxa3xx-regs.h
 delete mode 100644 arch/arm/mach-pxa/include/mach/pxa3xx.h
 delete mode 100644 arch/arm/mach-pxa/include/mach/pxa930.h
 delete mode 100644 arch/arm/mach-pxa/include/mach/pxa95x.h
 delete mode 100644 arch/arm/mach-pxa/include/mach/pxafb.h
 delete mode 100644 arch/arm/mach-pxa/include/mach/regs-ac97.h
 delete mode 100644 arch/arm/mach-pxa/include/mach/regs-lcd.h
 delete mode 100644 arch/arm/mach-pxa/include/mach/regs-ost.h
 delete mode 100644 arch/arm/mach-pxa/include/mach/regs-rtc.h
 delete mode 100644 arch/arm/mach-pxa/include/mach/regs-u2d.h
 rename arch/arm/mach-realview/include/{mach => mach-realview}/barriers.h (100%)
 create mode 100644 arch/arm/mach-realview/include/mach-realview/board-eb.h
 create mode 100644 arch/arm/mach-realview/include/mach-realview/board-pb1176.h
 create mode 100644 arch/arm/mach-realview/include/mach-realview/board-pb11mp.h
 create mode 100644 arch/arm/mach-realview/include/mach-realview/board-pba8.h
 create mode 100644 arch/arm/mach-realview/include/mach-realview/board-pbx.h
 create mode 100644 arch/arm/mach-realview/include/mach-realview/clkdev.h
 rename arch/arm/mach-realview/include/{mach => mach-realview}/debug-macro.S (100%)
 rename arch/arm/{mach-tegra/include/mach => mach-realview/include/mach-realview}/gpio.h (100%)
 rename arch/arm/mach-realview/include/{mach => mach-realview}/hardware.h (100%)
 rename arch/arm/mach-realview/include/{mach => mach-realview}/irqs-eb.h (100%)
 rename arch/arm/mach-realview/include/{mach => mach-realview}/irqs-pb1176.h (100%)
 rename arch/arm/mach-realview/include/{mach => mach-realview}/irqs-pb11mp.h (100%)
 rename arch/arm/mach-realview/include/{mach => mach-realview}/irqs-pba8.h (100%)
 rename arch/arm/mach-realview/include/{mach => mach-realview}/irqs-pbx.h (100%)
 create mode 100644 arch/arm/mach-realview/include/mach-realview/irqs.h
 rename arch/arm/mach-realview/include/{mach => mach-realview}/memory.h (100%)
 rename arch/arm/mach-realview/include/{mach => mach-realview}/platform.h (100%)
 rename arch/arm/mach-realview/include/{mach => mach-realview}/timex.h (100%)
 create mode 100644 arch/arm/mach-realview/include/mach-realview/uncompress.h
 delete mode 100644 arch/arm/mach-realview/include/mach/board-eb.h
 delete mode 100644 arch/arm/mach-realview/include/mach/board-pb1176.h
 delete mode 100644 arch/arm/mach-realview/include/mach/board-pb11mp.h
 delete mode 100644 arch/arm/mach-realview/include/mach/board-pba8.h
 delete mode 100644 arch/arm/mach-realview/include/mach/board-pbx.h
 delete mode 100644 arch/arm/mach-realview/include/mach/clkdev.h
 delete mode 100644 arch/arm/mach-realview/include/mach/irqs.h
 delete mode 100644 arch/arm/mach-realview/include/mach/uncompress.h
 rename arch/arm/mach-rpc/include/{mach => mach-rpc}/acornfb.h (100%)
 rename arch/arm/mach-rpc/include/{mach => mach-rpc}/debug-macro.S (100%)
 create mode 100644 arch/arm/mach-rpc/include/mach-rpc/entry-macro.S
 create mode 100644 arch/arm/mach-rpc/include/mach-rpc/hardware.h
 create mode 100644 arch/arm/mach-rpc/include/mach-rpc/io.h
 rename arch/arm/mach-rpc/include/{mach => mach-rpc}/irqs.h (100%)
 rename arch/arm/mach-rpc/include/{mach => mach-rpc}/isa-dma.h (100%)
 rename arch/arm/mach-rpc/include/{mach => mach-rpc}/memory.h (100%)
 rename arch/arm/mach-rpc/include/{mach => mach-rpc}/timex.h (100%)
 create mode 100644 arch/arm/mach-rpc/include/mach-rpc/uncompress.h
 delete mode 100644 arch/arm/mach-rpc/include/mach/entry-macro.S
 delete mode 100644 arch/arm/mach-rpc/include/mach/hardware.h
 delete mode 100644 arch/arm/mach-rpc/include/mach/io.h
 delete mode 100644 arch/arm/mach-rpc/include/mach/uncompress.h
 rename arch/arm/mach-s3c24xx/include/{mach => mach-s3c24xx}/anubis-cpld.h (100%)
 rename arch/arm/mach-s3c24xx/include/{mach => mach-s3c24xx}/anubis-irq.h (100%)
 rename arch/arm/mach-s3c24xx/include/{mach => mach-s3c24xx}/anubis-map.h (100%)
 rename arch/arm/mach-s3c24xx/include/{mach => mach-s3c24xx}/bast-cpld.h (100%)
 rename arch/arm/mach-s3c24xx/include/{mach => mach-s3c24xx}/bast-irq.h (100%)
 rename arch/arm/mach-s3c24xx/include/{mach => mach-s3c24xx}/bast-map.h (100%)
 create mode 100644 arch/arm/mach-s3c24xx/include/mach-s3c24xx/debug-macro.S
 create mode 100644 arch/arm/mach-s3c24xx/include/mach-s3c24xx/dma.h
 create mode 100644 arch/arm/mach-s3c24xx/include/mach-s3c24xx/entry-macro.S
 create mode 100644 arch/arm/mach-s3c24xx/include/mach-s3c24xx/fb.h
 create mode 100644 arch/arm/mach-s3c24xx/include/mach-s3c24xx/gpio-fns.h
 rename arch/arm/mach-s3c24xx/include/{mach => mach-s3c24xx}/gpio-nrs.h (100%)
 create mode 100644 arch/arm/mach-s3c24xx/include/mach-s3c24xx/gpio-track.h
 create mode 100644 arch/arm/mach-s3c24xx/include/mach-s3c24xx/gpio.h
 create mode 100644 arch/arm/mach-s3c24xx/include/mach-s3c24xx/gta02.h
 rename arch/arm/mach-s3c24xx/include/{mach => mach-s3c24xx}/h1940-latch.h (100%)
 rename arch/arm/mach-s3c24xx/include/{mach => mach-s3c24xx}/h1940.h (100%)
 create mode 100644 arch/arm/mach-s3c24xx/include/mach-s3c24xx/hardware.h
 rename arch/arm/mach-s3c24xx/include/{mach => mach-s3c24xx}/idle.h (100%)
 create mode 100644 arch/arm/mach-s3c24xx/include/mach-s3c24xx/io.h
 rename arch/arm/mach-s3c24xx/include/{mach => mach-s3c24xx}/irqs.h (100%)
 rename arch/arm/mach-s3c24xx/include/{mach => mach-s3c24xx}/leds-gpio.h (100%)
 create mode 100644 arch/arm/mach-s3c24xx/include/mach-s3c24xx/map.h
 rename arch/arm/mach-s3c24xx/include/{mach => mach-s3c24xx}/osiris-cpld.h (100%)
 rename arch/arm/mach-s3c24xx/include/{mach => mach-s3c24xx}/osiris-map.h (100%)
 rename arch/arm/mach-s3c24xx/include/{mach => mach-s3c24xx}/otom-map.h (100%)
 rename arch/arm/mach-s3c24xx/include/{mach => mach-s3c24xx}/pm-core.h (100%)
 rename arch/arm/mach-s3c24xx/include/{mach => mach-s3c24xx}/regs-clock.h (100%)
 rename arch/arm/mach-s3c24xx/include/{mach => mach-s3c24xx}/regs-dsc.h (100%)
 create mode 100644 arch/arm/mach-s3c24xx/include/mach-s3c24xx/regs-gpio.h
 rename arch/arm/mach-s3c24xx/include/{mach => mach-s3c24xx}/regs-irq.h (100%)
 rename arch/arm/mach-s3c24xx/include/{mach => mach-s3c24xx}/regs-lcd.h (100%)
 rename arch/arm/mach-s3c24xx/include/{mach => mach-s3c24xx}/regs-mem.h (100%)
 rename arch/arm/mach-s3c24xx/include/{mach => mach-s3c24xx}/regs-power.h (100%)
 rename arch/arm/mach-s3c24xx/include/{mach => mach-s3c24xx}/regs-s3c2412-mem.h (100%)
 rename arch/arm/mach-s3c24xx/include/{mach => mach-s3c24xx}/regs-s3c2412.h (100%)
 rename arch/arm/mach-s3c24xx/include/{mach => mach-s3c24xx}/regs-s3c2416-mem.h (100%)
 rename arch/arm/mach-s3c24xx/include/{mach => mach-s3c24xx}/regs-s3c2416.h (100%)
 rename arch/arm/mach-s3c24xx/include/{mach => mach-s3c24xx}/regs-s3c2443-clock.h (100%)
 rename arch/arm/mach-s3c24xx/include/{mach => mach-s3c24xx}/regs-sdi.h (100%)
 rename arch/arm/mach-s3c24xx/include/{mach => mach-s3c24xx}/tick.h (100%)
 rename arch/arm/mach-s3c24xx/include/{mach => mach-s3c24xx}/timex.h (100%)
 create mode 100644 arch/arm/mach-s3c24xx/include/mach-s3c24xx/uncompress.h
 rename arch/arm/mach-s3c24xx/include/{mach => mach-s3c24xx}/vr1000-cpld.h (100%)
 rename arch/arm/mach-s3c24xx/include/{mach => mach-s3c24xx}/vr1000-irq.h (100%)
 create mode 100644 arch/arm/mach-s3c24xx/include/mach-s3c24xx/vr1000-map.h
 delete mode 100644 arch/arm/mach-s3c24xx/include/mach/debug-macro.S
 delete mode 100644 arch/arm/mach-s3c24xx/include/mach/dma.h
 delete mode 100644 arch/arm/mach-s3c24xx/include/mach/entry-macro.S
 delete mode 100644 arch/arm/mach-s3c24xx/include/mach/fb.h
 delete mode 100644 arch/arm/mach-s3c24xx/include/mach/gpio-fns.h
 delete mode 100644 arch/arm/mach-s3c24xx/include/mach/gpio-track.h
 delete mode 100644 arch/arm/mach-s3c24xx/include/mach/gpio.h
 delete mode 100644 arch/arm/mach-s3c24xx/include/mach/gta02.h
 delete mode 100644 arch/arm/mach-s3c24xx/include/mach/hardware.h
 delete mode 100644 arch/arm/mach-s3c24xx/include/mach/io.h
 delete mode 100644 arch/arm/mach-s3c24xx/include/mach/map.h
 delete mode 100644 arch/arm/mach-s3c24xx/include/mach/regs-gpio.h
 delete mode 100644 arch/arm/mach-s3c24xx/include/mach/uncompress.h
 delete mode 100644 arch/arm/mach-s3c24xx/include/mach/vr1000-map.h
 rename arch/arm/mach-s3c64xx/include/{mach => mach-s3c64xx}/crag6410.h (100%)
 create mode 100644 arch/arm/mach-s3c64xx/include/mach-s3c64xx/debug-macro.S
 create mode 100644 arch/arm/mach-s3c64xx/include/mach-s3c64xx/dma.h
 rename arch/arm/mach-s3c64xx/include/{mach => mach-s3c64xx}/gpio.h (100%)
 rename arch/arm/mach-s3c64xx/include/{mach => mach-s3c64xx}/hardware.h (100%)
 rename arch/arm/mach-s3c64xx/include/{mach => mach-s3c64xx}/irqs.h (100%)
 create mode 100644 arch/arm/mach-s3c64xx/include/mach-s3c64xx/map.h
 create mode 100644 arch/arm/mach-s3c64xx/include/mach-s3c64xx/pm-core.h
 rename arch/arm/mach-s3c64xx/include/{mach => mach-s3c64xx}/regs-clock.h (100%)
 rename arch/arm/mach-s3c64xx/include/{mach => mach-s3c64xx}/regs-gpio-memport.h (100%)
 rename arch/arm/mach-s3c64xx/include/{mach => mach-s3c64xx}/regs-gpio.h (100%)
 rename arch/arm/mach-s3c64xx/include/{mach => mach-s3c64xx}/regs-irq.h (100%)
 rename arch/arm/mach-s3c64xx/include/{mach => mach-s3c64xx}/regs-modem.h (100%)
 rename arch/arm/mach-s3c64xx/include/{mach => mach-s3c64xx}/regs-srom.h (100%)
 rename arch/arm/mach-s3c64xx/include/{mach => mach-s3c64xx}/regs-sys.h (100%)
 rename arch/arm/mach-s3c64xx/include/{mach => mach-s3c64xx}/regs-syscon-power.h (100%)
 rename arch/arm/mach-s3c64xx/include/{mach => mach-s3c64xx}/tick.h (100%)
 rename arch/arm/mach-s3c64xx/include/{mach => mach-s3c64xx}/timex.h (100%)
 create mode 100644 arch/arm/mach-s3c64xx/include/mach-s3c64xx/uncompress.h
 delete mode 100644 arch/arm/mach-s3c64xx/include/mach/debug-macro.S
 delete mode 100644 arch/arm/mach-s3c64xx/include/mach/dma.h
 delete mode 100644 arch/arm/mach-s3c64xx/include/mach/map.h
 delete mode 100644 arch/arm/mach-s3c64xx/include/mach/pm-core.h
 delete mode 100644 arch/arm/mach-s3c64xx/include/mach/uncompress.h
 create mode 100644 arch/arm/mach-s5p64x0/include/mach-s5p64x0/debug-macro.S
 create mode 100644 arch/arm/mach-s5p64x0/include/mach-s5p64x0/dma.h
 rename arch/arm/mach-s5p64x0/include/{mach => mach-s5p64x0}/gpio.h (100%)
 rename arch/arm/mach-s5p64x0/include/{mach => mach-s5p64x0}/hardware.h (100%)
 rename arch/arm/mach-s5p64x0/include/{mach => mach-s5p64x0}/i2c.h (100%)
 create mode 100644 arch/arm/mach-s5p64x0/include/mach-s5p64x0/irqs.h
 create mode 100644 arch/arm/mach-s5p64x0/include/mach-s5p64x0/map.h
 create mode 100644 arch/arm/mach-s5p64x0/include/mach-s5p64x0/pm-core.h
 create mode 100644 arch/arm/mach-s5p64x0/include/mach-s5p64x0/regs-clock.h
 create mode 100644 arch/arm/mach-s5p64x0/include/mach-s5p64x0/regs-gpio.h
 create mode 100644 arch/arm/mach-s5p64x0/include/mach-s5p64x0/regs-irq.h
 rename arch/arm/mach-s5p64x0/include/{mach => mach-s5p64x0}/s5p64x0-clock.h (100%)
 rename arch/arm/mach-s5p64x0/include/{mach => mach-s5p64x0}/tick.h (100%)
 rename arch/arm/mach-s5p64x0/include/{mach => mach-s5p64x0}/timex.h (100%)
 create mode 100644 arch/arm/mach-s5p64x0/include/mach-s5p64x0/uncompress.h
 delete mode 100644 arch/arm/mach-s5p64x0/include/mach/debug-macro.S
 delete mode 100644 arch/arm/mach-s5p64x0/include/mach/dma.h
 delete mode 100644 arch/arm/mach-s5p64x0/include/mach/irqs.h
 delete mode 100644 arch/arm/mach-s5p64x0/include/mach/map.h
 delete mode 100644 arch/arm/mach-s5p64x0/include/mach/pm-core.h
 delete mode 100644 arch/arm/mach-s5p64x0/include/mach/regs-clock.h
 delete mode 100644 arch/arm/mach-s5p64x0/include/mach/regs-gpio.h
 delete mode 100644 arch/arm/mach-s5p64x0/include/mach/regs-irq.h
 delete mode 100644 arch/arm/mach-s5p64x0/include/mach/uncompress.h
 create mode 100644 arch/arm/mach-s5pc100/include/mach-s5pc100/debug-macro.S
 create mode 100644 arch/arm/mach-s5pc100/include/mach-s5pc100/dma.h
 rename arch/arm/mach-s5pc100/include/{mach => mach-s5pc100}/entry-macro.S (100%)
 rename arch/arm/mach-s5pc100/include/{mach => mach-s5pc100}/gpio.h (100%)
 rename arch/arm/mach-s5pc100/include/{mach => mach-s5pc100}/hardware.h (100%)
 create mode 100644 arch/arm/mach-s5pc100/include/mach-s5pc100/irqs.h
 create mode 100644 arch/arm/mach-s5pc100/include/mach-s5pc100/map.h
 create mode 100644 arch/arm/mach-s5pc100/include/mach-s5pc100/regs-clock.h
 create mode 100644 arch/arm/mach-s5pc100/include/mach-s5pc100/regs-gpio.h
 create mode 100644 arch/arm/mach-s5pc100/include/mach-s5pc100/regs-irq.h
 rename arch/arm/mach-s5pc100/include/{mach => mach-s5pc100}/tick.h (100%)
 rename arch/arm/mach-s5pc100/include/{mach => mach-s5pc100}/timex.h (100%)
 create mode 100644 arch/arm/mach-s5pc100/include/mach-s5pc100/uncompress.h
 delete mode 100644 arch/arm/mach-s5pc100/include/mach/debug-macro.S
 delete mode 100644 arch/arm/mach-s5pc100/include/mach/dma.h
 delete mode 100644 arch/arm/mach-s5pc100/include/mach/irqs.h
 delete mode 100644 arch/arm/mach-s5pc100/include/mach/map.h
 delete mode 100644 arch/arm/mach-s5pc100/include/mach/regs-clock.h
 delete mode 100644 arch/arm/mach-s5pc100/include/mach/regs-gpio.h
 delete mode 100644 arch/arm/mach-s5pc100/include/mach/regs-irq.h
 delete mode 100644 arch/arm/mach-s5pc100/include/mach/uncompress.h
 create mode 100644 arch/arm/mach-s5pv210/include/mach-s5pv210/debug-macro.S
 create mode 100644 arch/arm/mach-s5pv210/include/mach-s5pv210/dma.h
 rename arch/arm/mach-s5pv210/include/{mach => mach-s5pv210}/gpio.h (100%)
 rename arch/arm/mach-s5pv210/include/{mach => mach-s5pv210}/hardware.h (100%)
 create mode 100644 arch/arm/mach-s5pv210/include/mach-s5pv210/irqs.h
 create mode 100644 arch/arm/mach-s5pv210/include/mach-s5pv210/map.h
 rename arch/arm/mach-s5pv210/include/{mach => mach-s5pv210}/memory.h (100%)
 rename arch/arm/mach-s5pv210/include/{mach => mach-s5pv210}/pm-core.h (100%)
 rename arch/arm/mach-s5pv210/include/{mach => mach-s5pv210}/regs-audss.h (100%)
 create mode 100644 arch/arm/mach-s5pv210/include/mach-s5pv210/regs-clock.h
 create mode 100644 arch/arm/mach-s5pv210/include/mach-s5pv210/regs-gpio.h
 create mode 100644 arch/arm/mach-s5pv210/include/mach-s5pv210/regs-irq.h
 rename arch/arm/mach-s5pv210/include/{mach => mach-s5pv210}/regs-sys.h (100%)
 rename arch/arm/mach-s5pv210/include/{mach => mach-s5pv210}/tick.h (100%)
 rename arch/arm/mach-s5pv210/include/{mach => mach-s5pv210}/timex.h (100%)
 create mode 100644 arch/arm/mach-s5pv210/include/mach-s5pv210/uncompress.h
 delete mode 100644 arch/arm/mach-s5pv210/include/mach/debug-macro.S
 delete mode 100644 arch/arm/mach-s5pv210/include/mach/dma.h
 delete mode 100644 arch/arm/mach-s5pv210/include/mach/irqs.h
 delete mode 100644 arch/arm/mach-s5pv210/include/mach/map.h
 delete mode 100644 arch/arm/mach-s5pv210/include/mach/regs-clock.h
 delete mode 100644 arch/arm/mach-s5pv210/include/mach/regs-gpio.h
 delete mode 100644 arch/arm/mach-s5pv210/include/mach/regs-irq.h
 delete mode 100644 arch/arm/mach-s5pv210/include/mach/uncompress.h
 rename arch/arm/mach-sa1100/include/{mach => mach-sa1100}/SA-1100.h (100%)
 create mode 100644 arch/arm/mach-sa1100/include/mach-sa1100/SA-1101.h
 rename arch/arm/mach-sa1100/include/{mach => mach-sa1100}/SA-1111.h (100%)
 rename arch/arm/mach-sa1100/include/{mach => mach-sa1100}/assabet.h (100%)
 create mode 100644 arch/arm/mach-sa1100/include/mach-sa1100/badge4.h
 rename arch/arm/mach-sa1100/include/{mach => mach-sa1100}/bitfield.h (100%)
 rename arch/arm/mach-sa1100/include/{mach => mach-sa1100}/cerf.h (100%)
 rename arch/arm/mach-sa1100/include/{mach => mach-sa1100}/collie.h (100%)
 create mode 100644 arch/arm/mach-sa1100/include/mach-sa1100/debug-macro.S
 rename arch/arm/mach-sa1100/include/{mach => mach-sa1100}/entry-macro.S (100%)
 create mode 100644 arch/arm/mach-sa1100/include/mach-sa1100/gpio.h
 rename arch/arm/mach-sa1100/include/{mach => mach-sa1100}/h3xxx.h (100%)
 rename arch/arm/mach-sa1100/include/{mach => mach-sa1100}/hardware.h (100%)
 rename arch/arm/mach-sa1100/include/{mach => mach-sa1100}/irqs.h (100%)
 rename arch/arm/mach-sa1100/include/{mach => mach-sa1100}/jornada720.h (100%)
 rename arch/arm/mach-sa1100/include/{mach => mach-sa1100}/lart.h (100%)
 rename arch/arm/mach-sa1100/include/{mach => mach-sa1100}/mcp.h (100%)
 rename arch/arm/mach-sa1100/include/{mach => mach-sa1100}/memory.h (100%)
 create mode 100644 arch/arm/mach-sa1100/include/mach-sa1100/mtd-xip.h
 create mode 100644 arch/arm/mach-sa1100/include/mach-sa1100/nanoengine.h
 rename arch/arm/mach-sa1100/include/{mach => mach-sa1100}/neponset.h (100%)
 rename arch/arm/mach-sa1100/include/{mach => mach-sa1100}/reset.h (100%)
 rename arch/arm/mach-sa1100/include/{mach => mach-sa1100}/shannon.h (100%)
 rename arch/arm/mach-sa1100/include/{mach => mach-sa1100}/simpad.h (100%)
 rename arch/arm/mach-sa1100/include/{mach => mach-sa1100}/timex.h (100%)
 rename arch/arm/mach-sa1100/include/{mach => mach-sa1100}/uncompress.h (100%)
 delete mode 100644 arch/arm/mach-sa1100/include/mach/SA-1101.h
 delete mode 100644 arch/arm/mach-sa1100/include/mach/badge4.h
 delete mode 100644 arch/arm/mach-sa1100/include/mach/debug-macro.S
 delete mode 100644 arch/arm/mach-sa1100/include/mach/gpio.h
 delete mode 100644 arch/arm/mach-sa1100/include/mach/mtd-xip.h
 delete mode 100644 arch/arm/mach-sa1100/include/mach/nanoengine.h
 rename arch/arm/mach-shark/include/{mach => mach-shark}/debug-macro.S (100%)
 rename arch/arm/mach-shark/include/{mach => mach-shark}/entry-macro.S (100%)
 rename arch/arm/mach-shark/include/{mach => mach-shark}/framebuffer.h (100%)
 rename arch/arm/mach-shark/include/{mach => mach-shark}/hardware.h (100%)
 rename arch/arm/mach-shark/include/{mach => mach-shark}/io.h (100%)
 rename arch/arm/mach-shark/include/{mach => mach-shark}/irqs.h (100%)
 rename arch/arm/mach-shark/include/{mach => mach-shark}/isa-dma.h (100%)
 rename arch/arm/mach-shark/include/{mach => mach-shark}/memory.h (100%)
 rename arch/arm/mach-shark/include/{mach => mach-shark}/timex.h (100%)
 rename arch/arm/mach-shark/include/{mach => mach-shark}/uncompress.h (100%)
 rename arch/arm/mach-shmobile/include/{mach => mach-shmobile}/clkdev.h (100%)
 rename arch/arm/mach-shmobile/include/{mach => mach-shmobile}/common.h (100%)
 rename arch/arm/mach-shmobile/include/{mach => mach-shmobile}/dma-register.h (100%)
 rename arch/arm/mach-shmobile/include/{mach => mach-shmobile}/dma.h (100%)
 rename arch/arm/mach-shmobile/include/{mach => mach-shmobile}/emev2.h (100%)
 rename arch/arm/mach-shmobile/include/{mach => mach-shmobile}/gpio.h (100%)
 rename arch/arm/mach-shmobile/include/{mach => mach-shmobile}/hardware.h (100%)
 rename arch/arm/mach-shmobile/include/{mach => mach-shmobile}/head-ap4evb.txt (100%)
 rename arch/arm/mach-shmobile/include/{mach => mach-shmobile}/head-mackerel.txt (100%)
 rename arch/arm/mach-shmobile/include/{mach => mach-shmobile}/intc.h (100%)
 rename arch/arm/mach-shmobile/include/{mach => mach-shmobile}/irqs.h (100%)
 rename arch/arm/mach-shmobile/include/{mach => mach-shmobile}/memory.h (100%)
 rename arch/arm/mach-shmobile/include/{mach => mach-shmobile}/mmc-ap4eb.h (100%)
 rename arch/arm/mach-shmobile/include/{mach => mach-shmobile}/mmc-mackerel.h (100%)
 rename arch/arm/mach-shmobile/include/{mach => mach-shmobile}/mmc.h (100%)
 rename arch/arm/mach-shmobile/include/{mach => mach-shmobile}/pm-rmobile.h (100%)
 create mode 100644 arch/arm/mach-shmobile/include/mach-shmobile/r8a7740.h
 rename arch/arm/mach-shmobile/include/{mach => mach-shmobile}/r8a7779.h (100%)
 rename arch/arm/mach-shmobile/include/{mach => mach-shmobile}/sdhi-sh7372.h (100%)
 rename arch/arm/mach-shmobile/include/{mach => mach-shmobile}/sdhi.h (100%)
 rename arch/arm/mach-shmobile/include/{mach => mach-shmobile}/sh7367.h (100%)
 create mode 100644 arch/arm/mach-shmobile/include/mach-shmobile/sh7372.h
 rename arch/arm/mach-shmobile/include/{mach => mach-shmobile}/sh7377.h (100%)
 rename arch/arm/mach-shmobile/include/{mach => mach-shmobile}/sh73a0.h (100%)
 rename arch/arm/mach-shmobile/include/{mach => mach-shmobile}/system.h (100%)
 rename arch/arm/mach-shmobile/include/{mach => mach-shmobile}/timex.h (100%)
 rename arch/arm/mach-shmobile/include/{mach => mach-shmobile}/uncompress.h (100%)
 create mode 100644 arch/arm/mach-shmobile/include/mach-shmobile/zboot.h
 rename arch/arm/mach-shmobile/include/{mach => mach-shmobile}/zboot_macros.h (100%)
 delete mode 100644 arch/arm/mach-shmobile/include/mach/r8a7740.h
 delete mode 100644 arch/arm/mach-shmobile/include/mach/sh7372.h
 delete mode 100644 arch/arm/mach-shmobile/include/mach/zboot.h
 rename arch/arm/mach-socfpga/include/{mach => mach-socfpga}/debug-macro.S (100%)
 rename arch/arm/mach-socfpga/include/{mach => mach-socfpga}/timex.h (100%)
 rename arch/arm/mach-socfpga/include/{mach => mach-socfpga}/uncompress.h (100%)
 create mode 100644 arch/arm/mach-spear13xx/include/mach-spear13xx/debug-macro.S
 rename arch/arm/mach-spear13xx/include/{mach => mach-spear13xx}/dma.h (100%)
 rename arch/arm/mach-spear13xx/include/{mach => mach-spear13xx}/generic.h (100%)
 create mode 100644 arch/arm/mach-spear13xx/include/mach-spear13xx/gpio.h
 rename arch/arm/mach-spear13xx/include/{mach => mach-spear13xx}/hardware.h (100%)
 rename arch/arm/mach-spear13xx/include/{mach => mach-spear13xx}/irqs.h (100%)
 rename arch/arm/mach-spear13xx/include/{mach => mach-spear13xx}/spear.h (100%)
 rename arch/arm/mach-spear13xx/include/{mach => mach-spear13xx}/spear1310_misc_regs.h (100%)
 rename arch/arm/mach-spear13xx/include/{mach => mach-spear13xx}/spear1340_misc_regs.h (100%)
 create mode 100644 arch/arm/mach-spear13xx/include/mach-spear13xx/timex.h
 create mode 100644 arch/arm/mach-spear13xx/include/mach-spear13xx/uncompress.h
 delete mode 100644 arch/arm/mach-spear13xx/include/mach/debug-macro.S
 delete mode 100644 arch/arm/mach-spear13xx/include/mach/gpio.h
 delete mode 100644 arch/arm/mach-spear13xx/include/mach/timex.h
 delete mode 100644 arch/arm/mach-spear13xx/include/mach/uncompress.h
 create mode 100644 arch/arm/mach-spear3xx/include/mach-spear3xx/debug-macro.S
 rename arch/arm/mach-spear3xx/include/{mach => mach-spear3xx}/generic.h (100%)
 create mode 100644 arch/arm/mach-spear3xx/include/mach-spear3xx/gpio.h
 rename arch/arm/mach-spear3xx/include/{mach => mach-spear3xx}/hardware.h (100%)
 rename arch/arm/mach-spear3xx/include/{mach => mach-spear3xx}/irqs.h (100%)
 create mode 100644 arch/arm/mach-spear3xx/include/mach-spear3xx/misc_regs.h
 rename arch/arm/mach-spear3xx/include/{mach => mach-spear3xx}/spear.h (100%)
 create mode 100644 arch/arm/mach-spear3xx/include/mach-spear3xx/timex.h
 create mode 100644 arch/arm/mach-spear3xx/include/mach-spear3xx/uncompress.h
 delete mode 100644 arch/arm/mach-spear3xx/include/mach/debug-macro.S
 delete mode 100644 arch/arm/mach-spear3xx/include/mach/gpio.h
 delete mode 100644 arch/arm/mach-spear3xx/include/mach/misc_regs.h
 delete mode 100644 arch/arm/mach-spear3xx/include/mach/timex.h
 delete mode 100644 arch/arm/mach-spear3xx/include/mach/uncompress.h
 create mode 100644 arch/arm/mach-spear6xx/include/mach-spear6xx/debug-macro.S
 rename arch/arm/mach-spear6xx/include/{mach => mach-spear6xx}/generic.h (100%)
 create mode 100644 arch/arm/mach-spear6xx/include/mach-spear6xx/gpio.h
 rename arch/arm/mach-spear6xx/include/{mach => mach-spear6xx}/hardware.h (100%)
 rename arch/arm/mach-spear6xx/include/{mach => mach-spear6xx}/irqs.h (100%)
 create mode 100644 arch/arm/mach-spear6xx/include/mach-spear6xx/misc_regs.h
 rename arch/arm/mach-spear6xx/include/{mach => mach-spear6xx}/spear.h (100%)
 create mode 100644 arch/arm/mach-spear6xx/include/mach-spear6xx/timex.h
 create mode 100644 arch/arm/mach-spear6xx/include/mach-spear6xx/uncompress.h
 delete mode 100644 arch/arm/mach-spear6xx/include/mach/debug-macro.S
 delete mode 100644 arch/arm/mach-spear6xx/include/mach/gpio.h
 delete mode 100644 arch/arm/mach-spear6xx/include/mach/misc_regs.h
 delete mode 100644 arch/arm/mach-spear6xx/include/mach/timex.h
 delete mode 100644 arch/arm/mach-spear6xx/include/mach/uncompress.h
 rename arch/arm/mach-tegra/include/{mach => mach-tegra}/clk.h (100%)
 create mode 100644 arch/arm/mach-tegra/include/mach-tegra/debug-macro.S
 rename arch/arm/mach-tegra/include/{mach => mach-tegra}/dma.h (100%)
 create mode 100644 arch/arm/mach-tegra/include/mach-tegra/gpio-tegra.h
 rename arch/arm/{mach-u300/include/mach => mach-tegra/include/mach-tegra}/gpio.h (100%)
 rename arch/arm/mach-tegra/include/{mach => mach-tegra}/io.h (100%)
 rename arch/arm/mach-tegra/include/{mach => mach-tegra}/iomap.h (100%)
 rename arch/arm/mach-tegra/include/{mach => mach-tegra}/irammap.h (100%)
 rename arch/arm/mach-tegra/include/{mach => mach-tegra}/irqs.h (100%)
 rename arch/arm/mach-tegra/include/{mach => mach-tegra}/kbc.h (100%)
 rename arch/arm/mach-tegra/include/{mach => mach-tegra}/pinconf-tegra.h (100%)
 rename arch/arm/mach-tegra/include/{mach => mach-tegra}/powergate.h (100%)
 rename arch/arm/mach-tegra/include/{mach => mach-tegra}/sdhci.h (100%)
 rename arch/arm/mach-tegra/include/{mach => mach-tegra}/smmu.h (100%)
 rename arch/arm/mach-tegra/include/{mach => mach-tegra}/suspend.h (100%)
 rename arch/arm/mach-tegra/include/{mach => mach-tegra}/tegra-ahb.h (100%)
 rename arch/arm/mach-tegra/include/{mach => mach-tegra}/tegra_wm8903_pdata.h (100%)
 rename arch/arm/mach-tegra/include/{mach => mach-tegra}/timex.h (100%)
 create mode 100644 arch/arm/mach-tegra/include/mach-tegra/uncompress.h
 rename arch/arm/mach-tegra/include/{mach => mach-tegra}/usb_phy.h (100%)
 delete mode 100644 arch/arm/mach-tegra/include/mach/debug-macro.S
 delete mode 100644 arch/arm/mach-tegra/include/mach/gpio-tegra.h
 delete mode 100644 arch/arm/mach-tegra/include/mach/uncompress.h
 rename arch/arm/mach-u300/include/{mach => mach-u300}/clkdev.h (100%)
 rename arch/arm/mach-u300/include/{mach => mach-u300}/coh901318.h (100%)
 create mode 100644 arch/arm/mach-u300/include/mach-u300/debug-macro.S
 rename arch/arm/mach-u300/include/{mach => mach-u300}/dma_channels.h (100%)
 rename arch/arm/mach-u300/include/{mach => mach-u300}/gpio-u300.h (100%)
 rename arch/arm/{mach-versatile/include/mach => mach-u300/include/mach-u300}/gpio.h (100%)
 create mode 100644 arch/arm/mach-u300/include/mach-u300/hardware.h
 rename arch/arm/mach-u300/include/{mach => mach-u300}/irqs.h (100%)
 rename arch/arm/mach-u300/include/{mach => mach-u300}/platform.h (100%)
 rename arch/arm/mach-u300/include/{mach => mach-u300}/syscon.h (100%)
 rename arch/arm/mach-u300/include/{mach => mach-u300}/timex.h (100%)
 rename arch/arm/mach-u300/include/{mach => mach-u300}/u300-regs.h (100%)
 rename arch/arm/mach-u300/include/{mach => mach-u300}/uncompress.h (100%)
 delete mode 100644 arch/arm/mach-u300/include/mach/debug-macro.S
 delete mode 100644 arch/arm/mach-u300/include/mach/hardware.h
 create mode 100644 arch/arm/mach-ux500/include/mach-ux500/crypto-ux500.h
 rename arch/arm/mach-ux500/include/{mach => mach-ux500}/db8500-regs.h (100%)
 create mode 100644 arch/arm/mach-ux500/include/mach-ux500/debug-macro.S
 rename arch/arm/mach-ux500/include/{mach => mach-ux500}/devices.h (100%)
 rename arch/arm/mach-ux500/include/{mach => mach-ux500}/gpio.h (100%)
 create mode 100644 arch/arm/mach-ux500/include/mach-ux500/hardware.h
 rename arch/arm/mach-ux500/include/{mach => mach-ux500}/id.h (100%)
 rename arch/arm/mach-ux500/include/{mach => mach-ux500}/irqs-board-mop500.h (100%)
 rename arch/arm/mach-ux500/include/{mach => mach-ux500}/irqs-db8500.h (100%)
 create mode 100644 arch/arm/mach-ux500/include/mach-ux500/irqs.h
 create mode 100644 arch/arm/mach-ux500/include/mach-ux500/msp.h
 rename arch/arm/mach-ux500/include/{mach => mach-ux500}/setup.h (100%)
 rename arch/arm/mach-ux500/include/{mach => mach-ux500}/timex.h (100%)
 create mode 100644 arch/arm/mach-ux500/include/mach-ux500/uncompress.h
 rename arch/arm/mach-ux500/include/{mach => mach-ux500}/usb.h (100%)
 delete mode 100644 arch/arm/mach-ux500/include/mach/crypto-ux500.h
 delete mode 100644 arch/arm/mach-ux500/include/mach/debug-macro.S
 delete mode 100644 arch/arm/mach-ux500/include/mach/hardware.h
 delete mode 100644 arch/arm/mach-ux500/include/mach/irqs.h
 delete mode 100644 arch/arm/mach-ux500/include/mach/msp.h
 delete mode 100644 arch/arm/mach-ux500/include/mach/uncompress.h
 create mode 100644 arch/arm/mach-versatile/include/mach-versatile/clkdev.h
 rename arch/arm/mach-versatile/include/{mach => mach-versatile}/debug-macro.S (100%)
 rename arch/arm/{mach-vexpress/include/mach => mach-versatile/include/mach-versatile}/gpio.h (100%)
 rename arch/arm/mach-versatile/include/{mach => mach-versatile}/hardware.h (100%)
 rename arch/arm/mach-versatile/include/{mach => mach-versatile}/io.h (100%)
 create mode 100644 arch/arm/mach-versatile/include/mach-versatile/irqs.h
 rename arch/arm/mach-versatile/include/{mach => mach-versatile}/platform.h (100%)
 rename arch/arm/mach-versatile/include/{mach => mach-versatile}/timex.h (100%)
 rename arch/arm/mach-versatile/include/{mach => mach-versatile}/uncompress.h (100%)
 delete mode 100644 arch/arm/mach-versatile/include/mach/clkdev.h
 delete mode 100644 arch/arm/mach-versatile/include/mach/irqs.h
 rename arch/arm/mach-vexpress/include/{mach => mach-vexpress}/ct-ca9x4.h (100%)
 rename arch/arm/mach-vexpress/include/{mach => mach-vexpress}/debug-macro.S (100%)
 rename arch/arm/{mach-vt8500/include/mach => mach-vexpress/include/mach-vexpress}/gpio.h (100%)
 rename arch/arm/mach-vexpress/include/{mach => mach-vexpress}/hardware.h (100%)
 rename arch/arm/mach-vexpress/include/{mach => mach-vexpress}/irqs.h (100%)
 rename arch/arm/mach-vexpress/include/{mach => mach-vexpress}/motherboard.h (100%)
 rename arch/arm/mach-vexpress/include/{mach => mach-vexpress}/timex.h (100%)
 rename arch/arm/mach-vexpress/include/{mach => mach-vexpress}/uncompress.h (100%)
 rename arch/arm/mach-vt8500/include/{mach => mach-vt8500}/debug-macro.S (100%)
 rename arch/arm/mach-vt8500/include/{mach => mach-vt8500}/entry-macro.S (100%)
 rename arch/arm/{plat-mxc/include/mach => mach-vt8500/include/mach-vt8500}/gpio.h (100%)
 rename arch/arm/mach-vt8500/include/{mach => mach-vt8500}/hardware.h (100%)
 rename arch/arm/mach-vt8500/include/{mach => mach-vt8500}/i8042.h (100%)
 rename arch/arm/mach-vt8500/include/{mach => mach-vt8500}/irqs.h (100%)
 rename arch/arm/mach-vt8500/include/{mach => mach-vt8500}/restart.h (100%)
 rename arch/arm/mach-vt8500/include/{mach => mach-vt8500}/timex.h (100%)
 rename arch/arm/mach-vt8500/include/{mach => mach-vt8500}/uncompress.h (100%)
 rename arch/arm/mach-vt8500/include/{mach => mach-vt8500}/vt8500_irqs.h (100%)
 rename arch/arm/mach-vt8500/include/{mach => mach-vt8500}/vt8500_regs.h (100%)
 rename arch/arm/mach-vt8500/include/{mach => mach-vt8500}/vt8500fb.h (100%)
 rename arch/arm/mach-vt8500/include/{mach => mach-vt8500}/wm8505_irqs.h (100%)
 rename arch/arm/mach-vt8500/include/{mach => mach-vt8500}/wm8505_regs.h (100%)
 create mode 100644 arch/arm/mach-w90x900/include/mach-w90x900/entry-macro.S
 rename arch/arm/mach-w90x900/include/{mach => mach-w90x900}/fb.h (100%)
 create mode 100644 arch/arm/mach-w90x900/include/mach-w90x900/gpio.h
 create mode 100644 arch/arm/mach-w90x900/include/mach-w90x900/hardware.h
 rename arch/arm/mach-w90x900/include/{mach => mach-w90x900}/i2c.h (100%)
 rename arch/arm/mach-w90x900/include/{mach => mach-w90x900}/irqs.h (100%)
 rename arch/arm/mach-w90x900/include/{mach => mach-w90x900}/map.h (100%)
 rename arch/arm/mach-w90x900/include/{mach => mach-w90x900}/mfp.h (100%)
 rename arch/arm/mach-w90x900/include/{mach => mach-w90x900}/nuc900_spi.h (100%)
 rename arch/arm/mach-w90x900/include/{mach => mach-w90x900}/regs-clock.h (100%)
 rename arch/arm/mach-w90x900/include/{mach => mach-w90x900}/regs-ebi.h (100%)
 rename arch/arm/mach-w90x900/include/{mach => mach-w90x900}/regs-gcr.h (100%)
 rename arch/arm/mach-w90x900/include/{mach => mach-w90x900}/regs-irq.h (100%)
 create mode 100644 arch/arm/mach-w90x900/include/mach-w90x900/regs-ldm.h
 rename arch/arm/mach-w90x900/include/{mach => mach-w90x900}/regs-serial.h (100%)
 rename arch/arm/mach-w90x900/include/{mach => mach-w90x900}/regs-timer.h (100%)
 rename arch/arm/mach-w90x900/include/{mach => mach-w90x900}/regs-usb.h (100%)
 rename arch/arm/mach-w90x900/include/{mach => mach-w90x900}/timex.h (100%)
 create mode 100644 arch/arm/mach-w90x900/include/mach-w90x900/uncompress.h
 rename arch/arm/mach-w90x900/include/{mach => mach-w90x900}/w90p910_keypad.h (100%)
 delete mode 100644 arch/arm/mach-w90x900/include/mach/entry-macro.S
 delete mode 100644 arch/arm/mach-w90x900/include/mach/gpio.h
 delete mode 100644 arch/arm/mach-w90x900/include/mach/hardware.h
 delete mode 100644 arch/arm/mach-w90x900/include/mach/regs-ldm.h
 delete mode 100644 arch/arm/mach-w90x900/include/mach/uncompress.h
 create mode 100644 arch/arm/mach-zynq/include/mach-zynq/clkdev.h
 create mode 100644 arch/arm/mach-zynq/include/mach-zynq/debug-macro.S
 rename arch/arm/mach-zynq/include/{mach => mach-zynq}/hardware.h (100%)
 rename arch/arm/mach-zynq/include/{mach => mach-zynq}/irqs.h (100%)
 rename arch/arm/mach-zynq/include/{mach => mach-zynq}/timex.h (100%)
 rename arch/arm/mach-zynq/include/{mach => mach-zynq}/uart.h (100%)
 create mode 100644 arch/arm/mach-zynq/include/mach-zynq/uncompress.h
 rename arch/arm/mach-zynq/include/{mach => mach-zynq}/zynq_soc.h (100%)
 delete mode 100644 arch/arm/mach-zynq/include/mach/clkdev.h
 delete mode 100644 arch/arm/mach-zynq/include/mach/debug-macro.S
 delete mode 100644 arch/arm/mach-zynq/include/mach/uncompress.h
 delete mode 100644 arch/arm/plat-mxc/include/mach/debug-macro.S
 delete mode 100644 arch/arm/plat-mxc/include/mach/devices-common.h
 delete mode 100644 arch/arm/plat-mxc/include/mach/hardware.h
 delete mode 100644 arch/arm/plat-mxc/include/mach/iomux-mx1.h
 delete mode 100644 arch/arm/plat-mxc/include/mach/iomux-mx21.h
 delete mode 100644 arch/arm/plat-mxc/include/mach/iomux-mx25.h
 delete mode 100644 arch/arm/plat-mxc/include/mach/iomux-mx27.h
 delete mode 100644 arch/arm/plat-mxc/include/mach/iomux-mx35.h
 delete mode 100644 arch/arm/plat-mxc/include/mach/iomux-mx50.h
 delete mode 100644 arch/arm/plat-mxc/include/mach/iomux-mx51.h
 delete mode 100644 arch/arm/plat-mxc/include/mach/iomux-mx53.h
 rename arch/arm/plat-nomadik/include/{plat => plat-nomadik}/gpio-nomadik.h (100%)
 rename arch/arm/plat-nomadik/include/{plat => plat-nomadik}/mtu.h (100%)
 rename arch/arm/plat-nomadik/include/{plat => plat-nomadik}/pincfg.h (100%)
 rename arch/arm/plat-nomadik/include/{plat => plat-nomadik}/ske.h (100%)
 rename arch/arm/plat-nomadik/include/{plat => plat-nomadik}/ste_dma40.h (100%)
 rename arch/arm/plat-omap/include/{plat => plat-omap}/am33xx.h (100%)
 rename arch/arm/plat-omap/include/{plat => plat-omap}/board-ams-delta.h (100%)
 rename arch/arm/plat-omap/include/{plat => plat-omap}/board-sx1.h (100%)
 rename arch/arm/plat-omap/include/{plat => plat-omap}/board-voiceblue.h (100%)
 create mode 100644 arch/arm/plat-omap/include/plat-omap/board.h
 rename arch/arm/plat-omap/include/{plat => plat-omap}/clkdev_omap.h (100%)
 rename arch/arm/plat-omap/include/{plat => plat-omap}/clock.h (100%)
 create mode 100644 arch/arm/plat-omap/include/plat-omap/common.h
 create mode 100644 arch/arm/plat-omap/include/plat-omap/cpu.h
 rename arch/arm/plat-omap/include/{plat => plat-omap}/dma-44xx.h (100%)
 create mode 100644 arch/arm/plat-omap/include/plat-omap/dma.h
 rename arch/arm/plat-omap/include/{plat => plat-omap}/dmtimer.h (100%)
 rename arch/arm/plat-omap/include/{plat => plat-omap}/dsp.h (100%)
 rename arch/arm/plat-omap/include/{plat => plat-omap}/flash.h (100%)
 rename arch/arm/plat-omap/include/{plat => plat-omap}/fpga.h (100%)
 rename arch/arm/plat-omap/include/{plat => plat-omap}/gpio-switch.h (100%)
 rename arch/arm/plat-omap/include/{plat => plat-omap}/gpio.h (100%)
 rename arch/arm/plat-omap/include/{plat => plat-omap}/gpmc-smc91x.h (100%)
 rename arch/arm/plat-omap/include/{plat => plat-omap}/gpmc-smsc911x.h (100%)
 rename arch/arm/plat-omap/include/{plat => plat-omap}/gpmc.h (100%)
 create mode 100644 arch/arm/plat-omap/include/plat-omap/hardware.h
 create mode 100644 arch/arm/plat-omap/include/plat-omap/hdq1w.h
 rename arch/arm/plat-omap/include/{plat => plat-omap}/i2c.h (100%)
 create mode 100644 arch/arm/plat-omap/include/plat-omap/iommu.h
 rename arch/arm/plat-omap/include/{plat => plat-omap}/iommu2.h (100%)
 rename arch/arm/plat-omap/include/{plat => plat-omap}/iopgtable.h (100%)
 rename arch/arm/plat-omap/include/{plat => plat-omap}/iovmm.h (100%)
 rename arch/arm/plat-omap/include/{plat => plat-omap}/irda.h (100%)
 rename arch/arm/plat-omap/include/{plat => plat-omap}/irqs-44xx.h (100%)
 rename arch/arm/plat-omap/include/{plat => plat-omap}/irqs.h (100%)
 rename arch/arm/plat-omap/include/{plat => plat-omap}/keypad.h (100%)
 rename arch/arm/plat-omap/include/{plat => plat-omap}/l3_2xxx.h (100%)
 rename arch/arm/plat-omap/include/{plat => plat-omap}/l3_3xxx.h (100%)
 rename arch/arm/plat-omap/include/{plat => plat-omap}/l4_2xxx.h (100%)
 rename arch/arm/plat-omap/include/{plat => plat-omap}/l4_3xxx.h (100%)
 rename arch/arm/plat-omap/include/{plat => plat-omap}/lcd_mipid.h (100%)
 rename arch/arm/plat-omap/include/{plat => plat-omap}/led.h (100%)
 rename arch/arm/plat-omap/include/{plat => plat-omap}/mailbox.h (100%)
 rename arch/arm/plat-omap/include/{plat => plat-omap}/mcbsp.h (100%)
 rename arch/arm/plat-omap/include/{plat => plat-omap}/mcspi.h (100%)
 rename arch/arm/plat-omap/include/{plat => plat-omap}/menelaus.h (100%)
 create mode 100644 arch/arm/plat-omap/include/plat-omap/mmc.h
 rename arch/arm/plat-omap/include/{plat => plat-omap}/multi.h (100%)
 rename arch/arm/plat-omap/include/{plat => plat-omap}/mux.h (100%)
 create mode 100644 arch/arm/plat-omap/include/plat-omap/nand.h
 rename arch/arm/plat-omap/include/{plat => plat-omap}/omap-pm.h (100%)
 rename arch/arm/plat-omap/include/{plat => plat-omap}/omap-secure.h (100%)
 create mode 100644 arch/arm/plat-omap/include/plat-omap/omap-serial.h
 rename arch/arm/plat-omap/include/{plat => plat-omap}/omap1510.h (100%)
 rename arch/arm/plat-omap/include/{plat => plat-omap}/omap16xx.h (100%)
 rename arch/arm/plat-omap/include/{plat => plat-omap}/omap24xx.h (100%)
 rename arch/arm/plat-omap/include/{plat => plat-omap}/omap34xx.h (100%)
 rename arch/arm/plat-omap/include/{plat => plat-omap}/omap4-keypad.h (100%)
 rename arch/arm/plat-omap/include/{plat => plat-omap}/omap44xx.h (100%)
 rename arch/arm/plat-omap/include/{plat => plat-omap}/omap54xx.h (100%)
 rename arch/arm/plat-omap/include/{plat => plat-omap}/omap7xx.h (100%)
 create mode 100644 arch/arm/plat-omap/include/plat-omap/omap_device.h
 create mode 100644 arch/arm/plat-omap/include/plat-omap/omap_hwmod.h
 rename arch/arm/plat-omap/include/{plat => plat-omap}/onenand.h (100%)
 rename arch/arm/plat-omap/include/{plat => plat-omap}/param.h (100%)
 rename arch/arm/plat-omap/include/{plat => plat-omap}/prcm.h (100%)
 rename arch/arm/plat-omap/include/{plat => plat-omap}/remoteproc.h (100%)
 rename arch/arm/plat-omap/include/{plat => plat-omap}/sdrc.h (100%)
 rename arch/arm/plat-omap/include/{plat => plat-omap}/serial.h (100%)
 rename arch/arm/plat-omap/include/{plat => plat-omap}/sram.h (100%)
 rename arch/arm/plat-omap/include/{plat => plat-omap}/tc.h (100%)
 rename arch/arm/plat-omap/include/{plat => plat-omap}/ti81xx.h (100%)
 rename arch/arm/plat-omap/include/{plat => plat-omap}/timex.h (100%)
 create mode 100644 arch/arm/plat-omap/include/plat-omap/uncompress.h
 create mode 100644 arch/arm/plat-omap/include/plat-omap/usb.h
 rename arch/arm/plat-omap/include/{plat => plat-omap}/voltage.h (100%)
 rename arch/arm/plat-omap/include/{plat => plat-omap}/vram.h (100%)
 rename arch/arm/plat-omap/include/{plat => plat-omap}/vrfb.h (100%)
 delete mode 100644 arch/arm/plat-omap/include/plat/board.h
 delete mode 100644 arch/arm/plat-omap/include/plat/common.h
 delete mode 100644 arch/arm/plat-omap/include/plat/cpu.h
 delete mode 100644 arch/arm/plat-omap/include/plat/dma.h
 delete mode 100644 arch/arm/plat-omap/include/plat/hardware.h
 delete mode 100644 arch/arm/plat-omap/include/plat/hdq1w.h
 delete mode 100644 arch/arm/plat-omap/include/plat/iommu.h
 delete mode 100644 arch/arm/plat-omap/include/plat/mmc.h
 delete mode 100644 arch/arm/plat-omap/include/plat/nand.h
 delete mode 100644 arch/arm/plat-omap/include/plat/omap-serial.h
 delete mode 100644 arch/arm/plat-omap/include/plat/omap_device.h
 delete mode 100644 arch/arm/plat-omap/include/plat/omap_hwmod.h
 delete mode 100644 arch/arm/plat-omap/include/plat/uncompress.h
 delete mode 100644 arch/arm/plat-omap/include/plat/usb.h
 rename arch/arm/plat-orion/include/{plat => plat-orion}/addr-map.h (100%)
 rename arch/arm/plat-orion/include/{plat => plat-orion}/audio.h (100%)
 rename arch/arm/plat-orion/include/{plat => plat-orion}/cache-feroceon-l2.h (100%)
 rename arch/arm/plat-orion/include/{plat => plat-orion}/common.h (100%)
 rename arch/arm/plat-orion/include/{plat => plat-orion}/ehci-orion.h (100%)
 rename arch/arm/plat-orion/include/{plat => plat-orion}/gpio.h (100%)
 rename arch/arm/plat-orion/include/{plat => plat-orion}/irq.h (100%)
 rename arch/arm/plat-orion/include/{plat => plat-orion}/mpp.h (100%)
 rename arch/arm/plat-orion/include/{plat => plat-orion}/mv_xor.h (100%)
 rename arch/arm/plat-orion/include/{plat => plat-orion}/mvsdio.h (100%)
 rename arch/arm/plat-orion/include/{plat => plat-orion}/orion_nand.h (100%)
 rename arch/arm/plat-orion/include/{plat => plat-orion}/pcie.h (100%)
 rename arch/arm/plat-orion/include/{plat => plat-orion}/time.h (100%)
 rename arch/arm/plat-pxa/include/{plat => plat-pxa}/dma.h (100%)
 rename arch/arm/plat-pxa/include/{plat => plat-pxa}/mfp.h (100%)
 rename arch/arm/plat-pxa/include/{plat => plat-pxa}/pxa27x_keypad.h (100%)
 rename arch/arm/plat-pxa/include/{plat => plat-pxa}/pxa3xx_nand.h (100%)
 rename arch/arm/plat-samsung/include/{plat => plat-samsung}/adc-core.h (100%)
 rename arch/arm/plat-samsung/include/{plat => plat-samsung}/adc.h (100%)
 rename arch/arm/plat-samsung/include/{plat => plat-samsung}/ata-core.h (100%)
 rename arch/arm/plat-samsung/include/{plat => plat-samsung}/ata.h (100%)
 rename arch/arm/plat-samsung/include/{plat => plat-samsung}/audio-simtec.h (100%)
 rename arch/arm/plat-samsung/include/{plat => plat-samsung}/audio.h (100%)
 rename arch/arm/plat-samsung/include/{plat => plat-samsung}/backlight.h (100%)
 rename arch/arm/plat-samsung/include/{plat => plat-samsung}/camport.h (100%)
 rename arch/arm/plat-samsung/include/{plat => plat-samsung}/clock-clksrc.h (100%)
 rename arch/arm/plat-samsung/include/{plat => plat-samsung}/clock.h (100%)
 rename arch/arm/plat-samsung/include/{plat => plat-samsung}/common-smdk.h (100%)
 create mode 100644 arch/arm/plat-samsung/include/plat-samsung/cpu-freq-core.h
 rename arch/arm/plat-samsung/include/{plat => plat-samsung}/cpu-freq.h (100%)
 rename arch/arm/plat-samsung/include/{plat => plat-samsung}/cpu.h (100%)
 create mode 100644 arch/arm/plat-samsung/include/plat-samsung/debug-macro.S
 rename arch/arm/plat-samsung/include/{plat => plat-samsung}/devs.h (100%)
 rename arch/arm/plat-samsung/include/{plat => plat-samsung}/dma-core.h (100%)
 rename arch/arm/plat-samsung/include/{plat => plat-samsung}/dma-ops.h (100%)
 create mode 100644 arch/arm/plat-samsung/include/plat-samsung/dma-pl330.h
 create mode 100644 arch/arm/plat-samsung/include/plat-samsung/dma-s3c24xx.h
 create mode 100644 arch/arm/plat-samsung/include/plat-samsung/dma.h
 rename arch/arm/plat-samsung/include/{plat => plat-samsung}/ehci.h (100%)
 rename arch/arm/plat-samsung/include/{plat => plat-samsung}/fb-core.h (100%)
 rename arch/arm/plat-samsung/include/{plat => plat-samsung}/fb-s3c2410.h (100%)
 rename arch/arm/plat-samsung/include/{plat => plat-samsung}/fb.h (100%)
 rename arch/arm/plat-samsung/include/{plat => plat-samsung}/fimc-core.h (100%)
 rename arch/arm/plat-samsung/include/{plat => plat-samsung}/fiq.h (100%)
 rename arch/arm/plat-samsung/include/{plat => plat-samsung}/gpio-cfg-helpers.h (100%)
 rename arch/arm/plat-samsung/include/{plat => plat-samsung}/gpio-cfg.h (100%)
 create mode 100644 arch/arm/plat-samsung/include/plat-samsung/gpio-core.h
 create mode 100644 arch/arm/plat-samsung/include/plat-samsung/gpio-fns.h
 rename arch/arm/plat-samsung/include/{plat => plat-samsung}/hwmon.h (100%)
 rename arch/arm/plat-samsung/include/{plat => plat-samsung}/iic-core.h (100%)
 rename arch/arm/plat-samsung/include/{plat => plat-samsung}/iic.h (100%)
 rename arch/arm/plat-samsung/include/{plat => plat-samsung}/irq-uart.h (100%)
 rename arch/arm/plat-samsung/include/{plat => plat-samsung}/irq-vic-timer.h (100%)
 rename arch/arm/plat-samsung/include/{plat => plat-samsung}/irq.h (100%)
 rename arch/arm/plat-samsung/include/{plat => plat-samsung}/irqs.h (100%)
 rename arch/arm/plat-samsung/include/{plat => plat-samsung}/keypad-core.h (100%)
 rename arch/arm/plat-samsung/include/{plat => plat-samsung}/keypad.h (100%)
 rename arch/arm/plat-samsung/include/{plat => plat-samsung}/map-base.h (100%)
 create mode 100644 arch/arm/plat-samsung/include/plat-samsung/map-s3c.h
 create mode 100644 arch/arm/plat-samsung/include/plat-samsung/map-s5p.h
 rename arch/arm/plat-samsung/include/{plat => plat-samsung}/mci.h (100%)
 rename arch/arm/plat-samsung/include/{plat => plat-samsung}/mfc.h (100%)
 rename arch/arm/plat-samsung/include/{plat => plat-samsung}/mipi_csis.h (100%)
 rename arch/arm/plat-samsung/include/{plat => plat-samsung}/nand-core.h (100%)
 rename arch/arm/plat-samsung/include/{plat => plat-samsung}/nand.h (100%)
 rename arch/arm/plat-samsung/include/{plat => plat-samsung}/onenand-core.h (100%)
 rename arch/arm/plat-samsung/include/{plat => plat-samsung}/pll.h (100%)
 rename arch/arm/plat-samsung/include/{plat => plat-samsung}/pm.h (100%)
 rename arch/arm/plat-samsung/include/{plat => plat-samsung}/pwm-clock.h (100%)
 rename arch/arm/plat-samsung/include/{plat => plat-samsung}/regs-ac97.h (100%)
 rename arch/arm/plat-samsung/include/{plat => plat-samsung}/regs-adc.h (100%)
 rename arch/arm/plat-samsung/include/{plat => plat-samsung}/regs-ata.h (100%)
 rename arch/arm/plat-samsung/include/{plat => plat-samsung}/regs-dma.h (100%)
 create mode 100644 arch/arm/plat-samsung/include/plat-samsung/regs-fb-v4.h
 rename arch/arm/plat-samsung/include/{plat => plat-samsung}/regs-fb.h (100%)
 rename arch/arm/plat-samsung/include/{plat => plat-samsung}/regs-iic.h (100%)
 rename arch/arm/plat-samsung/include/{plat => plat-samsung}/regs-iis.h (100%)
 rename arch/arm/plat-samsung/include/{plat => plat-samsung}/regs-irqtype.h (100%)
 rename arch/arm/plat-samsung/include/{plat => plat-samsung}/regs-nand.h (100%)
 rename arch/arm/plat-samsung/include/{plat => plat-samsung}/regs-onenand.h (100%)
 rename arch/arm/plat-samsung/include/{plat => plat-samsung}/regs-rtc.h (100%)
 rename arch/arm/plat-samsung/include/{plat => plat-samsung}/regs-sdhci.h (100%)
 rename arch/arm/plat-samsung/include/{plat => plat-samsung}/regs-serial.h (100%)
 rename arch/arm/plat-samsung/include/{plat => plat-samsung}/regs-spi.h (100%)
 rename arch/arm/plat-samsung/include/{plat => plat-samsung}/regs-srom.h (100%)
 rename arch/arm/plat-samsung/include/{plat => plat-samsung}/regs-timer.h (100%)
 rename arch/arm/plat-samsung/include/{plat => plat-samsung}/regs-udc.h (100%)
 rename arch/arm/plat-samsung/include/{plat => plat-samsung}/regs-usb-hsotg-phy.h (100%)
 rename arch/arm/plat-samsung/include/{plat => plat-samsung}/regs-watchdog.h (100%)
 rename arch/arm/plat-samsung/include/{plat => plat-samsung}/rtc-core.h (100%)
 rename arch/arm/plat-samsung/include/{plat => plat-samsung}/s3c2410.h (100%)
 rename arch/arm/plat-samsung/include/{plat => plat-samsung}/s3c2412.h (100%)
 rename arch/arm/plat-samsung/include/{plat => plat-samsung}/s3c2416.h (100%)
 rename arch/arm/plat-samsung/include/{plat => plat-samsung}/s3c2443.h (100%)
 rename arch/arm/plat-samsung/include/{plat => plat-samsung}/s3c244x.h (100%)
 rename arch/arm/plat-samsung/include/{plat => plat-samsung}/s3c64xx-spi.h (100%)
 rename arch/arm/plat-samsung/include/{plat => plat-samsung}/s5p-clock.h (100%)
 rename arch/arm/plat-samsung/include/{plat => plat-samsung}/s5p-time.h (100%)
 create mode 100644 arch/arm/plat-samsung/include/plat-samsung/sdhci.h
 rename arch/arm/plat-samsung/include/{plat => plat-samsung}/ts.h (100%)
 rename arch/arm/plat-samsung/include/{plat => plat-samsung}/tv-core.h (100%)
 rename arch/arm/plat-samsung/include/{plat => plat-samsung}/udc.h (100%)
 create mode 100644 arch/arm/plat-samsung/include/plat-samsung/uncompress.h
 rename arch/arm/plat-samsung/include/{plat => plat-samsung}/usb-control.h (100%)
 rename arch/arm/plat-samsung/include/{plat => plat-samsung}/usb-phy.h (100%)
 rename arch/arm/plat-samsung/include/{plat => plat-samsung}/wakeup-mask.h (100%)
 create mode 100644 arch/arm/plat-samsung/include/plat-samsung/watchdog-reset.h
 delete mode 100644 arch/arm/plat-samsung/include/plat/cpu-freq-core.h
 delete mode 100644 arch/arm/plat-samsung/include/plat/debug-macro.S
 delete mode 100644 arch/arm/plat-samsung/include/plat/dma-pl330.h
 delete mode 100644 arch/arm/plat-samsung/include/plat/dma-s3c24xx.h
 delete mode 100644 arch/arm/plat-samsung/include/plat/dma.h
 delete mode 100644 arch/arm/plat-samsung/include/plat/gpio-core.h
 delete mode 100644 arch/arm/plat-samsung/include/plat/gpio-fns.h
 delete mode 100644 arch/arm/plat-samsung/include/plat/map-s3c.h
 delete mode 100644 arch/arm/plat-samsung/include/plat/map-s5p.h
 delete mode 100644 arch/arm/plat-samsung/include/plat/regs-fb-v4.h
 delete mode 100644 arch/arm/plat-samsung/include/plat/sdhci.h
 delete mode 100644 arch/arm/plat-samsung/include/plat/uncompress.h
 delete mode 100644 arch/arm/plat-samsung/include/plat/watchdog-reset.h
 rename arch/arm/plat-spear/include/{plat => plat-spear}/debug-macro.S (100%)
 rename arch/arm/plat-spear/include/{plat => plat-spear}/gpio.h (100%)
 rename arch/arm/plat-spear/include/{plat => plat-spear}/keyboard.h (100%)
 rename arch/arm/plat-spear/include/{plat => plat-spear}/pl080.h (100%)
 rename arch/arm/plat-spear/include/{plat => plat-spear}/shirq.h (100%)
 rename arch/arm/plat-spear/include/{plat => plat-spear}/timex.h (100%)
 rename arch/arm/plat-spear/include/{plat => plat-spear}/uncompress.h (100%)
 rename arch/arm/plat-versatile/include/{plat => plat-versatile}/clcd.h (100%)
 rename arch/arm/plat-versatile/include/{plat => plat-versatile}/clock.h (100%)
 rename arch/arm/plat-versatile/include/{plat => plat-versatile}/fpga-irq.h (100%)
 rename arch/arm/plat-versatile/include/{plat => plat-versatile}/sched_clock.h (100%)
 create mode 100755 arch/arm/tools/gen-headers

-- 
1.7.10

