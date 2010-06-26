Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754945Ab0FZMWF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jun 2010 08:22:05 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:35631 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753485Ab0FZMWB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jun 2010 08:22:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=aQkMUYbHzxizBz1Y9aP4iCjTseXaR3tlmx3QSGBe7a/Epelyy5a8LtG7NsNTHeOIGf
         eh9gt+/aX0AM/yv+Z3RHUynqHSnnqNkIOiHtGwSKOunqyT5RKDBtQ5LCYPWcM4qaXnaz
         hsRrvbBJdTUJqg9/UtbgjVkrlwkrNjZXp+C9w=
MIME-Version: 1.0
In-Reply-To: <20100626075125.3d1711ff@tlielax.poochiereds.net>
References: <AANLkTilhTrEBYZd4HxeXQk8B6-yV8rCJ2C0jXsEREgIR@mail.gmail.com>
	<AANLkTimTmPEG-8gDKu7Xj8--LrXsF9oe-afbm0X_QHsX@mail.gmail.com>
	<20100626075125.3d1711ff@tlielax.poochiereds.net>
Date: Sat, 26 Jun 2010 22:22:00 +1000
Message-ID: <AANLkTikXz-zW3_nh0k941BPHWLJMN630l2R5sPoc35kC@mail.gmail.com>
Subject: Re: 2.6.34-rc3 BUG: unable to handle kernel NULL pointer dereference 
	at 0000000000000048 cifs_show_options
From: Andrew Hendry <andrew.hendry@gmail.com>
To: Jeff Layton <jlayton@samba.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, linux-cifs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have turned on cifs debug to try to catch it if happens again.

