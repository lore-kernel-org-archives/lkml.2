Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752997Ab1KECVR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Nov 2011 22:21:17 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:33871 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752180Ab1KECVR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Nov 2011 22:21:17 -0400
MIME-Version: 1.0
In-Reply-To: <6389467.vmEs7mxtWt@pawels>
References: <20111031171441.GD3466@redhat.com>
	<alpine.LSU.2.00.1111032318290.2058@sister.anvils>
	<CAPQyPG4DNofTw=rqJXPTbo3w4xGMdPF3SYt3qyQCWXYsDLa08A@mail.gmail.com>
	<6389467.vmEs7mxtWt@pawels>
Date: Sat, 5 Nov 2011 10:21:15 +0800
Message-ID: <CAPQyPG5FUsibQo0B_VHBSkDKJWc7QqZ3NLTTSwZfAKqSvjLO5A@mail.gmail.com>
Subject: Re: [PATCH] mremap: enforce rmap src/dst vma ordering in case of
 vma_merge succeeding in copy_vma
From: Nai Xia <nai.xia@gmail.com>
To: Pawel Sikora <pluto@agmk.net>
Cc: Hugh Dickins <hughd@google.com>, Andrea Arcangeli <aarcange@redhat.com>,
        Mel Gorman <mgorman@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        jpiszcz@lucidpixels.com, arekm@pld-linux.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 4, 2011 at 11:59 PM, Pawel Sikora <pluto@agmk.net> wrote:
> On Friday 04 of November 2011 22:34:54 Nai Xia wrote:
>> On Fri, Nov 4, 2011 at 3:31 PM, Hugh Dickins <hughd@google.com> wrote:
>> > On Mon, 31 Oct 2011, Andrea Arcangeli wrote:
>> >
>> >> migrate was doing a rmap_walk with speculative lock-less access on
>> >> pagetables. That could lead it to not serialize properly against
>> >> mremap PT locks. But a second problem remains in the order of vmas in
>> >> the same_anon_vma list used by the rmap_walk.
>> >
>> > I do think that Nai Xia deserves special credit for thinking deeper
>> > into this than the rest of us (before you came back): something like
>> >
>> > Issue-conceived-by: Nai Xia <nai.xia@gmail.com>
>>
>> Thanks! ;-)
>
> hi all,
>
> i'm still testing anon_vma_order_tail() patch. 10 days of heavy processing
> and machine is still stable but i've recorded some interesting thing:
>
> $ uname -a
> Linux hal 3.0.8-vs2.3.1-dirty #6 SMP Tue Oct 25 10:07:50 CEST 2011 x86_64 AMD_Opteron(tm)_Processor_6128 PLD Linux
> $ uptime
>  16:47:44 up 10 days,  4:21,  5 users,  load average: 19.55, 19.15, 18.76
> $ ps aux|grep migration
> root         6  0.0  0.0      0     0 ?        S    Oct25   0:00 [migration/0]
> root         8 68.0  0.0      0     0 ?        S    Oct25 9974:01 [migration/1]
> root        13 35.4  0.0      0     0 ?        S    Oct25 5202:15 [migration/2]
> root        17 71.4  0.0      0     0 ?        S    Oct25 10479:10 [migration/3]
> root        21 70.7  0.0      0     0 ?        S    Oct25 10370:14 [migration/4]
> root        25 66.1  0.0      0     0 ?        S    Oct25 9698:11 [migration/5]
> root        29 70.1  0.0      0     0 ?        S    Oct25 10283:22 [migration/6]
> root        33 62.6  0.0      0     0 ?        S    Oct25 9190:28 [migration/7]
> root        37  0.0  0.0      0     0 ?        S    Oct25   0:00 [migration/8]
> root        41 97.7  0.0      0     0 ?        S    Oct25 14338:30 [migration/9]
> root        45 29.2  0.0      0     0 ?        S    Oct25 4290:00 [migration/10]
> root        49 68.7  0.0      0     0 ?        S    Oct25 10081:38 [migration/11]
> root        53 98.7  0.0      0     0 ?        S    Oct25 14477:25 [migration/12]
> root        57 70.0  0.0      0     0 ?        S    Oct25 10272:57 [migration/13]
> root        61 69.7  0.0      0     0 ?        S    Oct25 10232:29 [migration/14]
> root        65 70.9  0.0      0     0 ?        S    Oct25 10403:09 [migration/15]
>
> wow, 71..241 hours in migration processes after 10 days of uptime?
> machine has 2 opteron nodes with 32GB ram paired with each processor.
> i suppose that it spends a lot of time on migration (processes + memory pages).

Hi Paweł, it seems to me an issue related to load balancing but might
not directly
related to this bug or even not related to abnormal page migration.
Can this be a scheduler & interrupts issue?

But oh, well, actually I never ever had touch a 16-core machine
and do heavy processing. So I cannot tell if this result is normal or not.

Maybe you should ask for a broader range of people?

BR,
Nai

>
> BR,
> Paweł.
>
