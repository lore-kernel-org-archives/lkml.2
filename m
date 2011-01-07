Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754486Ab1AGAox (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 19:44:53 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:56644 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752137Ab1AGAov convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 19:44:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=LY9unP+SPWof4Yo9eP3Rx7TgXOICChrdt5u1pzMebu9l5QXESBfWF/Ucx+4eRpBNrW
         gegOcVAaZScBmMIj2nFDTIzVxE3iZ17V1/SYZj8dmAqBdUv7h3BucmagbfUurqKdDK4P
         hZVE0L0gEBKMcuvnmGQVdJdNp+8CFTFkGHSHI=
MIME-Version: 1.0
In-Reply-To: <201101061735.40060.florian@kriener.org>
References: <201101061735.40060.florian@kriener.org>
Date: Fri, 7 Jan 2011 11:44:49 +1100
Message-ID: <AANLkTi=QDTt=QYwf3+jr0jWd6D3HiBNaOh_sOG6hey=s@mail.gmail.com>
Subject: Re: BUG in fs/inode.c:429
From: Nick Piggin <npiggin@gmail.com>
To: Florian Kriener <florian@kriener.org>
Cc: linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 7, 2011 at 3:35 AM, Florian Kriener <florian@kriener.org> wrote:
> Hello,
>
> here is a kernel bug message of one that I somehow triggered.
> I have absolutely no idea why it happend, I was reading an E-Mail
> with an attached archive, that I opened and closed again and BANG.
>
> It works now. I am however scared. This is not the first time it
> happend and the others were even more scarier. So scary, I
> don't even have trace of them. -- I could not find one on my
> hard drive, but I have my camera ready now. BTW: The others happend
> during suspend or resume from hibernate. This one did not, I am
> however pretty sure, that my notebook was in hibernation before.
>
> Here is the trace:
>
> [ 4626.750273] ------------[ cut here ]------------
> [ 4626.750314] kernel BUG at /build/buildd-linux-2.6_2.6.37~rc7-1~experimental.1-amd64-
> Mw4Tor/linux-2.6-2.6.37~rc7/debian/build/source_amd64_none/fs/inode.c:429!

Is this an unpatched kernel? ie.
BUG_ON(!list_empty(&inode->i_data.private_list));


> [ 4626.750384] invalid opcode: 0000 [#1] SMP
> [ 4626.750413] last sysfs file: /sys/devices/LNXSYSTM:00/device:00/PNP0A08:00/device:01/PNP0C09:00/PNP0C0A:00/power_supply/BAT0/energy_full
> [ 4626.750476] CPU 1
> [ 4626.750488] Modules linked in: usblp zaurus cdc_ether usbnet cdc_acm cdc_wdm mii sco bnep acpi_cpufreq mperf rfcomm cpufreq_conservative
> cpufreq_userspace cpufreq_powersave cpufreq_stats l2cap parport_pc ppdev lp parport vboxnetadp vboxnetflt vboxdrv binfmt_misc microcode uinput
> ipt_LOG ip6t_LOG ipt_REJECT xt_comment ipt_addrtype ip6t_REJECT xt_multiport xt_mark nf_conntrack_ipv6 nf_defrag_ipv6 ip6table_mangle
> ip6table_raw ip6table_filter ip6_tables xt_tcpudp xt_conntrack iptable_mangle iptable_nat nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 iptable_raw
> iptable_filter ip_tables x_tables ext2 btusb bluetooth nf_conntrack_ftp nf_conntrack tp_smapi thinkpad_ec loop snd_hda_codec_conexant arc4
> snd_hda_intel ecb snd_hda_codec snd_hwdep snd_pcm thinkpad_acpi iwlagn snd_seq iwlcore snd_timer uvcvideo snd_seq_device videodev mac80211
> v4l1_compat v4l2_compat_ioctl32 snd i2c_i801 tpm_tis snd_page_alloc cfg80211 psmouse soundcore tpm rfkill tpm_bios joydev ac nvram serio_raw
> battery power_supp
> ly wmi evdev processor ext4 mbcache jbd2 crc16 sha256_generic aes_x86_64 aes_generic cbc usbhid hid dm_crypt dm_mod sg sr_mod sd_mod cdrom
> crc_t10dif uhci_hcd i915 drm_kms_helper drm sdhci_pci ahci libahci libata i2c_algo_bit i2c_core ehci_hcd scsi_mod sdhci usbcore e1000e video
> thermal mmc_core thermal_sys output nls_base button [last unloaded: scsi_wait_scan]
> [ 4626.751505]
> [ 4626.751516] Pid: 6843, comm: ark Not tainted 2.6.37-rc7-amd64 #1 2808D9G/2808D9G
> [ 4626.751554] RIP: 0010:[<ffffffff811053ff>]  [<ffffffff811053ff>] end_writeback+0x27/0x65
> [ 4626.751600] RSP: 0018:ffff88008f06de68  EFLAGS: 00010207
> [ 4626.751630] RAX: ffff880137b32900 RBX: ffff880137b32760 RCX: ffff880137b33b40
> [ 4626.751660] RDX: 0000000100000000 RSI: ffffffff810fa2e5 RDI: ffff880137b32760
> [ 4626.751689] RBP: ffff8801377a5000 R08: 0000000000000000 R09: ffff8800ac79df00
> [ 4626.751718] R10: ffffffff810fa2e5 R11: dead000000200200 R12: ffff880137b32760
> [ 4626.751747] R13: ffff8801376fa700 R14: ffff880137b32760 R15: ffff880122b91900
> [ 4626.751777] FS:  00007f6451a2f710(0000) GS:ffff8800bd280000(0000) knlGS:0000000000000000
> [ 4626.751819] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [ 4626.751844] CR2: 00007f645be73c18 CR3: 00000000ab224000 CR4: 00000000000406e0
> [ 4626.751873] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [ 4626.751902] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> [ 4626.751933] Process ark (pid: 6843, threadinfo ffff88008f06c000, task ffff8801332dca40)
> [ 4626.751964] Stack:
> [ 4626.751978]  ffff880137b32760 ffffffff81105479 ffff880137b32760 ffffffff811059b5
> [ 4626.752010]  ffff880137b32760 ffff880122b91900 ffff880122b91908 ffffffff81102298
> [ 4626.752010]  0000000000000296 ffff880122b91900 ffff880122b91908 ffffffff811033d7
> [ 4626.752010] Call Trace:
> [ 4626.752010]  [<ffffffff81105479>] ? evict+0x3c/0x89
> [ 4626.752010]  [<ffffffff811059b5>] ? iput+0x1ff/0x238
> [ 4626.752010]  [<ffffffff81102298>] ? d_kill+0x39/0x59
> [ 4626.752010]  [<ffffffff811033d7>] ? dput+0x123/0x12f
> [ 4626.752010]  [<ffffffff810f4a5f>] ? fput+0x1d1/0x206
> [ 4626.752010]  [<ffffffff810f1ded>] ? filp_close+0x5f/0x6a
> [ 4626.752010]  [<ffffffff810f1e8a>] ? sys_close+0x92/0xc6
> [ 4626.752010]  [<ffffffff81009a12>] ? system_call_fastpath+0x16/0x1b
> [ 4626.752010] Code: 2e 8f 21 00 53 48 89 fb e8 33 8a 21 00 48 83 bb 70 01 00 00 00 74 04 0f 0b eb fe 48 8d 83 a0 01 00 00 48 39 83 a0 01 00 00
> 74 04 <0f> 0b eb fe 48 8b 83 f0 01 00 00 a8 20 75 04 0f 0b eb fe a8 40
> [ 4626.752010] RIP  [<ffffffff811053ff>] end_writeback+0x27/0x65
> [ 4626.752010]  RSP <ffff88008f06de68>
> [ 4626.763893] ---[ end trace a3a96a172795da1d ]---
>
>
> I am using 2.6.37-rc7 from Debian experimental and all my filesystems
> are ext4 except for /boot, which is ext2 (and /tmp is tmpfs).

Definitely no other filesystems? Too bad frame pointers are turned off,
but it seems perhaps default evict_inode is being used, which doesn't
do invalidate_inode_buffers(). ext2/3/4/fat/udf all seem to do the right
thing here, though.

If it's happening semi frequently, could you compile a vanilla 2.6.37
with the same .config, just turn on frame pointers, and report if it
happens again?

Dumping the inode->i_ops symbol name before going BUG in fact
might be helpful too.

Thanks,
Nick
