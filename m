Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756038Ab1COW4N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 18:56:13 -0400
Received: from shutemov.name ([188.40.19.243]:49807 "EHLO shutemov.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754648Ab1COWx3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 18:53:29 -0400
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: linux-kernel@vger.kernel.org
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>, Tejun Heo <tj@kernel.org>,
        linux-fbdev@vger.kernel.org
Subject: [PATCH 07/13] vmlfb: use list_move() instead of list_del()/list_add() combination
Date: Wed, 16 Mar 2011 00:53:19 +0200
Message-Id: <1300229605-14499-7-git-send-email-kirill@shutemov.name>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1300229605-14499-1-git-send-email-kirill@shutemov.name>
References: <1300229605-14499-1-git-send-email-kirill@shutemov.name>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Kirill A. Shutemov <kirill@shutemov.name>
Cc: Tejun Heo <tj@kernel.org>
Cc: linux-fbdev@vger.kernel.org
---
 drivers/video/vermilion/vermilion.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/video/vermilion/vermilion.c b/drivers/video/vermilion/vermilion.c
index 931a567..970e43d 100644
--- a/drivers/video/vermilion/vermilion.c
+++ b/drivers/video/vermilion/vermilion.c
@@ -891,8 +891,7 @@ static int vmlfb_set_par(struct fb_info *info)
 	int ret;
 
 	mutex_lock(&vml_mutex);
-	list_del(&vinfo->head);
-	list_add(&vinfo->head, (subsys) ? &global_has_mode : &global_no_mode);
+	list_move(&vinfo->head, (subsys) ? &global_has_mode : &global_no_mode);
 	ret = vmlfb_set_par_locked(vinfo);
 
 	mutex_unlock(&vml_mutex);
-- 
1.7.4.1

