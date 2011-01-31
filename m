Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755952Ab1AaPDR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 10:03:17 -0500
Received: from mx1.redhat.com ([209.132.183.28]:34205 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752550Ab1AaPDQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 10:03:16 -0500
Message-ID: <4D46CF18.4060406@redhat.com>
Date: Mon, 31 Jan 2011 10:02:48 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc13 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Avi Kiviti <avi@redhat.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Mike Galbraith <efault@gmx.de>, Chris Wright <chrisw@sous-sol.org>,
        ttracy@redhat.com, "Nakajima, Jun" <jun.nakajima@intel.com>
Subject: Re: [RFC -v7 PATCH 3/7] sched: use a buddy to implement yield_task_fair
References: <20110126165657.2ddd2ac9@annuminas.surriel.com>	 <20110126172101.7b5c22e6@annuminas.surriel.com> <1296474447.15234.392.camel@laptop>
In-Reply-To: <1296474447.15234.392.camel@laptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/31/2011 06:47 AM, Peter Zijlstra wrote:
> On Wed, 2011-01-26 at 17:21 -0500, Rik van Riel wrote:
>
>> +static struct sched_entity *__pick_second_entity(struct cfs_rq *cfs_rq)
>> +{
>> +	struct rb_node *left = cfs_rq->rb_leftmost;
>> +	struct rb_node *second;
>> +
>> +	if (!left)
>> +		return NULL;
>> +
>> +	second = rb_next(left);
>> +
>> +	if (!second)
>> +		second = left;
>> +
>> +	return rb_entry(second, struct sched_entity, run_node);
>> +}
>
> I would still prefer:
>
> sed -i 's/__pick_next_entity/__pick_first_entity/g' kernel/sched*.[ch]

Ahhh, now I understand what you want.  I'll get right on it.

> You seem to have lost the hunk removing sysctl_sched_compat_yield from
> kernel/sysctl.c :-)

Let me take care of that, too.

-- 
All rights reversed
