Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754929Ab2BUTxy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 14:53:54 -0500
Received: from mx1.redhat.com ([209.132.183.28]:5038 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753299Ab2BUTxv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 14:53:51 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 46/73] union-mount: Follow mount in __lookup_union() [ver #2]
To: linux-fsdevel@vger.kernel.org, viro@ZenIV.linux.org.uk,
        valerie.aurora@gmail.com
Cc: linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>
Date: Tue, 21 Feb 2012 18:03:15 +0000
Message-ID: <20120221180315.25235.54661.stgit@warthog.procyon.org.uk>
In-Reply-To: <20120221175721.25235.8901.stgit@warthog.procyon.org.uk>
References: <20120221175721.25235.8901.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Valerie Aurora <vaurora@redhat.com>

In order for read-only layers of a union to have submounts, we have to
follow mounts on directories in union lookup.

Original-author: Valerie Aurora <vaurora@redhat.com>
Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/namei.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index 3ac07be..37e32b4 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -1195,6 +1195,8 @@ static int __lookup_union(struct nameidata *nd, struct qstr *name,
 		 * layer's directory to the union stack for the topmost
 		 * directory.
 		 */
+		follow_mount(&lower);
+
 		if (!topmost->dentry->d_inode) {
 			err = union_create_topmost_dir(&parent, name, topmost,
 						       &lower);

