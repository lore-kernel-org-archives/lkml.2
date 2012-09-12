Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758509Ab2ILNA2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 09:00:28 -0400
Received: from smtp4.mundo-r.com ([212.51.32.151]:15608 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758134Ab2ILMz7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 08:55:59 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqECACCFUFBbdWObgWdsb2JhbABFu0AiAQEWJieCIAEBBXkQIDFXBhOIEbxikVIDlV+TBw
X-IronPort-AV: E=Sophos;i="4.80,410,1344204000"; 
   d="scan'208";a="950511813"
From: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        industrypack-devel@lists.sourceforge.net,
        Jens Taprogge <jens.taprogge@taprogge.org>,
        Samuel Iglesias Gonsalvez <siglesias@igalia.com>
Subject: [PATCH 24/24] staging: ipack/bridges/tpci200: Use endianess-aware types where applicable.
Date: Wed, 12 Sep 2012 14:55:46 +0200
Message-Id: <1347454546-23236-24-git-send-email-siglesias@igalia.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1347454546-23236-1-git-send-email-siglesias@igalia.com>
References: <1347454546-23236-1-git-send-email-siglesias@igalia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jens Taprogge <jens.taprogge@taprogge.org>

Signed-off-by: Jens Taprogge <jens.taprogge@taprogge.org>
Signed-off-by: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
---
 drivers/staging/ipack/bridges/tpci200.c |   10 +++++-----
 drivers/staging/ipack/bridges/tpci200.h |    8 ++++----
 2 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/ipack/bridges/tpci200.c b/drivers/staging/ipack/bridges/tpci200.c
index 1a149d8..21b2b75 100644
--- a/drivers/staging/ipack/bridges/tpci200.c
+++ b/drivers/staging/ipack/bridges/tpci200.c
@@ -501,7 +501,7 @@ out_unlock:
 static int tpci200_get_clockrate(struct ipack_device *dev)
 {
 	struct tpci200_board *tpci200 = check_slot(dev);
-	u16 __iomem *addr;
+	__le16 __iomem *addr;
 
 	if (!tpci200)
 		return -ENODEV;
@@ -513,7 +513,7 @@ static int tpci200_get_clockrate(struct ipack_device *dev)
 static int tpci200_set_clockrate(struct ipack_device *dev, int mherz)
 {
 	struct tpci200_board *tpci200 = check_slot(dev);
-	u16 __iomem *addr;
+	__le16 __iomem *addr;
 
 	if (!tpci200)
 		return -ENODEV;
@@ -536,7 +536,7 @@ static int tpci200_set_clockrate(struct ipack_device *dev, int mherz)
 static int tpci200_get_error(struct ipack_device *dev)
 {
 	struct tpci200_board *tpci200 = check_slot(dev);
-	u16 __iomem *addr;
+	__le16 __iomem *addr;
 	u16 mask;
 
 	if (!tpci200)
@@ -550,7 +550,7 @@ static int tpci200_get_error(struct ipack_device *dev)
 static int tpci200_get_timeout(struct ipack_device *dev)
 {
 	struct tpci200_board *tpci200 = check_slot(dev);
-	u16 __iomem *addr;
+	__le16 __iomem *addr;
 	u16 mask;
 
 	if (!tpci200)
@@ -565,7 +565,7 @@ static int tpci200_get_timeout(struct ipack_device *dev)
 static int tpci200_reset_timeout(struct ipack_device *dev)
 {
 	struct tpci200_board *tpci200 = check_slot(dev);
-	u16 __iomem *addr;
+	__le16 __iomem *addr;
 	u16 mask;
 
 	if (!tpci200)
diff --git a/drivers/staging/ipack/bridges/tpci200.h b/drivers/staging/ipack/bridges/tpci200.h
index 2718d22..e1f60f3 100644
--- a/drivers/staging/ipack/bridges/tpci200.h
+++ b/drivers/staging/ipack/bridges/tpci200.h
@@ -37,12 +37,12 @@
 #define TPCI200_MEM8_SPACE_BAR        5
 
 struct tpci200_regs {
-	u16	revision;
+	__le16	revision;
 	/* writes to control should occur with the mutex held to protect
 	 * read-modify-write operations */
-	u16  control[4];
-	u16	reset;
-	u16	status;
+	__le16  control[4];
+	__le16	reset;
+	__le16	status;
 	u8	reserved[242];
 } __packed;
 
-- 
1.7.10.4

