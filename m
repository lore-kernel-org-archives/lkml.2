Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754736Ab0LGCIK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 21:08:10 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:45958 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754156Ab0LGCIG (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Mon, 6 Dec 2010 21:08:06 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: airlied@linux.ie, tglx@linutronix.de, hpa@zytor.com, airlied@redhat.com,
        linux-kernel@vger.kernel.org, konrad@kernel.org
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 7/7] radeon/PCIe: bugfix: use the correct index field.
Date: Mon,  6 Dec 2010 21:07:26 -0500
Message-Id: <1291687646-31994-8-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1291687646-31994-1-git-send-email-konrad.wilk@oracle.com>
References: <1291687646-31994-1-git-send-email-konrad.wilk@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We were using the wrong index field causing us to ignore
when DMA addresses were passed in.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 drivers/gpu/drm/radeon/radeon_gart.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/radeon/radeon_gart.c b/drivers/gpu/drm/radeon/radeon_gart.c
index 8e89e01..4a5ac4b 100644
--- a/drivers/gpu/drm/radeon/radeon_gart.c
+++ b/drivers/gpu/drm/radeon/radeon_gart.c
@@ -183,9 +183,9 @@ int radeon_gart_bind(struct radeon_device *rdev, unsigned offset,
 	for (i = 0; i < pages; i++, p++) {
 		/* On TTM path, we only use the DMA API if TTM_PAGE_FLAG_DMA32
 		 * is requested. */
-		if (dma_addr[p] != DMA_ERROR_CODE) {
+		if (dma_addr[i] != DMA_ERROR_CODE) {
 			rdev->gart.ttm_alloced[p] = true;
-			rdev->gart.pages_addr[p] = dma_addr[p];
+			rdev->gart.pages_addr[p] = dma_addr[i];
 		} else {
 			/* we need to support large memory configurations */
 			/* assume that unbind have already been call on the range */
-- 
1.7.1

