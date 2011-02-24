Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756555Ab1BXUdv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 15:33:51 -0500
Received: from cantor.suse.de ([195.135.220.2]:59701 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756166Ab1BXUdt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 15:33:49 -0500
Message-ID: <4D66C094.4050800@suse.com>
Date: Thu, 24 Feb 2011 15:33:24 -0500
From: Jeff Mahoney <jeffm@suse.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101206 SUSE/3.1.7 Thunderbird/3.1.7
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: linux-ia64@vger.kernel.org, Tony Luck <tony.luck@intel.com>
Subject: [PATCH] tioca: Fix assignment from incompatible pointer warnings
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 The prototype for sn_pci_provider->{dma_map,dma_map_consistent} expects
 an unsigned long instead of a u64.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 arch/ia64/sn/pci/tioca_provider.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/ia64/sn/pci/tioca_provider.c
+++ b/arch/ia64/sn/pci/tioca_provider.c
@@ -509,7 +509,7 @@ tioca_dma_unmap(struct pci_dev *pdev, dm
  * use the GART mapped mode.
  */
 static u64
-tioca_dma_map(struct pci_dev *pdev, u64 paddr, size_t byte_count, int dma_flags)
+tioca_dma_map(struct pci_dev *pdev, unsigned long paddr, size_t byte_count, int dma_flags)
 {
 	u64 mapaddr;
 
-- 
Jeff Mahoney
SUSE Labs
