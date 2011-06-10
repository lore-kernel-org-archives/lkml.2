Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757437Ab1FJNKQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 09:10:16 -0400
Received: from grimli.r00tworld.net ([83.169.44.195]:43178 "EHLO
	mail.r00tworld.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757223Ab1FJNKA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 09:10:00 -0400
From: Mathias Krause <minipli@googlemail.com>
To: Michal Simek <monstr@monstr.eu>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        microblaze-uclinux@itee.uq.edu.au, linux-kernel@vger.kernel.org,
        Mathias Krause <minipli@googlemail.com>
Subject: [PATCH] microblaze, exec: remove redundant set_fs(USER_DS)
Date: Fri, 10 Jun 2011 15:09:59 +0200
Message-Id: <1307711399-7929-1-git-send-email-minipli@googlemail.com>
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
 arch/microblaze/kernel/process.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/microblaze/kernel/process.c b/arch/microblaze/kernel/process.c
index 968648a..dbb8124 100644
--- a/arch/microblaze/kernel/process.c
+++ b/arch/microblaze/kernel/process.c
@@ -237,7 +237,6 @@ unsigned long get_wchan(struct task_struct *p)
 /* Set up a thread for executing a new program */
 void start_thread(struct pt_regs *regs, unsigned long pc, unsigned long usp)
 {
-	set_fs(USER_DS);
 	regs->pc = pc;
 	regs->r1 = usp;
 	regs->pt_mode = 0;
-- 
1.5.6.5

