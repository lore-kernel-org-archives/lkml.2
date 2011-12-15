Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759023Ab1LOR4o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 12:56:44 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:65279 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751544Ab1LOR4m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 12:56:42 -0500
Message-ID: <4EEA34D7.9030109@gmail.com>
Date: Thu, 15 Dec 2011 18:56:39 +0100
From: Julian Sikorski <belegdol@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: Clemens Ladisch <clemens@ladisch.de>
CC: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: bug report: irq 19: nobody cared (try booting with the "irqpoll"
 option)
References: <4EEA0485.4050105@gmail.com> <4EEA0521.2030502@gmail.com> <4EEA18A8.5030603@ladisch.de> <4EEA1A81.6030807@gmail.com> <4EEA331F.1060201@ladisch.de>
In-Reply-To: <4EEA331F.1060201@ladisch.de>
X-Enigmail-Version: 1.3.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

W dniu 15.12.2011 18:49, Clemens Ladisch pisze:
> Julian Sikorski wrote:
>> W dniu 15.12.2011 16:56, Clemens Ladisch pisze:
>>> Julian, try disabling DMAR (probably called IOMMU or something related
>>> to virtualization) in the BIOS.
>>
>> There is no such option or anything even remotely related in the BIOS
> 
> Then add the kernel parameter intel_iommu=off to the boot loader.
> 
> 
> Regards,
> Clemens
This did not work (I have nvidia.ko loaded now, but as I have shown
before the issue can be reproduced without it too):

$ dmesg | grep mmu
[    0.000000] Command line: BOOT_IMAGE=/vmlinuz-3.1.5-2.fc16.x86_64
root=/dev/mapper/vg_snowball2-lv_root ro rd.lvm.lv=vg_snowball2/lv_swap
rd.md=0 rd.dm=0 quiet SYSFONT=latarcyrheb-sun16 rhgb
rd.lvm.lv=vg_snowball2/lv_root rd.luks=0 LANG=pl_PL.UTF-8 KEYTABLE=pl2
nouveau.modeset=0 rd.driver.blacklist=nouveau intel_iommu=off
[    0.000000] Kernel command line:
BOOT_IMAGE=/vmlinuz-3.1.5-2.fc16.x86_64
root=/dev/mapper/vg_snowball2-lv_root ro rd.lvm.lv=vg_snowball2/lv_swap
rd.md=0 rd.dm=0 quiet SYSFONT=latarcyrheb-sun16 rhgb
rd.lvm.lv=vg_snowball2/lv_root rd.luks=0 LANG=pl_PL.UTF-8 KEYTABLE=pl2
nouveau.modeset=0 rd.driver.blacklist=nouveau intel_iommu=off

irq 19: nobody cared (try booting with the "irqpoll" option)
Pid: 0, comm: swapper Tainted: P            3.1.5-2.fc16.x86_64 #1
Call Trace:
 <IRQ>  [<ffffffff810dc87d>] __report_bad_irq+0x3d/0xe0
 [<ffffffff810dcb3d>] note_interrupt+0x16d/0x220
 [<ffffffff8101a4f3>] ? native_sched_clock+0x13/0x80
 [<ffffffff810da8f9>] handle_irq_event_percpu+0xa9/0x220
 [<ffffffff810daab4>] handle_irq_event+0x44/0x70
 [<ffffffff810dd49f>] handle_fasteoi_irq+0x5f/0xf0
 [<ffffffff810151e9>] handle_irq+0x49/0xa0
 [<ffffffff815db6da>] do_IRQ+0x5a/0xe0
 [<ffffffff815d116e>] common_interrupt+0x6e/0x6e
 <EOI>  [<ffffffff8130179b>] ? intel_idle+0xcb/0x120
 [<ffffffff8130177d>] ? intel_idle+0xad/0x120
 [<ffffffff814803c6>] cpuidle_idle_call+0xc6/0x280
 [<ffffffff81012225>] cpu_idle+0xc5/0x120
 [<ffffffff815ab0ee>] rest_init+0x72/0x74
 [<ffffffff81b7ec0a>] start_kernel+0x3b5/0x3c0
 [<ffffffff81b7e347>] x86_64_start_reservations+0x132/0x136
 [<ffffffff81b7e140>] ? early_idt_handlers+0x140/0x140
 [<ffffffff81b7e44d>] x86_64_start_kernel+0x102/0x111

Julian
