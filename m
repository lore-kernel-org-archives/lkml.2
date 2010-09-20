Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756187Ab0ITJnm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 05:43:42 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:35760 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754485Ab0ITJnk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 05:43:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=g6OfNe1NXL393wXR/EwyhPlObJ+5OyXEhq24/9JBvyF1lMuZdAx9pwx3fwKXdPXs6T
         zmyGOqCTFKhbao1nZ6JKVMcVXONavpJPbwLYPvfb4AJAtMiwHSgSY2jb19rT0hfKysm8
         QO2u2DIdPDfOf/wW0pQB2fKr1Lt9uwAIClKLI=
MIME-Version: 1.0
In-Reply-To: <4C96B9DB.8030403@turmel.org>
References: <4C96B9DB.8030403@turmel.org>
Date: Mon, 20 Sep 2010 11:43:38 +0200
Message-ID: <AANLkTi=1zh4hD-1uzpgjAsnKZBE=qi_ZAX-ug=2XMkW0@mail.gmail.com>
Subject: Re: [BUG, Regression, bisected] USB mouse causes bug on 1st insert,
 ignored on 2nd insert, lsusb stuck at usbdev_open
From: Guillaume Chazarain <guichaz@gmail.com>
To: Phil Turmel <philip@turmel.org>
Cc: Jiri Kosina <jkosina@suse.cz>, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Alan Stern <stern@rowland.harvard.edu>,
        Oliver Neukum <oliver@neukum.org>, Alan Ott <alan@signal11.us>,
        linux-usb@vger.kernel.org, linux-input@vger.kernel.org,
        Mat <jackdachef@gmail.com>, Andreas Bombe <aeb@debian.org>,
        Alex Riesen <raa.lkml@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ + Mat <jackdachef@gmail.com>, Andreas Bombe <aeb@debian.org>, Alex
Riesen <raa.lkml@gmail.com> ]

