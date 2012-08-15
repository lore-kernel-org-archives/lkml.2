Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752026Ab2HOOYh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 10:24:37 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:38114 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750781Ab2HOOYf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 10:24:35 -0400
MIME-Version: 1.0
In-Reply-To: <5028F12C.7080405@intel.com>
References: <5028F12C.7080405@intel.com>
Date: Wed, 15 Aug 2012 20:24:34 +0600
Message-ID: <CADZ9YHhB_1ZeZM3WOFiz0kcx1ZR9iFO_R=Mst_w=QKXOi4Z9OQ@mail.gmail.com>
Subject: Re: [discussion]sched: a rough proposal to enable power saving in scheduler
From: Rakib Mullick <rakib.mullick@gmail.com>
To: Alex Shi <alex.shi@intel.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>, vincent.guittot@linaro.org,
        svaidy@linux.vnet.ibm.com, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/13/12, Alex Shi <alex.shi@intel.com> wrote:
> Since there is no power saving consideration in scheduler CFS, I has a
> very rough idea for enabling a new power saving schema in CFS.
>
> It bases on the following assumption:
> 1, If there are many task crowd in system, just let few domain cpus
> running and let other cpus idle can not save power. Let all cpu take the
> load, finish tasks early, and then get into idle. will save more power
> and have better user experience.
>
This assumption indirectly point towards the scheme when performance
is enabled, isn't it? Cause you're trying to spread the load equally
amongst all the CPUs.

> 2, schedule domain, schedule group perfect match the hardware, and
> the power consumption unit. So, pull tasks out of a domain means
> potentially this power consumption unit idle.
>
How do you plan to test this power saving scheme? Using powertop? Or,
is there any other tools?

>
> select_task_rq_fair()
> {
> 	for_each_domain(cpu, tmp) {
> 		if (policy == power && tmp_has_capacity &&
> 			 tmp->flags & sd_flag) {
> 			sd = tmp;
> 			//It is fine to got cpu in the domain
> 			break;
> 		}
> 	}
>
> 	while(sd) {
> 		if policy == power
> 			find_busiest_and_capable_group()

I'm not sure what find_busiest_and_capable_group() would really be, it
seems it'll find the busiest and capable group, but isn't it a
conflict with the first assumption you proposed on your proposal?

Thanks,
Rakib.
