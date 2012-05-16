Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966179Ab2EPM5K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 08:57:10 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:37824 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750838Ab2EPM5H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 08:57:07 -0400
Message-ID: <4FB3A416.9010703@gmail.com>
Date: Wed, 16 May 2012 20:56:54 +0800
From: "nai.xia" <nai.xia@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Johannes Weiner <hannes@cmpxchg.org>
CC: linux-mm@kvack.org, Rik van Riel <riel@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, Mel Gorman <mgorman@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Minchan Kim <minchan.kim@gmail.com>, Hugh Dickins <hughd@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 0/5] refault distance-based file cache sizing
References: <1335861713-4573-1-git-send-email-hannes@cmpxchg.org> <4FB33A4E.1010208@gmail.com> <20120516065132.GC1769@cmpxchg.org>
In-Reply-To: <20120516065132.GC1769@cmpxchg.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 2012/05/16 14:51, Johannes Weiner wrote:
> Hi Nai,
>
> On Wed, May 16, 2012 at 01:25:34PM +0800, nai.xia wrote:
>> Hi Johannes,
>>
>> Just out of curiosity(since I didn't study deep into the
>> reclaiming algorithms), I can recall from here that around 2005,
>> there was an(or some?) implementation of the "Clock-pro" algorithm
>> which also have the idea of "reuse distance", but it seems that algo
>> did not work well enough to get merged? Does this patch series finally
>> solve the problem(s) with "Clock-pro" or totally doesn't have to worry
>> about the similar problems?
>
> As far as I understood, clock-pro set out to solve more problems than
> my patch set and it failed to satisfy everybody.
>
> The main error case was that it could not partially cache data of a
> set that was bigger than memory.  Instead, looping over the file
> repeatedly always has to read every single page because the most
> recent page allocations would push out the pages needed in the nearest
> future.  I never promised to solve this problem in the first place.
> But giving more memory to the big looping load is not useful in our
> current situation, and at least my code protects smaller sets of
> active cache from these loops.  So it's not optimal, but it sucks only
> half as much :)

Yep, I see ;)

>
> There may have been improvements from clock-pro, but it's hard to get
> code merged that does not behave as expected in theory with nobody
> understanding what's going on.
>
> My code is fairly simple, works for the tests I've done and the
> behaviour observed so far is understood (at least by me).

OK, I assume that you do aware that the system you constructed with
this simple and understandable idea looks like a so called "feedback
system"? Or in other words, I think theoretically the refault-distance
of a page before and after your algorithm is applied is not the same.
And this changed refault-distance pattern is then feed as input into
your algorithm. A feedback system may be hard(and may be simple) to
analyze but may also work well magically.

Well, again I confess I've not done enough course in this area. Just hope
that my words can help you think more comprehensively. :)


Thanks,

Nai
