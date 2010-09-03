Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753597Ab0ICHML (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 03:12:11 -0400
Received: from hera.kernel.org ([140.211.167.34]:43143 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752064Ab0ICHMJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 03:12:09 -0400
Date: Fri, 3 Sep 2010 07:11:44 GMT
From: tip-bot for Jan Beulich <JBeulich@novell.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        jbeulich@novell.com, heukelum@fastmail.fm, JBeulich@novell.com,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        jbeulich@novell.com, JBeulich@novell.com, heukelum@fastmail.fm,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <4C7FBAA80200007800013F67@vpn.id2.novell.com>
References: <4C7FBAA80200007800013F67@vpn.id2.novell.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/debug] x86-64: Adjust frame type at paranoid_exit:
Message-ID: <tip-1f130a783a796f147b080c594488b566c86007d0@git.kernel.org>
Git-Commit-ID: 1f130a783a796f147b080c594488b566c86007d0
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 03 Sep 2010 07:11:44 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1f130a783a796f147b080c594488b566c86007d0
Gitweb:     http://git.kernel.org/tip/1f130a783a796f147b080c594488b566c86007d0
Author:     Jan Beulich <JBeulich@novell.com>
AuthorDate: Thu, 2 Sep 2010 13:54:32 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 3 Sep 2010 08:14:10 +0200

x86-64: Adjust frame type at paranoid_exit:

As this isn't an exception or interrupt entry point, it doesn't
have any of the hardware provide frame layouts active.

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Acked-by: Alexander van Heukelum <heukelum@fastmail.fm>
LKML-Reference: <4C7FBAA80200007800013F67@vpn.id2.novell.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/entry_64.S |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index 16aeff0..64dfe30 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -1367,7 +1367,7 @@ paranoidzeroentry machine_check *machine_check_vector(%rip)
 
 	/* ebx:	no swapgs flag */
 ENTRY(paranoid_exit)
-	INTR_FRAME
+	DEFAULT_FRAME
 	DISABLE_INTERRUPTS(CLBR_NONE)
 	TRACE_IRQS_OFF
 	testl %ebx,%ebx				/* swapgs needed? */
