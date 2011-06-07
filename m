Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755735Ab1FGOas (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 10:30:48 -0400
Received: from mail.pripojeni.net ([178.22.112.14]:60036 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753341Ab1FGOar (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 10:30:47 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, jirislaby@gmail.com,
        Jiri Slaby <jslaby@suse.cz>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Al Viro <viro@zeniv.linux.org.uk>, Andi Kleen <andi@firstfloor.org>,
        Oleg Nesterov <oleg@redhat.com>
Subject: [PATCH v2 1/2] coredump: use task comm instead of (unknown)
Date: Tue,  7 Jun 2011 16:30:09 +0200
Message-Id: <1307457010-7241-1-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.5.3
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
Cc: Oleg Nesterov <oleg@redhat.com>
---
 fs/exec.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index a9f2b36..2093c47 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1631,7 +1631,7 @@ static int cn_print_exe_file(struct core_name *cn)
 
 	exe_file = get_mm_exe_file(current->mm);
 	if (!exe_file)
-		return cn_printf(cn, "(unknown)");
+		return cn_printf(cn, "%s (path unknown)", current->comm);
 
 	pathbuf = kmalloc(PATH_MAX, GFP_TEMPORARY);
 	if (!pathbuf) {
-- 
1.7.5.3


