Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932338Ab1LEN1T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 08:27:19 -0500
Received: from terminus.zytor.com ([198.137.202.10]:57525 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932224Ab1LEN1R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 08:27:17 -0500
Date: Mon, 5 Dec 2011 05:24:45 -0800
From: tip-bot for Andy Lutomirski <luto@amacapital.net>
Message-ID: <tip-2e57ae0515124af45dd889bfbd4840fd40fcc07d@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        torvalds@linux-foundation.org, bunk@stusta.de, luto@amacapital.net,
        richard.weinberger@gmail.com, tglx@linutronix.de, hpa@linux.intel.com,
        mingo@elte.hu
Reply-To: luto@amacapital.net, mingo@redhat.com, hpa@zytor.com,
        linux-kernel@vger.kernel.org, richard.weinberger@gmail.com,
        bunk@stusta.de, torvalds@linux-foundation.org, tglx@linutronix.de,
        hpa@linux.intel.com, mingo@elte.hu
In-Reply-To: <93154af3b2b6d208906ae02d80d92cf60c6fa94f.1320712291.git.luto@amacapital.net>
References: <93154af3b2b6d208906ae02d80d92cf60c6fa94f.1320712291.git.luto@amacapital.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/asm] x86: Default to vsyscall=emulate
Git-Commit-ID: 2e57ae0515124af45dd889bfbd4840fd40fcc07d
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 05 Dec 2011 05:24:51 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2e57ae0515124af45dd889bfbd4840fd40fcc07d
Gitweb:     http://git.kernel.org/tip/2e57ae0515124af45dd889bfbd4840fd40fcc07d
Author:     Andy Lutomirski <luto@amacapital.net>
AuthorDate: Mon, 7 Nov 2011 16:33:41 -0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 5 Dec 2011 12:17:29 +0100

x86: Default to vsyscall=emulate

This essentially reverts:

  2b666859ec32: x86: Default to vsyscall=native for now

The ABI breakage should now be fixed by:

 commit 48c4206f5b02f28c4c78a1f5b491d3772fb64fb9
 Author: Andy Lutomirski <luto@mit.edu>
 Date:   Thu Oct 20 08:48:19 2011 -0700

    x86-64: Set siginfo and context on vsyscall emulation faults

Signed-off-by: Andy Lutomirski <luto@amacapital.net>
Cc: richard -rw- weinberger <richard.weinberger@gmail.com>
Cc: Adrian Bunk <bunk@stusta.de>
Cc: H. Peter Anvin <hpa@linux.intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/r/93154af3b2b6d208906ae02d80d92cf60c6fa94f.1320712291.git.luto@amacapital.net
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 Documentation/kernel-parameters.txt |    7 +++----
 arch/x86/kernel/vsyscall_64.c       |    2 +-
 2 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index a0c5c5f..ce7fc8b 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -2750,11 +2750,10 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 			functions are at fixed addresses, they make nice
 			targets for exploits that can control RIP.
 
-			emulate     Vsyscalls turn into traps and are emulated
-			            reasonably safely.
+			emulate     [default] Vsyscalls turn into traps and are
+			            emulated reasonably safely.
 
-			native      [default] Vsyscalls are native syscall
-			            instructions.
+			native      Vsyscalls are native syscall instructions.
 			            This is a little bit faster than trapping
 			            and makes a few dynamic recompilers work
 			            better than they would in emulation mode.
diff --git a/arch/x86/kernel/vsyscall_64.c b/arch/x86/kernel/vsyscall_64.c
index 8084bec..b07ba93 100644
--- a/arch/x86/kernel/vsyscall_64.c
+++ b/arch/x86/kernel/vsyscall_64.c
@@ -57,7 +57,7 @@ DEFINE_VVAR(struct vsyscall_gtod_data, vsyscall_gtod_data) =
 	.lock = __SEQLOCK_UNLOCKED(__vsyscall_gtod_data.lock),
 };
 
-static enum { EMULATE, NATIVE, NONE } vsyscall_mode = NATIVE;
+static enum { EMULATE, NATIVE, NONE } vsyscall_mode = EMULATE;
 
 static int __init vsyscall_setup(char *str)
 {
