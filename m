Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753009Ab1GaA5c (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jul 2011 20:57:32 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:54008 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752397Ab1GaA50 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jul 2011 20:57:26 -0400
MIME-Version: 1.0
Date: Sun, 31 Jul 2011 08:57:25 +0800
Message-ID: <CAJd=RBB7sJC1cJCKRzzSuM5JgST3nF18g9vG7BQoLT=0iWmSBg@mail.gmail.com>
Subject: [PATCH] MIPS: minor cleanups for octeon
From: Hillf Danton <dhillf@gmail.com>
To: Ralf Baechle <ralf@linux-mips.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is just cleanup for two cases in the code, then it looks not ugly enough.

Signed-off-by: Hillf Danton <dhillf@gmail.com>
---
 arch/mips/include/asm/octeon/cvmx.h |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/mips/include/asm/octeon/cvmx.h
b/arch/mips/include/asm/octeon/cvmx.h
index 7e12867..e314c26 100644
--- a/arch/mips/include/asm/octeon/cvmx.h
+++ b/arch/mips/include/asm/octeon/cvmx.h
@@ -88,7 +88,8 @@ static inline uint32_t cvmx_get_proc_id(void)
  *
  * @bits:   Number of bits in the mask
  * Returns The mask
- */ static inline uint64_t cvmx_build_mask(uint64_t bits)
+ */
+static inline uint64_t cvmx_build_mask(uint64_t bits)
 {
 	return ~((~0x0ull) << bits);
 }
@@ -412,8 +413,7 @@ static inline uint64_t cvmx_get_cycle_global(void)
  * 3) If #2 isn't true loop to #1 unless too much time has passed.
  */
 #define CVMX_WAIT_FOR_FIELD64(address, type, field, op, value, timeout_usec)\
-    (									\
-{									\
+({									\
 	int result;							\
 	do {								\
 		uint64_t done = cvmx_get_cycle() + (uint64_t)timeout_usec * \
