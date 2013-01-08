Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757216Ab3AHXlw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 18:41:52 -0500
Received: from mail1.windriver.com ([147.11.146.13]:53816 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755298Ab3AHXkS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 18:40:18 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Richard Weinberger <richard@nod.at>,
        <user-mode-linux-devel@lists.sourceforge.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 75/77] um: Use RWSEM_GENERIC_SPINLOCK on x86
Date: Tue, 8 Jan 2013 18:35:54 -0500
Message-ID: <1357688156-25387-76-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.12.1
In-Reply-To: <1357688156-25387-1-git-send-email-paul.gortmaker@windriver.com>
References: <1357688156-25387-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Richard Weinberger <richard@nod.at>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 3a3679078aed2c451ebc32836bbd3b8219a65e01 upstream.

Commit d12337 (rwsem: Remove redundant asmregparm annotation)
broke rwsem on UML.

As we cannot compile UML with -mregparm=3 and keeping asmregparm only
for UML is inadequate the easiest solution is using RWSEM_GENERIC_SPINLOCK.

Thanks to Thomas Gleixner for the idea.

Reported-by: Toralf Förster <toralf.foerster@gmx.de>
Tested-by: Toralf Förster <toralf.foerster@gmx.de>
Signed-off-by: Richard Weinberger <richard@nod.at>
Cc: user-mode-linux-devel@lists.sourceforge.net
Link: http://lkml.kernel.org/r/%3C1306183893-26655-1-git-send-email-richard%40nod.at%3E
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 arch/um/Kconfig.x86 | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/um/Kconfig.x86 b/arch/um/Kconfig.x86
index 5ee3280..91668e1 100644
--- a/arch/um/Kconfig.x86
+++ b/arch/um/Kconfig.x86
@@ -20,10 +20,10 @@ config X86_32
 	select HAVE_AOUT
 
 config RWSEM_XCHGADD_ALGORITHM
-	def_bool X86_XADD
+	def_bool X86_XADD && 64BIT
 
 config RWSEM_GENERIC_SPINLOCK
-	def_bool !X86_XADD
+	def_bool !RWSEM_XCHGADD_ALGORITHM
 
 config 3_LEVEL_PGTABLES
 	bool "Three-level pagetables (EXPERIMENTAL)" if !64BIT
-- 
1.7.12.1

