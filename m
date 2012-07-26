Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752032Ab2GZK3P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 06:29:15 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:45943 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751350Ab2GZK3N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 06:29:13 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de, broonie@opensource.wolfsonmicro.com,
        sameo@linux.intel.com, olalilja@yahoo.se, ola.o.lilja@stericsson.com,
        alsa-devel@alsa-project.org, lrg@ti.com
Subject: [PATCH 00/21] Some fixes and DT enablement for ux500 audio
Date: Thu, 26 Jul 2012 11:28:33 +0100
Message-Id: <1343298534-13611-1-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch-set sees some code reinforcement surrounding the recently
accepted MOP500 MSP, PCM, AB8500 CODEC and ux500 Audio Machine Driver.
It contains some extra error checking pertaining to the ux500 specific
drivers themselves, along with bugfixes for issues in core SoC Audio 
code happened upon along the way. There are also a couple of minor 
clean-ups relating to ux500 platform code, which are hitching a ride 
for ease of status tracking.

 arch/arm/boot/dts/db8500.dtsi            |   48 ++++++
 arch/arm/mach-ux500/Kconfig              |    1 +
 arch/arm/mach-ux500/Makefile             |    2 +-
 arch/arm/mach-ux500/board-mop500-audio.c |  194 ++++++++++++++++++++++
 arch/arm/mach-ux500/board-mop500-msp.c   |  267 ------------------------------
 arch/arm/mach-ux500/board-mop500-msp.h   |   14 --
 arch/arm/mach-ux500/board-mop500.c       |   23 ++-
 arch/arm/mach-ux500/board-mop500.h       |    6 +
 arch/arm/mach-ux500/include/mach/msp.h   |    3 +-
 drivers/mfd/ab8500-core.c                |    1 +
 drivers/mfd/db8500-prcmu.c               |    1 +
 include/linux/mfd/abx500/ab8500-codec.h  |    6 +-
 sound/soc/codecs/ab8500-codec.c          |   79 +++++++++
 sound/soc/soc-dapm.c                     |    2 -
 sound/soc/soc-io.c                       |   14 +-
 sound/soc/ux500/mop500.c                 |   41 +++++
 sound/soc/ux500/ux500_msp_dai.c          |   11 +-
 sound/soc/ux500/ux500_msp_i2s.c          |  118 ++++++++++---
 sound/soc/ux500/ux500_msp_i2s.h          |    5 +-
 sound/soc/ux500/ux500_pcm.c              |    6 +
 20 files changed, 516 insertions(+), 326 deletions(-)

