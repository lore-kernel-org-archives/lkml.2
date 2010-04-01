Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754797Ab0DAJbP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 05:31:15 -0400
Received: from mga09.intel.com ([134.134.136.24]:24545 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754786Ab0DAJbE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 05:31:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.51,347,1267430400"; 
   d="scan'208";a="505485374"
Subject: [PATCH]slub: fix bad scope checking
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Pekka Enberg <penberg@cs.helsinki.fi>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Thu, 01 Apr 2010 17:32:30 +0800
Message-Id: <1270114350.2078.111.camel@ymzhang.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 (2.28.0-2.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Function init_kmem_cache_nodes is incorrect when checking upper limitation
of kmalloc_caches.

The patch against latest tip/master fixes it.

From: Zhang, Yanmin <yanmin_zhang@linux.intel.com>

---

--- linux-2.6/mm/slub.c	2010-04-01 17:01:21.091999999 +0800
+++ linux-2.6_slub/mm/slub.c	2010-04-01 17:04:34.876000010 +0800
@@ -2153,7 +2153,7 @@ static int init_kmem_cache_nodes(struct 
 	int local_node;
 
 	if (slab_state >= UP && (s < kmalloc_caches ||
-			s > kmalloc_caches + KMALLOC_CACHES))
+			s >= kmalloc_caches + KMALLOC_CACHES))
 		local_node = page_to_nid(virt_to_page(s));
 	else
 		local_node = 0;


