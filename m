Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753596Ab0LMJ7t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 04:59:49 -0500
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:59822 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753307Ab0LMJ7r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 04:59:47 -0500
Date: Sat, 11 Dec 2010 19:27:27 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Avi Kivity <avi@redhat.com>
Cc: Rik van Riel <riel@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Anthony Liguori <aliguori@linux.vnet.ibm.com>
Subject: Re: [RFC PATCH 0/3] directed yield for Pause Loop Exiting
Message-ID: <20101211135727.GU3158@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <20101202144129.4357fe00@annuminas.surriel.com>
 <20101210050344.GR3158@balbir.in.ibm.com>
 <4D0328CC.1020809@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <4D0328CC.1020809@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Avi Kivity <avi@redhat.com> [2010-12-11 09:31:24]:

> On 12/10/2010 07:03 AM, Balbir Singh wrote:
> >>
> >>  Scheduler people, please flame me with anything I may have done
> >>  wrong, so I can do it right for a next version :)
> >>
> >
> >This is a good problem statement, there are other things to consider
> >as well
> >
> >1. If a hard limit feature is enabled underneath, donating the
> >timeslice would probably not make too much sense in that case
> 
> What's the alternative?
> 
> Consider a two vcpu guest with a 50% hard cap.  Suppose the workload
> involves ping-ponging within the guest.  If the scheduler decides to
> schedule the vcpus without any overlap, then the throughput will be
> dictated by the time slice.  If we allow donation, throughput is
> limited by context switch latency.
>

If the vpcu holding the lock runs more and capped, the timeslice
transfer is a heuristic that will not help. 

-- 
	Three Cheers,
	Balbir
