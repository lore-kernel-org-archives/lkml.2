Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755379Ab1H3Paq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 11:30:46 -0400
Received: from relay1.sgi.com ([192.48.179.29]:44655 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755235Ab1H3Pap (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 11:30:45 -0400
Date: Tue, 30 Aug 2011 10:30:42 -0500
From: Dimitri Sivanich <sivanich@sgi.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Anton Blanchard <anton@au1.ibm.com>, Avi Kivity <avi@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, Lai Jiangshan <laijs@cn.fujitsu.com>,
        "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tim Pepper <lnxninja@linux.vnet.ibm.com>,
        Paul Menage <paul@paulmenage.org>
Subject: Re: [PATCH 12/32] nohz: Try not to give the timekeeping duty to a
 cpuset nohz cpu
Message-ID: <20110830153042.GA23932@sgi.com>
References: <1313423549-27093-1-git-send-email-fweisbec@gmail.com>
 <1313423549-27093-13-git-send-email-fweisbec@gmail.com>
 <1314629745.2816.84.camel@twins>
 <20110830151704.GV9748@somewhere.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110830151704.GV9748@somewhere.redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 30, 2011 at 05:17:06PM +0200, Frederic Weisbecker wrote:
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
> 
> I need to handle that.

Frederic,

Please note that the patch that Peter references (lkml.kernel.org/r/20110823195628.GB4533@sgi.com) supports only the nohz=off case.
