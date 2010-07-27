Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755843Ab0G0Ins (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 04:43:48 -0400
Received: from hera.kernel.org ([140.211.167.34]:39750 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753914Ab0G0Inq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jul 2010 04:43:46 -0400
Message-ID: <4C4E9C3B.9070402@kernel.org>
Date: Tue, 27 Jul 2010 10:43:39 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.4) Gecko/20100608 Thunderbird/3.1
MIME-Version: 1.0
To: Nils Radtke <lkml@Think-Future.de>
CC: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: ata_port_flush_task, BUG: unable to handle kernel paging request
References: <20100725154816.GF31966@localhost>
In-Reply-To: <20100725154816.GF31966@localhost>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 27 Jul 2010 08:43:42 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(cc'ing linux-ide)
Hello,

On 07/25/2010 05:48 PM, Nils Radtke wrote:
>   Hi,
> 
> Ideas, anybody?
> 
> BUG: unable to handle kernel paging request at 10ec83c6
> IP: [<c13b8880>] ata_port_flush_task+0x0/0x50
> *pde = 00000000 
> Oops: 0002 [#1] PREEMPT 
> last sysfs file: /sys/devices/pci0000:00/0000:00:1c.0/0000:02:00.0/net/eth0/carrier
> Modules linked in: snd_usb_audio snd_usb_lib snd_seq_midi snd_rawmidi uvcvideo option usbserial usb_storage video1394 raw1394 dv1394 firewire_ohci firewire_core ohci1394 ieee1394 tg3 libphy
> 
> Pid: 1298, comm: scsi_eh_0 Not tainted 2.6.33 #6 Columbia                       /Extensa 5220                   
> EIP: 0060:[<c13b8880>] EFLAGS: 00010292 CPU: 0
> EIP is at ata_port_flush_task+0x0/0x50
> EAX: f6878000 EBX: 00000246 ECX: 00000003 EDX: c13c7ab0
> ESI: f6813800 EDI: f6813844 EBP: 00000000 ESP: f6877f48
>  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
> Process scsi_eh_0 (pid: 1298, ti=f6876000 task=f70603f0 task.ti=f6876000)
> Stack:
>  c13c7aca c1852b50 f6acbc80 f6acbc80 c102fb3e f6acbc80 f70603f0 c184a5a0
> <0> f6813800 c184a400 f6878000 f70603f0 00000246 f6813800 f6813844 00000000
> <0> c138a5af 00000000 c13897b0 c102bd97 f70603f0 f70603f0 f6813834 f6813844
> Call Trace:
>  [<c13c7aca>] ? ata_scsi_error+0x1a/0x870
>  [<c102fb3e>] ? finish_task_switch+0x2e/0xa0
>  [<c138a5af>] ? scsi_error_handler+0x9f/0x3a0
>  [<c13897b0>] ? eh_lock_door_done+0x0/0x10
>  [<c102bd97>] ? pick_next_task_fair+0x97/0xe0
>  [<c1671f0a>] ? schedule+0x28a/0x3b0
>  [<c138a510>] ? scsi_error_handler+0x0/0x3a0
>  [<c104f3f4>] ? kthread+0x74/0x80
>  [<c104f380>] ? kthread+0x0/0x80
>  [<c1003236>] ? kernel_thread_helper+0x6/0x10
> Code: 18 00 00 b8 a5 f7 7b c1 e8 2e b8 c7 ff eb 81 8d b6 00 00 00 00 8d bf 00 00 00 00 83 c0 5c e8 48 d3 fb ff e9 43 ff ff ff 8d 76 00 <ff> 89 c3 83 ec 10 8d 80 75 1e 00 00 e8 bf 3d c9 ff f6 83 c4 1e 
> EIP: [<c13b8880>] ata_port_flush_task+0x0/0x50 SS:ESP 0068:f6877f48
> CR2: 0000000010ec83c6
> ---[ end trace 2f757ea4d01bedcf ]---

Which kernel version is this?  What was the configuration and what
were the system doing?  Can you please post lspci -nn output and boot
log?

-- 
tejun
