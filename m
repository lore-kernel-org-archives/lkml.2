Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757955Ab2D0XvP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 19:51:15 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:55554 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754426Ab2D0XvM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 19:51:12 -0400
MIME-Version: 1.0
In-Reply-To: <4F9AD28C.60508@parallels.com>
References: <4F9A327A.6050409@jp.fujitsu.com>
	<4F9A343F.7020409@jp.fujitsu.com>
	<4F9AD28C.60508@parallels.com>
Date: Sat, 28 Apr 2012 08:51:11 +0900
Message-ID: <CABEgKgrHXeXX1napajY-hRqDPB1snL1xWmrAVxVKkOGEvnJdkQ@mail.gmail.com>
Subject: Re: [RFC][PATCH 3/7 v2] res_counter: add res_counter_uncharge_until()
From: Hiroyuki Kamezawa <kamezawa.hiroyuki@gmail.com>
To: Glauber Costa <glommer@parallels.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>,
        Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Tejun Heo <tj@kernel.org>,
        Han Ying <yinghan@google.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 28, 2012 at 2:08 AM, Glauber Costa <glommer@parallels.com> wrote:
> On 04/27/2012 02:53 AM, KAMEZAWA Hiroyuki wrote:
>>  From bb0168d5c85f62f36434956e4728a67d0cc41e55 Mon Sep 17 00:00:00 2001
>> From: KAMEZAWA Hiroyuki<kamezawa.hiroyu@jp.fujitsu.com>
>> Date: Thu, 26 Apr 2012 18:48:07 +0900
>> Subject: [PATCH 3/9] memcg: add res_counter_uncharge_until()
>>
>> At killing res_counter which is a child of other counter,
>> we need to do
>>       res_counter_uncharge(child, xxx)
>>       res_counter_charge(parent, xxx)
>>
>> This is not atomic and wasting cpu. This patch adds
>> res_counter_uncharge_until(). This function's uncharge propagates
>> to ancestors until specified res_counter.
>>
>>       res_counter_uncharge_until(child, parent, xxx)
>>
>> This ops is atomic and more efficient.
>>
>> Originaly-written-by: Frederic Weisbecker<fweisbec@gmail.com>
>> Signed-off-by: KAMEZAWA Hiroyuki<kamezawa.hiroyu@jp.fujitsu.com>
> I have been carrying Frederic's patch itself in my code for a while now.
>
> Why not just use it? What are you doing differently to justify writing a
> patch yourself? It's a bit of credit giving as well

I don't need "charge" part for my purpose and have no justification to add it.
And task-limit cgroup has no justification, either.

Thanks,
-Kame
