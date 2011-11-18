Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758162Ab1KRQXP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 11:23:15 -0500
Received: from mx1.redhat.com ([209.132.183.28]:13198 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757929Ab1KRQXO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 11:23:14 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Mel Gorman <mgorman@suse.de>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Christoph Lameter <cl@linux-foundation.org>,
        Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH v3 3/3] slub: min order when debug_guardpage_minorder > 0
Date: Fri, 18 Nov 2011 17:25:07 +0100
Message-Id: <1321633507-13614-3-git-send-email-sgruszka@redhat.com>
In-Reply-To: <1321633507-13614-1-git-send-email-sgruszka@redhat.com>
References: <1321633507-13614-1-git-send-email-sgruszka@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Disable slub debug facilities and allocate slabs at minimal order when
debug_guardpage_minorder > 0 to increase probability to catch random
memory corruption by cpu exception.

v1 -> v2:
  - use slub_max_order to minimalize slub order

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 mm/slub.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 7d2a996..a66be56 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -3645,6 +3645,9 @@ void __init kmem_cache_init(void)
 	struct kmem_cache *temp_kmem_cache_node;
 	unsigned long kmalloc_size;
 
+	if (debug_guardpage_minorder())
+		slub_max_order = 0;
+
 	kmem_size = offsetof(struct kmem_cache, node) +
 				nr_node_ids * sizeof(struct kmem_cache_node *);
 
-- 
1.7.1

