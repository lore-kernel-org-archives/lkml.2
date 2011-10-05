Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934561Ab1JEMR0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 08:17:26 -0400
Received: from mx2.parallels.com ([64.131.90.16]:59858 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934221Ab1JEMRZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 08:17:25 -0400
Message-ID: <4E8C4AB0.7070008@parallels.com>
Date: Wed, 5 Oct 2011 16:16:48 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0.2) Gecko/20110906 Thunderbird/6.0.2
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: <linux-kernel@vger.kernel.org>, <paul@paulmenage.org>,
        <lizf@cn.fujitsu.com>, <daniel.lezcano@free.fr>,
        <jbottomley@parallels.com>, Balbir Singh <bsingharora@gmail.com>
Subject: Re: [PATCH 08/10] provide a version of cpuacct statistics inside
 cpu cgroup
References: <1317583287-18300-1-git-send-email-glommer@parallels.com>  <1317583287-18300-9-git-send-email-glommer@parallels.com> <1317805825.6766.7.camel@twins>
In-Reply-To: <1317805825.6766.7.camel@twins>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/05/2011 01:10 PM, Peter Zijlstra wrote:
> On Sun, 2011-10-02 at 23:21 +0400, Glauber Costa wrote:
>> +       for_each_online_cpu(cpu) {
>> +               struct kernel_stat *kstat = per_cpu_ptr(tg->cpustat, cpu);
>> +               val += kstat->cpustat[USER];
>> +               val += kstat->cpustat[NICE];
>> +       }
>
> by using online_cpu, you fail to sum whatever data was accrued on
> unplugged cpus, is that a problem?
>
>

Humm... I guess it is. We're effectively replacing a percpu_counter, 
that should accumulate anything left in cpus that gets unplugged. I'll
have to change that.

Thanks
