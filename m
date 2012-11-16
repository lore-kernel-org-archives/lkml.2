Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751594Ab2KPFrY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 00:47:24 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:54825 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750767Ab2KPFrM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 00:47:12 -0500
From: Damian Hobson-Garcia <dhobsong@igel.co.jp>
To: hjk@hansjkoch.de, gregkh@linuxfoundation.org, magnus.damm@gmail.com,
        horms@verge.net.au
Cc: linux-kernel@vger.kernel.org, linux-sh@vger.kernel.org,
        Damian Hobson-Garcia <dhobsong@igel.co.jp>
Subject: [PATCH 4/4] drivers: uio: Only allocate new private data when probing device tree node
Date: Fri, 16 Nov 2012 14:46:12 +0900
Message-Id: <1353044772-18803-5-git-send-email-dhobsong@igel.co.jp>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1353044772-18803-1-git-send-email-dhobsong@igel.co.jp>
References: <1353044772-18803-1-git-send-email-dhobsong@igel.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The same condition should be used both when allocating and freeing the
driver private data.  When dev.of_node is non NULL, allocate a new
private data structure, otherwise use the values from the platform data.

Reported-by: Fengguang Wu <fengguang.wu@intel.com>

Signed-off-by: Damian Hobson-Garcia <dhobsong@igel.co.jp>
---
 drivers/uio/uio_dmem_genirq.c |    2 +-
 drivers/uio/uio_pdrv_genirq.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/uio/uio_dmem_genirq.c b/drivers/uio/uio_dmem_genirq.c
index bbdf925..252434c 100644
--- a/drivers/uio/uio_dmem_genirq.c
+++ b/drivers/uio/uio_dmem_genirq.c
@@ -153,7 +153,7 @@ static int uio_dmem_genirq_probe(struct platform_device *pdev)
 	int ret = -EINVAL;
 	int i;
 
-	if (!uioinfo) {
+	if (pdev->dev.of_node) {
 		int irq;
 
 		/* alloc uioinfo for one device */
diff --git a/drivers/uio/uio_pdrv_genirq.c b/drivers/uio/uio_pdrv_genirq.c
index 42202cd..45fcceb 100644
--- a/drivers/uio/uio_pdrv_genirq.c
+++ b/drivers/uio/uio_pdrv_genirq.c
@@ -102,7 +102,7 @@ static int uio_pdrv_genirq_probe(struct platform_device *pdev)
 	int ret = -EINVAL;
 	int i;
 
-	if (!uioinfo) {
+	if (pdev->dev.of_node) {
 		int irq;
 
 		/* alloc uioinfo for one device */
-- 
1.7.5.4

