Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932751Ab1LERiO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 12:38:14 -0500
Received: from terminus.zytor.com ([198.137.202.10]:58688 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932512Ab1LERiL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 12:38:11 -0500
Date: Mon, 5 Dec 2011 09:37:26 -0800
From: tip-bot for Thomas Meyer <thomas@m3y3r.de>
Message-ID: <tip-cced40229993bb63238299e48a22e4c8d1e13181@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, thomas@m3y3r.de, hpa@zytor.com,
        mingo@redhat.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, thomas@m3y3r.de,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1321569820.1624.275.camel@localhost.localdomain>
References: <1321569820.1624.275.camel@localhost.localdomain>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/cleanups] x86: Use kmemdup() in copy_thread(), rather than duplicating its implementation
Git-Commit-ID: cced40229993bb63238299e48a22e4c8d1e13181
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 05 Dec 2011 09:37:32 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  cced40229993bb63238299e48a22e4c8d1e13181
Gitweb:     http://git.kernel.org/tip/cced40229993bb63238299e48a22e4c8d1e13181
Author:     Thomas Meyer <thomas@m3y3r.de>
AuthorDate: Thu, 17 Nov 2011 23:43:40 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 5 Dec 2011 13:54:39 +0100

x86: Use kmemdup() in copy_thread(), rather than duplicating its implementation

The semantic patch that makes this change is available
in scripts/coccinelle/api/memdup.cocci.

Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
Link: http://lkml.kernel.org/r/1321569820.1624.275.camel@localhost.localdomain
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/process_64.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index 3bd7e6e..d2c1f62 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -293,13 +293,12 @@ int copy_thread(unsigned long clone_flags, unsigned long sp,
 	memset(p->thread.ptrace_bps, 0, sizeof(p->thread.ptrace_bps));
 
 	if (unlikely(test_tsk_thread_flag(me, TIF_IO_BITMAP))) {
-		p->thread.io_bitmap_ptr = kmalloc(IO_BITMAP_BYTES, GFP_KERNEL);
+		p->thread.io_bitmap_ptr = kmemdup(me->thread.io_bitmap_ptr,
+						  IO_BITMAP_BYTES, GFP_KERNEL);
 		if (!p->thread.io_bitmap_ptr) {
 			p->thread.io_bitmap_max = 0;
 			return -ENOMEM;
 		}
-		memcpy(p->thread.io_bitmap_ptr, me->thread.io_bitmap_ptr,
-				IO_BITMAP_BYTES);
 		set_tsk_thread_flag(p, TIF_IO_BITMAP);
 	}
 
