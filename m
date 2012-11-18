Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751462Ab2KRIft (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Nov 2012 03:35:49 -0500
Received: from mail-ob0-f174.google.com ([209.85.214.174]:42829 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751200Ab2KRIfs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Nov 2012 03:35:48 -0500
MIME-Version: 1.0
In-Reply-To: <50A7E181.9040605@linux.vnet.ibm.com>
References: <1353157457-3649-1-git-send-email-alex.shi@intel.com>
	<50A7E181.9040605@linux.vnet.ibm.com>
Date: Sun, 18 Nov 2012 16:35:48 +0800
Message-ID: <CAGjg+kH0S-Gmm1U35WYKq=voGy4ksnYJt3Geb+jnrWYe_6NTYw@mail.gmail.com>
Subject: Re: [RFC PATCH 0/5] enable runnable load avg in load balance
From: Alex Shi <lkml.alex@gmail.com>
To: Preeti U Murthy <preeti@linux.vnet.ibm.com>
Cc: Alex Shi <alex.shi@intel.com>, mingo@redhat.com, peterz@infradead.org,
        pjt@google.com, vincent.guittot@linaro.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 18, 2012 at 3:12 AM, Preeti U Murthy
<preeti@linux.vnet.ibm.com> wrote:
> Hi Alex,
>
> On 11/17/2012 06:34 PM, Alex Shi wrote:
>> This patchset try to consider runnable load avg when do cpu load comparison
>> in load balance.
>>
>> I had seen preeti's enabling before patch finished, but I still think considing
>> runnable load avg on rq is may a more natrual way.
>>
>> BTW, I am thinking if 2 times decay for cpu_load is too complicate? one for
>> runnable time, another for CPU_LOAD_IDX. I think I missed the decay reason
>> for CPU_LOAD_IDX. Could anyone like do me favor to give some hints of this?
>
> The decay happening for CPU_LOAD_IDX is *more coarse grained* than the
> decay that __update_entity_runnable_avg() is performing.While
> __update_cpu_load() decays the rq->load.weight *for every jiffy*(~4ms)
> passed so far without update of the load,
> __update_entity_runnable_avg() decays the rq->load.weight *for every
> 1ms* when called from update_rq_runnable_avg().
>
> Before the introduction of PJT's series,__update_cpu_load() seems to be
> the only place where decay of older rq load was happening(so as to give
> the older load less importance in its relevance),but with the
> introduction of PJT's series since the older rq load gets decayed in
> __update_entity_runnable_avg() in a more fine grained fashion,perhaps
> you are right,while the CPU_LOAD_IDX gets updated,we dont need to decay
> the load once again here.


If cpu_load is just a coarse decay, we can remove it. but it has
different meaning for busy_idx, forkexec_idx, idle_idx, newidle_idx.
each of them has different degree decay. that is the key part, but I
has no idea of their value come from.

Thanks!
