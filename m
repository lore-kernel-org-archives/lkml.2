Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755149Ab2G3Rdp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 13:33:45 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:60428 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755132Ab2G3Rdm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 13:33:42 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Hugh Dickins <hughd@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Minchan Kim <minchan@kernel.org>, Mel Gorman <mgorman@suse.de>
Subject: [ 35/41] mm: test PageSwapBacked in lumpy reclaim
Date: Mon, 30 Jul 2012 10:31:34 -0700
Message-Id: <20120730172904.049886840@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120730172901.306897424@linuxfoundation.org>
References: <20120730172901.306897424@linuxfoundation.org>
User-Agent: quilt/0.60-20.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hugh Dickins <hughd@google.com>

commit 043bcbe5ec51e0478ef2b44acef17193e01d7f70 upstream.

Stable note: Not tracked in Bugzilla. There were reports of shared
	mapped pages being unfairly reclaimed in comparison to older kernels.
	This is being addressed over time. Even though the subject
	refers to lumpy reclaim, it impacts compaction as well.

Lumpy reclaim does well to stop at a PageAnon when there's no swap, but
better is to stop at any PageSwapBacked, which includes shmem/tmpfs too.

Signed-off-by: Hugh Dickins <hughd@google.com>
Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Reviewed-by: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Mel Gorman <mgorman@suse.de>

---
 mm/vmscan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1199,7 +1199,7 @@ static unsigned long isolate_lru_pages(u
 			 * anon page which don't already have a swap slot is
 			 * pointless.
 			 */
-			if (nr_swap_pages <= 0 && PageAnon(cursor_page) &&
+			if (nr_swap_pages <= 0 && PageSwapBacked(cursor_page) &&
 			    !PageSwapCache(cursor_page))
 				break;
 


