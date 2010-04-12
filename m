Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752270Ab0DLPUw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Apr 2010 11:20:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33371 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751967Ab0DLPUv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Apr 2010 11:20:51 -0400
Message-ID: <4BC33A02.8000307@redhat.com>
Date: Mon, 12 Apr 2010 11:19:30 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Lightning/1.0b2pre Thunderbird/3.0.1
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Borislav Petkov <bp@alien8.de>, Johannes Weiner <hannes@cmpxchg.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Minchan Kim <minchan.kim@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Nick Piggin <npiggin@suse.de>, Andrea Arcangeli <aarcange@redhat.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, sgunderson@bigfoot.com
Subject: Re: [PATCH -v2] rmap: make anon_vma_prepare link in all the anon_vmas
 of a mergeable VMA
References: <20100409191425.GB10780@a1.tnic>	 <alpine.LFD.2.00.1004091227310.3558@i5.linux-foundation.org>	 <20100409204328.GG28964@cmpxchg.org>	 <alpine.LFD.2.00.1004091546350.3558@i5.linux-foundation.org>	 <alpine.LFD.2.00.1004091638290.3558@i5.linux-foundation.org>	 <20100410003110.GI28964@cmpxchg.org>	 <alpine.LFD.2.00.1004091730130.3558@i5.linux-foundation.org>	 <20100410072714.GA9246@liondog.tnic> <20100410112639.GA24708@a1.tnic>	 <alpine.LFD.2.00.1004100821340.3558@i5.linux-foundation.org>	 <20100410163828.GA25579@a1.tnic>	 <alpine.LFD.2.00.1004100947400.3558@i5.linux-foundation.org>	 <alpine.LFD.2.00.1004101101180.3558@i5.linux-foundation.org> <1271083207.4807.18.camel@twins>
In-Reply-To: <1271083207.4807.18.camel@twins>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/12/2010 10:40 AM, Peter Zijlstra wrote:

> So the reason page->mapping isn't cleared in page_remove_rmap() isn't
> detailed beyond a (possible) race with page_add_anon_rmap() (which I
> guess would be reclaim trying to unmap the page and a fault re-instating
> it).
>
> This also complicates the whole page_lock_anon_vma() thing, so it would
> be nice to be able to remove this race and clear page->mapping in
> page_remove_rmap().

For anonymous pages, I don't see where the race comes from.

Both do_swap_page and the reclaim code hold the page lock
across the entire operation, so they are already excluding
each other.

Hugh, do you remember what the race between page_remove_rmap
and page_add_anon_rmap is/was all about?

I don't see a race in the current code...
