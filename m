Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752109Ab2KQTMh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2012 14:12:37 -0500
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:57224 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752043Ab2KQTMg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2012 14:12:36 -0500
Message-ID: <50A7E181.9040605@linux.vnet.ibm.com>
Date: Sun, 18 Nov 2012 00:42:01 +0530
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Alex Shi <alex.shi@intel.com>
CC: mingo@redhat.com, peterz@infradead.org, pjt@google.com,
        vincent.guittot@linaro.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/5] enable runnable load avg in load balance
References: <1353157457-3649-1-git-send-email-alex.shi@intel.com>
In-Reply-To: <1353157457-3649-1-git-send-email-alex.shi@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12111719-4790-0000-0000-0000059E387B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alex,

On 11/17/2012 06:34 PM, Alex Shi wrote:
> This patchset try to consider runnable load avg when do cpu load comparison
> in load balance.
> 
> I had seen preeti's enabling before patch finished, but I still think considing
> runnable load avg on rq is may a more natrual way.
> 
> BTW, I am thinking if 2 times decay for cpu_load is too complicate? one for
> runnable time, another for CPU_LOAD_IDX. I think I missed the decay reason
> for CPU_LOAD_IDX. Could anyone like do me favor to give some hints of this?

The decay happening for CPU_LOAD_IDX is *more coarse grained* than the
decay that __update_entity_runnable_avg() is performing.While
__update_cpu_load() decays the rq->load.weight *for every jiffy*(~4ms)
passed so far without update of the load,
__update_entity_runnable_avg() decays the rq->load.weight *for every
1ms* when called from update_rq_runnable_avg().

Before the introduction of PJT's series,__update_cpu_load() seems to be
the only place where decay of older rq load was happening(so as to give
the older load less importance in its relevance),but with the
introduction of PJT's series since the older rq load gets decayed in
__update_entity_runnable_avg() in a more fine grained fashion,perhaps
you are right,while the CPU_LOAD_IDX gets updated,we dont need to decay
the load once again here.
> 
> Best Regards!
> Alex 
> 
> [RFC PATCH 1/5] sched: get rq runnable load average for load balance
> [RFC PATCH 2/5] sched: update rq runnable load average in time
> [RFC PATCH 3/5] sched: using runnable load avg in cpu_load and
> [RFC PATCH 4/5] sched: consider runnable load average in wake_affine
> [RFC PATCH 5/5] sched: revert 'Introduce temporary FAIR_GROUP_SCHED
> 
Regards
Preeti U Murthy

