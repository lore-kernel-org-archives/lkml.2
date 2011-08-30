Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752584Ab1H3FX5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 01:23:57 -0400
Received: from hera.kernel.org ([140.211.167.34]:48815 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750970Ab1H3FXy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 01:23:54 -0400
Date: Tue, 30 Aug 2011 05:23:24 GMT
From: tip-bot for Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Message-ID: <tip-00a41546e8008b9944382eed1841c785f4fc8d9c@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        tglx@linutronix.de, hpa@linux.intel.com,
        jeremy.fitzhardinge@citrix.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, hpa@linux.intel.com,
        jeremy.fitzhardinge@citrix.com
In-Reply-To: <4E5BCC40.3030501@goop.org>
References: <4E5BCC40.3030501@goop.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/spinlocks] x86, cmpxchg: Move 64-bit set64_bit() to match 32-bit
Git-Commit-ID: 00a41546e8008b9944382eed1841c785f4fc8d9c
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (hera.kernel.org [127.0.0.1]); Tue, 30 Aug 2011 05:23:45 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  00a41546e8008b9944382eed1841c785f4fc8d9c
Gitweb:     http://git.kernel.org/tip/00a41546e8008b9944382eed1841c785f4fc8d9c
Author:     Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
AuthorDate: Thu, 18 Aug 2011 11:40:22 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Mon, 29 Aug 2011 13:41:40 -0700

x86, cmpxchg: Move 64-bit set64_bit() to match 32-bit

Reduce arbitrary differences between 32 and 64 bits.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Link: http://lkml.kernel.org/r/4E5BCC40.3030501@goop.org
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/include/asm/cmpxchg_64.h |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/cmpxchg_64.h b/arch/x86/include/asm/cmpxchg_64.h
index 7cf5c0a..5bfa560 100644
--- a/arch/x86/include/asm/cmpxchg_64.h
+++ b/arch/x86/include/asm/cmpxchg_64.h
@@ -3,11 +3,6 @@
 
 #include <asm/alternative.h> /* Provides LOCK_PREFIX */
 
-static inline void set_64bit(volatile u64 *ptr, u64 val)
-{
-	*ptr = val;
-}
-
 extern void __xchg_wrong_size(void);
 extern void __cmpxchg_wrong_size(void);
 
@@ -66,6 +61,11 @@ extern void __cmpxchg_wrong_size(void);
 #define xchg(ptr, v)							\
 	__xchg((v), (ptr), sizeof(*ptr))
 
+static inline void set_64bit(volatile u64 *ptr, u64 val)
+{
+	*ptr = val;
+}
+
 #define __HAVE_ARCH_CMPXCHG 1
 
 /*
