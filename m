Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756263Ab0GFW2U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jul 2010 18:28:20 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:61118 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755328Ab0GFW2S convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jul 2010 18:28:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=odDmrtwHUAy/x1W+k9CX2FgWpXnzMjy2eepseT8KEZo8DA552AUuXVyCqOcU/JCGHM
         8odAbRl6X4KDTI46Tb00oWR3SAq8pi1uAh1qq9z9w15zGwwsTLtEOWIXbfbkUet2ulrc
         d0JkEVQ7OzzL4br4UC9bHCH8hK89UHzCJ1kOU=
MIME-Version: 1.0
In-Reply-To: <20100706202758.GC18210@cmpxchg.org>
References: <20100702125155.69c02f85.akpm@linux-foundation.org>
	<20100705134949.GC13780@csn.ul.ie>
	<20100706093529.CCD1.A69D9226@jp.fujitsu.com>
	<20100706101235.GE13780@csn.ul.ie>
	<AANLkTin8FotAC1GvjuoYU9XA2eiSr6FWWh6bwypTdhq3@mail.gmail.com>
	<20100706152539.GG13780@csn.ul.ie>
	<20100706202758.GC18210@cmpxchg.org>
Date: Wed, 7 Jul 2010 07:28:14 +0900
Message-ID: <AANLkTimOkI95ZkJecE3jxRDDGbHvP9tRUluIoJuhqqMz@mail.gmail.com>
Subject: Re: [PATCH 12/14] vmscan: Do not writeback pages in direct reclaim
From: Minchan Kim <minchan.kim@gmail.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Mel Gorman <mel@csn.ul.ie>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
       Dave Chinner <david@fromorbit.com>,
       Chris Mason <chris.mason@oracle.com>, Nick Piggin <npiggin@suse.de>,
       Rik van Riel <riel@redhat.com>, Christoph Hellwig <hch@infradead.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Andrea Arcangeli <aarcange@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 7, 2010 at 5:27 AM, Johannes Weiner <hannes@cmpxchg.org> wrote:
> On Tue, Jul 06, 2010 at 04:25:39PM +0100, Mel Gorman wrote:
>> On Tue, Jul 06, 2010 at 08:24:57PM +0900, Minchan Kim wrote:
>> > but it is still problem in case of swap file.
>> > That's because swapout on swapfile cause file system writepage which
>> > makes kernel stack overflow.
>>
>> I don't *think* this is a problem unless I missed where writing out to
>> swap enters teh filesystem code. I'll double check.
>
> It bypasses the fs.  On swapon, the blocks are resolved
> (mm/swapfile.c::setup_swap_extents) and then the writeout path uses
> bios directly (mm/page_io.c::swap_writepage).
>
> (GFP_NOFS still includes __GFP_IO, so allows swapping)
>
>        Hannes

Thanks, Hannes. You're right.
Extents would be resolved by setup_swap_extents.
Sorry for confusing, Mel.

It was just my guessing about Kosaki's mention but he might say another story.
Ignore me.

-- 
Kind regards,
Minchan Kim
