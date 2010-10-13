Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752608Ab0JMN7L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Oct 2010 09:59:11 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:35659 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752133Ab0JMN7K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Oct 2010 09:59:10 -0400
Date: Wed, 13 Oct 2010 19:29:02 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Nikhil Rao <ncrao@google.com>
Cc: Bharata B Rao <bharata@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
        Dhaval Giani <dhaval.giani@gmail.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Pavel Emelyanov <xemul@openvz.org>,
        Herbert Poetzl <herbert@13thfloor.at>, Avi Kivity <avi@redhat.com>,
        Chris Friesen <cfriesen@nortel.com>, Paul Menage <menage@google.com>,
        Mike Waychison <mikew@google.com>, Paul Turner <pjt@google.com>
Subject: Re: [PATCH v3 2/7] sched: accumulate per-cfs_rq cpu usage
Message-ID: <20101013135902.GA4189@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <20101012074910.GA9893@in.ibm.com>
 <20101012075109.GC9893@in.ibm.com>
 <20101013133053.GD3914@balbir.in.ibm.com>
 <AANLkTiko2JryQWRmn2Df0-OyQwXgSZ6nyvrMm-o5WNvS@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <AANLkTiko2JryQWRmn2Df0-OyQwXgSZ6nyvrMm-o5WNvS@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Nikhil Rao <ncrao@google.com> [2010-10-13 06:46:18]:

> > Quick question for cfs_b->quota == RUNTIME_INF, won't cfs_b->runtime
> > be always > 0?
> 
> Hi Balbir,
> 
> cfs_b->runtime can be 0 if the task group exhausts its quota.
> cfs_b->runtime is a counter that is periodically refreshed to
> cfs_b->quota, and is decremented every time a cfs_rq requests a slice.
>

Thanks, Nikhil

I saw several checks for quota == RUNTIME_INF and saw updates not
happening. Do we track usage for cgroups with infinite quota? IOW, is
runtime updated? If so, why?

-- 
	Three Cheers,
	Balbir
