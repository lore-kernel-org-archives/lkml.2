Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756731Ab0J0XWl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 19:22:41 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:47417 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752628Ab0J0XWi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 19:22:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=uyR6BHGxRg9pzEu4n30QsVh7+eszb0TluOZxhujvMZ80PpljMHbymJOYXdA9yfKj7Q
         Nh0wASrPufmdmg2sfGmfi+YTPJTdde94C0cfcYlyJcG++MAoNO5LFZgWu/qWKDp4Qppi
         Oav3z4iD1deu4Y2f6Wv+yASiGAui0qewevUh8=
MIME-Version: 1.0
In-Reply-To: <20101026190042.57f30338.kamezawa.hiroyu@jp.fujitsu.com>
References: <20101026190042.57f30338.kamezawa.hiroyu@jp.fujitsu.com>
Date: Thu, 28 Oct 2010 08:22:38 +0900
Message-ID: <AANLkTim4fFXQKqmFCeR8pvi0SZPXpjDqyOkbV6PYJYkR@mail.gmail.com>
Subject: Re: [RFC][PATCH 0/3] big chunk memory allocator v2
From: Minchan Kim <minchan.kim@gmail.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        andi.kleen@intel.com, KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        fujita.tomonori@lab.ntt.co.jp, felipe.contreras@gmail.com,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Michal Nazarewicz <m.nazarewicz@samsung.com>,
        Russell King <linux@arm.linux.org.uk>,
        Pawel Osciak <p.osciak@samsung.com>,
        Peter Zijlstra <peterz@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 26, 2010 at 7:00 PM, KAMEZAWA Hiroyuki
<kamezawa.hiroyu@jp.fujitsu.com> wrote:
> Hi, here is version 2.
>
> I only did small test and it seems to work (but I think there will be bug...)
> I post this now just because I'll be out of office 10/31-11/15 with ksummit and
> a private trip.
>
> Any comments are welcome but please see the interface is enough for use cases or
> not.  For example) If MAX_ORDER alignment is too bad, I need to rewrite almost
> all code.

First of all, thanks for the endless your effort to embedded system.
It's time for statkeholders to review this.
Cced some guys. Maybe many people of them have to attend KS.
So I hope SAMSUNG guys review this.

Maybe they can't test this since ARM doesn't support movable zone now.
(I will look into this).
As Kame said, please, review this patch whether this patch have enough
interface and meet
your requirement.
I think this can't meet _all_ of your requirements(ex, latency and
making sure getting big contiguous memory) but I believe it can meet
NOT CRITICAL many cases, I guess.

>
> Now interface is:
>
>
> struct page *__alloc_contig_pages(unsigned long base, unsigned long end,
>                        unsigned long nr_pages, int align_order,
>                        int node, gfp_t gfpflag, nodemask_t *mask)
>
>  * @base: the lowest pfn which caller wants.
>  * @end:  the highest pfn which caller wants.
>  * @nr_pages: the length of a chunk of pages to be allocated.
>  * @align_order: alignment of start address of returned chunk in order.
>  *   Returned' page's order will be aligned to (1 << align_order).If smaller
>  *   than MAX_ORDER, it's raised to MAX_ORDER.
>  * @node: allocate near memory to the node, If -1, current node is used.
>  * @gfpflag: see include/linux/gfp.h
>  * @nodemask: allocate memory within the nodemask.
>
> If the caller wants a FIXED address, set end - base == nr_pages.
>
> The patch is based onto the latest mmotm + Bob's 3 patches for fixing
> memory_hotplug.c (they are queued.)
>
> Thanks,
> -Kame
>
>
>
>
>



-- 
Kind regards,
Minchan Kim
