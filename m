Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754782Ab1GFSSi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 14:18:38 -0400
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:49244 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753218Ab1GFSSh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 14:18:37 -0400
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: v9fs-developer@lists.sourceforge.net, penberg@kernel.org,
        levinsasha928@gmail.com
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH] net/9p: Remove structure not used in the code
Date: Wed,  6 Jul 2011 23:48:20 +0530
Message-Id: <1309976300-6636-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We retain p9_twrite. It is used by tools/kvm/virtio/9p.c

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 include/net/9p/9p.h |  153 +--------------------------------------------------
 1 files changed, 1 insertions(+), 152 deletions(-)

diff --git a/include/net/9p/9p.h b/include/net/9p/9p.h
index fe1efa6..c3457a3 100644
--- a/include/net/9p/9p.h
+++ b/include/net/9p/9p.h
@@ -516,11 +516,6 @@ struct p9_getlock {
 	char *client_id;
 };
 
-/* Structures for Protocol Operations */
-struct p9_tstatfs {
-	u32 fid;
-};
-
 struct p9_rstatfs {
 	u32 type;
 	u32 bsize;
@@ -533,157 +528,11 @@ struct p9_rstatfs {
 	u32 namelen;
 };
 
-struct p9_trename {
-	u32 fid;
-	u32 newdirfid;
-	struct p9_str name;
-};
-
-struct p9_rrename {
-};
-
-struct p9_tversion {
-	u32 msize;
-	struct p9_str version;
-};
-
-struct p9_rversion {
-	u32 msize;
-	struct p9_str version;
-};
-
-struct p9_tauth {
-	u32 afid;
-	struct p9_str uname;
-	struct p9_str aname;
-	u32 n_uname;		/* 9P2000.u extensions */
-};
-
-struct p9_rauth {
-	struct p9_qid qid;
-};
-
-struct p9_rerror {
-	struct p9_str error;
-	u32 errno;		/* 9p2000.u extension */
-};
-
-struct p9_tflush {
-	u16 oldtag;
-};
-
-struct p9_rflush {
-};
-
-struct p9_tattach {
-	u32 fid;
-	u32 afid;
-	struct p9_str uname;
-	struct p9_str aname;
-	u32 n_uname;		/* 9P2000.u extensions */
-};
-
-struct p9_rattach {
-	struct p9_qid qid;
-};
-
-struct p9_twalk {
-	u32 fid;
-	u32 newfid;
-	u16 nwname;
-	struct p9_str wnames[16];
-};
-
-struct p9_rwalk {
-	u16 nwqid;
-	struct p9_qid wqids[16];
-};
-
-struct p9_topen {
-	u32 fid;
-	u8 mode;
-};
-
-struct p9_ropen {
-	struct p9_qid qid;
-	u32 iounit;
-};
-
-struct p9_tcreate {
-	u32 fid;
-	struct p9_str name;
-	u32 perm;
-	u8 mode;
-	struct p9_str extension;
-};
-
-struct p9_rcreate {
-	struct p9_qid qid;
-	u32 iounit;
-};
-
-struct p9_tread {
-	u32 fid;
-	u64 offset;
-	u32 count;
-};
-
-struct p9_rread {
-	u32 count;
-	u8 *data;
-};
-
 struct p9_twrite {
 	u32 fid;
 	u64 offset;
 	u32 count;
-	u8 *data;
-};
-
-struct p9_rwrite {
-	u32 count;
-};
-
-struct p9_treaddir {
-	u32 fid;
-	u64 offset;
-	u32 count;
-};
-
-struct p9_rreaddir {
-	u32 count;
-	u8 *data;
-};
-
-
-struct p9_tclunk {
-	u32 fid;
-};
-
-struct p9_rclunk {
-};
-
-struct p9_tremove {
-	u32 fid;
-};
-
-struct p9_rremove {
-};
-
-struct p9_tstat {
-	u32 fid;
-};
-
-struct p9_rstat {
-	struct p9_wstat stat;
-};
-
-struct p9_twstat {
-	u32 fid;
-	struct p9_wstat stat;
-};
-
-struct p9_rwstat {
+	u8 data[];
 };
 
 /**
-- 
1.7.4.1

