Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751533Ab1AEIgF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 03:36:05 -0500
Received: from mx1.redhat.com ([209.132.183.28]:30064 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751309Ab1AEIgE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 03:36:04 -0500
Message-ID: <4D242D60.9060301@redhat.com>
Date: Wed, 05 Jan 2011 10:35:44 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: Rik van Riel <riel@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mike Galbraith <efault@gmx.de>, Chris Wright <chrisw@sous-sol.org>
Subject: Re: [RFC -v3 PATCH 2/3] sched: add yield_to function
References: <20110104151345.3BC2.A69D9226@jp.fujitsu.com> <4D230C90.6060104@redhat.com> <20110105110837.B62A.A69D9226@jp.fujitsu.com>
In-Reply-To: <20110105110837.B62A.A69D9226@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/05/2011 04:39 AM, KOSAKI Motohiro wrote:
> >  On 01/04/2011 08:14 AM, KOSAKI Motohiro wrote:
> >  >  Also, If pthread_cond_signal() call sys_yield_to imlicitly, we can
> >  >  avoid almost Nehalem (and other P2P cache arch) lock unfairness
> >  >  problem. (probaby creating pthread_condattr_setautoyield_np or similar
> >  >  knob is good one)
> >
> >  Often, the thread calling pthread_cond_signal() wants to continue
> >  executing, not yield.
>
> Then, it doesn't work.
>
> After calling pthread_cond_signal(), T1 which cond_signal caller and T2
> which waked start to GIL grab race. But usually T1 is always win because
> lock variable is in T1's cpu cache. Why kernel and userland have so much
> different result? One of a reason is glibc doesn't have any ticket lock scheme.
>
> If you are interesting GIL mess and issue, please feel free to ask more.

I suggest looking into an explicit round-robin scheme, where each thread 
adds itself to a queue and an unlock wakes up the first waiter.

-- 
error compiling committee.c: too many arguments to function

