Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932160Ab3AJFtF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 00:49:05 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:55224 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751188Ab3AJFtE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 00:49:04 -0500
X-AuditID: 9c930179-b7c7fae00000255c-d6-50ee564d4d63
From: Namhyung Kim <namhyung@kernel.org>
To: Preeti U Murthy <preeti@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>, Mike Galbraith <efault@gmx.de>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Alex Shi <alex.shi@intel.com>
Subject: Re: [PATCH] sched: Get rid of unnecessary checks from select_idle_sibling
References: <1357714256-24373-1-git-send-email-namhyung@kernel.org>
	<50ED286C.6070601@linux.vnet.ibm.com>
Date: Thu, 10 Jan 2013 14:49:01 +0900
In-Reply-To: <50ED286C.6070601@linux.vnet.ibm.com> (Preeti U. Murthy's message
	of "Wed, 09 Jan 2013 13:51:00 +0530")
Message-ID: <87obgxpoz6.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Preeti,

On Wed, 09 Jan 2013 13:51:00 +0530, Preeti U. Murthy wrote:
> On 01/09/2013 12:20 PM, Namhyung Kim wrote:
>> From: Namhyung Kim <namhyung.kim@lge.com>
>> 
>> AFAICS @target cpu of select_idle_sibling() is always either prev_cpu
>> or this_cpu.  So no need to check it again and the conditionals can be
>> consolidated.
[snip]
> If NUMA_TTWU_BIAS or NUMA_TTWU_TO is true(it is false by

I can't find those bits in the code.  I've checked v3.8-rc2,
next-20130110, tip/master and tip/numa/core but there's nothing like
above.  Which tree are you saying?


> default),cpu/prev_cpu can be changed to be a random node_cpu(the node
> that 'this_cpu' is on). In which case even if the node cpu is idle,it
> would not be a viable target,looks like.Maybe that is why
> select_idle_sibling() makes the check if the target is prev_cpu/this cpu.

Looking into tip/numa/core, I can see that there's a code added for
CONFIG_NUMA_BALANCING.  But still, it seems nothing changed on a path
from select_task_rq_fair() to select_idle_sibling() - i.e. if the
select_idle_sibling called, the target would be either prev_cpu or this
cpu.  Am I missing something?

Thanks,
Namhyung
