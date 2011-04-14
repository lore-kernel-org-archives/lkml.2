Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757274Ab1DNGdv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 02:33:51 -0400
Received: from ebb06.tieto.com ([131.207.168.38]:48096 "EHLO ebb06.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752800Ab1DNGdu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 02:33:50 -0400
X-AuditID: 83cfa826-b7c64ae000004fc2-5e-4da6954c626d
Date: Thu, 14 Apr 2011 14:44:41 +0800
From: Yang Ruirui <ruirui.r.yang@tieto.com>
To: <tytso@mit.edu>, <linux-ext4@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH] ext4: release page cache in ext4_mb_load_buddy error path
Message-ID: <20110414064441.GA3499@darkstar>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add missing page_cache_release in the error path of ext4_mb_load_buddy

Signed-off-by: Yang Ruirui <ruirui.r.yang@tieto.com>
---
 fs/ext4/mballoc.c |    2 ++
 1 file changed, 2 insertions(+)

--- linux-2.6.orig/fs/ext4/mballoc.c	2011-04-14 14:04:48.000000000 +0800
+++ linux-2.6/fs/ext4/mballoc.c	2011-04-14 14:33:28.702958245 +0800
@@ -1273,6 +1273,8 @@ repeat_load_buddy:
 	return 0;
 
 err:
+	if (page)
+		page_cache_release(page);
 	if (e4b->bd_bitmap_page)
 		page_cache_release(e4b->bd_bitmap_page);
 	if (e4b->bd_buddy_page)
