Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755389Ab0KMPZg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Nov 2010 10:25:36 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:40919 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754214Ab0KMPZe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Nov 2010 10:25:34 -0500
Date: Sat, 13 Nov 2010 16:25:14 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Greg KH <gregkh@suse.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Lawrence Rust <lvr@softsystem.co.uk>
Subject: Re: [boot crash] Re: [GIT PATCH] TTY/serial fixes for .37-rc1
Message-ID: <20101113152514.GA3069@elte.hu>
References: <20101112213215.GB9294@kroah.com>
 <20101113151022.GA29085@elte.hu>
 <20101113152131.GA2606@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101113152131.GA2606@elte.hu>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> * Ingo Molnar <mingo@elte.hu> wrote:
> 
> > It crashed almost immediately after i merged Linus's 9457b24a0955 into -tip,
> > we were on yesterday's f6614b7bb405 before that - so i think the crash is
> > both pretty generic.
> 
> Yes, it crashes with an x86 defconfig too. Appears to be caused by:
> 
>  47d3904fe40d: 8250: Fix tcsetattr to avoid ioctl(TIOCMIWAIT) hang
> 
> It crashes any x86 serial console bootup.

The revert below makes the system boot up fine.

Thanks,

	Ingo

------------------------>
>From a0758e8ea2a19de96d16db231be71f708980b86a Mon Sep 17 00:00:00 2001
From: Ingo Molnar <mingo@elte.hu>
Date: Sat, 13 Nov 2010 16:21:58 +0100
Subject: [PATCH] Revert "8250: Fix tcsetattr to avoid ioctl(TIOCMIWAIT) hang"

This reverts commit 47d3904fe40d62deee8cd46e79ca784e7a548acd.

Crashes any x86 serial console bootup:

Console: colour VGA+ 80x25
BUG: unable to handle kernel NULL pointer dereference at 0000000000000158
IP: [<ffffffff811ebcb4>] serial8250_do_set_termios+0x1d4/0x430
PGD 0 
Oops: 0000 [#1] SMP 
last sysfs file: 
CPU 0 
Modules linked in:

Pid: 0, comm: swapper Not tainted 2.6.37-rc1-tip-02017-gba4813e-dirty #62970 /
RIP: 0010:[<ffffffff811ebcb4>]  [<ffffffff811ebcb4>] serial8250_do_set_termios+0x1d4/0x430
RSP: 0000:ffffffff8152fd88  EFLAGS: 00010082
RAX: 0000000000000000 RBX: ffffffff8207aa80 RCX: 0000000000002060
RDX: 0000000000000158 RSI: 0000000000000000 RDI: ffffffff8207aa80
RBP: ffffffff8152fdd8 R08: 000000000000000a R09: 000000000001c200
R10: 0000000000000025 R11: ffffffff81cec340 R12: 0000000000000013
R13: ffffffff8152fe08 R14: 0000000000000001 R15: 000000000001c200
FS:  0000000000000000(0000) GS:ffff88003e400000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000158 CR3: 000000000153f000 CR4: 00000000000006b0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process swapper (pid: 0, threadinfo ffffffff8152e000, task ffffffff81547020)
Stack:
 ffffffff815567e0 ffffffff8207aa00 0000000000000286 00ffffff8207aa10
 000000000000006e 000000000001c200 ffffffff8207aa80 ffffffff815762c0
 000000000000006e 000000000000006e ffffffff8152fde8 ffffffff811ebf35
Call Trace:
 [<ffffffff811ebf35>] serial8250_set_termios+0x25/0x30
 [<ffffffff811e6663>] uart_set_options+0xf3/0x170
 [<ffffffff81798f55>] serial8250_console_setup+0xa8/0xaf
 [<ffffffff8104ac1a>] register_console+0x22a/0x390
 [<ffffffff81799117>] serial8250_console_init+0x28/0x2c
 [<ffffffff81797a5c>] console_init+0x19/0x2a
 [<ffffffff81778b4d>] start_kernel+0x27d/0x407
 [<ffffffff81778347>] x86_64_start_reservations+0x132/0x136
 [<ffffffff81778451>] x86_64_start_kernel+0x106/0x115
Code: 98 00 00 00 41 f6 45 00 04 0f 85 a8 01 00 00 41 f6 45 08 80 75 07 83 8b 98 00 00 00 01 48 8b 83 a0 00 00 00 48 8d 90 58 01 00 00 <48> 39 90 58 01 00 00 0f 84 17 02 00 00 0f b6 93 c1 01 00 00 89 
RIP  [<ffffffff811ebcb4>] serial8250_do_set_termios+0x1d4/0x430
 RSP <ffffffff8152fd88>
CR2: 0000000000000158
---[ end trace a7919e7f17c0a725 ]---
Kernel panic - not syncing: Fatal exception
Pid: 0, comm: swapper Tainted: G      D     2.6.37-rc1-tip-02017-gba4813e-dirty #62970
Call Trace:
 [<ffffffff8139148f>] panic+0x8c/0x19c
 [<ffffffff8104b745>] ? kmsg_dump+0x155/0x170
 [<ffffffff8100f744>] oops_end+0xd4/0xf0
 [<ffffffff81030a50>] no_context+0xf0/0x260
 [<ffffffff81063910>] ? __kernel_text_address+0x40/0x70
 [<ffffffff81030ce5>] __bad_area_nosemaphore+0x125/0x1e0
 [<ffffffff81030dae>] bad_area_nosemaphore+0xe/0x10
 [<ffffffff81031841>] do_page_fault+0x3d1/0x4a0
 [<ffffffff8101867a>] ? save_stack_trace+0x2a/0x50
 [<ffffffff8107810d>] ? __lock_acquire.clone.20+0x6fd/0xab0
 [<ffffffff81395ad5>] page_fault+0x25/0x30
 [<ffffffff811ebcb4>] ? serial8250_do_set_termios+0x1d4/0x430
 [<ffffffff811ebc2d>] ? serial8250_do_set_termios+0x14d/0x430
 [<ffffffff811ebf35>] serial8250_set_termios+0x25/0x30
 [<ffffffff811e6663>] uart_set_options+0xf3/0x170
 [<ffffffff81798f55>] serial8250_console_setup+0xa8/0xaf
 [<ffffffff8104ac1a>] register_console+0x22a/0x390
 [<ffffffff81799117>] serial8250_console_init+0x28/0x2c
 [<ffffffff81797a5c>] console_init+0x19/0x2a
 [<ffffffff81778b4d>] start_kernel+0x27d/0x407
 [<ffffffff81778347>] x86_64_start_reservations+0x132/0x136
 [<ffffffff81778451>] x86_64_start_kernel+0x106/0x115

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 drivers/serial/8250.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/drivers/serial/8250.c b/drivers/serial/8250.c
index dd5e1ac..4d8e14b 100644
--- a/drivers/serial/8250.c
+++ b/drivers/serial/8250.c
@@ -2343,11 +2343,8 @@ serial8250_do_set_termios(struct uart_port *port, struct ktermios *termios,
 
 	/*
 	 * CTS flow control flag and modem status interrupts
-	 * Only disable MSI if no threads are waiting in
-	 * serial_core::uart_wait_modem_status
 	 */
-	if (!waitqueue_active(&up->port.state->port.delta_msr_wait))
-		up->ier &= ~UART_IER_MSI;
+	up->ier &= ~UART_IER_MSI;
 	if (!(up->bugs & UART_BUG_NOMSR) &&
 			UART_ENABLE_MS(&up->port, termios->c_cflag))
 		up->ier |= UART_IER_MSI;
