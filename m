Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752976Ab1HQAGS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Aug 2011 20:06:18 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:47075 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752485Ab1HQAGR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Aug 2011 20:06:17 -0400
From: Kevin Winchester <kjwinchester@gmail.com>
To: jbaron@redhat.com, rostedt@goodmis.org, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com
Cc: Kevin Winchester <kjwinchester@gmail.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] x86: jump_label: arch_jump_label_text_poke_early: add missing __init
Date: Tue, 16 Aug 2011 21:04:38 -0300
Message-Id: <1313539478-30303-1-git-send-email-kjwinchester@gmail.com>
X-Mailer: git-send-email 1.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

arch_jump_label_text_poke_early calls text_poke_early, which is
an __init function.  Thus arch_jump_label_text_poke_early should
be the same.

Signed-off-by: Kevin Winchester <kjwinchester@gmail.com>
---
 arch/x86/kernel/jump_label.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/jump_label.c b/arch/x86/kernel/jump_label.c
index 3fee346..5b3dbf7 100644
--- a/arch/x86/kernel/jump_label.c
+++ b/arch/x86/kernel/jump_label.c
@@ -42,7 +42,7 @@ void arch_jump_label_transform(struct jump_entry *entry,
 	put_online_cpus();
 }
 
-void arch_jump_label_text_poke_early(jump_label_t addr)
+void __init arch_jump_label_text_poke_early(jump_label_t addr)
 {
 	text_poke_early((void *)addr, ideal_nops[NOP_ATOMIC5],
 			JUMP_LABEL_NOP_SIZE);
-- 
1.7.6

