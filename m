Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753345Ab0C2Snf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 14:43:35 -0400
Received: from hera.kernel.org ([140.211.167.34]:45412 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753258Ab0C2Snc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 14:43:32 -0400
Date: Mon, 29 Mar 2010 18:42:37 GMT
From: tip-bot for Yinghai Lu <yinghai@kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       yinghai@kernel.org, torvalds@linux-foundation.org, hannes@cmpxchg.org,
       davem@davemloft.net, benh@kernel.crashing.org, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       yinghai@kernel.org, torvalds@linux-foundation.org, hannes@cmpxchg.org,
       davem@davemloft.net, benh@kernel.crashing.org, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <1269830604-26214-2-git-send-email-yinghai@kernel.org>
References: <1269830604-26214-2-git-send-email-yinghai@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86: Make smp_locks end with page alignment
Message-ID: <tip-596b711ed6b5235f8545680ef38ace00f9898c32@git.kernel.org>
Git-Commit-ID: 596b711ed6b5235f8545680ef38ace00f9898c32
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 29 Mar 2010 18:42:38 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  596b711ed6b5235f8545680ef38ace00f9898c32
Gitweb:     http://git.kernel.org/tip/596b711ed6b5235f8545680ef38ace00f9898c32
Author:     Yinghai Lu <yinghai@kernel.org>
AuthorDate: Sun, 28 Mar 2010 19:42:54 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 29 Mar 2010 18:42:30 +0200

x86: Make smp_locks end with page alignment

Fix:

 ------------[ cut here ]------------
 WARNING: at arch/x86/mm/init.c:342 free_init_pages+0x4c/0xfa()
 free_init_pages: range [0x40daf000, 0x40db5c24] is not aligned
 Modules linked in:
 Pid: 0, comm: swapper Not tainted
 2.6.34-rc2-tip-03946-g4f16b23-dirty #50 Call Trace:
  [<40232e9f>] warn_slowpath_common+0x65/0x7c
  [<4021c9f0>] ? free_init_pages+0x4c/0xfa
  [<40881434>] ? _etext+0x0/0x24
  [<40232eea>] warn_slowpath_fmt+0x24/0x27
  [<4021c9f0>] free_init_pages+0x4c/0xfa
  [<40881434>] ? _etext+0x0/0x24
  [<40d3f4bd>] alternative_instructions+0xf6/0x100
  [<40d3fe4f>] check_bugs+0xbd/0xbf
  [<40d398a7>] start_kernel+0x2d5/0x2e4
  [<40d390ce>] i386_start_kernel+0xce/0xd5
 ---[ end trace 4eaa2a86a8e2da22 ]---

Comments in vmlinux.lds.S already said:

 |        /*
 |         * smp_locks might be freed after init
 |         * start/end must be page aligned
 |         */

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: David Miller <davem@davemloft.net>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
LKML-Reference: <1269830604-26214-2-git-send-email-yinghai@kernel.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/vmlinux.lds.S |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/vmlinux.lds.S b/arch/x86/kernel/vmlinux.lds.S
index 44879df..2cc2497 100644
--- a/arch/x86/kernel/vmlinux.lds.S
+++ b/arch/x86/kernel/vmlinux.lds.S
@@ -291,8 +291,8 @@ SECTIONS
 	.smp_locks : AT(ADDR(.smp_locks) - LOAD_OFFSET) {
 		__smp_locks = .;
 		*(.smp_locks)
-		__smp_locks_end = .;
 		. = ALIGN(PAGE_SIZE);
+		__smp_locks_end = .;
 	}
 
 #ifdef CONFIG_X86_64
