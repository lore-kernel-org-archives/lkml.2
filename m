Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756069Ab1CAIv7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 03:51:59 -0500
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:58627 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756043Ab1CAIv5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 03:51:57 -0500
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: v9fs-developer@lists.sourceforge.net
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH 6/6] net/9p: Fix compile warning
Date: Tue,  1 Mar 2011 14:21:24 +0530
Message-Id: <1298969484-16199-6-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1298969484-16199-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1298969484-16199-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 net/9p/trans_common.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/9p/trans_common.c b/net/9p/trans_common.c
index d62b9aa..ca55e3b 100644
--- a/net/9p/trans_common.c
+++ b/net/9p/trans_common.c
@@ -42,8 +42,8 @@ int
 p9_nr_pages(struct p9_req_t *req)
 {
 	int start_page, end_page;
-	start_page =  (unsigned long long)req->tc->pubuf >> PAGE_SHIFT;
-	end_page = ((unsigned long long)req->tc->pubuf + req->tc->pbuf_size +
+	start_page =  (unsigned long)req->tc->pubuf >> PAGE_SHIFT;
+	end_page = ((unsigned long)req->tc->pubuf + req->tc->pbuf_size +
 			PAGE_SIZE - 1) >> PAGE_SHIFT;
 	return end_page - start_page;
 }
@@ -69,8 +69,8 @@ p9_payload_gup(struct p9_req_t *req, size_t *pdata_off, int *pdata_len,
 	*pdata_off = (size_t)req->tc->pubuf & (PAGE_SIZE-1);
 
 	if (*pdata_off)
-		first_page_bytes = min((PAGE_SIZE - *pdata_off),
-				req->tc->pbuf_size);
+		first_page_bytes = min(((size_t)PAGE_SIZE - *pdata_off),
+				       req->tc->pbuf_size);
 
 	rpinfo = req->tc->private;
 	pdata_mapped_pages = get_user_pages_fast((unsigned long)req->tc->pubuf,
-- 
1.7.1

