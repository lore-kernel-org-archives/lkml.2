Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932117Ab1JQXcb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 19:32:31 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:39626 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751106Ab1JQXca (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 19:32:30 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LSU.2.00.1110171528520.6878@sister.anvils>
References: <20110705141038.23872.55303.stgit@localhost.localdomain>
	<20110705144140.23872.86541.stgit@localhost.localdomain>
	<alpine.LSU.2.00.1107071742250.10362@sister.anvils>
	<20110708093859.299958df@lxorguk.ukuu.org.uk>
	<alpine.LSU.2.00.1107080917430.1781@sister.anvils>
	<20110711172517.46907e62@lxorguk.ukuu.org.uk>
	<alpine.LSU.2.00.1107111033440.1752@sister.anvils>
	<CAMeQTsb7ZMbyt8avYNOiBssERmk6vEbg7RR6TQw7CaD55MK22A@mail.gmail.com>
	<alpine.LSU.2.00.1110101102330.21957@sister.anvils>
	<CAN_cFWNkYGSajh7eG1qK+A5tWSHNR2gH4EPiPg9tKd+yw8nRYQ@mail.gmail.com>
	<alpine.LSU.2.00.1110171031290.2545@sister.anvils>
	<20111017223928.4d5ed2c6@lxorguk.ukuu.org.uk>
	<alpine.LSU.2.00.1110171528520.6878@sister.anvils>
Date: Mon, 17 Oct 2011 18:32:30 -0500
Message-ID: <CAN_cFWP9jOGTPuoXQaXan_P1AKYrbvfLoB8hzG-YdCddfsu3Vw@mail.gmail.com>
Subject: Re: [PATCH 34/49] gma500: the GEM and GTT code is device independant
From: Rob Clark <rob.clark@linaro.org>
To: Hugh Dickins <hughd@google.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Patrik Jakobsson <patrik.r.jakobsson@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christoph Hellwig <hch@infradead.org>, greg@kroah.com,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 17, 2011 at 5:34 PM, Hugh Dickins <hughd@google.com> wrote:
> On Mon, 17 Oct 2011, Alan Cox wrote:
>> > It feels to me like GEM is pulling shmem in an ever more alien direction:
>> > these device constraints are so foreign to the nature of tmpfs; and
>> > beyond my expertise, so that I'd be ever more likely to make the wrong
>> > decisions (mixing swap and uncached pages? hmmm).
>>
>> For the most part we fixed that. You can now have a GEM object that is
>> backed by a private memory object rather than having to be tmpfs.
>> GMA500 uses it to attach 'stolen' memory to GEM handles, and at least
>> one other pending submission uses it with a private CMA style allocator.
>
> Sounds good.

Well, that means we could implement our own shmem/tmpfs.. although I'm
not entirely sure that I would want to..  a couple drm drivers are
using private memory objects, but I think primarily for scanout
buffers (which can't really be swapped out anyways).  I don't think
we'd want to use this for everything.

What troubles could you see for swap+uncached (or more likely,
writecombine) pages?

BR,
-R

>>
>> The gma500 report seems an odd one - no GMA500 box has >4GB memory so how
>> did the test code get a page that was unsuitable - is the test buggy ?
>
> This is the first I heard of some gma500 test seeing a problem with >4GB.
>
> In this thread we have Patrik hitting the oops in read_cache_page_gfp()
> because of some changes he is preparing, but I thought he and Rob were
> just thinking ahead when they raise the 4GB issue.
>
> Can you point us to another thread on a another list?
>
> Hugh
>
