Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754702Ab2ECGl3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 02:41:29 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:62341 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754492Ab2ECGlP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 02:41:15 -0400
X-AuditID: 9c930197-b7badae000000cfd-4a-4fa2288ab295
From: Minchan Kim <minchan@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Nitin Gupta <ngupta@vflare.org>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Minchan Kim <minchan@kernel.org>
Subject: [PATCH 4/4] zsmalloc: zsmalloc: align cache line size
Date: Thu,  3 May 2012 15:40:42 +0900
Message-Id: <1336027242-372-4-git-send-email-minchan@kernel.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1336027242-372-1-git-send-email-minchan@kernel.org>
References: <1336027242-372-1-git-send-email-minchan@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's a overkill to align pool size with PAGE_SIZE to avoid
false-sharing. This patch aligns it with just cache line size.

Signed-off-by: Minchan Kim <minchan@kernel.org>
---
 drivers/staging/zsmalloc/zsmalloc-main.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/zsmalloc/zsmalloc-main.c b/drivers/staging/zsmalloc/zsmalloc-main.c
index 51074fa..3991b03 100644
--- a/drivers/staging/zsmalloc/zsmalloc-main.c
+++ b/drivers/staging/zsmalloc/zsmalloc-main.c
@@ -489,14 +489,14 @@ fail:
 
 struct zs_pool *zs_create_pool(const char *name, gfp_t flags)
 {
-	int i, error, ovhd_size;
+	int i, error;
 	struct zs_pool *pool;
 
 	if (!name)
 		return NULL;
 
-	ovhd_size = roundup(sizeof(*pool), PAGE_SIZE);
-	pool = kzalloc(ovhd_size, GFP_KERNEL);
+	pool = kzalloc(ALIGN(sizeof(*pool), cache_line_size()),
+				GFP_KERNEL);
 	if (!pool)
 		return NULL;
 
-- 
1.7.9.5

