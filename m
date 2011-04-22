Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755453Ab1DVAy0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 20:54:26 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:40532 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751994Ab1DVAyZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 20:54:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=d2AMn8h2PBYz+sw7n4ssg65yagdcCktGLq0fYknSc45M98KWTO5IFZv6O5qar5FlO2
         D8m4z45nMPZk3mlSEEcQ/ZiJ++Dp8deywkxde0QNL2Y3QPqpmurmgIqHMqoSzvX5J0C4
         K7aNz+I9nRelKLgvG4mzS1ZBU3jxC6OdKIsj0=
MIME-Version: 1.0
In-Reply-To: <20110421161402.GS5611@random.random>
References: <20110415101248.GB22688@suse.de>
	<BANLkTik7H+cmA8iToV4j1ncbQqeraCaeTg@mail.gmail.com>
	<20110421110841.GA612@suse.de>
	<20110421142636.GA1835@barrios-desktop>
	<20110421160057.GA28712@suse.de>
	<20110421161402.GS5611@random.random>
Date: Fri, 22 Apr 2011 09:54:24 +0900
Message-ID: <BANLkTi=+fGe-hrV3c8r2jKzWG2BHU0GsFA@mail.gmail.com>
Subject: Re: [PATCH] mm: Check if PTE is already allocated during page fault
From: Minchan Kim <minchan.kim@gmail.com>
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>, akpm@linux-foundation.org,
        raz ben yehuda <raziebe@gmail.com>, riel@redhat.com,
        kosaki.motohiro@jp.fujitsu.com, lkml <linux-kernel@vger.kernel.org>,
        linux-mm@kvack.org, stable@kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrea,

On Fri, Apr 22, 2011 at 1:14 AM, Andrea Arcangeli <aarcange@redhat.com> wrote:
> On Thu, Apr 21, 2011 at 05:00:57PM +0100, Mel Gorman wrote:
>> If you want to create a new patch with either your comment or mine
>> (whichever you prefer) I'll add my ack. I'm about to drop offline
>> for a few days but if it's still there Tuesday, I'll put together an
>> appropriate patch and submit. I'd keep it separate from the other patch
>> because it's a performance fix (which I'd like to see in -stable) where
>> as this is more of a cleanup IMO.
>
> I think the older patch should have more priority agreed. This one may
> actually waste cpu cycles overall, rather than saving them, it
> shouldn't be a common occurrence.
>
> From a code consistency point of view maybe we should just implement a
> pte_alloc macro (to put after pte_alloc_map) and use it in both
> places, and hide the glory details of the unlikely in the macro. When
> implementing pte_alloc, I suggest also adding unlikely to both, I mean
> we added unlikely to the fast path ok, but __pte_alloc is orders of
> magnitude less likely to fail than pte_none, and it still runs 1 every
> 512 4k page faults, so I think __pte_alloc deserves an unlikely too.
>
> Minchan, you suggested this cleanup, so I suggest you to send a patch,
> but if you're busy we can help.

It's no problem to send a patch but I can do it at out-of-office time.
Maybe weekend. :)
Before doing that, let's clear the point. You mentioned  it shouldn't
be a common occurrence but you are suggesting we should do for code
consistency POV. Am I right?

>
> Thanks!
> Andrea
>



-- 
Kind regards,
Minchan Kim
