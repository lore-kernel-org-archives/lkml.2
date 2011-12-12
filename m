Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753827Ab1LLSDA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 13:03:00 -0500
Received: from smtp-outbound-2.vmware.com ([65.115.85.73]:59107 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753779Ab1LLSC5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 13:02:57 -0500
From: Dmitry Torokhov <dtor@vmware.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        pv-drivers@vmware.com, Andrei Warkentin <andreiw@vmware.com>,
        stable@kernel.org, Dmitry Torokhov <dtor@vmware.com>
Subject: [PATCH] include/log2.h: Fix rounddown_pow_of_two(1)
Date: Mon, 12 Dec 2011 10:02:33 -0800
Message-Id: <1323712953-13636-1-git-send-email-dtor@vmware.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrei Warkentin <andreiw@vmware.com>

1 is a power of two, therefore rounddown_pow_of_two(1) should return 1.
It does in case the argument is a variable but in case it's a constant
it behaves incorrectly and returns 0. Probably nobody ever did it so
this was never noticed, however drivers/net/vmxnet3 with latest GCC does
and breaks on unicpu systems.

This is similar to Rolf's patch to roundup_pow_of_two(1).

Signed-off-by: Andrei Warkentin <andreiw@vmware.com>
Reviewed-by: Jesper Juhl <jj@chaosbits.net>
Reviewed-by: Rolf Eike Beer <eike-kernel@sf-tec.de>
Cc: stable@kernel.org
Signed-off-by: Dmitry Torokhov <dtor@vmware.com>
---
 include/linux/log2.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/log2.h b/include/linux/log2.h
index 25b8086..ccda848 100644
--- a/include/linux/log2.h
+++ b/include/linux/log2.h
@@ -185,7 +185,7 @@ unsigned long __rounddown_pow_of_two(unsigned long n)
 #define rounddown_pow_of_two(n)			\
 (						\
 	__builtin_constant_p(n) ? (		\
-		(n == 1) ? 0 :			\
+		(n == 1) ? 1 :			\
 		(1UL << ilog2(n))) :		\
 	__rounddown_pow_of_two(n)		\
  )
-- 
1.7.4.1

