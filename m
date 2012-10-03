Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932769Ab2JCXLI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 19:11:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25185 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932581Ab2JCXLD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 19:11:03 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 2/2] UAPI: Split compound conditionals containing __KERNEL__
 in Arm64
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>,
        Catalin Marinas <catalin.marinas@arm.com>
Date: Thu, 04 Oct 2012 00:10:59 +0100
Message-ID: <20121003231058.19239.7392.stgit@warthog.procyon.org.uk>
In-Reply-To: <20121003231044.19239.81961.stgit@warthog.procyon.org.uk>
References: <20121003231044.19239.81961.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Split compound conditionals containing __KERNEL__ in Arm64 where possible to
make it easier for the UAPI disintegration scripts to handle them.

Signed-off-by: David Howells <dhowells@redhat.com>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
---

 arch/arm64/include/asm/hwcap.h  |    4 +++-
 arch/arm64/include/asm/stat.h   |    4 +++-
 arch/arm64/include/asm/unistd.h |    4 +++-
 3 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/include/asm/hwcap.h b/arch/arm64/include/asm/hwcap.h
index f8190ba..db05f97 100644
--- a/arch/arm64/include/asm/hwcap.h
+++ b/arch/arm64/include/asm/hwcap.h
@@ -35,7 +35,8 @@
 #define COMPAT_HWCAP_IDIVT	(1 << 18)
 #define COMPAT_HWCAP_IDIV	(COMPAT_HWCAP_IDIVA|COMPAT_HWCAP_IDIVT)
 
-#if defined(__KERNEL__) && !defined(__ASSEMBLY__)
+#ifdef __KERNEL__
+#ifndef __ASSEMBLY__
 /*
  * This yields a mask that user programs can use to figure out what
  * instruction set this cpu supports.
@@ -49,5 +50,6 @@
 
 extern unsigned int elf_hwcap;
 #endif
+#endif
 
 #endif
diff --git a/arch/arm64/include/asm/stat.h b/arch/arm64/include/asm/stat.h
index d87225c..a9f580c 100644
--- a/arch/arm64/include/asm/stat.h
+++ b/arch/arm64/include/asm/stat.h
@@ -18,7 +18,8 @@
 
 #include <asm-generic/stat.h>
 
-#if defined(__KERNEL__) && defined(CONFIG_COMPAT)
+#ifdef __KERNEL__
+#ifdef CONFIG_COMPAT
 
 #include <asm/compat.h>
 
@@ -58,5 +59,6 @@ struct stat64 {
 };
 
 #endif
+#endif
 
 #endif
diff --git a/arch/arm64/include/asm/unistd.h b/arch/arm64/include/asm/unistd.h
index f55ba3e..8f03dee 100644
--- a/arch/arm64/include/asm/unistd.h
+++ b/arch/arm64/include/asm/unistd.h
@@ -18,6 +18,8 @@
 #include <asm-generic/unistd.h>
 #endif
 
-#if defined(__KERNEL__) && defined(CONFIG_COMPAT)
+#ifdef __KERNEL__
+#ifdef CONFIG_COMPAT
 #include <asm/unistd32.h>
 #endif
+#endif

