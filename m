Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934136Ab1FWSB5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 14:01:57 -0400
Received: from mail.windriver.com ([147.11.1.11]:34915 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933544Ab1FWRhY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 13:37:24 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, roel <roel.kluin@gmail.com>,
        "J. Bruce Fields" <bfields@redhat.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 163/247] nfsd: wrong index used in inner loop
Date: Thu, 23 Jun 2011 13:33:51 -0400
Message-Id: <1308850515-15242-104-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1308850515-15242-1-git-send-email-paul.gortmaker@windriver.com>
References: <1308849690-14530-1-git-send-email-paul.gortmaker@windriver.com>
 <1308850515-15242-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: roel <roel.kluin@gmail.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 3ec07aa9522e3d5e9d5ede7bef946756e623a0a0 upstream.

Index i was already used in the outer loop

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 fs/nfsd/nfs4xdr.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/nfsd/nfs4xdr.c b/fs/nfsd/nfs4xdr.c
index cb0a5fe..d2b44c8 100644
--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -1107,7 +1107,7 @@ nfsd4_decode_create_session(struct nfsd4_compoundargs *argp,
 
 	u32 dummy;
 	char *machine_name;
-	int i;
+	int i, j;
 	int nr_secflavs;
 
 	READ_BUF(16);
@@ -1180,7 +1180,7 @@ nfsd4_decode_create_session(struct nfsd4_compoundargs *argp,
 			READ_BUF(4);
 			READ32(dummy);
 			READ_BUF(dummy * 4);
-			for (i = 0; i < dummy; ++i)
+			for (j = 0; j < dummy; ++j)
 				READ32(dummy);
 			break;
 		case RPC_AUTH_GSS:
-- 
1.7.4.4

