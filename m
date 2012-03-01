Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754799Ab2CAXyu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 18:54:50 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:64941 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753199Ab2CAXys convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 18:54:48 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of rengels@optionscity.com designates 10.52.179.102 as permitted sender) smtp.mail=rengels@optionscity.com
MIME-Version: 1.0
Date: Thu, 1 Mar 2012 17:54:47 -0600
Message-ID: <CA+q+rD1+5D8_Cw5=DYeb1QNM6L+xMdUpCoZDPPtnXVsHZfOzSg@mail.gmail.com>
Subject: kernel-rt 3.0.9 panics/bugs
From: Robert Engels <rengels@optionscity.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I am posting this message because various kernel message told me to
'please report this trace'. The messages/logs are below.

For a bit of background, we use EL5 (scientific linux compiled), with
their 'MRG Realtime' patch set in production.

It is very reliable.

We have begun testing with EL6 with the 3.0.9 kernel and patch set,
and it has been a no-go. Same exact Java code (with some realtime
enhancements). The kernel locks up, hangs, panics.

When it does work, the context switch times with 3.0 seem almost too
good to be true - half the 2.6 times - so we'd like to use it.

I also built a 3.0.22 kernel and applied the 3.0.22.rt37 patch set and
had similar problems.

I would like to be CC'd on any responses to this message. Thanks!

Here are various kernel messages under 3.0.9... with rtdebug, with
kdump used to get the crash information (last entry).

--- This is the a crash (not using debug kernel) ---

Feb 27 10:30:17 localhost kernel: ------------[ cut here ]------------
Feb 27 10:30:17 localhost kernel: WARNING: at fs/hugetlbfs/inode.c:936
hugetlb_file_setup+0x88/0x21b()
Feb 27 10:30:17 localhost kernel: Hardware name: PowerEdge R610
Feb 27 10:30:17 localhost kernel: Using mlock ulimits for SHM_HUGETLB deprecated
Feb 27 10:30:17 localhost kernel: Modules linked in: sunrpc fcoe
libfcoe libfc scsi_transport_fc scsi_tgt 8021q garp stp ipv6 ses
enclosure sg dcdbas pcsp
kr serio_raw iTCO_wdt iTCO_vendor_support i7core_edac edac_core ext4
mbcache jbd2 crc16 sr_mod cdrom sd_mod crc_t10dif pata_acpi
ata_generic ata_piix liba
ta megaraid_sas ehci_hcd uhci_hcd igb dca bnx2 button dm_mirror
dm_region_hash dm_log dm_mod cxgb3i cxgb3 mdio libiscsi_tcp libiscsi
qla4xxx scsi_transpor
t_iscsi scsi_mod [last unloaded: scsi_wait_scan]
Feb 27 10:30:17 localhost kernel: Pid: 4524, comm: java Not tainted
2.6.33.9-rt31.79.el6rt.x86_64 #1
Feb 27 10:30:17 localhost kernel: Call Trace:
Feb 27 10:30:17 localhost kernel: [<ffffffff81041bfc>]
warn_slowpath_common+0x85/0x9d
Feb 27 10:30:17 localhost kernel: [<ffffffff81041cb7>]
warn_slowpath_fmt+0x46/0x48
Feb 27 10:30:17 localhost kernel: [<ffffffff810d807a>] ? user_shm_lock+0x83/0x8e
Feb 27 10:30:17 localhost kernel: [<ffffffff81158008>]
hugetlb_file_setup+0x88/0x21b
Feb 27 10:30:17 localhost kernel: [<ffffffff811b36fa>] ? sprintf+0x40/0x42
Feb 27 10:30:17 localhost kernel: [<ffffffff81162d13>] newseg+0x11d/0x27b
Feb 27 10:30:17 localhost kernel: [<ffffffff8115f156>] ipcget+0x63/0x1ab
Feb 27 10:30:17 localhost kernel: [<ffffffff8106f185>] ? rt_up_read+0x1a/0x1c
Feb 27 10:30:17 localhost kernel: [<ffffffff81162be2>] sys_shmget+0x59/0x5d
Feb 27 10:30:17 localhost kernel: [<ffffffff81162bf6>] ? newseg+0x0/0x27b
Feb 27 10:30:17 localhost kernel: [<ffffffff81162be6>] ? shm_security+0x0/0x10
Feb 27 10:30:17 localhost kernel: [<ffffffff81162771>] ?
shm_more_checks+0x0/0x18
Feb 27 10:30:17 localhost kernel: [<ffffffff81002c9b>]
system_call_fastpath+0x16/0x1b
Feb 27 10:30:17 localhost kernel: ---[ end trace 023f822deda2cb95 ]---

