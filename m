Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753633Ab1ITMzq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 08:55:46 -0400
Received: from merlin.infradead.org ([205.233.59.134]:60581 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752742Ab1ITMzp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 08:55:45 -0400
Subject: Re: CFS Bandwidth Control - Test results of cgroups tasks pinned vs
 unpinnede
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Cc: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Paul Turner <pjt@google.com>,
        Vladimir Davydov <vdavydov@parallels.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Bharata B Rao <bharata@linux.vnet.ibm.com>,
        Dhaval Giani <dhaval.giani@gmail.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Pavel Emelianov <xemul@parallels.com>
Date: Tue, 20 Sep 2011 14:55:20 +0200
In-Reply-To: <20110915175537.GA17701@linux.vnet.ibm.com>
References: <1315906788.575.3.camel@twins>
	 <20110913112852.GE7254@linux.vnet.ibm.com> <1315922848.5977.11.camel@twins>
	 <20110913162119.GA3045@linux.vnet.ibm.com> <1315931775.5977.29.camel@twins>
	 <20110913175425.GB3062@linux.vnet.ibm.com> <1315937995.4226.9.camel@twins>
	 <20110913182841.GO11100@linux.vnet.ibm.com>
	 <1315938646.4226.12.camel@twins>
	 <20110913183502.GP11100@linux.vnet.ibm.com>
	 <20110915175537.GA17701@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1316523320.13664.2.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-09-15 at 23:25 +0530, Kamalesh Babulal wrote:

> lb.sh
> ------
> #!/bin/bash
> 
> rm -rf test*
> rm -rf t*

You're insane, right?

> ITERATIONS=60			# No of Iterations to capture the details
> NUM_CPUS=$(cat /proc/cpuinfo |grep -i proces|wc -l)
> 
> NUM_HOGS=$((NUM_CPUS * 2))	# No of hogs threads to invoke
> 
> echo "System has $NUM_CPUS cpus..... Spawing $NUM_HOGS cpu hogs ... for $ITERATIONS seconds.."
> if [ ! -e while1.c ]
> then
> 	cat >> while1.c << EOF
> 	int
> 	main (int argc, char **argv)
> 	{
> 		while(1);
> 		return (0);
> 	}
> EOF
> fi
> 
> for i in $(seq 1 $NUM_HOGS)
> do
> 	gcc -o while$i while1.c
> 	if [ $? -ne 0 ]
> 	then
> 		echo "Looks like gcc is not present ... aborting"
> 		exit
> 	fi
> done
> 
> for i in $(seq 1 $NUM_HOGS)
> do
> 	./while$i &

You can kill the above two blocks by doing:

	while :; do :; done &

> 	pids[$i]=$!
> 	pids_old[$i]=`cat /proc/$!/sched |grep -i nr_migr|grep -iv cold|cut -d ":" -f2|sed 's/  //g'`
> done


and a fixup of the pkill muck.
