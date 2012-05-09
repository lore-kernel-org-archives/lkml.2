Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757667Ab2EIGAi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 02:00:38 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:38958 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756488Ab2EIFxp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 01:53:45 -0400
Message-Id: <20120509055042.096442453@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Wed, 09 May 2012 06:51:58 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [ 089/167] [PATCH] NFSv4: Ensure that the LOCK code sets exception->inode
In-Reply-To: <20120509055029.588587017@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Trond Myklebust <Trond.Myklebust@netapp.com>

commit 05ffe24f5290dc095f98fbaf84afe51ef404ccc5 upstream.

All callers of nfs4_handle_exception() that need to handle
NFS4ERR_OPENMODE correctly should set exception->inode

Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/nfs/nfs4proc.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
index f82bde0..3c787d0 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -4558,7 +4558,9 @@ static int _nfs4_do_setlk(struct nfs4_state *state, int cmd, struct file_lock *f
 static int nfs4_lock_reclaim(struct nfs4_state *state, struct file_lock *request)
 {
 	struct nfs_server *server = NFS_SERVER(state->inode);
-	struct nfs4_exception exception = { };
+	struct nfs4_exception exception = {
+		.inode = state->inode,
+	};
 	int err;
 
 	do {
@@ -4576,7 +4578,9 @@ static int nfs4_lock_reclaim(struct nfs4_state *state, struct file_lock *request
 static int nfs4_lock_expired(struct nfs4_state *state, struct file_lock *request)
 {
 	struct nfs_server *server = NFS_SERVER(state->inode);
-	struct nfs4_exception exception = { };
+	struct nfs4_exception exception = {
+		.inode = state->inode,
+	};
 	int err;
 
 	err = nfs4_set_lock_state(state, request);
@@ -4676,6 +4680,7 @@ static int nfs4_proc_setlk(struct nfs4_state *state, int cmd, struct file_lock *
 {
 	struct nfs4_exception exception = {
 		.state = state,
+		.inode = state->inode,
 	};
 	int err;
 
-- 
1.7.10



