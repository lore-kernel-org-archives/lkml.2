Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753198Ab0KECgI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 22:36:08 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:57184 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752670Ab0KECgH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 22:36:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=Hohha05FT1GiG6+zkzwTR8aY+xtsphy06BiWGU7IOcSV+eoXI4ZWzuFWpZNSCKlDcn
         QOaF2weK2/eb7QvU0AyVKwhfA0fBDf8FKmr5MuQS2PViz448m7CIWtNruzg+L+8cJjMO
         xIcgltxCVSO0xxVBmngWb1gl3pjP2xHk3dn4I=
MIME-Version: 1.0
In-Reply-To: <20101104015249.GD19646@google.com>
References: <20101028191523.GA14972@google.com>
	<20101101012322.605C.A69D9226@jp.fujitsu.com>
	<20101101182416.GB31189@google.com>
	<AANLkTimCjUgy9sN5QzxwW960v9eNWAjMBdq3H6P20NUa@mail.gmail.com>
	<20101104015249.GD19646@google.com>
Date: Fri, 5 Nov 2010 11:36:05 +0900
Message-ID: <AANLkTim45zjeVoeb3xGFxGa=UzZAz_pV_qUv8o0P_274@mail.gmail.com>
Subject: Re: [PATCH] RFC: vmscan: add min_filelist_kbytes sysctl for
 protecting the working set
From: Minchan Kim <minchan.kim@gmail.com>
To: Mandeep Singh Baines <msb@chromium.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>, Mel Gorman <mel@csn.ul.ie>,
        Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, wad@chromium.org, olofj@chromium.org,
        hughd@chromium.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 4, 2010 at 10:52 AM, Mandeep Singh Baines <msb@chromium.org> wrote:
> Minchan Kim (minchan.kim@gmail.com) wrote:
>> On Tue, Nov 2, 2010 at 3:24 AM, Mandeep Singh Baines <msb@chromium.org> wrote:
>> > I see memcg more as an isolation mechanism but I guess you could use it to
>> > isolate the working set from anon browser tab data as Kamezawa suggests.
>>
>>
>> I don't think current VM behavior has a problem.
>> Current problem is that you use up many memory than real memory.
>> As system memory without swap is low, VM doesn't have a many choice.
>> It ends up evict your working set to meet for user request. It's very
>> natural result for greedy user.
>>
>> Rather than OOM notifier, what we need is memory notifier.
>> AFAIR, before some years ago, KOSAKI tried similar thing .
>> http://lwn.net/Articles/268732/
>
> Thanks! This is perfect. I wonder why its not merged. Was a different
> solution eventually implemented? Is there another way of doing the
> same thing?

If my remember is right, there was timing issue.
When the application is notified, it was too late to handle it.
Mabye KOSAKI can explain more detail problem.

I think we need some leveling mechanism.
For example, user can set the limits 30M, 20M, 10M, 5M.

If free memory is low below 30M, master application can require
freeing of extra memory of background sleeping application.
If free memory is low below 20M, master application can require
existing of background sleeping application.
If free memory is low below 10M, master application can kill
none-critical application.
If free memory is low below 5M, master application can require freeing
of memory of critical application.

I think this mechanism would be useful memcg, too.

>
>> (I can't remember why KOSAKI quit it exactly, AFAIR, some signal time
>> can't meet yours requirement. I mean when the user receive the memory
>> low signal, it's too late. Maybe there are other causes for KOSAKi to
>> quit it.)
>> Anyway, If the system memory is low, your intelligent middleware can
>> control it very well than VM.
>
> Agree.
>
>> In this chance, how about improving it?
>> Mandeep, Could you feel needing this feature?
>>
>
> mem_notify seems perfect.

BTW, Regardless of mem_notify, I think this patch is useful in general
system, too.
We have to progress this patch.

>
>>
>>
>> > Regards,
>> > Mandeep
>> >
>> >> Thanks.
>> >>
>> >>
>> >>
>> >
>>
>>
>>
>> --
>> Kind regards,
>> Minchan Kim
>



-- 
Kind regards,
Minchan Kim
