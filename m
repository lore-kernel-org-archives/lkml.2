Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030393Ab2LGNfu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2012 08:35:50 -0500
Received: from mail-ob0-f174.google.com ([209.85.214.174]:60459 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030286Ab2LGNft (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2012 08:35:49 -0500
MIME-Version: 1.0
In-Reply-To: <CAA_GA1fiQfOqApE05oh=2Wr-GejbHtOd4o7sqcGdQFH6cxWPpQ@mail.gmail.com>
References: <1354810175-4338-1-git-send-email-js1304@gmail.com>
	<CAA_GA1fiQfOqApE05oh=2Wr-GejbHtOd4o7sqcGdQFH6cxWPpQ@mail.gmail.com>
Date: Fri, 7 Dec 2012 22:35:48 +0900
Message-ID: <CAAmzW4O0EY=-ZBytrWmGVax47_ygNh+hcGpbGOCt9cnXH7HU-g@mail.gmail.com>
Subject: Re: [RFC PATCH 0/8] remove vm_struct list management
From: JoonSoo Kim <js1304@gmail.com>
To: Bob Liu <lliubbo@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        kexec@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Bob.

2012/12/7 Bob Liu <lliubbo@gmail.com>:
> Hi Joonsoo,
>
> On Fri, Dec 7, 2012 at 12:09 AM, Joonsoo Kim <js1304@gmail.com> wrote:
>> This patchset remove vm_struct list management after initializing vmalloc.
>> Adding and removing an entry to vmlist is linear time complexity, so
>> it is inefficient. If we maintain this list, overall time complexity of
>> adding and removing area to vmalloc space is O(N), although we use
>> rbtree for finding vacant place and it's time complexity is just O(logN).
>>
>> And vmlist and vmlist_lock is used many places of outside of vmalloc.c.
>> It is preferable that we hide this raw data structure and provide
>> well-defined function for supporting them, because it makes that they
>> cannot mistake when manipulating theses structure and it makes us easily
>> maintain vmalloc layer.
>>
>> I'm not sure that "7/8: makes vmlist only for kexec" is fine.
>> Because it is related to userspace program.
>> As far as I know, makedumpfile use kexec's output information and it only
>> need first address of vmalloc layer. So my implementation reflect this
>> fact, but I'm not sure. And now, I don't fully test this patchset.
>> Basic operation work well, but I don't test kexec. So I send this
>> patchset with 'RFC'.
>>
>> Please let me know what I am missing.
>>
>
> Nice work!
> I also thought about this several weeks ago but I think the efficiency
> may be a problem.
>
> As you know two locks(vmap_area_lock and vmlist_lock) are used
> currently so that some
> work may be done in parallel(not proved).
> If removed vmlist, i'm afraid vmap_area_lock will become a bottleneck
> which will reduce the efficiency.

Thanks for comment!

Yes, there were some place that work may be done in parallel.
For example, access to '/proc/meminfo', '/proc/vmallocinfo' and '/proc/kcore'
may be done in parallel. But, access to these are not main
functionality of vmalloc layer.
Optimizing main function like vmalloc, vfree is more preferable than above.
And this patchset optimize main function with removing vmlist iteration.

Thanks.
