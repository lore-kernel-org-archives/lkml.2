Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755258Ab1KQB5g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 20:57:36 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:57552 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754989Ab1KQB5e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 20:57:34 -0500
Date: Wed, 16 Nov 2011 17:57:18 -0800 (PST)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@sister.anvils
To: "Wouter M. Koolen" <W.M.Koolen-Wijkstra@cwi.nl>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>, len.brown@intel.com, pavel@ucw.cz,
        linux-kernel@vger.kernel.org
Subject: Re: [BUG] NULL deref in swapin_readahead
In-Reply-To: <4EBD14B4.5000201@cwi.nl>
Message-ID: <alpine.LSU.2.00.1111161743530.2092@sister.anvils>
References: <4EBD0767.8040901@cwi.nl> <201111111307.02203.rjw@sisk.pl> <4EBD14B4.5000201@cwi.nl>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Nov 2011, Wouter M. Koolen wrote:
> On 11/11/2011 12:07 PM, Rafael J. Wysocki wrote:
> > > BUG: unable to handle kernel NULL pointer dereference at 000000000000000c
> > > IP: [<ffffffff810f55e1>] valid_swaphandles+0x71/0x130
> > > PGD 4b53d067 PUD 4b6ff067 PMD 0
> > > Oops: 0000 [#1] SMP
> > > CPU 0
> > > Modules linked in: hidp acpi_cpufreq mperf cpufreq_stats cpufreq_powersave rfcomm bnep microcode uinput fuse sbs sbshc coretemp i2c_dev loop uvcvideo videodev v4l2_compat_ioctl32 firewire_sbp2 aes_x86_64 aes_generic ecb btusb bluetooth hid_apple usbhid hid appletouch isight_firmware sg sr_mod cdrom arc4 uhci_hcd ehci_hcd b43 usbcore i2c_i801 evdev snd_hda_codec_realtek mac80211 cfg80211 rfkill snd_hda_intel rng_core snd_hda_codec battery ssb snd_hwdep firewire_ohci snd_pcm mmc_core firewire_core crc_itu_t snd_seq snd_timer snd_seq_device snd soundcore snd_page_alloc applesmc input_polldev pcspkr ac processor apple_bl power_supply sky2 ext4 mbcache jbd2 crc16 sd_mod crc_t10dif ata_piix libata scsi_mod
> > > Nov 11 01:32:24 wensbook kernel:
> > > Pid: 13697, comm: firefox-bin Not tainted 3.1.0.git2+ #27 Apple Inc. MacBook4,1/Mac-F22788A9
> > > RIP: 0010:[<ffffffff810f55e1>]  [<ffffffff810f55e1>] valid_swaphandles+0x71/0x130
> > > RSP: 0000:ffff880054229cb8  EFLAGS: 00010246
> > > RAX: 0000000000007d7d RBX: 0000000000000000 RCX: 0000000000000003
> > > RDX: 0000000000000001 RSI: ffff880054229d20 RDI: ffffffff81772b30
> > > RBP: ffff880054229cf8 R08: 0000000000000000 R09: 0000000000000028
> > > R10: ffff880076f31360 R11: 2000000080000000 R12: 0000000080000000
> > > R13: 0000000080000000 R14: 0000000000000000 R15: ffff880054229d20
> > > FS:  00007faed45fe700(0000) GS:ffff88007da00000(0000) knlGS:0000000000000000
> > > CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > > CR2: 000000000000000c CR3: 0000000037d1f000 CR4: 00000000000006f0
> > > DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> > > DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> > > Process firefox-bin (pid: 13697, threadinfo ffff880054228000, task ffff880054206980)
> > > Stack:
> > > ffffea0000cc53f0 0000000080000008 ffff88007a54ab00 00000000000200da
> > > ffff880061b6b7c8 00007faf0d9a5bef ffff88007a54ab00 00007faf0d9a5bef
> > > ffff880054229d58 ffffffff810f2166 ffff880054229d58 2000000080000000
> > > Call Trace:
> > > [<ffffffff810f2166>] swapin_readahead+0x26/0xb0
> > > [<ffffffff811af74e>] ? radix_tree_lookup_slot+0xe/0x10
> > > [<ffffffff810e2e0f>] handle_pte_fault+0x65f/0x930
> > > [<ffffffff8132ce19>] ? __ip_route_output_key+0x4c9/0x970
> > > [<ffffffff810e33d7>] handle_mm_fault+0x1b7/0x2c0
> > > [<ffffffff813d4cbd>] do_page_fault+0x11d/0x4e0
> > > [<ffffffff8111d522>] ? d_kill+0xd2/0x130
> > > [<ffffffff81124a2f>] ? mntput_no_expire+0x1f/0xf0
> > > [<ffffffff81124b1a>] ? mntput+0x1a/0x30
> > > [<ffffffff81109f0f>] ? fput+0x16f/0x210
> > > [<ffffffff813d1e2f>] page_fault+0x1f/0x30
> > > Code: 34 c5 40 2b 77 81 4d 89 ec b8 01 00 00 00 49 d3 ec d3 e0 49 d3 e4 48 98 4c 01 e0 4d 85 e4 4c 0f 44 e2 48 89 45 c8 e8 9f c4 2d 00
> > > RIP  [<ffffffff810f55e1>] valid_swaphandles+0x71/0x130
> > > RSP <ffff880054229cb8>
> > > CR2: 000000000000000c
> > > ---[ end trace 55973eaf7551e3c0 ]---

> > Well, the trace doesn't indicate how the problem is related to the
> > suspend/resume code paths.
> > 
> > Is this a regression for you?
> 
> This problem manifests itself when resuming from RAM, but only very
> infrequently. This is the third occurrence since I started using this
> machine three months ago. I suspend it to RAM at least twice a day. The
> previous two occurrences were on 3.0. So not a clear regression in that
> sense. (Note this is from memory, I didn't record those other two oopses)
> 
> However, since it happens immediately upon resume, I suspected it was
> related. Would you have any tips for stress testing resumes? If I can
> increase the reproducibility then I could try to bisect it.
> 
> Or do you think it better, judging from the back trace, to forward this to
> some other subsystem maintainer? Please do then, I obviously don't know how
> to read backtraces.

I've very little to add on this, but wanted to report that I did check
to see where it had crashed in valid_swaphandles(): it was on the line
	if (end > si->max)
which that means si was NULL i.e. the swap entry on which it faulted had
an invalid swp_type.  It appears that the page table was corrupt on
return from resume.

Hugh
