Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751628Ab2GUPir (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2012 11:38:47 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:58039 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751299Ab2GUPiq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2012 11:38:46 -0400
From: zwu.kernel@gmail.com
To: viro@zeniv.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
Subject: [PATCH] vfs: simply the code logic
Date: Sat, 21 Jul 2012 23:38:19 +0800
Message-Id: <1342885099-22662-1-git-send-email-zwu.kernel@gmail.com>
X-Mailer: git-send-email 1.7.6
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12072115-8974-0000-0000-00000B610027
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>

Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
---
 fs/block_dev.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/fs/block_dev.c b/fs/block_dev.c
index c2bbe1f..0f268d3 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -396,10 +396,7 @@ static loff_t block_llseek(struct file *file, loff_t offset, int origin)
 			goto out;
 	}
 	if (offset >= 0 && offset <= size) {
-		if (offset != file->f_pos) {
-			file->f_pos = offset;
-		}
-		retval = offset;
+		retval = file->f_pos = offset;
 	}
 out:
 	mutex_unlock(&bd_inode->i_mutex);
-- 
1.7.6

