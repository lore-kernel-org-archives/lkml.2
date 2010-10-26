Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932460Ab0JZCyd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 22:54:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1029 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932398Ab0JZCy1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 22:54:27 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH 03/43] bitops: Change the bitmap index from int to unsigned
 long [mn10300]
To: linux-am33-list@redhat.com
From: David Howells <dhowells@redhat.com>
Cc: Justin Chen <justin.chen@hp.com>, linux-kernel@vger.kernel.org,
        Bjorn Helgaas <bjorn.helgaas@hp.com>
Date: Tue, 26 Oct 2010 03:53:18 +0100
Message-ID: <20101026025318.23512.1067.stgit@warthog.procyon.org.uk>
In-Reply-To: <20101026025301.23512.24525.stgit@warthog.procyon.org.uk>
References: <20101026025301.23512.24525.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.15-97-g9680-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Justin Chen <jchen@hpdst41.cup.hp.com>

Change the index to unsigned long in all bitops for [mn10300]

Signed-off-by: Justin Chen <justin.chen@hp.com>
Reviewed-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
Signed-off-by: David Howells <dhowells@redhat.com>
---

 arch/mn10300/include/asm/bitops.h |   12 ++++++------
 arch/mn10300/lib/bitops.c         |    4 ++--
 2 files changed, 8 insertions(+), 8 deletions(-)


diff --git a/arch/mn10300/include/asm/bitops.h b/arch/mn10300/include/asm/bitops.h
index 3f50e96..6208ea6 100644
--- a/arch/mn10300/include/asm/bitops.h
+++ b/arch/mn10300/include/asm/bitops.h
@@ -57,7 +57,7 @@
 #define clear_bit(nr, addr) ___clear_bit((nr), (addr))
 
 
-static inline void __clear_bit(int nr, volatile void *addr)
+static inline void __clear_bit(unsigned long nr, volatile void *addr)
 {
 	unsigned int *a = (unsigned int *) addr;
 	int mask;
@@ -70,7 +70,7 @@ static inline void __clear_bit(int nr, volatile void *addr)
 /*
  * test bit
  */
-static inline int test_bit(int nr, const volatile void *addr)
+static inline int test_bit(unsigned long nr, const volatile void *addr)
 {
 	return 1UL & (((const unsigned int *) addr)[nr >> 5] >> (nr & 31));
 }
@@ -78,7 +78,7 @@ static inline int test_bit(int nr, const volatile void *addr)
 /*
  * change bit
  */
-static inline void __change_bit(int nr, volatile void *addr)
+static inline void __change_bit(unsigned long nr, volatile void *addr)
 {
 	int	mask;
 	unsigned int *a = (unsigned int *) addr;
@@ -88,7 +88,7 @@ static inline void __change_bit(int nr, volatile void *addr)
 	*a ^= mask;
 }
 
-extern void change_bit(int nr, volatile void *addr);
+extern void change_bit(unsigned long nr, volatile void *addr);
 
 /*
  * test and set bit
@@ -135,7 +135,7 @@ extern void change_bit(int nr, volatile void *addr);
 /*
  * test and change bit
  */
-static inline int __test_and_change_bit(int nr, volatile void *addr)
+static inline int __test_and_change_bit(unsigned long nr, volatile void *addr)
 {
 	int	mask, retval;
 	unsigned int *a = (unsigned int *)addr;
@@ -148,7 +148,7 @@ static inline int __test_and_change_bit(int nr, volatile void *addr)
 	return retval;
 }
 
-extern int test_and_change_bit(int nr, volatile void *addr);
+extern int test_and_change_bit(unsigned long nr, volatile void *addr);
 
 #include <asm-generic/bitops/lock.h>
 
diff --git a/arch/mn10300/lib/bitops.c b/arch/mn10300/lib/bitops.c
index 440a7dc..a66c6cd 100644
--- a/arch/mn10300/lib/bitops.c
+++ b/arch/mn10300/lib/bitops.c
@@ -15,7 +15,7 @@
 /*
  * try flipping a bit using BSET and BCLR
  */
-void change_bit(int nr, volatile void *addr)
+void change_bit(unsigned long nr, volatile void *addr)
 {
 	if (test_bit(nr, addr))
 		goto try_clear_bit;
@@ -34,7 +34,7 @@ try_clear_bit:
 /*
  * try flipping a bit using BSET and BCLR and returning the old value
  */
-int test_and_change_bit(int nr, volatile void *addr)
+int test_and_change_bit(unsigned long nr, volatile void *addr)
 {
 	if (test_bit(nr, addr))
 		goto try_clear_bit;

