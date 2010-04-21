Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754908Ab0DUB07 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Apr 2010 21:26:59 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:37506 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754858Ab0DUB0w convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Apr 2010 21:26:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=gpsPmYK2WI17i8m4Sxgy+Da0pGoVqZOcfgEr3vnTVF90Uulb3dPjvOHhkm5Sv/xABD
         UZroJnCb6wdCLQmdZmuEJzsLFAHdBSSaJZT8CDTdTH3EZHXC8PrxkblX6k5bWrUNd8LA
         GnGCF8FLEE+oiJabyyALyGhZcNPQephPTzesM=
MIME-Version: 1.0
In-Reply-To: <j2pfe58d3641004201748uadddaf12n1cfec0c0bb98117c@mail.gmail.com>
References: <j2pfe58d3641004201748uadddaf12n1cfec0c0bb98117c@mail.gmail.com>
Date: Tue, 20 Apr 2010 18:21:08 -0700
Message-ID: <n2pfe58d3641004201821r3805616id4a8cd5cdb745b46@mail.gmail.com>
Subject: Question on 2.6.25 kernel crash.
From: Viswanathan Murugesan <viswa.murugesan@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.25 Kernel crashes when tried to upload a 2 MB file through FTP to
a ftp server under a ipsec gateway.

With 2.6.25 kernel and openswan2.6.24, a IPSEC tunnel is established
with IPSEC gateway. A FTP server is connected under the IPSEC gateway.
Tried to upload a file of 2MB to the FTP server. Kernel crashes with
oops and it is not consistent. Sometimes it might pass successfully.
We have to try this few time to recreate this problem.

Following are the two logs that I have collected for this oops message

