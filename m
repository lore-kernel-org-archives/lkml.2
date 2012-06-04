Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755612Ab2FDHsJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 03:48:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50710 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751400Ab2FDHsH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 03:48:07 -0400
Date: Mon, 4 Jun 2012 10:48:03 +0300
From: Gleb Natapov <gleb@redhat.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: automount hangs during boot somewhere in rcu_barrier.
Message-ID: <20120604074803.GA23670@redhat.com>
References: <20120603113236.GW2311@redhat.com>
 <20120604031549.GE2357@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120604031549.GE2357@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 03, 2012 at 08:15:49PM -0700, Paul E. McKenney wrote:
> On Sun, Jun 03, 2012 at 02:32:36PM +0300, Gleb Natapov wrote:
> > Hello Paul,
> > 
> > I see something strange with 3.5.0-rc1 kernel. During boot automount
> > process hangs for a couple of minutes and when boot finally completes
> > I find this in dmesg:
> > 
> > [  240.676287] INFO: task automount:3000 blocked for more than 120 seconds.
> > [  240.676393] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> > [  240.676495] automount       D ffff88027fc12040     0  3000   2994 0x00000000
> > [  240.676581]  ffff880273e7dcb8 0000000000000046 ffff880273e7dc70 ffff880273e7dfd8
> > [  240.676681]  0000000000004000 0000000000012040 ffffffff814e3410 ffff8802732a4100
> > [  240.676781]  ffff880272470a20 ffff8802732f5001 0000000000000009 ffff880273e7de18
> > [  240.676880] Call Trace:
> > [  240.676962]  [<ffffffff81186bae>] ? security_inode_permission+0x1e/0x20
> > [  240.677072]  [<ffffffff8114ad90>] ? fsnotify_clear_marks_by_inode+0x93/0xd4
> > [  240.677169]  [<ffffffff8105ae20>] ? sub_preempt_count+0x38/0x4b
> > [  240.677260]  [<ffffffff8137e738>] schedule+0x64/0x66
> > [  240.677348]  [<ffffffff8137cad4>] schedule_timeout+0x2b/0x28b
> > [  240.677435]  [<ffffffff8137dcdd>] ? wait_for_common+0xc0/0x146
> > [  240.677523]  [<ffffffff8105ae20>] ? sub_preempt_count+0x38/0x4b
> > [  240.677610]  [<ffffffff8137dce5>] wait_for_common+0xc8/0x146
> > [  240.677699]  [<ffffffff8109a1cd>] ? synchronize_sched_expedited_cpu_stop+0x10/0x10
> > [  240.677804]  [<ffffffff8105c963>] ? try_to_wake_up+0x24f/0x24f
> > [  240.677892]  [<ffffffff8137dd80>] wait_for_completion+0x1d/0x1f
> > [  240.677979]  [<ffffffff8109a6b4>] _rcu_barrier+0x204/0x21f
> > [  240.678085]  [<ffffffff8109c560>] ? kfree_call_rcu+0x1c/0x1c
> > [  240.678178]  [<ffffffff8109a48b>] ? rcu_implicit_dynticks_qs+0x191/0x191
> > [  240.678272]  [<ffffffff8109a6eb>] rcu_barrier+0x1c/0x1e
> > [  240.678359]  [<ffffffff81119060>] deactivate_locked_super+0x37/0x57
> > [  240.678447]  [<ffffffff81119cae>] deactivate_super+0x3f/0x43
> > [  240.678535]  [<ffffffff8112fdd9>] mntput_no_expire+0x132/0x13a
> > [  240.678622]  [<ffffffff81130c15>] sys_umount+0x308/0x33a
> > [  240.678708]  [<ffffffff81380092>] system_call_fastpath+0x16/0x1b
> > 
> > When I am actually trying to access automounted NFS directory nfs mount
> > also hangs in D state in rcu_barrier (I see this behaviour in 3.4 and it
> > looks like 3.3 kernel too).
> 
> So this did not happen in 3.2?
> 
Do not remember. Need to check.

> > My kernel config is attached.
> 
> Hmmm...  Could you please try disabling CONFIG_RCU_FAST_NO_HZ?  If that
> makes the problem go away, I have some patches 3.6-targeted patches
> for you.
Will report back.

--
			Gleb.
