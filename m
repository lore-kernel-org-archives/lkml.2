Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750927Ab2L3FfV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2012 00:35:21 -0500
Received: from mail-qc0-f181.google.com ([209.85.216.181]:50389 "EHLO
	mail-qc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750735Ab2L3FfS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2012 00:35:18 -0500
MIME-Version: 1.0
In-Reply-To: <22263901.MJnoQmEgLn@vostro.rjw.lan>
References: <CAAAKZwsU=jMb6SCvUrAZqRn-uD8HNX3cJ8VFqrG-dqiOoW3+QQ@mail.gmail.com>
 <22263901.MJnoQmEgLn@vostro.rjw.lan>
From: Tim Hockin <thockin@hockin.org>
Date: Sat, 29 Dec 2012 21:34:57 -0800
X-Google-Sender-Auth: 0X5fVYjG2xesvtdGztf-KavCJVI
Message-ID: <CAAAKZwsn8cYURZZ9dSAHqUzAFGXQBU_jNYBsX30rvAMZfZvdFw@mail.gmail.com>
Subject: Re: kernel panic on resume from S3 - stumped
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-kernel@vger.kernel.org, Pavel Machek <pavel@ucw.cz>,
        Linux PM list <linux-pm@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Running a suspend with pm_trace set, I get:

aer 0000:00:03.0:pcie02: hash matches

I don't know what magic might be needed here, though.

I guess next step is to try to build a non-distro kernel.

On Sat, Dec 29, 2012 at 1:57 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Saturday, December 29, 2012 12:03:13 PM Tim Hockin wrote:
>> 4 days ago I had Ubuntu Lucid running on this computer. Suspend and
>> resume worked flawlessly every time.
>>
>> Then I upgraded to Ubuntu Precise.
>
> Well, do you use a distro kernel or a kernel.org kernel?
>
>> Suspend seems to work, but resume
>> fails every time. The video never initializes.  By the flashing
>> keyboard lights, I guess it's a kernel panic. It fails from the Live
>> CD and from a fresh install.
>>
>> Here is my debug so far.
>>
>> Install all updates (3.2 kernel, nouveau driver)
>> Reboot
>> Try suspend = fails
>>
>> Install Ubuntu's linux-generic-lts-quantal (3.5 kernel, nouveau driver)
>> Reboot
>> Try suspend = fails
>>
>> Install nVidia's 304 driver
>> Reboot
>> Try suspend = fails
>>
>> From within X:
>>   echo core > /sys/power/pm_test
>>   echo mem > /sys/power/state
>> The system acts like it is going to sleep, and then wakes up a few
>> seconds later. dmesg shows:
>>
>> [ 1230.083404] ------------[ cut here ]------------
>> [ 1230.083410] WARNING: at
>> /build/buildd/linux-lts-quantal-3.5.0/kernel/power/suspend_test.c:53
>> suspend_test_finish+0x86/0x90()
>> [ 1230.083411] Hardware name: To Be Filled By O.E.M.
>> [ 1230.083412] Component: resume devices, time: 14424
>> [ 1230.083412] Modules linked in: snd_emu10k1_synth snd_emux_synth
>> snd_seq_virmidi snd_seq_midi_emul bnep rfcomm parport_pc ppdev
>> nvidia(PO) snd_emu10k1 snd_ac97_codec ac97_bus snd_pcm snd_page_alloc
>> snd_util_mem snd_hwdep snd_seq_midi snd_rawmidi snd_seq_midi_event
>> snd_seq snd_timer coretemp snd_seq_device kvm_intel kvm snd
>> ghash_clmulni_intel soundcore aesni_intel btusb cryptd aes_x86_64
>> bluetooth i7core_edac edac_core microcode mac_hid lpc_ich mxm_wmi
>> shpchp serio_raw wmi hid_generic lp parport usbhid hid r8169
>> pata_marvell
>> [ 1230.083445] Pid: 3329, comm: bash Tainted: P O 3.5.0-21-generic
>> #32~precise1-Ubuntu
>> [ 1230.083446] Call Trace:
>> [ 1230.083448] [<ffffffff81052c9f>] warn_slowpath_common+0x7f/0xc0
>> [ 1230.083452] [<ffffffff81052d96>] warn_slowpath_fmt+0x46/0x50
>> [ 1230.083455] [<ffffffff8109b836>] suspend_test_finish+0x86/0x90
>> [ 1230.083457] [<ffffffff8109b53b>] suspend_devices_and_enter+0x10b/0x200
>> [ 1230.083460] [<ffffffff8109b701>] enter_state+0xd1/0x100
>> [ 1230.083463] [<ffffffff8109b74b>] pm_suspend+0x1b/0x60
>> [ 1230.083465] [<ffffffff8109a7a5>] state_store+0x45/0x70
>> [ 1230.083467] [<ffffffff81331d2f>] kobj_attr_store+0xf/0x30
>> [ 1230.083471] [<ffffffff811f77ff>] sysfs_write_file+0xef/0x170
>> [ 1230.083476] [<ffffffff811879d3>] vfs_write+0xb3/0x180
>> [ 1230.083480] [<ffffffff81187cfa>] sys_write+0x4a/0x90
>> [ 1230.083483] [<ffffffff816a6e69>] system_call_fastpath+0x16/0x1b
>> [ 1230.083488] ---[ end trace 839cdd0078b3ce03 ]---
>>
>> Boot with init=/bin/bash
>> unload all modules except USBHID
>> echo core > /sys/power/pm_test
>> echo mem > /sys/power/state
>> system acts like it is going to sleep, and then wakes up a few seconds later
>> echo none > /sys/power/pm_test
>> echo mem > /sys/power/state
>> system goes to sleep
>> press power to resume = fails
>>
>> At this point I am stumped on how to debug. This is a "modern"
>> computer with no serial ports. It worked under Lucid, so I know it is
>> POSSIBLE.
>>
>> Mobo: ASRock X58 single-socket
>> CPU: Westmere 6 core (12 hyperthreads) 3.2 GHz
>> RAM: 12 GB ECC
>> Disk: sda = Intel SSD, mounted on /
>> Disk: sdb = Intel SSD, not mounted
>> Disk: sdc = Seagate HDD, not mounted
>> Disk: sdd = Seagate HDD, not mounted
>> NIC = Onboard RTL8168e/8111e
>> Sound = EMU1212 (emu10k1, not even configured yet)
>> Video = nVidia GeForce 7600 GT
>> KB = PS2 (also tried USB)
>> Mouse = USB
>>
>> I have not updated to a more current kernel than 3.5, but I will if
>> there's evidence that this is resolved.  Any other clever trick to
>> try?
>
> There is no evidence and there won't be if you don't try a newer kernel.
>
> Thanks,
> Rafael
>
>
> --
> I speak only for myself.
> Rafael J. Wysocki, Intel Open Source Technology Center.
