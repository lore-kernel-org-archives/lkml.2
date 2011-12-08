Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751872Ab1LHHpX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 02:45:23 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:36621 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751696Ab1LHHpW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 02:45:22 -0500
From: Kautuk Consul <consul.kautuk@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>, Joe Perches <joe@perches.com>,
        David Rientjes <rientjes@google.com>,
        Minchan Kim <minchan.kim@gmail.com>,
        David Vrabel <david.vrabel@citrix.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Kautuk Consul <consul.kautuk@gmail.com>
Subject: [PATCH 1/1] vmalloc: Remove static declaration of va from __get_vm_area_node
Date: Thu,  8 Dec 2011 13:20:21 +0530
Message-Id: <1323330621-31254-1-git-send-email-consul.kautuk@gmail.com>
X-Mailer: git-send-email 1.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Static storage is not required for the struct vmap_area in
__get_vm_area_node.

Removing "static" to store this variable on the stack instead.

Signed-off-by: Kautuk Consul <consul.kautuk@gmail.com>
---
 mm/vmalloc.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 3231bf3..173562c 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -1290,7 +1290,7 @@ static struct vm_struct *__get_vm_area_node(unsigned long size,
 		unsigned long align, unsigned long flags, unsigned long start,
 		unsigned long end, int node, gfp_t gfp_mask, void *caller)
 {
-	static struct vmap_area *va;
+	struct vmap_area *va;
 	struct vm_struct *area;
 
 	BUG_ON(in_interrupt());
-- 
1.7.6

