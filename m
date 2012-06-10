Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756509Ab2FJKvS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2012 06:51:18 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:59515 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755355Ab2FJKuO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2012 06:50:14 -0400
From: Sasha Levin <levinsasha928@gmail.com>
To: dan.magenheimer@oracle.com, konrad.wilk@oracle.com
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Sasha Levin <levinsasha928@gmail.com>
Subject: [PATCH v3 07/10] mm: frontswap: remove unnecessary check during initialization
Date: Sun, 10 Jun 2012 12:51:05 +0200
Message-Id: <1339325468-30614-8-git-send-email-levinsasha928@gmail.com>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1339325468-30614-1-git-send-email-levinsasha928@gmail.com>
References: <1339325468-30614-1-git-send-email-levinsasha928@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The check whether frontswap is enabled or not is done in the API functions in
the frontswap header, before they are passed to the internal
double-underscored frontswap functions.

Remove the check from __frontswap_init for consistency.

Signed-off-by: Sasha Levin <levinsasha928@gmail.com>
---
 mm/frontswap.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/mm/frontswap.c b/mm/frontswap.c
index d8dc986..7c26e89 100644
--- a/mm/frontswap.c
+++ b/mm/frontswap.c
@@ -110,8 +110,7 @@ void __frontswap_init(unsigned type)
 	BUG_ON(sis == NULL);
 	if (sis->frontswap_map == NULL)
 		return;
-	if (frontswap_enabled)
-		frontswap_ops.init(type);
+	frontswap_ops.init(type);
 }
 EXPORT_SYMBOL(__frontswap_init);
 
-- 
1.7.8.6

