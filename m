Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754379Ab0GLUul (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 16:50:41 -0400
Received: from mail.perches.com ([173.55.12.10]:1727 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754169Ab0GLUuf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 16:50:35 -0400
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org, Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>, linux390@de.ibm.com,
        linux-s390@vger.kernel.org
Subject: [PATCH 04/36] arch/s390: Remove unnecessary casts of private_data
Date: Mon, 12 Jul 2010 13:49:56 -0700
Message-Id: <fa1d54091a0015737790eb442d2fbc8f5e24f276.1278967120.git.joe@perches.com>
X-Mailer: git-send-email 1.7.1.337.g6068.dirty
In-Reply-To: <cover.1278967120.git.joe@perches.com>
References: <cover.1278967120.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 arch/s390/kernel/debug.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/s390/kernel/debug.c b/arch/s390/kernel/debug.c
index 9819226..39439c7 100644
--- a/arch/s390/kernel/debug.c
+++ b/arch/s390/kernel/debug.c
@@ -531,7 +531,7 @@ debug_output(struct file *file,		/* file descriptor */
 	size_t entry_offset;
 	file_private_info_t *p_info;
 
-	p_info = ((file_private_info_t *) file->private_data);
+	p_info = file->private_data;
 	if (*offset != p_info->offset) 
 		return -EPIPE;
 	if(p_info->act_area >= p_info->debug_info_snap->nr_areas)
@@ -581,7 +581,7 @@ debug_input(struct file *file, const char __user *user_buf, size_t length,
 	file_private_info_t *p_info;
 
 	mutex_lock(&debug_mutex);
-	p_info = ((file_private_info_t *) file->private_data);
+	p_info = file->private_data;
 	if (p_info->view->input_proc)
 		rc = p_info->view->input_proc(p_info->debug_info_org,
 					      p_info->view, file, user_buf,
@@ -671,7 +671,7 @@ static int
 debug_close(struct inode *inode, struct file *file)
 {
 	file_private_info_t *p_info;
-	p_info = (file_private_info_t *) file->private_data;
+	p_info = file->private_data;
 	if(p_info->debug_info_snap)
 		debug_info_free(p_info->debug_info_snap);
 	debug_info_put(p_info->debug_info_org);
-- 
1.7.1.337.g6068.dirty

