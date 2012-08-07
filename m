Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031031Ab2HGW7F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 18:59:05 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:33320 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031019Ab2HGWp3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 18:45:29 -0400
From: Matt Sealey <matt@genesi-usa.com>
To: Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>
Cc: Steev Klimaszewski <steev@genesi-usa.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Matt Sealey <matt@genesi-usa.com>, Shawn Guo <shawn.guo@linaro.org>,
        Dave Martin <dave.martin@linaro.org>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Sascha Hauer <kernel@pengutronix.de>
Subject: [PATCH 0/2] ARM: imx: change building of SSI FIQ support for i.MX processors
Date: Tue,  7 Aug 2012 17:45:12 -0500
Message-Id: <1344379514-30076-1-git-send-email-matt@genesi-usa.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patches to fix Thumb2 kernel building and change the dependency for SSI FIQ
support to a more specific option to prevent it from being needlessly built
in the first place on more frugal kernel configurations.

A better solution might be to rewrite the function in Thumb-compatible assembly
but the target processors do not support Thumb2 kernels anyway, and the last
time it was suggested the updated code was nacked by Russell. Since its built
as a side-effect on ARMv6/v7 i.MX processors, these could be considered somewhat
Needful Things(tm) by people wanting Thumb2 kernels based on imx_v6_v7_defconfig
or wanting to remove certain boards from their configs.

Matt Sealey (2):
  ARM: build ssi-fiq.S in ARM mode to prevent CONFIG_THUMB2_KERNEL
    build breakage
  ARM: only build ssi-fiq.S et al if CONFIG_SND_IMX_SOC_PCM_FIQ is
    selected

 arch/arm/plat-mxc/Makefile  |    2 +-
 arch/arm/plat-mxc/ssi-fiq.S |    1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

-- 
1.7.9.5

