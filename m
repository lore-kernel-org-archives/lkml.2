Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754110Ab1FCLT3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 07:19:29 -0400
Received: from mail001.aei.ca ([206.123.6.130]:52210 "EHLO mail001.aei.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752631Ab1FCLT1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 07:19:27 -0400
From: Ed Tomlinson <edt@aei.ca>
To: linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [BUG] oops with 3.0-rc1+ involving bluetooth
Date: Fri, 3 Jun 2011 07:19:23 -0400
User-Agent: KMail/1.13.7 (Linux/2.6.39-crc+; KDE/4.6.3; x86_64; ; )
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201106030719.24032.edt@aei.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I've been having fun with bluetooth with the .38 and .39 kernels.  Decided to try 3.0-rc to see
if it would be 3 for 3.  It was.  I booted with my magic mouse connected via an asus doggle supporting
2.1+EDR.  When I started X it was not working so I powered it off and on.  During the process
it crashed.  I got the following oops off my serial console (followed by a few more before it died).

[  145.440232] ------------[ cut here ]------------
[  145.445053] WARNING: at kernel/softirq.c:98 __local_bh_disable+0x121/0x160()
[  145.452309] Hardware name: System Product Name
[  145.452311] Modules linked in: hidp loop acpi_pad video pci_slot container fan tun sit tunnel4 ipv6 bnep rfcomm snd_seq_dummy sndx
[  145.452351] Pid: 1417, comm: irq/19-ehci_hcd Not tainted 3.0.0-rc1-crc+ #307
[  145.452354] Call Trace:
[  145.452356]  <IRQ>  [<ffffffff8104adff>] warn_slowpath_common+0x7f/0xc0
[  145.452363]  [<ffffffff8155fcd6>] ? _raw_write_lock_bh+0x16/0x50
[  145.452365]  [<ffffffff8104ae5a>] warn_slowpath_null+0x1a/0x20
[  145.452367]  [<ffffffff81052121>] __local_bh_disable+0x121/0x160
[  145.452370]  [<ffffffff81052177>] local_bh_disable+0x17/0x20
[  145.452372]  [<ffffffff8155fcd6>] _raw_write_lock_bh+0x16/0x50
[  145.452389]  [<ffffffffa01febe2>] l2cap_chan_create+0x52/0xa0 [bluetooth]
[  145.452399]  [<ffffffffa01ff36d>] l2cap_connect_req+0x30d/0x570 [bluetooth]
[  145.452402]  [<ffffffff8105ba81>] ? lock_timer_base+0x61/0xa0
[  145.452405]  [<ffffffff81280b3e>] ? do_raw_spin_lock+0xde/0x1c0
[  145.452409]  [<ffffffff8108a685>] ? __lock_acquire+0xb65/0x16a0
[  145.452418]  [<ffffffffa01fffd0>] l2cap_bredr_sig_cmd+0x1d0/0xce0 [bluetooth]
[  145.452428]  [<ffffffffa0202f14>] ? l2cap_recv_frame+0xd4/0xc60 [bluetooth]
[  145.452437]  [<ffffffffa0202f14>] ? l2cap_recv_frame+0xd4/0xc60 [bluetooth]
[  145.452447]  [<ffffffffa02032df>] l2cap_recv_frame+0x49f/0xc60 [bluetooth]
[  145.452455]  [<ffffffffa01f8553>] ? hci_send_to_sock+0x53/0x220 [bluetooth]
[  145.452464]  [<ffffffffa01e62d3>] ? hci_rx_task+0x283/0x470 [bluetooth]
[  145.452472]  [<ffffffffa01e62d3>] ? hci_rx_task+0x283/0x470 [bluetooth]
[  145.452475]  [<ffffffff812807d3>] ? do_raw_read_unlock+0x33/0x60
[  145.452484]  [<ffffffffa0203d7b>] l2cap_recv_acldata+0x2db/0x410 [bluetooth]
[  145.452493]  [<ffffffffa01eb562>] ? hci_conn_enter_active_mode+0x42/0x100 [bluetooth]
[  145.452501]  [<ffffffffa01e6346>] hci_rx_task+0x2f6/0x470 [bluetooth]
[  145.452504]  [<ffffffff81280b3e>] ? do_raw_spin_lock+0xde/0x1c0
[  145.452506]  [<ffffffff81053265>] tasklet_action+0x175/0x180
[  145.452510]  [<ffffffff810a96fd>] ? irq_forced_thread_fn+0x3d/0x50
[  145.452512]  [<ffffffff81052bc4>] __do_softirq+0x194/0x300
[  145.452515]  [<ffffffff810a96fd>] ? irq_forced_thread_fn+0x3d/0x50
[  145.452518]  [<ffffffff81568b8c>] call_softirq+0x1c/0x30
[  145.452519]  <EOI>  [<ffffffff81003e7d>] ? do_softirq+0x8d/0x130
[  145.452484]  [<ffffffffa0203d7b>] l2cap_recv_acldata+0x2db/0x410 [bluetooth]                                                                                    
[  145.452493]  [<ffffffffa01eb562>] ? hci_conn_enter_active_mode+0x42/0x100 [bluetooth]                                                                           
[  145.452501]  [<ffffffffa01e6346>] hci_rx_task+0x2f6/0x470 [bluetooth]                                                                                           
[  145.452504]  [<ffffffff81280b3e>] ? do_raw_spin_lock+0xde/0x1c0                                                                                                 
[  145.452506]  [<ffffffff81053265>] tasklet_action+0x175/0x180                                                                                                    
[  145.452510]  [<ffffffff810a96fd>] ? irq_forced_thread_fn+0x3d/0x50                                                                                              
[  145.452512]  [<ffffffff81052bc4>] __do_softirq+0x194/0x300                                                                                                      
[  145.452515]  [<ffffffff810a96fd>] ? irq_forced_thread_fn+0x3d/0x50                                                                                              
[  145.452518]  [<ffffffff81568b8c>] call_softirq+0x1c/0x30                                                                                                        
[  145.452519]  <EOI>  [<ffffffff81003e7d>] ? do_softirq+0x8d/0x130                                                                                                
[  145.452524]  [<ffffffff810a96fd>] ? irq_forced_thread_fn+0x3d/0x50                                                                                              
[  145.452527]  [<ffffffff810524e3>] local_bh_enable+0x113/0x1d0                                                                                                   
[  145.452529]  [<ffffffff810a96fd>] irq_forced_thread_fn+0x3d/0x50                                                                                                
[  145.452532]  [<ffffffff810a95df>] irq_thread+0x1ef/0x200                                                                                                        
[  145.452534]  [<ffffffff810a96c0>] ? exit_irq_thread+0x90/0x90                                                                                                   
[  145.452537]  [<ffffffff810a93f0>] ? irq_finalize_oneshot+0x160/0x160                                                                                            
[  145.452540]  [<ffffffff81070c36>] kthread+0xb6/0xc0                                                                                                             
[  145.452542]  [<ffffffff8108987d>] ? trace_hardirqs_on_caller+0x14d/0x190                                                                                        
[  145.452545]  [<ffffffff81568a94>] kernel_thread_helper+0x4/0x10                                                                                                 
[  145.452548]  [<ffffffff81560a04>] ? retint_restore_args+0xe/0xe                                                                                                 
[  145.452550]  [<ffffffff81070b80>] ? __init_kthread_worker+0x70/0x70                                                                                             
[  145.452553]  [<ffffffff81568a90>] ? gs_change+0xb/0xb                                                                                                           
[  145.452555] ---[ end trace 7f7128e5e2ec7e44 ]---                                                                                                                
[  145.452776] huh, entered softirq 6 TASKLET ffffffff810530f0 preempt_count 00000101, exited with ffffff01?                                                       
[  145.806887] huh, entered softirq 6 TASKLET ffffffff810530f0 preempt_count 00000101, exited with ffffff01?                                                       
[  145.834627] input: Apple Wireless Mouse as /devices/pci0000:00/0000:00:13.2/usb2/2-4/2-4.4/2-4.4:1.0/bluetooth/hci0/hci0:21/input7                              
[  145.847736] magicmouse 0005:05AC:030D.0004: input,hidraw3: BLUETOOTH HID v0.84 Mouse [Apple Wireless Mouse] on 00:02:72:20:20:1D                                
[  145.898290] magicmouse 0005:05AC:030D.0004: unable to request touch data (2)                                                                                    
[  145.917995] magicmouse: probe of 0005:05AC:030D.0004 failed with error 2                                                                                        
[  195.253991] ------------[ cut here ]------------ 

I have threaded IRQs enabled (same as in .39) and an at commit 1fa7b6a29c61358cc2ca6f64cef4aa0e1a7ca74c
from June 2nd. 

Ideas?
Ed
