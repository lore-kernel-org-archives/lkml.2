Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758859Ab1CaSDM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 14:03:12 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:33112 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758835Ab1CaSDH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 14:03:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=PC9Z7CaOsBAIoxWzv5xz+FCKuN7Qx2nvTBAXntYIFh6JLRXbDB3OTblFn1bJ6G+pPJ
         Ygwg1U9Kl1nTdjQg/FtjIKDC7fzc+mLcohoGN56Dr1uiREsNqX0L7TqTRnVNDbG3aU/V
         D4VlyB97mz8n0JHAPS/7ZmTfWZRa6XyOIip/M=
From: Tejun Heo <tj@kernel.org>
To: mingo@redhat.com, tglx@linutronix.de, hpa@zytor.com,
        cl@linux-foundation.org, yinghai@kernel.org
Cc: torvalds@linux-foundation.org, aarcange@redhat.com,
        linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>
Subject: [PATCH 2/4] x86-32: Increment SECTION_SIZE_BITS to 30 when X86_PAE
Date: Thu, 31 Mar 2011 20:02:44 +0200
Message-Id: <1301594566-10139-3-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1301594566-10139-1-git-send-email-tj@kernel.org>
References: <1301594566-10139-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When X86_PAE is enabled, SECTION_SIZE_BITS is 29 and MAX_PHYSADDR_BITS
36 making SECTIONS_WIDTH 7, which is different from !X86_PAE case
where the width is 6.  On x86, when all the related options are
enabled, NR_PAGEFLAGS reaches 26 and thus can accomodate only 6 more
bits, not 7.

This direcrepancy leads to confusing Kconfig restrictions like
disabling of ARCH_SUPPORTS_MEMORY_FAILURE depending on combinations of
options.

This patch bumps SECTION_SIZE_BITS to 30 when X86_PAE.  This change
increases sparse memory model granuality from 512MiB to 1GiB which in
turn can increase the amount of wasted memory in memmap when the
memory sections aren't aligned.  The amount of wastage can be a few
MiB per unaligned section.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/include/asm/sparsemem.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/sparsemem.h b/arch/x86/include/asm/sparsemem.h
index 4517d6b..71b8671 100644
--- a/arch/x86/include/asm/sparsemem.h
+++ b/arch/x86/include/asm/sparsemem.h
@@ -16,7 +16,7 @@
 
 #ifdef CONFIG_X86_32
 # ifdef CONFIG_X86_PAE
-#  define SECTION_SIZE_BITS	29
+#  define SECTION_SIZE_BITS	30
 #  define MAX_PHYSADDR_BITS	36
 #  define MAX_PHYSMEM_BITS	36
 # else
-- 
1.7.1

