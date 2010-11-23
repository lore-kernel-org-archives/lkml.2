Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751301Ab0KWIpA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 03:45:00 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:59696 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750793Ab0KWIo7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 03:44:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=dod5JV+Koy7S1z1GO5+++UHQ2iQ7rWSJbP0gpfva9gw3UHomxDkSQXOOJwI5/Ufd6/
         QSyh5cIJck7quEOvlfXv76BeBC2KShcdDIxDWlyEJg1XD6zxDWY1uqBfIwDqcr3M6riX
         Az1igvIKcFylTwUekJRgJC0Wkyl+C9tE9OgH4=
MIME-Version: 1.0
In-Reply-To: <20101123165240.7BC2.A69D9226@jp.fujitsu.com>
References: <20101122143817.E242.A69D9226@jp.fujitsu.com>
	<AANLkTinZmv540r+EkjwUu6cd9c1u7qG9iR+pvp3YqZC1@mail.gmail.com>
	<20101123165240.7BC2.A69D9226@jp.fujitsu.com>
Date: Tue, 23 Nov 2010 17:44:57 +0900
Message-ID: <AANLkTi=ibOd3OUZ5D-V60iaNcP0_eND2VrcJB+PBo8mD@mail.gmail.com>
Subject: Re: [RFC 1/2] deactive invalidated pages
From: Minchan Kim <minchan.kim@gmail.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Rik van Riel <riel@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Nick Piggin <npiggin@kernel.dk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 23, 2010 at 5:01 PM, KOSAKI Motohiro
<kosaki.motohiro@jp.fujitsu.com> wrote:
>> Hi KOSAKI,
>>
>> 2010/11/23 KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>:
>> >> By Other approach, app developer uses POSIX_FADV_DONTNEED.
>> >> But it has a problem. If kernel meets page is writing
>> >> during invalidate_mapping_pages, it can't work.
>> >> It is very hard for application programmer to use it.
>> >> Because they always have to sync data before calling
>> >> fadivse(..POSIX_FADV_DONTNEED) to make sure the pages could
>> >> be discardable. At last, they can't use deferred write of kernel
>> >> so that they could see performance loss.
>> >> (http://insights.oetiker.ch/linux/fadvise.html)
>> >
>> > If rsync use the above url patch, we don't need your patch.
>> > fdatasync() + POSIX_FADV_DONTNEED should work fine.
>>
>> It works well. But it needs always fdatasync before calling fadvise.
>> For small file, it hurt performance since we can't use the deferred write.
>
> I doubt rsync need to call fdatasync. Why?
>
> If rsync continue to do following loop, some POSIX_FADV_DONTNEED
> may not drop some dirty pages. But they can be dropped at next loop's
> POSIX_FADV_DONTNEED. Then, It doesn't make serious issue.
>
> 1) read
> 2) write
> 3) POSIX_FADV_DONTNEED
> 4) goto 1

fadvise need pair (offset and len).
if the pair in next turn is different with one's previous turn, it
couldn't be dropped.

-- 
Kind regards,
Minchan Kim
