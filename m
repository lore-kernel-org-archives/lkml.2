Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755460Ab1IOIiS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 04:38:18 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:34707 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755180Ab1IOIiR convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@suse.com:4:1>);
	Thu, 15 Sep 2011 04:38:17 -0400
Message-Id: <4E71D59702000078000563D1@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Thu, 15 Sep 2011 09:38:15 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: "Andy Lutomirski" <luto@MIT.EDU>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86-64: add default case to emulate_vsyscall() to
	 silence compiler warning
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

... since the compiler can't possibly know that vsyscall_nr is limited
to three values, and hence 'ret' must appear possibly uninitialized to
it.

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Cc: Andy Lutomirski <luto@mit.edu>

---
 arch/x86/kernel/vsyscall_64.c |    3 +++
 1 file changed, 3 insertions(+)

--- 3.1-rc6/arch/x86/kernel/vsyscall_64.c
+++ 3.1-rc6-x86_64-emul-vsyscall/arch/x86/kernel/vsyscall_64.c
@@ -195,6 +195,9 @@ bool emulate_vsyscall(struct pt_regs *re
 				 (unsigned __user *)regs->si,
 				 0);
 		break;
+	default:
+		ret = -ENOSYS;
+		break;
 	}
 
 	if (ret == -EFAULT) {



