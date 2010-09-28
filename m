Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755880Ab0I1RuV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 13:50:21 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:53504 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755621Ab0I1RuT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 13:50:19 -0400
Date: Tue, 28 Sep 2010 18:50:17 +0100
To: ralf@linux-mips.org
Subject: [PATCH 1/5] mips: don't block signals if we'd failed setting
 sigframe up
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
User-Agent: Heirloom mailx 12.4 7/29/08
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <E1P0eJl-0006im-4g@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 arch/mips/kernel/signal.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/arch/mips/kernel/signal.c b/arch/mips/kernel/signal.c
index 2099d5a..b3273ae 100644
--- a/arch/mips/kernel/signal.c
+++ b/arch/mips/kernel/signal.c
@@ -575,6 +575,9 @@ static int handle_signal(unsigned long sig, siginfo_t *info,
 		ret = abi->setup_frame(vdso + abi->signal_return_offset,
 				       ka, regs, sig, oldset);
 
+	if (ret)
+		return ret;
+
 	spin_lock_irq(&current->sighand->siglock);
 	sigorsets(&current->blocked, &current->blocked, &ka->sa.sa_mask);
 	if (!(ka->sa.sa_flags & SA_NODEFER))
-- 
1.5.6.5


