Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751947Ab1KGFrH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 00:47:07 -0500
Received: from mail7.hitachi.co.jp ([133.145.228.42]:54466 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751295Ab1KGFrG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 00:47:06 -0500
X-AuditID: b753bd60-a0aaaba0000019f4-a4-4eb770d6ca0a
X-AuditID: b753bd60-a0aaaba0000019f4-a4-4eb770d6ca0a
From: Mitsuo Hayasaka <mitsuo.hayasaka.hu@hitachi.com>
Subject: [RFC PATCH 0/5] x86: check stack overflows more reliably
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Randy Dunlap <rdunlap@xenotime.net>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        yrl.pp-manager.tt@hitachi.com
Date: Mon, 07 Nov 2011 14:51:08 +0900
Message-ID: <20111107055108.7928.89454.stgit@ltc219.sdl.hitachi.co.jp>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patch series adds the following three features about stack
overflow checking. The (2) and (3) features work if their options
are enabled.

(1) add user mode vm check
    The kernel stack overflow is checked in stack_overflow_check(),
    which may wrongly detect the overflow if the user stack pointer
    pointed to the kernel stack accidentally. To avoid this misdetection,
    bail out early if the user stack is used.

(2) check stack overflow in detail
    Currently, only kernel stack is checked for the overflow,
    which is not sufficient for enterprise systems. To enhance
    reliability, expand stack overflow checking to IRQ and 
    exception stacks optionally. This is disabled by default
    in Kconfig.

(3) panic on stack overflow
    Currently, kernel messages are output on the detection of 
    stack overflow. Similarly, its's not sufficient for enterprise
    systems since it may corrupt data. To enhance reliability,
    cause a panic for the overflows according to the sysctl parameter.
    This is disabled by default.

Thanks,

---

Mitsuo Hayasaka (5):
      x86: change range of stack overflow checking
      x86: panic on detection of stack overflow
      x86: add a sysctl parameter to panic on stack overflow
      x86: check stack overflow in detail
      x86: add user_mode_vm check in stack_overflow_check


 Documentation/sysctl/kernel.txt |   13 +++++++++++
 arch/x86/Kconfig.debug          |   11 +++++++++
 arch/x86/kernel/irq_32.c        |    2 ++
 arch/x86/kernel/irq_64.c        |   46 ++++++++++++++++++++++++++++++++++++---
 include/linux/kernel.h          |    1 +
 include/linux/sysctl.h          |    1 +
 kernel/sysctl.c                 |    9 ++++++++
 kernel/sysctl_binary.c          |    1 +
 8 files changed, 80 insertions(+), 4 deletions(-)

-- 
Mitsuo Hayasaka (mitsuo.hayasaka.hu@hitachi.com)
