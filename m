Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755777Ab0I3J3M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 05:29:12 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:32949 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755741Ab0I3J3H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 05:29:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=QJnYFvL/8eLCTSIVek+S2aDGUVBs3r1wZgBnndpVRM4jLcgRafp60CAGiMHnQc9HVR
         dfvGkdYTBfMboW1dEmOJvoptuznWI3qnK8nu6PGcllm2R4nPFfssDcLZ1P1klfskPYjs
         ofOMlplRNLDudjzTy8CLlrG9FwtMVACZ9P1ts=
From: Namhyung Kim <namhyung@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Roland McGrath <roland@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        linux-kernel@vger.kernel.org, Michal Simek <monstr@monstr.eu>
Subject: [PATCH RESEND v3 14/24] ptrace: cleanup arch_ptrace() on microblaze
Date: Thu, 30 Sep 2010 18:27:49 +0900
Message-Id: <1285838880-4977-15-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <1285838880-4977-1-git-send-email-namhyung@gmail.com>
References: <1285838880-4977-1-git-send-email-namhyung@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove checking @addr greater than 0 because @addr is now unsigned.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Cc: Michal Simek <monstr@monstr.eu>
---
 arch/microblaze/kernel/ptrace.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/microblaze/kernel/ptrace.c b/arch/microblaze/kernel/ptrace.c
index 3544bc1..05ac8cc 100644
--- a/arch/microblaze/kernel/ptrace.c
+++ b/arch/microblaze/kernel/ptrace.c
@@ -100,7 +100,7 @@ long arch_ptrace(struct task_struct *child, long request,
 			} else {
 				rval = -EIO;
 			}
-		} else if (addr >= 0 && addr < PT_SIZE && (addr & 0x3) == 0) {
+		} else if (addr < PT_SIZE && (addr & 0x3) == 0) {
 			microblaze_reg_t *reg_addr = reg_save_addr(addr, child);
 			if (request == PTRACE_PEEKUSR)
 				val = *reg_addr;
-- 
1.7.2.2

