Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754175Ab1HKACD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 20:02:03 -0400
Received: from hera.kernel.org ([140.211.167.34]:41318 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753680Ab1HKACB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 20:02:01 -0400
Date: Thu, 11 Aug 2011 00:01:55 GMT
From: tip-bot for Andy Lutomirski <luto@mit.edu>
Message-ID: <tip-8df77470aa0d3b101a481197de4c6d9716ee63bc@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        luto@mit.edu, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        luto@mit.edu, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <6b19f55bdb06a0c32c2fa6dba9b6f222e1fde999.1312988155.git.luto@mit.edu>
References: <6b19f55bdb06a0c32c2fa6dba9b6f222e1fde999.1312988155.git.luto@mit.edu>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/vdso] x86-64: Wire up getcpu syscall
Git-Commit-ID: 8df77470aa0d3b101a481197de4c6d9716ee63bc
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 11 Aug 2011 00:01:56 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8df77470aa0d3b101a481197de4c6d9716ee63bc
Gitweb:     http://git.kernel.org/tip/8df77470aa0d3b101a481197de4c6d9716ee63bc
Author:     Andy Lutomirski <luto@mit.edu>
AuthorDate: Wed, 10 Aug 2011 11:15:31 -0400
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Wed, 10 Aug 2011 18:55:48 -0500

x86-64: Wire up getcpu syscall

getcpu is available as a vdso entry and an emulated vsyscall.
Programs that for some reason don't want to use the vdso should
still be able to call getcpu without relying on the slow emulated
vsyscall.  It costs almost nothing to expose it as a real syscall.

We also need this for the following patch in vsyscall=native mode.

Signed-off-by: Andy Lutomirski <luto@mit.edu>
Link: http://lkml.kernel.org/r/6b19f55bdb06a0c32c2fa6dba9b6f222e1fde999.1312988155.git.luto@mit.edu
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Cc: <stable@kernel.org> v3.0
---
 arch/x86/include/asm/unistd_64.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/unistd_64.h b/arch/x86/include/asm/unistd_64.h
index 705bf13..d92641c 100644
--- a/arch/x86/include/asm/unistd_64.h
+++ b/arch/x86/include/asm/unistd_64.h
@@ -681,6 +681,8 @@ __SYSCALL(__NR_syncfs, sys_syncfs)
 __SYSCALL(__NR_sendmmsg, sys_sendmmsg)
 #define __NR_setns				308
 __SYSCALL(__NR_setns, sys_setns)
+#define __NR_getcpu				309
+__SYSCALL(__NR_getcpu, sys_getcpu)
 
 #ifndef __NO_STUBS
 #define __ARCH_WANT_OLD_READDIR
