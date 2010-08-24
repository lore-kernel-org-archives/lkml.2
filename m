Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752376Ab0HXIFY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 04:05:24 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:54079 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750769Ab0HXIFU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 04:05:20 -0400
Date: Tue, 24 Aug 2010 13:35:15 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Venkatesh Pallipadi <venki@google.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, Paul Menage <menage@google.com>,
        linux-kernel@vger.kernel.org, Paul Turner <pjt@google.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Paul Mackerras <paulus@samba.org>, Tony Luck <tony.luck@intel.com>
Subject: Re: [PATCH 0/4] Finer granularity and task/cgroup irq time accounting
Message-ID: <20100824080515.GK4684@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <1279583835-22854-1-git-send-email-venki@google.com>
 <20100720095546.2f899e04@mschwide.boeblingen.de.ibm.com>
 <AANLkTiktBNr3pVOHwxX3piwagtkGxHpp5TepBFS3UGhb@mail.gmail.com>
 <20100722131239.208d9501@mschwide.boeblingen.de.ibm.com>
 <AANLkTim==2J3Fo8Axz0yLvpfWf1bq_e0c0EYWi6y3xRe@mail.gmail.com>
 <1282636286.2605.2307.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1282636286.2605.2307.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra <peterz@infradead.org> [2010-08-24 09:51:26]:

> On Thu, 2010-07-22 at 19:12 -0700, Venkatesh Pallipadi wrote:
> > >
> > > Well, the task and cgroup information is there but what does it really
> > > tell me? As long as the irq & softirq time can be caused by any other
> > > process I don't see the value of this incorrect data point.
> > >
> > 
> > Data point will be correct. How it gets used is a different qn. This
> > interface will be useful for Alert/Paranoid/Annoyed user/admin who
> > sees that the job exec_time is high but it is not doing any useful
> > work. 
> 
> I'm very sympathetic with Martin's POV. irq/softirq times per task don't
> really make sense. In the case you provide above the solution would be
> to subtract these times from the task execution time, not break it out.
> In that case he would see his task not do much, and end up with the same
> action list.
>

cgroup level info does make sense, assuming that tasks that share the
costs being mentioned here belong to the same cgroup. Though the data
is calculated per task, when accumulated per cgroup, it should be
close to being correct.

-- 
	Three Cheers,
	Balbir
