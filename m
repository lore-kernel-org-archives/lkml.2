Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756019Ab1KWOfj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 09:35:39 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:59176 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753872Ab1KWOfh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 09:35:37 -0500
MIME-Version: 1.0
In-Reply-To: <20111123134512.GN19415@suse.de>
References: <1321900608-27687-1-git-send-email-mgorman@suse.de>
	<1321900608-27687-8-git-send-email-mgorman@suse.de>
	<1321945011.22361.335.camel@sli10-conroe>
	<CAPQyPG4DQCxDah5VYMU6PNgeuD_3WJ-zm8XpL7V7BK8hAF8OJg@mail.gmail.com>
	<20111123110041.GM19415@suse.de>
	<CAPQyPG588_q1diT8KyPirUD9MLME6SanO-cSw1twzhFiTBWgCw@mail.gmail.com>
	<20111123134512.GN19415@suse.de>
Date: Wed, 23 Nov 2011 22:35:37 +0800
Message-ID: <CAPQyPG6b-MiysHnEadWRX729_q7G=_mYozSR+OatS-TLs_Sw_Q@mail.gmail.com>
Subject: Re: [PATCH 7/7] mm: compaction: Introduce sync-light migration for
 use by compaction
From: Nai Xia <nai.xia@gmail.com>
To: Mel Gorman <mgorman@suse.de>
Cc: Shaohua Li <shaohua.li@intel.com>, Linux-MM <linux-mm@kvack.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Minchan Kim <minchan.kim@gmail.com>, Jan Kara <jack@suse.cz>,
        Andy Isaacson <adi@hexapodia.org>,
        Johannes Weiner <jweiner@redhat.com>, Rik van Riel <riel@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 23, 2011 at 9:45 PM, Mel Gorman <mgorman@suse.de> wrote:
> On Wed, Nov 23, 2011 at 09:05:08PM +0800, Nai Xia wrote:
>> > <SNIP>
>> >
>> > Where are you adding this check?
>> >
>> > If you mean in __unmap_and_move(), the check is unnecessary unless
>> > another subsystem starts using sync-light compaction. With this series,
>> > only direct compaction cares about MIGRATE_SYNC_LIGHT. If the page is
>>
>> But I am still a little bit confused that if MIGRATE_SYNC_LIGHT is only
>> used by direct compaction and  another mode can be used by it:
>> MIGRATE_ASYNC also does not write dirty pages, then why not also
>> do an (current->flags & PF_MEMALLOC) test before writing out pages,
>
> Why would it be necessary?
> Why would it be better than what is there now?

I mean, if MIGRATE_SYNC_LIGHT -->  (current->flags & PF_MEMALLOC),
and MIGRATE_SYNC_LIGHT --> no dirty writeback, and
 (current->flags & PF_MEMALLOC)
---> (MIGRATE_SYNC_LIGHT || MIGRATE_ASYNC)
and   MIGRATE_ASYNC --> no dirty writeback, then
why not simply  (current->flags & PF_MEMALLOC) ---> no dirty writeback
and keep the sync meaning as it was?

Hoping I get myself clear this time......

>
>> like we already did for the page lock condition, but adding a new mode
>> instead?
>>
>
> I'm afraid I am missing the significance of your question or how it
> might apply to the problem at hand.

Sorry, It always takes some effort for me to get myself understood
when expressing a complicated thing. That's always my fault ;)

Thanks,
Nai

>
> --
> Mel Gorman
> SUSE Labs
>
