Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757869Ab2CAHKP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 02:10:15 -0500
Received: from ozlabs.org ([203.10.76.45]:41200 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756495Ab2CAHKN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 02:10:13 -0500
Date: Thu, 1 Mar 2012 18:09:53 +1100
From: Anton Blanchard <anton@samba.org>
To: benh@kernel.crashing.org, paulus@samba.org, akpm@linux-foundation.org,
        asharma@fb.com, vapier@gentoo.org, eric.dumazet@gmail.com,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] atomic: Allow atomic_inc_not_zero to be overridden
Message-ID: <20120301180953.0f61576f@kryten>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.24.4; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


We want to implement a ppc64 specific version of atomic_inc_not_zero
so wrap it in an ifdef to allow it to be overridden.

Signed-off-by: Anton Blanchard <anton@samba.org>
---

Index: linux-build/include/linux/atomic.h
===================================================================
--- linux-build.orig/include/linux/atomic.h	2012-02-11 14:59:23.284714257 +1100
+++ linux-build/include/linux/atomic.h	2012-02-11 15:01:14.894764555 +1100
@@ -24,7 +24,9 @@ static inline int atomic_add_unless(atom
  * Atomically increments @v by 1, so long as @v is non-zero.
  * Returns non-zero if @v was non-zero, and zero otherwise.
  */
+#ifndef atomic_inc_not_zero
 #define atomic_inc_not_zero(v)		atomic_add_unless((v), 1, 0)
+#endif
 
 /**
  * atomic_inc_not_zero_hint - increment if not null
