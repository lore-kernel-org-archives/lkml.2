Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758203Ab2IVCI6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 22:08:58 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:36750 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753950Ab2IVCI4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 22:08:56 -0400
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX1+JYHx3jdGJXLbPoKUCZl3BP9Ub9jKkMvz7mmpHhj
	Tp2ofUsXpm0lAd
From: Peter =?iso-8859-1?q?H=FCwe?= <PeterHuewe@gmx.de>
To: Jonathan Cameron <jic23@cam.ac.uk>
Subject: OOPS/panic in iio_dummy (v3.6-rc6-176-gabef3bd)
Date: Sat, 22 Sep 2012 04:13:36 +0200
User-Agent: KMail/1.13.7 (Linux/3.5.4; KDE/4.8.5; x86_64; ; )
Cc: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        linux-iio@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201209220413.36295.PeterHuewe@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

loading iio_dummy results in kernel panic as the call to 
iio_buffer_register in iio_dummy_probe is performed with indio_dev->buffer == 
NULL and thus the access to indio_dev->buffer->attrs results in this 
oops/panic.

Thanks,
Peter

Steps to reproduce:

#modprobe iio_dummy
iio_dummy: module is from the staging directory, the quality is unknown, you 
have been warned.

Modules linked in: iio_dummy(C+) industrialio
Pid: 615, comm: modprobe Tainted: G         C   3.6.0-rc6-00180-g68d0383-dirty
RIP: 0033:[<00000000a089d846>]
RSP: 000000009f4ffd30  EFLAGS: 00010206
RAX: 0000000000000004 RBX: 00000000a08be6a0 RCX: 0000000000000000
RDX: 000000006036a320 RSI: 0000000000000008 RDI: 0000000000000000
RBP: 000000009f4ffda0 R08: 000000009f4ff900 R09: 0000000060406da8
R10: 000000000000004a R11: 0000000000000246 R12: 00000000602a58bc
R13: 0000000000000005 R14: 000000006005f170 R15: 000000009f6b0400
Call Trace: 
603675d8:  [<6001d53d>] segv+0x1bd/0x340
603675f8:  [<6008b8ab>] handle_irq_event_percpu+0xab/0x1b0
60367620:  [<6008b9b0>] handle_irq_event+0x0/0x40
60367630:  [<6002e09c>] os_waiting_for_events+0x0/0xc5
60367658:  [<6008fccf>] rcu_irq_exit+0x5f/0xb0
603676a8:  [<6001d713>] segv_handler+0x53/0xb0
603676c8:  [<60019b5c>] sigio_handler+0xac/0xc0
603676f8:  [<6002ff5a>] sig_handler_common+0xa4/0xb9
60367708:  [<6005f170>] __mutex_init+0x0/0x20
60367718:  [<602a58bc>] printk+0x0/0xa8
60367780:  [<a089d846>] iio_buffer_register+0x46/0x610 [industrialio]
60367818:  [<60016c34>] _einittext+0x2572/0x38f6
60367828:  [<60016728>] _einittext+0x2066/0x38f6
60367908:  [<60016c34>] _einittext+0x2572/0x38f6
603679a8:  [<60019b70>] to_irq_stack+0x0/0xe0
60367a28:  [<60019b70>] to_irq_stack+0x0/0xe0
60367a38:  [<600300b5>] sig_handler+0x4a/0x5d
60367a58:  [<6002fb81>] hard_handler+0x89/0xd8
60367a90:  [<602a58bc>] printk+0x0/0xa8
60367aa0:  [<6005f170>] __mutex_init+0x0/0x20
60367b08:  [<602a58bc>] printk+0x0/0xa8
60367b18:  [<6005f170>] __mutex_init+0x0/0x20
60367b68:  [<a089d846>] iio_buffer_register+0x46/0x610 [industrialio]

