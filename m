Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753685Ab1KGFsH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 00:48:07 -0500
Received: from mail4.hitachi.co.jp ([133.145.228.5]:40341 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751690Ab1KGFsF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 00:48:05 -0500
X-AuditID: b753bd60-98c60ba00000359c-60-4eb77112b1b6
X-AuditID: b753bd60-98c60ba00000359c-60-4eb77112b1b6
From: Mitsuo Hayasaka <mitsuo.hayasaka.hu@hitachi.com>
Subject: [RFC PATCH 5/5] x86: change range of stack overflow checking
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Randy Dunlap <rdunlap@xenotime.net>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        yrl.pp-manager.tt@hitachi.com,
        Mitsuo Hayasaka <mitsuo.hayasaka.hu@hitachi.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Date: Mon, 07 Nov 2011 14:53:16 +0900
Message-ID: <20111107055315.7928.77663.stgit@ltc219.sdl.hitachi.co.jp>
In-Reply-To: <20111107055108.7928.89454.stgit@ltc219.sdl.hitachi.co.jp>
References: <20111107055108.7928.89454.stgit@ltc219.sdl.hitachi.co.jp>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The original stack overflow checking checks if a stack pointer is
less than or equal to (curbase + THREAD_SIZE) as the 2nd condition.
However, it is not necessary since the 3rd one checks if the pointer
is lower than available stack size. This patch removes the 2nd one.

Signed-off-by: Mitsuo Hayasaka <mitsuo.hayasaka.hu@hitachi.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
---

 arch/x86/kernel/irq_64.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/irq_64.c b/arch/x86/kernel/irq_64.c
index f7baedd..d85b338 100644
--- a/arch/x86/kernel/irq_64.c
+++ b/arch/x86/kernel/irq_64.c
@@ -73,7 +73,6 @@ static inline void stack_overflow_check(struct pt_regs *regs)
 		panic("low stack detected by irq handler - check messages\n");
 #else
 	if (regs->sp >= curbase &&
-		regs->sp <= curbase + THREAD_SIZE &&
 		regs->sp <  curbase + sizeof(struct thread_info) +
 					sizeof(struct pt_regs) + 128) {
 		WARN_ONCE(1,

