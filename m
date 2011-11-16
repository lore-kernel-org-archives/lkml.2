Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753107Ab1KPT4X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 14:56:23 -0500
Received: from smtp-outbound-2.vmware.com ([65.115.85.73]:25277 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751907Ab1KPT4W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 14:56:22 -0500
From: Andrei Warkentin <andreiw@vmware.com>
To: linux-kernel@vger.kernel.org
Cc: Andrei Warkentin <andreiw@vmware.com>,
        Rolf Eike Beer <eike-kernel@sf-tec.de>, opensuse-kernel@opensuse.org
Subject: [PATCH] include/log2.h: Fix rounddown_pow_of_two(1)
Date: Wed, 16 Nov 2011 14:56:06 -0500
Message-Id: <1321473366-31053-1-git-send-email-andreiw@vmware.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

1 is a power of two, therefore rounddown_pow_of_two(1) should return 1. It does
in case the argument is a variable but in case it's a constant it behaves
wrong and returns 0. Probably nobody ever did it so this was never noticed,
however net/drivers/vmxnet3 with latest GCC does and breaks on unicpu systems.

This is similar to Rolf's patch to roundup_pow_of_two(1).

Cc: Rolf Eike Beer <eike-kernel@sf-tec.de>
Cc: opensuse-kernel@opensuse.org
Reviewed-by: Jesper Juhl <jj@chaosbits.net>
Signed-off-by: Andrei Warkentin <andreiw@vmware.com>
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

