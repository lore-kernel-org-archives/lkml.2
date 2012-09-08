Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754404Ab2IHSXp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2012 14:23:45 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:33471 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752268Ab2IHSXm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2012 14:23:42 -0400
Message-ID: <504B8CFE.5010005@ursulin.net>
Date: Sat, 08 Sep 2012 19:22:54 +0100
From: Tvrtko Ursulin <tvrtko@ursulin.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: David Howells <dhowells@redhat.com>
CC: linux-cachefs@redhat.com, linux-kernel@vger.kernel.org
Subject: fscache scheduling while atomic bugs under 3.4.10-rt18
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

I get a lot of those and was wondering if it is a generic fscache issues 
or in some way related to the RT patchset. Perhaps that the two do not 
play well together?

Traces typically look like this:

  BUG: scheduling while atomic: kworker/u:2/4151/0x00000002
  Modules linked in: snd_usb_audio snd_hwdep snd_usbmidi_lib fuse 
ip6table_filter ip6_tables ebtable_nat ebtables cachefiles 
ipt_MASQUERADE iptable_nat nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 
xt_state nf_conntrack ipt_REJECT iptable_mangle xt_tcpudp iptable_filter 
ip_tables x_tables bridge stp llc kvm_amd kvm autofs4 dm_crypt joydev 
usbhid hid snd_ice1712 nfsd snd_ice17xx_ak4xxx bnep snd_ak4xxx_adda 
snd_cs8427 snd_ac97_codec nfs bluetooth snd_pcm lockd fscache 
auth_rpcgss snd_page_alloc nfs_acl ac97_bus binfmt_misc sunrpc snd_i2c 
snd_mpu401_uart snd_seq_midi microcode snd_rawmidi snd_seq_midi_event 
snd_seq snd_timer snd_seq_device snd psmouse soundcore ext4 
firewire_ohci mbcache r8169 firewire_core jbd2 mii crc_itu_t pata_atiixp 
fglrx(PO) i2c_piix4 it87 hwmon_vid raid10 raid456 async_pq async_xor xor 
async_memcpy async_raid6_recov raid6_pq async_tx raid1 linear xfs raid0 
ahci libahci
  Pid: 4151, comm: kworker/u:2 Tainted: P           O 3.4.10-rt18 #1
  Call Trace:
   [<ffffffff813d8b0f>] __schedule_bug+0x43/0x45
   [<ffffffff813ddcda>] __schedule+0x64a/0x680
   [<ffffffff813de149>] schedule+0x29/0x80
   [<ffffffff813deda7>] rt_spin_lock_slowlock+0x14b/0x1e4
   [<ffffffff813df271>] rt_spin_lock+0x21/0x30
   [<ffffffff81045520>] __queue_work+0x180/0x330
   [<ffffffff8105644a>] ? ttwu_do_activate.constprop.76+0x4a/0x60
   [<ffffffff8104571d>] queue_work_on+0x1d/0x30
   [<ffffffff8104577e>] queue_work+0x2e/0x50
   [<ffffffff81055c9b>] ? migrate_enable+0xcb/0x1b0
   [<ffffffffa047aca5>] fscache_enqueue_object+0x65/0xd0 [fscache]
   [<ffffffffa047b2d2>] fscache_object_work_func+0x342/0xa20 [fscache]
   [<ffffffff81055c9b>] ? migrate_enable+0xcb/0x1b0
   [<ffffffffa047af90>] ? fscache_drop_object+0x170/0x170 [fscache]
   [<ffffffff81045a87>] process_one_work+0x117/0x3a0
   [<ffffffff81045d34>] process_scheduled_works+0x24/0x40
   [<ffffffff81046781>] worker_thread+0x271/0x340
   [<ffffffff81046510>] ? manage_workers.isra.30+0x230/0x230
   [<ffffffff8104bbde>] kthread+0x8e/0xa0
   [<ffffffff810546f9>] ? finish_task_switch+0x49/0xf0
   [<ffffffff813e1034>] kernel_thread_helper+0x4/0x10
   [<ffffffff8104bb50>] ? __init_kthread_worker+0x50/0x50
   [<ffffffff813e1030>] ? gs_change+0xb/0xb

Thanks,

Tvrtko
