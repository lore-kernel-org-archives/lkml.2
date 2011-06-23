Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933596Ab1FWSBw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 14:01:52 -0400
Received: from mail.windriver.com ([147.11.1.11]:34924 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933413Ab1FWRhZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 13:37:25 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Mi Jinlong <mijinlong@cn.fujitsu.com>,
        "J. Bruce Fields" <bfields@redhat.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 164/247] nfsd: wrong index used in inner loop
Date: Thu, 23 Jun 2011 13:33:52 -0400
Message-Id: <1308850515-15242-105-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1308850515-15242-1-git-send-email-paul.gortmaker@windriver.com>
References: <1308849690-14530-1-git-send-email-paul.gortmaker@windriver.com>
 <1308850515-15242-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mi Jinlong <mijinlong@cn.fujitsu.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 5a02ab7c3c4580f94d13c683721039855b67cda6 upstream.

We must not use dummy for index.
After the first index, READ32(dummy) will change dummy!!!!

Signed-off-by: Mi Jinlong <mijinlong@cn.fujitsu.com>
[bfields@redhat.com: Trond points out READ_BUF alone is sufficient.]
Signed-off-by: J. Bruce Fields <bfields@redhat.com>

Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 fs/nfsd/nfs4xdr.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/fs/nfsd/nfs4xdr.c b/fs/nfsd/nfs4xdr.c
index d2b44c8..28d586a 100644
--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -1107,7 +1107,7 @@ nfsd4_decode_create_session(struct nfsd4_compoundargs *argp,
 
 	u32 dummy;
 	char *machine_name;
-	int i, j;
+	int i;
 	int nr_secflavs;
 
 	READ_BUF(16);
@@ -1180,8 +1180,6 @@ nfsd4_decode_create_session(struct nfsd4_compoundargs *argp,
 			READ_BUF(4);
 			READ32(dummy);
 			READ_BUF(dummy * 4);
-			for (j = 0; j < dummy; ++j)
-				READ32(dummy);
 			break;
 		case RPC_AUTH_GSS:
 			dprintk("RPC_AUTH_GSS callback secflavor "
@@ -1197,7 +1195,6 @@ nfsd4_decode_create_session(struct nfsd4_compoundargs *argp,
 			READ_BUF(4);
 			READ32(dummy);
 			READ_BUF(dummy);
-			p += XDR_QUADLEN(dummy);
 			break;
 		default:
 			dprintk("Illegal callback secflavor\n");
-- 
1.7.4.4

