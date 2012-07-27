Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752736Ab2G0Mj0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2012 08:39:26 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:42287 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752599Ab2G0MjC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2012 08:39:02 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de, olalilja@yahoo.se, ola.o.lilja@stericsson.com,
        sameo@linux.intel.com, alsa-devel@alsa-project.org,
        broonie@opensource.wolfsonmicro.com, lrg@ti.com
Subject: [PATCH 0/7] Bugfixes and clean-ups bound for the v3.6 RCs
Date: Fri, 27 Jul 2012 13:38:47 +0100
Message-Id: <1343392734-11805-1-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch-set includes some important changes which should make
their way to the Mainline Release Candidates for the v3.6 release.
Without them Audio doesn't even probe (at all) when booting with
Device Tree selected. The kernel can't compile with ux500 audio
enabled. Also platform data will fail to reach the AB8500 CODEC
driver. Even if we can get that far SoC Core will assume we're
using regmaps and attempt to use them; however, none exist for
this driver, so the kernel will oops.

 arch/arm/mach-ux500/board-mop500-msp.c |    2 +-
 arch/arm/mach-ux500/board-mop500.c     |    9 ++++-----
 drivers/mfd/ab8500-core.c              |    1 +
 drivers/mfd/db8500-prcmu.c             |    1 +
 sound/soc/codecs/ab8500-codec.c        |    4 ++++
 sound/soc/soc-dapm.c                   |    2 --
 6 files changed, 11 insertions(+), 8 deletions(-)

