Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752098Ab2LANYP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Dec 2012 08:24:15 -0500
Received: from smtp-out-239.synserver.de ([212.40.185.239]:1061 "EHLO
	smtp-out-239.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751646Ab2LANYN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Dec 2012 08:24:13 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@laprican.de
X-SynServer-PPID: 11086
From: Lars-Peter Clausen <lars@metafoo.de>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Mark Salter <msalter@redhat.com>, Aurelien Jacquiot <a-jacquiot@ti.com>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        Chris Zankel <chris@zankel.net>, Max Filippov <jcmvbkbc@gmail.com>,
        linux-c6x-dev@linux-c6x.org, linux-kernel@vger.kernel.org,
        linux-xtensa@linux-xtensa.org, linux-arch@vger.kernel.org,
        Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH resend 2/5] asm-generic/mmu.h: Add support for FDPIC
Date: Sat,  1 Dec 2012 14:24:41 +0100
Message-Id: <1354368284-11625-2-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1354368284-11625-1-git-send-email-lars@metafoo.de>
References: <1354368284-11625-1-git-send-email-lars@metafoo.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No-MMU architectures often have support for FDPIC binaries. FDPIC support
requires two additional fields in the mm_context_t struct. This patch adds these
fields to the generic mm_context_t definition if support for FDPIC binaries is
enabled. This allows to use the generic mmu.h for a few more architectures.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
---
 include/asm-generic/mmu.h |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/include/asm-generic/mmu.h b/include/asm-generic/mmu.h
index a67ae0a9..0ed3f1c 100644
--- a/include/asm-generic/mmu.h
+++ b/include/asm-generic/mmu.h
@@ -8,6 +8,11 @@
 #ifndef __ASSEMBLY__
 typedef struct {
 	unsigned long		end_brk;
+
+#ifdef CONFIG_BINFMT_ELF_FDPIC
+	unsigned long		exec_fdpic_loadmap;
+	unsigned long		interp_fdpic_loadmap;
+#endif
 } mm_context_t;
 #endif
 
-- 
1.7.2.5

