Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752254Ab2DAN0y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2012 09:26:54 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:39514 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751954Ab2DAN0v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2012 09:26:51 -0400
Subject: [PATCH] x86: v3.4-rc1 s2ram regression
To: x86@kernel.org, linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Marcelo Tosatti <mtosatti@redhat.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Ingo Molnar <mingo@redhat.com>, Avi Kivity <avi@redhat.com>,
        Pavel Machek <pavel@ucw.cz>, "H. Peter Anvin" <hpa@zytor.com>,
        Igor Mammedov <imammedo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
Date: Sun, 01 Apr 2012 17:26:43 +0400
Message-ID: <20120401132643.4922.79748.stgit@zurg>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit b74f05d61b73af584d0c39121980171389ecfaaa
("x86: kvmclock: abstract save/restore sched_clock_state")
breaks s2ram for my notebook. It hangs (maybe panic) somewhere on resume stage
and blinks with all possible leds =) Screen is black, so I don't know what happened.

reverting or following patch helps

Bisected-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Avi Kivity <avi@redhat.com>
Cc: Igor Mammedov <imammedo@redhat.com>
---
 arch/x86/power/cpu.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/power/cpu.c b/arch/x86/power/cpu.c
index 4793683..2bc5a82 100644
--- a/arch/x86/power/cpu.c
+++ b/arch/x86/power/cpu.c
@@ -231,8 +231,8 @@ static void __restore_processor_state(struct saved_context *ctxt)
 /* Needed by apm.c */
 void restore_processor_state(void)
 {
-	x86_platform.restore_sched_clock_state();
 	__restore_processor_state(&saved_context);
+	x86_platform.restore_sched_clock_state();
 }
 #ifdef CONFIG_X86_32
 EXPORT_SYMBOL(restore_processor_state);

