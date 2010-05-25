Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758867Ab0EYQjb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 12:39:31 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:55341 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754168Ab0EYQj3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 12:39:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=sLNspy52pBiCCD5y+VzTCyGlco0rAjnHB/sp0XNzFheqKemcEtuYXIPwa6LCUKNdYz
         1/U93R2ZsDbMg/iMUwfpnNk9QkrRoR1urQarwQSVJwB3wfneNkBTACHTkureZWynDVF5
         nREqiV671GzWdGFIREGuE9UPhtKTacA3P5oNQ=
Date: Tue, 25 May 2010 09:39:20 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: iwl3945 dies (oops) in post 2.6.34 kernels
Message-ID: <20100525163920.GA2730@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I am getting the following crashers in iwl3945 after updating to
post-2.6.34 kernels. This is with the pull from Linus's tree as of last
night (the taint is from nvidia module):

[ 3330.630734] general protection fault: 0000 [#1] PREEMPT SMP 
[ 3330.630752] last sysfs file: /sys/devices/platform/dock.0/docked
[ 3330.630761] CPU 0 
[ 3330.630766] Modules linked in: cryptd aes_x86_64 aes_generic fuse rfcomm sco bnep l2cap autofs4
coretemp hwmon sunrpc ppdev parport_pc parport acpi_cpufreq mperf uinput nvidia(P) snd_hda_codec_idt
arc4 snd_hda_intel ecb snd_hda_codec snd_hwdep iwl3945 joydev snd_seq snd_seq_device snd_pcm iwlcore
mac80211 snd_timer cfg80211 snd psmouse iTCO_wdt dell_wmi iTCO_vendor_support serio_raw tg3 battery
dell_laptop dcdbas soundcore snd_page_alloc btusb bluetooth video pcspkr mac_hid ac wmi libphy
firewire_ohci i2c_i801 firewire_core yenta_socket crc_itu_t ohci_hcd [last unloaded: microcode]
[ 3330.630950] 
[ 3330.630958] Pid: 455, comm: iwl3945 Tainted: P            2.6.35-rc0 #293 0WM416/Latitude D630                   
[ 3330.630967] RIP: 0010:[<ffffffffa01e70d3>]  [<ffffffffa01e70d3>] iwl3945_get_channels_for_scan+0xe3/0x460 [iwl3945]
[ 3330.630993] RSP: 0018:ffff8801126b1c10  EFLAGS: 00010297
[ 3330.631001] RAX: ffff8800b2853c00 RBX: 0000000000000000 RCX: 0002079700220078
[ 3330.631009] RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffff880112641aa0
[ 3330.631016] RBP: ffff8801126b1cc0 R08: ffff88010c22d0f2 R09: 0000000000000000
[ 3330.631024] R10: 0000000000000000 R11: 0000000000000001 R12: 0000000000000001
[ 3330.631032] R13: ffff880112641aa0 R14: ffff88010c22d0f2 R15: 0000000000000000
[ 3330.631040] FS:  0000000000000000(0000) GS:ffff880002600000(0000) knlGS:0000000000000000
[ 3330.631049] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 3330.631056] CR2: 0000000005d03000 CR3: 0000000001806000 CR4: 00000000000006f0
[ 3330.631064] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 3330.631072] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 3330.631081] Process iwl3945 (pid: 455, threadinfo ffff8801126b0000, task ffff880115ab3fa0)
[ 3330.631087] Stack:
[ 3330.631092]  0000000000000000 ffffffffa01e7980 ffff880100000000 ffffffff814932ad
[ 3330.631106] <0> ffff8801126424c0 ffff880115ab3fa0 ffffffff00000000 0000005800000016
[ 3330.631123] <0> ffff8801126b1fd8 0058ffff00575231 ffff8801126b1fd8 0000000000000001
[ 3330.631143] Call Trace:
[ 3330.631161]  [<ffffffffa01e7980>] ? iwl3945_request_scan+0x3f0/0xb40 [iwl3945]
[ 3330.631178]  [<ffffffff814932ad>] ? _raw_spin_unlock_irqrestore+0x3d/0x70
[ 3330.631190]  [<ffffffff81496dfd>] ? sub_preempt_count+0x9d/0xd0
[ 3330.631206]  [<ffffffffa01e7ac4>] iwl3945_request_scan+0x534/0xb40 [iwl3945]
[ 3330.631233]  [<ffffffffa018bf60>] ? iwl_bg_start_internal_scan+0x0/0x320 [iwlcore]
[ 3330.631254]  [<ffffffffa018bf60>] ? iwl_bg_start_internal_scan+0x0/0x320 [iwlcore]
[ 3330.631274]  [<ffffffffa018c166>] iwl_bg_start_internal_scan+0x206/0x320 [iwlcore]
[ 3330.631288]  [<ffffffff81065f4c>] run_workqueue+0x12c/0x2a0
[ 3330.631298]  [<ffffffff81065efb>] ? run_workqueue+0xdb/0x2a0
[ 3330.631311]  [<ffffffff81066156>] worker_thread+0x96/0xf0
[ 3330.631323]  [<ffffffff8106b1c0>] ? autoremove_wake_function+0x0/0x40
[ 3330.631333]  [<ffffffff810660c0>] ? worker_thread+0x0/0xf0
[ 3330.631344]  [<ffffffff8106acae>] kthread+0x8e/0xa0
[ 3330.631356]  [<ffffffff81003d94>] kernel_thread_helper+0x4/0x10
[ 3330.631367]  [<ffffffff81035c24>] ? finish_task_switch+0x74/0xd0
[ 3330.631377]  [<ffffffff81493a40>] ? restore_args+0x0/0x30
[ 3330.631388]  [<ffffffff8106ac20>] ? kthread+0x0/0xa0
[ 3330.631398]  [<ffffffff81003d90>] ? kernel_thread_helper+0x0/0x10
[ 3330.631404] Code: b7 55 ce 89 55 88 41 8d 57 ff 45 89 d7 66 89 55 9a eb 10 0f 1f 44 00 00 ff c3
39 58 0c 0f 86 c5 00 00 00 48 63 d3 48 8b 4c d0 38 <44> 39 21 75 e8 0f b7 51 06 44 89 e6 41 88 56 01
48 89 4d 80 0f 
[ 3330.631505] RIP  [<ffffffffa01e70d3>] iwl3945_get_channels_for_scan+0xe3/0x460 [iwl3945]
[ 3330.631505]  RSP <ffff8801126b1c10>
[ 3330.631657] ---[ end trace faaae140797cc308 ]---

-- 
Dmitry
