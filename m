Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752698Ab2BTAWE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Feb 2012 19:22:04 -0500
Received: from terminus.zytor.com ([198.137.202.10]:57415 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752190Ab2BTAWB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Feb 2012 19:22:01 -0500
From: "H. Peter Anvin" <hpa@zytor.com>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Cc: mingo@kernel.org, tglx@linutronix.de, hpa@zytor.com,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        hjl.tools@gmail.com
Subject: [PATCH 29/30] x32: Allow x32 to be configured
Date: Sun, 19 Feb 2012 16:08:07 -0800
Message-Id: <1329696488-16970-30-git-send-email-hpa@zytor.com>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1329696488-16970-1-git-send-email-hpa@zytor.com>
References: <1329696488-16970-1-git-send-email-hpa@zytor.com>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Sun, 19 Feb 2012 16:21:56 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "H. J. Lu" <hjl.tools@gmail.com>

At this point, one should be able to build an x32 kernel.

Note that for now we depend on CONFIG_IA32_EMULATION.  Long term, x32
and IA32 should be detangled.

Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/Kconfig |   21 +++++++++++++++++----
 1 files changed, 17 insertions(+), 4 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 5bed94e..c9d6c9e 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -2165,9 +2165,9 @@ config IA32_EMULATION
 	depends on X86_64
 	select COMPAT_BINFMT_ELF
 	---help---
-	  Include code to run 32-bit programs under a 64-bit kernel. You should
-	  likely turn this on, unless you're 100% sure that you don't have any
-	  32-bit programs left.
+	  Include code to run legacy 32-bit programs under a
+	  64-bit kernel. You should likely turn this on, unless you're
+	  100% sure that you don't have any 32-bit programs left.
 
 config IA32_AOUT
 	tristate "IA32 a.out support"
@@ -2175,9 +2175,22 @@ config IA32_AOUT
 	---help---
 	  Support old a.out binaries in the 32bit emulation.
 
+config X86_X32_ABI
+	bool "x32 ABI for 64-bit mode (EXPERIMENTAL)"
+	depends on X86_64 && IA32_EMULATION && EXPERIMENTAL
+	---help---
+	  Include code to run binaries for the x32 native 32-bit ABI
+	  for 64-bit processors.  An x32 process gets access to the
+	  full 64-bit register file and wide data path while leaving
+	  pointers at 32 bits for smaller memory footprint.
+
+	  You will need a recent binutils (2.22 or later) with
+	  elf32_x86_64 support enabled to compile a kernel with this
+	  option set.
+
 config COMPAT
 	def_bool y
-	depends on IA32_EMULATION
+	depends on IA32_EMULATION || X86_X32_ABI
 
 config COMPAT_FOR_U64_ALIGNMENT
 	def_bool COMPAT
-- 
1.7.6.5

