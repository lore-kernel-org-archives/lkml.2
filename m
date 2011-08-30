Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755085Ab1H3PRO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 11:17:14 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:61978 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754861Ab1H3PRM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 11:17:12 -0400
Date: Tue, 30 Aug 2011 17:17:06 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Anton Blanchard <anton@au1.ibm.com>, Avi Kivity <avi@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, Lai Jiangshan <laijs@cn.fujitsu.com>,
        "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tim Pepper <lnxninja@linux.vnet.ibm.com>,
        Dimitri Sivanich <sivanich@sgi.com>, Paul Menage <paul@paulmenage.org>
Subject: Re: [PATCH 12/32] nohz: Try not to give the timekeeping duty to a
 cpuset nohz cpu
Message-ID: <20110830151704.GV9748@somewhere.redhat.com>
References: <1313423549-27093-1-git-send-email-fweisbec@gmail.com>
 <1313423549-27093-13-git-send-email-fweisbec@gmail.com>
 <1314629745.2816.84.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1314629745.2816.84.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 29, 2011 at 04:55:45PM +0200, Peter Zijlstra wrote:
> On Mon, 2011-08-15 at 17:52 +0200, Frederic Weisbecker wrote:
> > Try to give the timekeeing duty to a CPU that doesn't belong
> > to any nohz cpuset when possible, so that we increase the chance
> > for these nohz cpusets to run their CPUs out of periodic tick
> > mode. 
> 
> You and Dmitiri might want to get together:
> 
> lkml.kernel.org/r/20110823195628.GB4533@sgi.com

Right!

There is another missing piece in my patchset. If every non adaptive-nohz
CPUs are sleeping, then none is handling the do_timer duty and adaptive nohz
CPUs run with a stale jiffies and walltime.

I need to handle that.
