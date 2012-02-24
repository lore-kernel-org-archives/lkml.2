Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756123Ab2BXLqf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 06:46:35 -0500
Received: from nat28.tlf.novell.com ([130.57.49.28]:60782 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751604Ab2BXLqe convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:4:1>);
	Fri, 24 Feb 2012 06:46:34 -0500
Message-Id: <4F4786A802000078000749FD@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Fri, 24 Feb 2012 11:46:32 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: "Jeremy Fitzhardinge" <jeremy@goop.org>,
        "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com>
Cc: "xen-devel" <xen-devel@lists.xen.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] xenbus: address compiler warnings
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- casting pointers to integer types of different size is being warned on
- an uninitialized variable warning occurred on certain gcc versions

Signed-off-by: Jan Beulich <jbeulich@suse.com>

---
 drivers/xen/xenbus/xenbus_client.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- 3.3-rc4/drivers/xen/xenbus/xenbus_client.c
+++ 3.3-rc4-xenbus-warnings/drivers/xen/xenbus/xenbus_client.c
@@ -569,7 +569,7 @@ int xenbus_map_ring(struct xenbus_device
 {
 	struct gnttab_map_grant_ref op;
 
-	gnttab_set_map_op(&op, (phys_addr_t)vaddr, GNTMAP_host_map, gnt_ref,
+	gnttab_set_map_op(&op, (unsigned long)vaddr, GNTMAP_host_map, gnt_ref,
 			  dev->otherend_id);
 
 	if (HYPERVISOR_grant_table_op(GNTTABOP_map_grant_ref, &op, 1))
@@ -662,7 +662,7 @@ static int xenbus_unmap_ring_vfree_hvm(s
 			goto found;
 		}
 	}
-	node = NULL;
+	node = addr = NULL;
  found:
 	spin_unlock(&xenbus_valloc_lock);
 
@@ -698,7 +698,7 @@ int xenbus_unmap_ring(struct xenbus_devi
 {
 	struct gnttab_unmap_grant_ref op;
 
-	gnttab_set_unmap_op(&op, (phys_addr_t)vaddr, GNTMAP_host_map, handle);
+	gnttab_set_unmap_op(&op, (unsigned long)vaddr, GNTMAP_host_map, handle);
 
 	if (HYPERVISOR_grant_table_op(GNTTABOP_unmap_grant_ref, &op, 1))
 		BUG();



