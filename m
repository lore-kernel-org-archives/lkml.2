Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758566Ab2CMAWW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 20:22:22 -0400
Received: from mail.windriver.com ([147.11.1.11]:47609 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758498Ab2CMAWU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 20:22:20 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Jeff Mahoney <jeffm@suse.com>,
        Tony Luck <tony.luck@intel.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 060/196] tioca: Fix assignment from incompatible pointer warnings
Date: Mon, 12 Mar 2012 20:19:33 -0400
Message-Id: <1331598109-31424-15-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.3
In-Reply-To: <1331598109-31424-1-git-send-email-paul.gortmaker@windriver.com>
References: <1331597724-31358-1-git-send-email-paul.gortmaker@windriver.com>
 <1331598109-31424-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeff Mahoney <jeffm@suse.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit b4a6b3436531f6c5256e6d60d388c3c28ff1a0e9 upstream.

The prototype for sn_pci_provider->{dma_map,dma_map_consistent} expects
an unsigned long instead of a u64.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
Signed-off-by: Tony Luck <tony.luck@intel.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 arch/ia64/sn/pci/tioca_provider.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/ia64/sn/pci/tioca_provider.c b/arch/ia64/sn/pci/tioca_provider.c
index 4d4536e..9c271be 100644
--- a/arch/ia64/sn/pci/tioca_provider.c
+++ b/arch/ia64/sn/pci/tioca_provider.c
@@ -509,7 +509,7 @@ tioca_dma_unmap(struct pci_dev *pdev, dma_addr_t bus_addr, int dir)
  * use the GART mapped mode.
  */
 static u64
-tioca_dma_map(struct pci_dev *pdev, u64 paddr, size_t byte_count, int dma_flags)
+tioca_dma_map(struct pci_dev *pdev, unsigned long paddr, size_t byte_count, int dma_flags)
 {
 	u64 mapaddr;
 
-- 
1.7.9.3

