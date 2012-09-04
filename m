Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757332Ab2IDO47 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 10:56:59 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:54105 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757157Ab2IDO45 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 10:56:57 -0400
Date: Tue, 4 Sep 2012 07:48:13 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Artem Bityutskiy <dedekind1@gmail.com>
Cc: Subodh Nijsure <snijsure@grid-net.com>, linux-mtd@lists.infradead.org,
        Linux Kernel Maling List <linux-kernel@vger.kernel.org>
Subject: Re: RCU warning during UBI file system mount
Message-ID: <20120904144813.GC2593@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <5042EC5D.1010207@grid-net.com>
 <1346744796.12610.6.camel@sauron.fi.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1346744796.12610.6.camel@sauron.fi.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12090414-6078-0000-0000-00000F060738
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 04, 2012 at 10:46:36AM +0300, Artem Bityutskiy wrote:
> Let's CC LKML and Paul.
> 
>  
> On Sat, 2012-09-01 at 22:19 -0700, Subodh Nijsure wrote:
> > Hello,
> > 
> > I am running 3.6-rc4 kernel on my MX28 based board and every time I 
> > mount UBI file system I see following warning.
> > Anybody else seen this errors, particularly those running it on MXS 
> > platform?
> > 
> > I haven't debugged RCU warnings before any clues as to what is the 
> > source of this warning is, should I be looking at 
> > start_dma_without_bch_irq() code? Would appreciate any pointers in 
> > fixing this...

RCU is upset because what it believes to be a non-idle task is telling
RCU that it is entering the idle loop.

Does the MX28 kernel have any unusual idle features?  (This is a subarch
of ARM, correct?)

							Thanx, Paul