(gdb) list *(cifs_show_options+0xf9)
0x309 is in cifs_show_options (fs/cifs/cifsfs.c:336).
331	static void
332	cifs_show_address(struct seq_file *s, struct TCP_Server_Info *server)
333	{
334		seq_printf(s, ",addr=");
335	
336		switch (server->addr.sockAddr.sin_family) {
337		case AF_INET:
338			seq_printf(s, "%pI4", &server->addr.sockAddr.sin_addr.s_addr);
339			break;
340		case AF_INET6:




On Sat, Jun 26, 2010 at 9:51 PM, Jeff Layton <jlayton@samba.org> wrote:
> On Sat, 26 Jun 2010 20:47:33 +1000
> Andrew Hendry <andrew.hendry@gmail.com> wrote:
>
>> sorry, this should say 2.6.35-rc3
>>
>> On Sat, Jun 26, 2010 at 8:46 PM, Andrew Hendry <andrew.hendry@gmail.com> wrote:
>> > From 2.6.34-rc3
>> > Can't reliably reproduce, this was once after a resume over a few days
>> > normal use.
>> > The No response for cmds lines are normal as NAS takes a while to spin
>> > up after resume.
>> > System was unstable after message so couldn't collect more state
>> >
>> > [18446744028.633263] r8169 0000:0b:02.0: eth0: link up
>> > [18446744039.623540] eth0: no IPv6 routers present
>> > [18446744041.684522] CIFS VFS: No response for cmd 117 mid 21812
>> > [18446744041.684561] CIFS VFS: cifs_mount failed w/return code = -11
>> > [18446744056.674016] CIFS VFS: No response for cmd 114 mid 21813
>> > [18446744056.674105] CIFS VFS: cifs_mount failed w/return code = -112
>> > [18446744060.831668] BUG: unable to handle kernel NULL pointer
>> > dereference at 0000000000000048
>> > [18446744060.831680] IP: [<ffffffffa02982d9>]
>> > cifs_show_options+0xf9/0x480 [cifs]
>> > [18446744060.831699] PGD 2068fe067 PUD 2068fd067 PMD 0
>> > [18446744060.831710] Oops: 0000 [#1] PREEMPT SMP
>> > [18446744060.831720] last sysfs file:
>> > /sys/devices/system/cpu/sched_smt_power_savings
>> > [18446744060.831729] CPU 4
>> > [18446744060.831733] Modules linked in: nls_cp437 cifs fbcon tileblit
>> > font bitblit softcursor binfmt_misc kvm_intel kvm snd_hda_codec_via
>> > snd_hda_intel snd_hda_codec snd_hwdep snd_pcm_oss nouveau
>> > snd_mixer_oss snd_pcm snd_seq_dummy snd_seq_oss snd_seq_midi
>> > snd_rawmidi snd_seq_midi_event ttm psmouse snd_seq drm_kms_helper
>> > snd_timer snd_seq_device serio_raw snd drm asus_atk0110 soundcore
>> > snd_page_alloc i2c_algo_bit usbhid hid ahci r8169 mii libahci
>> > pata_jmicron
>> > [18446744060.831821]
>> > [18446744060.831829] Pid: 2206, comm: udisks-daemon Not tainted
>> > 2.6.35-rc3 #6 P7P55D-E PRO/System Product Name
>> > [18446744060.831836] RIP: 0010:[<ffffffffa02982d9>]
>> > [<ffffffffa02982d9>] cifs_show_options+0xf9/0x480 [cifs]
>> > [18446744060.831853] RSP: 0018:ffff880206913dc8  EFLAGS: 00010246
>> > [18446744060.831860] RAX: 0000000000000000 RBX: ffff880184a7f140 RCX:
>> > 0000000000000006
>> > [18446744060.831867] RDX: 0000000000000006 RSI: 0000000000001000 RDI:
>> > ffff880232fb0491
>> > [18446744060.831874] RBP: ffff880206913df8 R08: 000000000000fff8 R09:
>> > 0000000000000004
>> > [18446744060.831881] R10: 0000000000000000 R11: 0000000000000000 R12:
>> > ffff880231ad7400
>> > [18446744060.831888] R13: ffff8802324d7400 R14: ffff8802324d6b00 R15:
>> > 0000000000000000
>> > [18446744060.831896] FS:  00007fdb12ceb7a0(0000)
>> > GS:ffff880001e80000(0000) knlGS:0000000000000000
>> > [18446744060.831904] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> > [18446744060.831910] CR2: 0000000000000048 CR3: 00000002068fb000 CR4:
>> > 00000000000006e0
>> > [18446744060.831917] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
>> > 0000000000000000
>> > [18446744060.831924] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7:
>> > 0000000000000400
>> > [18446744060.831932] Process udisks-daemon (pid: 2206, threadinfo
>> > ffff880206912000, task ffff880236ae1680)
>> > [18446744060.831939] Stack:
>> > [18446744060.831942]  ffff880206913df8 0000000000000000
>> > ffff880184a7f140 ffff880184a7f140
>> > [18446744060.831954] <0> ffff8802324d6b00 ffff880231ad6400
>> > ffff880206913e68 ffffffff811575c7
>> > [18446744060.831966] <0> ffffffff8161b450 0000000000000202
>> > ffff8802318cac00 ffff88023fa6af00
>> > [18446744060.831980] Call Trace:
>> > [18446744060.831992]  [<ffffffff811575c7>] show_mountinfo+0x237/0x2b0
>> > [18446744060.832004]  [<ffffffff8115bc1f>] seq_read+0x25f/0x3f0
>> > [18446744060.832015]  [<ffffffff8113c9f5>] vfs_read+0xb5/0x180
>> > [18446744060.832024]  [<ffffffff8113de8f>] ? fget_light+0x7f/0xc0
>> > [18446744060.832033]  [<ffffffff8113d331>] sys_read+0x51/0x90
>> > [18446744060.832045]  [<ffffffff8100b0f2>] system_call_fastpath+0x16/0x1b
>> > [18446744060.832052] Code: 00 48 c7 c6 9a 7e 2c a0 48 89 df 31 c0 e8
>> > 80 32 ec e0 49 8b 45 28 48 c7 c6 b0 7e 2c a0 4c 8b 78 40 48 89 df 31
>> > c0 e8 67 32 ec e0 <41> 0f b7 47 48 66 83 f8 02 0f 84 98 01 00 00 66 83
>> > f8 0a 0f 84
>> > [18446744060.832164] RIP  [<ffffffffa02982d9>]
>> > cifs_show_options+0xf9/0x480 [cifs]
>> > [18446744060.832179]  RSP <ffff880206913dc8>
>> > [18446744060.832184] CR2: 0000000000000048
>> > [18446744060.832190] BUG: unable to handle kernel NULL pointer
>> > dereference at 0000000000000048
>> > [18446744060.832199] IP: [<ffffffffa02982d9>]
>> > cifs_show_options+0xf9/0x480 [cifs]
>> > [18446744060.832211] ---[ end trace d709801030e1a5a5 ]---
>> > [18446744060.832217] PGD 233e17067 PUD 233e15067 PMD 0
>> > [18446744060.832225] Oops: 0000 [#2] PREEMPT SMP
>> > [18446744060.832232] last sysfs file:
>> > /sys/devices/system/cpu/sched_smt_power_savings
>> > [18446744060.832238] CPU 1
>> > [18446744060.832241] Modules linked in: nls_cp437 cifs fbcon tileblit
>> > font bitblit softcursor binfmt_misc kvm_intel kvm snd_hda_codec_via
>> > snd_hda_intel snd_hda_codec snd_hwdep snd_pcm_oss nouveau
>> > snd_mixer_oss snd_pcm snd_seq_dummy snd_seq_oss snd_seq_midi
>> > snd_rawmidi snd_seq_midi_event ttm psmouse snd_seq drm_kms_helper
>> > snd_timer snd_seq_device serio_raw snd drm asus_atk0110 soundcore
>> > snd_page_alloc i2c_algo_bit usbhid hid ahci r8169 mii libahci
>> > pata_jmicron
>> > [18446744060.832321]
>> > [18446744060.832327] Pid: 1356, comm: hald Tainted: G      D
>> > 2.6.35-rc3 #6 P7P55D-E PRO/System Product Name
>> > [18446744060.832334] RIP: 0010:[<ffffffffa02982d9>]
>> > [<ffffffffa02982d9>] cifs_show_options+0xf9/0x480 [cifs]
>> > [18446744060.832348] RSP: 0018:ffff880234ac3de8  EFLAGS: 00010246
>> > [18446744060.832354] RAX: 0000000000000000 RBX: ffff88020afd0fc0 RCX:
>> > 0000000000000006
>> > [18446744060.832360] RDX: 0000000000000006 RSI: 0000000000001000 RDI:
>> > ffff880232f7f3e5
>> > [18446744060.832366] RBP: ffff880234ac3e18 R08: 000000000000fff8 R09:
>> > 0000000000000004
>> > [18446744060.832372] R10: 0000000000000000 R11: 0000000000000002 R12:
>> > ffff880231ad7400
>> > [18446744060.832378] R13: ffff8802324d7400 R14: ffff8802324d6b00 R15:
>> > 0000000000000000
>> > [18446744060.832384] FS:  00007f0b1c325700(0000)
>> > GS:ffff880001e20000(0000) knlGS:0000000000000000
>> > [18446744060.832390] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> > [18446744060.832396] CR2: 0000000000000048 CR3: 0000000235641000 CR4:
>> > 00000000000006e0
>> > [18446744060.832401] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
>> > 0000000000000000
>> > [18446744060.832406] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7:
>> > 0000000000000400
>> > [18446744060.832413] Process hald (pid: 1356, threadinfo
>> > ffff880234ac2000, task ffff880234bc9680)
>> > [18446744060.832419] Stack:
>> > [18446744060.832423]  ffff880234ac3e18 ffff88020afd0fc0
>> > ffff8802324d6b00 ffff8802324d6b60
>> > [18446744060.832433] <0> ffffffff8161b470 0000000000000000
>> > ffff880234ac3e68 ffffffff81157752
>> > [18446744060.832444] <0> ffff8802324d6b00 ffff88023f986000
>> > ffff880234ac3e68 ffff88020afd0fc0
>> > [18446744060.832458] Call Trace:
>> > [18446744060.832467]  [<ffffffff81157752>] show_vfsmnt+0x112/0x150
>> > [18446744060.832475]  [<ffffffff8115bc1f>] seq_read+0x25f/0x3f0
>> > [18446744060.832484]  [<ffffffff8113c9f5>] vfs_read+0xb5/0x180
>> > [18446744060.832492]  [<ffffffff8113de8f>] ? fget_light+0x7f/0xc0
>> > [18446744060.832500]  [<ffffffff8113d331>] sys_read+0x51/0x90
>> > [18446744060.832510]  [<ffffffff8100b0f2>] system_call_fastpath+0x16/0x1b
>> > [18446744060.832515] Code: 00 48 c7 c6 9a 7e 2c a0 48 89 df 31 c0 e8
>> > 80 32 ec e0 49 8b 45 28 48 c7 c6 b0 7e 2c a0 4c 8b 78 40 48 89 df 31
>> > c0 e8 67 32 ec e0 <41> 0f b7 47 48 66 83 f8 02 0f 84 98 01 00 00 66 83
>> > f8 0a 0f 84
>> > [18446744060.832634] RIP  [<ffffffffa02982d9>]
>> > cifs_show_options+0xf9/0x480 [cifs]
>> > [18446744060.832647]  RSP <ffff880234ac3de8>
>> > [18446744060.832651] CR2: 0000000000000048
>> > [18446744060.832668] ---[ end trace d709801030e1a5a6 ]---
>> >
>
> (cc'ing new linux-cifs ML)
>
> Thanks for the bug report. Would you be able to follow the directions
> here? That should help us pinpoint the spot where it actually crashed:
>
> http://wiki.samba.org/index.php/LinuxCIFS_troubleshooting#Oopses
>
> Thanks!
> --
> Jeff Layton <jlayton@samba.org>
>
