Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754414Ab1BUOOm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 09:14:42 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:41940 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750978Ab1BUOOl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 09:14:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=B7Nyy9t7MftiuFAkAtsg0b02L/AkOV/YeCO23BPtPPpVVyDqkH7gCxKZkuhc2P18cu
         wMsugZZ0uHqSNT7Zkqh1EouLDT6InZAMMB2c3xQAIppmn3t7VIE+eiFskZukE/vDMjRK
         NFxDQFyYpuoYXoYpvnM/V4Y6X1zUWbUFFU1y8=
MIME-Version: 1.0
In-Reply-To: <20110221130431.GF25382@cmpxchg.org>
References: <cover.1298214672.git.minchan.kim@gmail.com>
	<b691a7be970d6aafcd12ccc32ba812ce39fcf027.1298214672.git.minchan.kim@gmail.com>
	<20110221130431.GF25382@cmpxchg.org>
Date: Mon, 21 Feb 2011 23:14:40 +0900
Message-ID: <AANLkTintsg+5wm7EOr40zUqcmhO3Qend=KeYV09zeOAE@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] memcg: remove unnecessary BUG_ON
From: Minchan Kim <minchan.kim@gmail.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 21, 2011 at 10:04 PM, Johannes Weiner <hannes@cmpxchg.org> wrote:
> On Mon, Feb 21, 2011 at 12:17:17AM +0900, Minchan Kim wrote:
>> Now memcg in unmap_and_move checks BUG_ON of charge.
>> But mem_cgroup_prepare_migration returns either 0 or -ENOMEM.
>> If it returns -ENOMEM, it jumps out unlock without the check.
>> If it returns 0, it can pass BUG_ON. So it's meaningless.
>> Let's remove it.
>>
>> Cc: Johannes Weiner <hannes@cmpxchg.org>
>> Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
>> Acked-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
>> Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
>> Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
>> ---
>>  mm/migrate.c |    1 -
>>  1 files changed, 0 insertions(+), 1 deletions(-)
>>
>> diff --git a/mm/migrate.c b/mm/migrate.c
>> index eb083a6..2abc9c9 100644
>> --- a/mm/migrate.c
>> +++ b/mm/migrate.c
>> @@ -683,7 +683,6 @@ static int unmap_and_move(new_page_t get_new_page, unsigned long private,
>>               rc = -ENOMEM;
>>               goto unlock;
>>       }
>> -     BUG_ON(charge);
>
> You remove this assertion of the mem_cgroup_prepare_migration() return
> value but only add a comment about the expectations in the next patch.
>
> Could you write a full-blown kerneldoc on mem_cgroup_prepare_migration
> and remove this BUG_ON() in the same patch?
>

Okay. I could.




-- 
Kind regards,
Minchan Kim
