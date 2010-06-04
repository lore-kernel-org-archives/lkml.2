Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755784Ab0FDNWw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 09:22:52 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:46732 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755462Ab0FDNWu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 09:22:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=dpWd2hAL1APEEyqCHds+an8hyjzp4oEutJUv3gvJm4F72EGTSUxCwKf77Jp1ID3LLe
         68xSULVLEYbvc3RCL3fJLJhH+UoEPSzOoCMZtOGCSwHKW2iZODwgrc0mNNsqb/kFHmNk
         rZfEkLxSAgZwKDQoSKjKSWUTov71pVfpKMHQo=
Message-ID: <4C08FE3C.2010509@lwfinger.net>
Date: Fri, 04 Jun 2010 08:23:08 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100317 SUSE/3.0.4-1.20 Thunderbird/3.0.4
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
Subject: WARNING in __mark_inode_dirty for 2.6.35-rc1-00324-gad84563
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As reported in Bug #16122, I get the following warning when booting
2.6.25-rc1 from either Linus's mainline tree, or Linville's
wireless-testing tree. The traceback is as follows:

[   16.480278] ------------[ cut here ]------------
[   16.480288] WARNING: at fs/fs-writeback.c:1142
__mark_inode_dirty+0x103/0x170()
[   16.480291] Hardware name: HP Pavilion dv2700 Notebook PC
[   16.480293] Modules linked in: loop(+) dm_mod ide_cd_mod cdrom
snd_hda_codec_conexant arc4 ecb b43 ide_pci_generic rng_core mac80211
cfg80211 rfkill snd_hda_intel led_class snd_hda_codec ssb snd_pcm
mmc_core snd_timer amd74xx pcmcia k8temp snd i2c_nforce2 ide_core
soundcore serio_raw hwmon sg pcmcia_core joydev snd_page_alloc forcedeth
i2c_core ac battery button ext3 jbd mbcache ohci_hcd sd_mod ehci_hcd
usbcore fan processor ahci libahci libata scsi_mod thermal
[   16.480344] Pid: 2432, comm: udisks-part-id Not tainted
2.6.35-rc1-Linus-00324-gad84563 #202
[   16.480347] Call Trace:
[   16.480354]  [<ffffffff8104623a>] warn_slowpath_common+0x7a/0xb0
[   16.480358]  [<ffffffff81046285>] warn_slowpath_null+0x15/0x20
[   16.480362]  [<ffffffff81128f53>] __mark_inode_dirty+0x103/0x170
[   16.480367]  [<ffffffff8111d6cd>] touch_atime+0x12d/0x170
[   16.480372]  [<ffffffff810ca131>] generic_file_aio_read+0x5c1/0x720
[   16.480377]  [<ffffffff810e49d8>] ? handle_mm_fault+0x718/0x8b0
[   16.480381]  [<ffffffff81107302>] do_sync_read+0xd2/0x110
[   16.480387]  [<ffffffff8107ab85>] ? trace_hardirqs_on_caller+0x145/0x190
[   16.480391]  [<ffffffff8107abdd>] ? trace_hardirqs_on+0xd/0x10
[   16.480394]  [<ffffffff81107a23>] vfs_read+0xb3/0x170
[   16.480399]  [<ffffffff81002d1c>] ? sysret_check+0x27/0x62
[   16.480403]  [<ffffffff81107b2c>] sys_read+0x4c/0x80
[   16.480407]  [<ffffffff81002ceb>] system_call_fastpath+0x16/0x1b
[   16.480410] ---[ end trace f16a433c45bd0baa ]---
