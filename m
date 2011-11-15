Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755441Ab1KOLhi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 06:37:38 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:47107 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755103Ab1KOLhh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 06:37:37 -0500
Message-ID: <4EC24EEC.4000708@parallels.com>
Date: Tue, 15 Nov 2011 15:37:16 +0400
From: Pavel Emelyanov <xemul@parallels.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Cyrill Gorcunov <gorcunov@openvz.org>,
        Glauber Costa <glommer@parallels.com>,
        Andi Kleen <andi@firstfloor.org>, Tejun Heo <tj@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Matt Helsley <matthltc@us.ibm.com>
Subject: [PATCH 3/4] proc: Show open file ID in /proc/pid/fdinfo/*
References: <4EC24E9E.8040502@parallels.com>
In-Reply-To: <4EC24E9E.8040502@parallels.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Pavel Emelyanov <xemul@parallels.com>

---
 fs/proc/base.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index 5eb0206..7a9e36b 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -83,6 +83,7 @@
 #include <linux/pid_namespace.h>
 #include <linux/fs_struct.h>
 #include <linux/slab.h>
+#include <linux/gen_object_ids.h>
 #ifdef CONFIG_HARDWALL
 #include <asm/hardwall.h>
 #endif
@@ -1934,9 +1935,10 @@ static int proc_fd_info(struct inode *inode, struct path *path, char *info)
 			if (info)
 				snprintf(info, PROC_FDINFO_MAX,
 					 "pos:\t%lli\n"
-					 "flags:\t0%o\n",
+					 "flags:\t0%o\n"
+					 "id:\t%lu\n",
 					 (long long) file->f_pos,
-					 f_flags);
+					 f_flags, gen_object_id(file));
 			spin_unlock(&files->file_lock);
 			put_files_struct(files);
 			return 0;
-- 
1.5.5.6
