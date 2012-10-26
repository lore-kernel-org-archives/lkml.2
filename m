Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933326Ab2JZOaU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 10:30:20 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:49944 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S933218Ab2JZOaS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 10:30:18 -0400
X-Authenticated: #5108953
X-Provags-ID: V01U2FsdGVkX1/+7e8Bt1L+xXJj8HXz3mO1JUM1FmSw8nxyqerz+D
	LmKXhXwGYPAnwR
Message-ID: <508A9E74.4050309@gmx.de>
Date: Fri, 26 Oct 2012 16:30:12 +0200
From: =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121022 Thunderbird/16.0.1
MIME-Version: 1.0
To: "Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: EXT4-fs error w/ external USB drive
References: <507C4BDA.20205@gmx.de> <20121019210723.GA4721@thunk.org> <5085923F.9050801@gmx.de> <20121024011128.GG28626@thunk.org> <5088260D.7080403@gmx.de> <20121024183505.GA6142@thunk.org>
In-Reply-To: <20121024183505.GA6142@thunk.org>
X-Enigmail-Version: 1.5a1pre
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/24/2012 08:35 PM, Theodore Ts'o wrote:
> On Wed, Oct 24, 2012 at 07:31:57PM +0200, Toralf Förster wrote:
>>> Are you using any kind of special mount options on your usb stick?
>>>
>> nope
> 
> Thanks, we're trying to get a reliable repro of this failure, and so
> every bit of data helps...  I've cc'ed you on the other thread, and if
> you could try the second patch I sent out last night (and let me know
> when/if the WARN_ON triggers), I'd really appreciate it.
> 
> Thanks again,
> 
>                                           - Ted
> 
Well, here it is :

