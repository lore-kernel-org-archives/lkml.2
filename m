Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758057Ab0IZS2y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Sep 2010 14:28:54 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:50377 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758036Ab0IZS2w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Sep 2010 14:28:52 -0400
Date: Sun, 26 Sep 2010 19:28:52 +0100
To: linux-kernel@vger.kernel.org
Subject: [PATCH 3/5] mn10300: ->restart_block.fn needs to be reset on
 sigreturn
Cc: dhowells@redhat.com, torvalds@linux-foundation.org
User-Agent: Heirloom mailx 12.4 7/29/08
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <E1Ozvy0-0002pG-7r@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 arch/mn10300/kernel/signal.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/arch/mn10300/kernel/signal.c b/arch/mn10300/kernel/signal.c
index 4ef9925..5a2c004 100644
--- a/arch/mn10300/kernel/signal.c
+++ b/arch/mn10300/kernel/signal.c
@@ -102,6 +102,9 @@ static int restore_sigcontext(struct pt_regs *regs,
 {
 	unsigned int err = 0;
 
+	/* Always make any pending restarted system calls return -EINTR */
+	current_thread_info()->restart_block.fn = do_no_restart_syscall;
+
 	if (is_using_fpu(current))
 		fpu_kill_state(current);
 
-- 
1.5.6.5

