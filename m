Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757118Ab1CBVAq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 16:00:46 -0500
Received: from mx1.redhat.com ([209.132.183.28]:21173 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754924Ab1CBVAp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 16:00:45 -0500
Message-ID: <4D6EAF93.5000000@redhat.com>
Date: Wed, 02 Mar 2011 15:58:59 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100720 Fedora/3.1.1-1.fc13 Lightning/1.0b2pre Thunderbird/3.1.1
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, linux-mm@kvack.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        David Miller <davem@davemloft.net>,
        Hugh Dickins <hugh.dickins@tiscali.co.uk>, Mel Gorman <mel@csn.ul.ie>,
        Nick Piggin <npiggin@kernel.dk>, Russell King <rmk@arm.linux.org.uk>,
        Chris Metcalf <cmetcalf@tilera.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: [RFC][PATCH 2/6] mm: Change flush_tlb_range() to take an mm_struct
References: <20110302175928.022902359@chello.nl> <20110302180258.956518392@chello.nl> <AANLkTimhWKhHojZ-9XZGSh3OzfPhvo__Dib9VfeMWoBQ@mail.gmail.com>
In-Reply-To: <AANLkTimhWKhHojZ-9XZGSh3OzfPhvo__Dib9VfeMWoBQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/02/2011 02:19 PM, Linus Torvalds wrote:

>> There are various reasons that we need to flush TLBs _after_ freeing
>> the page-tables themselves. For some architectures (x86 among others)
>> this serializes against (both hardware and software) page table
>> walkers like gup_fast().
>
> This part of the changelog also makes no sense what-so-ever. It's
> actively wrong.
>
> On x86, we absolutely *must* do the TLB flush _before_ we release the
> page tables. So your commentary is actively wrong and misleading.
>
> The order has to be:
>   - clear the page table entry, queue the page to be free'd
>   - flush the TLB
>   - free the page (and page tables)
>
> and nothing else is correct, afaik. So the changelog is pure and utter
> garbage. I didn't look at what the patch actually changed.

The patch seems to preserve the correct behaviour.

The changelog should probably read something along the
lines of:

"There are various reasons that we need to flush TLBs _after_
  clearing the page-table entries themselves."
