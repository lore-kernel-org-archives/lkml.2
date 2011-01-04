Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752067Ab1ADJOs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 04:14:48 -0500
Received: from mx1.redhat.com ([209.132.183.28]:35289 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750944Ab1ADJOr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 04:14:47 -0500
Message-ID: <4D22E4F9.4060909@redhat.com>
Date: Tue, 04 Jan 2011 11:14:33 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: Rik van Riel <riel@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mike Galbraith <efault@gmx.de>, Chris Wright <chrisw@sous-sol.org>
Subject: Re: [RFC -v3 PATCH 0/3] directed yield for Pause Loop Exiting
References: <20110103162637.29f23c40@annuminas.surriel.com>
In-Reply-To: <20110103162637.29f23c40@annuminas.surriel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/03/2011 11:26 PM, Rik van Riel wrote:
> When running SMP virtual machines, it is possible for one VCPU to be
> spinning on a spinlock, while the VCPU that holds the spinlock is not
> currently running, because the host scheduler preempted it to run
> something else.
>
> Both Intel and AMD CPUs have a feature that detects when a virtual
> CPU is spinning on a lock and will trap to the host.
>
> The current KVM code sleeps for a bit whenever that happens, which
> results in eg. a 64 VCPU Windows guest taking forever and a bit to
> boot up.  This is because the VCPU holding the lock is actually
> running and not sleeping, so the pause is counter-productive.
>
> In other workloads a pause can also be counter-productive, with
> spinlock detection resulting in one guest giving up its CPU time
> to the others.  Instead of spinning, it ends up simply not running
> much at all.
>
> This patch series aims to fix that, by having a VCPU that spins
> give the remainder of its timeslice to another VCPU in the same
> guest before yielding the CPU - one that is runnable but got
> preempted, hopefully the lock holder.
>

Looks great.

Assuming there are no objections, Mike, can you get 2/3 into a 
fast-forward-only branch of tip.git?  I'll then merge it into kvm.git 
and apply 1/3 and 2/3.

Since the merge window is about to open I'd like to merge this for 
2.6.39 so it gets to stew a while in tip.git, kvm.git, and linux-next.

-- 
error compiling committee.c: too many arguments to function

