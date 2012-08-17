Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758051Ab2HQOgH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 10:36:07 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:62831 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758034Ab2HQOft (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 10:35:49 -0400
From: Richard Genoud <richard.genoud@gmail.com>
To: Artem Bityutskiy <dedekind1@gmail.com>
Cc: Shmulik Ladkani <shmulik.ladkani@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-mtd@lists.infradead.org,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Subject: [PATCH 1/8] arm: sam9_l9260_defconfig: adjust UBI bad eraseblocks limit
Date: Fri, 17 Aug 2012 16:35:17 +0200
Message-Id: <1345214124-5478-2-git-send-email-richard.genoud@gmail.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1345214124-5478-1-git-send-email-richard.genoud@gmail.com>
References: <1345214124-5478-1-git-send-email-richard.genoud@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>

UBI has changed the MTD_UBI_BEB_LIMIT semantics. It used to be a percent of
total amount of eraseblock in the partition, and now it is the maximum
amount of bad eraseblocks on the entire devise per 1024 eraseblocks. So not
only the units changed, but also the meaning. But anyway, old 3% roughly
correspond to new 30, so change the defconfig correspondingly.

Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
---
 arch/arm/configs/sam9_l9260_defconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/arm/configs/sam9_l9260_defconfig b/arch/arm/configs/sam9_l9260_defconfig
index da276f9..d11fea5 100644
--- a/arch/arm/configs/sam9_l9260_defconfig
+++ b/arch/arm/configs/sam9_l9260_defconfig
@@ -39,7 +39,7 @@ CONFIG_MTD_NAND=y
 CONFIG_MTD_NAND_ATMEL=y
 CONFIG_MTD_NAND_PLATFORM=y
 CONFIG_MTD_UBI=y
-CONFIG_MTD_UBI_BEB_LIMIT=3
+CONFIG_MTD_UBI_BEB_LIMIT=30
 CONFIG_MTD_UBI_GLUEBI=y
 CONFIG_BLK_DEV_LOOP=y
 CONFIG_BLK_DEV_RAM=y
-- 
1.7.2.5

