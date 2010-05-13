Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932913Ab0EMUHl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 16:07:41 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:40590 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932514Ab0EMUHe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 16:07:34 -0400
Date: Thu, 13 May 2010 22:07:29 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: Sage Weil <sage@newdream.net>, ceph-devel@vger.kernel.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 19/20] fs/ceph: Use kzalloc
Message-ID: <Pine.LNX.4.64.1005132207120.6282@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Use kzalloc rather than the combination of kmalloc and memset.

The semantic patch that makes this change is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
expression x,size,flags;
statement S;
@@

-x = kmalloc(size,flags);
+x = kzalloc(size,flags);
 if (x == NULL) S
-memset(x, 0, size);
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 fs/ceph/mon_client.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -u -p a/fs/ceph/mon_client.c b/fs/ceph/mon_client.c
--- a/fs/ceph/mon_client.c
+++ b/fs/ceph/mon_client.c
@@ -481,11 +481,10 @@ int ceph_monc_do_statfs(struct ceph_mon_
 	struct ceph_mon_statfs *h;
 	int err;
 
-	req = kmalloc(sizeof(*req), GFP_NOFS);
+	req = kzalloc(sizeof(*req), GFP_NOFS);
 	if (!req)
 		return -ENOMEM;
 
-	memset(req, 0, sizeof(*req));
 	kref_init(&req->kref);
 	req->buf = buf;
 	init_completion(&req->completion);
