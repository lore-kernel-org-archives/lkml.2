Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934012Ab2E0Bg5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2012 21:36:57 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:36809 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756415Ab2E0BNZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2012 21:13:25 -0400
Message-Id: <20120527010436.165554954@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Sun, 27 May 2012 10:05:51 +0900
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Dan Carpenter <dan.carpenter@oracle.com>,
        Joerg Roedel <joerg.roedel@amd.com>,
        Youquan Song <youquan.song@intel.com>, walter harms <wharms@bfs.de>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Ingo Molnar <mingo@kernel.org>, Ben Hutchings <ben@decadent.org.uk>
Subject: [ 88/94] iommu: Fix off by one in dmar_get_fault_reason()
In-Reply-To: <20120527010332.GA11170@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iommu/dmar.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/iommu/dmar.c
+++ b/drivers/iommu/dmar.c
@@ -1056,8 +1056,8 @@ static const char *intr_remap_fault_reas
 
 const char *dmar_get_fault_reason(u8 fault_reason, int *fault_type)
 {
-	if (fault_reason >= 0x20 && (fault_reason <= 0x20 +
-				     ARRAY_SIZE(intr_remap_fault_reasons))) {
+	if (fault_reason >= 0x20 && (fault_reason - 0x20 <
+					ARRAY_SIZE(intr_remap_fault_reasons))) {
 		*fault_type = INTR_REMAP;
 		return intr_remap_fault_reasons[fault_reason - 0x20];
 	} else if (fault_reason < ARRAY_SIZE(dma_remap_fault_reasons)) {


