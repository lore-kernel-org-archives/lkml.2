Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751244Ab1EDHc5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 03:32:57 -0400
Received: from mail.pripojeni.net ([217.66.174.14]:34940 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750914Ab1EDHc4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 03:32:56 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: akpm@linux-foundation.org
Cc: linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, jirislaby@gmail.com,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, Al Viro <viro@zeniv.linux.org.uk>,
        Andi Kleen <andi@firstfloor.org>
Subject: [PATCH 1/1] coredump: use task comm instead of (unknown)
Date: Wed,  4 May 2011 09:32:34 +0200
Message-Id: <1304494354-21487-1-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.4.2
In-Reply-To: <4DC0FFAB.1000805@gmail.com>
References: <4DC0FFAB.1000805@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If we don't know the file corresponding to the binary (i.e. exe_file
is unknown), use "task->comm (path unknown)" instead of simple
"(unknown)" as suggested by ak.

The fallback is the same as %e except it will append "(path unknown)".

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Andi Kleen <andi@firstfloor.org>
---
 fs/exec.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index 5ee7562..0a4d281 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1555,7 +1555,7 @@ static int cn_print_exe_file(struct core_name *cn)
 
 	exe_file = get_mm_exe_file(current->mm);
 	if (!exe_file)
-		return cn_printf(cn, "(unknown)");
+		return cn_printf(cn, "%s (path unknown)", current->comm);
 
 	pathbuf = kmalloc(PATH_MAX, GFP_TEMPORARY);
 	if (!pathbuf) {
-- 
1.7.4.2


