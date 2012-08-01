Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754089Ab2HAXKv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2012 19:10:51 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48457 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753076Ab2HAXKu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2012 19:10:50 -0400
Date: Wed, 1 Aug 2012 16:10:33 -0700
From: "tip-bot for H. Peter Anvin" <hpa@linux.intel.com>
Message-ID: <tip-vwzk3qbcr3yjyxjg2j38vgy9@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        gorcunov@openvz.org, tglx@linutronix.de, hpa@linux.intel.com,
        hjl.tools@gmail.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        gorcunov@openvz.org, tglx@linutronix.de, hpa@linux.intel.com,
        hjl.tools@gmail.com
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86-64, kcmp: The kcmp system call can be common
Git-Commit-ID: eaf4ce6c5fed6b4c55f7efcd5fc3477435cab5e9
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 01 Aug 2012 16:10:38 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  eaf4ce6c5fed6b4c55f7efcd5fc3477435cab5e9
Gitweb:     http://git.kernel.org/tip/eaf4ce6c5fed6b4c55f7efcd5fc3477435cab5e9
Author:     H. Peter Anvin <hpa@linux.intel.com>
AuthorDate: Wed, 1 Aug 2012 15:59:58 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Wed, 1 Aug 2012 16:01:06 -0700

x86-64, kcmp: The kcmp system call can be common

We already use the same system call handler for i386 and x86-64, there
is absolutely no reason x32 can't use the same system call, too.

Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Cc: H.J. Lu <hjl.tools@gmail.com>
Cc: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: <stable@vger.kernel.org> v3.5
Link: http://lkml.kernel.org/n/tip-vwzk3qbcr3yjyxjg2j38vgy9@git.kernel.org
---
 arch/x86/syscalls/syscall_64.tbl |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/syscalls/syscall_64.tbl b/arch/x86/syscalls/syscall_64.tbl
index 51171ae..29aed7a 100644
--- a/arch/x86/syscalls/syscall_64.tbl
+++ b/arch/x86/syscalls/syscall_64.tbl
@@ -318,7 +318,7 @@
 309	common	getcpu			sys_getcpu
 310	64	process_vm_readv	sys_process_vm_readv
 311	64	process_vm_writev	sys_process_vm_writev
-312	64	kcmp			sys_kcmp
+312	common	kcmp			sys_kcmp
 
 #
 # x32-specific system call numbers start at 512 to avoid cache impact
