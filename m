Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762651Ab2FVQPQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 12:15:16 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:20975 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755624Ab2FVQPH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 12:15:07 -0400
X-IronPort-AV: E=Sophos;i="4.77,459,1336363200"; 
   d="scan'208";a="199722605"
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
To: <linux-kernel@vger.kernel.org>
CC: <xen-devel@lists.xensource.com>, <Stefano.Stabellini@eu.citrix.com>,
        <Ian.Campbell@citrix.com>, <tim@xen.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: [PATCH WIP 1/6] xen/arm: fix the shared_info and vcpu_info structs
Date: Fri, 22 Jun 2012 17:14:40 +0100
Message-ID: <1340381685-22529-1-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <alpine.DEB.2.02.1206221644370.27860@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1206221644370.27860@kaball.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the shared_info and vcpu_info struct definitions to match the ones
in Xen.

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
---
 arch/arm/include/asm/xen/interface.h |   15 +++------------
 1 files changed, 3 insertions(+), 12 deletions(-)

diff --git a/arch/arm/include/asm/xen/interface.h b/arch/arm/include/asm/xen/interface.h
index 3ad2d4b..8ab7cebb 100644
--- a/arch/arm/include/asm/xen/interface.h
+++ b/arch/arm/include/asm/xen/interface.h
@@ -40,19 +40,10 @@ DEFINE_GUEST_HANDLE(xen_pfn_t);
 #endif
 
 /* Maximum number of virtual CPUs in multi-processor guests. */
-#define MAX_VIRT_CPUS 32
+#define MAX_VIRT_CPUS 1
 
-struct arch_vcpu_info {
-    unsigned long cr2;
-    unsigned long pad; /* sizeof(vcpu_info_t) == 64 */
-};
-
-struct arch_shared_info {
-    unsigned long max_pfn;                  /* max pfn that appears in table */
-    /* Frame containing list of mfns containing list of mfns containing p2m. */
-    unsigned long pfn_to_mfn_frame_list_list;
-    unsigned long nmi_reason;
-};
+struct arch_vcpu_info { };
+struct arch_shared_info { };
 
 /* XXX: Move pvclock definitions some place arch independent */
 struct pvclock_vcpu_time_info {
-- 
1.7.2.5

