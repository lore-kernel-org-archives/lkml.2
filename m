Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751948Ab0HZJjx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 05:39:53 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:39959 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750881Ab0HZJju (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 05:39:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=Pt9bAAQQ4P0PcwkNwqGbcga+1tDIuDsTEyT+TQ6iV1gCwyUzbCd4fxr74xWGnwDagD
         rswuaXsw7xdnbhL006SdslAPrEVeVwvY7u1+Nsn0iqost5VzfphsFuVcqzKmb6+bU+W4
         2lrh8THa/v8Eex57uWjG0cePzoX7CBLbyEF7A=
MIME-Version: 1.0
In-Reply-To: <20100826090305.GC20944@csn.ul.ie>
References: <1282663879-4130-1-git-send-email-minchan.kim@gmail.com>
	<20100826090305.GC20944@csn.ul.ie>
Date: Thu, 26 Aug 2010 18:39:49 +0900
Message-ID: <AANLkTikE-_=8GCu=LjLiyyO9W+soSKAC0bkXfYAnwMux@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] compaction: handle active and inactive fairly in too_many_isolated
From: Minchan Kim <minchan.kim@gmail.com>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel List <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
        Wu Fengguang <fengguang.wu@intel.com>,
        Iram Shahzad <iram.shahzad@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 26, 2010 at 6:03 PM, Mel Gorman <mel@csn.ul.ie> wrote:
> On Wed, Aug 25, 2010 at 12:31:18AM +0900, Minchan Kim wrote:
>> Iram reported compaction's too_many_isolated loops forever.
>> (http://www.spinics.net/lists/linux-mm/msg08123.html)
>>
>> The meminfo of situation happened was inactive anon is zero.
>> That's because the system has no memory pressure until then.
>> While all anon pages was in active lru, compaction could select
>> active lru as well as inactive lru. That's different things
>> with vmscan's isolated. So we has been two too_many_isolated.
>>
>> While compaction can isolated pages in both active and inactive,
>> current implementation of too_many_isolated only considers inactive.
>> It made Iram's problem.
>>
>> This patch handles active and inactive with fair.
>> That's because we can't expect where from and how many compaction would
>> isolated pages.
>>
>> This patch changes (nr_isolated > nr_inactive) with
>> nr_isolated > (nr_active + nr_inactive) / 2.
>>
>> Cc: Iram Shahzad <iram.shahzad@jp.fujitsu.com>
>> Acked-by: Mel Gorman <mel@csn.ul.ie>
>> Acked-by: Wu Fengguang <fengguang.wu@intel.com>
>> Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
>
> Please send this patch on its own as it looks like it should be merged and
> arguably is a stable candidate for 2.6.35. Alternatively, Andrew, can you pick
> up just this patch? It seems unrelated to the second patch on COMPACTPAGEFAILED.

I thought it's not urgent and next patch would apply based on this
patch without HUNK.
If Andrew doesn't have a response, I will resend as a standalone.
Thanks.

-- 
Kind regards,
Minchan Kim
