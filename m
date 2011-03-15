Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755983Ab1COWy0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 18:54:26 -0400
Received: from shutemov.name ([188.40.19.243]:49806 "EHLO shutemov.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754653Ab1COWx3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 18:53:29 -0400
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: linux-kernel@vger.kernel.org
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>,
        Tomi Valkeinen <tomi.valkeinen@nokia.com>, linux-fbdev@vger.kernel.org,
        linux-omap@vger.kernel.org
Subject: [PATCH 06/13] omap: use list_move() instead of list_del()/list_add() combination
Date: Wed, 16 Mar 2011 00:53:18 +0200
Message-Id: <1300229605-14499-6-git-send-email-kirill@shutemov.name>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1300229605-14499-1-git-send-email-kirill@shutemov.name>
References: <1300229605-14499-1-git-send-email-kirill@shutemov.name>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Kirill A. Shutemov <kirill@shutemov.name>
Cc: Tomi Valkeinen <tomi.valkeinen@nokia.com>
Cc: linux-fbdev@vger.kernel.org
Cc: linux-omap@vger.kernel.org
---
 drivers/video/omap/blizzard.c |    3 +--
 drivers/video/omap/hwa742.c   |    3 +--
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/video/omap/blizzard.c b/drivers/video/omap/blizzard.c
index 87785c2..c0504a8 100644
--- a/drivers/video/omap/blizzard.c
+++ b/drivers/video/omap/blizzard.c
@@ -397,8 +397,7 @@ static inline void free_req(struct blizzard_request *req)
 
 	spin_lock_irqsave(&blizzard.req_lock, flags);
 
-	list_del(&req->entry);
-	list_add(&req->entry, &blizzard.free_req_list);
+	list_move(&req->entry, &blizzard.free_req_list);
 	if (!(req->flags & REQ_FROM_IRQ_POOL))
 		up(&blizzard.req_sema);
 
diff --git a/drivers/video/omap/hwa742.c b/drivers/video/omap/hwa742.c
index 0016f77..084aa0a 100644
--- a/drivers/video/omap/hwa742.c
+++ b/drivers/video/omap/hwa742.c
@@ -269,8 +269,7 @@ static inline void free_req(struct hwa742_request *req)
 
 	spin_lock_irqsave(&hwa742.req_lock, flags);
 
-	list_del(&req->entry);
-	list_add(&req->entry, &hwa742.free_req_list);
+	list_move(&req->entry, &hwa742.free_req_list);
 	if (!(req->flags & REQ_FROM_IRQ_POOL))
 		up(&hwa742.req_sema);
 
-- 
1.7.4.1

