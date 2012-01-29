Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753695Ab2A2Suf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jan 2012 13:50:35 -0500
Received: from vt.electrainfo.com ([207.136.236.70]:38546 "EHLO
	black.transpect.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1753634Ab2A2Sue (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jan 2012 13:50:34 -0500
X-Greylist: delayed 356 seconds by postgrey-1.27 at vger.kernel.org; Sun, 29 Jan 2012 13:50:34 EST
Date: Sun, 29 Jan 2012 13:44:37 -0500
From: Whit Blauvelt <whit@transpect.com>
To: linux-kernel@vger.kernel.org
Subject: WARNING: at kernel/timer.c:1011 del_timer_sync+0x56/0x60() - 3.2.2 -
 tulip?
Message-ID: <20120129184437.GA10176@black.transpect.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.2 kernel. Just in case it's of interest:

Jan 29 11:15:31 whit kernel: [50599.304905] ------------[ cut here ]------------
Jan 29 11:15:31 whit kernel: [50599.304924] WARNING: at kernel/timer.c:1011 del_timer_sync+0x56/0x60()
Jan 29 11:15:31 whit kernel: [50599.304929] Hardware name: SK22V10
Jan 29 11:15:31 whit kernel: [50599.304933] Modules linked in: joydev st lp parport_pc binfmt_misc nfsd lockd nfs_acl auth_rpcgss sunrpc exportfs xt_limit ipt_REJECT xt_multiport ipt_LOG xt_tcpudp dm_crypt bridge xt_state stp iptable_filter ip_
Jan 29 11:15:31 whit kernel: crc_itu_t sata_via [last unloaded: ppa]
Jan 29 11:15:31 whit kernel: [50599.305073] Pid: 0, comm: swapper/1 Not tainted 3.2.2-black01 #1
Jan 29 11:15:31 whit kernel: [50599.305078] Call Trace:
Jan 29 11:15:31 whit kernel: [50599.305083]  <IRQ>  [<ffffffff81063d8f>] warn_slowpath_common+0x7f/0xc0
Jan 29 11:15:31 whit kernel: [50599.305105]  [<ffffffff81063dea>] warn_slowpath_null+0x1a/0x20
Jan 29 11:15:31 whit kernel: [50599.305111]  [<ffffffff81074406>] del_timer_sync+0x56/0x60
Jan 29 11:15:31 whit kernel: [50599.305130]  [<ffffffffa002ee79>] pnic2_lnk_change+0xe9/0x698 [tulip]
Jan 29 11:15:31 whit kernel: [50599.305145]  [<ffffffffa00283a9>] tulip_interrupt+0x1e9/0x1010 [tulip]
Jan 29 11:15:31 whit kernel: [50599.305159]  [<ffffffff810d4d04>] handle_irq_event_percpu+0x54/0x200  
Jan 29 11:15:31 whit kernel: [50599.305169]  [<ffffffff810d4f04>] handle_irq_event+0x54/0x80
Jan 29 11:15:31 whit kernel: [50599.305178]  [<ffffffff810d7eca>] handle_fasteoi_irq+0x6a/0x100
Jan 29 11:15:31 whit kernel: [50599.305190]  [<ffffffff81015232>] handle_irq+0x22/0x40
Jan 29 11:15:31 whit kernel: [50599.305199]  [<ffffffff815e9a1d>] do_IRQ+0x5d/0xe0
Jan 29 11:15:31 whit kernel: [50599.305210]  [<ffffffff815df0ee>] common_interrupt+0x6e/0x6e
Jan 29 11:15:31 whit kernel: [50599.305215]  <EOI>  [<ffffffff8103b21b>] ? native_safe_halt+0xb/0x10  
Jan 29 11:15:31 whit kernel: [50599.305233]  [<ffffffff8101b9c1>] default_idle+0x41/0xe0
Jan 29 11:15:31 whit kernel: [50599.305241]  [<ffffffff8101babd>] amd_e400_idle+0x5d/0x120
Jan 29 11:15:31 whit kernel: [50599.305250]  [<ffffffff81012276>] cpu_idle+0xd6/0x110     
Jan 29 11:15:31 whit kernel: [50599.305259]  [<ffffffff815d70e8>] start_secondary+0x1e0/0x1e7
Jan 29 11:15:31 whit kernel: [50599.305267] ---[ end trace 525e0a5d40ea44de ]---

Seeing "tulip" there, I'm guessing this relates to this old NIC:

  LNE100TX [Linksys EtherFast 10/100]

Whit
