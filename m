Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755805Ab2BUTLE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 14:11:04 -0500
Received: from mx1.redhat.com ([209.132.183.28]:61323 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753366Ab2BUTLB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 14:11:01 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 38/73] union-mount: Prevent bind mounts of union mounts [ver
 #2]
To: linux-fsdevel@vger.kernel.org, viro@ZenIV.linux.org.uk,
        valerie.aurora@gmail.com
Cc: linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>
Date: Tue, 21 Feb 2012 18:02:16 +0000
Message-ID: <20120221180216.25235.27806.stgit@warthog.procyon.org.uk>
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

Prevent bind mounts of parts of union mounts.

XXX - Bind mounting parts of union mounts is probably easy to
implement, but requires some careful thought about corner cases,
extensive testing, and some refactoring of the code.

Original-author: Valerie Aurora <vaurora@redhat.com>
Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/namespace.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/fs/namespace.c b/fs/namespace.c
index 3c950fa..c990f69 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -1845,6 +1845,12 @@ static int do_loopback(struct path *path, char *old_name,
 	if (IS_MNT_UNBINDABLE(old))
 		goto out2;
 
+	/* XXX - Mounting a subtree of a union mount elsewhere requires careful
+	 * thought and some refactoring.
+	 */
+	if (IS_MNT_UNION(old_path.mnt))
+		goto out2;
+
 	if (!check_mnt(real_mount(path->mnt)) || !check_mnt(old))
 		goto out2;
 

