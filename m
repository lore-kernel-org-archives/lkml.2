Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760237Ab1D0Xmb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 19:42:31 -0400
Received: from mail-ww0-f42.google.com ([74.125.82.42]:42569 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757101Ab1D0Xma (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 19:42:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=vmLzDyN84lRG4z99YmtEZicjXn9vpgPerCmaTXQgGbdBPE6p/RqAGy68gpCilzbFdF
         onrJSBh74eOoF/4gU2Op8IRsI0oPk0EE3J6GdEfq+JARFnbWyXAQOzm4KInc2ay9nDs6
         fxlX+NxUrOhjP74R7NGfCT+cPS+uA8GnzaIkg=
MIME-Version: 1.0
In-Reply-To: <20110427171505.5d7bf485.kamezawa.hiroyu@jp.fujitsu.com>
References: <cover.1303833415.git.minchan.kim@gmail.com>
	<2b79bbf9ddceb73624f49bbe9477126147d875fd.1303833417.git.minchan.kim@gmail.com>
	<20110427171505.5d7bf485.kamezawa.hiroyu@jp.fujitsu.com>
Date: Thu, 28 Apr 2011 08:42:28 +0900
Message-ID: <BANLkTim8B7R_9jtBOLS6F_OYJJMwgcG-0Q@mail.gmail.com>
Subject: Re: [RFC 5/8] compaction: remove active list counting
From: Minchan Kim <minchan.kim@gmail.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>, Christoph Lameter <cl@linux.com>,
        Johannes Weiner <jweiner@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 27, 2011 at 5:15 PM, KAMEZAWA Hiroyuki
<kamezawa.hiroyu@jp.fujitsu.com> wrote:
> On Wed, 27 Apr 2011 01:25:22 +0900
> Minchan Kim <minchan.kim@gmail.com> wrote:
>
>> acct_isolated of compaction uses page_lru_base_type which returns only
>> base type of LRU list so it never returns LRU_ACTIVE_ANON or LRU_ACTIVE_FILE.
>> So it's pointless to add lru[LRU_ACTIVE_[ANON|FILE]] to get sum.
>>
>> Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
>> Cc: Mel Gorman <mgorman@suse.de>
>> Cc: Rik van Riel <riel@redhat.com>
>> Cc: Andrea Arcangeli <aarcange@redhat.com>
>> Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
>
> I think some comments are necessary to explain why INACTIVE only.

As alternative, I can change page_lru_base_type with page_lru.
It's not hot path so I will do.

Thanks, Kame.

> Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

-- 
Kind regards,
Minchan Kim
