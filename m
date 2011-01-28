Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755095Ab1A1Ihb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jan 2011 03:37:31 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:52689 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755015Ab1A1Iha convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jan 2011 03:37:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=btPZOSrAQZVtmU5/OzVTVcukoauHwochvxuf0NB0IVwFlL3mYLZmTlQ2KK1928j947
         t16/J7yjTp4BHG8qfm1FDI3cSOt/PjjjxHnEEpC/Y1P9h+nD9uY05C1DQGSKyqF61CZ9
         VweFA+HRi0eP4cUcyUqU6hqgFRlXNnFcXCARU=
MIME-Version: 1.0
In-Reply-To: <20110128172438.6c49d4ea.kamezawa.hiroyu@jp.fujitsu.com>
References: <20110128122229.6a4c74a2.kamezawa.hiroyu@jp.fujitsu.com>
	<20110128122449.e4bb0e5f.kamezawa.hiroyu@jp.fujitsu.com>
	<20110128134019.27abcfe2.nishimura@mxp.nes.nec.co.jp>
	<20110128135839.d53422e8.kamezawa.hiroyu@jp.fujitsu.com>
	<AANLkTikCjKCtjhRH-ZVsEQN-Luz==8g8e60uxhCTeD2w@mail.gmail.com>
	<20110128172438.6c49d4ea.kamezawa.hiroyu@jp.fujitsu.com>
Date: Fri, 28 Jan 2011 17:37:29 +0900
Message-ID: <AANLkTimmOhbWKMek+9UgTZOU7-17A3H3pMZF-pGQ5v7P@mail.gmail.com>
Subject: Re: [BUGFIX][PATCH 1/4] memcg: fix limit estimation at reclaim for hugepage
From: Minchan Kim <minchan.kim@gmail.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hannes@cmpxchg.org" <hannes@cmpxchg.org>,
        "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 28, 2011 at 5:24 PM, KAMEZAWA Hiroyuki
<kamezawa.hiroyu@jp.fujitsu.com> wrote:
> On Fri, 28 Jan 2011 17:04:16 +0900
> Minchan Kim <minchan.kim@gmail.com> wrote:
>
>> Hi Kame,
>>
>> On Fri, Jan 28, 2011 at 1:58 PM, KAMEZAWA Hiroyuki
>> <kamezawa.hiroyu@jp.fujitsu.com> wrote:
>> > How about this ?
>> > ==
>> > From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
>> >
>> > Current memory cgroup's code tends to assume page_size == PAGE_SIZE
>> > and arrangement for THP is not enough yet.
>> >
>> > This is one of fixes for supporing THP. This adds
>> > mem_cgroup_check_margin() and checks whether there are required amount of
>> > free resource after memory reclaim. By this, THP page allocation
>> > can know whether it really succeeded or not and avoid infinite-loop
>> > and hangup.
>> >
>> > Total fixes for do_charge()/reclaim memory will follow this patch.
>>
>> If this patch is only related to THP, I think patch order isn't good.
>> Before applying [2/4], huge page allocation will retry without
>> reclaiming and loop forever by below part.
>>
>> @@ -1854,9 +1858,6 @@ static int __mem_cgroup_do_charge(struct
>>       } else
>>               mem_over_limit = mem_cgroup_from_res_counter(fail_res, res);
>>
>> -     if (csize > PAGE_SIZE) /* change csize and retry */
>> -             return CHARGE_RETRY;
>> -
>>       if (!(gfp_mask & __GFP_WAIT))
>>               return CHARGE_WOULDBLOCK;
>>
>> Am I missing something?
>>
>
> You're right. But
>  - This patch oder doesn't affect bi-sect of the bug. because
>   2 bugs seems to be the same.
>  - This patch implements a leaf function for the real fix.
>
> Then, I think patch order is not problem here.
>
> Thank you for pointing out.

Okay. I understand Hannes and your opinion.
In my opinion, my suggestion can enhance the patch readability in this
series as just only my viewpoint. :)
Anyway, I don't mind it.

Reviewed-by: Minchan Kim <minchan.kim@gmail.com>

Thanks!!

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