2012-10-25T21:05:28.000+02:00 n22 sudo: tfoerste : TTY=pts/2 ; PWD=/home/tfoerste/virtual/uml ; USER=root ; COMMAND=/bin/su -
2012-10-25T21:05:28.000+02:00 n22 sudo: pam_unix(sudo:session): session opened for user root by tfoerste(uid=0)
2012-10-25T21:05:28.000+02:00 n22 su[18998]: Successful su for root by root
2012-10-25T21:05:28.000+02:00 n22 su[18998]: + /dev/pts/2 root:root
2012-10-25T21:05:28.000+02:00 n22 su[18998]: pam_unix(su:session): session opened for user root by tfoerste(uid=0)
2012-10-25T21:05:44.880+02:00 n22 kernel: EXT4-fs (loop0): mounted filesystem with ordered data mode. Opts: (null)
2012-10-25T21:07:07.218+02:00 n22 kernel: JBD2: jbd2_mark_journal_empty bug workaround (79, 80)
2012-10-25T21:07:07.218+02:00 n22 kernel: ------------[ cut here ]------------
2012-10-25T21:07:07.218+02:00 n22 kernel: WARNING: at fs/jbd2/journal.c:1364 jbd2_mark_journal_empty+0xef/0x110()
2012-10-25T21:07:07.218+02:00 n22 kernel: Hardware name: 4180F65
2012-10-25T21:07:07.218+02:00 n22 kernel: Modules linked in: bluetooth cpufreq_stats loop ipt_MASQUERADE xt_owner xt_multiport ipt_REJECT xt_recent xt_tcpudp xt_mac nf_conntrack_ftp xt_state xt_limit xt_LOG iptable_nat nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_conntrack iptable_filter ip_tables x_tables af_packet pppoe pppox ppp_generic slhc bridge stp llc tun msr i915 coretemp cfbfillrect cfbimgblt i2c_algo_bit cfbcopyarea fbcon bitblit snd_hda_codec_conexant softcursor font snd_hda_intel snd_hda_codec kvm_intel snd_pcm intel_agp 8250_pci intel_gtt drm_kms_helper snd_page_alloc snd_timer kvm 8250 drm thinkpad_acpi nvram uvcvideo snd serial_core agpgart fb sdhci_pci usblp videobuf2_vmalloc e1000e videobuf2_memops videobuf2_core videodev i2c_i801 tpm_tis soundcore hwmon arc4 sdhci i2c_core tpm fbdev iwldvm acpi_cpufreq mac80211 mperf ac psmouse iwlwifi battery button cfg80211 rfkill evdev mmc_core processor video tpm_bios thermal wmi xts gf128mul aesni_intel ablk_helper cryptd aes_i58
6 aes_generic cbc fuse nfs lockd sunrpc dm_crypt dm_mod hid_monterey hid_microsoft hid_logitech hid_ezkey hid_cypress hid_chicony hid_cherry hid_belkin hid_apple hid_a4tech hid_generic usbhid hid sr_mod cdrom sg [last unloaded: microcode]
2012-10-25T21:07:07.218+02:00 n22 kernel: Pid: 19040, comm: umount Not tainted 3.6.3 #8
2012-10-25T21:07:07.218+02:00 n22 kernel: Call Trace:
2012-10-25T21:07:07.218+02:00 n22 kernel: [<c10323e2>] warn_slowpath_common+0x72/0xa0
2012-10-25T21:07:07.218+02:00 n22 kernel: [<c11e253f>] ? jbd2_mark_journal_empty+0xef/0x110
2012-10-25T21:07:07.218+02:00 n22 kernel: [<c11e253f>] ? jbd2_mark_journal_empty+0xef/0x110
2012-10-25T21:07:07.223+02:00 n22 kernel: [<c1032432>] warn_slowpath_null+0x22/0x30
2012-10-25T21:07:07.223+02:00 n22 kernel: [<c11e253f>] jbd2_mark_journal_empty+0xef/0x110
2012-10-25T21:07:07.223+02:00 n22 kernel: [<c11e272e>] jbd2_journal_destroy+0x1ce/0x1f0
2012-10-25T21:07:07.223+02:00 n22 kernel: [<c10529c0>] ? add_wait_queue+0x50/0x50
2012-10-25T21:07:07.223+02:00 n22 kernel: [<c11b079a>] ext4_put_super+0x4a/0x2e0
2012-10-25T21:07:07.223+02:00 n22 kernel: [<c1127652>] ? dispose_list+0x32/0x40
2012-10-25T21:07:07.223+02:00 n22 kernel: [<c1127c0f>] ? evict_inodes+0x8f/0xe0
2012-10-25T21:07:07.223+02:00 n22 kernel: [<c1112521>] generic_shutdown_super+0x51/0xd0
2012-10-25T21:07:07.223+02:00 n22 kernel: [<c10e5b45>] ? pcpu_free_area+0x145/0x190
2012-10-25T21:07:07.223+02:00 n22 kernel: [<c11125c9>] kill_block_super+0x29/0x70
2012-10-25T21:07:07.224+02:00 n22 kernel: [<c1112800>] deactivate_locked_super+0x30/0x90
2012-10-25T21:07:07.224+02:00 n22 kernel: [<c1113247>] deactivate_super+0x47/0x60
2012-10-25T21:07:07.224+02:00 n22 kernel: [<c112a41d>] mntput_no_expire+0xcd/0x120
2012-10-25T21:07:07.224+02:00 n22 kernel: [<c112b1ca>] sys_umount+0x6a/0x330
2012-10-25T21:07:07.224+02:00 n22 kernel: [<c112b4ae>] sys_oldumount+0x1e/0x20
2012-10-25T21:07:07.224+02:00 n22 kernel: [<c13ad753>] sysenter_do_call+0x12/0x22
2012-10-25T21:07:07.224+02:00 n22 kernel: ---[ end trace 8e7416a7368818fe ]---
2012-10-25T21:07:07.000+02:00 n22 su[18998]: pam_unix(su:session): session closed for user root
2012-10-25T21:07:07.000+02:00 n22 sudo: pam_unix(sudo:session): session closed for user root


-- 
MfG/Sincerely
Toralf Förster
pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3
