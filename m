Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751608Ab0F1Jki (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 05:40:38 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:40811 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751470Ab0F1Jkg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 05:40:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=BXPelohsg/FNvim67tCqUhtL0wIFl6Mc034i/aLdiOzKy8j323QK3LFpuY5UXsKyD+
         /5irOGTMe3RCe51XGVlvgz6e0yyb9qd30ZWDnHze5Z+JIIXHGRsMRKLF5SSxqEH8l3Y6
         78zubByfEZ/UWj0zZC3FO8uwLeWhciMzxybbE=
MIME-Version: 1.0
Date: Mon, 28 Jun 2010 11:40:33 +0200
Message-ID: <AANLkTin24fr5O4_q5Xbo9Y_NKkEmtcp6Hgmr9_4qXaFz@mail.gmail.com>
Subject: WARNING: at fs/fs-writeback.c:1127 __mark_inode_dirty
From: Zdenek Kabelac <zdenek.kabelac@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: akpm@linux-foundation.org, jens.axboe@oracle.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

I've recompiled recent linux vanilla tree and I've got this warning:
(Lenovo T61, 4GB,  ext3 filesystem mounted with data=ordered)

WARNING: at fs/fs-writeback.c:1127 __mark_inode_dirty+0x103/0x170()
Hardware name: 6464CTO
Modules linked in: loop(+) ip6_tables xt_tcpudp bridge stp llc autofs4
sunrpc ipv6 ipt_REJECT xt_physdev xt_state iptable_filter
ipt_MASQUERADE iptable_nat nf_nat nf_conntrack_ipv4 nf_conntrack
nf_defrag_ipv4 ip_tables x_tables binfmt_misc dm_mirror dm_region_hash
dm_log dm_mod kvm_intel kvm i915 drm_kms_helper drm i2c_algo_bit
uinput snd_hda_codec_analog snd_hda_intel snd_hda_codec snd_seq arc4
ecb snd_seq_device snd_pcm cryptomgr crypto_hash aead pcompress
crypto_blkcipher snd_timer crypto_algapi iwl3945 thinkpad_acpi snd
iwlcore mac80211 cfg80211 psmouse btusb bluetooth soundcore nvram
iTCO_wdt serio_raw snd_page_alloc rfkill rtc_cmos wmi
iTCO_vendor_support ac rtc_core i2c_i801 rtc_lib i2c_core battery
e1000e evdev usbhid hid pcmcia sdhci_pci sdhci yenta_socket
pcmcia_rsrc mmc_core pcmcia_core led_class uhci_hcd ehci_hcd usbcore
video backlight output button [last unloaded: scsi_wait_scan]
Pid: 3919, comm: udisks-part-id Not tainted 2.6.35-rc3-00207-gfa637f6 #75
Call Trace:
 [<ffffffff8104bb7f>] warn_slowpath_common+0x7f/0xc0
 [<ffffffff8104bbda>] warn_slowpath_null+0x1a/0x20
 [<ffffffff81155493>] __mark_inode_dirty+0x103/0x170
 [<ffffffff81148bed>] touch_atime+0x12d/0x170
 [<ffffffff810ec134>] generic_file_aio_read+0x394/0x6f0
 [<ffffffff8113037a>] do_sync_read+0xda/0x120
 [<ffffffff81448869>] ? sub_preempt_count+0xa9/0xe0
 [<ffffffff81442645>] ? __mutex_unlock_slowpath+0xf5/0x170
 [<ffffffff81083ce5>] ? trace_hardirqs_on_caller+0x155/0x1a0
 [<ffffffff81083d3d>] ? trace_hardirqs_on+0xd/0x10
 [<ffffffff81221d86>] ? security_file_permission+0x16/0x20
 [<ffffffff81130e65>] vfs_read+0xb5/0x1a0
 [<ffffffff81130fa1>] sys_read+0x51/0x90
 [<ffffffff810030db>] system_call_fastpath+0x16/0x1b
bdi-block not registered


Zdenek
