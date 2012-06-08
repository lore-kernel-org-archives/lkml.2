Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933298Ab2FHTPG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 15:15:06 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:62667 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933198Ab2FHTO5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 15:14:57 -0400
From: Sasha Levin <levinsasha928@gmail.com>
To: dan.magenheimer@oracle.com, konrad.wilk@oracle.com
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Sasha Levin <levinsasha928@gmail.com>
Subject: [PATCH v2 07/10] mm: frontswap: remove unnecessary check during initialization
Date: Fri,  8 Jun 2012 21:15:16 +0200
Message-Id: <1339182919-11432-8-git-send-email-levinsasha928@gmail.com>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1339182919-11432-1-git-send-email-levinsasha928@gmail.com>
References: <1339182919-11432-1-git-send-email-levinsasha928@gmail.com>
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
index ee1763d..0319fc5 100644
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

