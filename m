Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932342Ab1LEN0j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 08:26:39 -0500
Received: from terminus.zytor.com ([198.137.202.10]:57510 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932227Ab1LEN0g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 08:26:36 -0500
Date: Mon, 5 Dec 2011 05:26:18 -0800
From: tip-bot for Ingo Molnar <mingo@elte.hu>
Message-ID: <tip-53b5650273fea486ac8ac6c1d1e9a6cd17aa31ca@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        rdunlap@xenotime.net, tglx@linutronix.de,
        mitsuo.hayasaka.hu@hitachi.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, rdunlap@xenotime.net, mingo@elte.hu,
        mitsuo.hayasaka.hu@hitachi.com
In-Reply-To: <20111129060836.11076.12323.stgit@ltc219.sdl.hitachi.co.jp>
References: <20111129060836.11076.12323.stgit@ltc219.sdl.hitachi.co.jp>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/debug] x86: Fix the 32-bit stackoverflow-debug build
Git-Commit-ID: 53b5650273fea486ac8ac6c1d1e9a6cd17aa31ca
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 05 Dec 2011 05:26:24 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  53b5650273fea486ac8ac6c1d1e9a6cd17aa31ca
Gitweb:     http://git.kernel.org/tip/53b5650273fea486ac8ac6c1d1e9a6cd17aa31ca
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Mon, 5 Dec 2011 12:25:44 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 5 Dec 2011 12:25:44 +0100

x86: Fix the 32-bit stackoverflow-debug build

The panic_on_stackoverflow variable needs to be avilable
on the 32-bit side as well ...

Cc: Mitsuo Hayasaka <mitsuo.hayasaka.hu@hitachi.com>
Cc: Randy Dunlap <rdunlap@xenotime.net>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Link: http://lkml.kernel.org/r/20111129060836.11076.12323.stgit@ltc219.sdl.hitachi.co.jp
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/irq_32.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/irq_32.c b/arch/x86/kernel/irq_32.c
index e16e99eb..40fc861 100644
--- a/arch/x86/kernel/irq_32.c
+++ b/arch/x86/kernel/irq_32.c
@@ -28,6 +28,9 @@ DEFINE_PER_CPU(struct pt_regs *, irq_regs);
 EXPORT_PER_CPU_SYMBOL(irq_regs);
 
 #ifdef CONFIG_DEBUG_STACKOVERFLOW
+
+int sysctl_panic_on_stackoverflow __read_mostly;
+
 /* Debugging check for stack overflow: is there less than 1KB free? */
 static int check_stack_overflow(void)
 {
