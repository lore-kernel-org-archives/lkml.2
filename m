Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933117Ab2EJXmZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 19:42:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16746 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932829Ab2EJXmV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 19:42:21 -0400
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 17/29] Provide macros for forming the name of an ELF note and
 its section [ver #4]
To: rusty@rustcorp.com.au
Cc: kyle@mcmartin.ca, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, keyrings@linux-nfs.org,
        David Howells <dhowells@redhat.com>
Date: Fri, 11 May 2012 00:42:10 +0100
Message-ID: <20120510234209.4137.38276.stgit@warthog.procyon.org.uk>
In-Reply-To: <20120510233901.4137.19023.stgit@warthog.procyon.org.uk>
References: <20120510233901.4137.19023.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Provide macros for stringifying the name of an ELF note and its section
appropriately so that the macro can be used in both C and assembly.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 include/linux/elfnote.h |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)


diff --git a/include/linux/elfnote.h b/include/linux/elfnote.h
index 278e3ef..949d494 100644
--- a/include/linux/elfnote.h
+++ b/include/linux/elfnote.h
@@ -58,6 +58,7 @@
 	ELFNOTE_END
 
 #else	/* !__ASSEMBLER__ */
+#include <linux/stringify.h>
 #include <linux/elf.h>
 /*
  * Use an anonymous structure which matches the shape of
@@ -93,6 +94,9 @@
 
 #define ELFNOTE32(name, type, desc) ELFNOTE(32, name, type, desc)
 #define ELFNOTE64(name, type, desc) ELFNOTE(64, name, type, desc)
+
+#define ELFNOTE_NAME(name)	__stringify(name)
+#define ELFNOTE_SECTION(name)	".note."ELFNOTE_NAME(name)
 #endif	/* __ASSEMBLER__ */
 
 #endif /* _LINUX_ELFNOTE_H */

