Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752782Ab1GUKLO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 06:11:14 -0400
Received: from hera.kernel.org ([140.211.167.34]:54080 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752575Ab1GUKLK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 06:11:10 -0400
Date: Thu, 21 Jul 2011 10:10:45 GMT
From: tip-bot for Greg Dietsche <Gregory.Dietsche@cuw.edu>
Message-ID: <tip-a6c23905ff0d6bbddf590ef0838489ee0f6c74ac@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        Gregory.Dietsche@cuw.edu, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        Gregory.Dietsche@cuw.edu, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1309482653-23648-1-git-send-email-Gregory.Dietsche@cuw.edu>
References: <1309482653-23648-1-git-send-email-Gregory.Dietsche@cuw.edu>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/cleanups] x86, smpboot: Mark the names[] array in __inquire_remote_apic() as const
Git-Commit-ID: a6c23905ff0d6bbddf590ef0838489ee0f6c74ac
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 21 Jul 2011 10:10:49 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a6c23905ff0d6bbddf590ef0838489ee0f6c74ac
Gitweb:     http://git.kernel.org/tip/a6c23905ff0d6bbddf590ef0838489ee0f6c74ac
Author:     Greg Dietsche <Gregory.Dietsche@cuw.edu>
AuthorDate: Thu, 30 Jun 2011 20:10:53 -0500
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 21 Jul 2011 10:04:51 +0200

x86, smpboot: Mark the names[] array in __inquire_remote_apic() as const

This array is read-only. Make it explicit by marking as const.

Signed-off-by: Greg Dietsche <Gregory.Dietsche@cuw.edu>
Link: http://lkml.kernel.org/r/1309482653-23648-1-git-send-email-Gregory.Dietsche@cuw.edu
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/smpboot.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index a3c430b..e02653a 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -425,7 +425,7 @@ static void impress_friends(void)
 void __inquire_remote_apic(int apicid)
 {
 	unsigned i, regs[] = { APIC_ID >> 4, APIC_LVR >> 4, APIC_SPIV >> 4 };
-	char *names[] = { "ID", "VERSION", "SPIV" };
+	const char * const names[] = { "ID", "VERSION", "SPIV" };
 	int timeout;
 	u32 status;
 
