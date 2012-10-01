Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753194Ab2JAKM5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 06:12:57 -0400
Received: from caiajhbdcbbj.dreamhost.com ([208.97.132.119]:42470 "EHLO
	homiemail-a37.g.dreamhost.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753153Ab2JAKM4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 06:12:56 -0400
Message-ID: <1349086372.2721.1.camel@offbook>
Subject: [PATCH RESEND] PM/Hibernate: use rb_entry
From: Davidlohr Bueso <dave@gnu.org>
Reply-To: dave@gnu.org
To: Pavel Machek <pavel@ucw.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Len Brown <len.brown@intel.com>
Cc: linux-pm@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>
Date: Mon, 01 Oct 2012 12:12:52 +0200
Organization: GNU
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since the software suspend extents are organized in an rbtree, use rb_entry
instead of container_of, as it is semantically more appropriate in order to
get a node as it is iterated.

Signed-off-by: Davidlohr Bueso <dave@gnu.org>
---
 kernel/power/swap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/power/swap.c b/kernel/power/swap.c
index 3c9d764..7c33ed2 100644
--- a/kernel/power/swap.c
+++ b/kernel/power/swap.c
@@ -126,7 +126,7 @@ static int swsusp_extents_insert(unsigned long swap_offset)
 
 	/* Figure out where to put the new node */
 	while (*new) {
-		ext = container_of(*new, struct swsusp_extent, node);
+		ext = rb_entry(*new, struct swsusp_extent, node);
 		parent = *new;
 		if (swap_offset < ext->start) {
 			/* Try to merge */
-- 
1.7.9.5



