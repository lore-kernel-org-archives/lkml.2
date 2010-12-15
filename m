Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752591Ab0LOKjL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 05:39:11 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:46801 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752164Ab0LOKjK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 05:39:10 -0500
Message-Id: <E1PSolI-0008TX-Bx@ZenIV.linux.org.uk>
Date: Wed, 15 Dec 2010 10:39:08 +0000
To: hans-christian.egtvedt@atmel.com
Subject: [PATCH 1/6] avr32: missed _TIF_NOTIFY_RESUME on one of
 do_notify_resume callers
Cc: linux-kernel@vger.kernel.org
User-Agent: Heirloom mailx 12.5 7/5/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Al Viro <viro@ftp.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


we need that not just on syscall returns but on irq ones as well...

Acked-by: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 arch/avr32/kernel/entry-avr32b.S |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/avr32/kernel/entry-avr32b.S b/arch/avr32/kernel/entry-avr32b.S
index 169268c..5e6beb2 100644
--- a/arch/avr32/kernel/entry-avr32b.S
+++ b/arch/avr32/kernel/entry-avr32b.S
@@ -587,7 +587,7 @@ fault_exit_work:
 	ld.w	r1, r0[TI_flags]
 	rjmp	fault_exit_work
 
-1:	mov	r2, _TIF_SIGPENDING | _TIF_RESTORE_SIGMASK
+1:	mov	r2, _TIF_SIGPENDING | _TIF_RESTORE_SIGMASK | _TIF_NOTIFY_RESUME
 	tst	r1, r2
 	breq	2f
 	unmask_interrupts
-- 
1.5.6.5