--- This is startup using the debug kernel ---

Feb 27 11:24:07 localhost kernel: BUG: using smp_processor_id() in
preemptible [00000000] code: java/4251
Feb 27 11:24:07 localhost kernel: caller is netif_rx+0x5a/0x68
Feb 27 11:24:07 localhost kernel: Pid: 4251, comm: java Tainted: G
   W  ---------------    2.6.33.9-rt31.79.el6rt.x86_64.rtdebug #1
Feb 27 11:24:07 localhost kernel: Call Trace:
Feb 27 11:24:07 localhost kernel: [<ffffffff811cf752>]
debug_smp_processor_id+0xc2/0xdc
Feb 27 11:24:07 localhost kernel: [<ffffffff812e149c>] netif_rx+0x5a/0x68
Feb 27 11:24:07 localhost kernel: [<ffffffff812e23f4>] netif_rx_ni+0x13/0x57
Feb 27 11:24:07 localhost kernel: [<ffffffff8126e30a>] loopback_xmit+0x52/0xb7
Feb 27 11:24:07 localhost kernel: [<ffffffff812e293b>]
dev_hard_start_xmit+0x246/0x305
Feb 27 11:24:07 localhost kernel: [<ffffffff812e2eab>]
dev_queue_xmit+0x399/0x495
Feb 27 11:24:07 localhost kernel: [<ffffffff812e2c87>] ?
dev_queue_xmit+0x175/0x495
Feb 27 11:24:07 localhost kernel: [<ffffffff813032fb>] ?
rcu_read_unlock+0x26/0x28
Feb 27 11:24:07 localhost kernel: [<ffffffff81303553>] ? nf_hook_slow+0xcf/0xe0
Feb 27 11:24:07 localhost kernel: [<ffffffff813147c6>] ?
ip_finish_output+0x0/0x6f
Feb 27 11:24:07 localhost kernel: [<ffffffff8131477d>]
ip_finish_output2+0x260/0x2a9
Feb 27 11:24:07 localhost kernel: [<ffffffff81314833>]
ip_finish_output+0x6d/0x6f
Feb 27 11:24:07 localhost kernel: [<ffffffff81314901>] ip_output+0xcc/0xd5
Feb 27 11:24:07 localhost kernel: [<ffffffff81313cd3>] ip_local_out+0x25/0x29
Feb 27 11:24:07 localhost kernel: [<ffffffff8131432a>] ip_queue_xmit+0x30e/0x36e
Feb 27 11:24:07 localhost kernel: [<ffffffff811023f1>] ?
kmem_cache_alloc_node_notrace+0xd5/0xfe
Feb 27 11:24:07 localhost kernel: [<ffffffff812d9e22>] ? __alloc_skb+0x75/0x165
Feb 27 11:24:07 localhost kernel: [<ffffffff813268c3>]
tcp_transmit_skb+0x70a/0x748
Feb 27 11:24:07 localhost kernel: [<ffffffff81328427>] tcp_send_ack+0xfc/0x100
Feb 27 11:24:07 localhost kernel: [<ffffffff813228c6>]
__tcp_ack_snd_check+0x6a/0x82
Feb 27 11:24:07 localhost kernel: [<ffffffff81324efa>]
tcp_rcv_established+0x502/0x682
Feb 27 11:24:07 localhost kernel: [<ffffffff8132c3c8>] tcp_v4_do_rcv+0x19d/0x347
Feb 27 11:24:07 localhost kernel: [<ffffffff8131a123>]
tcp_prequeue_process+0x64/0x75
Feb 27 11:24:07 localhost kernel: [<ffffffff8131cdc6>] tcp_recvmsg+0x538/0x996
Feb 27 11:24:07 localhost kernel: [<ffffffff812d39bf>]
sock_common_recvmsg+0x3c/0x4d
Feb 27 11:24:07 localhost kernel: [<ffffffff812d0d75>] __sock_recvmsg+0x72/0x7d
Feb 27 11:24:07 localhost kernel: [<ffffffff812d0f0d>] sock_recvmsg+0xab/0xc4
Feb 27 11:24:07 localhost kernel: [<ffffffff8110daf7>] ? rcu_read_lock+0x0/0x3a
Feb 27 11:24:07 localhost kernel: [<ffffffff812d10a4>] ?
sockfd_lookup_light+0x20/0x58
Feb 27 11:24:07 localhost kernel: [<ffffffff812d282e>] sys_recvfrom+0xe9/0x155
Feb 27 11:24:07 localhost kernel: [<ffffffff811152ef>] ? path_put+0x22/0x26
Feb 27 11:24:07 localhost kernel: [<ffffffff810730a7>] ?
trace_hardirqs_on_caller+0x1f/0x14b
Feb 27 11:24:07 localhost kernel: [<ffffffff8109caf8>] ?
audit_syscall_entry+0x11e/0x14a
Feb 27 11:24:07 localhost kernel: [<ffffffff81380d15>] ?
trace_hardirqs_on_thunk+0x3a/0x3f
Feb 27 11:24:07 localhost kernel: [<ffffffff81002cdb>]
system_call_fastpath+0x16/0x1b

