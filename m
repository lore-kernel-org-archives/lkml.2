Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760000Ab1EOLfV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 May 2011 07:35:21 -0400
Received: from londo.lunn.ch ([80.238.139.98]:59486 "EHLO londo.lunn.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759963Ab1EOLfT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 May 2011 07:35:19 -0400
From: Andrew Lunn <andrew@lunn.ch>
To: kernel@wantstofly.org, nico@fluxnic.net
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        saeed.bishara@gmail.com, Andrew Lunn <andrew@lunn.ch>
Subject: [PATCHv2 00/15] Consolidate Orion platform information setup.
Date: Sun, 15 May 2011 13:32:39 +0200
Message-Id: <1305459174-25517-1-git-send-email-andrew@lunn.ch>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset consolidates some of the code used for creating
platform data for various orion based SoC, namely Dove, Loki, Kirkwood,
mv78xx0 and Orion5x. Where possible, this code has been put into the
orion platform, with the mach-*/common.c calling the common platform
code.

Additionally the setup of the multi purpose pins has been consolidated.
Kirkwood and mv78xx0 had identical code, which has been generalized and
put into the platform. Orion5x and Dove mpp code has been re-written to 
use the consolidated method.

Tested on a Kirkwood device, otherwise compile tested.

Changes since last version:

 - Typos found by Saeed Bishara fixed
 - All ethernets reserve the same size
 - Add Kirkwood RTC interrupt as a seperate patch
 - Rather than drop the dove mpp code, refactor to use the platform code.

    Andrew Lunn


Andrew Lunn (15):
  [Orion] Rename some constants to macros to make code more identical
  [orion] Consolidate the creation of the uart platform data.
  [orion] Consolidate the creation of the RTC platform data.
  [kirkwood] Add support for RTC interrupts which allows RTC alarms.
  [orion] Consolidate ethernet platform data
  [orion] Consolidate I2C initialization.
  [orion] Consolidate SPI initialization.
  [orion] Consolidate the platform data setup for the watchdog.
  [orion] Consolidate the XOR platform setup code.
  [orion] Consolidate USB platform setup code.
  [orion] Consolidate SATA platform setup.
  [orion] Consolidate setup of the crypto engine.
  [orion] Refactor the MPP code. Common code in the orion platform.
  [orion5x] Refactor mpp code to use common orion platform mpp.
  [dove] Consolidate mpp code with platform mpp.

 arch/arm/mach-dove/common.c                    |  616 +---------------
 arch/arm/mach-dove/mpp.c                       |  134 ++---
 arch/arm/mach-dove/mpp.h                       |  362 +++++-----
 arch/arm/mach-kirkwood/common.c                |  601 +--------------
 arch/arm/mach-kirkwood/include/mach/irqs.h     |    1 +
 arch/arm/mach-kirkwood/mpp.c                   |   58 +--
 arch/arm/mach-kirkwood/mpp.h                   |    6 -
 arch/arm/mach-loki/common.c                    |  190 +-----
 arch/arm/mach-mv78xx0/common.c                 |  570 +-------------
 arch/arm/mach-mv78xx0/mpp.c                    |   58 +--
 arch/arm/mach-mv78xx0/mpp.h                    |    6 -
 arch/arm/mach-orion5x/common.c                 |  478 +-----------
 arch/arm/mach-orion5x/d2net-setup.c            |   44 +-
 arch/arm/mach-orion5x/db88f5281-setup.c        |   44 +-
 arch/arm/mach-orion5x/dns323-setup.c           |  132 ++--
 arch/arm/mach-orion5x/edmini_v2-setup.c        |   44 +-
 arch/arm/mach-orion5x/kurobox_pro-setup.c      |   44 +-
 arch/arm/mach-orion5x/ls-chl-setup.c           |   44 +-
 arch/arm/mach-orion5x/ls_hgl-setup.c           |   44 +-
 arch/arm/mach-orion5x/lsmini-setup.c           |   44 +-
 arch/arm/mach-orion5x/mpp.c                    |  150 +----
 arch/arm/mach-orion5x/mpp.h                    |  191 +++--
 arch/arm/mach-orion5x/mss2-setup.c             |   44 +-
 arch/arm/mach-orion5x/mv2120-setup.c           |   44 +-
 arch/arm/mach-orion5x/net2big-setup.c          |   44 +-
 arch/arm/mach-orion5x/rd88f5181l-fxo-setup.c   |   44 +-
 arch/arm/mach-orion5x/rd88f5181l-ge-setup.c    |   44 +-
 arch/arm/mach-orion5x/rd88f5182-setup.c        |   44 +-
 arch/arm/mach-orion5x/rd88f6183ap-ge-setup.c   |    1 -
 arch/arm/mach-orion5x/terastation_pro2-setup.c |   44 +-
 arch/arm/mach-orion5x/ts209-setup.c            |   44 +-
 arch/arm/mach-orion5x/ts409-setup.c            |   44 +-
 arch/arm/mach-orion5x/ts78xx-setup.c           |   44 +-
 arch/arm/mach-orion5x/wnr854t-setup.c          |   44 +-
 arch/arm/mach-orion5x/wrt350n-v2-setup.c       |   44 +-
 arch/arm/plat-orion/Makefile                   |    2 +-
 arch/arm/plat-orion/common.c                   |  957 ++++++++++++++++++++++++
 arch/arm/plat-orion/include/plat/common.h      |  117 +++
 arch/arm/plat-orion/include/plat/mpp.h         |   34 +
 arch/arm/plat-orion/mpp.c                      |   78 ++
 40 files changed, 2174 insertions(+), 3404 deletions(-)
 create mode 100644 arch/arm/plat-orion/common.c
 create mode 100644 arch/arm/plat-orion/include/plat/common.h
 create mode 100644 arch/arm/plat-orion/include/plat/mpp.h
 create mode 100644 arch/arm/plat-orion/mpp.c

-- 
1.7.4.4

