Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751629Ab2ALFLz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 00:11:55 -0500
Received: from seven.medozas.de ([188.40.89.202]:34608 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751003Ab2ALFLy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 00:11:54 -0500
From: Jan Engelhardt <jengelh@medozas.de>
To: paulmck@linux.vnet.ibm.com
Cc: laijs@cn.fujitsu.com, manfred@colorfullife.com, dhowells@redhat.com,
        josh@joshtriplett.org, linux-kernel@vger.kernel.org,
        jengelh@medozas.de
Subject: [PATCH] rcu: avoid checking for constant
Date: Thu, 12 Jan 2012 06:11:44 +0100
Message-Id: <1326345104-6919-1-git-send-email-jengelh@medozas.de>
X-Mailer: git-send-email 1.7.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When compiling kernel or module code with -O0, "offset" is no longer
considered a constant, and therefore always triggers the build error
that BUILD_BUG_ON is defined to yield.

What is the rationale between the forced constant check,
introduced in 9ab1544eb4196ca8d05c433b2eb56f74496b1ee3?

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 include/linux/rcupdate.h |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 2cf4226..38c5ba5 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -805,8 +805,6 @@ void __kfree_rcu(struct rcu_head *head, unsigned long offset)
 {
 	typedef void (*rcu_callback)(struct rcu_head *);
 
-	BUILD_BUG_ON(!__builtin_constant_p(offset));
-
 	/* See the kfree_rcu() header comment. */
 	BUILD_BUG_ON(!__is_kfree_rcu_offset(offset));
 
-- 
1.7.7

