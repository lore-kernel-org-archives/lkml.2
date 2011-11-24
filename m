Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753428Ab1KXLyC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Nov 2011 06:54:02 -0500
Received: from merlin.infradead.org ([205.233.59.134]:40791 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752024Ab1KXLyB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Nov 2011 06:54:01 -0500
Message-ID: <1322135629.2921.13.camel@twins>
Subject: Re: [patch 3/6] sched, nohz: sched group, domain aware nohz idle
 load balancing
From: Peter Zijlstra <peterz@infradead.org>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, Venki Pallipadi <venki@google.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Mike Galbraith <efault@gmx.de>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Tim Chen <tim.c.chen@linux.jf.intel.com>, alex.shi@intel.com
Date: Thu, 24 Nov 2011 12:53:49 +0100
In-Reply-To: <20111118230553.995756330@sbsiddha-desk.sc.intel.com>
References: <20111118230323.592022417@sbsiddha-desk.sc.intel.com>
	 <20111118230553.995756330@sbsiddha-desk.sc.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-11-18 at 15:03 -0800, Suresh Siddha wrote:
> Make nohz idle load balancing more scalabale by using the nr_busy_cpus in
> the struct sched_group_power.
> 
> Idle load balance is kicked on one of the idle cpu's when there is atleast
> one idle cpu and
> 
>  - a busy rq having more than one task or
> 
>  - a busy scheduler group having multiple busy cpus that exceed the sched group
>    power or
> 
>  - for the SD_ASYM_PACKING domain, if the lower numbered cpu's in that
>    domain are idle compared to the busy ones.
> 
> This will help in kicking the idle load balancing request only when
> there is a real imbalance. And once it is mostly balanced, these kicks will
> be minimized.
> 
> These changes helped improve the workload that is context switch intensive
> between number of task pairs by 2x on a 8 socket NHM-EX based system.

OK, but the nohz idle balance will still iterate the whole machine
instead of smaller parts, right?


