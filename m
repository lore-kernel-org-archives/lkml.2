Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752007Ab1GRFa6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jul 2011 01:30:58 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:64811 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750855Ab1GRFa5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jul 2011 01:30:57 -0400
MIME-Version: 1.0
Date: Mon, 18 Jul 2011 09:30:56 +0400
Message-ID: <CABAWUvV2er1niFGcXacMXdzMh46iAA_cHrO1mNaWXMcYc+GW3Q@mail.gmail.com>
Subject: Spinlock assembly clarification
From: Frank Coldwell <spaceportz@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dear friends,

I was looking at spinlock implementation in x86 architecture folder
and this is code i found there:
-----------------------------------------------------------------------------------------------------
static __always_inline void __ticket_spin_lock(arch_spinlock_t *lock)
{
	short inc = 0x0100;

	asm volatile (
		LOCK_PREFIX "xaddw %w0, %1\n"
		"1:\t"
		"cmpb %h0, %b0\n\t"
		"je 2f\n\t"
		"rep ; nop\n\t"
		"movb %1, %b0\n\t"
		/* don't need lfence here, because loads are in-order */
		"jmp 1b\n"
		"2:"
		: "+Q" (inc), "+m" (lock->slock)
		:
		: "memory", "cc");
}
-----------------------------------------------------------------------------------------------------

So to understand this I look at intel manual for these instructions,
and I could not find anything
for instruction xaddw ??

So can anyone can help me understand what this assembly code is doing
and also where are these
assembly instructions converted to real assembly instructions (in gcc maybe) ??

Thanks in advance,
