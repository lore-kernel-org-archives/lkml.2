Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752973Ab1BVOD5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 09:03:57 -0500
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:53365 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752641Ab1BVOD4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 09:03:56 -0500
Date: Tue, 22 Feb 2011 15:03:49 +0100
From: Borislav Petkov <bp@amd64.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Borislav Petkov <bp@alien8.de>
Subject: Re: Linux 2.6.38-rc6
Message-ID: <20110222140349.GA20708@kryptos.osrc.amd.com>
References: <AANLkTi=TTZ57d1wUz1uH3R6igN8O77iDvSLMW=t86g9V@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTi=TTZ57d1wUz1uH3R6igN8O77iDvSLMW=t86g9V@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 21, 2011 at 05:44:53PM -0800, Linus Torvalds wrote:
> We've fixed a fair number of problems, so it's always
> good to have regression reporters ping us with something like "hey,
> I'm still here, and you may have fixed all those other things, but you
> didn't fix my issue".

I don't know whether this one is relevant or not but it is in fs/namei.c
and it could mean vfs regression. I got the oops below after resuming
from disk today, kernel is 38-rc5. However, it didn't happen yesterday
on resume so it either is a glitch or a bug which is hard to reproduce.
I'll run -rc6 to check.

Beware, I've typed the whole oops from the screen, and while I paid
attention and made sure I had enough coffee before starting, some typos
might've sneaked in. I doublechecked the "Code:" section though.

--
[19728.090341] ------------[ cut here ]------------
[19728.090511] kernel BUG at fs/namei.c:1416!
[19728.090635] invalid opcode: 0000 [#1] PREEMPT SMP
[19728.090807] last sysfs file: /sys/devices/system/cpu/cpu0/cpufreq/scaling_cur_freq
[19728.091060] CPU 0
[19728.091060] Modules linked in: powernow_k8 mperf cpufreq_powersave cpufreq_conservative cpufreq_stats cpufreq_userspace sco bnep rfcomm l2cap crc16 loop btusb bluetooth snd_hda_codec_hdmi snd_hda_codec_conexant snd_hda_intel usbhid snd_hda_codec snd_hwdep snd_pcm_oss snd_mixer_oss usb_storage snd_kill snd_seq_oss snd_seq_midi snd_rawmidi option snd_seq_midi_event usb_wwan snd_seq usbserial snd_timer snd_seq_device ohci_hcd processor snd evdev kcore thermal video nvram usbcore i2c_piix4 snd_page_alloc nls_base battery thermal_sys edac_core ac button
[19728.091060]
[19728.091060] Pid: 1933, comm: conky Not tainted 2.6.38-rc5 #1 LENOVO 01972NG/INVALID
[19728.091060] RIP: 0010:[<ffffffff8111abb5>]  [<ffffffff8111abb5>] link_path_walk+0x975/0xa60
[19728.091060] RSP: 0018:ffff880137a99ce8 EFLAGS: 00010282
[19728.091060] RAX: ffff8800ad836738 RBX: ffff88012bedc00a RCX: 0000000000000000
[19728.091060] RDX: ffffffff81622040 RSI: ffff8800ad80d0c0 RDI: ffff8800ad80d0c0
[19728.091060] RBP: ffff880137a99d78 R08: 0000000000000003 R09: ffff8800ad80d0fa
[19728.091060] R10: 0000000000272c85 R11: ffff880137a99ca4 R12: ffff880137a99e18
[19728.091060] R13: ffff880137af9fe0 R14: ffff880137a99d28 R15: ffff880137af9fe0
[19728.091060] FS:  00007fdf4ca19700(0000) GS:ffff8800afc00000(0000) kn1GS:0000000000000000
[19728.091060] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[19728.091060] CR2: 00007fdf48001388 CR3: 0000000135a0f000 CR4: 00000000000006f0
[19728.091060] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[19728.091060] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[19728.091060] Process conky (pid: 1933, threadinfo ffff880137a98000, task ffff880137af9fe0)
[19728.091060] Stack:
[19728.091060]  00000000ffffff9c ffff880137a99e18 ffff880137a99d18 ffff880137af9fe0
[19728.091060]  ffff880137a99e38 0000014100000101 0000000300272c85 ffff88012bedc006
[19728.091060]  ffff88013fe0ce00 ffff8800ad80d0c0 ffff880137a99d78 ffff8800ad836738
[19728.091060] Call Trace:
[19728.091060]  [<ffffffff8111af17>] do_path_lookup+0x57/0xf0
[19728.091060]  [<ffffffff8111bfcf>] do_filp_open+0x1ef/0x770
[19728.091060]  [<ffffffff810e8971>] ? handle_mm_fault+0x191/0x250
[19728.091060]  [<ffffffff81038c19>] ? sub_preempt_count+0xa9/0xe0
[19728.091060]  [<ffffffff81127fba>] ? alloc_fd+0xfa/0x140
[19728.091060]  [<ffffffff8110b549>] do_sys_open+0x69/0x110
[19728.091060]  [<ffffffff8145dcc9>] ? trace_hardirqs_on_thunk+0x3a/0x3c
[19728.091060]  [<ffffffff8110b630>] sys_open+0x20/0x30
[19728.091060]  [<ffffffff8100276b>] system_call_fastpath+0x16/0x1b
[19728.091060] Code: 4d 80 4c 89 ea 4c 89 e6 ff d0 8b 4d 80 e9 12 ff ff ff 0f 0b eb fe 4c 89 e7 e8 b8 cb ff ff 85 c0 0f 84 ce fd ff ff e9 19 fa ff ff 47 68 48 8b 40 28 f6 40 09 40 0f 84 e5 f9 ff
[19728.091060] RIP  [<ffffffff8111abb5>] link_path_walk+0x975/0xa60
[19728.091060]  RSP <ffff880137a99ce8>

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Gemeinde Aschheim, Landkreis Muenchen
Registergericht Muenchen, HRB Nr. 43632
