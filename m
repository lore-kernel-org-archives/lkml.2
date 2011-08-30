Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755436Ab1H3Ph6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 11:37:58 -0400
Received: from casper.infradead.org ([85.118.1.10]:54717 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755210Ab1H3Ph5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 11:37:57 -0400
Subject: Re: [PATCH 12/32] nohz: Try not to give the timekeeping duty to a
 cpuset nohz cpu
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Anton Blanchard <anton@au1.ibm.com>, Avi Kivity <avi@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, Lai Jiangshan <laijs@cn.fujitsu.com>,
        "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tim Pepper <lnxninja@linux.vnet.ibm.com>,
        Dimitri Sivanich <sivanich@sgi.com>, Paul Menage <paul@paulmenage.org>
Date: Tue, 30 Aug 2011 17:37:28 +0200
In-Reply-To: <20110830151704.GV9748@somewhere.redhat.com>
References: <1313423549-27093-1-git-send-email-fweisbec@gmail.com>
	 <1313423549-27093-13-git-send-email-fweisbec@gmail.com>
	 <1314629745.2816.84.camel@twins>
	 <20110830151704.GV9748@somewhere.redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.2- 
Message-ID: <1314718648.5812.20.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-08-30 at 17:17 +0200, Frederic Weisbecker wrote:
> On Mon, Aug 29, 2011 at 04:55:45PM +0200, Peter Zijlstra wrote:
> > On Mon, 2011-08-15 at 17:52 +0200, Frederic Weisbecker wrote:
> > > Try to give the timekeeing duty to a CPU that doesn't belong
> > > to any nohz cpuset when possible, so that we increase the chance
> > > for these nohz cpusets to run their CPUs out of periodic tick
> > > mode. 
> > 
> > You and Dmitiri might want to get together:
> > 
> > lkml.kernel.org/r/20110823195628.GB4533@sgi.com
> 
> Right!
> 
> There is another missing piece in my patchset. If every non adaptive-nohz
> CPUs are sleeping, then none is handling the do_timer duty and adaptive nohz
> CPUs run with a stale jiffies and walltime.

Doesn't nohz already deal with the case of all cpus being idle? In that
case the cpu that wakes up first gets to play catch up on irq_enter() or
so.


