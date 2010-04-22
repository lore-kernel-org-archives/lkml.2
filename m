Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757912Ab0DVUcY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 16:32:24 -0400
Received: from kroah.org ([198.145.64.141]:59418 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757893Ab0DVT7l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 15:59:41 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Thu Apr 22 12:54:05 2010
Message-Id: <20100422195405.911134295@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Thu, 22 Apr 2010 12:53:08 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Andrew Stubbs <ams@codesourcery.com>, Paul Mundt <lethal@linux-sh.org>
Subject: [011/139] sh: Fix FDPIC binary loader
In-Reply-To: <20100422195715.GA25490@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Andrew Stubbs <ams@codesourcery.com>

commit d5ab780305bb6d60a7b5a74f18cf84eb6ad153b1 upstream.

Ensure that the aux table is properly initialized, even when optional
features are missing. Without this, the FDPIC loader did not work.

Signed-off-by: Andrew Stubbs <ams@codesourcery.com>
Signed-off-by: Paul Mundt <lethal@linux-sh.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/sh/include/asm/elf.h |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/arch/sh/include/asm/elf.h
+++ b/arch/sh/include/asm/elf.h
@@ -211,7 +211,9 @@ extern void __kernel_vsyscall;
 
 #define VSYSCALL_AUX_ENT					\
 	if (vdso_enabled)					\
-		NEW_AUX_ENT(AT_SYSINFO_EHDR, VDSO_BASE);
+		NEW_AUX_ENT(AT_SYSINFO_EHDR, VDSO_BASE);	\
+	else							\
+		NEW_AUX_ENT(AT_IGNORE, 0);
 #else
 #define VSYSCALL_AUX_ENT
 #endif /* CONFIG_VSYSCALL */
@@ -219,7 +221,7 @@ extern void __kernel_vsyscall;
 #ifdef CONFIG_SH_FPU
 #define FPU_AUX_ENT	NEW_AUX_ENT(AT_FPUCW, FPSCR_INIT)
 #else
-#define FPU_AUX_ENT
+#define FPU_AUX_ENT	NEW_AUX_ENT(AT_IGNORE, 0)
 #endif
 
 extern int l1i_cache_shape, l1d_cache_shape, l2_cache_shape;


