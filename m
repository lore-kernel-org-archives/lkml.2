Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933288Ab2JWS0C (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 14:26:02 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:47655 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933259Ab2JWSYc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 14:24:32 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org,
        stefano.stabellini@eu.citrix.com, Ian.Campbell@citrix.com,
        mukesh.rathor@oracle.com
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 03/10] xen/hypercall: Make xen_remove_from_physmap the same on 64/32 builds.
Date: Tue, 23 Oct 2012 14:12:04 -0400
Message-Id: <1351015931-16991-4-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1351015931-16991-1-git-send-email-konrad.wilk@oracle.com>
References: <1351015931-16991-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

By making the structure exactly the same size and with the same
offsets on 64 and 32-bit builds we are future-proofing ourselves.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 include/xen/interface/memory.h |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/include/xen/interface/memory.h b/include/xen/interface/memory.h
index 8beebdb..6b07b54 100644
--- a/include/xen/interface/memory.h
+++ b/include/xen/interface/memory.h
@@ -253,9 +253,14 @@ extern spinlock_t xen_reservation_lock;
 struct xen_remove_from_physmap {
     /* Which domain to change the mapping for. */
     domid_t domid;
-
+   /* To be used in the future if need to. */
+    uint8_t reserved[6];
     /* GPFN of the current mapping of the page. */
     xen_pfn_t gpfn;
+#ifdef CONFIG_X86_32
+    /* No need to do that on ARM as xen_pfn_t is always 8 bytes. */
+    uint8_t __pad[4];
+#endif
 };
 DEFINE_GUEST_HANDLE_STRUCT(xen_remove_from_physmap);
 
-- 
1.7.7.6

