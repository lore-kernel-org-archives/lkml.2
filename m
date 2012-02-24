Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932222Ab2BXAGR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 19:06:17 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:48593 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757542Ab2BXAGL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 19:06:11 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of gregkh@linuxfoundation.org designates 10.68.204.7 as permitted sender) smtp.mail=gregkh@linuxfoundation.org
MIME-Version: 1.0
Message-Id: <20120224000220.411457302@linuxfoundation.org>
User-Agent: quilt/0.51-15.1
Date: Thu, 23 Feb 2012 16:02:21 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk
Subject: [ 01/10] i387: math_state_restore() isnt called from asm
In-Reply-To: <20120224000510.GA1005@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linus Torvalds <torvalds@linux-foundation.org>

commit be98c2cdb15ba26148cd2bd58a857d4f7759ed38 upstream.

It was marked asmlinkage for some really old and stale legacy reasons.
Fix that and the equally stale comment.

Noticed when debugging the irq_fpu_usable() bugs.

Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/include/asm/i387.h |    2 +-
 arch/x86/kernel/traps.c     |    6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

--- a/arch/x86/include/asm/i387.h
+++ b/arch/x86/include/asm/i387.h
@@ -29,7 +29,7 @@ extern unsigned int sig_xstate_size;
 extern void fpu_init(void);
 extern void mxcsr_feature_mask_init(void);
 extern int init_fpu(struct task_struct *child);
-extern asmlinkage void math_state_restore(void);
+extern void math_state_restore(void);
 extern void __math_state_restore(void);
 extern int dump_fpu(struct pt_regs *, struct user_i387_struct *);
 
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -590,10 +590,10 @@ void __math_state_restore(void)
  * Careful.. There are problems with IBM-designed IRQ13 behaviour.
  * Don't touch unless you *really* know how it works.
  *
- * Must be called with kernel preemption disabled (in this case,
- * local interrupts are disabled at the call-site in entry.S).
+ * Must be called with kernel preemption disabled (eg with local
+ * local interrupts as in the case of do_device_not_available).
  */
-asmlinkage void math_state_restore(void)
+void math_state_restore(void)
 {
 	struct thread_info *thread = current_thread_info();
 	struct task_struct *tsk = thread->task;


