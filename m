Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762107Ab2COVxB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 17:53:01 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60190 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752262Ab2COVw5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 17:52:57 -0400
Date: Thu, 15 Mar 2012 14:52:44 -0700
From: tip-bot for Sasha Levin <levinsasha928@gmail.com>
Message-ID: <tip-f910381a55cdaa097030291f272f6e6e4380c39a@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, levinsasha928@gmail.com, hpa@zytor.com,
        mingo@redhat.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, levinsasha928@gmail.com,
        linux-kernel@vger.kernel.org, tglx@linutronix.de
In-Reply-To: <1331829374-31543-1-git-send-email-levinsasha928@gmail.com>
References: <1331829374-31543-1-git-send-email-levinsasha928@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/core] math: Introduce div64_long
Git-Commit-ID: f910381a55cdaa097030291f272f6e6e4380c39a
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 15 Mar 2012 14:52:50 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f910381a55cdaa097030291f272f6e6e4380c39a
Gitweb:     http://git.kernel.org/tip/f910381a55cdaa097030291f272f6e6e4380c39a
Author:     Sasha Levin <levinsasha928@gmail.com>
AuthorDate: Thu, 15 Mar 2012 12:36:13 -0400
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Thu, 15 Mar 2012 21:41:34 +0100

math: Introduce div64_long

Add a div64_long macro which is used to devide a 64bit number by a long (which
can be 4 bytes on 32bit systems and 8 bytes on 64bit systems).

Suggested-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Sasha Levin <levinsasha928@gmail.com>
Cc: johnstul@us.ibm.com
Link: http://lkml.kernel.org/r/1331829374-31543-1-git-send-email-levinsasha928@gmail.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/math64.h |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/include/linux/math64.h b/include/linux/math64.h
index 23fcdfc..b8ba855 100644
--- a/include/linux/math64.h
+++ b/include/linux/math64.h
@@ -6,6 +6,8 @@
 
 #if BITS_PER_LONG == 64
 
+#define div64_long(x,y) div64_s64((x),(y))
+
 /**
  * div_u64_rem - unsigned 64bit divide with 32bit divisor with remainder
  *
@@ -45,6 +47,8 @@ static inline s64 div64_s64(s64 dividend, s64 divisor)
 
 #elif BITS_PER_LONG == 32
 
+#define div64_long(x,y) div_s64((x),(y))
+
 #ifndef div_u64_rem
 static inline u64 div_u64_rem(u64 dividend, u32 divisor, u32 *remainder)
 {