Kernel panic - not syncing: Kernel mode fault at addr 0x68, ip 0xa089d846
Call Trace: 
603674b0:  [<a089d846>] iio_buffer_register+0x46/0x610 [industrialio]
603674c8:  [<602a5751>] panic+0x146/0x2b1
60367500:  [<a089d846>] iio_buffer_register+0x46/0x610 [industrialio]
60367508:  [<602a560b>] panic+0x0/0x2b1
60367520:  [<6007a4d4>] __module_text_address+0x14/0x70
60367538:  [<6007ec20>] is_module_text_address+0x10/0x20
60367548:  [<600582c7>] __kernel_text_address+0x87/0xc0
60367568:  [<6001bc1f>] show_trace+0x7f/0xf0
60367598:  [<a089d846>] iio_buffer_register+0x46/0x610 [industrialio]
603675c0:  [<a089d846>] iio_buffer_register+0x46/0x610 [industrialio]
603675d8:  [<6001d55b>] segv+0x1db/0x340
603675f8:  [<6008b8ab>] handle_irq_event_percpu+0xab/0x1b0
60367620:  [<6008b9b0>] handle_irq_event+0x0/0x40
60367630:  [<6002e09c>] os_waiting_for_events+0x0/0xc5
60367658:  [<6008fccf>] rcu_irq_exit+0x5f/0xb0
603676a8:  [<6001d713>] segv_handler+0x53/0xb0
603676c8:  [<60019b5c>] sigio_handler+0xac/0xc0
603676f8:  [<6002ff5a>] sig_handler_common+0xa4/0xb9
60367708:  [<6005f170>] __mutex_init+0x0/0x20
60367718:  [<602a58bc>] printk+0x0/0xa8
60367780:  [<a089d846>] iio_buffer_register+0x46/0x610 [industrialio]
60367818:  [<60016c34>] _einittext+0x2572/0x38f6
60367828:  [<60016728>] _einittext+0x2066/0x38f6
60367908:  [<60016c34>] _einittext+0x2572/0x38f6
603679a8:  [<60019b70>] to_irq_stack+0x0/0xe0
60367a28:  [<60019b70>] to_irq_stack+0x0/0xe0
60367a38:  [<600300b5>] sig_handler+0x4a/0x5d
60367a58:  [<6002fb81>] hard_handler+0x89/0xd8
60367a90:  [<602a58bc>] printk+0x0/0xa8
60367aa0:  [<6005f170>] __mutex_init+0x0/0x20
60367b08:  [<602a58bc>] printk+0x0/0xa8
60367b18:  [<6005f170>] __mutex_init+0x0/0x20
60367b68:  [<a089d846>] iio_buffer_register+0x46/0x610 [industrialio]


Modules linked in: iio_dummy(C+) industrialio
Pid: 615, comm: modprobe Tainted: G         C   3.6.0-rc6-00180-g68d0383-dirty
RIP: 0033:[<00000000402eff9a>]
RSP: 0000007fbfbf6798  EFLAGS: 00000246
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: ffffffffffffffff
RDX: 000000000060e110 RSI: 00000000000148c9 RDI: 0000000040024000
RBP: 0000000000611b70 R08: 000000000060e100 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000060e110
R13: 0000000000000000 R14: 000000000060e010 R15: 0000000000611b88
Call Trace: 
60367448:  [<6001db1e>] panic_exit+0x3e/0x60
60367478:  [<600616ad>] notifier_call_chain+0x4d/0x70
603674a0:  [<a089d846>] iio_buffer_register+0x46/0x610 [industrialio]
603674b8:  [<60061708>] atomic_notifier_call_chain+0x18/0x20
603674c8:  [<602a5784>] panic+0x179/0x2b1
60367500:  [<a089d846>] iio_buffer_register+0x46/0x610 [industrialio]
60367508:  [<602a560b>] panic+0x0/0x2b1
60367520:  [<6007a4d4>] __module_text_address+0x14/0x70
60367538:  [<6007ec20>] is_module_text_address+0x10/0x20
60367548:  [<600582c7>] __kernel_text_address+0x87/0xc0
60367568:  [<6001bc1f>] show_trace+0x7f/0xf0
60367598:  [<a089d846>] iio_buffer_register+0x46/0x610 [industrialio]
603675c0:  [<a089d846>] iio_buffer_register+0x46/0x610 [industrialio]
603675d8:  [<6001d55b>] segv+0x1db/0x340
603675f8:  [<6008b8ab>] handle_irq_event_percpu+0xab/0x1b0
60367620:  [<6008b9b0>] handle_irq_event+0x0/0x40
60367630:  [<6002e09c>] os_waiting_for_events+0x0/0xc5
60367658:  [<6008fccf>] rcu_irq_exit+0x5f/0xb0
603676a8:  [<6001d713>] segv_handler+0x53/0xb0
603676c8:  [<60019b5c>] sigio_handler+0xac/0xc0
603676f8:  [<6002ff5a>] sig_handler_common+0xa4/0xb9
60367708:  [<6005f170>] __mutex_init+0x0/0x20
60367718:  [<602a58bc>] printk+0x0/0xa8
60367780:  [<a089d846>] iio_buffer_register+0x46/0x610 [industrialio]
60367818:  [<60016c34>] _einittext+0x2572/0x38f6
60367828:  [<60016728>] _einittext+0x2066/0x38f6
60367908:  [<60016c34>] _einittext+0x2572/0x38f6
603679a8:  [<60019b70>] to_irq_stack+0x0/0xe0
60367a28:  [<60019b70>] to_irq_stack+0x0/0xe0
60367a38:  [<600300b5>] sig_handler+0x4a/0x5d
60367a58:  [<6002fb81>] hard_handler+0x89/0xd8
60367a90:  [<602a58bc>] printk+0x0/0xa8
60367aa0:  [<6005f170>] __mutex_init+0x0/0x20
60367b08:  [<602a58bc>] printk+0x0/0xa8
60367b18:  [<6005f170>] __mutex_init+0x0/0x20
60367b68:  [<a089d846>] iio_buffer_register+0x46/0x610 [industrialio]


Tested on recent linus' tree (v3.6-rc6-176-gabef3bd)
