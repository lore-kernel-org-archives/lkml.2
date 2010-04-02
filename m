Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759299Ab0DBHXK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Apr 2010 03:23:10 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:64938 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759264Ab0DBHW5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Apr 2010 03:22:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=FAFEOUDERrZJTPXHry2t+i9TgP8t5Xf64L1H4G8s7Z30e7beCJa2/KieQKVCixoe6a
         tZwmoY8eLAucJrUoeq84yuOKS8OoS2DHhLAkj/HN9DXogY+ZMWu8sNLRQX8xTMCu7uvZ
         8aBFIvHstO+roZGY1ACAtQzDtD4tmPYeH8r8U=
MIME-Version: 1.0
In-Reply-To: <z2w5f4a33681004020000td60331aam2c6947954d78e46@mail.gmail.com>
References: <i2i5f4a33681003312105m4cd42e9ayfe35cc0988c401b6@mail.gmail.com>
	 <g2g5f4a33681004012051wedea9538w9da89e210b731422@mail.gmail.com>
	 <20100402140406.d3d7f18e.kamezawa.hiroyu@jp.fujitsu.com>
	 <z2x28c262361004012215h2b2ea3dbu5260724f97f55b95@mail.gmail.com>
	 <z2w5f4a33681004020000td60331aam2c6947954d78e46@mail.gmail.com>
Date: Fri, 2 Apr 2010 16:22:56 +0900
Message-ID: <q2t28c262361004020022v8eda0491t61e510a1caa0ef@mail.gmail.com>
Subject: Re: [Question] race condition in mm/page_alloc.c regarding page->lru?
From: Minchan Kim <minchan.kim@gmail.com>
To: TAO HU <tghk48@motorola.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       TAO HU <taohu@motorola.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org,
       "Ye Yuan.Bo-A22116" <yuan-bo.ye@motorola.com>,
       Chang Qing-A21550 <Qing.Chang@motorola.com>,
       linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 2, 2010 at 4:00 PM, TAO HU <tghk48@motorola.com> wrote:
> Hi, kamezawa hiroyu
>
> Thanks for the hint!
>
> Hi, Minchan Kim
>
> Sorry. Not exactly sure your idea about <grep "page handling">.
> Below is a result of $ grep -n -r "list_del(&page->lru)" * in our src tree

It's not enough.
Maybe you have to review your's patches based on mainline.

>
> arch/s390/mm/pgtable.c:83:      list_del(&page->lru);
> arch/s390/mm/pgtable.c:226:             list_del(&page->lru);
> arch/x86/mm/pgtable.c:60:       list_del(&page->lru);
> drivers/xen/balloon.c:154:      list_del(&page->lru);
> drivers/virtio/virtio_balloon.c:143:            list_del(&page->lru);
> fs/cifs/file.c:1780:            list_del(&page->lru);
> fs/btrfs/extent_io.c:2584:              list_del(&page->lru);
> fs/mpage.c:388:         list_del(&page->lru);
> include/linux/mm_inline.h:37:   list_del(&page->lru);
> include/linux/mm_inline.h:47:   list_del(&page->lru);
> kernel/kexec.c:391:             list_del(&page->lru);
> kernel/kexec.c:711:                     list_del(&page->lru);
> mm/migrate.c:69:                list_del(&page->lru);
> mm/migrate.c:695:               list_del(&page->lru);
> mm/hugetlb.c:467:                       list_del(&page->lru);
> mm/hugetlb.c:509:                       list_del(&page->lru);
> mm/hugetlb.c:836:               list_del(&page->lru);
> mm/hugetlb.c:844:                       list_del(&page->lru);
> mm/hugetlb.c:900:                       list_del(&page->lru);
> mm/hugetlb.c:1130:                      list_del(&page->lru);
> mm/hugetlb.c:1809:              list_del(&page->lru);
> mm/vmscan.c:597:                list_del(&page->lru);
> mm/vmscan.c:1148:                       list_del(&page->lru);
> mm/vmscan.c:1246:               list_del(&page->lru);
> mm/slub.c:827:  list_del(&page->lru);
> mm/slub.c:1249: list_del(&page->lru);
> mm/slub.c:1263:         list_del(&page->lru);
> mm/slub.c:2419:                 list_del(&page->lru);
> mm/slub.c:2809:                         list_del(&page->lru);
> mm/readahead.c:65:              list_del(&page->lru);
> mm/readahead.c:100:             list_del(&page->lru);
> mm/page_alloc.c:532:            list_del(&page->lru);
> mm/page_alloc.c:679:            list_del(&page->lru);
> mm/page_alloc.c:741:            list_del(&page->lru);
> mm/page_alloc.c:820:                    list_del(&page->lru);
> mm/page_alloc.c:1107:           list_del(&page->lru);
> mm/page_alloc.c:4784:           list_del(&page->lru);
>
There are normal caller.
I expected some bogus driver of out-of-mainline uses page directly
without enough review.

Is your kernel working well except this bug?
Do you see same oops call trace(about page-allocator) whenever kernel
panic happens?

I mean if something not page-allocadtor breaks memory, you can see
other symptoms. so we can doubt others(H/W, other subsystem).

-- 
Kind regards,
Minchan Kim
