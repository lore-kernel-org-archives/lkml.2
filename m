Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754468Ab0CVNHf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 09:07:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54855 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753417Ab0CVNHe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 09:07:34 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] AFS: Potential null dereference
To: torvalds@osdl.org, akpm@linux-foundation.org
Cc: kernel-janitors@vger.kernel.org, linux-afs@lists.infradead.org,
       linux-kernel@vger.kernel.org, Dan Carpenter <error27@gmail.com>,
       David Howells <dhowells@redhat.com>
Date: Mon, 22 Mar 2010 13:07:14 +0000
Message-ID: <20100322130713.12914.76901.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dan Carpenter <error27@gmail.com>

It seems clear from the surrounding code that xpermits is allowed to be NULL
here.

Signed-off-by: Dan Carpenter <error27@gmail.com>
Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/afs/security.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/afs/security.c b/fs/afs/security.c
index 3ef5043..bb4ed14 100644
--- a/fs/afs/security.c
+++ b/fs/afs/security.c
@@ -189,8 +189,9 @@ void afs_cache_permit(struct afs_vnode *vnode, struct key *key, long acl_order)
 	if (!permits)
 		goto out_unlock;
 
-	memcpy(permits->permits, xpermits->permits,
-	       count * sizeof(struct afs_permit));
+	if (xpermits)
+		memcpy(permits->permits, xpermits->permits,
+			count * sizeof(struct afs_permit));
 
 	_debug("key %x access %x",
 	       key_serial(key), vnode->status.caller_access);

