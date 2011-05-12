Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758690Ab1ELVE1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 17:04:27 -0400
Received: from cantor2.suse.de ([195.135.220.15]:56166 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758659Ab1ELVE0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 17:04:26 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: akpm@linux-foundation.org
Cc: linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, jirislaby@gmail.com,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, Al Viro <viro@zeniv.linux.org.uk>,
        Andi Kleen <andi@firstfloor.org>
Subject: [PATCH v2 4/4] coredump: escape / in hostname and comm fix
Date: Thu, 12 May 2011 23:04:18 +0200
Message-Id: <1305234258-28184-1-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Escape comm also in failing %E case.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Andi Kleen <andi@firstfloor.org>
---
 fs/exec.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index dafded4..13b4fce 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1563,8 +1563,8 @@ static int cn_print_exe_file(struct core_name *cn)
 	exe_file = get_mm_exe_file(current->mm);
 	if (!exe_file) {
 		char comm[TASK_COMM_LEN];
-		return cn_printf(cn, "%s (path unknown)", get_task_comm(comm,
-					current));
+		cn_escape(get_task_comm(comm, current));
+		return cn_printf(cn, "%s (path unknown)", comm);
 	}
 
 	pathbuf = kmalloc(PATH_MAX, GFP_TEMPORARY);
-- 
1.7.4.2

