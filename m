Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759525Ab2INMZd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 08:25:33 -0400
Received: from casper.infradead.org ([85.118.1.10]:35372 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758736Ab2INMZc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 08:25:32 -0400
Message-ID: <1347625519.7172.31.camel@twins>
Subject: Re: WARNING: at kernel/rcutree.c:1558 rcu_do_batch+0x386/0x3a0(),
 during CPU hotplug
From: Peter Zijlstra <peterz@infradead.org>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: Fengguang Wu <fengguang.wu@intel.com>, paulmck@linux.vnet.ibm.com,
        jack@suse.cz,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "rusty@rustcorp.com.au" <rusty@rustcorp.com.au>,
        Tejun Heo <tj@kernel.org>, Michael Wang <wangyun@linux.vnet.ibm.com>
Date: Fri, 14 Sep 2012 14:25:19 +0200
In-Reply-To: <5053208C.4060205@linux.vnet.ibm.com>
References: <5007F8FA.7000203@linux.vnet.ibm.com>
	 <20120719171550.GL2507@linux.vnet.ibm.com>
	 <505081C4.2050600@linux.vnet.ibm.com> <50519AC5.9060102@linux.vnet.ibm.com>
	 <20120914114752.GA20349@localhost> <5053208C.4060205@linux.vnet.ibm.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-09-14 at 17:48 +0530, Srivatsa S. Bhat wrote:
> #! /bin/bash

CPUPATH="/sys/devices/system/cpu"

> NUMBER_OF_CPUS=`ls -d /sys/devices/system/cpu/cpu[0-9]* | wc -l`

apply the above

> cd /sys/devices/system/cpu

skip this, so running the script doesn't change PWD

> while [ 1 ]

while :;

> do
>         for ((i=1; i < NUMBER_OF_CPUS; i++))
>         do
>                 sleep 1;

Also play with shorter sleeps like: sleep .1, I've found that higher
hotplug rate triggers some races faster.

>                 state=`cat cpu$i/online`
>                 if [ $state -eq 0 ]
>                 then
>                         echo 1 > cpu$i/online
>                 else
>                         echo 0 > cpu$i/online

	echo $((state^1)) > $CPUPATH/cpu$i/online

>                 fi
>         done
> done 


