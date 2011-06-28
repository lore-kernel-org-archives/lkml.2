Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752116Ab1F1V5F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 17:57:05 -0400
Received: from mail.pripojeni.net ([178.22.112.14]:51068 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752238Ab1F1V4l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 17:56:41 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: akpm@linux-foundation.org
Cc: oleg@redhat.com, linux-kernel@vger.kernel.org, jirislaby@gmail.com,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, Al Viro <viro@zeniv.linux.org.uk>,
        Andi Kleen <andi@firstfloor.org>
Subject: [PATCH -resend v2 1/3] coredump: use task comm instead of (unknown)
Date: Tue, 28 Jun 2011 23:56:23 +0200
Message-Id: <1309298185-31434-1-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.6
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
index 20e0d18..4da1d95 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1636,7 +1636,7 @@ static int cn_print_exe_file(struct core_name *cn)
 
 	exe_file = get_mm_exe_file(current->mm);
 	if (!exe_file)
-		return cn_printf(cn, "(unknown)");
+		return cn_printf(cn, "%s (path unknown)", current->comm);
 
 	pathbuf = kmalloc(PATH_MAX, GFP_TEMPORARY);
 	if (!pathbuf) {
-- 
1.7.6


