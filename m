Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753363Ab0KIJG5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 04:06:57 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:52110 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753048Ab0KIJGy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 04:06:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=ZxD2g9PLju0UTLQghANJiTQNPncqqMAIgq+lFLuoALUn91AsxpPxrOMSCCqlWNgWTc
         0o5e6Ysb1OObmCh8uWxSWTJxud7V1WdpU+HGZsCpzKwOdA1Es2V9dsJbpNhzLoQ/DL2s
         9k+tZ5PMyg9s1nwz1JzatqqZvlx0tGaUnkfKY=
From: Mika Westerberg <mika.westerberg@iki.fi>
To: linux-arm-kernel@lists.infradead.org
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        Mika Westerberg <ext-mika.1.westerberg@nokia.com>
Subject: [PATCH 2/4] ARM: provide zero vmcore_elf64_check_arch()
Date: Tue,  9 Nov 2010 11:06:11 +0200
Message-Id: <932ce8610ecb22ee9d11190a043086a8975b09f7.1289292124.git.mika.westerberg@iki.fi>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <cover.1289292124.git.mika.westerberg@iki.fi>
References: <cover.1289292124.git.mika.westerberg@iki.fi>
In-Reply-To: <cover.1289292124.git.mika.westerberg@iki.fi>
References: <cover.1289292124.git.mika.westerberg@iki.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mika Westerberg <ext-mika.1.westerberg@nokia.com>

Since we don't support 64-bit ELF vmcores. This also prevents the
following warning:

fs/proc/vmcore.c: In function 'parse_crash_elf64_headers':
fs/proc/vmcore.c:502: warning: passing argument 1 of 'elf_check_arch'
  from incompatible pointer type

Signed-off-by: Mika Westerberg <ext-mika.1.westerberg@nokia.com>
---
 arch/arm/include/asm/elf.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/arm/include/asm/elf.h b/arch/arm/include/asm/elf.h
index 8bb66bc..c3cd875 100644
--- a/arch/arm/include/asm/elf.h
+++ b/arch/arm/include/asm/elf.h
@@ -99,6 +99,8 @@ struct elf32_hdr;
 extern int elf_check_arch(const struct elf32_hdr *);
 #define elf_check_arch elf_check_arch
 
+#define vmcore_elf64_check_arch(x) (0)
+
 extern int arm_elf_read_implies_exec(const struct elf32_hdr *, int);
 #define elf_read_implies_exec(ex,stk) arm_elf_read_implies_exec(&(ex), stk)
 
-- 
1.7.2.3

