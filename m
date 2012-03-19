Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162309Ab2CSRMe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 13:12:34 -0400
Received: from mail-we0-f194.google.com ([74.125.82.194]:33411 "EHLO
	mail-we0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162298Ab2CSRMd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 13:12:33 -0400
Date: Mon, 19 Mar 2012 18:12:29 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/process change for v3.4
Message-ID: <20120319171229.GA14978@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-process-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-process-for-linus

   HEAD: 42dfc43ee5999ac64284476ea0ac6c937587cf2b x86_64: Record stack pointer before task execution begins

 Thanks,

	Ingo

------------------>
Siddhesh Poyarekar (1):
      x86_64: Record stack pointer before task execution begins


 arch/x86/kernel/process_64.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index 1fd94bc..eb54dd0 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -341,6 +341,7 @@ start_thread_common(struct pt_regs *regs, unsigned long new_ip,
 	loadsegment(es, _ds);
 	loadsegment(ds, _ds);
 	load_gs_index(0);
+	current->thread.usersp	= new_sp;
 	regs->ip		= new_ip;
 	regs->sp		= new_sp;
 	percpu_write(old_rsp, new_sp);
