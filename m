Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965058Ab2CLXo4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 19:44:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18792 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964858Ab2CLXjI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 19:39:08 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 17/35] Make asm-generic/cmpxchg.h #include
 asm-generic/cmpxchg-local.h [ver #2]
To: paul.gortmaker@windriver.com, hpa@zytor.com
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, arnd@arndb.de,
        David Howells <dhowells@redhat.com>, Arnd Bergmann <arnd@arndb.de>
Date: Mon, 12 Mar 2012 23:38:58 +0000
Message-ID: <20120312233858.13888.34822.stgit@warthog.procyon.org.uk>
In-Reply-To: <20120312233602.13888.27659.stgit@warthog.procyon.org.uk>
References: <20120312233602.13888.27659.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make asm-generic/cmpxchg.h #include asm-generic/cmpxchg-local.h as all arch
files that #include the former also #include the latter.  See:

	grep -rl asm-generic/cmpxchg-local[.]h arch/ | sort > b
	grep -rl asm-generic/cmpxchg[.]h arch/ | sort > a
	comm a b

This simplifies the disintegration of asm-generic/system.h for arches that
don't have their own.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Arnd Bergmann <arnd@arndb.de>
---

 include/asm-generic/cmpxchg.h |    2 ++
 include/asm-generic/system.h  |    1 -
 2 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/include/asm-generic/cmpxchg.h b/include/asm-generic/cmpxchg.h
index 213ac6e..e0449af 100644
--- a/include/asm-generic/cmpxchg.h
+++ b/include/asm-generic/cmpxchg.h
@@ -10,6 +10,8 @@
 #error "Cannot use generic cmpxchg on SMP"
 #endif
 
+#include <asm-generic/cmpxchg-local.h>
+
 /*
  * Atomic compare and exchange.
  *
diff --git a/include/asm-generic/system.h b/include/asm-generic/system.h
index 215efa7..82cb53a 100644
--- a/include/asm-generic/system.h
+++ b/include/asm-generic/system.h
@@ -19,7 +19,6 @@
 #include <linux/types.h>
 #include <linux/irqflags.h>
 
-#include <asm/cmpxchg-local.h>
 #include <asm/cmpxchg.h>
 
 struct task_struct;

