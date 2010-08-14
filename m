Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756231Ab0HNMhV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Aug 2010 08:37:21 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:38099 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756105Ab0HNMhT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Aug 2010 08:37:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:date:message-id:subject:from:to:cc
         :content-type;
        b=TCSt+/rPUYiGqJdz+j5IVe8cdp6cVgqLCiLxTn8nFkBZztnv87TVDYk169l2+2KAgy
         nGr+qk3R+FXwbtV6ErdAQiHX+lD1EDMIOD3BW4ER+mIYq40c1PkJAT9SQLkyYzFyzOTF
         qtU6DC9YRz6elt7HR/PbsLX2F1vN/f/ZJww90=
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
Date: Sat, 14 Aug 2010 14:37:18 +0200
Message-ID: <AANLkTimNborh0AtHkdnN-aCizDu4+S6ORmeoKzS_nEVH@mail.gmail.com>
Subject: Re: Linux 2.6.35.2
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: Greg KH <gregkh@suse.de>, LKML <linux-kernel@vger.kernel.org>
Cc: penberg@kernel.org, arthur@psw.ro
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ CC me I am not subscribed to LKML ]

[1] says:

>You could try 'git bisect' between v2.6.35.1 and v2.6.35.2 to narrow
>the problem down to a specific commit.

I would suggest to revert last 3 patches to 2.6.35.y GIT branch (taken
from upstream, recently accepted, not well tested?):

x86: don't send SIGBUS for kernel page faults
mm: fix missing page table unmap for stack guard page failure case
mm: keep a guard page below a grow-down stack segment 	

I can't understand why some days old upstream patches go into a
stable-fix series.
As far as I can see they were not in the review-2.6.35 cycle and not
in 2.6.35.2-rc1 patch included (see my posting in [3],[4]).

I see similiar Call trace(s) in 2.6.35-gitX (here on Debian/sid i386):

root@tbox:~# grep "Aug 14 13:00:5" /var/log/syslog
Aug 14 13:00:53 tbox kernel: [ 1084.804086] BUG: scheduling while
atomic: bash/3256/0x10000001
Aug 14 13:00:53 tbox kernel: [ 1084.804092] Modules linked in: btrfs
zlib_deflate crc32c libcrc32c ufs qnx4 hfsplus hfs minix ntfs vfat
msdos fat jfs xfs exportfs reiserfs ext2 acpi_cpufreq mperf
cpufreq_stats cpufreq_userspace cpufreq_conservative cpufreq_powersave
ppdev lp sco bnep l2cap bluetooth aes_i586 aes_generic ext4 jbd2 crc16
fuse dm_crypt snd_intel8x0 snd_intel8x0m snd_ac97_codec arc4 ecb
ac97_bus radeon snd_pcm_oss snd_mixer_oss thinkpad_acpi snd_pcm ath5k
snd_seq_midi snd_rawmidi mac80211 snd_seq_midi_event ttm snd_seq ath
drm_kms_helper pcmcia drm joydev cfg80211 snd_timer snd_seq_device
nsc_ircc yenta_socket rfkill pcmcia_rsrc i2c_algo_bit pcmcia_core snd
i2c_i801 led_class video output irda rng_core soundcore tpm_tis shpchp
i2c_core battery ac pci_hotplug tpm nvram pcspkr serio_raw parport_pc
tpm_bios parport psmouse snd_page_alloc evdev processor button
crc_ccitt ext3 jbd mbcache dm_mod usbhid hid sg sd_mod sr_mod cdrom
crc_t10dif ata_generic ata_piix libata uhci_hcd ehci_hcd scsi_mod
usbcore
Aug 14 13:00:53 tbox kernel: e1000 floppy thermal thermal_sys nls_base
[last unloaded: scsi_wait_scan]
Aug 14 13:00:53 tbox kernel: [ 1084.804203] Pid: 3256, comm: bash Not
tainted 2.6.35-git14.sd.1-686 #2
Aug 14 13:00:53 tbox kernel: [ 1084.804206] Call Trace:
Aug 14 13:00:53 tbox kernel: [ 1084.804221]  [<c12761ad>] ? schedule+0x8e/0x569
Aug 14 13:00:53 tbox kernel: [ 1084.804230]  [<c108dc8c>] ?
__alloc_pages_nodemask+0x565/0x5d7
Aug 14 13:00:53 tbox kernel: [ 1084.804235]  [<c108a275>] ?
generic_file_aio_read+0x581/0x5cc
Aug 14 13:00:53 tbox kernel: [ 1084.804240]  [<c1276793>] ?
_cond_resched+0x26/0x3d
Aug 14 13:00:53 tbox kernel: [ 1084.804247]  [<c10a3b2e>] ?
anon_vma_prepare+0x11/0xe6
Aug 14 13:00:53 tbox kernel: [ 1084.804251]  [<c109fa93>] ?
expand_downwards+0x15/0x122
Aug 14 13:00:53 tbox kernel: [ 1084.804255]  [<c109ba49>] ?
__pte_alloc+0x5a/0x8a
Aug 14 13:00:53 tbox kernel: [ 1084.804271]  [<c109d73b>] ?
handle_mm_fault+0x207/0xa32
Aug 14 13:00:53 tbox kernel: [ 1084.804275]  [<c109ac81>] ?
follow_page+0x4d/0x29d
Aug 14 13:00:53 tbox kernel: [ 1084.804279]  [<c109e21e>] ?
__get_user_pages+0x2b8/0x39b
Aug 14 13:00:53 tbox kernel: [ 1084.804284]  [<c10b9c24>] ?
get_arg_page+0x2e/0x77
Aug 14 13:00:53 tbox kernel: [ 1084.804291]  [<c1139d90>] ?
strnlen_user+0x18/0x35
Aug 14 13:00:53 tbox kernel: [ 1084.804295]  [<c10b9d33>] ?
copy_strings+0xc6/0x161
Aug 14 13:00:53 tbox kernel: [ 1084.804299]  [<c10ba9b1>] ?
kernel_read+0x2d/0x3d
Aug 14 13:00:53 tbox kernel: [ 1084.804303]  [<c10b9de7>] ?
copy_strings_kernel+0x19/0x27
Aug 14 13:00:53 tbox kernel: [ 1084.804307]  [<c10bb1b1>] ?
do_execve+0x143/0x24e
Aug 14 13:00:53 tbox kernel: [ 1084.804313]  [<c1007c82>] ? sys_execve+0x2c/0x4d
Aug 14 13:00:53 tbox kernel: [ 1084.804318]  [<c1002fee>] ?
ptregs_execve+0x12/0x18
Aug 14 13:00:53 tbox kernel: [ 1084.804322]  [<c1002f1f>] ?
sysenter_do_call+0x12/0x28

Dunno, if they are correlated...

- Sedat -

[ REFERENCES ]
[1] http://lkml.org/lkml/2010/8/14/46
[2] http://git.kernel.org/?p=linux/kernel/git/hpa/linux-2.6-allstable.git;a=shortlog;h=refs/heads/linux-2.6.35.y
[3] http://lkml.org/lkml/2010/8/14/5
[4] http://lkml.org/lkml/2010/8/14/6
