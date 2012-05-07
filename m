Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755400Ab2EGHjA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 03:39:00 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:19898 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754194Ab2EGHi7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 03:38:59 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Mon, 07 May 2012 00:38:23 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: broonie@opensource.wolfsonmicro.com, gregkh@linuxfoundation.org,
        lrg@ti.com, linux-kernel@vger.kernel.org
Cc: Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH V1 0/4] regulator: tps62360: add cache support and settling time.
Date: Mon,  7 May 2012 13:05:35 +0530
Message-Id: <1336376139-1048-1-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series is for improving the regulator tps62360 by enabling
caching, using efficient functions for reducing code size and provide
settling time.

Laxman Dewangan (4):
  regmap: add function for set/clear bits
	This add the regmap_set_bits()/regmap_clear_bits() functionlity.

  regulator: tps62360: enable register cache
	Enable the caching of register to have faster update_bits as it
	will avoid one more i2c read every time.

  regulator: tps62360: use efficient function
	This reduces code size and have better readability in the code.

  regulator: tps62360: Provide settling time for voltage change
	This will provide settlling delay when voltage output changes.

 drivers/base/regmap/regmap.c           |   32 ++++++++++
 drivers/regulator/tps62360-regulator.c |  106 +++++++++++++++++++-------------
 include/linux/regmap.h                 |   15 +++++
 3 files changed, 110 insertions(+), 43 deletions(-)

