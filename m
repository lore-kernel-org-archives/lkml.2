Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757798Ab1ANSaJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 13:30:09 -0500
Received: from mx1.redhat.com ([209.132.183.28]:36410 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752335Ab1ANSaF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 13:30:05 -0500
Message-ID: <4D309620.60507@redhat.com>
Date: Fri, 14 Jan 2011 13:29:52 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc13 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: vatsa@linux.vnet.ibm.com
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Avi Kiviti <avi@redhat.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mike Galbraith <efault@gmx.de>, Chris Wright <chrisw@sous-sol.org>,
        ttracy@redhat.com, dshaks@redhat.com
Subject: Re: [RFC -v5 PATCH 2/4] sched: Add yield_to(task, preempt) functionality.
References: <20110114030209.53765a0a@annuminas.surriel.com> <20110114030357.03c3060a@annuminas.surriel.com> <20110114174741.GB28632@linux.vnet.ibm.com>
In-Reply-To: <20110114174741.GB28632@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/14/2011 12:47 PM, Srivatsa Vaddagiri wrote:

> If I recall correctly, one of the motivations for yield_to_task (rather than
> a simple yield) was to avoid leaking bandwidth to other guests i.e we don't want
> the remaining timeslice of spinning vcpu to be given away to other guests but
> rather donate it to another (lock-holding) vcpu and thus retain the bandwidth
> allocated to the guest.

No, that was not the motivation.   The motivation was to try
and get the lock holder to run soon, so it can release the
lock.

What you describe is merely one of the mechanisms considered
for meeting that objective.

> I am not sure whether we are meeting that objective via this patch, as
> lock-spinning vcpu would simply yield after setting next buddy to preferred
> vcpu on target pcpu, thereby leaking some amount of bandwidth on the pcpu
> where it is spinning.

Have you read the patch?

-- 
All rights reversed
