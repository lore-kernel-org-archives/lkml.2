Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756287Ab0GAOAb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 10:00:31 -0400
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:47987
	"EHLO VA3EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756060Ab0GAOAY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 10:00:24 -0400
X-SpamScore: 3
X-BigFish: VPS3(zza332jzz1202hzzz32i2a8h87h43h61h)
X-Spam-TCS-SCL: 0:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0L4VTKB-02-6BY-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 2/2] KVM: Use u64 for frame data types
Date: Thu, 1 Jul 2010 16:00:12 +0200
Message-ID: <1277992812-31945-3-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1277992812-31945-1-git-send-email-joerg.roedel@amd.com>
References: <1277992812-31945-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For 32bit machines where the physical address width is
larger than the virtual address width the frame number types
in KVM may overflow. Fix this by changing them to u64.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 include/linux/kvm_types.h |    4 ++--
 virt/kvm/iommu.c          |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/linux/kvm_types.h b/include/linux/kvm_types.h
index fb46efb..7ac0d4e 100644
--- a/include/linux/kvm_types.h
+++ b/include/linux/kvm_types.h
@@ -32,11 +32,11 @@
 
 typedef unsigned long  gva_t;
 typedef u64            gpa_t;
-typedef unsigned long  gfn_t;
+typedef u64            gfn_t;
 
 typedef unsigned long  hva_t;
 typedef u64            hpa_t;
-typedef unsigned long  hfn_t;
+typedef u64            hfn_t;
 
 typedef hfn_t pfn_t;
 
diff --git a/virt/kvm/iommu.c b/virt/kvm/iommu.c
index 673c88a..22fc28b 100644
--- a/virt/kvm/iommu.c
+++ b/virt/kvm/iommu.c
@@ -108,7 +108,7 @@ int kvm_iommu_map_pages(struct kvm *kvm, struct kvm_memory_slot *slot)
 			      get_order(page_size), flags);
 		if (r) {
 			printk(KERN_ERR "kvm_iommu_map_address:"
-			       "iommu failed to map pfn=%lx\n", pfn);
+			       "iommu failed to map pfn=%llx\n", pfn);
 			goto unmap_pages;
 		}
 
-- 
1.7.0.4


