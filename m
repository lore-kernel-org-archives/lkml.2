Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755573Ab2B2IiY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 03:38:24 -0500
Received: from cantor2.suse.de ([195.135.220.15]:59929 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755053Ab2B2IiW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 03:38:22 -0500
Date: Wed, 29 Feb 2012 09:38:18 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Hugh Dickins <hughd@google.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>
Subject: Re: Linux 3.3-rc4
In-Reply-To: <alpine.LNX.2.00.1202241859160.31150@pobox.suse.cz>
Message-ID: <alpine.LNX.2.00.1202290932090.31150@pobox.suse.cz>
References: <CA+55aFy2pnoNhpTstAMTs+dtm5iRaGCGKLwW6ScCLhEkWtHXGw@mail.gmail.com> <alpine.LRH.2.00.1202241112350.22368@twin.jikos.cz> <CA+55aFwg4EpUhbymOHrSt88FEmZWniMx4goCkk-xK7dwiKcsZg@mail.gmail.com> <alpine.LNX.2.00.1202241859160.31150@pobox.suse.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 24 Feb 2012, Jiri Kosina wrote:

> Running DEBUG_SLAB kernel since I have first hit the bug, but nothing 
> popped up yet. Seems undebuggable so far.
> 
> On the other hand I wouldn't blame HW for a bit-flip, as it was a clear 
> NULL pointer (plus 0x30 offset), not a random garbage.

Hmm, just got this as a result of lsmod (topmost commit g586c6e7)

BUG: unable to handle kernel NULL pointer dereference at 0000000000000020
IP: [<ffffffff810a6380>] m_show+0x70/0x190
PGD 77c60067 PUD 3756c067 PMD 0 
Oops: 0000 [#1] SMP 
CPU 0 
Modules linked in: af_packet rfcomm bnep tun iptable_mangle xt_DSCP nf_conntrack_ipv6 nf_defrag_ipv6 ip6table_filter ip6_tables xt
 nf_conntrack iptable_filter ip_tables x_tables cpufreq_conservative cpufreq_userspace cpufreq_powersave acpi_cpufreq mperf microc
 btusb bluetooth i2c_i801 iTCO_wdt snd_hda_codec_conexant e1000e pcspkr iTCO_vendor_support cfg80211 snd_hda_intel snd_hda_codec s
d_acpi rfkill battery snd ac soundcore tpm_tis wmi tpm tpm_bios autofs4 uhci_hcd i915 drm_kms_helper ehci_hcd drm i2c_algo_bit usb
a_generic thermal thermal_sys

Pid: 3960, comm: lsmod Not tainted 3.3.0-rc5-00088-g586c6e7 #10 LENOVO 7470BN2/7470BN2
RIP: 0010:[<ffffffff810a6380>]  [<ffffffff810a6380>] m_show+0x70/0x190
RSP: 0018:ffff880037b8fe08  EFLAGS: 00010203
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000001
RDX: 0000000000000000 RSI: 0000000000001000 RDI: ffff8800379b332c
RBP: ffff880037b8fe48 R08: 0000000000000020 R09: 000000000000ffff
R10: 0000000000000001 R11: 0000ffffffff6c0a R12: ffffffffa0175490
R13: ffff880036c44d80 R14: ffffffffa0175280 R15: ffffffffa0175288
FS:  00007f78f52a0700(0000) GS:ffff88007c200000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000020 CR3: 000000007563a000 CR4: 00000000000006f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process lsmod (pid: 3960, threadinfo ffff880037b8e000, task ffff880073624040)
Stack:
 ffff880037b8fe28 ffffffff814fa56e ffff880037b8fe88 ffffffffa0175288
 ffff880036c44d80 0000000000000320 ffff880037b8fe80 000000000000002b
 ffff880037b8feb8 ffffffff8118dda7 ffff880037b8ff48 00000000000003d5
Call Trace:
 [<ffffffff814fa56e>] ? mutex_lock_nested+0x3e/0x50
 [<ffffffff8118dda7>] seq_read+0x287/0x400
 [<ffffffff8118db20>] ? seq_lseek+0x110/0x110
 [<ffffffff811cea6d>] proc_reg_read+0x7d/0xc0
 [<ffffffff8116b258>] vfs_read+0xc8/0x130
 [<ffffffff8116b3b0>] sys_read+0x50/0x90
 [<ffffffff81505779>] system_call_fastpath+0x16/0x1b
Code: e8 06 ff ff ff 48 c7 c6 c6 50 79 81 48 89 c2 4c 89 ef 31 c0 e8 12 76 0e 00 49 8b 9e 10 02 00 00 31 c0 4c 39 e3 74 2a 0f 1f 4
89 ef 48 83 c2 18 e8 
RIP  [<ffffffff810a6380>] m_show+0x70/0x190
 RSP <ffff880037b8fe08>
CR2: 0000000000000020

So again NULL+offset, again a vfs-related structure, but a completely 
different codepath.

This particular kernel didn't have DEBUG_SLAB turned on, unfortunately.

-- 
Jiri Kosina
SUSE Labs
