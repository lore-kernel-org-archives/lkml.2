Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752148Ab2F2G5u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 02:57:50 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:56902 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751162Ab2F2G5t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 02:57:49 -0400
From: Richard Genoud <richard.genoud@gmail.com>
To: Artem Bityutskiy <dedekind1@gmail.com>
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        Richard Genoud <richard.genoud@gmail.com>
Subject: [PATCH] UBI: Change the default percentage of reserved PEB
Date: Fri, 29 Jun 2012 08:57:41 +0200
Message-Id: <1340953061-15728-1-git-send-email-richard.genoud@gmail.com>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The actual value (1%) is too low for actual NAND devices, a huge
majority of device has 2% maximum bad blocks (SLC or MLC).
(Actually it's 20 blocks on a 1024 blocks device, 40/2048...)

Signed-off-by: Richard Genoud <richard.genoud@gmail.com>
---
 drivers/mtd/ubi/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mtd/ubi/Kconfig b/drivers/mtd/ubi/Kconfig
index 738ee8d..ea4b95b 100644
--- a/drivers/mtd/ubi/Kconfig
+++ b/drivers/mtd/ubi/Kconfig
@@ -29,7 +29,7 @@ config MTD_UBI_WL_THRESHOLD
 
 config MTD_UBI_BEB_RESERVE
 	int "Percentage of reserved eraseblocks for bad eraseblocks handling"
-	default 1
+	default 2
 	range 0 25
 	help
 	  If the MTD device admits of bad eraseblocks (e.g. NAND flash), UBI
-- 
1.7.2.5

