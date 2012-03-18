Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756937Ab2CRXyu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Mar 2012 19:54:50 -0400
Received: from caiajhbdccah.dreamhost.com ([208.97.132.207]:40833 "EHLO
	homiemail-a2.g.dreamhost.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755210Ab2CRXyt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Mar 2012 19:54:49 -0400
Subject: [PATCH] PM/Hibernate: use rb_entry
From: Davidlohr Bueso <dave@gnu.org>
Reply-To: dave@gnu.org
To: Pavel Machek <pavel@ucw.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: lkml <linux-kernel@vger.kernel.org>, linux-pm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Organization: GNU
Date: Mon, 19 Mar 2012 00:54:45 +0100
Message-ID: <1332114885.2632.1.camel@offbook>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Davidlohr Bueso <dave@gnu.org>

Since the software suspend extents are organized in an rbtree, use rb_entry
instead of container_of, as it is semantically more appropriate in order to
get a node as it is iterated.

Signed-off-by: Davidlohr Bueso <dave@gnu.org>
---
 kernel/power/swap.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/power/swap.c b/kernel/power/swap.c
index 8742fd0..1529b83 100644
--- a/kernel/power/swap.c
+++ b/kernel/power/swap.c
@@ -109,7 +109,7 @@ static int swsusp_extents_insert(unsigned long swap_offset)
 
 	/* Figure out where to put the new node */
 	while (*new) {
-		ext = container_of(*new, struct swsusp_extent, node);
+		ext = rb_entry(*new, struct swsusp_extent, node);
 		parent = *new;
 		if (swap_offset < ext->start) {
 			/* Try to merge */
@@ -175,7 +175,7 @@ void free_all_swap_pages(int swap)
 		struct swsusp_extent *ext;
 		unsigned long offset;
 
-		ext = container_of(node, struct swsusp_extent, node);
+		ext = rb_entry(node, struct swsusp_extent, node);
 		rb_erase(node, &swsusp_extents);
 		for (offset = ext->start; offset <= ext->end; offset++)
 			swap_free(swp_entry(swap, offset));
-- 
1.7.4.1



