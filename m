Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932079Ab1FJNJi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 09:09:38 -0400
Received: from grimli.r00tworld.net ([83.169.44.195]:43084 "EHLO
	mail.r00tworld.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757223Ab1FJNJf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 09:09:35 -0400
From: Mathias Krause <minipli@googlemail.com>
To: Yoshinori Sato <ysato@users.sourceforge.jp>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Mathias Krause <minipli@googlemail.com>
Subject: [PATCH] h8300, exec: remove redundant set_fs(USER_DS)
Date: Fri, 10 Jun 2011 15:09:34 +0200
Message-Id: <1307711374-7366-1-git-send-email-minipli@googlemail.com>
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
---
 arch/h8300/include/asm/processor.h |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/arch/h8300/include/asm/processor.h b/arch/h8300/include/asm/processor.h
index 69e8a34..e834b60 100644
--- a/arch/h8300/include/asm/processor.h
+++ b/arch/h8300/include/asm/processor.h
@@ -81,7 +81,6 @@ struct thread_struct {
 #if defined(__H8300H__)
 #define start_thread(_regs, _pc, _usp)			        \
 do {							        \
-	set_fs(USER_DS);           /* reads from user space */  \
   	(_regs)->pc = (_pc);				        \
 	(_regs)->ccr = 0x00;	   /* clear all flags */        \
 	(_regs)->er5 = current->mm->start_data;	/* GOT base */  \
@@ -91,7 +90,6 @@ do {							        \
 #if defined(__H8300S__)
 #define start_thread(_regs, _pc, _usp)			        \
 do {							        \
-	set_fs(USER_DS);           /* reads from user space */  \
 	(_regs)->pc = (_pc);				        \
 	(_regs)->ccr = 0x00;	   /* clear kernel flag */      \
 	(_regs)->exr = 0x78;       /* enable all interrupts */  \
-- 
1.5.6.5

