Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754508Ab2E1Drl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2012 23:47:41 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:52011 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753562Ab2E1D3Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2012 23:29:25 -0400
Message-Id: <20120528031206.629958289@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 28 May 2012 04:12:29 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Dan Carpenter <dan.carpenter@oracle.com>,
        Joerg Roedel <joerg.roedel@amd.com>,
        Youquan Song <youquan.song@intel.com>, walter harms <wharms@bfs.de>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Ingo Molnar <mingo@kernel.org>
Subject: [ 027/117] iommu: Fix off by one in dmar_get_fault_reason()
In-Reply-To: <20120528031202.829379252@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@oracle.com>

commit fefe1ed1398b81e3fadc92d11d91162d343c8836 upstream.

fault_reason - 0x20 == ARRAY_SIZE(irq_remap_fault_reasons) is
one past the end of the array.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Joerg Roedel <joerg.roedel@amd.com>
Cc: Youquan Song <youquan.song@intel.com>
Cc: walter harms <wharms@bfs.de>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>
Link: http://lkml.kernel.org/r/20120513170938.GA4280@elgon.mountain
Signed-off-by: Ingo Molnar <mingo@kernel.org>
[bwh: Backported to 3.2: s/irq_remap_fault_reasons/intr_remap_fault_reasons/]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/iommu/dmar.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- linux.orig/drivers/iommu/dmar.c
+++ linux/drivers/iommu/dmar.c
@@ -1056,8 +1056,8 @@
 
 const char *dmar_get_fault_reason(u8 fault_reason, int *fault_type)
 {
-	if (fault_reason >= 0x20 && (fault_reason <= 0x20 +
-				     ARRAY_SIZE(intr_remap_fault_reasons))) {
+	if (fault_reason >= 0x20 && (fault_reason - 0x20 <
+					ARRAY_SIZE(intr_remap_fault_reasons))) {
 		*fault_type = INTR_REMAP;
 		return intr_remap_fault_reasons[fault_reason - 0x20];
 	} else if (fault_reason < ARRAY_SIZE(dma_remap_fault_reasons)) {


