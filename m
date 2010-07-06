Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753128Ab0GFFqj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jul 2010 01:46:39 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:51250 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752472Ab0GFFqh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jul 2010 01:46:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=syACDaBXgldocUt0uO+DWdxIF2dJiLa/nEaDBOkDb8fwzNioS24Fj5ztDGUognmEA5
         X+iGi2WwxKLr5R0j2xGDtU4wbrPM1FE6kfw0pGJAEfHiZOUID/1LfCfkjDv6Bvc6oiPh
         Ftbv49RTy1/oCQ1U5miG8eSVJaZXOYK2/k6hY=
MIME-Version: 1.0
In-Reply-To: <20100706093529.CCD1.A69D9226@jp.fujitsu.com>
References: <20100702125155.69c02f85.akpm@linux-foundation.org>
	<20100705134949.GC13780@csn.ul.ie>
	<20100706093529.CCD1.A69D9226@jp.fujitsu.com>
Date: Tue, 6 Jul 2010 14:46:37 +0900
Message-ID: <AANLkTimk6SwmljTWpIgp_OI_eLP6w8BCWKf-VRUFQ65H@mail.gmail.com>
Subject: Re: [PATCH 12/14] vmscan: Do not writeback pages in direct reclaim
From: Minchan Kim <minchan.kim@gmail.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Mel Gorman <mel@csn.ul.ie>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-mm@kvack.org, Dave Chinner <david@fromorbit.com>,
       Chris Mason <chris.mason@oracle.com>, Nick Piggin <npiggin@suse.de>,
       Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
       Christoph Hellwig <hch@infradead.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Andrea Arcangeli <aarcange@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 6, 2010 at 9:36 AM, KOSAKI Motohiro
<kosaki.motohiro@jp.fujitsu.com> wrote:
> Hello,
>
>> Ok, that's reasonable as I'm still working on that patch. For example, the
>> patch disabled anonymous page writeback which is unnecessary as the stack
>> usage for anon writeback is less than file writeback.
>
> How do we examine swap-on-file?

bool is_swap_on_file(struct page *page)
{
    struct swap_info_struct *p;
    swp_entry_entry entry;
    entry.val = page_private(page);
    p = swap_info_get(entry);
    return !(p->flags & SWP_BLKDEV)
}

-- 
Kind regards,
Minchan Kim
