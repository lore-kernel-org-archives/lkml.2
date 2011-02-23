Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751745Ab1BWXh3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 18:37:29 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:57548 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751370Ab1BWXh1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 18:37:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=dB5eW7gPFAniVZdU28479DudL4BHSK4LERyjgrkuleEjJUB8BN9y7ffMAsQh1IYqVK
         9AP0gTZqRU4fBvDVQnFpZIjBRZsiFuOmCNNwhhfAknm2MwJjZaU/nniYnibm+zHogWbe
         mbXaaZE+rFJHO5Z+sQc9GpUX8S7RKEth1G0mE=
MIME-Version: 1.0
In-Reply-To: <20110223144445.86d0ca2b.akpm@linux-foundation.org>
References: <1297355626-5152-1-git-send-email-minchan.kim@gmail.com>
	<20110219234121.GA2546@barrios-desktop>
	<20110223144445.86d0ca2b.akpm@linux-foundation.org>
Date: Thu, 24 Feb 2011 08:37:27 +0900
Message-ID: <AANLkTik47+rots2XsouMiCnefmxeC_n=Q9mwBSyE9YjC@mail.gmail.com>
Subject: Re: [PATCH] mm: optimize replace_page_cache_page
From: Minchan Kim <minchan.kim@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Miklos Szeredi <mszeredi@suse.cz>
Cc: linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        Rik van Riel <riel@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Mel Gorman <mel@csn.ul.ie>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 24, 2011 at 7:44 AM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Sun, 20 Feb 2011 08:41:21 +0900
> Minchan Kim <minchan.kim@gmail.com> wrote:
>
>> Resend.
>
> Reignore.
>
>> he patch is based on mmotm-2011-02-04 +
>> mm-add-replace_page_cache_page-function-add-freepage-hook.patch.
>>
>> On Fri, Feb 11, 2011 at 01:33:46AM +0900, Minchan Kim wrote:
>> > This patch optmizes replace_page_cache_page.
>> >
>> > 1) remove radix_tree_preload
>> > 2) single radix_tree_lookup_slot and replace radix tree slot
>> > 3) page accounting optimization if both pages are in same zone.
>> >
>> > Cc: Miklos Szeredi <mszeredi@suse.cz>
>> > Cc: Rik van Riel <riel@redhat.com>
>> > Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
>> > Cc: Mel Gorman <mel@csn.ul.ie>
>> > Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
>> > ---
>> >  mm/filemap.c |   61 ++++++++++++++++++++++++++++++++++++++++++++++++---------
>> >  1 files changed, 51 insertions(+), 10 deletions(-)
>> >
>> > Hi Miklos,
>> > This patch is totally not tested.
>> > Could you test this patch?
>
> ^^^ Because of this.
>
> Is it tested yet?
>

Miklos. Could you test this?
If you are busy, let me know how to test it. I will.
Thanks.


-- 
Kind regards,
Minchan Kim