On Mon, Sep 20, 2010 at 3:33 AM, Phil Turmel <philip@turmel.org> wrote:
> A new regression was introduced between -rc3 and -rc4:
>
> The USB mouse I use with my laptop is causing a BUG when inserted.  It works at that
> point, but if removed and re-inserted, it is ignored.  Also, after the 2nd insert,
> other USB devices (like my thumb drive) are also ignored.
>
> [   37.450777] BUG: unable to handle kernel NULL pointer dereference at (null)
> [   37.451148] IP: [<ffffffff817d0991>] hiddev_open+0xc1/0x220
> [   37.452036] PGD 1131a0067 PUD 113036067 PMD 0
> [   37.452924] Oops: 0000 [#1] PREEMPT SMP
> [   37.453336] last sysfs file: /sys/devices/platform/toshiba_acpi/backlight/toshiba/max_brightness
> [   37.453336] CPU 1
> [   37.453336] Modules linked in: tpm_infineon iwlagn iwlcore tifm_7xx1 tpm_tis toshiba_bluetooth toshiba_acpi tifm_core pcmcia sdhci_pci yenta_socket sdhci [last unloaded: scsi_wait_scan]
> [   37.453336]
> [   37.453336] Pid: 3117, comm: hald-probe-hidd Not tainted 2.6.36-rc4-00166-g151b6a5 #28 Portable PC/TECRA A9
> [   37.453336] RIP: 0010:[<ffffffff817d0991>]  [<ffffffff817d0991>] hiddev_open+0xc1/0x220
> [   37.453336] RSP: 0018:ffff8801130e7c28  EFLAGS: 00010286
> [   37.453336] RAX: 00000000ffffffed RBX: ffff8801121a0000 RCX: 0000000000000000
> [   37.453336] RDX: 0000000000000000 RSI: ffffffff81cfbfaa RDI: ffff8801121ac030
> [   37.453336] RBP: ffff8801130e7c58 R08: 0000000000000010 R09: 0000000000000000
> [   37.453336] R10: 0000000000000000 R11: 0000000000000000 R12: ffff8801131c10c0
> [   37.453336] R13: 0000000000000000 R14: 00000000ffffffed R15: ffff88013820ac68
> [   37.453336] FS:  00007f3987315700(0000) GS:ffff880002500000(0000) knlGS:0000000000000000
> [   37.453336] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [   37.453336] CR2: 0000000000000000 CR3: 0000000112188000 CR4: 00000000000006e0
> [   37.453336] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [   37.453336] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> [   37.453336] Process hald-probe-hidd (pid: 3117, threadinfo ffff8801130e6000, task ffff8801399186b0)
> [   37.453336] Stack:
> [   37.453336]  ffff8801130e6000 00000000000000b4 ffff8801131c10c0 ffffffff81b57c20
> [   37.453336] <0> ffffffff81b66420 00000000ffffffed ffff8801130e7c98 ffffffff8171794b
> [   37.453336] <0> 000000000029d5f6 ffff88013b345d00 ffff88013820ac68 ffff8801131c10c0
> [   37.453336] Call Trace:
> [   37.453336]  [<ffffffff8171794b>] usb_open+0x10b/0x2b0
> [   37.453336]  [<ffffffff81156ae0>] ? chrdev_open+0x0/0x280
> [   37.453336]  [<ffffffff81156c07>] chrdev_open+0x127/0x280
> [   37.453336]  [<ffffffff81156ae0>] ? chrdev_open+0x0/0x280
> [   37.453336]  [<ffffffff81151508>] __dentry_open+0x108/0x3a0
> [   37.453336]  [<ffffffff811518b4>] nameidata_to_filp+0x54/0x70
> [   37.453336]  [<ffffffff8115f668>] do_last+0x3b8/0x6c0
> [   37.453336]  [<ffffffff811618a8>] do_filp_open+0x228/0x670
> [   37.453336]  [<ffffffff81919ac5>] ? T.827+0x135/0x230
> [   37.453336]  [<ffffffff8116c4aa>] ? alloc_fd+0xfa/0x140
> [   37.453336]  [<ffffffff811512c5>] do_sys_open+0x65/0x130
> [   37.453336]  [<ffffffff811513d0>] sys_open+0x20/0x30
> [   37.453336]  [<ffffffff81037c1b>] system_call_fastpath+0x16/0x1b
> [   37.453336] Code: 30 c0 00 00 48 c7 c6 aa bf cf 81 e8 9a 7d 8d ff 4c 89 ab 18 c0 00 00 b8 ed ff ff ff 49 89 9c 24 98 00 00 00 48 8b 93 18 c0 00 00 <44> 8b 02 45 85 c0 0f 84 a8 00 00 00 8b 42 04 8d 48 01 85 c0 89
> [   37.453336] RIP  [<ffffffff817d0991>] hiddev_open+0xc1/0x220
> [   37.453336]  RSP <ffff8801130e7c28>
> [   37.453336] CR2: 0000000000000000
> [   37.495310] ---[ end trace a76b3a74914412d8 ]---
>
> I bisected this phenomenon to:
>
> 8fe294caf8c868edd9046251824a0af91991bf43 is the first bad commit
> commit 8fe294caf8c868edd9046251824a0af91991bf43
> Author: Guillaume Chazarain <guichaz@gmail.com>
> Date:   Sun Sep 12 21:32:35 2010 +0200
>
>    HID: fix hiddev's use of usb_find_interface
>
>    My macbook infrared remote control was broken by commit
>    bd25f4dd6972755579d0ea50d1a5ace2e9b00d1a ("HID: hiddev: use
>    usb_find_interface, get rid of BKL").
>
>    This device appears in dmesg as:
>    apple 0003:05AC:8242.0001: hiddev0,hidraw0: USB HID v1.11 Device
>    [Apple Computer, Inc. IR Receiver] on usb-0000:00:1d.2-1/input0
>
>    It stopped working as lircd was getting ENODEV when opening /dev/usb/hiddev0.
>
>    AFAICS hiddev_driver is a dummy driver so usb_find_interface(&hiddev_driver)
>    does not find anything.
>
>    The device is associated with the usbhid driver, so let's do
>    usb_find_interface(&hid_driver) instead.
>
>    $ ls -l /sys/devices/pci0000:00/0000:00:1d.2/usb7/7-1/7-1:1.0/usb/hiddev0/device/driver
>    lrwxrwxrwx 1 root root 0 2010-09-12 16:28 /sys/devices/pci0000:00/0000:00:1d.2/usb7/7-1/7-1:1.0/usb/hiddev0/device/driver -> ../../../../../../bus/usb/drivers/usbhid
>
>    Signed-off-by: Guillaume Chazarain <guichaz@gmail.com>
>    Signed-off-by: Jiri Kosina <jkosina@suse.cz>
>
> :040000 040000 a7db28b9b84792aa51a1027daebb627150892837 84209dde8d0d2ef3c1d58a20586060947890fc80 M      drivers
>
> lsusb also gets stuck like so:
>
> # cat /proc/4306/stack
> [<ffffffff81719e3c>] usbdev_open+0x11c/0x2e0
> [<ffffffff81156c07>] chrdev_open+0x127/0x280
> [<ffffffff81151508>] __dentry_open+0x108/0x3a0
> [<ffffffff811518b4>] nameidata_to_filp+0x54/0x70
> [<ffffffff8115f668>] do_last+0x3b8/0x6c0
> [<ffffffff811618a8>] do_filp_open+0x228/0x670
> [<ffffffff811512c5>] do_sys_open+0x65/0x130
> [<ffffffff811513d0>] sys_open+0x20/0x30
> [<ffffffff81037c1b>] system_call_fastpath+0x16/0x1b
> [<ffffffffffffffff>] 0xffffffffffffffff
>
> The commit 8fe294c reverts cleanly from 2.6.36-rc4-00166-g151b6a5, and solves this
> problem.
>
> Config, dmesg, and lsusb (after revert) are attached.
>
> The system is Gentoo unstable 64bit, w/ hal-0.5.14-r2 and udev-161.
>
> I'm happy to test patches in lieu of a revert, since it was a fix to a
> different regression.

One difference between the regression I originally reported and the
current one is that I was using the "apple" hid_driver while all the
regressions caused by my patch use the "generic" hid_driver.
Can you send the output of 'sudo ls -lR /sys | bzip2'?

Thanks.

-- 
Guillaume
