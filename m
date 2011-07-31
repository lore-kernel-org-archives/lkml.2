Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752310Ab1GaQUG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jul 2011 12:20:06 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:56556 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752162Ab1GaQUE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jul 2011 12:20:04 -0400
MIME-Version: 1.0
In-Reply-To: <20110730191855.eaec670f.rdunlap@xenotime.net>
References: <CAKWSe6B3hWt4ANpgoS4dRUZPju0Abey9y3DORVFqGYgMeF=gQA@mail.gmail.com>
	<20110730191855.eaec670f.rdunlap@xenotime.net>
Date: Sun, 31 Jul 2011 18:20:01 +0200
Message-ID: <CAKWSe6Bf6bZQnjujPRYQPCw+PEkvPOkwxdCVqfJV+6Xr6erw5Q@mail.gmail.com>
Subject: Re: warn_slowpath_common WARNING on boot since 3.0.0-git7
From: Alessandro Suardi <alessandro.suardi@gmail.com>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 31, 2011 at 4:18 AM, Randy Dunlap <rdunlap@xenotime.net> wrote:
> On Sat, 30 Jul 2011 17:31:51 +0200 Alessandro Suardi wrote:
>
>> F15 x86_64, still present in 3.0.0-git11; didn't report it earlier as I
>>  thought it'd be squashed sooner... probably it's not as common
>>  as I thought it'd be:
>>
>> Jul 27 18:46:18 duff kernel: WARNING: at fs/proc/base.c:1123
>> oom_adjust_write+0x185/0x23c()
>> Jul 27 18:46:18 duff kernel: Hardware name: Latitude E6400
>> Jul 27 18:46:18 duff kernel: sshd (3245): /proc/3245/oom_adj is
>> deprecated, please use /proc/3245/oom_score_adj instead.
>
> Looks like sshd is using a deprecated /proc interface.
> fs/proc/base.c:1118 says:
>         * Warn that /proc/pid/oom_adj is deprecated, see
>         * Documentation/feature-removal-schedule.txt.
>
> What else needs to be done here?
>
>> Jul 27 18:46:18 duff kernel: Modules linked in: sunrpc rfcomm bnep
>> ip6t_REJECT nf_conntrack_ipv6 ipt_REJECT nf_defrag_ipv6
>> nf_conntrack_ipv4 ip6table_filter nf_defrag_ipv4 ip6_tables xt_state
>> nf_conntrack iptable_filter ip_tables snd_hda_codec_hdmi
>> snd_hda_codec_idt snd_hda_intel snd_hda_codec aes_x86_64 aes_generic
>> ecb snd_hwdep btusb snd_seq snd_seq_device bluetooth snd_pcm
>> dell_laptop snd_timer snd i2c_i801 rfkill microcode pcspkr joydev
>> soundcore snd_page_alloc dcdbas ipv6 autofs4 ext4 jbd2 crc16 sdhci_pci
>> firewire_ohci sdhci firewire_core crc_itu_t mmc_core i915
>> drm_kms_helper drm i2c_algo_bit i2c_core video [last unloaded:
>> scsi_wait_scan]
>> Jul 27 18:46:18 duff kernel: Pid: 3245, comm: sshd Not tainted 3.0.0-git7 #6
>> Jul 27 18:46:18 duff kernel: Call Trace:
>> Jul 27 18:46:18 duff kernel: [<ffffffff8103774c>] warn_slowpath_common+0x7e/0x96
>> Jul 27 18:46:18 duff kernel: [<ffffffff810377f8>] warn_slowpath_fmt+0x41/0x43
>> Jul 27 18:46:18 duff kernel: [<ffffffff810408f4>] ? ns_capable+0x35/0x4a
>> Jul 27 18:46:18 duff kernel: [<ffffffff81129fb8>] oom_adjust_write+0x185/0x23c
>> Jul 27 18:46:18 duff kernel: [<ffffffff810e0736>] vfs_write+0xa3/0xca
>> Jul 27 18:46:18 duff kernel: [<ffffffff8109176f>] ?
>> trace_hardirqs_on_caller+0xe/0x22
>> Jul 27 18:46:18 duff kernel: [<ffffffff810e08d2>] sys_write+0x45/0x69
>> Jul 27 18:46:18 duff kernel: [<ffffffff813752fb>] system_call_fastpath+0x16/0x1b

Well, the obsolescence was discussed a while ago in this thread

http://www.gossamer-threads.com/lists/linux/kernel/1301830

 and my kernel dmesg output has been telling me ever since;
 the "issue", if we can so call that, is that the WARNING trace
 output appeared in 3.0.0-git7.

In 3.0.0-git1 I still had

Jul 24 12:22:01 duff kernel: sshd (3185): /proc/3185/oom_adj is
deprecated, please use /proc/3185/oom_score_adj instead.

 *without* the warn_slowpath_common WARNING.

Is the extra tracing intentional, or a side effect of something else ?


As a final note, the openssh fix appears to be in 5.7p1

https://bugzilla.mindrot.org/show_bug.cgi?id=1838

 and I am running an updated F15 as of today

[root@duff ~]# rpm -q openssh
openssh-5.6p1-33.fc15.1.x86_64

I guess I'll file a F15 bug later tonight, as I can't find one
 already asking for the 5.7p1 fix backport to 5.6x.


Thanks,

--alessandro

 "There's always a siren singing you to shipwreck"

   (Radiohead, "There There")
