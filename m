Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933944Ab0HLPzi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 11:55:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29864 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933858Ab0HLPzg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 11:55:36 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 6/6] MN10300: Use no_printk() for disabled gdbstub debugging
	functions
To: torvalds@osdl.org, akpm@linux-foundation.org
Cc: linux-am33-list@redhat.com, linux-kernel@vger.kernel.org,
        David Howells <dhowells@redhat.com>
Date: Thu, 12 Aug 2010 16:55:02 +0100
Message-ID: <20100812155502.17015.209.stgit@warthog.procyon.org.uk>
In-Reply-To: <20100812155436.17015.78424.stgit@warthog.procyon.org.uk>
References: <20100812155436.17015.78424.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use no_printk() for disabled gdbstub debugging functions to maintain side
effect checking.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 arch/mn10300/include/asm/gdb-stub.h |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)


diff --git a/arch/mn10300/include/asm/gdb-stub.h b/arch/mn10300/include/asm/gdb-stub.h
index 556cce9..41ed267 100644
--- a/arch/mn10300/include/asm/gdb-stub.h
+++ b/arch/mn10300/include/asm/gdb-stub.h
@@ -157,25 +157,25 @@ void gdbstub_printk(const char *fmt, ...)
 #ifdef CONFIG_GDBSTUB_DEBUG_ENTRY
 #define gdbstub_entry(FMT, ...) gdbstub_printk(FMT, ##__VA_ARGS__)
 #else
-#define gdbstub_entry(FMT, ...) ({ 0; })
+#define gdbstub_entry(FMT, ...) no_printk(FMT, ##__VA_ARGS__)
 #endif
 
 #ifdef CONFIG_GDBSTUB_DEBUG_PROTOCOL
 #define gdbstub_proto(FMT, ...) gdbstub_printk(FMT, ##__VA_ARGS__)
 #else
-#define gdbstub_proto(FMT, ...) ({ 0; })
+#define gdbstub_proto(FMT, ...) no_printk(FMT, ##__VA_ARGS__)
 #endif
 
 #ifdef CONFIG_GDBSTUB_DEBUG_IO
 #define gdbstub_io(FMT, ...) gdbstub_printk(FMT, ##__VA_ARGS__)
 #else
-#define gdbstub_io(FMT, ...) ({ 0; })
+#define gdbstub_io(FMT, ...) no_printk(FMT, ##__VA_ARGS__)
 #endif
 
 #ifdef CONFIG_GDBSTUB_DEBUG_BREAKPOINT
 #define gdbstub_bkpt(FMT, ...) gdbstub_printk(FMT, ##__VA_ARGS__)
 #else
-#define gdbstub_bkpt(FMT, ...) ({ 0; })
+#define gdbstub_bkpt(FMT, ...) no_printk(FMT, ##__VA_ARGS__)
 #endif
 
 #endif /* !__ASSEMBLY__ */

