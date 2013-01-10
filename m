Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932236Ab3AJFwI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 00:52:08 -0500
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:60524 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751113Ab3AJFwG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 00:52:06 -0500
X-AuditID: 9c93016f-b7b54ae000000e9e-7e-50ee57020b51
From: Namhyung Kim <namhyung@kernel.org>
To: Alex Shi <alex.shi@intel.com>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>, Mike Galbraith <efault@gmx.de>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>
Subject: Re: [PATCH] sched: Get rid of unnecessary checks from select_idle_sibling
References: <1357714256-24373-1-git-send-email-namhyung@kernel.org>
	<50ED1D54.70208@intel.com> <876236rdum.fsf@sejong.aot.lge.com>
	<50ED2B9F.3080800@intel.com>
Date: Thu, 10 Jan 2013 14:52:02 +0900
In-Reply-To: <50ED2B9F.3080800@intel.com> (Alex Shi's message of "Wed, 09 Jan
	2013 16:34:39 +0800")
Message-ID: <87k3rlpou5.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 09 Jan 2013 16:34:39 +0800, Alex Shi wrote:
> On 01/09/2013 03:54 PM, Namhyung Kim wrote:
>> Hi Alex,
>> 
>> On Wed, 09 Jan 2013 15:33:40 +0800, Alex Shi wrote:
>>> On 01/09/2013 02:50 PM, Namhyung Kim wrote:
>>>> From: Namhyung Kim <namhyung.kim@lge.com>
>>>>
>>>> AFAICS @target cpu of select_idle_sibling() is always either prev_cpu
>>>> or this_cpu.  So no need to check it again and the conditionals can be
>>>> consolidated.
>> [snip]
>>> Uh, we don't know if the target is this_cpu or previous cpu, If we just
>>> check the target idle status, we may miss another idle cpu. So this
>>> patch change the logical in this function.
>> 
>> select_idle_sibling() is called only in select_task_rq_fair() if it
>> found a suitable affine_sd.  The default target is the 'prev_cpu' of the
>> task but if wake_affine() returns true it'd be (this) 'cpu'.
>> 
>> I cannot see where the prev_cpu or the cpu is set to another one before
>> calling select_idle_sibling.
>
> The old logical will return directly whenever prev_cpu or this cpu idle,
> but your new logical just has one chance.

Sorry, I can't get your point.  Could you elaborate on it a bit more?

Thanks,
Namhyung
