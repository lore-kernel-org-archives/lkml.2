Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932172Ab2JJScw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 14:32:52 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:47700 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754433Ab2JJSct (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 14:32:49 -0400
Message-ID: <1349893964.15966.376.camel@mfleming-mobl1.ger.corp.intel.com>
Subject: Re: [PATCH] x86, boot: Explicitly include autoconf.h for hostprogs
From: Matt Fleming <matt@console-pimps.org>
To: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>
Cc: David Howells <dhowells@redhat.com>, linux-kernel@vger.kernel.org,
        linux-efi@vger.kernel.org
Date: Wed, 10 Oct 2012 19:32:44 +0100
In-Reply-To: <1349884273-24401-1-git-send-email-matt@console-pimps.org>
References: <1349884273-24401-1-git-send-email-matt@console-pimps.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-10-10 at 16:51 +0100, Matt Fleming wrote:
> From: Matt Fleming <matt.fleming@intel.com>
> 
> The hostprogs need access to the CONFIG_* symbols found in
> include/generated/autoconf.h. commit abbf1590 ("UAPI: Partition the
> header include path sets and add uapi/ header directories") replaced
> $(LINUXINCLUDE) with $(USERINCLUDE) which doesn't contain the
> necessary include paths.
> 
> This has the undersiable affect of breaking the EFI boot stub because
> the #ifdef CONFIG_EFI_STUB code in arch/x86/boot/tools/build.c was
> never compiled.
> 
> It should also be noted that because $(USERINCLUDE) isn't exported by
> the top-level Makefile it's actually empty in arch/x86/boot/Makefile.
> 
> Cc: H. Peter Anvin <hpa@zytor.com>
> Cc: Ingo Molnar <mingo@kernel.org>
> Acked-by: David Howells <dhowells@redhat.com>
> Signed-off-by: Matt Fleming <matt.fleming@intel.com>

And here's a version without all the typos!

---

>From 0fe8a9317d99ad8dd39807c0ad93d65e34aadfe9 Mon Sep 17 00:00:00 2001
From: Matt Fleming <matt.fleming@intel.com>
Date: Wed, 10 Oct 2012 16:36:45 +0100
Subject: [PATCH] x86, boot: Explicitly include autoconf.h for hostprogs

The hostprogs need access to the CONFIG_* symbols found in
include/generated/autoconf.h. commit abbf1590 ("UAPI: Partition the
header include path sets and add uapi/ header directories") replaced
$(LINUXINCLUDE) with $(USERINCLUDE) which doesn't contain the
necessary include paths.

This has the undesirable effect of breaking the EFI boot stub because
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




