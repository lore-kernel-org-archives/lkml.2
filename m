Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756033Ab2DTWEF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 18:04:05 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34127 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754800Ab2DTWEC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 18:04:02 -0400
Date: Fri, 20 Apr 2012 15:03:52 -0700
From: "tip-bot for H. Peter Anvin" <hpa@zytor.com>
Message-ID: <tip-a53a96e5413d3639ed75d202bbfe68aa0a56c091@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        david.daney@cavium.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        david.daney@cavium.com, tglx@linutronix.de
In-Reply-To: <CA+55aFyijf43qSu3N9nWHEBwaGbb7T2Oq9A=9EyR=Jtyqfq_cQ@mail.gmail.com>
References: <CA+55aFyijf43qSu3N9nWHEBwaGbb7T2Oq9A=9EyR=Jtyqfq_cQ@mail.gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/extable] x86, extable:
  Remove open-coded exception table entries in arch/x86/lib/putuser.S
Git-Commit-ID: a53a96e5413d3639ed75d202bbfe68aa0a56c091
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 20 Apr 2012 15:03:57 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a53a96e5413d3639ed75d202bbfe68aa0a56c091
Gitweb:     http://git.kernel.org/tip/a53a96e5413d3639ed75d202bbfe68aa0a56c091
Author:     H. Peter Anvin <hpa@zytor.com>
AuthorDate: Fri, 20 Apr 2012 12:19:52 -0700
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Fri, 20 Apr 2012 13:51:39 -0700

x86, extable: Remove open-coded exception table entries in arch/x86/lib/putuser.S

Remove open-coded exception table entries in arch/x86/lib/putuser.S,
and replace them with _ASM_EXTABLE() macros; this will allow us to
change the format and type of the exception table entries.

Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Cc: David Daney <david.daney@cavium.com>
Link: http://lkml.kernel.org/r/CA%2B55aFyijf43qSu3N9nWHEBwaGbb7T2Oq9A=9EyR=Jtyqfq_cQ@mail.gmail.com
---
 arch/x86/lib/putuser.S |   12 +++++-------
 1 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/arch/x86/lib/putuser.S b/arch/x86/lib/putuser.S
index 36b0d15..7f951c8 100644
--- a/arch/x86/lib/putuser.S
+++ b/arch/x86/lib/putuser.S
@@ -86,12 +86,10 @@ bad_put_user:
 	EXIT
 END(bad_put_user)
 
-.section __ex_table,"a"
-	_ASM_PTR 1b,bad_put_user
-	_ASM_PTR 2b,bad_put_user
-	_ASM_PTR 3b,bad_put_user
-	_ASM_PTR 4b,bad_put_user
+	_ASM_EXTABLE(1b,bad_put_user)
+	_ASM_EXTABLE(2b,bad_put_user)
+	_ASM_EXTABLE(3b,bad_put_user)
+	_ASM_EXTABLE(4b,bad_put_user)
 #ifdef CONFIG_X86_32
-	_ASM_PTR 5b,bad_put_user
+	_ASM_EXTABLE(5b,bad_put_user)
 #endif
-.previous
