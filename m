Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756193Ab0IBPsL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 11:48:11 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:33315 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756160Ab0IBPsG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 11:48:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=uap/h8lAfFzhuwGMvEgEnGJhn5EBaJpQ39tm5SAw9NouL5YYPSPC3HUYK46vm1ZUx+
         +zR+cCRQUCSwdFPc+/Epsh0pYx8+bEjsp6/JTVoewKVG99E1DyLFzncVMvdvKRjmcADJ
         ShZ+/OqdZp7c1CPY0Os2G6gvMMo0dJeanXW58=
From: Namhyung Kim <namhyung@gmail.com>
To: Roland McGrath <roland@redhat.com>, Oleg Nesterov <oleg@redhat.com>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        Michal Simek <monstr@monstr.eu>
Subject: [PATCH v2 14/24] ptrace: cleanup arch_ptrace() on microblaze
Date: Fri,  3 Sep 2010 00:46:21 +0900
Message-Id: <1283442391-23612-15-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <1283442391-23612-1-git-send-email-namhyung@gmail.com>
References: <1283442391-23612-1-git-send-email-namhyung@gmail.com>
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

