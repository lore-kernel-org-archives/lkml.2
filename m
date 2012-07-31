Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753044Ab2GaNjY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 09:39:24 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:53416 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751838Ab2GaNjX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 09:39:23 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        olalilja@yahoo.se, ola.o.lilja@stericsson.com,
        alsa-devel@alsa-project.org, lrg@ti.com,
        broonie@opensource.wolfsonmicro.com
Cc: STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de
Subject: [PATCH 01/19] Configure ux500 Audio Drivers for Device Tree
Date: Tue, 31 Jul 2012 14:38:54 +0100
Message-Id: <1343741953-17828-1-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch-set sees many of the ux500 related Audio drivers gain
Device Tree enablement. There are also some fixes to issues which
where encountered along the way.

 Documentation/devicetree/bindings/mfd/ab8500.txt   |   15 +
 .../devicetree/bindings/sound/ux500-mop500.txt     |   39 ++
 .../devicetree/bindings/sound/ux500-msp.txt        |   43 ++
 arch/arm/boot/dts/db8500.dtsi                      |  597 ------------------
 arch/arm/boot/dts/dbx5x0.dtsi                      |  636 ++++++++++++++++++++
 arch/arm/boot/dts/snowball.dts                     |   18 +-
 arch/arm/mach-ux500/Makefile                       |    2 +-
 arch/arm/mach-ux500/board-mop500-audio.c           |  189 ++++++
 arch/arm/mach-ux500/board-mop500-msp.c             |  267 --------
 arch/arm/mach-ux500/board-mop500-msp.h             |   14 -
 arch/arm/mach-ux500/board-mop500.c                 |   22 +-
 arch/arm/mach-ux500/board-mop500.h                 |    6 +
 arch/arm/mach-ux500/include/mach/msp.h             |    2 -
 include/linux/mfd/abx500/ab8500-codec.h            |    6 +-
 sound/soc/codecs/ab8500-codec.c                    |   81 +++
 sound/soc/ux500/mop500.c                           |   42 +-
 sound/soc/ux500/ux500_msp_dai.c                    |   20 +-
 sound/soc/ux500/ux500_msp_i2s.c                    |   97 ++-
 sound/soc/ux500/ux500_msp_i2s.h                    |    2 -
 sound/soc/ux500/ux500_pcm.c                        |   19 +-
 sound/soc/ux500/ux500_pcm.h                        |    3 +
 21 files changed, 1189 insertions(+), 931 deletions(-)

