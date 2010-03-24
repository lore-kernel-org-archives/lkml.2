Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754095Ab0CXCKR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 22:10:17 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:52825 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752342Ab0CXCKP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 22:10:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=k42iFCfrACTFneJvR7ENEBkvzs+bF7d7ny+WM99zTQkeEnWITnoSuyYdL/S1jO827D
         JEjcSIosLqodc5jjbohH0zi3SoiL5QpPUzFlfF5ewvGXEulrlyDNWhpO9ZzJO9McN5Hg
         +XXZUVjL/TLpavIPvES9pn/RwsYW8E3pMJJO4=
MIME-Version: 1.0
In-Reply-To: <20100324105311.2f41e82b.kamezawa.hiroyu@jp.fujitsu.com>
References: <1269347146-7461-1-git-send-email-mel@csn.ul.ie>
	 <1269347146-7461-8-git-send-email-mel@csn.ul.ie>
	 <20100324100334.8d6f0739.kamezawa.hiroyu@jp.fujitsu.com>
	 <28c262361003231847q1e4b7c7agdf82c4b2e920ada4@mail.gmail.com>
	 <20100324105311.2f41e82b.kamezawa.hiroyu@jp.fujitsu.com>
Date: Wed, 24 Mar 2010 11:10:14 +0900
Message-ID: <28c262361003231910w27dbe52fqe02afad2b0238c9a@mail.gmail.com>
Subject: Re: [PATCH 07/11] Memory compaction core
From: Minchan Kim <minchan.kim@gmail.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Mel Gorman <mel@csn.ul.ie>, Andrew Morton <akpm@linux-foundation.org>,
       Andrea Arcangeli <aarcange@redhat.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Adam Litke <agl@us.ibm.com>, Avi Kivity <avi@redhat.com>,
       David Rientjes <rientjes@google.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 24, 2010 at 10:53 AM, KAMEZAWA Hiroyuki
<kamezawa.hiroyu@jp.fujitsu.com> wrote:
> On Wed, 24 Mar 2010 10:47:41 +0900
> Minchan Kim <minchan.kim@gmail.com> wrote:
>
>> On Wed, Mar 24, 2010 at 10:03 AM, KAMEZAWA Hiroyuki
>> <kamezawa.hiroyu@jp.fujitsu.com> wrote:
>> > On Tue, 23 Mar 2010 12:25:42 +0000
>> > Mel Gorman <mel@csn.ul.ie> wrote:
>> >
>> >> This patch is the core of a mechanism which compacts memory in a zone by
>> >> relocating movable pages towards the end of the zone.
>> >>
>> >> A single compaction run involves a migration scanner and a free scanner.
>> >> Both scanners operate on pageblock-sized areas in the zone. The migration
>> >> scanner starts at the bottom of the zone and searches for all movable pages
>> >> within each area, isolating them onto a private list called migratelist.
>> >> The free scanner starts at the top of the zone and searches for suitable
>> >> areas and consumes the free pages within making them available for the
>> >> migration scanner. The pages isolated for migration are then migrated to
>> >> the newly isolated free pages.
>> >>
>> >> Signed-off-by: Mel Gorman <mel@csn.ul.ie>
>> >> Acked-by: Rik van Riel <riel@redhat.com>
>> >> Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
>> >
>> > I think lru_add_drain() or lru_add_drain_all() should be called somewhere
>> > when we do __isolate_lru_page(). But it's (_all is) slow....
>> >
>>
>> migrate_prep does it.
>>
> Thanks.
>
> Hmm...then, lru_add_drain_all() is called at each (32page migrate) itelation.
> Isn't it too slow to be called in such frequency ?

I agree. We can move migrate_prep in compact_zone.

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
