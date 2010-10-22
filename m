Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759231Ab0JVS4C (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 14:56:02 -0400
Received: from kroah.org ([198.145.64.141]:33950 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755630Ab0JVSz6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 14:55:58 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Oct 22 11:52:28 2010
Message-Id: <20101022185228.579017521@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 22 Oct 2010 11:50:48 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Don Mullis <don.mullis@gmail.com>,
        Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Subject: [014/103] lib/list_sort: do not pass bad pointers to cmp callback
In-Reply-To: <20101022185455.GA9114@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Don Mullis <don.mullis@gmail.com>

commit f015ac3edd84ad72f88e08a4d83c56c360aae404 upstream.

If the original list is a POT in length, the first callback from line 73
will pass a==b both pointing to the original list_head.  This is dangerous
because the 'list_sort()' user can use 'container_of()' and accesses the
"containing" object, which does not necessary exist for the list head.  So
the user can access RAM which does not belong to him.  If this is a write
access, we can end up with memory corruption.

Signed-off-by: Don Mullis <don.mullis@gmail.com>
Tested-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 lib/list_sort.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/list_sort.c
+++ b/lib/list_sort.c
@@ -70,7 +70,7 @@ static void merge_and_restore_back_links
 		 * element comparison is needed, so the client's cmp()
 		 * routine can invoke cond_resched() periodically.
 		 */
-		(*cmp)(priv, tail, tail);
+		(*cmp)(priv, tail->next, tail->next);
 
 		tail->next->prev = tail;
 		tail = tail->next;