Feb 27 11:29:55 localhost kernel: ============================================
Feb 27 11:29:55 localhost kernel: [ BUG: circular locking deadlock detected! ]
Feb 27 11:29:55 localhost kernel: --------------------------------------------
Feb 27 11:29:55 localhost kernel: console_check/2212 is deadlocking
current task console_init/2214
Feb 27 11:29:55 localhost kernel:
Feb 27 11:29:55 localhost kernel:
Feb 27 11:29:55 localhost kernel: 1) console_init/2214 is trying to
acquire this lock:
Feb 27 11:29:55 localhost kernel: [ffffffff8178b3e0] {kernel_sem.lock}
Feb 27 11:29:55 localhost kernel: .. ->owner: ffff880bceb84901
Feb 27 11:29:55 localhost kernel: .. held by:     console_check: 2212
[ffff880bceb84900, 118]
Feb 27 11:29:55 localhost kernel:
Feb 27 11:29:55 localhost kernel: 2) console_check/2212 is blocked on this lock:
Feb 27 11:29:55 localhost kernel: [ffffffff81752aa0] {console_mutex.lock}
Feb 27 11:29:55 localhost kernel: .. ->owner: ffff880bcc459081
Feb 27 11:29:55 localhost kernel: .. held by:      console_init: 2214
[ffff880bcc459080, 118]
Feb 27 11:29:55 localhost kernel: INFO: lockdep is turned off.
Feb 27 11:29:55 localhost kernel: INFO: lockdep is turned off.
Feb 27 11:29:55 localhost kernel:
Feb 27 11:29:55 localhost kernel: console_check/2212's [blocked] stackdump:
Feb 27 11:29:55 localhost kernel:
Feb 27 11:29:55 localhost kernel: ffff880bc989dab8 ffffffff8178b3e0
ffff880bcc459080 ffffffff8103bbaa
Feb 27 11:29:55 localhost kernel: ffff880bc989dac8 ffff880bceb84900
ffffffff81752aa0 ffff880bc989db18
Feb 27 11:29:55 localhost kernel: 0000000000000000 ffff880bceb84900
ffff880bc989da88 ffffffff8137f81e
Feb 27 11:29:55 localhost kernel: Call Trace:
Feb 27 11:29:55 localhost kernel: [<ffffffff8137f81e>] schedule+0x14/0x25
Feb 27 11:29:55 localhost kernel: [<ffffffff8138038f>]
__rt_mutex_slowlock+0xa0/0xe3
Feb 27 11:29:55 localhost kernel: [<ffffffff81380963>]
rt_mutex_slowlock+0x181/0x23f
Feb 27 11:29:55 localhost kernel: [<ffffffff81380a92>] rt_mutex_lock+0x35/0x39
Feb 27 11:29:55 localhost kernel: [<ffffffff8138122d>] _mutex_lock+0x3c/0x43
Feb 27 11:29:55 localhost kernel: [<ffffffff81045909>] ?
acquire_console_mutex+0x30/0x4f
Feb 27 11:29:55 localhost kernel: [<ffffffff81045909>]
acquire_console_mutex+0x30/0x4f
Feb 27 11:29:55 localhost kernel: [<ffffffff81045a09>] console_device+0x18/0x58
Feb 27 11:29:55 localhost kernel: [<ffffffff8123d306>] tty_open+0x121/0x51f
Feb 27 11:29:55 localhost kernel: [<ffffffff8110fb93>] chrdev_open+0x12c/0x14d
Feb 27 11:29:55 localhost kernel: [<ffffffff81189ca4>] ?
selinux_dentry_open+0xfa/0x103
Feb 27 11:29:55 localhost kernel: [<ffffffff8110fa67>] ? chrdev_open+0x0/0x14d
Feb 27 11:29:55 localhost kernel: [<ffffffff8110b0be>] __dentry_open+0x219/0x357
Feb 27 11:29:55 localhost kernel: [<ffffffff81182bf0>] ?
security_inode_permission+0x21/0x23
Feb 27 11:29:55 localhost kernel: [<ffffffff8110b2ce>]
nameidata_to_filp+0x3f/0x50
Feb 27 11:29:55 localhost kernel: [<ffffffff81118d0d>] do_filp_open+0x57e/0xae9
Feb 27 11:29:55 localhost kernel: [<ffffffff81074f13>] ?
put_lock_stats+0x23/0x2e
Feb 27 11:29:55 localhost kernel: [<ffffffff81074fd4>] ?
lock_release_holdtime+0xb6/0xbb
Feb 27 11:29:55 localhost kernel: [<ffffffff81381b05>] ?
_raw_spin_unlock_irqrestore+0x3f/0x69
Feb 27 11:29:55 localhost kernel: [<ffffffff81038afa>] ? get_parent_ip+0x11/0x42
Feb 27 11:29:55 localhost kernel: [<ffffffff81381b11>] ?
_raw_spin_unlock_irqrestore+0x4b/0x69
Feb 27 11:29:55 localhost kernel: [<ffffffff813810f5>] ?
rt_spin_unlock+0x4d/0x51
Feb 27 11:29:55 localhost kernel: [<ffffffff8110ada4>] do_sys_open+0x63/0x118
Feb 27 11:29:55 localhost kernel: [<ffffffff8110ae8c>] sys_open+0x20/0x22
Feb 27 11:29:55 localhost kernel: [<ffffffff81002cdb>]
system_call_fastpath+0x16/0x1b

