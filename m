Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756168Ab1CBInI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 03:43:08 -0500
Received: from hera.kernel.org ([140.211.167.34]:45329 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755576Ab1CBInF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 03:43:05 -0500
Date: Wed, 2 Mar 2011 08:42:47 GMT
From: tip-bot for Jan Beulich <JBeulich@novell.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        jbeulich@novell.com, JBeulich@novell.com, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        jbeulich@novell.com, JBeulich@novell.com, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <4D6D1082020000780003454C@vpn.id2.novell.com>
References: <4D6D1082020000780003454C@vpn.id2.novell.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/asm] x86: Fix a bogus unwind annotation in lib/semaphore_32.S
Message-ID: <tip-e938c287ea8d977e079f07464ac69923412663ce@git.kernel.org>
Git-Commit-ID: e938c287ea8d977e079f07464ac69923412663ce
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 02 Mar 2011 08:42:48 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e938c287ea8d977e079f07464ac69923412663ce
Gitweb:     http://git.kernel.org/tip/e938c287ea8d977e079f07464ac69923412663ce
Author:     Jan Beulich <JBeulich@novell.com>
AuthorDate: Tue, 1 Mar 2011 14:28:02 +0000
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 2 Mar 2011 08:16:44 +0100

x86: Fix a bogus unwind annotation in lib/semaphore_32.S

'simple' would have required specifying current frame address
and return address location manually, but that's obviously not
the case (and not necessary) here.

Signed-off-by: Jan Beulich <jbeulich@novell.com>
LKML-Reference: <4D6D1082020000780003454C@vpn.id2.novell.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/lib/semaphore_32.S |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/lib/semaphore_32.S b/arch/x86/lib/semaphore_32.S
index 48e44f7..06691da 100644
--- a/arch/x86/lib/semaphore_32.S
+++ b/arch/x86/lib/semaphore_32.S
@@ -36,7 +36,7 @@
  */
 #ifdef CONFIG_SMP
 ENTRY(__write_lock_failed)
-	CFI_STARTPROC simple
+	CFI_STARTPROC
 	FRAME
 2: 	LOCK_PREFIX
 	addl	$ RW_LOCK_BIAS,(%eax)
