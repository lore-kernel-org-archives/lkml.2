Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757309Ab1FJNJA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 09:09:00 -0400
Received: from grimli.r00tworld.net ([83.169.44.195]:42914 "EHLO
	mail.r00tworld.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757223Ab1FJNI6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 09:08:58 -0400
From: Mathias Krause <minipli@googlemail.com>
To: Russell King <linux@arm.linux.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Mathias Krause <minipli@googlemail.com>
Subject: [PATCH] arm, exec: remove redundant set_fs(USER_DS)
Date: Fri, 10 Jun 2011 15:08:57 +0200
Message-Id: <1307711337-4042-1-git-send-email-minipli@googlemail.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <BANLkTinv1teZEHMK0qymaVdcxPOErpqSyg@mail.gmail.com>
References: <BANLkTinv1teZEHMK0qymaVdcxPOErpqSyg@mail.gmail.com>
References: <BANLkTiknCeAxe30MJdVTxDom+ko8+EDQ4A@mail.gmail.com> <1307642718-22257-1-git-send-email-minipli@googlemail.com> <20110609155630.0f734351.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The address limit is already set in flush_old_exec() so this
set_fs(USER_DS) is redundant.

Signed-off-by: Mathias Krause <minipli@googlemail.com>
---
 arch/arm/include/asm/processor.h |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/arm/include/asm/processor.h b/arch/arm/include/asm/processor.h
index b2d9df5..3962caf 100644
--- a/arch/arm/include/asm/processor.h
+++ b/arch/arm/include/asm/processor.h
@@ -55,7 +55,6 @@ struct thread_struct {
 #define start_thread(regs,pc,sp)					\
 ({									\
 	unsigned long *stack = (unsigned long *)sp;			\
-	set_fs(USER_DS);						\
 	memset(regs->uregs, 0, sizeof(regs->uregs));			\
 	if (current->personality & ADDR_LIMIT_32BIT)			\
 		regs->ARM_cpsr = USR_MODE;				\
-- 
1.5.6.5