Feb 27 11:29:55 localhost kernel: console_init/2214's [current] stackdump:
Feb 27 11:29:55 localhost kernel:
Feb 27 11:29:55 localhost kernel: Pid: 2214, comm: console_init Not
tainted 2.6.33.9-rt31.79.el6rt.x86_64.rtdebug #1
Feb 27 11:29:55 localhost kernel: Call Trace:
Feb 27 11:29:55 localhost kernel: [<ffffffff8107c12b>]
debug_rt_mutex_print_deadlock+0x17f/0x1a8
Feb 27 11:29:55 localhost kernel: [<ffffffff8107bfdb>] ?
debug_rt_mutex_print_deadlock+0x2f/0x1a8
Feb 27 11:29:55 localhost kernel: [<ffffffff81384c89>] ?
sub_preempt_count+0xa3/0xb7
Feb 27 11:29:55 localhost kernel: [<ffffffff81380383>]
__rt_mutex_slowlock+0x94/0xe3
Feb 27 11:29:55 localhost kernel: [<ffffffff8138081e>] ?
rt_mutex_slowlock+0x3c/0x23f
Feb 27 11:29:55 localhost kernel: [<ffffffff81380963>]
rt_mutex_slowlock+0x181/0x23f
Feb 27 11:29:55 localhost kernel: [<ffffffff81380a92>] rt_mutex_lock+0x35/0x39
Feb 27 11:29:55 localhost kernel: [<ffffffff8138122d>] _mutex_lock+0x3c/0x43
Feb 27 11:29:55 localhost kernel: [<ffffffff813809f0>] ?
rt_mutex_slowlock+0x20e/0x23f
Feb 27 11:29:55 localhost kernel: [<ffffffff81381b2a>] ?
_raw_spin_unlock_irqrestore+0x64/0x69
Feb 27 11:29:55 localhost kernel: [<ffffffff813809f0>]
rt_mutex_slowlock+0x20e/0x23f
Feb 27 11:29:55 localhost kernel: [<ffffffff81380a92>] rt_mutex_lock+0x35/0x39
Feb 27 11:29:55 localhost kernel: [<ffffffff8138122d>] _mutex_lock+0x3c/0x43
Feb 27 11:29:55 localhost kernel: [<ffffffff81045909>] ?
acquire_console_mutex+0x30/0x4f
Feb 27 11:29:55 localhost kernel: [<ffffffff81045909>]
acquire_console_mutex+0x30/0x4f
Feb 27 11:29:55 localhost kernel: [<ffffffff8124cd22>] con_open+0x21/0xcd
Feb 27 11:29:55 localhost kernel: [<ffffffff8123d567>] tty_open+0x382/0x51f
Feb 27 11:29:55 localhost kernel: [<ffffffff8110fb93>] chrdev_open+0x12c/0x14d
Feb 27 11:29:55 localhost kernel: [<ffffffff81189ca4>] ?
selinux_dentry_open+0xfa/0x103
Feb 27 11:29:55 localhost kernel: [<ffffffff8110fa67>] ? chrdev_open+0x0/0x14d
Feb 27 11:29:55 localhost kernel: [<ffffffff8110b0be>] __dentry_open+0x219/0x357
Feb 27 11:29:55 localhost kernel: [<ffffffff81182bf0>] ?
security_inode_permission+0x21/0x23
Feb 27 11:29:55 localhost kernel: [<ffffffff8110b2ce>]
nameidata_to_filp+0x3f/0x50
Feb 27 11:29:55 localhost kernel: [<ffffffff81118d0d>] do_filp_open+0x57e/0xae9
Feb 27 11:29:55 localhost kernel: [<ffffffff81074f13>] ?
put_lock_stats+0x23/0x2e
Feb 27 11:29:55 localhost kernel: [<ffffffff81074fd4>] ?
lock_release_holdtime+0xb6/0xbb
Feb 27 11:29:55 localhost kernel: [<ffffffff81381b05>] ?
_raw_spin_unlock_irqrestore+0x3f/0x69
Feb 27 11:29:55 localhost kernel: [<ffffffff81038afa>] ? get_parent_ip+0x11/0x42
Feb 27 11:29:55 localhost kernel: [<ffffffff81381b11>] ?
_raw_spin_unlock_irqrestore+0x4b/0x69
Feb 27 11:29:55 localhost kernel: [<ffffffff813810f5>] ?
rt_spin_unlock+0x4d/0x51
Feb 27 11:29:55 localhost kernel: [<ffffffff8110ada4>] do_sys_open+0x63/0x118
Feb 27 11:29:55 localhost kernel: [<ffffffff8110ae8c>] sys_open+0x20/0x22
Feb 27 11:29:55 localhost kernel: [<ffffffff81002cdb>]
system_call_fastpath+0x16/0x1b
Feb 27 11:29:55 localhost kernel: INFO: lockdep is turned off.
Feb 27 11:29:55 localhost kernel: [ turning off deadlock
detection.Please report this trace. ]

--- This is the crash information ---

Here is the output using crash...

     KERNEL: /usr/lib/debug/lib/modules/2.6.33.9-rt31.79.el6rt.x86_64.rtdebug/vmlinux
    DUMPFILE: vmcore  [PARTIAL DUMP]
        CPUS: 12
        DATE: Mon Feb 27 11:24:39 2012
      UPTIME: 00:08:24
LOAD AVERAGE: 0.81, 0.29, 0.14
       TASKS: 757
    NODENAME: localhost.localdomain
     RELEASE: 2.6.33.9-rt31.79.el6rt.x86_64.rtdebug
     VERSION: #1 SMP PREEMPT RT Wed Jan 11 13:37:12 CET 2012
     MACHINE: x86_64  (3457 Mhz)
      MEMORY: 48 GB
       PANIC: "kernel BUG at kernel/rtmutex.c:458!"
         PID: 4376
     COMMAND: "java"
        TASK: ffff880bc99cc9c0  [THREAD_INFO: ffff880bc99ca000]
         CPU: 4
       STATE: TASK_RUNNING (PANIC)

--

Robert Engels
OptionsCity Software Inc.
Chicago, IL
