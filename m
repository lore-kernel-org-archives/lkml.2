Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754002Ab0E1Gi6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 02:38:58 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:39336 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752143Ab0E1Gi5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 02:38:57 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 28 May 2010 15:34:32 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: balbir@linux.vnet.ibm.com
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       "Luis Claudio R. Goncalves" <lclaudio@uudg.org>,
       Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       David Rientjes <rientjes@google.com>, Mel Gorman <mel@csn.ul.ie>,
       williams@redhat.com
Subject: Re: [RFC] oom-kill: give the dying task a higher priority
Message-Id: <20100528153432.a4f5ef2c.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100528062701.GA3519@balbir.in.ibm.com>
References: <20100528035147.GD11364@uudg.org>
	<20100528043339.GZ3519@balbir.in.ibm.com>
	<20100528134133.7E24.A69D9226@jp.fujitsu.com>
	<20100528062701.GA3519@balbir.in.ibm.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 May 2010 11:57:01 +0530
Balbir Singh <balbir@linux.vnet.ibm.com> wrote:

> I am still not convinced, specially if we are running under mem
> cgroup. Even setting SCHED_FIFO does not help, you could have other
> things like cpusets that might restrict the CPUs you can run on, or
> any other policy and we could end up contending anyway with other
> SCHED_FIFO tasks.
>  
> > That's the reason I acked it.
> 
> If we could show faster recovery from OOM or anything else, I would be
> more convinced.
> 
Off topic.

 1. Run a daemon in the highest RT priority.
 2. disable OOM for a mem cgroup.
 3. The daemon register oom-event-notifier of the mem cgroup.

 When OOM happens.
 4. The daemon receive a event, and then,
    a) enlarge limit
    or
    b) kill a task 
    or
    c) enlarge limit temporary and kill a task, later, reduce limit again.

This is the fastest and promissing operation for memcg users.

memcg's oom slowdown happens just because it's limited by a user configuration
not by the system. That's a point to be considered.
The oom situation can be _immediaterly_ fixed up by enlarge limit as emergency mode.

If you has to wait for the end of a task, there will be delay, it's unavoidable.

Thanks,
-Kame



