Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755348Ab1EQOhB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 10:37:01 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:49669 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755139Ab1EQOhA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 10:37:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=ecSKcvLh8IN0mpB1DJ4UssGVZZ+aXVGn4D0rj9E0x7X91bT+Ekvdh2tckgbszvB+m/
         MANT0um0rR6t8BlTSDf2eI2AkfdpMpVUBMIU8VZ7cqkdL52uXYbg/TEaJITQ2p8XFLnP
         W8kgWRRKXkNDn/XV1U6SZse3Tr16qjLN2mFUE=
From: Wanlong Gao <wanlong.gao@gmail.com>
To: dwmw2@infradead.org, akpm@linux-foundation.org
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        Wanlong Gao <wanlong.gao@gmail.com>
Subject: [PATCH 2/2] driver:mtd:fix the bad format in the mtdcore.c
Date: Tue, 17 May 2011 22:36:19 +0800
Message-Id: <1305642979-7419-2-git-send-email-wanlong.gao@gmail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1305642979-7419-1-git-send-email-wanlong.gao@gmail.com>
References: <1305642979-7419-1-git-send-email-wanlong.gao@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wanlong Gao <wanlong.gao@gmail.com>

Fix the bad format in the mtdcore.c.

Signed-off-by: Wanlong Gao <wanlong.gao@gmail.com>
---
 drivers/mtd/mtdcore.c |   34 +++++++++++++++++-----------------
 1 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/drivers/mtd/mtdcore.c b/drivers/mtd/mtdcore.c
index 9b7ad35..524e030 100644
--- a/drivers/mtd/mtdcore.c
+++ b/drivers/mtd/mtdcore.c
@@ -615,7 +615,7 @@ int default_mtd_writev(struct mtd_info *mtd, const struct kvec *vecs,
 	if(!mtd->write) {
 		ret = -EROFS;
 	} else {
-		for (i=0; i<count; i++) {
+		for (i = 0; i < count; i++) {
 			if (!vecs[i].iov_len)
 				continue;
 			ret = mtd->write(mtd, to, vecs[i].iov_len, &thislen, vecs[i].iov_base);
@@ -651,8 +651,8 @@ static struct proc_dir_entry *proc_mtd;
 static inline int mtd_proc_info(char *buf, struct mtd_info *this)
 {
 	return sprintf(buf, "mtd%d: %8.8llx %8.8x \"%s\"\n", this->index,
-		       (unsigned long long)this->size,
-		       this->erasesize, this->name);
+			(unsigned long long)this->size,
+			this->erasesize, this->name);
 }
 
 static int mtd_read_proc (char *page, char **start, off_t off, int count,
@@ -660,30 +660,30 @@ static int mtd_read_proc (char *page, char **start, off_t off, int count,
 {
 	struct mtd_info *mtd;
 	int len, l;
-        off_t   begin = 0;
+	off_t begin = 0;
 
 	mutex_lock(&mtd_table_mutex);
 
 	len = sprintf(page, "dev:    size   erasesize  name\n");
 	mtd_for_each_device(mtd) {
 		l = mtd_proc_info(page + len, mtd);
-                len += l;
-                if (len+begin > off+count)
-                        goto done;
-                if (len+begin < off) {
-                        begin += len;
-                        len = 0;
-                }
-        }
+		len += l;
+		if (len + begin > off + count)
+			goto done;
+		if (len + begin < off) {
+			begin += len;
+			len = 0;
+		}
+	}
 
-        *eof = 1;
+	*eof = 1;
 
 done:
 	mutex_unlock(&mtd_table_mutex);
-        if (off >= len+begin)
-                return 0;
-        *start = page + (off-begin);
-        return ((count < begin+len-off) ? count : begin+len-off);
+	if (off >= len + begin)
+		return 0;
+	*start = page + (off - begin);
+	return ((count < begin + len - off) ? count : begin + len - off);
 }
 
 #endif /* CONFIG_PROC_FS */
-- 
1.7.4.1

