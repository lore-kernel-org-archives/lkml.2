Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933108Ab0JZC5o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 22:57:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38019 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933061Ab0JZC4d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 22:56:33 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH 38/43] MN10300: Specify an ELF HWCAP flag for MN10300 Atomic
 Operations Unit support
To: linux-am33-list@redhat.com
From: David Howells <dhowells@redhat.com>
Cc: linux-kernel@vger.kernel.org, Mark Salter <msalter@redhat.com>
Date: Tue, 26 Oct 2010 03:56:24 +0100
Message-ID: <20101026025624.23512.27873.stgit@warthog.procyon.org.uk>
In-Reply-To: <20101026025301.23512.24525.stgit@warthog.procyon.org.uk>
References: <20101026025301.23512.24525.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.15-97-g9680-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark Salter <msalter@redhat.com>

Use an ELF HWCAP flag to indicate to the process that the CPU provides LL/SC
equivalent atomic operations unit support in addition to BSET/BCLR.

Signed-off-by: Mark Salter <msalter@redhat.com>
Signed-off-by: David Howells <dhowells@redhat.com>
---

 arch/mn10300/include/asm/elf.h |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)


diff --git a/arch/mn10300/include/asm/elf.h b/arch/mn10300/include/asm/elf.h
index a30d220..8157c92 100644
--- a/arch/mn10300/include/asm/elf.h
+++ b/arch/mn10300/include/asm/elf.h
@@ -32,6 +32,12 @@
 #define R_MN10300_ALIGN 	34	/* Alignment requirement. */
 
 /*
+ * AM33/AM34 HW Capabilities
+ */
+#define HWCAP_MN10300_ATOMIC_OP_UNIT	1	/* Has AM34 Atomic Operations */
+
+
+/*
  * ELF register definitions..
  */
 typedef unsigned long elf_greg_t;
@@ -128,7 +134,11 @@ do {						\
  * instruction set this CPU supports.  This could be done in user space,
  * but it's not easy, and we've already done it here.
  */
+#ifdef CONFIG_MN10300_HAS_ATOMIC_OPS_UNIT
+#define ELF_HWCAP	(HWCAP_MN10300_ATOMIC_OP_UNIT)
+#else
 #define ELF_HWCAP	(0)
+#endif
 
 /*
  * This yields a string that ld.so will use to load implementation

