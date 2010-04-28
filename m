Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752703Ab0D1KvG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 06:51:06 -0400
Received: from mail.gmx.net ([213.165.64.20]:52544 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752060Ab0D1KvE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 06:51:04 -0400
X-Authenticated: #15668376
X-Provags-ID: V01U2FsdGVkX1+QdYZkA1WQRfbi/Z6kjr7hbdkLB0wdCC5dDrvKLi
	GSYt+SGviQypZC
From: Peter Fritzsche <peter.fritzsche@gmx.de>
To: David Howells <dhowells@redhat.com>,
       Koichi Yasutake <yasutake.koichi@jp.panasonic.com>,
       Ingo Molnar <mingo@elte.hu>,
       Remis Lima Baima <remis.developer@googlemail.com>,
       Arnd Bergmann <arnd@arndb.de>, linux-am33-list@redhat.com,
       linux-kernel@vger.kernel.org,
       Keith M Wesolowski <wesolows@foobazco.org>
Cc: Peter Fritzsche <peter.fritzsche@gmx.de>
Subject: [PATCH 1/2] mn10300: Don't warn that atomic_t is only 24 bit
Date: Wed, 28 Apr 2010 12:50:37 +0200
Message-Id: <1272451837-17961-1-git-send-email-peter.fritzsche@gmx.de>
X-Mailer: git-send-email 1.7.1
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.55000000000000004
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

32-bit Sparc used to only allow usage of 24-bit of it's atomic_t type.
This was corrected with linux 2.6.3 when Keith M Wesolowski changed the
implementation to use the parisc approach of having an array of
spinlocks to protect the atomic_t.

These warnings were also removed from the sparc implementation when the
new implementation was merged in BKrev:402e4949VThdc6D3iaosSFUgabMfvw,
but the warning still remained in some other places without any
24-bit-only atomic_t implementation inside the kernel.

We should remove these warnings to allow users to rely on the full
32-bit range of atomic_t.

Signed-off-by: Peter Fritzsche <peter.fritzsche@gmx.de>
---
 This should correct the problem mentioned in http://lkml.org/lkml/2010/4/26/33

 arch/mn10300/include/asm/atomic.h |    8 ++------
 1 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/arch/mn10300/include/asm/atomic.h b/arch/mn10300/include/asm/atomic.h
index 5bf5be9..5b58ff8 100644
--- a/arch/mn10300/include/asm/atomic.h
+++ b/arch/mn10300/include/asm/atomic.h
@@ -28,8 +28,7 @@
  * atomic_read - read atomic variable
  * @v: pointer of type atomic_t
  *
- * Atomically reads the value of @v.  Note that the guaranteed
- * useful range of an atomic_t is only 24 bits.
+ * Atomically reads the value of @v.
  */
 #define atomic_read(v)	((v)->counter)
 
@@ -38,8 +37,7 @@
  * @v: pointer of type atomic_t
  * @i: required value
  *
- * Atomically sets the value of @v to @i.  Note that the guaranteed
- * useful range of an atomic_t is only 24 bits.
+ * Atomically sets the value of @v to @i.
  */
 #define atomic_set(v, i) (((v)->counter) = (i))
 
@@ -51,7 +49,6 @@
  * @v: pointer of type atomic_t
  *
  * Atomically adds @i to @v and returns the result
- * Note that the guaranteed useful range of an atomic_t is only 24 bits.
  */
 static inline int atomic_add_return(int i, atomic_t *v)
 {
@@ -73,7 +70,6 @@ static inline int atomic_add_return(int i, atomic_t *v)
  * @v: pointer of type atomic_t
  *
  * Atomically subtracts @i from @v and returns the result
- * Note that the guaranteed useful range of an atomic_t is only 24 bits.
  */
 static inline int atomic_sub_return(int i, atomic_t *v)
 {
-- 
1.7.1

