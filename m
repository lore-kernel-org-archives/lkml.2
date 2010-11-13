Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755959Ab0KMQpS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Nov 2010 11:45:18 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:33178 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754736Ab0KMQpP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Nov 2010 11:45:15 -0500
Date: Sat, 13 Nov 2010 08:44:33 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, linux-pci@vger.kernel.org,
        akpm <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: [PATCH -next] pci-sysfs: fix printk warnings
Message-Id: <20101113084433.67a92e8f.randy.dunlap@oracle.com>
In-Reply-To: <20101112130547.c2a3c2c1.sfr@canb.auug.org.au>
References: <20101112130547.c2a3c2c1.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Cast pci_resource_start() and pci_resource_len() to u64 for printk.

drivers/pci/pci-sysfs.c:753: warning: format '%16Lx' expects type 'long long unsigned int', but argument 9 has type 'resource_size_t'
drivers/pci/pci-sysfs.c:753: warning: format '%16Lx' expects type 'long long unsigned int', but argument 10 has type 'resource_size_t'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/pci/pci-sysfs.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- linux-next-20101112.orig/drivers/pci/pci-sysfs.c
+++ linux-next-20101112/drivers/pci/pci-sysfs.c
@@ -754,7 +754,8 @@ pci_mmap_resource(struct kobject *kobj, 
 			"at page 0x%08lx on %s BAR %d (start 0x%16Lx, size 0x%16Lx)\n",
 			current->comm, vma->vm_end-vma->vm_start, vma->vm_pgoff,
 			pci_name(pdev), i,
-			pci_resource_start(pdev, i), pci_resource_len(pdev, i));
+			(u64)pci_resource_start(pdev, i),
+			(u64)pci_resource_len(pdev, i));
 		return -EINVAL;
 	}
 
