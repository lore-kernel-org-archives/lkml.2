Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755362Ab2D3Iga (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 04:36:30 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:50273 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753361Ab2D3Ig3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 04:36:29 -0400
X-AuditID: 9c930179-b7bfaae000006f69-52-4f9e4f0b2ebf
Message-ID: <4F9E4F0A.8030900@kernel.org>
Date: Mon, 30 Apr 2012 17:36:26 +0900
From: Minchan Kim <minchan@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120410 Thunderbird/11.0.1
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel.mm,gmane.linux.kernel
To: Pekka Enberg <penberg@kernel.org>
CC: linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        Leonid Moiseichuk <leonid.moiseichuk@nokia.com>
Subject: Re: vmevent: question?
References: <4F9E39F1.5030600@kernel.org> <CAOJsxLE3A3b5HSrRm0NVCBmzv7AAs-RWEiZC1BL=se309+=WTA@mail.gmail.com> <4F9E44AD.8020701@kernel.org> <CAOJsxLGd_-ZSxpY2sL8XqyiYxpnmYDJJ+Hfx-zi1Ty=-1igcLA@mail.gmail.com>
In-Reply-To: <CAOJsxLGd_-ZSxpY2sL8XqyiYxpnmYDJJ+Hfx-zi1Ty=-1igcLA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/30/2012 05:01 PM, Pekka Enberg wrote:

> Hi Minchan,
> 
> On Mon, Apr 30, 2012 at 10:52 AM, Minchan Kim <minchan@kernel.org> wrote:
>>> It makes the userspace side simpler for "lowmem notification" use
>>> case. I'm open to changing the ABI if it doesn't make the userspace
>>> side too complex.
>>
>> Yes. I understand your point but if we still consider all of values,
>> we don't have any way to capture exact values except triggered event value.
>> I mean there is no lock to keep consistency.
>> If stale data is okay, no problem but IMHO, it could make user very confusing.
>> So let's return value for first matched event if various event match.
>> Of course, let's write down it in ABI.
>> If there is other idea for reporting all of item with consistent, I'm okay.
> 
> What kind of consistency guarantees do you mean? The data sent to
> userspace is always a snapshot of the state and therefore can be stale
> by the time it reaches userspace.


Consistency between component of snapshot.
let's assume following as

1. User expect some events's value would be minus when event he expect happen.
   A : -3, B : -4, C : -5, D : -6
2. Logically, it's not possible to mix plus and minus values for the events.
   A : -3, B : -4, C : -5, D : -6 ( O )
   A : -3, B : -4, C : 1, D : 2   ( X )
   
But in current implementation, some of those could be minus and some of those could be plus.
Which event could user believe?
At least, we need a _captured_ value when event triggered so that user can ignore other values.

> 
> If your code needs stricter consistency guarantees, you probably want
> to do it in the kernel.
> 
>                                 Pekka
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Fight unfair telecom internet charges in Canada: sign http://stopthemeter.ca/
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
> 



-- 
Kind regards,
Minchan Kim
