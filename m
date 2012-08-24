Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932755Ab2HXOCS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 10:02:18 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:59868 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932572Ab2HXOCM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 10:02:12 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de, broonie@opensource.wolfsonmicro.com,
        ola.o.lilja@stericsson.com, roger.xr.nilsson@stericsson.com,
        alsa-devel@alsa-project.org
Subject: [PATCH 00/17] MOP500 Audio fix-ups and DT enablement
Date: Fri, 24 Aug 2012 15:01:36 +0100
Message-Id: <1345816913-4113-1-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch-set provides the MOP500 Audio driver with a few small
fix-ups along with Device Tree enablement for MOP500 Core and the
MSPs. You'll notice that we've left the PCM out for the time being
and continue to register that using platform code. This is because
we're still in the middle of discussions pertaining to how this
pseudo-device should be handled. We also pass pinctrl responsibility
to the MSP driver instead of setting it up in platform code, which
is an unnecessary over-head. 

 Documentation/devicetree/bindings/mfd/ab8500.txt   |   15 ++
 .../devicetree/bindings/sound/ux500-mop500.txt     |   39 +++
 .../devicetree/bindings/sound/ux500-msp.txt        |   43 ++++
 arch/arm/boot/dts/dbx5x0.dtsi                      |   39 +++
 arch/arm/boot/dts/snowball.dts                     |   16 ++
 arch/arm/mach-ux500/Makefile                       |    2 +-
 arch/arm/mach-ux500/board-mop500-audio.c           |  199 +++++++++++++++
 arch/arm/mach-ux500/board-mop500-msp.c             |  267 --------------------
 arch/arm/mach-ux500/board-mop500-msp.h             |   14 -
 arch/arm/mach-ux500/board-mop500.c                 |   22 +-
 arch/arm/mach-ux500/board-mop500.h                 |    8 +
 arch/arm/mach-ux500/include/mach/msp.h             |    2 -
 include/linux/mfd/abx500/ab8500-codec.h            |    6 +-
 sound/soc/codecs/ab8500-codec.c                    |   81 ++++++
 sound/soc/ux500/mop500.c                           |   47 +++-
 sound/soc/ux500/ux500_msp_dai.c                    |    6 +
 sound/soc/ux500/ux500_msp_i2s.c                    |   89 +++++--
 sound/soc/ux500/ux500_msp_i2s.h                    |    8 +-
 18 files changed, 584 insertions(+), 319 deletions(-)

