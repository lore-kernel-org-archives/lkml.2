Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756597Ab2ENNm1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 09:42:27 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56531 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752717Ab2ENNmZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 09:42:25 -0400
Date: Mon, 14 May 2012 06:42:05 -0700
From: tip-bot for Dan Carpenter <dan.carpenter@oracle.com>
Message-ID: <tip-fefe1ed1398b81e3fadc92d11d91162d343c8836@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        joerg.roedel@amd.com, youquan.song@intel.com, stable@kernel.org,
        suresh.b.siddha@intel.com, tglx@linutronix.de, wharms@bfs.de,
        dan.carpenter@oracle.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        joerg.roedel@amd.com, youquan.song@intel.com, stable@kernel.org,
        suresh.b.siddha@intel.com, tglx@linutronix.de, wharms@bfs.de,
        dan.carpenter@oracle.com
In-Reply-To: <20120513170938.GA4280@elgon.mountain>
References: <20120513170938.GA4280@elgon.mountain>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/iommu] iommu: Fix off by one in dmar_get_fault_reason()
Git-Commit-ID: fefe1ed1398b81e3fadc92d11d91162d343c8836
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 14 May 2012 06:42:13 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  fefe1ed1398b81e3fadc92d11d91162d343c8836
Gitweb:     http://git.kernel.org/tip/fefe1ed1398b81e3fadc92d11d91162d343c8836
Author:     Dan Carpenter <dan.carpenter@oracle.com>
AuthorDate: Sun, 13 May 2012 20:09:38 +0300
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Mon, 14 May 2012 14:37:47 +0200

iommu: Fix off by one in dmar_get_fault_reason()

fault_reason - 0x20 == ARRAY_SIZE(irq_remap_fault_reasons) is
one past the end of the array.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Joerg Roedel <joerg.roedel@amd.com>
Cc: Youquan Song <youquan.song@intel.com>
Cc: walter harms <wharms@bfs.de>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: <stable@kernel.org>
Link: http://lkml.kernel.org/r/20120513170938.GA4280@elgon.mountain
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 drivers/iommu/dmar.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/iommu/dmar.c b/drivers/iommu/dmar.c
index 5ef65cf..3a74e44 100644
--- a/drivers/iommu/dmar.c
+++ b/drivers/iommu/dmar.c
@@ -1057,8 +1057,8 @@ static const char *irq_remap_fault_reasons[] =
 
 const char *dmar_get_fault_reason(u8 fault_reason, int *fault_type)
 {
-	if (fault_reason >= 0x20 && (fault_reason <= 0x20 +
-				     ARRAY_SIZE(irq_remap_fault_reasons))) {
+	if (fault_reason >= 0x20 && (fault_reason - 0x20 <
+					ARRAY_SIZE(irq_remap_fault_reasons))) {
 		*fault_type = INTR_REMAP;
 		return irq_remap_fault_reasons[fault_reason - 0x20];
 	} else if (fault_reason < ARRAY_SIZE(dma_remap_fault_reasons)) {
