Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758870Ab1CaSDN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 14:03:13 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:34779 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758834Ab1CaSDF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 14:03:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=SM+b2bZngw5XDAh3zwz2qPQFqWnBGhnHTWvd14OdJ/HJJ0hBjbzY685JZevC5BKCEX
         bUvYOahsR3v69XDcmPnH+fz6gr4VEMQqjEL1vGq2t4zd6x/5Q0C8RS6/QrKupd0JSYpO
         tdDjYejoTB2MmeizCyMs3RPYOEFsJK4AEWx74=
From: Tejun Heo <tj@kernel.org>
To: mingo@redhat.com, tglx@linutronix.de, hpa@zytor.com,
        cl@linux-foundation.org, yinghai@kernel.org
Cc: torvalds@linux-foundation.org, aarcange@redhat.com,
        linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>
Subject: [PATCH 1/4] x86: Clean up memory model related configs in arch/x86/Kconfig
Date: Thu, 31 Mar 2011 20:02:43 +0200
Message-Id: <1301594566-10139-2-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1301594566-10139-1-git-send-email-tj@kernel.org>
References: <1301594566-10139-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Remove bogus dependency on ARCH_SELECT_MEMORY_MODEL from
  ARCH_FLATMEM_ENABLE.  ENABLE configs don't interfere with
  SELECT_MEMORY_MODEL.  They just need to indicate whether the
  specific memory model is supported.

* Relocate HAVE_ARCH_ALLOC_REMAP, ARCH_PROC_KCORE_TEXT and
  ARCH_SPARSEMEM_DEFAULT so that memory model related configs are
  together in consistent order.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/Kconfig |   26 +++++++++++++-------------
 1 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index cc6c53a..0db96ae 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1223,6 +1223,10 @@ config HAVE_ARCH_BOOTMEM
 	def_bool y
 	depends on X86_32 && NUMA
 
+config HAVE_ARCH_ALLOC_REMAP
+	def_bool y
+	depends on X86_32 && NUMA
+
 config ARCH_HAVE_MEMORY_PRESENT
 	def_bool y
 	depends on X86_32 && DISCONTIGMEM
@@ -1231,13 +1235,9 @@ config NEED_NODE_MEMMAP_SIZE
 	def_bool y
 	depends on X86_32 && (DISCONTIGMEM || SPARSEMEM)
 
-config HAVE_ARCH_ALLOC_REMAP
-	def_bool y
-	depends on X86_32 && NUMA
-
 config ARCH_FLATMEM_ENABLE
 	def_bool y
-	depends on X86_32 && ARCH_SELECT_MEMORY_MODEL && !NUMA
+	depends on X86_32 && !NUMA
 
 config ARCH_DISCONTIGMEM_ENABLE
 	def_bool y
@@ -1247,20 +1247,16 @@ config ARCH_DISCONTIGMEM_DEFAULT
 	def_bool y
 	depends on NUMA && X86_32
 
-config ARCH_PROC_KCORE_TEXT
-	def_bool y
-	depends on X86_64 && PROC_KCORE
-
-config ARCH_SPARSEMEM_DEFAULT
-	def_bool y
-	depends on X86_64
-
 config ARCH_SPARSEMEM_ENABLE
 	def_bool y
 	depends on X86_64 || NUMA || (EXPERIMENTAL && X86_32) || X86_32_NON_STANDARD
 	select SPARSEMEM_STATIC if X86_32
 	select SPARSEMEM_VMEMMAP_ENABLE if X86_64
 
+config ARCH_SPARSEMEM_DEFAULT
+	def_bool y
+	depends on X86_64
+
 config ARCH_SELECT_MEMORY_MODEL
 	def_bool y
 	depends on ARCH_SPARSEMEM_ENABLE
@@ -1269,6 +1265,10 @@ config ARCH_MEMORY_PROBE
 	def_bool X86_64
 	depends on MEMORY_HOTPLUG
 
+config ARCH_PROC_KCORE_TEXT
+	def_bool y
+	depends on X86_64 && PROC_KCORE
+
 config ILLEGAL_POINTER_VALUE
        hex
        default 0 if X86_32
-- 
1.7.1

