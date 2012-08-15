Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756764Ab2HOTvI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 15:51:08 -0400
Received: from mail.windriver.com ([147.11.1.11]:36859 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756597Ab2HOTu4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 15:50:56 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: "J. Bruce Fields" <bfields@redhat.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 085/165] nfsd4: ignore WANT bits in open downgrade
Date: Wed, 15 Aug 2012 15:47:09 -0400
Message-ID: <1345060109-9187-86-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.12.rc2
In-Reply-To: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
References: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "J. Bruce Fields" <bfields@redhat.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit c30e92df30d7d5fe65262fbce5d1b7de675fe34e upstream.

We don't use WANT bits yet--and sending them can probably trigger a
BUG() further down.

Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 fs/nfsd/nfs4state.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
index 6a8feda..aa76339 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -3065,6 +3065,8 @@ nfsd4_open_downgrade(struct svc_rqst *rqstp,
 	if (!access_valid(od->od_share_access, cstate->minorversion)
 			|| !deny_valid(od->od_share_deny))
 		return nfserr_inval;
+	/* We don't yet support WANT bits: */
+	od->od_share_access &= NFS4_SHARE_ACCESS_MASK;
 
 	nfs4_lock_state();
 	if ((status = nfs4_preprocess_seqid_op(cstate,
-- 
1.7.12.rc2

