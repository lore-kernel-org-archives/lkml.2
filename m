Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752740Ab1H3FXe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 01:23:34 -0400
Received: from hera.kernel.org ([140.211.167.34]:48798 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752584Ab1H3FXc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 01:23:32 -0400
Date: Tue, 30 Aug 2011 05:22:54 GMT
From: tip-bot for Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Message-ID: <tip-416185bd5ac8a749ee43d1b0967b43782843d1a0@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        tglx@linutronix.de, hpa@linux.intel.com,
        jeremy.fitzhardinge@citrix.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, hpa@linux.intel.com,
        jeremy.fitzhardinge@citrix.com
In-Reply-To: <4E5BCC40.3030501@goop.org>
References: <4E5BCC40.3030501@goop.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/spinlocks] x86, cmpxchg: Move 32-bit __cmpxchg_wrong_size to match 64 bit.
Git-Commit-ID: 416185bd5ac8a749ee43d1b0967b43782843d1a0
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (hera.kernel.org [127.0.0.1]); Tue, 30 Aug 2011 05:23:23 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  416185bd5ac8a749ee43d1b0967b43782843d1a0
Gitweb:     http://git.kernel.org/tip/416185bd5ac8a749ee43d1b0967b43782843d1a0
Author:     Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
AuthorDate: Thu, 18 Aug 2011 11:34:46 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Mon, 29 Aug 2011 13:41:17 -0700

x86, cmpxchg: Move 32-bit __cmpxchg_wrong_size to match 64 bit.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Link: http://lkml.kernel.org/r/4E5BCC40.3030501@goop.org
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/include/asm/cmpxchg_32.h |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/cmpxchg_32.h b/arch/x86/include/asm/cmpxchg_32.h
index 024b694..59d8e36 100644
--- a/arch/x86/include/asm/cmpxchg_32.h
+++ b/arch/x86/include/asm/cmpxchg_32.h
@@ -9,6 +9,7 @@
  */
 
 extern void __xchg_wrong_size(void);
+extern void __cmpxchg_wrong_size(void);
 
 /*
  * Note: no "lock" prefix even on SMP: xchg always implies lock anyway.
@@ -84,8 +85,6 @@ static inline void set_64bit(volatile u64 *ptr, u64 value)
 		     : "memory");
 }
 
-extern void __cmpxchg_wrong_size(void);
-
 /*
  * Atomic compare and exchange.  Compare OLD with MEM, if identical,
  * store NEW in MEM.  Return the initial value in MEM.  Success is
