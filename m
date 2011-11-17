Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756539Ab1KQJ5D (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 04:57:03 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:4170 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756300Ab1KQJ5B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 04:57:01 -0500
Message-ID: <4EC4DA68.9010009@parallels.com>
Date: Thu, 17 Nov 2011 13:56:56 +0400
From: Pavel Emelyanov <xemul@parallels.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Cyrill Gorcunov <gorcunov@openvz.org>,
        Glauber Costa <glommer@parallels.com>,
        Andi Kleen <andi@firstfloor.org>, Tejun Heo <tj@kernel.org>,
        Matt Helsley <matthltc@us.ibm.com>, Pekka Enberg <penberg@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 3/4] proc: Show open file ID in /proc/pid/fdinfo/*
References: <4EC4DA15.7090106@parallels.com>
In-Reply-To: <4EC4DA15.7090106@parallels.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Pavel Emelyanov <xemul@parallels.com>

---
 fs/proc/base.c     |    6 ++++--
 include/linux/mm.h |    1 +
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index 5eb0206..cb3e34c 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -1934,9 +1934,11 @@ static int proc_fd_info(struct inode *inode, struct path *path, char *info)
 			if (info)
 				snprintf(info, PROC_FDINFO_MAX,
 					 "pos:\t%lli\n"
-					 "flags:\t0%o\n",
+					 "flags:\t0%o\n"
+					 "id:\t%lu\n",
 					 (long long) file->f_pos,
-					 f_flags);
+					 f_flags,
+					 gen_object_id(file, GEN_OBJ_ID_FILE));
 			spin_unlock(&files->file_lock);
 			put_files_struct(files);
 			return 0;
diff --git a/include/linux/mm.h b/include/linux/mm.h
index cd4d727..caa42ca 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1629,6 +1629,7 @@ extern void copy_user_huge_page(struct page *dst, struct page *src,
 
 enum {
 	GEN_OBJ_ID_NS,
+	GEN_OBJ_ID_FILE,
 	GEN_OBJ_ID_TYPES,
 };
 
-- 
1.5.5.6
