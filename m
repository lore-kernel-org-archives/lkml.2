Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753384Ab1H3LEV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 07:04:21 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:55145 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752139Ab1H3LET (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 07:04:19 -0400
From: Richard Weinberger <richard@nod.at>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, user-mode-linux-devel@lists.sourceforge.net,
        Al Viro <viro@ftp.linux.org.uk>, jdike@addtoit.com,
        Al Viro <viro@zeniv.linux.org.uk>, Richard Weinberger <richard@nod.at>
Subject: [PATCH] um: fix strrchr problems
Date: Tue, 30 Aug 2011 13:04:04 +0200
Message-Id: <1314702244-3948-1-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.7.6.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Al Viro <viro@ftp.linux.org.uk>

[richard@nod.at:
Fixes:
/usr/lib/gcc/x86_64-linux-gnu/4.4.5/../../../../lib/libc.a(strrchr.o): In function `rindex':
(.text+0x0): multiple definition of `strrchr'

If both STATIC_LINK and UML_NET_VDE are set to "y" libc's strstr
may clash with the kernel implementation.

This workaround comes originally from Jeff Dike:
http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=494995#35
]

CC: jdike@addtoit.com
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Richard Weinberger <richard@nod.at>
---
 arch/um/Makefile |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/um/Makefile b/arch/um/Makefile
index fab8121..c0f712c 100644
--- a/arch/um/Makefile
+++ b/arch/um/Makefile
@@ -41,7 +41,7 @@ KBUILD_CPPFLAGS += -I$(srctree)/$(ARCH_DIR)/sys-$(SUBARCH)
 KBUILD_CFLAGS += $(CFLAGS) $(CFLAGS-y) -D__arch_um__ -DSUBARCH=\"$(SUBARCH)\" \
 	$(ARCH_INCLUDE) $(MODE_INCLUDE) -Dvmap=kernel_vmap	\
 	-Din6addr_loopback=kernel_in6addr_loopback \
-	-Din6addr_any=kernel_in6addr_any
+	-Din6addr_any=kernel_in6addr_any -Dstrrchr=kernel_strrchr
 
 KBUILD_AFLAGS += $(ARCH_INCLUDE)
 
-- 
1.7.6.1

