Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754877Ab1EAPJ2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 May 2011 11:09:28 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:37174 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753372Ab1EAPJ1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 May 2011 11:09:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=OiVeVbnVURWE/UpWtO00/sXPvovdcKtes1TnPYyva6G++v3Zfx9/ukPgjHXOIqxrjQ
         oKq5lQFYvQTp1ETfk6dLUhIBnOQ/wmnsjIivutmw7X6Y3vL1g629pVen8FMi5L3NkkTM
         s3WfwlhXIW9dfqsUh1SMIKrpWsp1G+E3ClugM=
MIME-Version: 1.0
In-Reply-To: <20110501222117.75E8.A69D9226@jp.fujitsu.com>
References: <20110428105027.GT4658@suse.de>
	<BANLkTi=bMm+iyO23+16FxK__V1-aM50zWQ@mail.gmail.com>
	<20110501222117.75E8.A69D9226@jp.fujitsu.com>
Date: Mon, 2 May 2011 00:09:26 +0900
Message-ID: <BANLkTi=u-a+L_AGoM+_yufuBBAwPnVG0Zw@mail.gmail.com>
Subject: Re: [RFC 5/8] compaction: remove active list counting
From: Minchan Kim <minchan.kim@gmail.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Mel Gorman <mgorman@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
        linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        Christoph Lameter <cl@linux.com>, Johannes Weiner <jweiner@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Rik van Riel <riel@redhat.com>, Andrea Arcangeli <aarcange@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 1, 2011 at 10:19 PM, KOSAKI Motohiro
<kosaki.motohiro@jp.fujitsu.com> wrote:
>> On Thu, Apr 28, 2011 at 7:50 PM, Mel Gorman <mgorman@suse.de> wrote:
>> > On Wed, Apr 27, 2011 at 01:25:22AM +0900, Minchan Kim wrote:
>> >> acct_isolated of compaction uses page_lru_base_type which returns only
>> >> base type of LRU list so it never returns LRU_ACTIVE_ANON or LRU_ACTIVE_FILE.
>> >> So it's pointless to add lru[LRU_ACTIVE_[ANON|FILE]] to get sum.
>> >>
>> >> Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
>> >> Cc: Mel Gorman <mgorman@suse.de>
>> >> Cc: Rik van Riel <riel@redhat.com>
>> >> Cc: Andrea Arcangeli <aarcange@redhat.com>
>> >> Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
>> >
>> > hmm, isolate_migratepages() is doing a linear scan of PFNs and is
>> > calling __isolate_lru_page(..ISOLATE_BOTH..). Using page_lru_base_type
>> > happens to work because we're only interested in the number of isolated
>> > pages and your patch still covers that. Using page_lru might be more
>> > accurate in terms of accountancy but does not seem necessary.
>>
>> True.
>>
>> >
>> > Adding a comment explaining why we account for it as inactive and why
>> > that's ok would be nice although I admit this is something I should have
>> > done when acct_isolated() was introduced.
>>
>> When Kame pointed out comment, I wanted to avoid unnecessary comment
>> so decided changing it with page_lru although it adds overhead a
>> little bit. But Hannes, you and maybe Kame don't want it. I don't mind
>> adding comment.
>> Okay. fix it in next version.
>
> Or
>
>        unsigned int count[2];
>
>        list_for_each_entry(page, &cc->migratepages, lru) {
>                count[page_is_file_cache(page)]++;
>        }
>
> is also clear to me.
>

That's very clear to me, too.
Thanks, KOSAKI.



-- 
Kind regards,
Minchan Kim
