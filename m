Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932730Ab2EDUsE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 16:48:04 -0400
Received: from mail-pz0-f45.google.com ([209.85.210.45]:45099 "EHLO
	mail-pz0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932700Ab2EDUr7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 16:47:59 -0400
Message-Id: <20120504204245.028324509@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 04 May 2012 13:42:46 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [ 02/47] NFSv4: Ensure that the LOCK code sets exception->inode
In-Reply-To: <20120504204307.GA13761@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Trond Myklebust <Trond.Myklebust@netapp.com>

commit 05ffe24f5290dc095f98fbaf84afe51ef404ccc5 upstream.

All callers of nfs4_handle_exception() that need to handle
NFS4ERR_OPENMODE correctly should set exception->inode

Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/nfs/nfs4proc.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -4424,7 +4424,9 @@ static int _nfs4_do_setlk(struct nfs4_st
 static int nfs4_lock_reclaim(struct nfs4_state *state, struct file_lock *request)
 {
 	struct nfs_server *server = NFS_SERVER(state->inode);
-	struct nfs4_exception exception = { };
+	struct nfs4_exception exception = {
+		.inode = state->inode,
+	};
 	int err;
 
 	do {
@@ -4442,7 +4444,9 @@ static int nfs4_lock_reclaim(struct nfs4
 static int nfs4_lock_expired(struct nfs4_state *state, struct file_lock *request)
 {
 	struct nfs_server *server = NFS_SERVER(state->inode);
-	struct nfs4_exception exception = { };
+	struct nfs4_exception exception = {
+		.inode = state->inode,
+	};
 	int err;
 
 	err = nfs4_set_lock_state(state, request);
@@ -4508,6 +4512,7 @@ static int nfs4_proc_setlk(struct nfs4_s
 {
 	struct nfs4_exception exception = {
 		.state = state,
+		.inode = state->inode,
 	};
 	int err;
 


