Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756267Ab0DGVxu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 17:53:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1824 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756321Ab0DGVxq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 17:53:46 -0400
Message-ID: <4BBCFE8A.1030602@redhat.com>
Date: Wed, 07 Apr 2010 17:52:10 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Lightning/1.0b2pre Thunderbird/3.0.1
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
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
References: <alpine.LFD.2.00.1004061609320.3487@i5.linux-foundation.org> <20100406195459.554265e7@annuminas.surriel.com> <20100407151357.FB7E.A69D9226@jp.fujitsu.com> <20100407105454.2e7ab9bf@annuminas.surriel.com> <alpine.LFD.2.00.1004070827140.3487@i5.linux-foundation.org> <4BBCAA5B.7080603@redhat.com> <alpine.LFD.2.00.1004070951330.3487@i5.linux-foundation.org> <alpine.LFD.2.00.1004071415170.3586@i5.linux-foundation.org>
In-Reply-To: <alpine.LFD.2.00.1004071415170.3586@i5.linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/07/2010 05:19 PM, Linus Torvalds wrote:

> Comments?

I remember there being an "unfixable" spot with this
approach when I originally wrote the new anon_vma
linking code.

However, I can't for the life of me find that spot.
I am starting to believe I made it fixable as a side
effect of one of the changes I made :)

One of the issues with your patch is that anon_vma_prepare
can fail and this patch ignores its return value.

Having anon_vma-prepare fail after an mremap or mprotect
might result in messing up the VMAs of a process, or having
to undo the VMA changes that were made.

In fact, this may be the problem I was running into - not
wanting to add even more complex error paths to the vma
shuffling code.
