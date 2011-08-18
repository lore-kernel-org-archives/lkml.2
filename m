Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753134Ab1HRTBD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 15:01:03 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:44217 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753083Ab1HRTA7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 15:00:59 -0400
Date: Thu, 18 Aug 2011 20:00:59 +0100
To: richard@nod.at
Subject: Subject: [PATCH 12/91] um: switch to -idirafter, get saner
 kern_constants.h out of that
Cc: user-mode-linux-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
User-Agent: Heirloom mailx 12.5 7/5/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <E1Qu7pr-0007VL-7N@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 arch/um/Makefile |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/um/Makefile b/arch/um/Makefile
index c0f712c..deb0553 100644
--- a/arch/um/Makefile
+++ b/arch/um/Makefile
@@ -47,7 +47,7 @@ KBUILD_AFLAGS += $(ARCH_INCLUDE)
 
 USER_CFLAGS = $(patsubst $(KERNEL_DEFINES),,$(patsubst -D__KERNEL__,,\
 	$(patsubst -I%,,$(KBUILD_CFLAGS)))) $(ARCH_INCLUDE) $(MODE_INCLUDE) \
-	$(filter -I%,$(CFLAGS)) -D_FILE_OFFSET_BITS=64
+	$(filter -I%,$(CFLAGS)) -D_FILE_OFFSET_BITS=64 -idirafter include
 
 include $(srctree)/$(ARCH_DIR)/Makefile-$(SUBARCH)
 
@@ -149,6 +149,6 @@ $(SHARED_HEADERS)/user_constants.h: $(ARCH_DIR)/sys-$(SUBARCH)/user-offsets.s
 
 $(SHARED_HEADERS)/kern_constants.h:
 	$(Q)mkdir -p $(dir $@)
-	$(Q)echo '#include "../../../../include/generated/asm-offsets.h"' >$@
+	$(Q)echo '#include <generated/asm-offsets.h>' >$@
 
 export SUBARCH USER_CFLAGS CFLAGS_NO_HARDENING OS HEADER_ARCH DEV_NULL_PATH
-- 
1.7.2.5


