Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753161Ab2KSF3p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 00:29:45 -0500
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:59039 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752868Ab2KSF3n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 00:29:43 -0500
X-Originating-IP: 217.70.178.144
X-Originating-IP: 50.43.39.152
From: Josh Triplett <josh@joshtriplett.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        "David S. Miller" <davem@davemloft.net>, Tejun Heo <tj@kernel.org>,
        Gavin Shan <shangw@linux.vnet.ibm.com>,
        Yinghai Lu <yinghai@kernel.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Cc: Josh Triplett <josh@joshtriplett.org>
Subject: [PATCH 18/58] mm: bootmem: Declare internal ___alloc_bootmem_node function static
Date: Sun, 18 Nov 2012 21:27:57 -0800
Message-Id: <1353302917-13995-19-git-send-email-josh@joshtriplett.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1353302917-13995-1-git-send-email-josh@joshtriplett.org>
References: <1353302917-13995-1-git-send-email-josh@joshtriplett.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Both mm/bootmem.c and mm/nobootmem.c define an internal function
___alloc_bootmem_node.  Nothing outside of those source files references
that function, so declare it static in both cases.

Signed-off-by: Josh Triplett <josh@joshtriplett.org>
---
 mm/bootmem.c   |    8 +++++---
 mm/nobootmem.c |    8 +++++---
 2 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/mm/bootmem.c b/mm/bootmem.c
index 434be4a..93eb8bd 100644
--- a/mm/bootmem.c
+++ b/mm/bootmem.c
@@ -747,9 +747,11 @@ void * __init __alloc_bootmem_node_nopanic(pg_data_t *pgdat, unsigned long size,
 	return ___alloc_bootmem_node_nopanic(pgdat, size, align, goal, 0);
 }
 
-void * __init ___alloc_bootmem_node(pg_data_t *pgdat, unsigned long size,
-				    unsigned long align, unsigned long goal,
-				    unsigned long limit)
+static void * __init ___alloc_bootmem_node(pg_data_t *pgdat,
+					   unsigned long size,
+					   unsigned long align,
+					   unsigned long goal,
+					   unsigned long limit)
 {
 	void *ptr;
 
diff --git a/mm/nobootmem.c b/mm/nobootmem.c
index 714d5d6..c4e22a1 100644
--- a/mm/nobootmem.c
+++ b/mm/nobootmem.c
@@ -319,9 +319,11 @@ void * __init __alloc_bootmem_node_nopanic(pg_data_t *pgdat, unsigned long size,
 	return ___alloc_bootmem_node_nopanic(pgdat, size, align, goal, 0);
 }
 
-void * __init ___alloc_bootmem_node(pg_data_t *pgdat, unsigned long size,
-				    unsigned long align, unsigned long goal,
-				    unsigned long limit)
+static void * __init ___alloc_bootmem_node(pg_data_t *pgdat,
+					   unsigned long size,
+					   unsigned long align,
+					   unsigned long goal,
+					   unsigned long limit)
 {
 	void *ptr;
 
-- 
1.7.10.4

