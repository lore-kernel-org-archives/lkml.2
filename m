Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933877Ab1KJI7k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 03:59:40 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:61894 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933598Ab1KJI7j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 03:59:39 -0500
MIME-Version: 1.0
In-Reply-To: <4EBAAFAC.90205@parallels.com>
References: <1320182360-20043-1-git-send-email-glommer@parallels.com>
	<1320182360-20043-14-git-send-email-glommer@parallels.com>
	<CANaxB-xQcqcZo5m7CJkCHrWj_TS4dyzYemPvrqZ25TaqK2tWYQ@mail.gmail.com>
	<4EBA6AF7.4020509@parallels.com>
	<CANaxB-z0-VY=SVEjmYKXrF+i2VW3U3QCxz0yN4Wp8-qevnd4tA@mail.gmail.com>
	<4EBAAFAC.90205@parallels.com>
Date: Thu, 10 Nov 2011 12:59:38 +0400
Message-ID: <CANaxB-wjpS9rF_1rxQeGY1Kjya+9EtuRJJZPmBdWU0d4WZ+LJw@mail.gmail.com>
Subject: Re: [PATCH v2 13/14] provide a version of cpuusage statistics inside
 cpu cgroup
From: Andrew Wagin <avagin@gmail.com>
To: Glauber Costa <glommer@parallels.com>
Cc: linux-kernel@vger.kernel.org, paul@paulmenage.org, lizf@cn.fujitsu.com,
        daniel.lezcano@free.fr, a.p.zijlstra@chello.nl,
        jbottomley@parallels.com, pjt@google.com, fweisbec@gmail.com,
        Balbir Singh <bsingharora@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/11/9 Glauber Costa <glommer@parallels.com>:
> On 11/09/2011 12:18 PM, Andrew Wagin wrote:
>>
>> And look at cfs_rq->prev_sum_exec_runtime, probably it is not used too.
>> Usage of cfs_rq->sum_exec_runtime looks strange.
>
> No, it is not.
> se->sum_exec_runtime is a per-se measure. It follows the task group as it
> moves from rq to rq. cfs->rq->sum_exec_runtime (and it's rt counterpart) is
> a measurement of accumulated runtime of all tasks that ever passed through
> this rq.
>

1. cfs_rq->sum_exec_runtime and cfs_rq->exec_clock are same things.

I enabled sched_stat by default and execute following commands:
# cat /proc/sched_debug  | grep exec_clock
  .exec_clock                    : 2959.768408
  .exec_clock                    : 2340.166419
# cat /cgroup/cpu.usage_percpu
2960772019 2341358764

2. Reseting of cpu.usage doesn't work for root cgroup.
[root@dhcp-10-30-20-19 ~]# echo 0 > /cgroup/cpu.usage
[root@dhcp-10-30-20-19 ~]# cat /cgroup/cpu.usage
6087490986

Probably for this reason cfs_rq->prev_sum_exec is unused.
