Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753255Ab2L0QOt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2012 11:14:49 -0500
Received: from mout.gmx.net ([212.227.15.19]:54220 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752999Ab2L0QOq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2012 11:14:46 -0500
X-Authenticated: #5108953
X-Provags-ID: V01U2FsdGVkX18twpE+Y1MtVkfXGEdnr50W/pRVmB+LnY89fhAqjy
	B+QrDWTMyIHwqC
Message-ID: <50DC73F3.6020605@gmx.de>
Date: Thu, 27 Dec 2012 17:14:43 +0100
From: =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: UML process hangs
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sometimes my user mode linux image just hangs.

Attaching a GDB to the "linux" process (which itself occupies 100% of a CPU core), gives :

...
Loaded symbols for /lib/libnss_files.so.2
0x0805f24c in from_irq_stack (nested=0) at arch/um/kernel/irq.c:462
462             current->stack = to;
(gdb) cont
Continuing.

Program received signal SIGSEGV, Segmentation fault.
0x0805f24c in from_irq_stack (nested=0) at arch/um/kernel/irq.c:462
462             current->stack = to;
(gdb) bt
#0  0x0805f24c in from_irq_stack (nested=0) at arch/um/kernel/irq.c:462
#1  0x0807176d in hard_handler (sig=<optimized out>, si=0x8402b0c <cpu0_irqstack+2828>, p=0x8402b8c <cpu0_irqstack+2956>)
    at arch/um/os-Linux/signal.c:175
#2  <signal handler called>
#3  get_symbol_pos (addr=134759253, symbolsize=0x387ba170, offset=0x387ba16c) at kernel/kallsyms.c:219
#4  0x080b732e in kallsyms_lookup (addr=134759253, symbolsize=0x387ba170, offset=0x387ba16c, modname=0x387ba168, namebuf=0x387ba1a1 "")
    at kernel/kallsyms.c:295
#5  0x080b73c7 in __sprint_symbol (buffer=0x387ba1a1 "", address=134759253, symbol_offset=0, add_offset=1) at kernel/kallsyms.c:354
#6  0x080b757a in sprint_symbol (buffer=0x387ba1a1 "", address=134759253) at kernel/kallsyms.c:385
#7  0x0826a207 in symbol_string (buf=0x84cefc3 <textbuf.24807+35> "---\n", 
    end=0x84cf380 <cont> "Netdevice 0 (72:ef:3d:5d:d3:db) : xes 6 to 9)e...No, enabling workaround", ptr=<optimized out>, ext=83 'S', spec=...)
    at lib/vsprintf.c:545
#8  0x0826ac1d in pointer (fmt=<optimized out>, buf=0x84cefc3 <textbuf.24807+35> "---\n", end=<optimized out>, ptr=0x8084355 <local_bh_enable+69>, 
    spec=...) at lib/vsprintf.c:1062
#9  0x0826a948 in vsnprintf (buf=0x84cefa0 <textbuf.24807> "\001\064WARNING: at kernel/softirq.c:160 ---\n", size=992, fmt=0x83b3066 "pS()\n", 
    args=0x387ba3a0 "UC\b\b") at lib/vsprintf.c:1450
#10 0x0826af37 in vscnprintf (buf=0x84cefa0 <textbuf.24807> "\001\064WARNING: at kernel/softirq.c:160 ---\n", size=992, 
    fmt=0x83b3051 "\001\064WARNING: at %s:%d %pS()\n", args=0x387ba394 "H1;\b\240") at lib/vsprintf.c:1559
#11 0x0807edb8 in vprintk_emit (facility=0, level=-1, dict=0x0, dictlen=0, fmt=0x83b3051 "\001\064WARNING: at %s:%d %pS()\n", 
    args=0x387ba394 "H1;\b\240") at kernel/printk.c:1547
