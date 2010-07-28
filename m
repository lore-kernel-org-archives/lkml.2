Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756453Ab0G1Vgu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 17:36:50 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:56629 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753101Ab0G1Vgr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 17:36:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=tyvSgHsko/a8OX5ba/P2sp3t7HTkrBTUAEttENKf1W4Yjux61pGqlzRZ6RX4adLpNy
         QIf28bzR0QR0qPM7CHGEcKIkzeJbw8X/Q86I96e3m/I0yu/xeC6vOlJFhk9HRk5BgqUn
         QBjtU2Dk5UeAJKw1cmHP8YJQn8e1iTioFJB8g=
Message-ID: <4C50A2EB.1080804@gmail.com>
Date: Wed, 28 Jul 2010 15:36:43 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100720 Fedora/3.1.1-1.fc13 Lightning/1.0b2pre Thunderbird/3.1.1
MIME-Version: 1.0
To: Linux-kernel <linux-kernel@vger.kernel.org>
Subject: warning at __set_page_dirty in backport of perf counters from 2.6.31.14
 to 2.6.27.48
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I would like to get the perf tool working with the 2.6.27 kernel series.
To that end I have been working on backporting the code from 2.6.31.14.

I am hitting a WARN_ON_ONCE in __set_page_dirty that has me stumped. The
backtrace is:

[ 1774.073892] ------------[ cut here ]------------
[ 1774.073895] WARNING: at fs/buffer.c:711 __set_page_dirty+0x72/0x126()
[ 1774.073898] Modules linked in: nfs lockd nfs_acl sunrpc dm_multipath
uinput i2c_piix4 i2c_core pcspkr virtio_net floppy virtio_blk virtio_pci
virtio_ring virtio ext3 jbd mbcache [last unloaded: microcode]
[ 1774.073916] Pid: 1911, comm: perf Not tainted 2.6.27.48 #22
[ 1774.073919]  [<c065bcf8>] ? printk+0x14/0x1c
[ 1774.073965]  [<c042d9a7>] warn_on_slowpath+0x46/0x6a
[ 1774.073991]  [<c04771d9>] ? zone_watermark_ok+0xe/0xa4
[ 1774.074017]  [<c04770d5>] ? constant_test_bit+0x9/0x20
[ 1774.074022]  [<c0478d02>] ? get_page_from_freelist+0x348/0x453
[ 1774.074027]  [<c04154ab>] ? __cpus_empty+0xd/0x44
[ 1774.074039]  [<c04b62e1>] ? constant_test_bit+0x9/0x20
[ 1774.074043]  [<c04b757e>] __set_page_dirty+0x72/0x126
[ 1774.074048]  [<c04b7a36>] __set_page_dirty_buffers+0x62/0x66
[ 1774.074051]  [<c04798c5>] set_page_dirty+0x2a/0xbc
[ 1774.074054]  [<c0481451>] do_wp_page+0x5c2/0x629
[ 1774.074058]  [<c0474f56>] ? generic_file_buffered_write+0x17d/0x50d
[ 1774.074064]  [<c0482d42>] handle_mm_fault+0x8d5/0x980
[ 1774.074068]  [<c047360d>] ? generic_write_checks+0xe/0x1f5
[ 1774.074073]  [<c0444abd>] ? getnstimeofday+0x54/0xdc
[ 1774.074085]  [<c065f9ba>] do_page_fault+0x346/0x75a
[ 1774.074089]  [<f887d595>] ? constant_test_bit+0x9/0x20 [nfs]
[ 1774.074114]  [<f887e1bd>] ? nfs_file_write+0x11d/0x14c [nfs]
[ 1774.074134]  [<c04998ce>] ? do_sync_write+0xb0/0xee
[ 1774.074154]  [<c043f023>] ? autoremove_wake_function+0x0/0x38
[ 1774.074167]  [<c04bfa7d>] ? inotify_inode_queue_event+0xe/0xb6
[ 1774.074204]  [<c04bffb7>] ? inotify_dentry_parent_queue_event+0xe/0x83
[ 1774.074204]  [<c049962d>] ? fsnotify_modify+0x54/0x5f
[ 1774.074204]  [<c049981e>] ? do_sync_write+0x0/0xee
[ 1774.074204]  [<c049a10d>] ? vfs_write+0xa9/0xe4
[ 1774.074204]  [<c049a1eb>] ? sys_write+0x40/0x65
[ 1774.074204]  [<c065f674>] ? do_page_fault+0x0/0x75a
[ 1774.074204]  [<c065deda>] error_code+0x72/0x78
[ 1774.074204]  =======================
[ 1774.074204] ---[ end trace 555130f3852ca6a3 ]---

I am not subscribed to this list, so please cc me to any response.

Thanks,

David
