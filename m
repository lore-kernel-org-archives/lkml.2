Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754429Ab0KWXpW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 18:45:22 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:64077 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754137Ab0KWXpV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 18:45:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=iakl2hLpGIkalpQtp52z4l2zKBCbnF1ocpjvZ4LCbvCIZ7cLf7QjKO4QR36M6Ddmm7
         npJWqYwLH8OlD9hTbpWVxHSW45u7InOCMYvKXN1TmTXt4NpRTsoH9ocdYniQqqJ5lC2c
         8yCAsYfYvGHXivb86cru3DljYI4w/x35yNc6Q=
MIME-Version: 1.0
In-Reply-To: <20101123221049.GR19571@csn.ul.ie>
References: <bdd6628e81c06f6871983c971d91160fca3f8b5e.1290349672.git.minchan.kim@gmail.com>
	<20101122141449.9de58a2c.akpm@linux-foundation.org>
	<AANLkTimk4JL7hDvLWuHjiXGNYxz8GJ_TypWFC=74Xt1Q@mail.gmail.com>
	<20101122210132.be9962c7.akpm@linux-foundation.org>
	<20101123093859.GE19571@csn.ul.ie>
	<87k4k49jii.fsf@gmail.com>
	<20101123145856.GQ19571@csn.ul.ie>
	<20101123123535.438e9750.akpm@linux-foundation.org>
	<20101123221049.GR19571@csn.ul.ie>
Date: Wed, 24 Nov 2010 08:45:20 +0900
Message-ID: <AANLkTikvsEpQM4=fGj5sH7rS74-KfPL5nq0v18v59MOb@mail.gmail.com>
Subject: Re: [RFC 1/2] deactive invalidated pages
From: Minchan Kim <minchan.kim@gmail.com>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ben Gamari <bgamari@gmail.com>,
        linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Rik van Riel <riel@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Nick Piggin <npiggin@kernel.dk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 24, 2010 at 7:10 AM, Mel Gorman <mel@csn.ul.ie> wrote:
> On Tue, Nov 23, 2010 at 12:35:35PM -0800, Andrew Morton wrote:
>> On Tue, 23 Nov 2010 14:58:56 +0000
>> Mel Gorman <mel@csn.ul.ie> wrote:
>>
>> > On Tue, Nov 23, 2010 at 09:55:49AM -0500, Ben Gamari wrote:
>> > > On Tue, 23 Nov 2010 09:38:59 +0000, Mel Gorman <mel@csn.ul.ie> wrote:
>> > > > > If it's mapped pagecache then the user was being a bit silly (or didn't
>> > > > > know that some other process had mapped the file).  In which case we
>> > > > > need to decide what to do - leave the page alone, deactivate it, or
>> > > > > half-deactivate it as this patch does.
>> > > > >
>> > > >
>> > > > What are the odds of an fadvise() user having used mincore() in advance
>> > > > to determine if the page was in use by another process? I would guess
>> > > > "low" so this half-deactivate gives a chance for the page to be promoted
>> > > > again as well as a chance for the flusher threads to clean the page if
>> > > > it really is to be reclaimed.
>> > > >
>> > > Do we really want to make the user jump through such hoops as using
>> > > mincore() just to get the kernel to handle use-once pages properly?
>> >
>> > I would think "no" which is why I support half-deactivating pages so they won't
>> > have to.
>>
>> If the page is page_mapped() then we can assume that some other process
>> is using it and we leave it alone *altogether*.
>>
>
> Agreed, that makes perfect sense.
>
>> If the page is dirty or under writeback (and !page_mapped()) then we
>> should assume that we should free it asap.  The PageReclaim() trick
>> might help with that.
>>
>
> Again agreed.
>
>> I just don't see any argument for moving the page to the head of the
>> inactive LRU as a matter of policy.  We can park it there because we
>> can't think of anythnig else to do with it, but it's the wrong place
>> for it.
>>
>
> Is there a better alternative? One thing that springs to mind is that we are
> not exactly tracking very well what effect these policy changes have. The
> analysis scripts I have do a reasonable job on tracking reclaim activity
> (although only as part of the mmtests tarball, I should split them out as
> a standalone tool) but not the impact - namely minor and major faults. I
> should sort that out so we can put better reclaim analysis in place.

It can help very much. :)

Also, I need time since I am so busy.

>
> --
> Mel Gorman
> Part-time Phd Student                          Linux Technology Center
> University of Limerick                         IBM Dublin Software Lab
>



-- 
Kind regards,
Minchan Kim
