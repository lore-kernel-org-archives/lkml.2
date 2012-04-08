Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753454Ab2DHH2o (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Apr 2012 03:28:44 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:44567 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753033Ab2DHH2n convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Apr 2012 03:28:43 -0400
From: Marko =?utf-8?q?H=C3=A4nninen?= <bugitus@gmail.com>
To: Andrei Emeltchenko <andrei.emeltchenko@gmail.com>
Subject: Re: 3.3.0: Oops when resuming from hibernation
Date: Sun, 8 Apr 2012 10:29:02 +0300
User-Agent: KMail/1.13.7 (Linux/3.3.0; KDE/4.8.2; x86_64; ; )
Cc: Alexander Holler <holler@ahsoftware.de>, linux-kernel@vger.kernel.org
References: <CAFAkhwi1YedRDt3ET1zK03uMNbDfCrV1TqWXo-HH=mbShVJy3Q@mail.gmail.com>
In-Reply-To: <CAFAkhwi1YedRDt3ET1zK03uMNbDfCrV1TqWXo-HH=mbShVJy3Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201204081029.03204.bugitus@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Andrei Emeltchenko kirjoitti lauantai, 7. huhtikuuta 2012 23:02:44:
> Hi,
> 07.04.2012 17:51 пользователь "Alexander Holler" <holler@ahsoftware.de>
> 
> написал:
> > Am 07.04.2012 14:18, schrieb Marko Hänninen:
> >> Hi,
> >> 
> >> 
> >> I'm getting oops, when my laptop is resuming from hibernation
> 
> (hibernated by KDE). If I hibernate again without reboot, it won't wake up
> anymore. My bluetooth mouse (Logitech V470) works before hibernation, but
> not after. I have to reboot
> 
> >> to make bluetooth work again.
> >> I can reproduce this oops with every hibernation. This is regression in
> 
> linux 3.3.0: bluetooth has worked correctly before (since 2.6 days to
> 3.2.14). The problem still exists with 3.3.1 (which introduces another
> problem with ath9k not
> 
> >> connecting to AP, which is why I'm stuck with 3.3.0)
> >> 
> >> 
> >> Oops:
> >> 
> >> [  237.991473] Bluetooth: unknown link type 44
> >> [  237.991478] BUG: unable to handle kernel paging request at
> 
> 000000004f80229e
> 
> >> [  237.991525] IP: [<000000004f80229e>] 0x4f80229d
> >> [  237.991555] PGD 0
> >> [  237.991570] Oops: 0010 [#1] PREEMPT SMP
> >> [  237.991598] CPU 2
> >> [  237.991611] Modules linked in: psmouse joydev sdhci_pci
> >> [  237.991650]
> >> [  237.991661] Pid: 517, comm: khubd Not tainted 3.3.0 #1
> 
> Hewlett-Packard HP ProBook 4730s/167C
> 
> >> [  237.991720] RIP: 0010:[<000000004f80229e>]  [<000000004f80229e>]
> 
> 0x4f80229d
> 
> >> [  237.991759] RSP: 0018:ffff880149e3fbd8  EFLAGS: 00010202
> 
> >> [  237.991785] RAX: 000000004f80229e RBX: ffff8801450c4000 RCX:
> 0000000000000013
> 
> >> [  237.991822] RDX: 0000000000000067 RSI: 0000000000000016 RDI:
> ffff8801450c4000
> 
> >> [  237.991857] RBP: ffff880145019638 R08: 0000000000000002 R09:
> 00000000fffffffe
> 
> >> [  237.991892] R10: 0000000000000000 R11: 000000000000032e R12:
> ffff8801450195d0
> 
> >> [  237.991927] R13: 0000000000000000 R14: ffffffff81a4c510 R15:
> ffffffff81a4c578
> 
> >> [  237.991973] FS:  0000000000000000(0000) GS:ffff88014f480000(0000)
> 
> knlGS:0000000000000000
> 
> >> [  237.992026] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> 
> >> [  237.992062] CR2: 000000004f80229e CR3: 0000000001a05000 CR4:
> 00000000000406e0
> 
> >> [  237.992088] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
> 0000000000000000
> 
> >> [  237.992112] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7:
> 0000000000000400
> 
> >> [  237.992139] Process khubd (pid: 517, threadinfo ffff880149e3e000,
> 
> task ffff88014a3739f0)
> 
> >> [  237.992167] Stack:
> >> [  237.992176]  ffffffff814fccc9 ffff8801466ee000 ffff8801450c4000
> 
> ffff880148706926
> 
> >> [  237.992206]  ffff880145019000 ffff880145019010 ffffffff814f9c9a
> 
> ffff88014a33d140
> 
> >> [  237.992238]  ffff880145019000 0000000000000000 ffff88014a32cc00
> 
> 0000000000000000
> 
> >> [  237.992269] Call Trace:
> >> [  237.992283]  [<ffffffff814fccc9>] ? hci_conn_hash_flush+0x7c/0x9d
> >> [  237.992306]  [<ffffffff814f9c9a>] ? hci_dev_do_close+0x10d/0x234
> >> [  237.992329]  [<ffffffff814fb44f>] ? hci_unregister_dev+0x54/0x13e
> >> [  237.992352]  [<ffffffff813cc76f>] ? btusb_disconnect+0x4a/0x8f
> >> [  237.992374]  [<ffffffff813702f7>] ? usb_unbind_interface+0x5b/0x126
> >> [  237.992398]  [<ffffffff812fa7e7>] ? __device_release_driver+0x7f/0xd0
> >> [  237.992423]  [<ffffffff812fa855>] ? device_release_driver+0x1d/0x2b
> >> [  237.992446]  [<ffffffff812fa43a>] ? bus_remove_device+0xd2/0xe7
> >> [  237.992469]  [<ffffffff812f840f>] ? device_del+0x11a/0x168
> >> [  237.992490]  [<ffffffff8136e847>] ? usb_disable_device+0x6b/0x15a
> >> [  237.992514]  [<ffffffff813688f8>] ? usb_disconnect+0x94/0x107
> >> [  237.992536]  [<ffffffff81369efb>] ? hub_thread+0x509/0xdeb
> >> [  237.992558]  [<ffffffff81050a38>] ? update_curr+0x67/0xaa
> >> [  237.992579]  [<ffffffff81040009>] ?
> 
> find_worker_executing_work+0xb/0x31
> 
> >> [  237.992604]  [<ffffffff81566051>] ? __schedule+0x40a/0x421
> >> [  237.992625]  [<ffffffff810456fa>] ? wake_up_bit+0x23/0x23
> >> [  237.992646]  [<ffffffff813699f2>] ? usb_remote_wakeup+0x2f/0x2f
> >> [  237.992668]  [<ffffffff813699f2>] ? usb_remote_wakeup+0x2f/0x2f
> >> [  237.992690]  [<ffffffff810452ed>] ? kthread+0x81/0x89
> >> [  237.992709]  [<ffffffff81568754>] ? kernel_thread_helper+0x4/0x10
> >> [  237.992732]  [<ffffffff8104526c>] ?
> 
> kthread_freezable_should_stop+0x37/0x37
> 
> >> [  237.992757]  [<ffffffff81568750>] ? gs_change+0xb/0xb
> >> [  237.992774] Code:  Bad RIP value.
> >> [  237.992790] RIP  [<000000004f80229e>] 0x4f80229d
> >> [  237.992809]  RSP<ffff880149e3fbd8>
> >> [  237.992821] CR2: 000000004f80229e
> >> [  238.144442] ---[ end trace 904a4682b9213a2e ]---
> >> 
> >> 
> >> 
> >> This is with vanilla 3.3.0 kernel, downloaded from kernel.org:
> >> Linux bugi 3.3.0 #1 SMP PREEMPT Sat Apr 7 13:23:08 EEST 2012 x86_64
> 
> Intel(R) Core(TM) i5-2410M CPU @ 2.30GHz GenuineIntel GNU/Linux
> 
> >> I'm not sure if this bug is in usb, bluetooth or hibernation, so I send
> 
> this mail to lkml.
> 
> >> I'm not subscribed to the list, so please CC me.
> > 
> > You might try that patch which removes a dead lock I had problems with:
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux.git;a=commit;h=e72
> acc13c770a82b4ce4a07e9716f29320eae0f8
> 
> > See the thread here:
> > 
> > https://lkml.org/lkml/2012/4/2/62
> 
> You can check also this:
> 
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux.git;a=commitdiff;h
> =3c4e0df028935618d052235ba85bc7079be13394
> 
> -- Andrei


This one fixed it: 
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux.git;a=commitdiff;h=3c4e0df028935618d052235ba85bc7079be13394

Thank you very much!


As this patch fixes an oops on my machine with 3.3.0, I think it should be sent 
to stable 3.3 series.


Marko Hänninen
bugitus (at) gmail (dot) com
