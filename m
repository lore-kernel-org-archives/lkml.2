Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754901Ab0GITM2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 15:12:28 -0400
Received: from nlpi157.sbcis.sbc.com ([207.115.36.171]:34375 "EHLO
	nlpi157.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754771Ab0GITMY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 15:12:24 -0400
Message-Id: <20100709190853.770833931@quilx.com>
User-Agent: quilt/0.48-1
Date: Fri, 09 Jul 2010 14:07:13 -0500
From: Christoph Lameter <cl@linux-foundation.org>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: linux-mm@kvack.org, Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Roland Dreier <rdreier@cisco.com>
Cc: linux-kernel@vger.kernel.org
Cc: Nick Piggin <npiggin@suse.de>
Cc: David Rientjes <rientjes@google.com>
Subject: [S+Q2 07/19] slub: Allow removal of slab caches during boot
References: <20100709190706.938177313@quilx.com>
Content-Disposition: inline; filename=slub_sysfs_remove_during_boot
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If a slab cache is removed before we have setup sysfs then simply skip over
the sysfs handling.

Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Roland Dreier <rdreier@cisco.com>
Signed-off-by: Christoph Lameter <cl@linux-foundation.org>

---
 mm/slub.c |    7 +++++++
 1 file changed, 7 insertions(+)

Index: linux-2.6/mm/slub.c
===================================================================
--- linux-2.6.orig/mm/slub.c	2010-07-06 15:13:48.000000000 -0500
+++ linux-2.6/mm/slub.c	2010-07-06 15:15:27.000000000 -0500
@@ -4507,6 +4507,13 @@ static int sysfs_slab_add(struct kmem_ca
 
 static void sysfs_slab_remove(struct kmem_cache *s)
 {
+	if (slab_state < SYSFS)
+		/*
+		 * Sysfs has not been setup yet so no need to remove the
+		 * cache from sysfs.
+		 */
+		return;
+
 	kobject_uevent(&s->kobj, KOBJ_REMOVE);
 	kobject_del(&s->kobj);
 	kobject_put(&s->kobj);