Unable to handle kernel NULL pointer dereference at virtual address 00000004
pgd = c0004000
[00000004] *pgd=00000000
Internal error: Oops: 817 [#1] PREEMPT
Modules linked in: deflate zlib_deflate zlib_inflate crypto_null blowfish ah4 es
p4 xfrm4_mode_beet xfrm4_tunnel tunnel4 xfrm4_mode_tunnel xfrm4_mode_transport i
pcomp af_key uap8xxx msm_sdcc
CPU: 0    Not tainted  (2.6.25.07 #6)
PC is at skb_dequeue+0x48/0x64
LR is at _spin_lock_irqsave+0x54/0x60
pc : [<c01f8da8>]    lr : [<c02a5890>]    psr: 20000093
sp : c39d9da8  ip : c39d9d80  fp : c39d9dc4
r10: 0000043d  r9 : c39d8000  r8 : 00000001
r7 : 00000002  r6 : c30cc0a8  r5 : c40d0760  r4 : c30cc09c
r3 : ffffffde  r2 : 00000000  r1 : 60000013  r0 : 00000000
Flags: nzCv  IRQs off  FIQs on  Mode SVC_32  ISA ARM  Segment kernel
Control: 00c5387f  Table: 04350008  DAC: 00000017
Process smd_tty (pid: 107, stack limit = 0xc39d8260)
Stack: (0xc39d9da8 to 0xc39da000)
9da0:                   c40d0760 c30cc000 c40d0760 0000000a c39d9ddc c39d9dc8
9dc0: c019d3e4 c01f8d6c c30cc0c4 00000000 c39d9df4 c39d9de0 c005c068 c019d3b8
9de0: c03eb3f0 00000001 c39d9e14 c39d9df8 c005bef0 c005bffc c038a228 c39d8000
9e00: c39d8000 00000000 c39d9e2c c39d9e18 c005c488 c005be84 00000000 c038a228
9e20: c39d9e4c c39d9e30 c002904c c005c438 00000080 ffffffff e0000000 0000043d
9e40: c39d9eac c39d9e50 c0029630 c002900c c30cc030 c033f330 c39d8000 00000000
9e60: c30cc030 a0000013 0000043d c356f39e c356f59e c3140000 0000043d c39d9eac
9e80: c39d9e98 c39d9e98 c02a5e20 c02a5e24 60000013 ffffffff c314ca1c c30cc000
9ea0: c39d9ee4 c39d9eb0 c019d94c c02a5de8 c3140000 a0000013 60000013 c314ca1c
9ec0: c314c81c c3140000 c314c800 00412fbf c3140154 00010000 c39d9f1c c39d9ee8
9ee0: c01771fc c019d428 c03aa394 c314000c 60000013 c3140108 c3140000 c03aa394
9f00: c03aa3a0 c39d9f6c 00000000 c003b2a8 c39d9f34 c39d9f20 c01772d8 c0177108
9f20: 0000010c c3140000 c39d9f5c c39d9f38 c003b340 c0177290 c00682ec c314c81c
9f40: 00000002 00000002 c42e7de0 c39d8000 c39d9f9c c39d9f60 c006834c c003b2b4
9f60: 00000002 c00682ec fe7df56c c03aa254 00000000 c0324860 c42e7e04 c39d8000
9f80: c42e7de0 00000000 00000000 00000000 c39d9fd4 c39d9fa0 c00690b0 c0068258
9fa0: bdaf306f 00000000 c4288480 c006c54c c39d9fb0 c39d9fb0 00000000 c39d8000
9fc0: c42e7de0 c0068fc0 c39d9ff4 c39d9fd8 c006c43c c0068fcc 00000000 00000000
9fe0: 00000000 00000000 00000000 c39d9ff8 c0059e08 c006c3ec 00000000 00000000
Backtrace:
[<c01f8d60>] (skb_dequeue+0x0/0x64) from [<c019d3e4>] (ppp_async_process+0x38/0x
70)
 r6:0000000a r5:c40d0760 r4:c30cc000
[<c019d3ac>] (ppp_async_process+0x0/0x70) from [<c005c068>] (tasklet_action+0x78
/0xd0)
 r5:00000000 r4:c30cc0c4
[<c005bff0>] (tasklet_action+0x0/0xd0) from [<c005bef0>] (__do_softirq+0x78/0x10
4)

 r5:00000001 r4:c03eb3f0
[<c005be78>] (__do_softirq+0x0/0x104) from [<c005c488>] (irq_exit+0x5c/0xa4)
 r6:00000000 r5:c39d8000 r4:c39d8000

 r6:00000000 r5:c39d8000 r4:c39d8000
[<c005c42c>] (irq_exit+0x0/0xa4) from [<c002904c>] (__exception_text_start+0x4c/
0x64)
 r5:c038a228 r4:00000000
[<c0029000>] (__exception_text_start+0x0/0x64) from [<c0029630>] (__irq_svc+0x50
/0x74)
Exception stack(0xc39d9e50 to 0xc39d9e98)
9e40:                                     c30cc030 c033f330 c39d8000 00000000
9e60: c30cc030 a0000013 0000043d c356f39e c356f59e c3140000 0000043d c39d9eac
9e80: c39d9e98 c39d9e98 c02a5e20 c02a5e24 60000013 ffffffff
 r6:0000043d r5:e0000000 r4:ffffffff
[<c02a5ddc>] (_spin_unlock_irqrestore+0x0/0x6c) from [<c019d94c>] (ppp_asynctty_
receive+0x530/0x5ec)
 r5:c30cc000 r4:c314ca1c
[<c019d41c>] (ppp_asynctty_receive+0x0/0x5ec) from [<c01771fc>] (flush_to_ldisc+
0x100/0x188)
[<c01770fc>] (flush_to_ldisc+0x0/0x188) from [<c01772d8>] (tty_flip_buffer_push+
0x54/0x64)
[<c0177284>] (tty_flip_buffer_push+0x0/0x64) from [<c003b340>] (smd_tty_work_fun
c+0x98/0xb4)
 r5:c3140000 r4:0000010c
[<c003b2a8>] (smd_tty_work_func+0x0/0xb4) from [<c006834c>] (run_workqueue+0x100
/0x1f0)
 r6:c39d8000 r5:c42e7de0 r4:00000002
[<c006824c>] (run_workqueue+0x0/0x1f0) from [<c00690b0>] (worker_thread+0xf0/0x1
04)
[<c0068fc0>] (worker_thread+0x0/0x104) from [<c006c43c>] (kthread+0x5c/0x94)
 r6:c0068fc0 r5:c42e7de0 r4:c39d8000
[<c006c3e0>] (kthread+0x0/0x94) from [<c0059e08>] (do_exit+0x0/0x6ac)
 r6:00000000 r5:00000000 r4:00000000
Code: e3a00000 15843008 01a05000 15842000 (15824004)
Kernel panic - not syncing: Fatal exception in interrupt

Another log of the crash.

skb_over_panic: text:c01d1bfc len:2854 put:1434 head:c4033800 data:c4033810 tail
:0xc4034336 end:0xc4033e20 dev:usb0
kernel BUG at net/core/skbuff.c:130!
Unable to handle kernel NULL pointer dereference at virtual address 00000000
pgd = c3448000
[00000000] *pgd=0365c031, *pte=00000000, *ppte=00000000
Internal error: Oops: 817 [#1] PREEMPT
Modules linked in: deflate zlib_deflate zlib_inflate crypto_null blowfish ah4 es
p4 xfrm4_mode_beet xfrm4_tunnel tunnel4 xfrm4_mode_tunnel xfrm4_mode_transport i
pcomp af_key uap8xxx msm_sdcc
CPU: 0    Not tainted  (2.6.25.07 #6)
PC is at __bug+0x20/0x2c
LR is at vprintk+0x350/0x43c
pc : [<c002dbb0>]    lr : [<c00575c0>]    psr: 40000093
sp : c345fe88  ip : c345fde0  fp : c345fe94
r10: 00000006  r9 : c345e000  r8 : 60000093
r7 : c4033e20  r6 : c4034336  r5 : c4033810  r4 : c4033800
r3 : 00000000  r2 : c345e000  r1 : c325e8c0  r0 : 00000028
Flags: nZcv  IRQs off  FIQs on  Mode SVC_32  ISA ARM  Segment user
Control: 00c5387f  Table: 03648008  DAC: 00000015
Process klogd (pid: 761, stack limit = 0xc345e260)
Stack: (0xc345fe88 to 0xc3460000)
fe80:                   c345fecc c345fe98 c01f7dbc c002db9c c4033800 c4033810
fea0: c4034336 c4033e20 c39d2000 60000093 c41df520 c39d2480 c33ba860 04000040
fec0: c345feec c345fed0 c01d1c0c c01f7d6c c02a5e2c c33ba860 c39d2948 c39d2800
fee0: c345ff4c c345fef0 c01ccab8 c01d1b74 c0637f10 60000093 00000080 c345e000
ff00: 00000000 00000000 c345e000 4021c000 c345ff4c c345ff20 c007aa30 c0079884
ff20: 00000002 c322b620 00000000 00000000 0000002f 00000000 c345e000 4021c000
ff40: c345ff6c c345ff50 c0083b7c c01cc020 c038b194 0000002f c322b620 c038b1c4
ff60: c345ff8c c345ff70 c00855fc c0083b5c 0000002f c038b194 00000000 00000001
ff80: c345ffac c345ff90 c0029048 c0085538 c00aa1c4 ffffffff e0000000 4020d7a7
ffa0: 00000000 c345ffb0 c0029850 c002900c 00001ffc 00000007 00000000 fffffff9
ffc0: fffffff7 00000008 4020d7a7 0008b193 ffffffff 4020aadc 4021c000 00000008
ffe0: ffffffff be9fdba0 00000000 40188670 a0000010 ffffffff 00000000 00000000
Backtrace:
[<c002db90>] (__bug+0x0/0x2c) from [<c01f7dbc>] (skb_over_panic+0x5c/0x68)
[<c01f7d60>] (skb_over_panic+0x0/0x68) from [<c01d1c0c>] (rx_complete+0xa4/0x1bc
)
 r7:04000040 r6:c33ba860 r5:c39d2480 r4:c41df520
[<c01d1b68>] (rx_complete+0x0/0x1bc) from [<c01ccab8>] (usb_interrupt+0xaa4/0xc6
0)
 r6:c39d2800 r5:c39d2948 r4:c33ba860
[<c01cc014>] (usb_interrupt+0x0/0xc60) from [<c0083b7c>] (handle_IRQ_event+0x2c/
0x68)
[<c0083b50>] (handle_IRQ_event+0x0/0x68) from [<c00855fc>] (handle_level_irq+0xd
0/0x140)
 r7:c038b1c4 r6:c322b620 r5:0000002f r4:c038b194
[<c008552c>] (handle_level_irq+0x0/0x140) from [<c0029048>] (__exception_text_st
art+0x48/0x64)
 r7:00000001 r6:00000000 r5:c038b194 r4:0000002f
[<c0029000>] (__exception_text_start+0x0/0x64) from [<c0029850>] (__irq_usr+0x50
/0xa0)
Exception stack(0xc345ffb0 to 0xc345fff8)
ffa0:                                     00001ffc 00000007 00000000 fffffff9
ffc0: fffffff7 00000008 4020d7a7 0008b193 ffffffff 4020aadc 4021c000 00000008
ffe0: ffffffff be9fdba0 00000000 40188670 a0000010 ffffffff
 r6:4020d7a7 r5:e0000000 r4:ffffffff
Code: e1a01000 e59f000c eb00a6bf e3a03000 (e5833000)
Kernel panic - not syncing: Fatal exception in interrupt
Rebooting in 5 seconds..

Does somebody come across crash like this before. I am just wondering
if it is know issue in the 2.6.25 kernel.
Any help is appreciated.

TIA,
Viswa.
