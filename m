Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755024Ab1A1I0A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jan 2011 03:26:00 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:34808 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754997Ab1A1IZ7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jan 2011 03:25:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Hz4TGOElX2rjq1ppiPX+JPxe6zaldBUT9l7qzBr/Z8OnW9eOmXt0acReLpyqrQMjbY
         G0Qz0CvDmnboh7nhxZox6Yv6tTUETj6XrAs0fLjLKe/Z/YZjPtTCb10AyZ4ZyqulUfES
         cMiCMde94A8G/t7MhADZrvghZd4QXJlvl8e8U=
MIME-Version: 1.0
In-Reply-To: <20110128081723.GD2213@cmpxchg.org>
References: <20110128122229.6a4c74a2.kamezawa.hiroyu@jp.fujitsu.com>
	<20110128122449.e4bb0e5f.kamezawa.hiroyu@jp.fujitsu.com>
	<20110128134019.27abcfe2.nishimura@mxp.nes.nec.co.jp>
	<20110128135839.d53422e8.kamezawa.hiroyu@jp.fujitsu.com>
	<AANLkTikCjKCtjhRH-ZVsEQN-Luz==8g8e60uxhCTeD2w@mail.gmail.com>
	<20110128081723.GD2213@cmpxchg.org>
Date: Fri, 28 Jan 2011 17:25:58 +0900
Message-ID: <AANLkTinikUM09bXbLZ5zU1gdgfdPZSQmbycbbeSyGk59@mail.gmail.com>
Subject: Re: [BUGFIX][PATCH 1/4] memcg: fix limit estimation at reclaim for hugepage
From: Minchan Kim <minchan.kim@gmail.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Hannes,

On Fri, Jan 28, 2011 at 5:17 PM, Johannes Weiner <hannes@cmpxchg.org> wrote:
> On Fri, Jan 28, 2011 at 05:04:16PM +0900, Minchan Kim wrote:
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
>
> No, you are correct.  But I am not sure the order really matters in
> theory: you have two endless loops that need independent fixing.

That's why I ask a question.
Two endless loop?

One is what I mentioned. The other is what?
Maybe this patch solve the other.
But I can't guess it by only this description. Stupid..

Please open my eyes.

-- 
Kind regards,
Minchan Kim
