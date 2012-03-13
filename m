Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759020Ab2CMAYE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 20:24:04 -0400
Received: from mail.windriver.com ([147.11.1.11]:48398 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964856Ab2CMAX5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 20:23:57 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Jovi Zhang <bookjovi@gmail.com>,
        Trond Myklebust <Trond.Myklebust@netapp.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 126/196] nfs: fix compilation warning
Date: Mon, 12 Mar 2012 20:20:39 -0400
Message-Id: <1331598109-31424-81-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.3
In-Reply-To: <1331598109-31424-1-git-send-email-paul.gortmaker@windriver.com>
References: <1331597724-31358-1-git-send-email-paul.gortmaker@windriver.com>
 <1331598109-31424-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jovi Zhang <bookjovi@gmail.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 43b7c3f051dea504afccc39bcb56d8e26c2e0b77 upstream.

this commit fix compilation warning as following:
linux-2.6/fs/nfs/nfs4proc.c:3265: warning: comparison of distinct pointer types lacks a cast

Signed-off-by: Jovi Zhang <bookjovi@gmail.com>
Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 fs/nfs/nfs4proc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
index 5b33856..8dd3309 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -3251,7 +3251,7 @@ static int buf_to_pages_noslab(const void *buf, size_t buflen,
 	spages = pages;
 
 	do {
-		len = min(PAGE_CACHE_SIZE, buflen);
+		len = min_t(size_t, PAGE_CACHE_SIZE, buflen);
 		newpage = alloc_page(GFP_KERNEL);
 
 		if (newpage == NULL)
-- 
1.7.9.3

