Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751662Ab2GIQF7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 12:05:59 -0400
Received: from pindarots.xs4all.nl ([80.101.128.228]:52418 "EHLO
	pindarots.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751043Ab2GIQF6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 12:05:58 -0400
Message-ID: <4FFB015E.8050803@xs4all.nl>
Date: Mon, 09 Jul 2012 18:05:50 +0200
From: Udo van den Heuvel <udovdh@xs4all.nl>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Clemens Ladisch <clemens@ladisch.de>
CC: linux-usb@vger.kernel.org, Simon Jones <sijones2010@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: 3.4.4: disabling irq
References: <4FF93C68.5000503@xs4all.nl> <4FFAE2A5.2070701@ladisch.de>
In-Reply-To: <4FFAE2A5.2070701@ladisch.de>
X-Enigmail-Version: 1.4.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-07-09 15:54, Clemens Ladisch wrote:
> (forwarded to linux-usb)
> 
> Udo van den Heuvel wrote:
>> Hello,
>>
>> One moment the box is runing OK.
>> One moment the 3.4.4 kernel decides to disable an interrupt.
>> Why?
>>
>> Jul  8 07:43:49 box3 ntpd[5067]: parse: convert_rawdcf: INCOMPLETE DATA - time code only has 1 bits
>> Jul  8 07:44:53 box3 kernel: irq 18: nobody cared (try booting with the "irqpoll" option)
>> Jul  8 07:44:53 box3 kernel: Pid: 1501, comm: irq/18-ohci_hcd Tainted: G        W    3.4.4 #1
>> Jul  8 07:44:53 box3 kernel: Call Trace:
>> Jul  8 07:44:53 box3 kernel: [<ffffffff81095a76>] ? __report_bad_irq+0x36/0xd0
>> Jul  8 07:44:53 box3 kernel: [<ffffffff81095d7f>] ? note_interrupt+0x1cf/0x220
>> Jul  8 07:44:53 box3 kernel: [<ffffffff810945c0>] ? irq_thread_fn+0x40/0x40
>> Jul  8 07:44:53 box3 kernel: [<ffffffff8109443d>] ? irq_thread+0x13d/0x180
>> Jul  8 07:44:53 box3 kernel: [<ffffffff81094300>] ? wake_threads_waitq+0x50/0x50
>> Jul  8 07:44:53 box3 kernel: [<ffffffff81052015>] ? kthread+0x85/0x90
>> Jul  8 07:44:53 box3 kernel: [<ffffffff81405514>] ? kernel_thread_helper+0x4/0x10
>> Jul  8 07:44:53 box3 kernel: [<ffffffff81051f90>] ? kthread_freezable_should_stop+0x50/0x50
>> Jul  8 07:44:53 box3 kernel: [<ffffffff81405510>] ? gs_change+0xb/0xb
>> Jul  8 07:44:53 box3 kernel: handlers:
>> Jul  8 07:44:53 box3 kernel: [<ffffffff810939d0>] irq_default_primary_handler threaded [<ffffffff812c7bb0>] usb_hcd_irq
>> Jul  8 07:44:53 box3 kernel: [<ffffffff810939d0>] irq_default_primary_handler threaded [<ffffffff812c7bb0>] usb_hcd_irq
>> Jul  8 07:44:53 box3 kernel: [<ffffffff810939d0>] irq_default_primary_handler threaded [<ffffffff812c7bb0>] usb_hcd_irq
>> Jul  8 07:44:53 box3 kernel: Disabling IRQ #18
>> Jul  8 07:44:53 box3 kernel: pwc: Iso frame 0 has error -114
>> Jul  8 07:44:53 box3 kernel: pwc: Iso frame 1 has error -18
>> Jul  8 07:44:53 box3 kernel: pwc: Iso frame 2 has error -18
>> Jul  8 07:44:53 box3 kernel: pwc: Iso frame 3 has error -18
>> Jul  8 07:44:53 box3 kernel: pwc: Iso frame 4 has error -18
>> Jul  8 07:44:53 box3 kernel: pwc: Iso frame 5 has error -18
>> (etc; many more of the pwc messages)
>>
>> Kind regards,
>> Udo
> 
> ... and, with apparently the same mainboard:

Over here:

        Manufacturer: Gigabyte Technology Co., Ltd.
        Product Name: GA-MA770-DS3

>> Motherboard is Gigabyte GA-990XA-UD3
>> CPU is AMD Bulldozer 6 Core version

AMD 9550 4 core in my case, i.e.: less new.
pwc driver is the main user for a webcam on USB.

>> I'll attach the 2 dmesg logs, one from 3.2 and other from 3.4,
>> hopefully someone can see what's wrong, there is a suggestion to boot
>> with irqpoll, but really wanted someone's opinion on this.

Any ideas why the IRQ stops working?

Udo

