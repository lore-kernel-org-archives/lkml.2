Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754081Ab2GIONw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 10:13:52 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:48404 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753705Ab2GIONu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 10:13:50 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1207081547140.18461@chino.kir.corp.google.com>
References: <1341588521-17744-1-git-send-email-js1304@gmail.com>
	<alpine.DEB.2.00.1207070139510.10445@chino.kir.corp.google.com>
	<CAAmzW4PXdpQ2zSnkx8sSScAt1OY0j4+HXVmf=COvP7eMLqrEvQ@mail.gmail.com>
	<alpine.DEB.2.00.1207081547140.18461@chino.kir.corp.google.com>
Date: Mon, 9 Jul 2012 23:13:50 +0900
Message-ID: <CAAmzW4P=Qf1u6spPZCN7o3TRqvwF-rZkZA3eFtAcnCdFg2CDBg@mail.gmail.com>
Subject: Re: [PATCH] mm: don't invoke __alloc_pages_direct_compact when order 0
From: JoonSoo Kim <js1304@gmail.com>
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>,
        Pekka Enberg <penberg@kernel.org>,
        Christoph Lameter <cl@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/7/9 David Rientjes <rientjes@google.com>:
> On Sun, 8 Jul 2012, JoonSoo Kim wrote:
>
>> >> __alloc_pages_direct_compact has many arguments so invoking it is very costly.
>> >> And in almost invoking case, order is 0, so return immediately.
>> >>
>> >
>> > If "zero cost" is "very costly", then this might make sense.
>> >
>> > __alloc_pages_direct_compact() is inlined by gcc.
>>
>> In my kernel image, __alloc_pages_direct_compact() is not inlined by gcc.
>
> Adding Andrew and Mel to the thread since this would require that we
> revert 11e33f6a55ed ("page allocator: break up the allocator entry point
> into fast and slow paths") which would obviously not be a clean revert
> since there have been several changes to these functions over the past
> three years.

Only "__alloc_pages_direct_compact()" is not inlined.
All others (__alloc_pages_high_priority, __alloc_pages_direct_reclaim,
...) are inlined correctly.
So revert is not needed.

I think __alloc_pages_direct_compact() can't be inlined by gcc,
because it is so big and is invoked two times in __alloc_pages_nodemask().

> I'm stunned (and skeptical) that __alloc_pages_direct_compact() is not
> inlined by your gcc, especially since the kernel must be compiled with
> optimization (either -O1 or -O2 which causes these functions to be
> inlined).  What version of gcc are you using and on what architecture?
> Please do "make mm/page_alloc.s" and send it to me privately, I'll file
> this and fix it up on gcc-bugs.

I will send result of "make mm/page_alloc.s" to you privately.
My environments is "x86_64, GNU C version 4.6.3"

> I'll definitely be following up on this.

Thanks for comments.
