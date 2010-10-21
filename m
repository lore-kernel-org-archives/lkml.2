Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755492Ab0JUATb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 20:19:31 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:43621 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750935Ab0JUATa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 20:19:30 -0400
Date: Wed, 20 Oct 2010 17:19:28 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2 v2] rcu,cleanup: move synchronize_sched_expedited()
 out of sched.c
Message-ID: <20101021001928.GA24855@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <4CBE886A.7010509@cn.fujitsu.com>
 <20101020191512.GG2386@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101020191512.GG2386@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 20, 2010 at 12:15:12PM -0700, Paul E. McKenney wrote:
> On Wed, Oct 20, 2010 at 02:12:58PM +0800, Lai Jiangshan wrote:
> > The first version of synchronize_sched_expedited() use the migration code
> > of the scheduler code, so it have to be implemented in sched.c
> > 
> > but now, the synchronize_sched_expedited() does not use such code,
> > it is time to move it out of sched.c.
> > 
> > Different rcu implementation' synchronize_sched_expedited() are also
> > different. so we move synchronize_sched_expedited() to kernel/rcutree_plugin.h
> > or include/linux/rcutiny.h instead of kerenl/rcupdate.c
> 
> Queued, thank you!!!

Hello again, Lai,

I hit the following build error during testing:

kernel/built-in.o: In function `.synchronize_rcu_expedited':
(.text+0x787d8): undefined reference to `.synchronize_sched_expedited'
kernel/built-in.o:(.toc1+0x1fe0): undefined reference to `synchronize_sched_expedited'

This build uses defconfig with the following applied:

CONFIG_RCU_TRACE=y
CONFIG_RCU_FAST_NO_HZ=y
CONFIG_NO_HZ=y
CONFIG_RCU_CPU_STALL_DETECTOR=y
CONFIG_SMP=y
CONFIG_RCU_FANOUT=8
CONFIG_NR_CPUS=8
CONFIG_RCU_FANOUT_EXACT=n
CONFIG_HOTPLUG_CPU=y
CONFIG_PREEMPT_NONE=y
CONFIG_PREEMPT_VOLUNTARY=n
CONFIG_PREEMPT=n
CONFIG_TREE_RCU=y
CONFIG_TREE_PREEMPT_RCU=n
CONFIG_RCU_TORTURE_TEST=m
CONFIG_MODULE_UNLOAD=y
CONFIG_SYSFS_DEPRECATED_V2=y
CONFIG_IKCONFIG=y
CONFIG_IKCONFIG_PROC=y

Thoughts?

							Thanx, Paul
