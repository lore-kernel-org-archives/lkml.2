Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757323Ab1FJNJY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 09:09:24 -0400
Received: from grimli.r00tworld.net ([83.169.44.195]:43051 "EHLO
	mail.r00tworld.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757221Ab1FJNJW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 09:09:22 -0400
From: Mathias Krause <minipli@googlemail.com>
To: Mikael Starvik <starvik@axis.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-cris-kernel@axis.com, linux-kernel@vger.kernel.org,
        Mathias Krause <minipli@googlemail.com>,
        Jesper Nilsson <jesper.nilsson@axis.com>
Subject: [PATCH] cris, exec: remove redundant set_fs(USER_DS)
Date: Fri, 10 Jun 2011 15:09:21 +0200
Message-Id: <1307711361-6112-1-git-send-email-minipli@googlemail.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <BANLkTinv1teZEHMK0qymaVdcxPOErpqSyg@mail.gmail.com>
References: <BANLkTinv1teZEHMK0qymaVdcxPOErpqSyg@mail.gmail.com>
References: <BANLkTiknCeAxe30MJdVTxDom+ko8+EDQ4A@mail.gmail.com> <1307642718-22257-1-git-send-email-minipli@googlemail.com> <20110609155630.0f734351.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The address limit is already set in flush_old_exec() so those calls to
set_fs(USER_DS) are redundant.

Signed-off-by: Mathias Krause <minipli@googlemail.com>
Cc: Jesper Nilsson <jesper.nilsson@axis.com>
---
 arch/cris/include/arch-v10/arch/processor.h |    1 -
 arch/cris/include/arch-v32/arch/processor.h |    1 -
 2 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/arch/cris/include/arch-v10/arch/processor.h b/arch/cris/include/arch-v10/arch/processor.h
index cc692c7..93feb2a 100644
--- a/arch/cris/include/arch-v10/arch/processor.h
+++ b/arch/cris/include/arch-v10/arch/processor.h
@@ -53,7 +53,6 @@ struct thread_struct {
  */
 
 #define start_thread(regs, ip, usp) do { \
-	set_fs(USER_DS);      \
 	regs->irp = ip;       \
 	regs->dccr |= 1 << U_DCCR_BITNR; \
 	wrusp(usp);           \
diff --git a/arch/cris/include/arch-v32/arch/processor.h b/arch/cris/include/arch-v32/arch/processor.h
index f80b477..9603c90 100644
--- a/arch/cris/include/arch-v32/arch/processor.h
+++ b/arch/cris/include/arch-v32/arch/processor.h
@@ -47,7 +47,6 @@ struct thread_struct {
  */
 #define start_thread(regs, ip, usp) \
 do { \
-	set_fs(USER_DS); \
 	regs->erp = ip; \
 	regs->ccs |= 1 << (U_CCS_BITNR + CCS_SHIFT); \
 	wrusp(usp); \
-- 
1.5.6.5

