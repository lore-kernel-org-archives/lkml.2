Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752000Ab1G3Pbz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jul 2011 11:31:55 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:47204 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751419Ab1G3Pbw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jul 2011 11:31:52 -0400
MIME-Version: 1.0
Date: Sat, 30 Jul 2011 17:31:51 +0200
Message-ID: <CAKWSe6B3hWt4ANpgoS4dRUZPju0Abey9y3DORVFqGYgMeF=gQA@mail.gmail.com>
Subject: warn_slowpath_common WARNING on boot since 3.0.0-git7
From: Alessandro Suardi <alessandro.suardi@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

F15 x86_64, still present in 3.0.0-git11; didn't report it earlier as I
 thought it'd be squashed sooner... probably it's not as common
 as I thought it'd be:

Jul 27 18:46:18 duff kernel: WARNING: at fs/proc/base.c:1123
oom_adjust_write+0x185/0x23c()
Jul 27 18:46:18 duff kernel: Hardware name: Latitude E6400
Jul 27 18:46:18 duff kernel: sshd (3245): /proc/3245/oom_adj is
deprecated, please use /proc/3245/oom_score_adj instead.
Jul 27 18:46:18 duff kernel: Modules linked in: sunrpc rfcomm bnep
ip6t_REJECT nf_conntrack_ipv6 ipt_REJECT nf_defrag_ipv6
nf_conntrack_ipv4 ip6table_filter nf_defrag_ipv4 ip6_tables xt_state
nf_conntrack iptable_filter ip_tables snd_hda_codec_hdmi
snd_hda_codec_idt snd_hda_intel snd_hda_codec aes_x86_64 aes_generic
ecb snd_hwdep btusb snd_seq snd_seq_device bluetooth snd_pcm
dell_laptop snd_timer snd i2c_i801 rfkill microcode pcspkr joydev
soundcore snd_page_alloc dcdbas ipv6 autofs4 ext4 jbd2 crc16 sdhci_pci
firewire_ohci sdhci firewire_core crc_itu_t mmc_core i915
drm_kms_helper drm i2c_algo_bit i2c_core video [last unloaded:
scsi_wait_scan]
Jul 27 18:46:18 duff kernel: Pid: 3245, comm: sshd Not tainted 3.0.0-git7 #6
Jul 27 18:46:18 duff kernel: Call Trace:
Jul 27 18:46:18 duff kernel: [<ffffffff8103774c>] warn_slowpath_common+0x7e/0x96
Jul 27 18:46:18 duff kernel: [<ffffffff810377f8>] warn_slowpath_fmt+0x41/0x43
Jul 27 18:46:18 duff kernel: [<ffffffff810408f4>] ? ns_capable+0x35/0x4a
Jul 27 18:46:18 duff kernel: [<ffffffff81129fb8>] oom_adjust_write+0x185/0x23c
Jul 27 18:46:18 duff kernel: [<ffffffff810e0736>] vfs_write+0xa3/0xca
Jul 27 18:46:18 duff kernel: [<ffffffff8109176f>] ?
trace_hardirqs_on_caller+0xe/0x22
Jul 27 18:46:18 duff kernel: [<ffffffff810e08d2>] sys_write+0x45/0x69
Jul 27 18:46:18 duff kernel: [<ffffffff813752fb>] system_call_fastpath+0x16/0x1b

--alessandro

 "There's always a siren singing you to shipwreck"

   (Radiohead, "There There")
