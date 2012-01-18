Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757918Ab2ART7h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 14:59:37 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:46571 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757816Ab2ART7d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 14:59:33 -0500
X-Authority-Analysis: v=2.0 cv=I83ntacg c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=UBy9sU4F98IA:10 a=NlQkGjxtZmsA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=mNJKDWw_57btS4Y4IVsA:9 a=ZOIaYEgeDMlavWx8p3cA:7 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20120118195340.767928915@goodmis.org>
User-Agent: quilt/0.50-1
Date: Wed, 18 Jan 2012 14:53:40 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Jason Baron <jbaron@redhat.com>
Subject: [PATCH 0/2] [RFC] jump-label/x86: Compress jmps to 2 bytes where possible
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


As discussed previously, it can save a lot of text space if we could
use the 2 byte jump for jump labels instead of always using the 5 byte
version. But to do this, the jmps must be put into the kernel first
(always on). Then at compile time, the jmps are examined and converted
to nops.

At boot up, the jump-labels are examined again and the nops are converted
to the CPU native best 5 byte nops for just the 5 byte nop locations.

The actual op is examined to determine if the jmp was 2 or 5 bytes, and
dealt with accordingly.

I forward ported old work I did before and cleaned it up a bit.
This can also be made to make a "default on" case at compile time if
necessary.

Thoughts?

-- Steve



Steven Rostedt (2):
      jump labels: Add infrastructure to update jump labels at compile time
      jump labels/x86: Use etiher 5 byte or 2 byte jumps

----
 Makefile                          |    7 +
 arch/Kconfig                      |    6 +
 arch/x86/Kconfig                  |    1 +
 arch/x86/include/asm/jump_label.h |    2 +-
 arch/x86/kernel/jump_label.c      |   86 +++++++++-
 scripts/Makefile                  |    1 +
 scripts/Makefile.build            |   15 ++-
 scripts/update_jump_label.c       |  335 +++++++++++++++++++++++++++++++++++++
 scripts/update_jump_label.h       |  283 +++++++++++++++++++++++++++++++
 9 files changed, 726 insertions(+), 10 deletions(-)
