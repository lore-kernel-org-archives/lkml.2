Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932154Ab1FJNJx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 09:09:53 -0400
Received: from grimli.r00tworld.net ([83.169.44.195]:43140 "EHLO
	mail.r00tworld.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932127Ab1FJNJt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 09:09:49 -0400
From: Mathias Krause <minipli@googlemail.com>
To: Hirokazu Takata <takata@linux-m32r.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-m32r@ml.linux-m32r.org, linux-kernel@vger.kernel.org,
        Mathias Krause <minipli@googlemail.com>
Subject: [PATCH] m32r, exec: remove redundant set_fs(USER_DS)
Date: Fri, 10 Jun 2011 15:09:48 +0200
Message-Id: <1307711388-7739-1-git-send-email-minipli@googlemail.com>
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
 arch/m32r/include/asm/processor.h |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/m32r/include/asm/processor.h b/arch/m32r/include/asm/processor.h
index 8397c24..e1f46d7 100644
--- a/arch/m32r/include/asm/processor.h
+++ b/arch/m32r/include/asm/processor.h
@@ -106,7 +106,6 @@ struct thread_struct {
 
 #define start_thread(regs, new_pc, new_spu) 				\
 	do {								\
-		set_fs(USER_DS); 					\
 		regs->psw = (regs->psw | USERPS_BPSW) & 0x0000FFFFUL;	\
 		regs->bpc = new_pc;					\
 		regs->spu = new_spu;					\
-- 
1.5.6.5

