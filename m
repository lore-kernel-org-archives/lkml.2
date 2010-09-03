Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751339Ab0ICE23 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 00:28:29 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:55033 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750748Ab0ICE22 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 00:28:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=XIlKoooXF4fAbyh5scDGaXEYSyJi0c1zuC5BUPbjkXy0XlriGUd76utEu1ovQUOSEi
         DjAeMufx2qTz7VJyG6yV2mtaVzInxQWIP+OYCTKn4gIIYEAGxd6/TTnEi6dyl0THG0bA
         aKIgONxDyy8277T8mL7pO2peSwqCM5miSPdjo=
MIME-Version: 1.0
In-Reply-To: <201009022204.14661.rjw@sisk.pl>
References: <1283442461-16290-1-git-send-email-minchan.kim@gmail.com>
	<201009022204.14661.rjw@sisk.pl>
Date: Fri, 3 Sep 2010 13:28:27 +0900
Message-ID: <AANLkTinNZYQ7WV_xu7_WE-ekPhHOjqsfr9xtnW3m9r1V@mail.gmail.com>
Subject: Re: [PATCH] vmscan: don't use return value trick when oom_killer_disabled
From: Minchan Kim <minchan.kim@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>, Rik van Riel <riel@redhat.com>,
        "M. Vefa Bicakci" <bicave@superonline.com>, stable@kernel.org,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/9/3 Rafael J. Wysocki <rjw@sisk.pl>:
> On Thursday, September 02, 2010, Minchan Kim wrote:
>> M. Vefa Bicakci reported 2.6.35 kernel hang up when hibernation on his
>> 32bit 3GB mem machine. (https://bugzilla.kernel.org/show_bug.cgi?id=16771)
>> Also he was bisected first bad commit is below
>>
>>   commit bb21c7ce18eff8e6e7877ca1d06c6db719376e3c
>>   Author: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
>>   Date:   Fri Jun 4 14:15:05 2010 -0700
>>
>>      vmscan: fix do_try_to_free_pages() return value when priority==0 reclaim failure
>>
>> At first impression, this seemed very strange because the above commit only
>> chenged function return value and hibernate_preallocate_memory() ignore
>> return value of shrink_all_memory(). But it's related.
>>
>> Now, page allocation from hibernation code may enter infinite loop if
>> the system has highmem.
>>
>> The reasons are two. 1) hibernate_preallocate_memory() call
>> alloc_pages() wrong order
>
> This isn't the case, as explained here: http://lkml.org/lkml/2010/9/1/316 .
>
> The ordering of calls is correct, but it's better to check if there are any
> non-highmem pages to allocate from before the last call (for performance
> reasons, but that also would eliminate the failure in question).

I actually didn't look into the 1) problem detail.
Just copy and paste from KOSAKI's description.
As I look the thread, KOSAKI seem to admit the description is wrong.
I will resend the patch removing phrase about 1) problem if KOSAKI don't mind.
KOSAKI. Is it okay?

Thanks.


-- 
Kind regards,
Minchan Kim
