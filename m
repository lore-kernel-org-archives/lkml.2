Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751372Ab0HATiq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Aug 2010 15:38:46 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:45954 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750999Ab0HATin (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Aug 2010 15:38:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=LYkGG7OtSFsdHzrVkj2834ywhBqw2LKkNretWLZcZo6YaqKLvdPYncUgVcCOr5b1Ui
         pz32FRKnZzhxJV5U6T5Q/ULjrfQNdeWgGPm2pJmfBd6uP91fgNd8JtLCigabnCSw9fvG
         2JIkGREGSuskRrLNp7nW4wzDcoPT9kTOg+G0c=
Message-ID: <4C55CD68.1020401@lwfinger.net>
Date: Sun, 01 Aug 2010 14:39:20 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100714 SUSE/3.0.6 Thunderbird/3.0.6
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Linux ACPI <linux-acpi@vger.kernel.org>,
        Linux PM List <linux-pm@lists.linux-foundation.org>,
        Linux SCSI List <linux-scsi@vger.kernel.org>,
        Linux Wireless List <linux-wireless@vger.kernel.org>,
        DRI <dri-devel@lists.freedesktop.org>
Subject: Re: 2.6.35-rc6-git6: Reported regressions from 2.6.34
References: <2dWFdr9kTFM.A.P0D.spXVMB@chimera>
In-Reply-To: <2dWFdr9kTFM.A.P0D.spXVMB@chimera>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/01/2010 08:46 AM, Rafael J. Wysocki wrote:
> This message contains a list of some regressions from 2.6.34,
> for which there are no fixes in the mainline known to the tracking team.
> If any of them have been fixed already, please let us know.
> 
> If you know of any other unresolved regressions from 2.6.34, please let us
> know either and we'll add them to the list.  Also, please let us know
> if any of the entries below are invalid.
> 
> Each entry from the list will be sent additionally in an automatic reply
> to this message with CCs to the people involved in reporting and handling
> the issue.

> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=16312
> Subject		: WARNING: at fs/fs-writeback.c:1127 __mark_inode_dirty
> Submitter	: Zdenek Kabelac <zdenek.kabelac@gmail.com>
> Date		: 2010-06-28 9:40 (35 days old)
> Message-ID	: <AANLkTin24fr5O4_q5Xbo9Y_NKkEmtcp6Hgmr9_4qXaFz@mail.gmail.com>
> References	: http://marc.info/?l=linux-kernel&m=127771804806465&w=2
> Handled-By	: Jan Kara <jack@suse.cz>
> Patch		: https://bugzilla.kernel.org/attachment.cgi?id=27272

I am beginning to think that Bug 16312 is not the same as Bug 16122. Even with
the patches from 16312, I still get warnings as below:

[   11.728776] ------------[ cut here ]------------
[   11.728787] WARNING: at fs/fs-writeback.c:964 __mark_inode_dirty+0x10f/0x1a0()
[   11.728790] Hardware name: HP Pavilion dv2700 Notebook PC
[   11.728792] Modules linked in: loop(+) dm_mod ide_cd_mod cdrom
snd_hda_codec_conexant ide_pci_generic arc4 ecb b43 rng_core mac80211
snd_hda_intel r8712u(C) cfg80211 snd_hda_codec amd74xx snd_pcm sg ide_core
rfkill led_class snd_timer ssb mmc_core pcmcia snd joydev k8temp hwmon
i2c_nforce2 pcmcia_core forcedeth serio_raw snd_page_alloc i2c_core battery ac
button ext4 mbcache jbd2 crc16 ohci_hcd sd_mod ehci_hcd usbcore fan processor
ahci libahci libata scsi_mod thermal
[   11.728854] Pid: 2449, comm: udisks-part-id Tainted: G         C
2.6.35-rc6-realtek+ #15
[   11.728857] Call Trace:
[   11.728865]  [<ffffffff8104608a>] warn_slowpath_common+0x7a/0xb0
[   11.728869]  [<ffffffff810460d5>] warn_slowpath_null+0x15/0x20
[   11.728874]  [<ffffffff81129d5f>] __mark_inode_dirty+0x10f/0x1a0
[   11.728879]  [<ffffffff8111e07d>] touch_atime+0x12d/0x170
[   11.728885]  [<ffffffff810cab91>] generic_file_aio_read+0x5c1/0x720
[   11.728890]  [<ffffffff81107ca2>] do_sync_read+0xd2/0x110
[   11.728896]  [<ffffffff81077e7d>] ? trace_hardirqs_on+0xd/0x10
[   11.728900]  [<ffffffff811083c3>] vfs_read+0xb3/0x170
[   11.728906]  [<ffffffff81002d1c>] ? sysret_check+0x27/0x62
[   11.728909]  [<ffffffff811084cc>] sys_read+0x4c/0x80
[   11.728914]  [<ffffffff81002ceb>] system_call_fastpath+0x16/0x1b
[   11.728917] ---[ end trace 32e16cacad33229f ]---
[   11.728919] bdi-block not registered

The warnings do not occur with every boot and appear to be some kind of race
condition.

Larry
