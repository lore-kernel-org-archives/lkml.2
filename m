Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755749Ab1G1Pvh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 11:51:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22602 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755719Ab1G1Pve (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 11:51:34 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 13/40] UAPI: Remove the inclusion of linux/types.h from x86's
 asm/page.h [ver #3]
To: torvalds@osdl.org
Cc: linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
        David Howells <dhowells@redhat.com>
Date: Thu, 28 Jul 2011 16:51:27 +0100
Message-ID: <20110728155127.16618.34430.stgit@warthog.procyon.org.uk>
In-Reply-To: <20110728154920.16618.89358.stgit@warthog.procyon.org.uk>
References: <20110728154920.16618.89358.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the inclusion of linux/types.h from x86's asm/page.h as it's included
via asm/page_types.h.  Make asm/page_types.h's inclusion dependent on not being
in assembly.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 arch/x86/include/asm/page.h       |    2 --
 arch/x86/include/asm/page_types.h |    3 +++
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/page.h b/arch/x86/include/asm/page.h
index 8ca8283..d4ee8d8 100644
--- a/arch/x86/include/asm/page.h
+++ b/arch/x86/include/asm/page.h
@@ -1,8 +1,6 @@
 #ifndef _ASM_X86_PAGE_H
 #define _ASM_X86_PAGE_H
 
-#include <linux/types.h>
-
 #ifdef __KERNEL__
 
 #include <asm/page_types.h>
diff --git a/arch/x86/include/asm/page_types.h b/arch/x86/include/asm/page_types.h
index bce688d..eeff662 100644
--- a/arch/x86/include/asm/page_types.h
+++ b/arch/x86/include/asm/page_types.h
@@ -2,7 +2,10 @@
 #define _ASM_X86_PAGE_DEFS_H
 
 #include <linux/const.h>
+
+#ifndef __ASSEMBLY__
 #include <linux/types.h>
+#endif
 
 /* PAGE_SHIFT determines the page size */
 #define PAGE_SHIFT	12

