Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756323Ab1KHTI1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 14:08:27 -0500
Received: from smtp-outbound-2.vmware.com ([65.115.85.73]:37446 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753211Ab1KHTI0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 14:08:26 -0500
From: Andrei Warkentin <andreiw@vmware.com>
To: linux-kernel@vger.kernel.org
Cc: Andrei Warkentin <andreiw@vmware.com>
Subject: [PATCH] include/log2.h: Fix rounddown_pow_of_two(1)
Date: Tue,  8 Nov 2011 14:08:15 -0500
Message-Id: <1320779295-17111-1-git-send-email-andreiw@vmware.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

1 is a power of two, therefore rounddown_pow_of_two(1) should return 1. It does
in case the argument is a variable but in case it's a constant it behaves
wrong and returns 0. Probably nobody ever did it so this was never noticed,
however net/drivers/vmxnet3 with latest GCC does and breaks on unicpu systems.

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

