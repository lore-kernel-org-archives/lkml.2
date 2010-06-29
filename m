Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753169Ab0F2HEF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 03:04:05 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:54076 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752058Ab0F2HEE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 03:04:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=SjiQibSqHqQhOMWMloUocMEboHR8wYLkm9A8cu/jAhP1Df2yFLVsEbFo8Ha3JnwitN
         VYOfj62ob0+761wk2ZtI2X6Y0m9eetHc7I7+Enf6NaL1icvCMW9tOet8SiWTXv6dTYWL
         3c0lyDmuEhDhP1pt+NvpHMH38vQAp3ACxp7d0=
MIME-Version: 1.0
In-Reply-To: <AANLkTinuas0MPFvZk9nOd91PuHXtaluHkkcWjGKYPZOl@mail.gmail.com>
References: <AANLkTilJDrpoFGyTSrKg3Hg59u9TvBLbxk4HAVKBvjxQ@mail.gmail.com>
	<1277733320.3561.50.camel@laptop>
	<AANLkTinuas0MPFvZk9nOd91PuHXtaluHkkcWjGKYPZOl@mail.gmail.com>
Date: Tue, 29 Jun 2010 14:34:48 +0800
Message-ID: <AANLkTin8xnr1Vp1lXiOpWcMLHSlbwpPiRrkzZVMChOus@mail.gmail.com>
Subject: Re: [PATCH] avoid return NULL on root rb_node in rb_next/rb_prev in 
	lib/rbtree.c
From: shenghui <crosslonelyover@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
       Greg KH <greg@kroah.com>, linux-mm@kvack.org, mingo@elte.hu
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/6/29 shenghui <crosslonelyover@gmail.com>:
> 2010/6/28 Peter Zijlstra <peterz@infradead.org>:
>> So if ->rb_leftmost is NULL, then the if (!left) check in
>> __pick_next_entity() would return null.
>>
>> As to the NULL deref in in pick_next_task_fair()->set_next_entity() that
>> should never happen because pick_next_task_fair() will bail
>> on !->nr_running.
>>
>> Furthermore, you've failed to mention what kernel version you're looking
>> at.
>>
>
> The kernel version is 2.6.35-rc3, and 2.6.34 has the same code.
>
> For nr->running, if current is the only process in the run queue, then
> nr->running would not be zero.
> 1784        if (!cfs_rq->nr_running)
> 1785                return NULL;
> pick_next_task_fair() could pass above check and run to following:
> 1787        do {
> 1788                se = pick_next_entity(cfs_rq);
> 1789                set_next_entity(cfs_rq, se);
> 1790                cfs_rq = group_cfs_rq(se);
> 1791        } while (cfs_rq);
>
> Then pick_next_entity will get NULL for current is the root rb_node.
> Then set_next_entity would fail on NULL deference.
>

Sorry, I misunderstood the code. I'll put forward one new patch to
avoid the NULL condition


-- 


Thanks and Best Regards,
shenghui
