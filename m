Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932915Ab1FPUXY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 16:23:24 -0400
Received: from smtp3-g21.free.fr ([212.27.42.3]:57108 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758203Ab1FPUXU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 16:23:20 -0400
Message-ID: <4DFA662D.5030302@free.fr>
Date: Thu, 16 Jun 2011 22:23:09 +0200
From: f6bvp <f6bvp@free.fr>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110501 Mandriva/3.1.10-0.1mdv2010.2 (2010.2) Thunderbird/3.1.10
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Jarek Poplawski <jarkao2@gmail.com>,
        Linux Netdev List <netdev@vger.kernel.org>,
        Ralf Baechle <ralf@linux-mips.org>, linux-hams@vger.kernel.org
Subject: [AX25] inconsistent lock state
References: <4B2CD772.1030106@upmc.fr> <4B2D1025.1020106@gmail.com> <4B2E6729.1090102@free.fr> <4B507FAA.8010007@free.fr> <20100115203654.GA3084@del.dom.local>
In-Reply-To: <20100115203654.GA3084@del.dom.local>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

When unpluging ethernet connector a few seconds I observed the following 
kernel message :


Jun 16 12:03:25 f6bvp-9 kernel: e1000e: eth1 NIC Link is Down
Jun 16 12:03:25 f6bvp-9 ifplugd(eth1)[1541]: Link beat lost.
Jun 16 12:03:31 f6bvp-9 ifplugd(eth1)[1541]: Executing 
'/etc/ifplugd/ifplugd.action eth1 down'.
Jun 16 12:03:31 f6bvp-9 avahi-daemon[2197]: Withdrawing address record 
for 192.168.0.66 on eth1.
Jun 16 12:03:31 f6bvp-9 avahi-daemon[2197]: Leaving mDNS multicast group 
on interface eth1.IPv4 with address 192.168.0.66.
Jun 16 12:03:31 f6bvp-9 avahi-daemon[2197]: Interface eth1.IPv4 no 
longer relevant for mDNS.
Jun 16 12:03:31 f6bvp-9 avahi-daemon[2197]: Withdrawing address record 
for fe80::21c:c0ff:fe36:723e on eth1.
Jun 16 12:03:31 f6bvp-9 vnstatd[2022]: SIGHUP received, flushing data to 
disk and reloading config.
Jun 16 12:03:31 f6bvp-9 ifplugd(eth1)[1541]: client: Rechargement de la 
configuration de vnstatdÂ : #033[65G[#033[1;32m  OK  #033[0;39m]#015
Jun 16 12:03:31 f6bvp-9 ifplugd(eth1)[1541]: Program executed successfully.
Jun 16 12:03:31 f6bvp-9 kernel: ADDRCONF(NETDEV_UP): eth1: link is not ready
Jun 16 12:03:34 f6bvp-9 kernel:
Jun 16 12:03:34 f6bvp-9 kernel: =================================
Jun 16 12:03:34 f6bvp-9 kernel: [ INFO: inconsistent lock state ]
Jun 16 12:03:34 f6bvp-9 kernel: 2.6.39.1 #3
Jun 16 12:03:34 f6bvp-9 kernel: ---------------------------------
Jun 16 12:03:34 f6bvp-9 kernel: inconsistent {IN-SOFTIRQ-R} -> 
{SOFTIRQ-ON-W} usage.
Jun 16 12:03:34 f6bvp-9 kernel: ax25ipd/2813 [HC0[0]:SC0[0]:HE1:SE1] takes:
Jun 16 12:03:34 f6bvp-9 kernel: (disc_data_lock){+++?.-}, at: 
[<ffffffffa018552b>] mkiss_close+0x1b/0x90 [mkiss]
Jun 16 12:03:34 f6bvp-9 kernel: {IN-SOFTIRQ-R} state was registered at:
Jun 16 12:03:34 f6bvp-9 kernel:  [<ffffffff8109484e>] 
__lock_acquire+0x57e/0x14c0
Jun 16 12:03:34 f6bvp-9 kernel:  [<ffffffff81095836>] 
lock_acquire+0xa6/0x160
Jun 16 12:03:34 f6bvp-9 kernel:  [<ffffffff813f64f4>] 
_raw_read_lock+0x34/0x50
Jun 16 12:03:34 f6bvp-9 kernel:  [<ffffffffa01850ed>] 
mkiss_get+0x1d/0x50 [mkiss]
Jun 16 12:03:34 f6bvp-9 kernel:  [<ffffffffa018517e>] 
mkiss_write_wakeup+0x1e/0xb0 [mkiss]
Jun 16 12:03:34 f6bvp-9 kernel:  [<ffffffff8129457e>] tty_wakeup+0x6e/0x80
Jun 16 12:03:34 f6bvp-9 kernel:  [<ffffffff8129f243>] pty_write+0x73/0x80
Jun 16 12:03:34 f6bvp-9 kernel:  [<ffffffffa0185d2e>] 
ax_xmit+0x27e/0x5e0 [mkiss]
Jun 16 12:03:34 f6bvp-9 kernel:  [<ffffffff81339dac>] 
dev_hard_start_xmit+0x34c/0x6f0
Jun 16 12:03:34 f6bvp-9 kernel:  [<ffffffff81358b4d>] 
sch_direct_xmit+0xdd/0x260
Jun 16 12:03:34 f6bvp-9 kernel:  [<ffffffff8133cc8f>] 
dev_queue_xmit+0x1af/0x8a0
Jun 16 12:03:34 f6bvp-9 kernel:  [<ffffffffa0325072>] 
ax25_queue_xmit+0x52/0x60 [ax25]
Jun 16 12:03:34 f6bvp-9 kernel:  [<ffffffffa032516f>] 
ax25_transmit_buffer+0xef/0x130 [ax25]
Jun 16 12:03:34 f6bvp-9 kernel:  [<ffffffffa0325238>] 
ax25_send_iframe+0x88/0xe0 [ax25]
Jun 16 12:03:34 f6bvp-9 kernel:  [<ffffffffa032536e>] 
ax25_kick+0xde/0x220 [ax25]
Jun 16 12:03:34 f6bvp-9 kernel:  [<ffffffffa0326715>] 
ax25_std_frame_in+0x65/0x920 [ax25]
Jun 16 12:03:34 f6bvp-9 kernel:  [<ffffffffa03241da>] 
ax25_rcv+0x3aa/0x9a0 [ax25]
Jun 16 12:03:34 f6bvp-9 kernel:  [<ffffffffa032486f>] 
ax25_kiss_rcv+0x9f/0xb0 [ax25]
Jun 16 12:03:34 f6bvp-9 kernel:  [<ffffffff8133bba5>] 
__netif_receive_skb+0x205/0x6d0
Jun 16 12:03:34 f6bvp-9 kernel:  [<ffffffff8133c144>] 
process_backlog+0xd4/0x1e0
Jun 16 12:03:34 f6bvp-9 kernel:  [<ffffffff8133c995>] 
net_rx_action+0x125/0x270
Jun 16 12:03:34 f6bvp-9 kernel:  [<ffffffff810618f1>] 
__do_softirq+0xc1/0x210
Jun 16 12:03:34 f6bvp-9 kernel:  [<ffffffff813ffa9c>] call_softirq+0x1c/0x30
Jun 16 12:03:34 f6bvp-9 kernel:  [<ffffffff810627db>] 
local_bh_enable_ip+0xeb/0xf0
Jun 16 12:03:34 f6bvp-9 kernel:  [<ffffffff813f6594>] 
_raw_spin_unlock_bh+0x34/0x40
Jun 16 12:03:34 f6bvp-9 kernel:  [<ffffffffa0186522>] 
mkiss_receive_buf+0x2e2/0x3dc [mkiss]
Jun 16 12:03:34 f6bvp-9 kernel:  [<ffffffff8129e122>] 
flush_to_ldisc+0x1b2/0x1d0
Jun 16 12:03:34 f6bvp-9 kernel:  [<ffffffff810762c0>] 
process_one_work+0x1a0/0x510
Jun 16 12:03:34 f6bvp-9 kernel:  [<ffffffff81078ba2>] 
worker_thread+0x172/0x400
Jun 16 12:03:34 f6bvp-9 kernel:  [<ffffffff8107d816>] kthread+0xb6/0xc0
Jun 16 12:03:34 f6bvp-9 kernel:  [<ffffffff813ff9a4>] 
kernel_thread_helper+0x4/0x10
Jun 16 12:03:34 f6bvp-9 kernel: irq event stamp: 76635461
Jun 16 12:03:34 f6bvp-9 kernel: hardirqs last  enabled at (76635461): 
[<ffffffff813f6620>] _raw_spin_unlock_irqrestore+0x40/0x70
Jun 16 12:03:34 f6bvp-9 kernel: hardirqs last disabled at (76635460): 
[<ffffffff813f5f1e>] _raw_spin_lock_irqsave+0x2e/0x70
Jun 16 12:03:34 f6bvp-9 kernel: softirqs last  enabled at (76635394): 
[<ffffffff81329337>] sk_common_release+0x67/0xd0
Jun 16 12:03:34 f6bvp-9 kernel: softirqs last disabled at (76635392): 
[<ffffffff813f60f6>] _raw_write_lock_bh+0x16/0x50
Jun 16 12:03:34 f6bvp-9 kernel:
Jun 16 12:03:34 f6bvp-9 kernel: other info that might help us debug this:
Jun 16 12:03:34 f6bvp-9 kernel: 2 locks held by ax25ipd/2813:
Jun 16 12:03:34 f6bvp-9 kernel: #0:  (big_tty_mutex){+.+.+.}, at: 
[<ffffffff813f67ce>] tty_lock+0x2e/0x4f
Jun 16 12:03:34 f6bvp-9 kernel: #1:  (&tty->ldisc_mutex){+.+.+.}, at: 
[<ffffffff8129d597>] tty_ldisc_hangup+0xe7/0x250
Jun 16 12:03:34 f6bvp-9 kernel:
Jun 16 12:03:34 f6bvp-9 kernel: stack backtrace:
Jun 16 12:03:34 f6bvp-9 kernel: Pid: 2813, comm: ax25ipd Not tainted 
2.6.39.1 #3
Jun 16 12:03:34 f6bvp-9 kernel: Call Trace:
Jun 16 12:03:34 f6bvp-9 kernel: [<ffffffff81092dc0>] 
print_usage_bug+0x170/0x180
Jun 16 12:03:34 f6bvp-9 kernel: [<ffffffff81093a81>] mark_lock+0x211/0x3f0
Jun 16 12:03:34 f6bvp-9 kernel: [<ffffffff810948c4>] 
__lock_acquire+0x5f4/0x14c0
Jun 16 12:03:34 f6bvp-9 kernel: [<ffffffff81093ccb>] ? 
mark_held_locks+0x6b/0xa0
Jun 16 12:03:34 f6bvp-9 kernel: [<ffffffff813f65d0>] ? 
_raw_spin_unlock_irq+0x30/0x40
Jun 16 12:03:34 f6bvp-9 kernel: [<ffffffff81093fcd>] ? 
trace_hardirqs_on_caller+0x13d/0x180
Jun 16 12:03:34 f6bvp-9 kernel: [<ffffffff81095836>] lock_acquire+0xa6/0x160
Jun 16 12:03:34 f6bvp-9 kernel: [<ffffffffa018552b>] ? 
mkiss_close+0x1b/0x90 [mkiss]
Jun 16 12:03:34 f6bvp-9 kernel: [<ffffffff81093ccb>] ? 
mark_held_locks+0x6b/0xa0
Jun 16 12:03:34 f6bvp-9 kernel: [<ffffffff813f6221>] 
_raw_write_lock+0x31/0x40
Jun 16 12:03:34 f6bvp-9 kernel: [<ffffffffa018552b>] ? 
mkiss_close+0x1b/0x90 [mkiss]
Jun 16 12:03:34 f6bvp-9 kernel: [<ffffffff8113775e>] ? 
kmem_cache_alloc_trace+0x7e/0x140
Jun 16 12:03:34 f6bvp-9 kernel: [<ffffffffa018552b>] 
mkiss_close+0x1b/0x90 [mkiss]
Jun 16 12:03:34 f6bvp-9 kernel: [<ffffffff8129c84b>] 
tty_ldisc_close+0x4b/0x70
Jun 16 12:03:34 f6bvp-9 kernel: [<ffffffff8129ce90>] 
tty_ldisc_reinit+0x40/0x80
Jun 16 12:03:34 f6bvp-9 kernel: [<ffffffff8129d5b4>] 
tty_ldisc_hangup+0x104/0x250
Jun 16 12:03:34 f6bvp-9 kernel: [<ffffffff8129588c>] 
__tty_hangup+0x15c/0x3e0
Jun 16 12:03:34 f6bvp-9 kernel: [<ffffffff8109401d>] ? 
trace_hardirqs_on+0xd/0x10
Jun 16 12:03:34 f6bvp-9 kernel: [<ffffffff81295b3e>] tty_vhangup+0xe/0x10
Jun 16 12:03:34 f6bvp-9 kernel: [<ffffffff8129f37e>] pty_close+0x10e/0x160
Jun 16 12:03:34 f6bvp-9 kernel: [<ffffffff81295ceb>] tty_release+0x16b/0x640
Jun 16 12:03:34 f6bvp-9 kernel: [<ffffffff8113920a>] ? 
kmem_cache_free+0x11a/0x160
Jun 16 12:03:34 f6bvp-9 kernel: [<ffffffff81142f9a>] fput+0xea/0x230
Jun 16 12:03:34 f6bvp-9 kernel: [<ffffffff8113ee03>] filp_close+0x63/0x90
Jun 16 12:03:34 f6bvp-9 kernel: [<ffffffff8105dab1>] 
put_files_struct+0x171/0x190
Jun 16 12:03:34 f6bvp-9 kernel: [<ffffffff8105d978>] ? 
put_files_struct+0x38/0x190
Jun 16 12:03:34 f6bvp-9 kernel: [<ffffffff8105db22>] exit_files+0x52/0x60
Jun 16 12:03:34 f6bvp-9 kernel: [<ffffffff8105deb9>] do_exit+0x189/0x860
Jun 16 12:03:34 f6bvp-9 kernel: [<ffffffff81142cc0>] ? fget+0xd0/0xd0
Jun 16 12:03:34 f6bvp-9 kernel: [<ffffffff813f69b9>] ? 
retint_swapgs+0x13/0x1b
Jun 16 12:03:34 f6bvp-9 kernel: [<ffffffff8105e5eb>] do_group_exit+0x5b/0xd0
Jun 16 12:03:34 f6bvp-9 kernel: [<ffffffff8105e677>] 
sys_exit_group+0x17/0x20
Jun 16 12:03:34 f6bvp-9 kernel: [<ffffffff813fe812>] 
system_call_fastpath+0x16/0x1b

Kernel is 2.6.39.1

Is there something wrong in AX25 code or (more unlikely) is this 
operation not permitted ?
Thanks for help.

Bernard Pidoux


