Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752964Ab2INMcT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 08:32:19 -0400
Received: from mga01.intel.com ([192.55.52.88]:9557 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751102Ab2INMcS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 08:32:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,422,1344236400"; 
   d="scan'208";a="222142049"
Date: Fri, 14 Sep 2012 20:32:13 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        paulmck@linux.vnet.ibm.com, jack@suse.cz,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "rusty@rustcorp.com.au" <rusty@rustcorp.com.au>,
        Tejun Heo <tj@kernel.org>, Michael Wang <wangyun@linux.vnet.ibm.com>
Subject: Re: WARNING: at kernel/rcutree.c:1558 rcu_do_batch+0x386/0x3a0(),
 during CPU hotplug
Message-ID: <20120914123213.GB21038@localhost>
References: <5007F8FA.7000203@linux.vnet.ibm.com>
 <20120719171550.GL2507@linux.vnet.ibm.com>
 <505081C4.2050600@linux.vnet.ibm.com>
 <50519AC5.9060102@linux.vnet.ibm.com>
 <20120914114752.GA20349@localhost>
 <5053208C.4060205@linux.vnet.ibm.com>
 <1347625519.7172.31.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1347625519.7172.31.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 14, 2012 at 02:25:19PM +0200, Peter Zijlstra wrote:
> On Fri, 2012-09-14 at 17:48 +0530, Srivatsa S. Bhat wrote:
> > #! /bin/bash
> 
> CPUPATH="/sys/devices/system/cpu"
> 
> > NUMBER_OF_CPUS=`ls -d /sys/devices/system/cpu/cpu[0-9]* | wc -l`
> 
> apply the above
> 
> > cd /sys/devices/system/cpu
> 
> skip this, so running the script doesn't change PWD

Yes, that's good practice.

> > while [ 1 ]
> 
> while :;

I used to use 'true', but ':' looks cool!

> > do
> >         for ((i=1; i < NUMBER_OF_CPUS; i++))
> >         do
> >                 sleep 1;
> 
> Also play with shorter sleeps like: sleep .1, I've found that higher
> hotplug rate triggers some races faster.

OK.

> >                 state=`cat cpu$i/online`
> >                 if [ $state -eq 0 ]
> >                 then
> >                         echo 1 > cpu$i/online
> >                 else
> >                         echo 0 > cpu$i/online
> 
> 	echo $((state^1)) > $CPUPATH/cpu$i/online

Good!

Thanks,
Fengguang
