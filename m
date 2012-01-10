Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932389Ab2AJRTL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 12:19:11 -0500
Received: from terminus.zytor.com ([198.137.202.10]:58684 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932236Ab2AJRTJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 12:19:09 -0500
Date: Tue, 10 Jan 2012 09:18:58 -0800
From: "tip-bot for H. Peter Anvin" <hpa@zytor.com>
Message-ID: <tip-8030c36d13f030103356709e63638678fdc66fdc@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        akpm@linux-foundation.org, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, tglx@linutronix.de
In-Reply-To: <20120109165859.1879abda.akpm@linux-foundation.org>
References: <20120109165859.1879abda.akpm@linux-foundation.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86, atomic: atomic64_read() take a const pointer
Git-Commit-ID: 8030c36d13f030103356709e63638678fdc66fdc
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 10 Jan 2012 09:19:04 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8030c36d13f030103356709e63638678fdc66fdc
Gitweb:     http://git.kernel.org/tip/8030c36d13f030103356709e63638678fdc66fdc
Author:     H. Peter Anvin <hpa@zytor.com>
AuthorDate: Mon, 9 Jan 2012 19:33:24 -0800
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Mon, 9 Jan 2012 19:33:24 -0800

x86, atomic: atomic64_read() take a const pointer

atomic64_read() doesn't actually write anything (as far as the C
environment is concerned... the CPU does actually write but that's an
implementation quirk), so it should take a const pointer.

This does NOT mean that it is safe to use atomic64_read() on an object
in readonly storage (it will trap!)

Reported-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Link: http://lkml.kernel.org/r/20120109165859.1879abda.akpm@linux-foundation.org
---
 arch/x86/include/asm/atomic64_32.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/atomic64_32.h b/arch/x86/include/asm/atomic64_32.h
index 24098aa..fa13f0e 100644
--- a/arch/x86/include/asm/atomic64_32.h
+++ b/arch/x86/include/asm/atomic64_32.h
@@ -82,7 +82,7 @@ static inline void atomic64_set(atomic64_t *v, long long i)
  *
  * Atomically reads the value of @v and returns it.
  */
-static inline long long atomic64_read(atomic64_t *v)
+static inline long long atomic64_read(const atomic64_t *v)
 {
 	long long r;
 	asm volatile(ATOMIC64_ALTERNATIVE(read)
