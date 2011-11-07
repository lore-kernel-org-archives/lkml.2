Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933169Ab1KGRr0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 12:47:26 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:48466 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933138Ab1KGRrZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 12:47:25 -0500
Date: Mon, 7 Nov 2011 21:45:22 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
To: linux-kernel@vger.kernel.org
Cc: Alexey Dobriyan <adobriyan@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] proc: restrict access to /proc/interrupts
Message-ID: <20111107174522.GA2317@albatros>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

/proc/interrupts contains the number of emitted interrupts, which
should not be world readable.  The information about keyboard
interrupts number may be used to learn the precise number of characters in
users' passwords by simply watching the changes of number of emitted
interrupts during the life of gksu-like programs.

The PoC is publicly available at:

http://www.openwall.com/lists/oss-security/2011/11/07/9

Cc: <stable@kernel.org>
Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>
---
 fs/proc/interrupts.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/proc/interrupts.c b/fs/proc/interrupts.c
index 05029c0..2fe87a1 100644
--- a/fs/proc/interrupts.c
+++ b/fs/proc/interrupts.c
@@ -47,7 +47,7 @@ static const struct file_operations proc_interrupts_operations = {
 
 static int __init proc_interrupts_init(void)
 {
-	proc_create("interrupts", 0, NULL, &proc_interrupts_operations);
+	proc_create("interrupts", S_IRUSR, NULL, &proc_interrupts_operations);
 	return 0;
 }
 module_init(proc_interrupts_init);
-- 
1.7.0.4

