Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754659Ab2HaRP3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2012 13:15:29 -0400
Received: from mail.candelatech.com ([208.74.158.172]:59292 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754270Ab2HaRP1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2012 13:15:27 -0400
Message-ID: <5040F12E.4020806@candelatech.com>
Date: Fri, 31 Aug 2012 10:15:26 -0700
From: Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: 3.5.2+ (tainted) BUG in uart_put_char
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Saw this on 3.5.2+ kernel on Fedora 17.  Tainting module is related to networking
and is unlikely to be the cause.


Aug 31 09:18:20 localhost kernel: BUG: unable to handle kernel NULL pointer dereference at 0000000000000006
Aug 31 09:18:20 localhost kernel: IP: [<ffffffff8130663e>] uart_put_char+0x5d/0x90
Aug 31 09:18:20 localhost kernel: PGD 0
Aug 31 09:18:20 localhost kernel: Oops: 0002 [#1] PREEMPT SMP
Aug 31 09:18:20 localhost kernel: CPU 0
Aug 31 09:18:20 localhost kernel: Modules linked in: nfs nls_utf8 cifs fscache 8021q garp bridge stp llc nfsd nfs_acl auth_rpcgss w83795 w83627ehf hwmon_vid 
jc42 fuse macvlan wanlink(PO) lockd pktgen sunrpc tpm_bios uinput coretemp kvm_intel gpio_ich kvm microcode pcspkr i2c_i801 e1000e lpc_ich mfd_core i7core_edac 
ioatdma ixgbe igb mdio ptp hwmon pps_core dca edac_core ipv6 mgag200 i2c_algo_bit drm_kms_helper ttm drm i2c_core [last unloaded: nf_nat]
Aug 31 09:18:20 localhost kernel:
Aug 31 09:18:20 localhost kernel: Pid: 19926, comm: kworker/0:2 Tainted: P           O 3.5.2+ #23 Iron Systems Inc. EE2610R/X8ST3
Aug 31 09:18:20 localhost kernel: RIP: 0010:[<ffffffff8130663e>]  [<ffffffff8130663e>] uart_put_char+0x5d/0x90
Aug 31 09:18:20 localhost kernel: RSP: 0018:ffff8802a78efc00  EFLAGS: 00010006
Aug 31 09:18:20 localhost kernel: RAX: 0000000000000286 RBX: ffffffff81c37820 RCX: 0000000000000006
Aug 31 09:18:20 localhost kernel: RDX: 0000000000000000 RSI: 0000000000000061 RDI: ffffffff81c37820
Aug 31 09:18:20 localhost kernel: RBP: ffff8802a78efc20 R08: ffffffff814e02bd R09: ffff8802a78efe70
Aug 31 09:18:20 localhost kernel: R10: ffff88031fc125a0 R11: ffff8802ddba4800 R12: ffff880301e2c000
Aug 31 09:18:20 localhost kernel: R13: 0000000000000001 R14: 0000000000000061 R15: ffff8802a8692000
Aug 31 09:18:20 localhost kernel: FS:  0000000000000000(0000) GS:ffff88031fc00000(0000) knlGS:0000000000000000
Aug 31 09:18:20 localhost kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
Aug 31 09:18:20 localhost kernel: CR2: 0000000000000006 CR3: 0000000001a0b000 CR4: 00000000000007f0
Aug 31 09:18:20 localhost kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Aug 31 09:18:20 localhost kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Aug 31 09:18:20 localhost kernel: Process kworker/0:2 (pid: 19926, threadinfo ffff8802a78ee000, task ffff8802aa270000)
Aug 31 09:18:20 localhost kernel: Stack:
Aug 31 09:18:20 localhost kernel: 0000000000000001 ffff8802a8691000 0000000000000001 0000000000000ff9
Aug 31 09:18:20 localhost kernel: ffff8802a78efc40 ffffffff812ed63f ffff8802a78efc50 ffffff61813065d4
Aug 31 09:18:20 localhost kernel: ffff8802a78efc60 ffffffff812f1434 ffff8802a78efc60 ffff8802ddba4800
Aug 31 09:18:20 localhost kernel: Call Trace:
Aug 31 09:18:20 localhost kernel: [<ffffffff812ed63f>] tty_put_char+0x1f/0x2f
Aug 31 09:18:20 localhost kernel: [<ffffffff812f1434>] do_output_char+0x1a1/0x1b4
Aug 31 09:18:20 localhost kernel: [<ffffffff812f168d>] process_echoes+0x1f4/0x2aa
Aug 31 09:18:20 localhost kernel: [<ffffffff812f200b>] n_tty_receive_buf+0x315/0xdc9
Aug 31 09:18:20 localhost kernel: [<ffffffff814e2160>] ? _raw_spin_unlock_irqrestore+0x3a/0x47
Aug 31 09:18:20 localhost kernel: [<ffffffff812f5a6a>] flush_to_ldisc+0xe3/0x188
Aug 31 09:18:20 localhost kernel: [<ffffffff812f5987>] ? tty_buffer_free_all+0x5f/0x5f
Aug 31 09:18:20 localhost kernel: [<ffffffff8106fca2>] process_one_work+0x1a6/0x278
Aug 31 09:18:20 localhost kernel: [<ffffffff81071d08>] worker_thread+0x136/0x255
Aug 31 09:18:20 localhost kernel: [<ffffffff81071bd2>] ? manage_workers+0x190/0x190
Aug 31 09:18:20 localhost kernel: [<ffffffff81075581>] kthread+0x84/0x8c
Aug 31 09:18:20 localhost kernel: [<ffffffff814e8264>] kernel_thread_helper+0x4/0x10
Aug 31 09:18:20 localhost kernel: [<ffffffff810754fd>] ? __init_kthread_worker+0x37/0x37
Aug 31 09:18:20 localhost kernel: [<ffffffff814e8260>] ? gs_change+0x13/0x13
Aug 31 09:18:20 localhost kernel: Code: 00 41 8b 8c 24 70 01 00 00 89 ca f7 d2 41 03 94 24 74 01 00 00 81 e2 ff 0f 00 00 74 2a 49 8b 94 24 68 01 00 00 48 63 c9 
41 b5 01 <44> 88 34 0a 41 8b 94 24 70 01 00 00 ff c2 81 e2 ff 0f 00 00 41
Aug 31 09:18:20 localhost kernel: RIP  [<ffffffff8130663e>] uart_put_char+0x5d/0x90
Aug 31 09:18:20 localhost kernel: RSP <ffff8802a78efc00>
Aug 31 09:18:20 localhost kernel: CR2: 0000000000000006



(gdb) l *(uart_put_char+0x5d/0x90)
0xffffffff813065e1 is in uart_put_char (/home/greearb/git/linux-3.5.dev.y/drivers/tty/serial/serial_core.c:484).
479		spin_unlock_irqrestore(&port->lock, flags);
480		return ret;
481	}
482	
483	static int uart_put_char(struct tty_struct *tty, unsigned char ch)
484	{
485		struct uart_state *state = tty->driver_data;
486	
487		return __uart_put_char(state->uart_port, &state->xmit, ch);
488	}
(gdb) l *(uart_put_char+0x5d)
0xffffffff8130663e is in uart_put_char (/home/greearb/git/linux-3.5.dev.y/drivers/tty/serial/serial_core.c:475).
470		if (!circ->buf)
471			return 0;
472	
473		spin_lock_irqsave(&port->lock, flags);
474		if (uart_circ_chars_free(circ) != 0) {
475			circ->buf[circ->head] = c;
476			circ->head = (circ->head + 1) & (UART_XMIT_SIZE - 1);
477			ret = 1;
478		}
479		spin_unlock_irqrestore(&port->lock, flags);
(gdb) l *(uart_put_char+0x90)
0xffffffff81306671 is in uart_set_termios (/home/greearb/git/linux-3.5.dev.y/drivers/tty/serial/serial_core.c:1195).
1190			uport->ops->set_ldisc(uport, tty->termios->c_line);
1191	}
1192	
1193	static void uart_set_termios(struct tty_struct *tty,
1194							struct ktermios *old_termios)
1195	{
1196		struct uart_state *state = tty->driver_data;
1197		unsigned long flags;
1198		unsigned int cflag = tty->termios->c_cflag;
1199	
(gdb)

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

