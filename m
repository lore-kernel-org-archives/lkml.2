Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754102Ab1JUJH6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Oct 2011 05:07:58 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:64593 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753893Ab1JUJH5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Oct 2011 05:07:57 -0400
MIME-Version: 1.0
In-Reply-To: <2109011.boM0eZ0ZTE@pawels>
References: <201110122012.33767.pluto@agmk.net>
	<CANsGZ6a6_q8+88FRV2froBsVEq7GhtKd9fRnB-0M2MD3a7tnSw@mail.gmail.com>
	<CAPQyPG6d3Sv26SiR6Xj4S5xOOy2DmrwQYO2wAwzrcg=2A0EcMQ@mail.gmail.com>
	<2109011.boM0eZ0ZTE@pawels>
Date: Fri, 21 Oct 2011 17:07:56 +0800
Message-ID: <CAPQyPG4SE8DyzuqwG74sE2zuZbDgfDoGDir1xHC3zdED+k=qLA@mail.gmail.com>
Subject: Re: kernel 3.0: BUG: soft lockup: find_get_pages+0x51/0x110
From: Nai Xia <nai.xia@gmail.com>
To: Pawel Sikora <pluto@agmk.net>
Cc: Hugh Dickins <hughd@google.com>, arekm@pld-linux.org,
        Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org,
        Mel Gorman <mgorman@suse.de>, jpiszcz@lucidpixels.com,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 21, 2011 at 4:07 PM, Pawel Sikora <pluto@agmk.net> wrote:
> On Friday 21 of October 2011 14:22:37 Nai Xia wrote:
>
>> And as a side note. Since I notice that Pawel's workload may include OOM,
>
> my last tests on patched (3.0.4 + migrate.c fix + vserver) kernel produce full cpu load
> on dual 8-cores opterons like on this htop screenshot -> http://pluto.agmk.net/kernel/screen1.png
> afaics all userspace applications usualy don't use more than half of physical memory
> and so called "cache" on htop bar doesn't reach the 100%.

OK，did you logged any OOM killing if there was some memory usage burst?
But, well my above OOM reasoning is a direct short cut to imagined
root cause of "adjacent VMAs which
should have been merged but in fact not merged" case.
Maybe there are other cases that can lead to this or maybe it's
totally another bug....

But still I think if my reasoning is good, similar bad things will
happen again some time in the future,
even if it was not your case here...

>
> the patched kernel with disabled CONFIG_TRANSPARENT_HUGEPAGE (new thing in 2.6.38)
> died at night, so now i'm going to disable also CONFIG_COMPACTION/MIGRATION in next
> steps and stress this machine again...

OK, it's smart to narrow down the range first....

>
>
