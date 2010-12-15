Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752804Ab0LOKjk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 05:39:40 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:46807 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752576Ab0LOKjj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 05:39:39 -0500
Message-Id: <E1PSolm-0008Tz-Cf@ZenIV.linux.org.uk>
Date: Wed, 15 Dec 2010 10:39:38 +0000
To: hans-christian.egtvedt@atmel.com
Subject: [PATCH 4/6] avr32: clear TIF_RESTORE_SIGMASK when signal is
 delivered...
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
 arch/avr32/kernel/signal.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/arch/avr32/kernel/signal.c b/arch/avr32/kernel/signal.c
index 25090d6..b9fa924 100644
--- a/arch/avr32/kernel/signal.c
+++ b/arch/avr32/kernel/signal.c
@@ -244,6 +244,10 @@ handle_signal(unsigned long sig, struct k_sigaction *ka, siginfo_t *info,
 		sigaddset(&current->blocked, sig);
 	recalc_sigpending();
 	spin_unlock_irq(&current->sighand->siglock);
+
+	/* mask saved on sigframe we'd set up */
+	clear_thread_flag(TIF_RESTORE_SIGMASK);
+
 	return;
 
 fail:
-- 
1.5.6.5


