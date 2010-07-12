Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755212Ab0GLN7w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 09:59:52 -0400
Received: from nlpi157.sbcis.sbc.com ([207.115.36.171]:51765 "EHLO
	nlpi157.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754155Ab0GLN7u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 09:59:50 -0400
Date: Mon, 12 Jul 2010 08:55:04 -0500 (CDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@router.home
To: Tejun Heo <tj@kernel.org>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Rusty Russell <rusty@rustcorp.com.au>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [RFC PATCH] x86-64: software IRQ masking and handling
In-Reply-To: <4C3AC5C4.5090505@kernel.org>
Message-ID: <alpine.DEB.2.00.1007120852400.14328@router.home>
References: <4C3A06E3.50402@kernel.org> <AANLkTik8EHarsrnAisuj9SKbeXddlA6Dz-KzDOPsmBxh@mail.gmail.com> <4C3AC5C4.5090505@kernel.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Jul 2010, Tejun Heo wrote:

> I'm not very convinced either.  Nehalems are said to be able to do
> cli-sti sequences every 13 cycles or so, which sounds pretty good and
> managing it asynchronously might not buy anything.  But what they said
> was cli-sti bandwidth, probably meaning that if you do cli-sti's in
> succession or tight loop, each iteration will take 13 cycles.  So,
> there still could be cost related to instruction scheduling.

Note that Andi has repeatedly pointed out that it is not the cli-sti
instructions that cause the most latencies but the pushf/popf etc stack
operations.

> It only took me a couple of days to get it working and the changes are
> pretty localized, so I think it's worthwhile to see whether it
> actually helps anything on x86.  I'm thinking about doing raw IOs on
> SSDs which isn't too unrealistic and heavy on both IRQ masking and IRQ
> handling although actual hardware access cost might just drown any
> difference and workloads which are heavy on memory allocations and
> such might be better fit.  If you have any better ideas on testing,
> please let me know.

If it is a win for local_irq_save/restore then it will help any slab
allocator because the alloc / free hotpath must disable interupts to be
usable from hardware interrupps.

