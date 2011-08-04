Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754460Ab1HDWyK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Aug 2011 18:54:10 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:54735 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753288Ab1HDWyD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Aug 2011 18:54:03 -0400
From: Grant Likely <grant.likely@secretlab.ca>
To: David Woodhouse <dwmw2@infradead.org>,
        Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Grant Likely <grant.likely@secretlab.ca>
Subject: [PATCH] mtd/physmap: Fix set_vpp signature in physmap_configure
Date: Thu,  4 Aug 2011 23:53:53 +0100
Message-Id: <1312498433-17950-1-git-send-email-grant.likely@secretlab.ca>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

physmap_configure() has the wrong signature for the set_vpp callback.
struct physmap_flash_data expects it to accpet a platform_device
pointer.

However, I can't find any users of physmap_configure(), so maybe the
hook should simply be removed.

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
---
 drivers/mtd/maps/physmap.c  |    2 +-
 include/linux/mtd/physmap.h |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/mtd/maps/physmap.c b/drivers/mtd/maps/physmap.c
index f64cee4..f2b9f5e 100644
--- a/drivers/mtd/maps/physmap.c
+++ b/drivers/mtd/maps/physmap.c
@@ -247,7 +247,7 @@ static struct platform_device physmap_flash = {
 };
 
 void physmap_configure(unsigned long addr, unsigned long size,
-		int bankwidth, void (*set_vpp)(struct map_info *, int))
+		int bankwidth, void (*set_vpp)(struct platform_device *, int))
 {
 	physmap_flash_resource.start = addr;
 	physmap_flash_resource.end = addr + size - 1;
diff --git a/include/linux/mtd/physmap.h b/include/linux/mtd/physmap.h
index e5f21d2..25ef3ed 100644
--- a/include/linux/mtd/physmap.h
+++ b/include/linux/mtd/physmap.h
@@ -36,7 +36,7 @@ struct physmap_flash_data {
  * Board needs to specify the exact mapping during their setup time.
  */
 void physmap_configure(unsigned long addr, unsigned long size,
-		int bankwidth, void (*set_vpp)(struct map_info *, int) );
+		int bankwidth, void (*set_vpp)(struct platform_device *, int) );
 
 /*
  * Machines that wish to do flash partition may want to call this function in
-- 
1.7.4.1

