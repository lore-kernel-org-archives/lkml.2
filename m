Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423497Ab2KNWMg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 17:12:36 -0500
Received: from mx1.redhat.com ([209.132.183.28]:19025 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933152Ab2KNWMf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 17:12:35 -0500
Message-ID: <50A41583.6060709@redhat.com>
Date: Wed, 14 Nov 2012 17:04:51 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>, Paul Turner <pjt@google.com>,
        Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
        Christoph Lameter <cl@linux.com>, Mel Gorman <mgorman@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>, Hugh Dickins <hughd@google.com>
Subject: Re: [PATCH 0/2] change_protection(): Count the number of pages affected
References: <1352883029-7885-1-git-send-email-mingo@kernel.org> <CA+55aFz_JnoR73O46YWhZn2A4t_CSUkGzMMprCUpvR79TVMCEQ@mail.gmail.com> <50A3E659.9060804@redhat.com> <CA+55aFy1d6pO5Ut15G7tbsQBXr1f5UyEvaQ_O5vMYFcy6wLwfg@mail.gmail.com>
In-Reply-To: <CA+55aFy1d6pO5Ut15G7tbsQBXr1f5UyEvaQ_O5vMYFcy6wLwfg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/14/2012 03:52 PM, Linus Torvalds wrote:
> On Wed, Nov 14, 2012 at 10:43 AM, Rik van Riel <riel@redhat.com> wrote:
>>
>>>    - even *more* aggressive: if the bits become strictly more
>>> restrictive
>
> sorry, this was meant to be "permissive", not restrictive.

> My mistake - the point is that if we're changing to a strictly more
> permissive mode, the old state of the page tables and TLB's are
> perfectly "valid", they are just unnecessarily strict. So we'll take a
> fault on some accesses, but that's fine - we can fix things up at
> fault time.

The patches I sent in a few weeks ago do that for do_wp_page,
but I can see how we want the same for mprotect...

> The question then becomes what the access patterns are. The fault
> overhead may well dawrf any TLB flush costs, but it depends on whether
> people tend to do large mprotect() and then just actually change a few
> pages, or whether mprotect() users often then touch all of the area..

If we keep a counter of faults-after-mprotect, we may be able
to figure out automatically what behaviour would be best.

Of course, that gets us into premature optimization, so it is
probably best to do the simple thing for now.

-- 
All rights reversed