#12 0x0833e3ed in printk (fmt=0x83b3051 "\001\064WARNING: at %s:%d %pS()\n") at kernel/printk.c:1689
#13 0x0807d3f0 in warn_slowpath_common (file=0x83b3148 "kernel/softirq.c", line=160, caller=<optimized out>, taint=9, args=0x0) at kernel/panic.c:413
#14 0x0807d4d3 in warn_slowpath_null (file=0x83b3148 "kernel/softirq.c", line=160) at kernel/panic.c:454
#15 0x08084355 in _local_bh_enable_ip (ip=<optimized out>) at kernel/softirq.c:160
#16 local_bh_enable () at kernel/softirq.c:187
#17 0x082ada10 in rcu_read_unlock_bh () at include/linux/rcupdate.h:827
#18 dev_queue_xmit (skb=0x385e76c0) at net/core/dev.c:2735
#19 0x082cfe42 in neigh_hh_output (skb=<optimized out>, hh=<optimized out>) at include/net/neighbour.h:356
#20 dst_neigh_output (skb=0x385e76c0, n=0x3868a800, dst=<optimized out>) at include/net/dst.h:412
#21 ip_finish_output2 (skb=0x385e76c0) at net/ipv4/ip_output.c:201
#22 ip_finish_output (skb=<optimized out>) at net/ipv4/ip_output.c:234
#23 0x082cfee3 in ip_output (skb=0x385e76c0) at net/ipv4/ip_output.c:307
#24 0x082ceec3 in dst_output (skb=0x385e76c0) at include/net/dst.h:449
#25 ip_local_out (skb=0x385e76c0) at net/ipv4/ip_output.c:110
#26 0x082cf06e in ip_build_and_send_pkt (skb=0x385e76c0, sk=0x38690a00, saddr=1174448320, daddr=4261456064, opt=0x0) at net/ipv4/ip_output.c:162
#27 0x082ebb1a in tcp_v4_conn_request (sk=0x38690a00, skb=0x385e7300) at net/ipv4/tcp_ipv4.c:1646
#28 0x082e2c6c in tcp_rcv_state_process (sk=0x38690a00, skb=0x385e7300, th=0x35477762, len=40) at net/ipv4/tcp_input.c:5942
#29 0x082e9957 in tcp_v4_do_rcv (sk=0x38690a00, skb=0x385e7300) at net/ipv4/tcp_ipv4.c:1888
#30 0x082ec4ce in tcp_v4_rcv (skb=0x385e7300) at net/ipv4/tcp_ipv4.c:2028
#31 0x082cb65e in ip_local_deliver_finish (skb=0x385e7300) at net/ipv4/ip_input.c:225
---Type <return> to continue, or q <return> to quit--- 
#32 ip_local_deliver (skb=0x385e7300) at net/ipv4/ip_input.c:263
#33 0x082cbb6a in dst_input (skb=0x385e7300) at include/net/dst.h:455
#34 ip_rcv_finish (skb=0x385e7300) at net/ipv4/ip_input.c:373
#35 ip_rcv (skb=<optimized out>, dev=0x384f2000, pt=0x8425b60 <ip_packet_type>, orig_dev=0x384f2000) at net/ipv4/ip_input.c:451
#36 0x082ab000 in __netif_receive_skb (skb=0x385e7300) at net/core/dev.c:3456
#37 0x082ab0c9 in process_backlog (napi=0x84284c0 <softnet_data+64>, quota=1) at net/core/dev.c:3925
#38 0x082ae7a2 in net_rx_action (h=0x84cfc4c <softirq_vec+12>) at net/core/dev.c:4083
#39 0x08084192 in __do_softirq () at kernel/softirq.c:247
#40 0x080842f6 in do_softirq () at kernel/softirq.c:295
#41 0x080844fd in invoke_softirq () at kernel/softirq.c:329
#42 irq_exit () at kernel/softirq.c:348
#43 0x0805ee5a in do_IRQ (irq=5, regs=0x387ba820) at arch/um/kernel/irq.c:295
#44 0x0805eed5 in sigio_handler (sig=29, unused_si=0x0, regs=0x387ba820) at arch/um/kernel/irq.c:53
#45 0x08071ab8 in sig_handler_common (sig=29, si=0x0, mc=0x0) at arch/um/os-Linux/signal.c:44
#46 0x080719db in unblock_signals () at arch/um/os-Linux/signal.c:282
#47 0x08071b5e in set_signals (enable=1) at arch/um/os-Linux/signal.c:302
#48 0x080842fe in arch_local_irq_restore (flags=1) at /home/tfoerste/devel/linux/arch/um/include/asm/irqflags.h:16
#49 do_softirq () at kernel/softirq.c:297
#50 0x08084397 in _local_bh_enable_ip (ip=<optimized out>) at kernel/softirq.c:176
#51 local_bh_enable () at kernel/softirq.c:187
#52 0x082cfe64 in rcu_read_unlock_bh () at include/linux/rcupdate.h:827
#53 ip_finish_output2 (skb=0x388240b0) at net/ipv4/ip_output.c:203
#54 ip_finish_output (skb=<optimized out>) at net/ipv4/ip_output.c:234
#55 0x082cfee3 in ip_output (skb=0x388240b0) at net/ipv4/ip_output.c:307
#56 0x082ceec3 in dst_output (skb=0x388240b0) at include/net/dst.h:449
#57 ip_local_out (skb=0x388240b0) at net/ipv4/ip_output.c:110
#58 0x082cf37d in ip_queue_xmit (skb=0x388240b0, fl=0x386915c8) at net/ipv4/ip_output.c:403
#59 0x082e5257 in tcp_transmit_skb (sk=0x38691400, skb=0x388240b0, clone_it=<optimized out>, gfp_mask=32) at net/ipv4/tcp_output.c:1106
#60 0x082e5c6c in tcp_write_xmit (sk=0x38691400, mss_now=1448, nonagle=1, push_one=0, gfp=32) at net/ipv4/tcp_output.c:2029
#61 0x082e5e48 in __tcp_push_pending_frames (sk=0x38691400, cur_mss=1448, nonagle=1) at net/ipv4/tcp_output.c:2068
#62 0x082d7854 in tcp_push (nonagle=<optimized out>, mss_now=1448, flags=64, sk=0x38691400) at net/ipv4/tcp.c:636
#63 tcp_sendmsg (iocb=0x387bad68, sk=0x38691400, msg=0x387bad20, size=826) at net/ipv4/tcp.c:1225
#64 0x082fa983 in inet_sendmsg (iocb=0x387bad68, sock=0x3816a180, msg=0x387bad20, size=826) at net/ipv4/af_inet.c:784
#65 0x0829b47c in __sock_sendmsg_nosec (size=<optimized out>, msg=0x387bad20, sock=0x3816a180, iocb=0x387bad68) at net/socket.c:628
#66 __sock_sendmsg (size=<optimized out>, msg=0x387bad20, sock=0x3816a180, iocb=0x387bad68) at net/socket.c:636
#67 do_sock_write (nr_segs=2, iov=0x387bae18, iocb=0x387bad68, msg=0x387bad20, file=<optimized out>) at net/socket.c:974
#68 sock_aio_write (iocb=0x387bad68, iov=0x387bae18, nr_segs=2, pos=0) at net/socket.c:989
#69 0x081003a6 in do_sync_readv_writev (filp=0x387b0280, iov=0x387bae18, nr_segs=2, len=826, ppos=0x387bae94, fn=0x829b360 <sock_aio_write>)
    at fs/read_write.c:572
#70 0x0810066f in do_readv_writev (type=1, file=0x387b0280, uvector=<optimized out>, nr_segs=2, pos=0x387bae94) at fs/read_write.c:730
---Type <return> to continue, or q <return> to quit---
#71 0x08100813 in vfs_writev (file=0x387b0280, vec=0x4b510bd0, vlen=2, pos=0x387bae94) at fs/read_write.c:768
#72 0x08100920 in sys_writev (fd=13, vec=0x4b510bd0, vlen=2) at fs/read_write.c:800
#73 0x08062ab2 in handle_syscall (r=0x3874b590) at arch/um/kernel/skas/syscall.c:35
#74 0x08074efd in handle_trap (local_using_sysemu=<optimized out>, regs=0x3874b590, pid=11862) at arch/um/os-Linux/skas/process.c:193
#75 userspace (regs=0x3874b590) at arch/um/os-Linux/skas/process.c:426
#76 0x0805f7cc in fork_handler () at arch/um/kernel/process.c:160
#77 0x00000000 in ?? ()


This happens since a loong time, the GDB trace above is from 3.8-rc1.
Any hints or tips ?

-- 
MfG/Sincerely
Toralf Förster
pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3
