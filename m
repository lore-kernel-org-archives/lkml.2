Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757510Ab2DISEs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 14:04:48 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:34332 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754139Ab2DISEr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 14:04:47 -0400
Message-ID: <4F83249B.2020701@linaro.org>
Date: Mon, 09 Apr 2012 11:04:11 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120310 Thunderbird/11.0
MIME-Version: 1.0
To: Sasha Levin <levinsasha928@gmail.com>
CC: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        Robert Love <rlove@google.com>, Mel Gorman <mel@csn.ul.ie>,
        Hugh Dickins <hughd@google.com>, Dave Hansen <dave@linux.vnet.ibm.com>,
        Rik van Riel <riel@redhat.com>,
        Dmitry Adamushko <dmitry.adamushko@gmail.com>,
        Dave Chinner <david@fromorbit.com>, Neil Brown <neilb@suse.de>,
        Andrea Righi <andrea@betterlinux.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Pekka Enberg <penberg@kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 1/2] [RFC] Range tree implementation
References: <1333757338-6854-1-git-send-email-john.stultz@linaro.org> <1333757338-6854-2-git-send-email-john.stultz@linaro.org> <CA+1xoqcezDdeNHoLF0R0OxB9EeQaopn4jhs+yC-FieXP+b=RZw@mail.gmail.com>
In-Reply-To: <CA+1xoqcezDdeNHoLF0R0OxB9EeQaopn4jhs+yC-FieXP+b=RZw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12040918-7182-0000-0000-0000013725EE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/07/2012 10:36 AM, Sasha Levin wrote:
> On Sat, Apr 7, 2012 at 2:08 AM, John Stultz<john.stultz@linaro.org>  wrote:
>> After Andrew suggested something like his mumbletree idea
>> to better store a list of ranges, I worked on a few different
>> approaches, and this is what I've finally managed to get working.
>>
>> I suspect range-tree isn't a totally accurate name, but I
>> couldn't quite make out the difference between range trees
>> and interval trees, so I just picked one to call it. Do
>> let me know if you have a better name.
>>
>> The idea of storing ranges in a tree is nice, but has a number
>> of complications. When adding a range, its possible that a
>> large range will consume and merge a number of smaller ranges.
>> When removing a range, its possible you may end up splitting an
>> existing range, causing one range to become two. This makes it
>> very difficult to provide generic list_head like behavior, as
>> the parent structures would need to be duplicated and removed,
>> and that has lots of memory ownership issues.
>>
>> So, this is a much simplified and more list_head like
>> implementation. You can add a node to a tree, or remove a node
>> to a tree, but the generic implementation doesn't do the
>> merging or splitting for you. But it does provide helpers to
>> find overlapping and adjacent ranges.
>>
>> Andrew also really wanted this range-tree implementation to be
>> resuable so we don't duplicate the file locking logic. I'm not
>> totally convinced that the requirements between the volatile
>> ranges and file locking are really equivelent, but this reduced
>> impelementation may make it possible.
>>
>> Do let me know what you think or if you have other ideas for
>> better ways to do the same.
> Hi John,
>
> I have implemented an interval lookup tree using the augmented
> features of the in-kernel rbtree for the KVM tools project. We
> currently use it for several things as a framework code such as MMIO
> memory mapping.
>
>  From what I see in the patch, you haven't fully implemented the
> interval structure (it needs to keep track of additional parameters
> when building it, and the search is a bit different and is based on
> those parameters).
Any more details on whats missing/different? Or the pros/cons of the 
different approaches?

> I could send that code as a patch against the kernel tree if something
> like that is actually required for the kernel at this point.
>
Sure.  I'm not married to this implementation (its just the only one so 
far that solves my needs - Dmitry already pointed out that the priotree 
might be close to sufficient, but I've not yet tried to adapt it), and 
whatever goes upstream needs to be generic enough to solve the related 
problems that a number of folks are all working on solving.  So seeing 
your approach might be good too.

thanks
-john


