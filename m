Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758042Ab1ELVy7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 17:54:59 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:49449 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757916Ab1ELVy6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 17:54:58 -0400
Date: Thu, 12 May 2011 23:54:52 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Stephane Eranian <eranian@google.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [BUG] perf: bogus correlation of kernel symbols
Message-ID: <20110512215452.GB20939@elte.hu>
References: <BANLkTim8mAzZbdOhBodaOFKM5esP-Q+K7g@mail.gmail.com>
 <BANLkTi==OatTqfDbnAmHQA0t2DmokEd-CA@mail.gmail.com>
 <BANLkTik7wQc05OQTHThBbrFhKx2pM1Tx+A@mail.gmail.com>
 <20110512213657.GC17596@elte.hu>
 <BANLkTi=O-59PS5cXevufqm741wwH5kuxXg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BANLkTi=O-59PS5cXevufqm741wwH5kuxXg@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Stephane Eranian <eranian@google.com> wrote:

> >> [...] So much for having perf in the kernel source tree to keep things in 
> >> sync...
> >
> > What do you mean?
>
> I meant that when this kptr feature was added, people should have scanned the 
> entire tree (include tools/perf) to look for potential impact on programs 
> relying on /proc/kallsyms. Having perf in the tree should have made this 
> easier to catch. That's all.

It was noticed in another case when there was kallsyms twiddling going on so it 
depends. What wasnt noticed here was how the present but zero value symbols:

 0000000000000000 D irq_stack_union
 0000000000000000 D __per_cpu_start
 0000000000000000 D gdt_page
 0000000000000000 d exception_stacks
 0000000000000000 d tlb_vector_offset
 0000000000000000 d shared_msrs
 0000000000000000 d cpu_tsc_khz

caused the symbol code of perf consider them non-existing.

Perf being in-tree wont magically avoid all bugs, so you should not expect that 
magical effect from tool integration into the kernel tree.

Thanks,

	Ingo
