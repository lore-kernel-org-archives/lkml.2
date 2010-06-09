Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758331Ab0FIVbU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 17:31:20 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:53154 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752125Ab0FIVbS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 17:31:18 -0400
Subject: Re: [ANNOUNCE] 2.6.33.5-rt23
From: Will Schmidt <will_schmidt@vnet.ibm.com>
Reply-To: will_schmidt@vnet.ibm.com
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
       rt-users <linux-rt-users@vger.kernel.org>,
       John Stultz <johnstul@us.ibm.com>, Nick Piggin <npiggin@suse.de>
In-Reply-To: <alpine.LFD.2.00.1006091837410.2933@localhost.localdomain>
References: <alpine.LFD.2.00.1002241740410.4245@localhost.localdomain>
	 <alpine.LFD.2.00.1002262041020.4245@localhost.localdomain>
	 <alpine.LFD.2.00.1003121124120.22855@localhost.localdomain>
	 <alpine.LFD.2.00.1003211158130.3147@localhost.localdomain>
	 <alpine.LFD.2.00.1004071619490.32352@localhost.localdomain>
	 <alpine.LFD.2.00.1004271744280.2951@localhost.localdomain>
	 <alpine.LFD.2.00.1004301156590.2951@localhost.localdomain>
	 <alpine.LFD.2.00.1005022109150.25342@localhost.localdomain>
	 <alpine.LFD.2.00.1006091837410.2933@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Organization: IBM
Date: Wed, 09 Jun 2010 16:31:14 -0500
Message-ID: <1276119074.15867.311.camel@lexx>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-06-09 at 18:44 +0200, Thomas Gleixner wrote:
> We are pleased to announce the next update to our new preempt-rt
> series.
> 
<snip>

> Changes from 2.6.33.4-rt21 to 2.6.33.5-rt22:
> 
>   ef4afcc: Merge stable/linux-2.6.33.y into rt/2.6.33
> 
> Changes from 2.6.33.5-rt22 to 2.6.33.5-rt23:
> 
>   ab774e8: drivers/hwmon/coretemp.c: get TjMax value from MSR
>   e8bfcca: drivers/hwmon/coretemp.c: detect the thermal sensors by CPUID
>   a06a867: dcache: Prevent d_genocide() from decrementing d_count more than once
>   bdeadaf: nfs: Avoid igrab deadlock.
>   6976846: dcache: Fix select_parent dentry traversal locking
>   1f0f6ec: powerpc: chrp/time.c fix preprocessor conditional

I'm still on 2.6.33.5-rt22 on powerpc, and have run into a couple
"sleeping function called from invalid context..." BUGs.   The first was
during system boot, second during a 'make'.

relevant code paths don't seem to have changed between -rt22 and -rt23,
so I think still valid.. :-)  

This is on a POWER7 system, which may have opened up some timing
windows, wrt previous runs on POWER6 systems.


BUG: sleeping function called from invalid context at
kernel/rtmutex.c:684
pcnt: 1 0 in_atomic(): 1, irqs_disabled(): 1, pid: 3209, name: ip
Call Trace:
[c000000078cf28e0] [c000000000015550] .show_stack+0xd8/0x218
(unreliable)
[c000000078cf29c0] [c0000000006a99c8] .dump_stack+0x28/0x3c
[c000000078cf2a40] [c00000000006cea8] .__might_sleep+0x134/0x15c
[c000000078cf2ae0] [c0000000006a2f78] .rt_spin_lock+0x4c/0x9c
[c000000078cf2b70] [c0000000001799e8] ._slab_irq_disable+0x70/0xd8
[c000000078cf2c20] [c00000000017d1b4] .kmem_cache_alloc_node_notrace
+0x78/0x234
[c000000078cf2cf0] [c000000000131a04] .irq_to_desc_alloc_node+0xdc/0x2b8
[c000000078cf2db0] [c00000000000f238] .irq_setup_virq+0x44/0xe4
[c000000078cf2e50] [c00000000000f3f8] .irq_create_mapping+0x120/0x188
[c000000078cf2ef0] [c00000000002edfc] .ibmebus_request_irq+0x50/0xac
[c000000078cf2fa0] [c0000000004f3bd0] .ehea_up+0x314/0x69c
[c000000078cf30b0] [c0000000004f3fc8] .ehea_open+0x70/0x128
[c000000078cf3150] [c0000000005e504c] .dev_open+0x120/0x198
[c000000078cf31f0] [c0000000005e3ee8] .dev_change_flags+0x11c/0x21c
[c000000078cf32a0] [c0000000005f10ec] .do_setlink+0x2e0/0x400
[c000000078cf3380] [c0000000005f23a0] .rtnl_newlink+0x380/0x5b8
[c000000078cf3580] [c0000000005f1fd4] .rtnetlink_rcv_msg+0x258/0x2a4
[c000000078cf3630] [c000000000604094] .netlink_rcv_skb+0x84/0x120
[c000000078cf36d0] [c0000000005f1d58] .rtnetlink_rcv+0x38/0x5c
[c000000078cf3760] [c000000000603ba0] .netlink_unicast+0x31c/0x3fc
[c000000078cf3840] [c000000000604838] .netlink_sendmsg+0x2c8/0x30c
[c000000078cf3930] [c0000000005c8bdc] .sock_sendmsg+0xbc/0xfc
[c000000078cf3b10] [c0000000005c92fc] .SyS_sendmsg+0x20c/0x2a4
[c000000078cf3d50] [c0000000005c7f6c] .SyS_socketcall+0x238/0x2b0
[c000000078cf3e30] [c00000000000852c] syscall_exit+0x0/0x40


BUG: sleeping function called from invalid context at kernel/rtmutex.c:684
pcnt: 0 0 in_atomic(): 0, irqs_disabled(): 1, pid: 4760, name: make
Call Trace:
[c0000000792978b0] [c000000000015550] .show_stack+0xd8/0x218 (unreliable)
[c000000079297990] [c0000000006a99c8] .dump_stack+0x28/0x3c
[c000000079297a10] [c00000000006cea8] .__might_sleep+0x134/0x15c
[c000000079297ab0] [c0000000006a2f78] .rt_spin_lock+0x4c/0x9c
[c000000079297b40] [c0000000000a1ff0] .get_signal_to_deliver+0xcc/0x4ec
[c000000079297c50] [c000000000018604] .do_signal_pending.clone.0+0x6c/0x2e0
[c000000079297d90] [c0000000000188b0] .do_signal+0x38/0x74
[c000000079297e30] [c000000000008b40] user_work+0x24/0x28




> 
> Bulk of changes comes from stable tree. The -rt related changes are
> mostly fixes for the vfs fallout the rest are fixlets all over the
> place and hardware enablement.
> 
> Download locations:
>    
>    http://www.kernel.org/pub/linux/kernel/projects/rt/
> 
> Git release branch:
>    git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git rt/2.6.33
> 
> Gitweb:
>    http://git.kernel.org/?p=linux/kernel/git/tip/linux-2.6-tip.git;a=shortlog;h=rt/2.6.33
> 
> Information on the RT patch can be found at:
> 
>    http://rt.wiki.kernel.org/index.php/Main_Page
> 
> To build the 2.6.33.5-rt23 tree, the following patches should be
> applied:
> 
>    http://www.kernel.org/pub/linux/kernel/v2.6/linux-2.6.33.5.tar.bz2
>    http://www.kernel.org/pub/linux/kernel/projects/rt/patch-2.6.33.5-rt23.bz2
> 
> Enjoy !
> 
>       tglx
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rt-users" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


