Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755981Ab2DFQxx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2012 12:53:53 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44395 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755242Ab2DFQxv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2012 12:53:51 -0400
Date: Fri, 6 Apr 2012 09:53:39 -0700
From: "tip-bot for H. Peter Anvin" <hpa@zytor.com>
Message-ID: <tip-8c91c5325e107ec17e40a59a47c6517387d64eb7@git.kernel.org>
Cc: jeremy@goop.org, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, leigh123linux@googlemail.com, treitmayr@devbase.at,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        jeremy@goop.org, leigh123linux@googlemail.com, treitmayr@devbase.at,
        tglx@linutronix.de
In-Reply-To: <4F7A3315.501@goop.org>
References: <4F7A3315.501@goop.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86:
  Use correct byte-sized register constraint in __add()
Git-Commit-ID: 8c91c5325e107ec17e40a59a47c6517387d64eb7
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 06 Apr 2012 09:53:44 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8c91c5325e107ec17e40a59a47c6517387d64eb7
Gitweb:     http://git.kernel.org/tip/8c91c5325e107ec17e40a59a47c6517387d64eb7
Author:     H. Peter Anvin <hpa@zytor.com>
AuthorDate: Fri, 6 Apr 2012 09:30:57 -0700
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Fri, 6 Apr 2012 09:40:07 -0700

x86: Use correct byte-sized register constraint in __add()

Similar to:

 2ca052a x86: Use correct byte-sized register constraint in __xchg_op()

... the __add() macro also needs to use a "q" constraint in the
byte-sized case, lest we try to generate an illegal register.

Link: http://lkml.kernel.org/r/4F7A3315.501@goop.org
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Leigh Scott <leigh123linux@googlemail.com>
Cc: Thomas Reitmayr <treitmayr@devbase.at>
Cc: <stable@vger.kernel.org> v3.3
---
 arch/x86/include/asm/cmpxchg.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/cmpxchg.h b/arch/x86/include/asm/cmpxchg.h
index bc18d0e..99480e5 100644
--- a/arch/x86/include/asm/cmpxchg.h
+++ b/arch/x86/include/asm/cmpxchg.h
@@ -173,7 +173,7 @@ extern void __add_wrong_size(void)
 		switch (sizeof(*(ptr))) {				\
 		case __X86_CASE_B:					\
 			asm volatile (lock "addb %b1, %0\n"		\
-				      : "+m" (*(ptr)) : "ri" (inc)	\
+				      : "+m" (*(ptr)) : "qi" (inc)	\
 				      : "memory", "cc");		\
 			break;						\
 		case __X86_CASE_W:					\
