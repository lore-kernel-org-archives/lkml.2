Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757146Ab1KRJ12 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 04:27:28 -0500
Received: from www17.your-server.de ([213.133.104.17]:48415 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756628Ab1KRJ1W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 04:27:22 -0500
Subject: [PATCH] x86: Use kmemdup rather than duplicating its implementation
From: Thomas Meyer <thomas@m3y3r.de>
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Date: Thu, 17 Nov 2011 23:43:40 +0100
Message-ID: <1321569820.1624.275.camel@localhost.localdomain>
X-Mailer: Evolution 3.2.1 (3.2.1-2.fc16) 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The semantic patch that makes this change is available
in scripts/coccinelle/api/memdup.cocci.

Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
---

diff -u -p a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
--- a/arch/x86/kernel/process_64.c 2011-11-07 19:37:39.656492567 +0100
+++ b/arch/x86/kernel/process_64.c 2011-11-08 11:02:12.018560408 +0100
@@ -293,13 +293,12 @@ int copy_thread(unsigned long clone_flag
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
 
