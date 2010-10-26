Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932476Ab0JZCyf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 22:54:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49987 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932433Ab0JZCyb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 22:54:31 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH 15/43] MN10300: Cache: Split cache bits out of arch Kconfig
To: linux-am33-list@redhat.com
From: David Howells <dhowells@redhat.com>
Cc: linux-kernel@vger.kernel.org
Date: Tue, 26 Oct 2010 03:54:21 +0100
Message-ID: <20101026025421.23512.78330.stgit@warthog.procyon.org.uk>
In-Reply-To: <20101026025301.23512.24525.stgit@warthog.procyon.org.uk>
References: <20101026025301.23512.24525.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.15-97-g9680-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Split the cache bits out of arch/mn10300/Kconfig as they're quite complex.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 arch/mn10300/Kconfig          |   29 +----------------------------
 arch/mn10300/mm/Kconfig.cache |   32 ++++++++++++++++++++++++++++++++
 2 files changed, 33 insertions(+), 28 deletions(-)
 create mode 100644 arch/mn10300/mm/Kconfig.cache


diff --git a/arch/mn10300/Kconfig b/arch/mn10300/Kconfig
index eab0c2a..069e34d 100644
--- a/arch/mn10300/Kconfig
+++ b/arch/mn10300/Kconfig
@@ -136,34 +136,7 @@ config FPU
 	default y
 	depends on MN10300_PROC_MN103E010
 
-choice
-	prompt "CPU Caching mode"
-	default MN10300_CACHE_WBACK
-	help
-	  This option determines the caching mode for the kernel.
-
-	  Write-Back caching mode involves the all reads and writes causing
-	  the affected cacheline to be read into the cache first before being
-	  operated upon. Memory is not then updated by a write until the cache
-	  is filled and a cacheline needs to be displaced from the cache to
-	  make room. Only at that point is it written back.
-
-	  Write-Through caching only fetches cachelines from memory on a
-	  read. Writes always get written directly to memory. If the affected
-	  cacheline is also in cache, it will be updated too.
-
-	  The final option is to turn of caching entirely.
-
-config MN10300_CACHE_WBACK
-	bool "Write-Back"
-
-config MN10300_CACHE_WTHRU
-	bool "Write-Through"
-
-config MN10300_CACHE_DISABLED
-	bool "Disabled"
-
-endchoice
+source "arch/mn10300/mm/Kconfig.cache"
 
 menu "Memory layout options"
 
diff --git a/arch/mn10300/mm/Kconfig.cache b/arch/mn10300/mm/Kconfig.cache
new file mode 100644
index 0000000..f5599f4
--- /dev/null
+++ b/arch/mn10300/mm/Kconfig.cache
@@ -0,0 +1,32 @@
+#
+# MN10300 CPU cache options
+#
+
+choice
+	prompt "CPU Caching mode"
+	default MN10300_CACHE_WBACK
+	help
+	  This option determines the caching mode for the kernel.
+
+	  Write-Back caching mode involves the all reads and writes causing
+	  the affected cacheline to be read into the cache first before being
+	  operated upon. Memory is not then updated by a write until the cache
+	  is filled and a cacheline needs to be displaced from the cache to
+	  make room. Only at that point is it written back.
+
+	  Write-Through caching only fetches cachelines from memory on a
+	  read. Writes always get written directly to memory. If the affected
+	  cacheline is also in cache, it will be updated too.
+
+	  The final option is to turn of caching entirely.
+
+config MN10300_CACHE_WBACK
+	bool "Write-Back"
+
+config MN10300_CACHE_WTHRU
+	bool "Write-Through"
+
+config MN10300_CACHE_DISABLED
+	bool "Disabled"
+
+endchoice

