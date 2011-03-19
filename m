Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756370Ab1CSPxg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Mar 2011 11:53:36 -0400
Received: from 206.83.70.73.ptr.us.xo.net ([206.83.70.73]:11944 "EHLO
	king.tilera.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754778Ab1CSPxe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Mar 2011 11:53:34 -0400
Message-Id: <201103191553.p2JFrWG9010986@farm-0023.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Sat, 19 Mar 2011 11:45:34 -0400
Subject: [PATCH] arch/tile: fix futex sanitization definition/prototype mismatch
To: linux-kernel@vger.kernel.org
To: Michel Lespinasse <walken@google.com>
X-OriginalArrivalTime: 19 Mar 2011 15:53:33.0418 (UTC) FILETIME=[CCDE44A0:01CBE64D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 8d7718aa082aaf30a0b4989e1f04858952f941bc changed "int"
to "u32" in the prototypes but not the definition.
I missed this when I saw the patch go by on LKML.

We cast "u32 *" to "int *" since we are tying into the underlying
atomics framework, and atomic_t uses int as its value type.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/lib/atomic_32.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/tile/lib/atomic_32.c b/arch/tile/lib/atomic_32.c
index f02040d..4657021 100644
--- a/arch/tile/lib/atomic_32.c
+++ b/arch/tile/lib/atomic_32.c
@@ -202,32 +202,32 @@ static inline int *__futex_setup(int __user *v)
 	return __atomic_hashed_lock((int __force *)v);
 }
 
-struct __get_user futex_set(int __user *v, int i)
+struct __get_user futex_set(u32 __user *v, int i)
 {
 	return __atomic_xchg((int __force *)v, __futex_setup(v), i);
 }
 
-struct __get_user futex_add(int __user *v, int n)
+struct __get_user futex_add(u32 __user *v, int n)
 {
 	return __atomic_xchg_add((int __force *)v, __futex_setup(v), n);
 }
 
-struct __get_user futex_or(int __user *v, int n)
+struct __get_user futex_or(u32 __user *v, int n)
 {
 	return __atomic_or((int __force *)v, __futex_setup(v), n);
 }
 
-struct __get_user futex_andn(int __user *v, int n)
+struct __get_user futex_andn(u32 __user *v, int n)
 {
 	return __atomic_andn((int __force *)v, __futex_setup(v), n);
 }
 
-struct __get_user futex_xor(int __user *v, int n)
+struct __get_user futex_xor(u32 __user *v, int n)
 {
 	return __atomic_xor((int __force *)v, __futex_setup(v), n);
 }
 
-struct __get_user futex_cmpxchg(int __user *v, int o, int n)
+struct __get_user futex_cmpxchg(u32 __user *v, int o, int n)
 {
 	return __atomic_cmpxchg((int __force *)v, __futex_setup(v), o, n);
 }
-- 
1.6.5.2

