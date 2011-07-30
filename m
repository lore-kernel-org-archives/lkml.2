Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752216Ab1G3XDB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jul 2011 19:03:01 -0400
Received: from casper.infradead.org ([85.118.1.10]:60217 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751729Ab1G3XCz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jul 2011 19:02:55 -0400
Subject: [PATCH 4/5] um: Do not define SUBARCH in CFLAGS
From: David Woodhouse <dwmw2@infradead.org>
To: Arnaud Lacombe <lacombar@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        linux-kbuild@vger.kernel.org,
        user-mode-linux-devel@lists.sourceforge.net
Date: Sun, 31 Jul 2011 00:02:50 +0100
In-Reply-To: <1312066693.22074.50.camel@i7.infradead.org>
References: <1312066693.22074.50.camel@i7.infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.2 (3.0.2-3.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1312066972.22074.55.camel@i7.infradead.org>
Mime-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are no users of this, and not a lot of reasons why people would *need*
to use it when the compiler defines standard macros for the architecture
anyway.

Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
---

Did I miss somewhere that this is actually used?

 arch/um/Makefile        |    2 +-
 arch/um/kernel/Makefile |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/um/Makefile b/arch/um/Makefile
index fab8121..2a54640 100644
--- a/arch/um/Makefile
+++ b/arch/um/Makefile
@@ -38,7 +38,7 @@ KBUILD_CPPFLAGS += -I$(srctree)/$(ARCH_DIR)/sys-$(SUBARCH)
 #
 # These apply to USER_CFLAGS to.
 
-KBUILD_CFLAGS += $(CFLAGS) $(CFLAGS-y) -D__arch_um__ -DSUBARCH=\"$(SUBARCH)\" \
+KBUILD_CFLAGS += $(CFLAGS) $(CFLAGS-y) -D__arch_um__ \
 	$(ARCH_INCLUDE) $(MODE_INCLUDE) -Dvmap=kernel_vmap	\
 	-Din6addr_loopback=kernel_in6addr_loopback \
 	-Din6addr_any=kernel_in6addr_any
diff --git a/arch/um/kernel/Makefile b/arch/um/kernel/Makefile
index c4491c1..48a4f9f 100644
--- a/arch/um/kernel/Makefile
+++ b/arch/um/kernel/Makefile
@@ -3,7 +3,7 @@
 # Licensed under the GPL
 #
 
-CPPFLAGS_vmlinux.lds := -U$(SUBARCH) -DSTART=$(LDS_START) \
+CPPFLAGS_vmlinux.lds := -DSTART=$(LDS_START) \
                         -DELF_ARCH=$(LDS_ELF_ARCH)        \
                         -DELF_FORMAT=$(LDS_ELF_FORMAT)
 extra-y := vmlinux.lds
-- 
1.7.6



