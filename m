Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752877Ab1DEJ3x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 05:29:53 -0400
Received: from ftp.sofha.de ([82.144.60.99]:58377 "EHLO ftp.sofha.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750920Ab1DEJ3w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 05:29:52 -0400
Message-ID: <4D9AE10E.3080501@snafu.de>
Date: Tue, 05 Apr 2011 11:29:50 +0200
From: Oncaphillis <oncaphillis@snafu.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.39.b3pre.fc14 Thunderbird/3.1.9
MIME-Version: 1.0
To: Xiaofan Chen <xiaofanc@gmail.com>
CC: libusb-devel@lists.sourceforge.net,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [Libusb-devel] Kernel bug message and missing data on	libusb_interrupt_transfer
References: <4D99B60D.3030009@snafu.de>	<BANLkTi=mU=v_6gH_5VCwZZmiX+UoqAVf+w@mail.gmail.com> <4D99C83A.2080807@snafu.de>
In-Reply-To: <4D99C83A.2080807@snafu.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/04/2011 03:31 PM, Oncaphillis wrote:
>    Thanks for the reply.
>
> I'm in an environment where we are
> reluctant to switch between versions. I had a hard time to
> argue for 0.1.x to 1.0.x transition. We saw the same bug (or at least
> kernel freezes in 0.1.x) I'll give 1.0.8 a try and report back.
>    Using a git pull isn't an option for us for political reasons.
>
> Thanks
>
> O.
>
>
> On 04/04/2011 03:06 PM, Xiaofan Chen wrote:
>> On Mon, Apr 4, 2011 at 8:14 PM, Oncaphillis<oncaphillis@snafu.de>   wrote:
>>> Hi,
>>>
>>>    We are experiencing sporadic kernel bug messages and total
>>> kernel freezes on usb communication via libusb-1.0.6.
>> First thing first, why not try the latest release version which
>> is libusb-1.08?
>>
>> Or better yet, try the latest git from libusb-stuge branch
>> which has quite some fixes post 1.08.
>> http://git.libusb.org/?p=libusb-stuge.git;a=summary;js=1
>>
Ok -- tried libusb 1.0.8.

Now I get

<snip>
------------[ cut here ]------------
kernel BUG at mm/slub.c:2808!
invalid opcode: 0000 [#2] SMP
last sysfs file: 
/sys/devices/pci0000:00/0000:00:1d.7/usb2/2-3/bConfigurationValue
CPU 1
Modules linked in:
Pid: 14293, comm: E25Stress Tainted: G      D    2.6.30.10 #2 To Be 
Filled By O.E.M.
RIP: 0010:[<ffffffff8028d2f8>]  [<ffffffff8028d2f8>] kfree+0x7c/0xdb
RSP: 0000:ffff88007847fb98  EFLAGS: 00010246
RAX: 4000000000000000 RBX: ffff880077c4a772 RCX: 0000000009f110a0
RDX: ffffe20000000000 RSI: ffffe20001a33030 RDI: ffff880077c4a772
RBP: ffff88007847fbb8 R08: ffff8800650dda40 R09: 00000000ffe1caa8
R10: ffff88007847e000 R11: 0000000000000000 R12: ffff88007b43fe40
R13: ffffffff80523871 R14: 0000000009f11080 R15: 00000000ffe1ca90
FS:  0000000000000000(0000) GS:ffff880001029000(0063) knlGS:00000000558356d0
CS:  0010 DS: 002b ES: 002b CR0: 000000008005003b
CR2: 0000000055577000 CR3: 000000007842c000 CR4: 00000000000406e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process E25Stress (pid: 14293, threadinfo ffff88007847e000, task 
ffff88007b46cec0)
Stack:
  ffffffff8029ee80 ffff88007b389e40 ffff88007b43fe40 ffff88007b389e40
  ffff88007847fbd8 ffffffff80523871 0000000000000000 ffff87fffffffffd
  ffff88007847fc18 ffffffff80523eee 0000000000200200 00000000ffffffff
Call Trace:
  [<ffffffff8029ee80>] ? __pollwait+0x0/0xbf
  [<ffffffff80523871>] free_async+0x22/0x47
  [<ffffffff80523eee>] processcompl_compat+0xe3/0x108
  [<ffffffff8052611f>] usbdev_ioctl+0x114f/0x157d
  [<ffffffff8029a046>] ? __link_path_walk+0x130/0xc32
  [<ffffffff802299e6>] ? dequeue_task_fair+0x13e/0x14d
  [<ffffffff80209b30>] ? __switch_to+0x13d/0x269
  [<ffffffff8029ce8e>] vfs_ioctl+0x6a/0x82
  [<ffffffff8029d2be>] do_vfs_ioctl+0x418/0x459
  [<ffffffff80246a12>] ? hrtimer_try_to_cancel+0x67/0x72
  [<ffffffff8029d341>] sys_ioctl+0x42/0x65
  [<ffffffff802c2cfd>] do_ioctl32_pointer+0xb/0xd
  [<ffffffff802c4790>] compat_sys_ioctl+0x2fa/0x34a
  [<ffffffff8029ddac>] ? poll_select_set_timeout+0x61/0x7c
  [<ffffffff80225602>] ia32_sysret+0x0/0xa
Code: ba 00 00 00 00 00 e2 ff ff 48 c1 e8 0c 48 6b f0 38 48 01 d6 66 83 
3e 00 79 04 48 8b 76 10 48 8b 06 84 c0 78 14 66 a9 00 c0 75 04 <0f> 0b 
eb fe 48 89 f7 e8 35 13 fe ff eb 48 48 8b 4d 08 48 8b 7e
RIP  [<ffffffff8028d2f8>] kfree+0x7c/0xdb
  RSP <ffff88007847fb98>
---[ end trace 840ffcb16d410ea4 ]---
</snip>

Suprisingly now the kernel is reported as tainted although there isn't 
any module inserted the
The timing seems to be the same as can be seen under 
http://oncaphillis.net/usb.pdf
but now we actually read data, but it's not the #72A7 sequence we are 
expecting.

Thanks
O.


>>>    We are currently under kernel 2.6.30.10 but have seen
>>> it also under older and newer kernel (I think the newest was
>>> a 2.6.36.x).
>>>
>>
>
> ------------------------------------------------------------------------------
> Create and publish websites with WebMatrix
> Use the most popular FREE web apps or write code yourself;
> WebMatrix provides all the features you need to develop and
> publish your website. http://p.sf.net/sfu/ms-webmatrix-sf
> _______________________________________________
> Libusb-devel mailing list
> Libusb-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/libusb-devel

