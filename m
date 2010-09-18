Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757872Ab0IRTw2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Sep 2010 15:52:28 -0400
Received: from kroah.org ([198.145.64.141]:51406 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755290Ab0IRTBn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Sep 2010 15:01:43 -0400
X-Mailbox-Line: From gregkh@clark.site Sat Sep 18 11:59:57 2010
Message-Id: <20100918185957.271072789@clark.site>
User-Agent: quilt/0.48-11.2
Date: Sat, 18 Sep 2010 11:58:16 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jerome Marchand <jmarchan@redhat.com>
Subject: [052/123] kernel/groups.c: fix integer overflow in groups_search
References: <20100918185724.290702750@clark.site>
Content-Disposition: inline; filename=kernel-groups.c-fix-integer-overflow-in-groups_search.patch
In-Reply-To: <20100918190024.GA14388@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jerome Marchand <jmarchan@redhat.com>

commit 1c24de60e50fb19b94d94225458da17c720f0729 upstream.

gid_t is a unsigned int.  If group_info contains a gid greater than
MAX_INT, groups_search() function may look on the wrong side of the search
tree.

This solves some unfair "permission denied" problems.

Signed-off-by: Jerome Marchand <jmarchan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/groups.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/kernel/groups.c
+++ b/kernel/groups.c
@@ -143,10 +143,9 @@ int groups_search(const struct group_inf
 	right = group_info->ngroups;
 	while (left < right) {
 		unsigned int mid = (left+right)/2;
-		int cmp = grp - GROUP_AT(group_info, mid);
-		if (cmp > 0)
+		if (grp > GROUP_AT(group_info, mid))
 			left = mid + 1;
-		else if (cmp < 0)
+		else if (grp < GROUP_AT(group_info, mid))
 			right = mid;
 		else
 			return 1;


