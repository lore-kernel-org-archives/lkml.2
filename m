Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753089Ab2LPR0o (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2012 12:26:44 -0500
Received: from perceval.ideasonboard.com ([95.142.166.194]:43775 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752303Ab2LPRY7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2012 12:24:59 -0500
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: Hideki EIRAKU <hdk@igel.co.jp>
Cc: Paul Mundt <lethal@linux-sh.org>, Magnus Damm <magnus.damm@gmail.com>,
        Simon Horman <horms@verge.net.au>, linux-sh@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Katsuya MATSUBARA <matsu@igel.co.jp>,
        Damian Hobson-Garcia <dhobsong@igel.co.jp>
Subject: [PATCH/WIP/RFC 09/14] shmobile-ipmmu: Rename ipmmu_priv to shmobile_ipmmu
Date: Sun, 16 Dec 2012 18:25:55 +0100
Message-Id: <1355678760-27357-10-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1355678760-27357-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1350290093-998-1-git-send-email-hdk@igel.co.jp>
 <1355678760-27357-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

And expose the structure to the IOMMU driver.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/iommu/shmobile-ipmmu.c |   14 ++++----------
 drivers/iommu/shmobile-ipmmu.h |    6 ++++++
 2 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/iommu/shmobile-ipmmu.c b/drivers/iommu/shmobile-ipmmu.c
index 34e3c66..b308292 100644
--- a/drivers/iommu/shmobile-ipmmu.c
+++ b/drivers/iommu/shmobile-ipmmu.c
@@ -34,13 +34,7 @@
 #define IMCTR1_TLBEN (1 << 0)
 #define IMCTR1_FLUSH (1 << 1)
 
-struct ipmmu_priv {
-	void __iomem *ipmmu_base;
-	int tlb_enabled;
-	struct mutex flush_lock;
-};
-
-static void ipmmu_reg_write(struct ipmmu_priv *priv, unsigned long reg_off,
+static void ipmmu_reg_write(struct shmobile_ipmmu *priv, unsigned long reg_off,
 			    unsigned long data)
 {
 	iowrite32(data, priv->ipmmu_base + reg_off);
@@ -48,7 +42,7 @@ static void ipmmu_reg_write(struct ipmmu_priv *priv, unsigned long reg_off,
 
 void ipmmu_tlb_flush(struct device *dev)
 {
-	struct ipmmu_priv *priv;
+	struct shmobile_ipmmu *priv;
 
 	if (!dev)
 		return;
@@ -63,7 +57,7 @@ void ipmmu_tlb_flush(struct device *dev)
 
 void ipmmu_tlb_set(struct device *dev, unsigned long phys, int size, int asid)
 {
-	struct ipmmu_priv *priv;
+	struct shmobile_ipmmu *priv;
 
 	if (!dev)
 		return;
@@ -110,7 +104,7 @@ void ipmmu_tlb_set(struct device *dev, unsigned long phys, int size, int asid)
 static int ipmmu_probe(struct platform_device *pdev)
 {
 	struct resource *res;
-	struct ipmmu_priv *priv;
+	struct shmobile_ipmmu *priv;
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (!res) {
diff --git a/drivers/iommu/shmobile-ipmmu.h b/drivers/iommu/shmobile-ipmmu.h
index 0e0a6a4..5c17a46 100644
--- a/drivers/iommu/shmobile-ipmmu.h
+++ b/drivers/iommu/shmobile-ipmmu.h
@@ -1,6 +1,12 @@
 #ifndef __SHMOBILE_IPMMU_H__
 #define __SHMOBILE_IPMMU_H__
 
+struct shmobile_ipmmu {
+	void __iomem *ipmmu_base;
+	int tlb_enabled;
+	struct mutex flush_lock;
+};
+
 #ifdef CONFIG_SHMOBILE_IPMMU_TLB
 void ipmmu_tlb_flush(struct device *ipmmu_dev);
 void ipmmu_tlb_set(struct device *ipmmu_dev, unsigned long phys, int size,
-- 
1.7.8.6

