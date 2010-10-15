Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755791Ab0JOCeM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 22:34:12 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:54435 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753539Ab0JOCeL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 22:34:11 -0400
Date: Fri, 15 Oct 2010 04:34:04 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH .36-rc8] a.out: Fix module build failure
Message-ID: <20101015023404.GA348@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_20 autolearn=no SpamAssassin version=3.2.5
	-1.0 BAYES_20               BODY: Bayesian spam probability is 5 to 20%
	[score: 0.0514]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The recent aout fix causes a modular build failure on x86 
(allmodconfig):

ERROR: "dump_seek" [fs/binfmt_aout.ko] undefined!
ERROR: "dump_write" [fs/binfmt_aout.ko] undefined!

Export these symbols.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
diff --git a/fs/exec.c b/fs/exec.c
index 03278c9..c55ca82 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -2024,6 +2024,7 @@ int dump_write(struct file *file, const void *addr, int nr)
 {
 	return access_ok(VERIFY_READ, addr, nr) && file->f_op->write(file, addr, nr, &file->f_pos) == nr;
 }
+EXPORT_SYMBOL_GPL(dump_write);
 
 int dump_seek(struct file *file, loff_t off)
 {
@@ -2052,3 +2053,4 @@ int dump_seek(struct file *file, loff_t off)
 	}
 	return ret;
 }
+EXPORT_SYMBOL_GPL(dump_seek);
