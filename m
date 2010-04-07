Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932419Ab0DGBUR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 21:20:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16168 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932370Ab0DGBUN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 21:20:13 -0400
Message-ID: <4BBBDD64.9030800@redhat.com>
Date: Tue, 06 Apr 2010 21:18:28 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Lightning/1.0b2pre Thunderbird/3.0.1
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Borislav Petkov <bp@alien8.de>, Andrew Morton <akpm@linux-foundation.org>,
       Minchan Kim <minchan.kim@gmail.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Nick Piggin <npiggin@suse.de>, Andrea Arcangeli <aarcange@redhat.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, sgunderson@bigfoot.com
Subject: Re: Ugly rmap NULL ptr deref oopsie on hibernate (was Linux 2.6.34-rc3)
References: <alpine.LFD.2.00.1004060841460.3487@i5.linux-foundation.org> <1270571019.1814.163.camel@barrios-desktop> <alpine.LFD.2.00.1004060926430.3487@i5.linux-foundation.org> <1270572327.1711.3.camel@barrios-desktop> <alpine.LFD.2.00.1004060951030.3487@i5.linux-foundation.org> <4BBB69A9.5090906@redhat.com> <alpine.LFD.2.00.1004061053450.3487@i5.linux-foundation.org> <20100406120315.53ad7390.akpm@linux-foundation.org> <20100406194238.GB20357@a1.tnic> <alpine.LFD.2.00.1004061243240.3487@i5.linux-foundation.org> <20100406205123.GC20357@a1.tnic> <alpine.LFD.2.00.1004061403170.3487@i5.linux-foundation.org> <4BBBC240.3090302@redhat.com> <alpine.LFD.2.00.1004061707250.3487@i5.linux-foundation.org>
In-Reply-To: <alpine.LFD.2.00.1004061707250.3487@i5.linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/06/2010 08:10 PM, Linus Torvalds wrote:

> That said, the code that _really_ confuses me is the stuff that uses
> "anon_vma_clone()". Could you please also explain the code flow of
> vma_adjust() to mere mortals, please?

That's easier said than done.  I spent 3 days with pen and paper,
going over that code before I made the anon_vma changes, first
verifying that the code is indeed correct and then figuring out
how I could make the anon_vma changes safely.

I am not happy with the complexity of the code around vma_adjust,
but could not find a way to simplify it and still keep merging
VMAs the way we do.

My largest change to vma_adjust was moving some code closer to
the beginning of the function, so I could bail out if the
allocation failed, without making change to the vma...

> I suspect Borislav is sleeping. But at least we have a patch for him to
> test when he wakes up ;)

I am looking forward to the test results.

