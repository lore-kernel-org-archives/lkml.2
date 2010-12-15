Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752830Ab0LOKju (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 05:39:50 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:46809 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752682Ab0LOKjt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 05:39:49 -0500
Message-Id: <E1PSolw-0008U6-Cr@ZenIV.linux.org.uk>
Date: Wed, 15 Dec 2010 10:39:48 +0000
To: hans-christian.egtvedt@atmel.com
Subject: [PATCH 5/6] avr32: need to reset ->restart_block.fn on sigreturn
Cc: linux-kernel@vger.kernel.org
User-Agent: Heirloom mailx 12.5 7/5/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Al Viro <viro@ftp.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Acked-by: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 arch/avr32/kernel/signal.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/arch/avr32/kernel/signal.c b/arch/avr32/kernel/signal.c
index b9fa924..3b4bb5a 100644
--- a/arch/avr32/kernel/signal.c
+++ b/arch/avr32/kernel/signal.c
@@ -42,6 +42,9 @@ restore_sigcontext(struct pt_regs *regs, struct sigcontext __user *sc)
 {
 	int err = 0;
 
+	/* Always make any pending restarted system calls return -EINTR */
+	current_thread_info()->restart_block.fn = do_no_restart_syscall;
+
 #define COPY(x)		err |= __get_user(regs->x, &sc->x)
 	COPY(sr);
 	COPY(pc);
-- 
1.5.6.5


