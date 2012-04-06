Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755479Ab2DFQxJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2012 12:53:09 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44384 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755142Ab2DFQxH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2012 12:53:07 -0400
Date: Fri, 6 Apr 2012 09:52:49 -0700
From: tip-bot for Jeremy Fitzhardinge <jeremy@goop.org>
Message-ID: <tip-2ca052a3710fac208eee690faefdeb8bbd4586a1@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, jeremy@goop.org, hpa@zytor.com,
        mingo@kernel.org, leigh123linux@googlemail.com, treitmayr@devbase.at,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, jeremy@goop.org,
        linux-kernel@vger.kernel.org, leigh123linux@googlemail.com,
        treitmayr@devbase.at, tglx@linutronix.de
In-Reply-To: <4F7A3315.501@goop.org>
References: <4F7A3315.501@goop.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86:
  Use correct byte-sized register constraint in __xchg_op()
Git-Commit-ID: 2ca052a3710fac208eee690faefdeb8bbd4586a1
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 06 Apr 2012 09:52:55 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2ca052a3710fac208eee690faefdeb8bbd4586a1
Gitweb:     http://git.kernel.org/tip/2ca052a3710fac208eee690faefdeb8bbd4586a1
Author:     Jeremy Fitzhardinge <jeremy@goop.org>
AuthorDate: Mon, 2 Apr 2012 16:15:33 -0700
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Fri, 6 Apr 2012 09:39:39 -0700

x86: Use correct byte-sized register constraint in __xchg_op()

x86-64 can access the low half of any register, but i386 can only do
it with a subset of registers.  'r' causes compilation failures on i386,
but 'q' expresses the constraint properly.

Signed-off-by: Jeremy Fitzhardinge <jeremy@goop.org>
Link: http://lkml.kernel.org/r/4F7A3315.501@goop.org
Reported-by: Leigh Scott <leigh123linux@googlemail.com>
Tested-by: Thomas Reitmayr <treitmayr@devbase.at>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Cc: <stable@vger.kernel.org> v3.3
---
 arch/x86/include/asm/cmpxchg.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/cmpxchg.h b/arch/x86/include/asm/cmpxchg.h
index b3b7332..bc18d0e 100644
--- a/arch/x86/include/asm/cmpxchg.h
+++ b/arch/x86/include/asm/cmpxchg.h
@@ -43,7 +43,7 @@ extern void __add_wrong_size(void)
 		switch (sizeof(*(ptr))) {				\
 		case __X86_CASE_B:					\
 			asm volatile (lock #op "b %b0, %1\n"		\
-				      : "+r" (__ret), "+m" (*(ptr))	\
+				      : "+q" (__ret), "+m" (*(ptr))	\
 				      : : "memory", "cc");		\
 			break;						\
 		case __X86_CASE_W:					\
