Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030398Ab2CBRlc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 12:41:32 -0500
Received: from mga01.intel.com ([192.55.52.88]:48374 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759002Ab2CBRlb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 12:41:31 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="124248220"
Subject: Re: [PATCH] Extend mwait idle to optimize away CAL and RES
 interrupts to an idle CPU -v1
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Venki Pallipadi <venki@google.com>, Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Aaron Durbin <adurbin@google.com>,
        Paul Turner <pjt@google.com>, Yong Zhang <yong.zhang0@gmail.com>,
        linux-kernel@vger.kernel.org
Date: Fri, 02 Mar 2012 09:41:43 -0800
In-Reply-To: <20120302072147.GA32401@elte.hu>
References: <1329957415-15239-1-git-send-email-venki@google.com>
	 <20120223075027.GB15306@elte.hu>
	 <CABeCy1YeGjTAGKRwwaryY9bx9UwMq9nhGAsVV-o2QEjPH=4ErA@mail.gmail.com>
	 <1330651732.30167.63.camel@sbsiddha-desk.sc.intel.com>
	 <CABeCy1btewB-oTgyL06qvebLLXTqareYNy-wdNZ3oiHR3KPwEw@mail.gmail.com>
	 <1330652258.30167.70.camel@sbsiddha-desk.sc.intel.com>
	 <CABeCy1a7RszUWBV10tVbdsxAdPpQAMSQXw-pMG2znTqYb5WN5A@mail.gmail.com>
	 <20120302072147.GA32401@elte.hu>
Organization: Intel Corp
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1330710103.30167.84.camel@sbsiddha-desk.sc.intel.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-03-02 at 08:21 +0100, Ingo Molnar wrote:
> * Venki Pallipadi <venki@google.com> wrote:
> > Yes. This case will be problematic. So, we still need struct 
> > create_idle work stuff even after percpu idle_task. Or was 
> > Ingo's suggestion to do something along the lines of - init 
> > any CPU's idle task from CPU 0's idle task?
> 
> If the percpu area of possible CPUs is already allocated at this 
> point then we should probably do that.
> 
> If not then what is the problem with doing fork_idle() from the 
> hotplug process context? Where does the assymetry in the dynamic 
> case come from?

As far as I know, we limit the # of cpus that can be onlined to the
possible cpus determined at boot time and this doesn't change after
boot. percpu area of possible cpu's already allocated by this point.

Main exercise I think is to move the init_task to percpu area of cpu-0
and ensure that fork_idle() does the init properly (with out allocating
the memory but do the initialization done by the
copy_process/dup_task_struct etc)

thanks,
suresh

