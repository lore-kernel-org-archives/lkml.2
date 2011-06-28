Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759708Ab1F1Qx6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 12:53:58 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:51798 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758944Ab1F1QxG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 12:53:06 -0400
X-Authority-Analysis: v=1.1 cv=PfPQ8rIoTcZsncbPZjVSZ7K0hy8Zc4hmL68r4VPNpKE= c=1 sm=0 a=vhdKIqpQuCYA:10 a=Z4Z000109gIA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=lNTr_St70bKISO6vLx4A:9 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110628164750.281686775@goodmis.org>
User-Agent: quilt/0.48-1
Date: Tue, 28 Jun 2011 12:47:50 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 0/2] mm: Clean up and document fault and RETRY mmap_sem
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On IRC, Russell King noticed that the code in arch/x86/mm/fault.c
looked buggy with the retry loop and retaking the mmap_sem. But
with further investigation it seems to be correct, but now
handle_mm_fault() has subtle locking with the mmap_sem depending
on what flags are set.

Unfortunately, there's no good comments about what is going on in the
code. Doing various git blame, git show, I dug up the history
and cleaned up the RETRY_NOWAIT and added documentation to the
handle_mm_fault().


Steven Rostedt (2):
      mm: Remove use of ALLOW_RETRY when RETRY_NOWAIT is set
      mm: Document handle_mm_fault()

----
 include/linux/mm.h |    4 ++--
 mm/filemap.c       |   14 +++++++-------
 mm/memory.c        |   24 +++++++++++++++++++++---
 3 files changed, 30 insertions(+), 12 deletions(-)
