Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932158Ab2DTWDU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 18:03:20 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34120 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755806Ab2DTWDR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 18:03:17 -0400
Date: Fri, 20 Apr 2012 15:03:01 -0700
From: "tip-bot for H. Peter Anvin" <hpa@zytor.com>
Message-ID: <tip-1a27bc0d99aabea6b628cb994a21a1c79b569fc9@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        david.daney@cavium.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        david.daney@cavium.com, tglx@linutronix.de
In-Reply-To: <CA+55aFyijf43qSu3N9nWHEBwaGbb7T2Oq9A=9EyR=Jtyqfq_cQ@mail.gmail.com>
References: <CA+55aFyijf43qSu3N9nWHEBwaGbb7T2Oq9A=9EyR=Jtyqfq_cQ@mail.gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/extable] x86, extable:
  Remove open-coded exception table entries in arch/x86/lib/getuser.S
Git-Commit-ID: 1a27bc0d99aabea6b628cb994a21a1c79b569fc9
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 20 Apr 2012 15:03:07 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1a27bc0d99aabea6b628cb994a21a1c79b569fc9
Gitweb:     http://git.kernel.org/tip/1a27bc0d99aabea6b628cb994a21a1c79b569fc9
Author:     H. Peter Anvin <hpa@zytor.com>
AuthorDate: Fri, 20 Apr 2012 12:19:51 -0700
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Fri, 20 Apr 2012 13:51:39 -0700

x86, extable: Remove open-coded exception table entries in arch/x86/lib/getuser.S

Remove open-coded exception table entries in arch/x86/lib/getuser.S,
and replace them with _ASM_EXTABLE() macros; this will allow us to
change the format and type of the exception table entries.

Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Cc: David Daney <david.daney@cavium.com>
Link: http://lkml.kernel.org/r/CA%2B55aFyijf43qSu3N9nWHEBwaGbb7T2Oq9A=9EyR=Jtyqfq_cQ@mail.gmail.com
---
 arch/x86/lib/getuser.S |    9 ++++-----
 1 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/arch/x86/lib/getuser.S b/arch/x86/lib/getuser.S
index 51f1504..b33b1fb 100644
--- a/arch/x86/lib/getuser.S
+++ b/arch/x86/lib/getuser.S
@@ -95,10 +95,9 @@ bad_get_user:
 	CFI_ENDPROC
 END(bad_get_user)
 
-.section __ex_table,"a"
-	_ASM_PTR 1b,bad_get_user
-	_ASM_PTR 2b,bad_get_user
-	_ASM_PTR 3b,bad_get_user
+	_ASM_EXTABLE(1b,bad_get_user)
+	_ASM_EXTABLE(2b,bad_get_user)
+	_ASM_EXTABLE(3b,bad_get_user)
 #ifdef CONFIG_X86_64
-	_ASM_PTR 4b,bad_get_user
+	_ASM_EXTABLE(4b,bad_get_user)
 #endif
