Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756629Ab2JTSUB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Oct 2012 14:20:01 -0400
Received: from mail.skyhub.de ([78.46.96.112]:35176 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756524Ab2JTSUA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Oct 2012 14:20:00 -0400
From: Borislav Petkov <bp@alien8.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Borislav Petkov <bp@alien8.de>, Pekka Enberg <penberg@kernel.org>,
        Sasha Levin <levinsasha928@gmail.com>,
        Asias He <asias.hejun@gmail.com>
Subject: [PATCH] tools/kvm: Add a .s file rule
Date: Sat, 20 Oct 2012 20:19:54 +0200
Message-Id: <1350757194-14498-1-git-send-email-bp@alien8.de>
X-Mailer: git-send-email 1.8.0.rc2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a rule to the kvm tool Makefile to build .asm versions of the files.
This is good for debugging purposes.

Cc: Pekka Enberg <penberg@kernel.org>
Cc: Sasha Levin <levinsasha928@gmail.com>
Cc: Asias He <asias.hejun@gmail.com>
Signed-off-by: Borislav Petkov <bp@alien8.de>
---
 tools/kvm/Makefile | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/kvm/Makefile b/tools/kvm/Makefile
index 903001e80951..64f2646e5966 100644
--- a/tools/kvm/Makefile
+++ b/tools/kvm/Makefile
@@ -314,6 +314,9 @@ util/rbtree.d: ../../lib/rbtree.c
 %.d: %.c
 	$(Q) $(CC) -M -MT $(patsubst %.d,%.o,$@) $(CFLAGS) $< -o $@
 
+%.s: %.c
+	$(Q) $(CC) -o $@ -S $(CFLAGS) -fverbose-asm $<
+
 # The header file common-cmds.h is needed for compilation of builtin-help.c.
 builtin-help.d: $(KVM_INCLUDE)/common-cmds.h
 
-- 
1.8.0.rc2

