Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752656Ab1BWKOB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 05:14:01 -0500
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:33625 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752141Ab1BWKN7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 05:13:59 -0500
Date: Wed, 23 Feb 2011 15:43:49 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Paul Turner <pjt@google.com>
Cc: Bharata B Rao <bharata@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
        Dhaval Giani <dhaval@linux.vnet.ibm.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Gautham R Shenoy <ego@in.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Pavel Emelyanov <xemul@openvz.org>,
        Herbert Poetzl <herbert@13thfloor.at>, Avi Kivity <avi@redhat.com>,
        Chris Friesen <cfriesen@nortel.com>, Nikhil Rao <ncrao@google.com>
Subject: Re: [CFS Bandwidth Control v4 5/7] sched: add exports tracking cfs
 bandwidth control statistics
Message-ID: <20110223101349.GL3379@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <20110216031831.571628191@google.com>
 <20110216031841.258879435@google.com>
 <20110222031420.GI10342@balbir.in.ibm.com>
 <20110222041332.GA2753@in.ibm.com>
 <20110222044035.GL10342@balbir.in.ibm.com>
 <AANLkTinsxWgRAV5JvAnX5B7nXFWp9sE7y41gHJtkwg=6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <AANLkTinsxWgRAV5JvAnX5B7nXFWp9sE7y41gHJtkwg=6@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Paul Turner <pjt@google.com> [2011-02-23 00:03:42]:

> On Mon, Feb 21, 2011 at 8:40 PM, Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> > * Bharata B Rao <bharata@linux.vnet.ibm.com> [2011-02-22 09:43:33]:
> >
> >> >
> >> > Should we consider integrating this in cpuacct, it would be difficult
> >> > if we spill over stats between controllers.
> >>
> >> Given that cpuacct controller can be mounted independently, I am not sure
> >> if we should integrate these stats. These stats come from cpu controller.
> >
> > The accounting controller was created to account. I'd still prefer
> > cpuacct, so that I can find everything in one place. NOTE: cpuacct was
> > created so that we do accounting with control - just account. I think
> > splitting stats creates a usability mess - no?
> >
> 
> One problem with rolling it into cpuacct is that some of the
> statistics have a 1:1 association with the hierarchy being throttled.
> For example, the number of periods in which throttling occurred or the
> count of elapsed periods.
> 
> If it were rolled into cpuacct the only meaningful export would be the
> total throttled time -- perhaps this is sufficient?
>

Good point, lets keep it as is. nr_throttled and nr_periods is also
important (although it can be derived).

-- 
	Three Cheers,
	Balbir
