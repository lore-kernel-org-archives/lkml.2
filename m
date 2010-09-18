Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757083Ab0IRTP4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Sep 2010 15:15:56 -0400
Received: from kroah.org ([198.145.64.141]:43703 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757066Ab0IRTPy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Sep 2010 15:15:54 -0400
X-Mailbox-Line: From gregkh@clark.site Sat Sep 18 12:13:04 2010
Message-Id: <20100918191304.882701867@clark.site>
User-Agent: quilt/0.48-11.2
Date: Sat, 18 Sep 2010 12:13:06 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jerome Marchand <jmarchan@redhat.com>
Subject: [088/129] kernel/groups.c: fix integer overflow in groups_search
In-Reply-To: <20100918191317.GA11386@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

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


