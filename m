Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754017Ab1JVQXJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Oct 2011 12:23:09 -0400
Received: from netrider.rowland.org ([192.131.102.5]:33721 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753764Ab1JVQXI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Oct 2011 12:23:08 -0400
Date: Sat, 22 Oct 2011 12:23:07 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: kanyck <nick.ka@mail.ru>, Thomas Gleixner <tglx@linutronix.de>
cc: Kernel development list <linux-kernel@vger.kernel.org>,
        USB list <linux-usb@vger.kernel.org>
Subject: Re: [bug] =?utf-8?b?dXNiX2hjZF9pcnEs?= irq nobody cared & threadirqs
In-Reply-To: <loom.20111022T124933-767@post.gmane.org>
Message-ID: <Pine.LNX.4.44L0.1110221218550.20346-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This problem does not seem to be particularly related to USB.  It 
appears to be a bug in the threaded IRQ subsystem.

I don't know what I can do other than forward the message to people who
might know more about it.

Alan Stern


On Sat, 22 Oct 2011, kanyck wrote:

> Hello Alan and everybody,
> 
> I apparently have the same problem but can't report it because the kernel.org 
> is still not fully up. So I apologize if I've put my report in a wrong place...
> 
> I experienced very high iowait level during intensive disk I/O (up to 87% 
> per CPU) on all the kernels I tried (2.6.32 and Debian backports' 2.6.38,
> 2.6.39) running on ASUS E35M1-M PRO (AMD e-350) platform
> 
> So I installed AVLinux's 3.0.3 kernel:
> Linux version 3.0.3-avl-3-pae (trulan@avlinux) (gcc version 4.6.1 (Debian
> 4.6.1-4) ) #1 SMP PREEMPT Thu Aug 18 07:18:19 EDT 2011
> 
> It worked much better but after a couple of hours my ethernet stops working and
> I see the following in my syslog:
> 
> Oct 16 21:31:43 localhost kernel: [14328.121907] irq 18: nobody cared (try
> booting with the "irqpoll" option)
> Oct 16 21:31:43 localhost kernel: [14328.125161] Pid: 658, comm: 
> irq/18-ohci_hcd Not tainted 3.0.3-avl-3-pae #1
> Oct 16 21:31:43 localhost kernel: [14328.128863] Call Trace:
> Oct 16 21:31:43 localhost kernel: [14328.132512]  [<c1068fab>] ?
> __report_bad_irq+0x1c/0x8d
> Oct 16 21:31:43 localhost kernel: [14328.136168]  [<c10692c3>] ?
> note_interrupt+0x11a/0x187
> Oct 16 21:31:43 localhost kernel: [14328.139790]  [<c10685df>] ?
> irq_thread+0xbf/0x15c
> Oct 16 21:31:43 localhost kernel: [14328.143373]  [<c106869f>] ?
> irq_thread_fn+0x23/0x23
> Oct 16 21:31:43 localhost kernel: [14328.146900]  [<c1022289>] ? 
> complete+0x28/0x36
> Oct 16 21:31:43 localhost kernel: [14328.150385]  [<c1068520>] ?
> irq_finalize_oneshot+0x9d/0x9d
> Oct 16 21:31:43 localhost kernel: [14328.153854]  [<c1040587>] ? 
> kthread+0x63/0x68
> Oct 16 21:31:43 localhost kernel: [14328.157276]  [<c1040524>] ?
> kthread_worker_fn+0x101/0x101
> Oct 16 21:31:43 localhost kernel: [14328.160671]  [<c1249a76>] ?
> kernel_thread_helper+0x6/0xd
> Oct 16 21:31:43 localhost kernel: [14328.164032] handlers:
> Oct 16 21:31:43 localhost kernel: [14328.167331] [<c1068080>]
> irq_default_primary_handler threaded [<ef7eccd5>] usb_hcd_irq
> Oct 16 21:31:43 localhost kernel: [14328.168325] [<c1068080>]
> irq_default_primary_handler threaded [<ef7eccd5>] usb_hcd_irq
> Oct 16 21:31:43 localhost kernel: [14328.168325] [<c1068080>]
> irq_default_primary_handler threaded [<ef7eccd5>] usb_hcd_irq
> Oct 16 21:31:43 localhost kernel: [14328.168325] [<c1068080>]
> irq_default_primary_handler threaded [<ef7eccd5>] usb_hcd_irq
> Oct 16 21:31:43 localhost kernel: [14328.168325] [<c1068080>]
> irq_default_primary_handler threaded [<ef9a54d9>] rtl8169_interrupt
> Oct 16 21:31:43 localhost kernel: [14328.183633] Disabling IRQ #18
> 
> This happend repeatedly until I disabled threadirqs option. Now it is stable,
> however I returned to high latencies and terrific iowaits...
> 
> Please suggest how cold I get help?

