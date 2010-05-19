Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757044Ab0ESK2h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 06:28:37 -0400
Received: from casper.infradead.org ([85.118.1.10]:56060 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753382Ab0ESK2f convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 06:28:35 -0400
Subject: Re: [PATCH] scheduler: Extract cgroups_cpuaccount code from
 sched.c into own file
From: Peter Zijlstra <peterz@infradead.org>
To: Thomas Renninger <trenn@suse.de>
Cc: Mike Chan <mike@android.com>, khilman@deeprootsystems.com,
       menage@google.com, balbir@in.ibm.com, cpufreq@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org, mingo@elte.hu,
       lizf@cn.fujitsu.com, containers@lists.linux-foundation.org
In-Reply-To: <1274261856.5605.10439.camel@twins>
References: <1274232620-23003-1-git-send-email-mike@android.com>
	 <1274232620-23003-4-git-send-email-mike@android.com>
	 <201005191130.42851.trenn@suse.de>  <1274261856.5605.10439.camel@twins>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 19 May 2010 12:27:57 +0200
Message-ID: <1274264877.5605.10541.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-05-19 at 11:37 +0200, Peter Zijlstra wrote:
> On Wed, 2010-05-19 at 11:30 +0200, Thomas Renninger wrote:
> > 
> > This is a cleanup against current linux-2.6 Linus tree.
> >     
> > Having CONFIG_CGROUP_CPUACCT code in kernel/sched.c looks wrong.
> > Move this out to kernel/cgroup_cpuaccount.c
> >     
> > Test compiled with and without CONFIG_CGROUP_CPUACCT set on x86_64.
> 
> Sure, works for me, less code to look at :-)


In file included from /mnt/build/linux-2.6/kernel/sched.c:1908:
/mnt/build/linux-2.6/kernel/sched_fair.c: In function ‘update_curr’:
/mnt/build/linux-2.6/kernel/sched_fair.c:544: error: implicit declaration of function ‘cpuacct_charge’
  CC      kernel/sysctl_binary.o
/mnt/build/linux-2.6/kernel/sched.c: In function ‘account_user_time’:
/mnt/build/linux-2.6/kernel/sched.c:3265: error: implicit declaration of function ‘cpuacct_update_stats’
/mnt/build/linux-2.6/kernel/sched.c:3265: error: ‘CPUACCT_STAT_USER’ undeclared (first use in this function)
/mnt/build/linux-2.6/kernel/sched.c:3265: error: (Each undeclared identifier is reported only once
/mnt/build/linux-2.6/kernel/sched.c:3265: error: for each function it appears in.)
/mnt/build/linux-2.6/kernel/sched.c: In function ‘account_system_time’:
/mnt/build/linux-2.6/kernel/sched.c:3332: error: ‘CPUACCT_STAT_SYSTEM’ undeclared (first use in this function)
make[2]: *** [kernel/sched.o] Error 1
make[2]: *** Waiting for unfinished jobs....
make[1]: *** [kernel/] Error 2
make: *** [sub-make] Error 2

