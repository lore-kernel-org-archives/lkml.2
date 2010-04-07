Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754996Ab0DGWU3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 18:20:29 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42304 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751929Ab0DGWU1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 18:20:27 -0400
Date: Wed, 7 Apr 2010 15:15:21 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Rik van Riel <riel@redhat.com>
cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Borislav Petkov <bp@alien8.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Minchan Kim <minchan.kim@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Nick Piggin <npiggin@suse.de>, Andrea Arcangeli <aarcange@redhat.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, sgunderson@bigfoot.com,
       hannes@cmpxchg.org
Subject: Re: [PATCH -v2] rmap: make anon_vma_prepare link in all the anon_vmas
 of a mergeable VMA
In-Reply-To: <alpine.LFD.2.00.1004071505510.3586@i5.linux-foundation.org>
Message-ID: <alpine.LFD.2.00.1004071510080.3586@i5.linux-foundation.org>
References: <alpine.LFD.2.00.1004061609320.3487@i5.linux-foundation.org> <20100406195459.554265e7@annuminas.surriel.com> <20100407151357.FB7E.A69D9226@jp.fujitsu.com> <20100407105454.2e7ab9bf@annuminas.surriel.com> <alpine.LFD.2.00.1004070827140.3487@i5.linux-foundation.org>
 <4BBCAA5B.7080603@redhat.com> <alpine.LFD.2.00.1004070951330.3487@i5.linux-foundation.org> <alpine.LFD.2.00.1004071415170.3586@i5.linux-foundation.org> <4BBCFE8A.1030602@redhat.com> <alpine.LFD.2.00.1004071505510.3586@i5.linux-foundation.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 7 Apr 2010, Linus Torvalds wrote:
> 
> In the long run, it would be nicer to actually return an error from the 
> mmap() that fails, but that's more complicated, and as mentioned, it's not 
> what the old code used to do either (since the failure point was always at 
> the page fault stage).

Put another way: I'm not proud of it, but the new code isn't any worse 
than what we used to have, and I think the new code is _fixable_.

The easiest way to do that would likely be to pre-allocate the anon_vma 
struct (and anon_vma_chain), and pass it down to anon_vma_prepare. That 
way anon_vma_prepare() itself can never fail, and all we need to do is a 
simple allocation earlier in the call-chain.

			Linus
