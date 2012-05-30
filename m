Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752666Ab2E3KrI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 06:47:08 -0400
Received: from mx2.parallels.com ([64.131.90.16]:43254 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752472Ab2E3KrG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 06:47:06 -0400
Message-ID: <4FC5FA20.50301@parallels.com>
Date: Wed, 30 May 2012 14:44:48 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: <linux-kernel@vger.kernel.org>, <cgroups@vger.kernel.org>,
        <devel@openvz.org>, Paul Turner <pjt@google.com>,
        Tejun Heo <tj@kernel.org>, "Eric W. Biederman" <ebiederm@xmission.com>,
        <handai.szj@gmail.com>, <Andrew.Phillips@lmax.com>,
        Serge Hallyn <serge.hallyn@canonical.com>
Subject: Re: [PATCH v3 3/6] expose fine-grained per-cpu data for cpuacct stats
References: <1338371317-5980-1-git-send-email-glommer@parallels.com>   <1338371317-5980-4-git-send-email-glommer@parallels.com>  <1338374041.26856.241.camel@twins> <4FC5F7A0.2000201@parallels.com> <1338374628.26856.244.camel@twins>
In-Reply-To: <1338374628.26856.244.camel@twins>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/30/2012 02:43 PM, Peter Zijlstra wrote:
> On Wed, 2012-05-30 at 14:34 +0400, Glauber Costa wrote:
>> On 05/30/2012 02:34 PM, Peter Zijlstra wrote:
>>> On Wed, 2012-05-30 at 13:48 +0400, Glauber Costa wrote:
>>>
>>>> +static int cpuacct_stats_percpu_show(struct cgroup *cgrp, struct cftype *cft,
>>>> +				     struct cgroup_map_cb *cb)
>>>> +{
>>>> +	struct cpuacct *ca = cgroup_ca(cgrp);
>>>> +	int cpu;
>>>> +
>>>> +	for_each_online_cpu(cpu) {
>>>> +		do_fill_cb(cb, ca, "user", cpu, CPUTIME_USER);
>>>> +		do_fill_cb(cb, ca, "nice", cpu, CPUTIME_NICE);
>>>> +		do_fill_cb(cb, ca, "system", cpu, CPUTIME_SYSTEM);
>>>> +		do_fill_cb(cb, ca, "irq", cpu, CPUTIME_IRQ);
>>>> +		do_fill_cb(cb, ca, "softirq", cpu, CPUTIME_SOFTIRQ);
>>>> +		do_fill_cb(cb, ca, "guest", cpu, CPUTIME_GUEST);
>>>> +		do_fill_cb(cb, ca, "guest_nice", cpu, CPUTIME_GUEST_NICE);
>>>> +	}
>>>> +
>>>> +	return 0;
>>>> +}
>>>
>>> Uhm, hotplug anyone?
>> What's with hotplug ?
>
>
> Who's to say all cpus are online at this point? If you don't want to
> make the files come and go with hotplug, one should use
> for_each_possible_cpu().
>
I don't oppose that.
But I don't really parse what you mean by "make the files go away". We 
have just one file, with multiple entries. The entries are in key:value 
form, so I don't see a huge problem in having some entries disappearing.

As a matter of fact, this is exactly what happens in /proc/stat when you 
offline a cpu: the correspondent line will stop showing up.


