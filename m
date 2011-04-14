Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933381Ab1DNR5I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 13:57:08 -0400
Received: from mail.windriver.com ([147.11.1.11]:38278 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933222Ab1DNRqk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 13:46:40 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Randy Dunlap <randy.dunlap@oracle.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 070/209] PCI: sysfs: fix printk warnings
Date: Thu, 14 Apr 2011 13:41:40 -0400
Message-Id: <1302803039-9400-71-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1302803039-9400-1-git-send-email-paul.gortmaker@windriver.com>
References: <1302803039-9400-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

  =====================================================================
  | This is a commit scheduled for the next v2.6.34 longterm release. |
  | If you see a problem with using this for longterm, please comment.|
  =====================================================================

commit e25cd062b16ed1d41a157aec5a108abd6ff2e9f9 upstream.

Cast pci_resource_start() and pci_resource_len() to u64 for printk.

drivers/pci/pci-sysfs.c:753: warning: format '%16Lx' expects type 'long long unsigned int', but argument 9 has type 'resource_size_t'
drivers/pci/pci-sysfs.c:753: warning: format '%16Lx' expects type 'long long unsigned int', but argument 10 has type 'resource_size_t'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/pci/pci-sysfs.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/pci/pci-sysfs.c b/drivers/pci/pci-sysfs.c
index e3efd79..627d067 100644
--- a/drivers/pci/pci-sysfs.c
+++ b/drivers/pci/pci-sysfs.c
@@ -741,7 +741,8 @@ pci_mmap_resource(struct kobject *kobj, struct bin_attribute *attr,
 			"at page 0x%08lx on %s BAR %d (start 0x%16Lx, size 0x%16Lx)\n",
 			current->comm, vma->vm_end-vma->vm_start, vma->vm_pgoff,
 			pci_name(pdev), i,
-			pci_resource_start(pdev, i), pci_resource_len(pdev, i));
+			(u64)pci_resource_start(pdev, i),
+			(u64)pci_resource_len(pdev, i));
 		return -EINVAL;
 	}
 
-- 
1.7.4.4