> > [    4.280000] WARNING: at /opt/git/kernel-mainline/kernel/rcutiny.c:75 
> > rcu_idle_enter_common.clone.7+0x90/0xac()
> > [    4.280000] Current pid: 1 comm: swapper / Idle pid: 0 comm: swapper
> > [    4.280000] Modules linked in:
> > [    4.280000] [<c0014eec>] (unwind_backtrace+0x0/0x130) from 
> > [<c001dd94>] (warn_slowpath_common+0x4c/0x64)
> > [    4.280000] [<c001dd94>] (warn_slowpath_common+0x4c/0x64) from 
> > [<c001de40>] (warn_slowpath_fmt+0x30/0x40)
> > [    4.280000] [<c001de40>] (warn_slowpath_fmt+0x30/0x40) from 
> > [<c0061618>] (rcu_idle_enter_common.clone.7+0x90/0xac)
> > [    4.280000] [<c0061618>] (rcu_idle_enter_common.clone.7+0x90/0xac) 
> > from [<c0061670>] (rcu_irq_exit+0x3c/0x78)
> > [    4.280000] [<c0061670>] (rcu_irq_exit+0x3c/0x78) from [<c000fe90>] 
> > (handle_IRQ+0x34/0x84)
> > [    4.280000] [<c000fe90>] (handle_IRQ+0x34/0x84) from [<c000ec34>] 
> > (__irq_svc+0x34/0x58)
> > [    4.280000] [<c000ec34>] (__irq_svc+0x34/0x58) from [<c0394c4c>] 
> > (schedule_timeout+0xdc/0x16c)
> > [    4.280000] [<c0394c4c>] (schedule_timeout+0xdc/0x16c) from 
> > [<c0395f34>] (wait_for_common+0xb4/0x160)
> > [    4.280000] [<c0395f34>] (wait_for_common+0xb4/0x160) from 
> > [<c02579d0>] (start_dma_without_bch_irq+0x6c/0xa8)
> > [    4.280000] [<c02579d0>] (start_dma_without_bch_irq+0x6c/0xa8) from 
> > [<c0258660>] (gpmi_send_command+0x120/0x154)
> > [    4.280000] [<c0258660>] (gpmi_send_command+0x120/0x154) from 
> > [<c0256fb4>] (gpmi_cmd_ctrl+0x44/0x6c)
> > [    4.280000] [<c0256fb4>] (gpmi_cmd_ctrl+0x44/0x6c) from [<c024f8e0>] 
> > (nand_command_lp+0xe8/0x270)
> > [    4.280000] [<c024f8e0>] (nand_command_lp+0xe8/0x270) from 
> > [<c0251e00>] (nand_do_read_ops+0x124/0x444)
> > [    4.280000] [<c0251e00>] (nand_do_read_ops+0x124/0x444) from 
> > [<c0252558>] (nand_read+0x54/0x78)
> > [    4.280000] [<c0252558>] (nand_read+0x54/0x78) from [<c02499a4>] 
> > (part_read+0x48/0x80)
> > [    4.280000] [<c02499a4>] (part_read+0x48/0x80) from [<c0246910>] 
> > (mtd_read+0x88/0xb4)
> > [    4.280000] [<c0246910>] (mtd_read+0x88/0xb4) from [<c026b188>] 
> > (ubi_io_read+0xb0/0x3e8)
> > [    4.280000] [<c026b188>] (ubi_io_read+0xb0/0x3e8) from [<c026740c>] 
> > (ubi_eba_read_leb+0x198/0x4bc)
> > [    4.280000] [<c026740c>] (ubi_eba_read_leb+0x198/0x4bc) from 
> > [<c0266800>] (ubi_leb_read+0xf4/0x16c)
> > [    4.280000] [<c0266800>] (ubi_leb_read+0xf4/0x16c) from [<c0155550>] 
> > (ubifs_leb_read+0x24/0x88)
> > [    4.280000] [<c0155550>] (ubifs_leb_read+0x24/0x88) from [<c01572f8>] 
> > (ubifs_read_node+0xa8/0x2e4)
> > [    4.280000] [<c01572f8>] (ubifs_read_node+0xa8/0x2e4) from 
> > [<c0153c50>] (ubifs_read_sb_node+0x54/0x78)
> > [    4.280000] [<c0153c50>] (ubifs_read_sb_node+0x54/0x78) from 
> > [<c0154940>] (ubifs_read_superblock+0xc8c/0x133c)
> > [    4.280000] [<c0154940>] (ubifs_read_superblock+0xc8c/0x133c) from 
> > [<c01520ac>] (ubifs_mount+0x73c/0x1bc0)
> > [    4.280000] [<c01520ac>] (ubifs_mount+0x73c/0x1bc0) from [<c00a49ec>] 
> > (mount_fs+0x44/0x184)
> > [    4.280000] [<c00a49ec>] (mount_fs+0x44/0x184) from [<c00baf90>] 
> > (vfs_kern_mount+0x4c/0xc0)
> > [    4.280000] [<c00baf90>] (vfs_kern_mount+0x4c/0xc0) from [<c00bb1a0>] 
> > (do_kern_mount+0x34/0xd0)
> > [    4.280000] [<c00bb1a0>] (do_kern_mount+0x34/0xd0) from [<c00bc93c>] 
> > (do_mount+0x15c/0x73c)
> > [    4.280000] [<c00bc93c>] (do_mount+0x15c/0x73c) from [<c00bcfa0>] 
> > (sys_mount+0x84/0xc4)
> > [    4.280000] [<c00bcfa0>] (sys_mount+0x84/0xc4) from [<c04e4a04>] 
> > (do_mount_root+0x24/0xb0)
> > [    4.280000] [<c04e4a04>] (do_mount_root+0x24/0xb0) from [<c04e4b78>] 
> > (mount_block_root+0xe8/0x214)
> > [    4.280000] [<c04e4b78>] (mount_block_root+0xe8/0x214) from 
> > [<c04e4e28>] (prepare_namespace+0x8c/0x180)
> > [    4.280000] [<c04e4e28>] (prepare_namespace+0x8c/0x180) from 
> > [<c04e4894>] (kernel_init+0x16c/0x1b4)
> > [    4.280000] [<c04e4894>] (kernel_init+0x16c/0x1b4) from [<c000ff70>] 
> > (kernel_thread_exit+0x0/0x8)
> > [    4.280000] ---[ end trace 4d36b722759fdc4f ]---
> > [    4.950000] UBIFS DBG (pid 58): ubifs_bg_thread: background thread 
> > "ubifs_bgt0_0" started, PID 58
> > 
> > -Subodh
> > 
> > ______________________________________________________
> > Linux MTD discussion mailing list
> > http://lists.infradead.org/mailman/listinfo/linux-mtd/
> 
> -- 
> Best Regards,
> Artem Bityutskiy


