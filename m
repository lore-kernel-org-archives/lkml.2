Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760188Ab1D0XS6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 19:18:58 -0400
Received: from mail-ww0-f42.google.com ([74.125.82.42]:64443 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757166Ab1D0XS4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 19:18:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=suA0UXbl+5H4ASr61w8V9ywvcGYvJMrXlpeMozezZFIAvmIGNCVvEWf02wmJZ+OziF
         wgMOF++CGKekLwz+qc3B680FhWC+wjWksx5QIoc0OkPuW6pfEO8wab5C+50uaeXdgy8A
         iFDPQ9OUv6Dt3cr8Od2HBtL91Tv9Sam+MhDWs=
MIME-Version: 1.0
In-Reply-To: <20110427170304.d31c1398.kamezawa.hiroyu@jp.fujitsu.com>
References: <cover.1303833415.git.minchan.kim@gmail.com>
	<232562452317897b5acb1445803410d74233a923.1303833417.git.minchan.kim@gmail.com>
	<20110427170304.d31c1398.kamezawa.hiroyu@jp.fujitsu.com>
Date: Thu, 28 Apr 2011 08:18:54 +0900
Message-ID: <BANLkTik9c7MVoHH+hjn7SHqMhW-6d4eoLg@mail.gmail.com>
Subject: Re: [RFC 3/8] vmscan: make isolate_lru_page with filter aware
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

On Wed, Apr 27, 2011 at 5:03 PM, KAMEZAWA Hiroyuki
<kamezawa.hiroyu@jp.fujitsu.com> wrote:
> On Wed, 27 Apr 2011 01:25:20 +0900
> Minchan Kim <minchan.kim@gmail.com> wrote:
>
>> In some __zone_reclaim case, we don't want to shrink mapped page.
>> Nonetheless, we have isolated mapped page and re-add it into
>> LRU's head. It's unnecessary CPU overhead and makes LRU churning.
>>
>> Of course, when we isolate the page, the page might be mapped but
>> when we try to migrate the page, the page would be not mapped.
>> So it could be migrated. But race is rare and although it happens,
>> it's no big deal.
>>
>> Cc: Christoph Lameter <cl@linux.com>
>> Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
>> Cc: Mel Gorman <mgorman@suse.de>
>> Cc: Rik van Riel <riel@redhat.com>
>> Cc: Andrea Arcangeli <aarcange@redhat.com>
>> Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
>
>
> Hmm, it seems mm/memcontrol.c::mem_cgroup_isolate_pages() should be updated, too.
>
> But it's okay you start from global LRU.

Yes. That's exactly what  I want. :)
I am supposed to consider memcg after concept is approved.

>
> Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Thanks fore the review, Kame.
-- 
Kind regards,
Minchan Kim
