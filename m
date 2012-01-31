Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754864Ab2AaTOS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 14:14:18 -0500
Received: from terminus.zytor.com ([198.137.202.10]:57445 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754462Ab2AaTOR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 14:14:17 -0500
Date: Tue, 31 Jan 2012 11:13:36 -0800
From: "tip-bot for hchunhui@mail.ustc.edu.cn" <hchunhui@mail.ustc.edu.cn>
Message-ID: <tip-b19c3206aa872e0562d67ad46bf3b3a59be956a7@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        tglx@linutronix.de, hpa@linux.intel.com, hchunhui@mail.ustc.edu.cn
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, hpa@linux.intel.com, hchunhui@mail.ustc.edu.cn
In-Reply-To: <32892299.2931391328028508117.JavaMail.coremail@mailweb>
References: <32892299.2931391328028508117.JavaMail.coremail@mailweb>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/boot] x86, boot: Fix port argument to inl() function
Git-Commit-ID: b19c3206aa872e0562d67ad46bf3b3a59be956a7
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 31 Jan 2012 11:13:43 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b19c3206aa872e0562d67ad46bf3b3a59be956a7
Gitweb:     http://git.kernel.org/tip/b19c3206aa872e0562d67ad46bf3b3a59be956a7
Author:     hchunhui@mail.ustc.edu.cn <hchunhui@mail.ustc.edu.cn>
AuthorDate: Wed, 1 Feb 2012 00:48:28 +0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Tue, 31 Jan 2012 10:08:17 -0800

x86, boot: Fix port argument to inl() function

"u32 port" in inl() should be "u16 port".

[ hpa: it's a bug, but it doesn't produce incorrect code, so no need
  to put this into urgent or stable. ]

Signed-off-by: He Chunhui <hchunhui@mail.ustc.edu.cn>
Link: http://lkml.kernel.org/r/32892299.2931391328028508117.JavaMail.coremail@mailweb
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/boot/boot.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/boot/boot.h b/arch/x86/boot/boot.h
index c7093bd..18997e5 100644
--- a/arch/x86/boot/boot.h
+++ b/arch/x86/boot/boot.h
@@ -67,7 +67,7 @@ static inline void outl(u32 v, u16 port)
 {
 	asm volatile("outl %0,%1" : : "a" (v), "dN" (port));
 }
-static inline u32 inl(u32 port)
+static inline u32 inl(u16 port)
 {
 	u32 v;
 	asm volatile("inl %1,%0" : "=a" (v) : "dN" (port));
