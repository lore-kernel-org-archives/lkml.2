Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753381Ab2JJPva (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 11:51:30 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:60389 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752426Ab2JJPv2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 11:51:28 -0400
From: Matt Fleming <matt@console-pimps.org>
To: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>
Cc: David Howells <dhowells@redhat.com>, linux-kernel@vger.kernel.org,
        linux-efi@vger.kernel.org, Matt Fleming <matt.fleming@intel.com>
Subject: [PATCH] x86, boot: Explicitly include autoconf.h for hostprogs
Date: Wed, 10 Oct 2012 16:51:13 +0100
Message-Id: <1349884273-24401-1-git-send-email-matt@console-pimps.org>
X-Mailer: git-send-email 1.7.11.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matt Fleming <matt.fleming@intel.com>

The hostprogs need access to the CONFIG_* symbols found in
include/generated/autoconf.h. commit abbf1590 ("UAPI: Partition the
header include path sets and add uapi/ header directories") replaced
$(LINUXINCLUDE) with $(USERINCLUDE) which doesn't contain the
necessary include paths.

This has the undersiable affect of breaking the EFI boot stub because
the #ifdef CONFIG_EFI_STUB code in arch/x86/boot/tools/build.c was
never compiled.

It should also be noted that because $(USERINCLUDE) isn't exported by
the top-level Makefile it's actually empty in arch/x86/boot/Makefile.

Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Ingo Molnar <mingo@kernel.org>
Acked-by: David Howells <dhowells@redhat.com>
Signed-off-by: Matt Fleming <matt.fleming@intel.com>
---
 arch/x86/boot/Makefile | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/boot/Makefile b/arch/x86/boot/Makefile
index ce03476..ccce0ed 100644
--- a/arch/x86/boot/Makefile
+++ b/arch/x86/boot/Makefile
@@ -37,7 +37,8 @@ setup-y		+= video-bios.o
 targets		+= $(setup-y)
 hostprogs-y	:= mkcpustr tools/build
 
-HOST_EXTRACFLAGS += -I$(srctree)/tools/include $(USERINCLUDE) \
+HOST_EXTRACFLAGS += -I$(srctree)/tools/include \
+		    -include include/generated/autoconf.h \
 	            -D__EXPORTED_HEADERS__
 
 $(obj)/cpu.o: $(obj)/cpustr.h
-- 
1.7.11.4

