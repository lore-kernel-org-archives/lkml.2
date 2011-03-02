Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751861Ab1CEJ14 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Mar 2011 04:27:56 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:50123 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751069Ab1CEJ1y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Mar 2011 04:27:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=C8IAEA3Q5pAxtIx+UixYe6OBm0nhi9LhqZco093mwCgEo59BtpE/c/sbdV5iVLdMRL
         AoA+wJaCwQ4Pp31E0pxgdIfq6S0gHighGAlwSw677qhsjoHTi5+WbrfszUzXHUNj5mhd
         VD0n9O61ODJ2nyyteZmR++Lo2P+dg6Km++p1g=
From: bookjovi@gmail.com
To: bookjovi@gmail.com
Cc: Trond Myklebust <Trond.Myklebust@netapp.com> (maintainer:NFS,
	SUNRPC, AND...),
        linux-nfs@vger.kernel.org (open list:NFS, SUNRPC, AND...),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] nfs: fix compilation warning
Date: Wed,  2 Mar 2011 18:19:37 -0500
Message-Id: <1299107978-3248-1-git-send-email-bookjovi@gmail.com>
X-Mailer: git-send-email 1.7.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jovi Zhang <bookjovi@gmail.com>

this commit fix compilation warning as following:
linux-2.6/fs/nfs/nfs4proc.c:3265: warning: comparison of distinct pointer types lacks a cast

Signed-off-by: Jovi Zhang <bookjovi@gmail.com>
---
 fs/nfs/nfs4proc.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
index 1ff76ac..c7eb4ee 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -3262,7 +3262,7 @@ static int buf_to_pages_noslab(const void *buf, size_t buflen,
 	spages = pages;
 
 	do {
-		len = min(PAGE_CACHE_SIZE, buflen);
+		len = min((size_t)PAGE_CACHE_SIZE, buflen);
 		newpage = alloc_page(GFP_KERNEL);
 
 		if (newpage == NULL)
-- 
1.7.2.3

