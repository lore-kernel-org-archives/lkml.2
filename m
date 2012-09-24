Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753403Ab2IXKMW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 06:12:22 -0400
Received: from casper.infradead.org ([85.118.1.10]:35525 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751791Ab2IXKMU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 06:12:20 -0400
Message-ID: <1348481528.11847.29.camel@twins>
Subject: Re: [PATCH] Update sched_domains_numa_masks when new cpus are
 onlined.
From: Peter Zijlstra <peterz@infradead.org>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: Tang Chen <tangchen@cn.fujitsu.com>, linux-kernel@vger.kernel.org,
        x86@kernel.org, linux-numa@vger.kernel.org, wency@cn.fujitsu.com,
        mingo@kernel.org, Thomas Gleixner <tglx@linutronix.de>
Date: Mon, 24 Sep 2012 12:12:08 +0200
In-Reply-To: <50602E75.1010304@linux.vnet.ibm.com>
References: <1347963128-25942-1-git-send-email-tangchen@cn.fujitsu.com>
	 <1348479536.11847.25.camel@twins> <50602E75.1010304@linux.vnet.ibm.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-09-24 at 15:27 +0530, Srivatsa S. Bhat wrote:
> On 09/24/2012 03:08 PM, Peter Zijlstra wrote:  
> >> +       hotcpu_notifier(sched_domains_numa_masks_update, CPU_PRI_SCHED_ACTIVE);
> >>         hotcpu_notifier(cpuset_cpu_active, CPU_PRI_CPUSET_ACTIVE);
> >>         hotcpu_notifier(cpuset_cpu_inactive, CPU_PRI_CPUSET_INACTIVE);
> > 
> > OK, so you really want your notifier to run before cpuset_cpu_active
> > because otherwise you get that crash, yet you fail with the whole order
> > thing.. You should not _ever_ rely on registration order.
> > 
> 
> IMHO he isn't relying on registration order.. He uses the CPU_PRI_SCHED_ACTIVE
> priority to ensure that the ordering of callbacks is right, isn't it?

Oh argh indeed. I can't read :/


