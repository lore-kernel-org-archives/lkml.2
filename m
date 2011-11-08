Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753444Ab1KHAeN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 19:34:13 -0500
Received: from mail-pz0-f42.google.com ([209.85.210.42]:46589 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753081Ab1KHAeL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 19:34:11 -0500
From: Andy Lutomirski <luto@amacapital.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: x86@kernel.org, Ingo Molnar <mingo@elte.hu>,
        richard -rw- weinberger <richard.weinberger@gmail.com>,
        Adrian Bunk <bunk@stusta.de>, "H. Peter Anvin" <hpa@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org, Andy Lutomirski <luto@amacapital.net>
Subject: [PATCH 2/2] x86: Default to vsyscall=emulate
Date: Mon,  7 Nov 2011 16:33:41 -0800
Message-Id: <93154af3b2b6d208906ae02d80d92cf60c6fa94f.1320712291.git.luto@amacapital.net>
X-Mailer: git-send-email 1.7.6.4
In-Reply-To: <cover.1320712291.git.luto@amacapital.net>
References: <CALCETrXAiHs9PyziHBm-gZRiyahYafbxxUSxJUcFh=a-0th0EQ@mail.gmail.com>
 <cover.1320712291.git.luto@amacapital.net>
In-Reply-To: <cover.1320712291.git.luto@amacapital.net>
References: <cover.1320712291.git.luto@amacapital.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This reverts commit 2b666859ec323403ac9a3a441d16eab30945404b.  The
ABI breakage should be fixed by:

commit 48c4206f5b02f28c4c78a1f5b491d3772fb64fb9
Author: Andy Lutomirski <luto@mit.edu>
Date:   Thu Oct 20 08:48:19 2011 -0700

    x86-64: Set siginfo and context on vsyscall emulation faults

Signed-off-by: Andy Lutomirski <luto@amacapital.net>
---
 Documentation/kernel-parameters.txt |    7 +++----
 arch/x86/kernel/vsyscall_64.c       |    2 +-
 2 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index d6e6724..854ed5ca 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -2706,11 +2706,10 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
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
index 9b05546..02e980a 100644
--- a/arch/x86/kernel/vsyscall_64.c
+++ b/arch/x86/kernel/vsyscall_64.c
@@ -56,7 +56,7 @@ DEFINE_VVAR(struct vsyscall_gtod_data, vsyscall_gtod_data) =
 	.lock = __SEQLOCK_UNLOCKED(__vsyscall_gtod_data.lock),
 };
 
-static enum { EMULATE, NATIVE, NONE } vsyscall_mode = NATIVE;
+static enum { EMULATE, NATIVE, NONE } vsyscall_mode = EMULATE;
 
 static int __init vsyscall_setup(char *str)
 {
-- 
1.7.6.4

