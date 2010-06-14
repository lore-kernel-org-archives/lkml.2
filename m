Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757207Ab0FNWiR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 18:38:17 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:55014 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757044Ab0FNWiQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 18:38:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=pHxrSNnBooBY8QLSDabKsCZZ0K2AKiPCWx0AEHZh/N00L6TVZ1E8DDKlklnkg0lKVV
         fssvAuDUUX98PAtaY64zKfAoenBwvT1nS21WIiZyG3xu5AoJAkdJMBSpL5nI1POA4/qp
         IvhhUqhuN0xf5CqqGQMVoosKuTji+xfL+TWvY=
Message-ID: <4C16AF56.1040002@panasas.com>
Date: Mon, 14 Jun 2010 18:38:14 -0400
From: Benny Halevy <bhalevy@panasas.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090925 Remi/fc9 Thunderbird/3.0b4
MIME-Version: 1.0
To: Dave Airlie <airlied@redhat.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: drm/i915 BUG with 2.6.35-rc
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Seen the following BUGs with 2.6.35-rc2 and -rc3 (haven't tested with -rc1 on this machine)
Here's an excerpt from /var/log/messages:

Jun 14 17:49:29 lt acpid: client connected from 2329[0:0]
Jun 14 17:49:31 lt NetworkManager: <WARN>  nm_signal_handler(): Caught signal 15, shutting down normally.
Jun 14 17:49:31 lt NetworkManager: <info>  (wlan0): now unmanaged
Jun 14 17:49:31 lt NetworkManager: <info>  (wlan0): device state change: 3 -> 1
Jun 14 17:49:31 lt NetworkManager: <info>  (wlan0): cleaning up...
Jun 14 17:49:31 lt NetworkManager: <info>  (wlan0): taking down device.
Jun 14 17:49:31 lt kernel: ------------[ cut here ]------------
Jun 14 17:49:31 lt kernel: kernel BUG at /usr0/home/bhalevy/dev/git/linux-pnfs-bh-nfs41/drivers/gpu/drm/drm_gem.c:447!
Jun 14 17:49:31 lt kernel: invalid opcode: 0000 [#1] SMP DEBUG_PAGEALLOC
Jun 14 17:49:31 lt kernel: last sysfs file: /sys/devices/virtual/dmi/id/chassis_asset_tag
Jun 14 17:49:31 lt kernel: CPU 0 
Jun 14 17:49:31 lt kernel: Modules linked in: nfsd lockd exportfs nfs_acl auth_rpcgss autofs4 sunrpc ip6_tables ipv6 cpufreq_ondemand acpi_cpufreq freq_table mperf fuse dm_mirror dm_region_hash dm_log dm_multipath dm_mod snd_hda_codec_idt snd_hda_intel snd_hda_codec snd_hwdep snd_seq_dummy i915 snd_seq_oss snd_seq_midi_event arc4 snd_seq ecb iwl3945 snd_seq_device snd_pcm_oss iwlcore snd_mixer_oss drm_kms_helper mac80211 drm snd_pcm snd_timer cfg80211 snd soundcore snd_page_alloc dell_laptop i2c_i801 i2c_algo_bit sg rng_core rfkill i2c_core wmi button dcdbas battery ac video output ata_piix ata_generic libata sd_mod scsi_mod ext3 jbd mbcache uhci_hcd ohci_hcd ehci_hcd [last unloaded: microcode]
Jun 14 17:49:31 lt kernel:
Jun 14 17:49:31 lt kernel: Pid: 2329, comm: Xorg Not tainted 2.6.35-rc3-pnfs #4 0FT292/Latitude D620                   
Jun 14 17:49:31 lt kernel: RIP: 0010:[<ffffffffa024e878>]  [<ffffffffa024e878>] drm_gem_object_free+0x14/0x2f [drm]
Jun 14 17:49:31 lt kernel: RSP: 0018:ffff8800738ddcd8  EFLAGS: 00010246
Jun 14 17:49:31 lt kernel: RAX: 0000000000000000 RBX: ffff88007defc200 RCX: 0000000000000000
Jun 14 17:49:31 lt kernel: RDX: ffff88007e123800 RSI: 0000000000000037 RDI: ffff88007defc200
Jun 14 17:49:31 lt kernel: RBP: ffff8800738ddcd8 R08: ffffffff816932d0 R09: ffffffff816fc4c8
Jun 14 17:49:31 lt kernel: R10: ffff8800738ddc00 R11: ffff88007e123800 R12: ffffffffa024e864
Jun 14 17:49:31 lt kernel: R13: ffff88007e123800 R14: ffff880077a335b0 R15: ffff8800738f99c0
Jun 14 17:49:31 lt kernel: FS:  00007f38f3bbf780(0000) GS:ffff880001a00000(0000) knlGS:0000000000000000
Jun 14 17:49:31 lt kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Jun 14 17:49:31 lt kernel: CR2: 0000000002a330e8 CR3: 000000007e216000 CR4: 00000000000006f0
Jun 14 17:49:31 lt kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Jun 14 17:49:31 lt kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Jun 14 17:49:31 lt kernel: Process Xorg (pid: 2329, threadinfo ffff8800738dc000, task ffff88007769da40)
Jun 14 17:49:31 lt kernel: Stack:
Jun 14 17:49:31 lt kernel: ffff8800738ddcf8 ffffffff81183576 ffff88007d90e028 ffff88007e123800
Jun 14 17:49:31 lt kernel: <0> ffff8800738ddd18 ffffffffa03b8b77 ffff88007d90e000 ffff88007e123800
Jun 14 17:49:31 lt kernel: <0> ffff8800738ddd38 ffffffffa03947cb ffff88007d90e000 ffff8800738dddb8
Jun 14 17:49:31 lt kernel: Call Trace:
Jun 14 17:49:31 lt kernel: [<ffffffff81183576>] kref_put+0x43/0x4f
Jun 14 17:49:31 lt kernel: [<ffffffffa03b8b77>] intel_cleanup_ring_buffer+0x46/0x5e [i915]
Jun 14 17:49:31 lt kernel: [<ffffffffa03947cb>] i915_dma_cleanup+0x30/0xbc [i915]
Jun 14 17:49:31 lt kernel: [<ffffffffa0395bdf>] i915_dma_init+0xaf/0x283 [i915]
Jun 14 17:49:31 lt kernel: [<ffffffffa024d2f7>] drm_ioctl+0x29c/0x37e [drm]
Jun 14 17:49:31 lt kernel: [<ffffffffa0395b30>] ? i915_dma_init+0x0/0x283 [i915]
Jun 14 17:49:31 lt kernel: [<ffffffff810ef075>] ? do_sync_write+0xcc/0x112
Jun 14 17:49:31 lt kernel: [<ffffffff810fbff9>] vfs_ioctl+0x2f/0xa3
Jun 14 17:49:31 lt kernel: [<ffffffff810fc5e3>] do_vfs_ioctl+0x4f6/0x52a
Jun 14 17:49:31 lt kernel: [<ffffffff810eed5e>] ? fsnotify_modify+0x7c/0x85
Jun 14 17:49:31 lt kernel: [<ffffffff810fc671>] sys_ioctl+0x5a/0x7c
Jun 14 17:49:31 lt kernel: [<ffffffff81002d72>] system_call_fastpath+0x16/0x1b
Jun 14 17:49:31 lt kernel: Code: ff ff ff 48 83 c4 18 44 89 e0 5b 41 5c 41 5d 41 5e 41 5f c9 c3 90 90 55 48 89 e5 0f 1f 44 00 00 48 8b 57 08 8b 42 20 ff c8 75 04 <0f> 0b eb fe 48 8b 82 c8 03 00 00 48 8b 80 38 01 00 00 48 85 c0 
Jun 14 17:49:31 lt kernel: RIP  [<ffffffffa024e878>] drm_gem_object_free+0x14/0x2f [drm]
Jun 14 17:49:31 lt kernel: RSP <ffff8800738ddcd8>
Jun 14 17:49:31 lt kernel: ---[ end trace 267e40534f71eb64 ]---
Jun 14 17:49:31 lt kernel: [drm:drm_release] *ERROR* Device busy: 1
Jun 14 17:49:31 lt gdm-binary[2250]: WARNING: GdmDisplay: display lasted 2.938716 seconds
Jun 14 17:49:31 lt NetworkManager: <info>  exiting (success)
Jun 14 17:49:31 lt acpid: client 2329[0:0] has disconnected
Jun 14 17:49:31 lt acpid: client connected from 2342[0:0]
Jun 14 17:49:31 lt acpid: exiting
Jun 14 17:49:32 lt console-kit-daemon[1933]: GLib-CRITICAL: g_async_queue_unref: assertion `queue->waiting_threads == 0' failed
Jun 14 17:49:32 lt nm-system-settings: disconnected from the system bus, exiting.
Jun 14 17:49:32 lt rpc.statd[1841]: Caught signal 15, un-registering and exiting.
Jun 14 17:49:32 lt rpcbind: rpcbind terminating on signal. Restart with "rpcbind -w"
Jun 14 17:49:32 lt auditd[1781]: The audit daemon is exiting.
Jun 14 17:49:32 lt kernel: type=1305 audit(1276552172.481:3): audit_pid=0 old=1781 auid=4294967295 ses=4294967295 res=1
Jun 14 17:49:32 lt pcscd: pcscdaemon.c:572:signal_trap() Preparing for suicide
Jun 14 17:49:33 lt pcscd: readerfactory.c:1379:RFCleanupReaders() entering cleaning function
Jun 14 17:49:33 lt pcscd: readerfactory.c:1388:RFCleanupReaders() Stopping reader: O2 Micro Oz776 00 00
Jun 14 17:49:33 lt pcscd: eventhandler.c:120:EHDestroyEventHandler() Stomping thread.
Jun 14 17:49:33 lt kernel: iounmap: bad address ffffc90008040000
Jun 14 17:49:33 lt kernel: Pid: 2342, comm: Xorg Tainted: G      D     2.6.35-rc3-pnfs #4
Jun 14 17:49:33 lt kernel: Call Trace:
Jun 14 17:49:33 lt kernel: [<ffffffff810266a2>] iounmap+0x86/0xbf
Jun 14 17:49:33 lt kernel: [<ffffffffa02510d7>] drm_core_ioremapfree+0x56/0x58 [drm]
Jun 14 17:49:33 lt kernel: [<ffffffffa03b8b59>] intel_cleanup_ring_buffer+0x28/0x5e [i915]
Jun 14 17:49:33 lt kernel: [<ffffffffa03947cb>] i915_dma_cleanup+0x30/0xbc [i915]
Jun 14 17:49:33 lt kernel: [<ffffffffa0395bdf>] i915_dma_init+0xaf/0x283 [i915]
Jun 14 17:49:33 lt kernel: [<ffffffffa024d2f7>] drm_ioctl+0x29c/0x37e [drm]
Jun 14 17:49:33 lt kernel: [<ffffffffa0395b30>] ? i915_dma_init+0x0/0x283 [i915]
Jun 14 17:49:33 lt kernel: [<ffffffff810ef075>] ? do_sync_write+0xcc/0x112
Jun 14 17:49:33 lt kernel: [<ffffffff810fbff9>] vfs_ioctl+0x2f/0xa3
Jun 14 17:49:33 lt kernel: [<ffffffff810fc5e3>] do_vfs_ioctl+0x4f6/0x52a
Jun 14 17:49:33 lt kernel: [<ffffffff810eed5e>] ? fsnotify_modify+0x7c/0x85
Jun 14 17:49:33 lt kernel: [<ffffffff810fc671>] sys_ioctl+0x5a/0x7c
Jun 14 17:49:33 lt kernel: [<ffffffff81002d72>] system_call_fastpath+0x16/0x1b
Jun 14 17:49:33 lt kernel: ------------[ cut here ]------------
Jun 14 17:49:33 lt kernel: kernel BUG at /usr0/home/bhalevy/dev/git/linux-pnfs-bh-nfs41/drivers/gpu/drm/i915/i915_gem.c:4195!
Jun 14 17:49:33 lt kernel: invalid opcode: 0000 [#2] SMP DEBUG_PAGEALLOC
Jun 14 17:49:33 lt kernel: last sysfs file: /sys/devices/virtual/dmi/id/chassis_asset_tag
Jun 14 17:49:33 lt kernel: CPU 1 
Jun 14 17:49:33 lt kernel: Modules linked in: nfsd lockd exportfs nfs_acl auth_rpcgss autofs4 sunrpc ip6_tables ipv6 cpufreq_ondemand acpi_cpufreq freq_table mperf fuse dm_mirror dm_region_hash dm_log dm_multipath dm_mod snd_hda_codec_idt snd_hda_intel snd_hda_codec snd_hwdep snd_seq_dummy i915 snd_seq_oss snd_seq_midi_event arc4 snd_seq ecb iwl3945 snd_seq_device snd_pcm_oss iwlcore snd_mixer_oss drm_kms_helper mac80211 drm snd_pcm snd_timer cfg80211 snd soundcore snd_page_alloc dell_laptop i2c_i801 i2c_algo_bit sg rng_core rfkill i2c_core wmi button dcdbas battery ac video output ata_piix ata_generic libata sd_mod scsi_mod ext3 jbd mbcache uhci_hcd ohci_hcd ehci_hcd [last unloaded: microcode]
Jun 14 17:49:33 lt kernel:
Jun 14 17:49:33 lt kernel: Pid: 2342, comm: Xorg Tainted: G      D     2.6.35-rc3-pnfs #4 0FT292/Latitude D620                   
Jun 14 17:49:33 lt kernel: RIP: 0010:[<ffffffffa039e63d>]  [<ffffffffa039e63d>] i915_gem_object_unpin+0x4a/0xbf [i915]
Jun 14 17:49:33 lt kernel: RSP: 0018:ffff880077939ce8  EFLAGS: 00010296
Jun 14 17:49:33 lt kernel: RAX: 000000000003c47c RBX: ffff88007defc200 RCX: 000000000003c000
Jun 14 17:49:33 lt kernel: RDX: 00000000ffffffff RSI: ffff88007d90e000 RDI: ffff88007defc200
Jun 14 17:49:33 lt kernel: RBP: ffff880077939cf8 R08: ffff880077939b38 R09: 0000ffffffff6c10
Jun 14 17:49:33 lt kernel: R10: 000000000000000f R11: 0000000000000078 R12: ffff88007e123800
Jun 14 17:49:33 lt kernel: R13: ffff88007e123800 R14: ffff880077a335e0 R15: ffff88007d91c0c0
Jun 14 17:49:33 lt kernel: FS:  00007fa018bba780(0000) GS:ffff880001b00000(0000) knlGS:0000000000000000
Jun 14 17:49:33 lt kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Jun 14 17:49:33 lt kernel: CR2: 00000000025e40e8 CR3: 00000000779b1000 CR4: 00000000000006e0
Jun 14 17:49:33 lt kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Jun 14 17:49:33 lt kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Jun 14 17:49:33 lt kernel: Process Xorg (pid: 2342, threadinfo ffff880077938000, task ffff880077699690)
Jun 14 17:49:33 lt kernel: Stack:
Jun 14 17:49:33 lt kernel: ffff88007d90e028 ffff88007e123800 ffff880077939d18 ffffffffa03b8b62
Jun 14 17:49:33 lt kernel: <0> ffff88007d90e000 ffff88007e123800 ffff880077939d38 ffffffffa03947cb
Jun 14 17:49:33 lt kernel: <0> ffff88007d90e000 ffff880077939db8 ffff880077939d68 ffffffffa0395bdf
Jun 14 17:49:33 lt kernel: Call Trace:
Jun 14 17:49:33 lt kernel: [<ffffffffa03b8b62>] intel_cleanup_ring_buffer+0x31/0x5e [i915]
Jun 14 17:49:33 lt kernel: [<ffffffffa03947cb>] i915_dma_cleanup+0x30/0xbc [i915]
Jun 14 17:49:33 lt kernel: [<ffffffffa0395bdf>] i915_dma_init+0xaf/0x283 [i915]
Jun 14 17:49:33 lt kernel: [<ffffffffa024d2f7>] drm_ioctl+0x29c/0x37e [drm]
Jun 14 17:49:33 lt kernel: [<ffffffffa0395b30>] ? i915_dma_init+0x0/0x283 [i915]
Jun 14 17:49:33 lt kernel: [<ffffffff810ef075>] ? do_sync_write+0xcc/0x112
Jun 14 17:49:33 lt kernel: [<ffffffff810fbff9>] vfs_ioctl+0x2f/0xa3
Jun 14 17:49:33 lt kernel: [<ffffffff810fc5e3>] do_vfs_ioctl+0x4f6/0x52a
Jun 14 17:49:33 lt kernel: [<ffffffff810eed5e>] ? fsnotify_modify+0x7c/0x85
Jun 14 17:49:33 lt kernel: [<ffffffff810fc671>] sys_ioctl+0x5a/0x7c
Jun 14 17:49:33 lt kernel: [<ffffffff81002d72>] system_call_fastpath+0x16/0x1b
Jun 14 17:49:33 lt kernel: Code: ff 49 8b b4 24 98 03 00 00 c1 e2 0e c1 fa 1c ff ca c1 e2 04 c0 fa 04 89 d1 83 e1 0f c1 e1 0e 09 c8 84 d2 89 87 b0 00 00 00 79 04 <0f> 0b eb fe 48 83 bf 88 00 00 00 00 75 04 0f 0b eb fe a9 00 c0 
Jun 14 17:49:33 lt kernel: RIP  [<ffffffffa039e63d>] i915_gem_object_unpin+0x4a/0xbf [i915]
Jun 14 17:49:33 lt kernel: RSP <ffff880077939ce8>
Jun 14 17:49:33 lt kernel: ---[ end trace 267e40534f71eb65 ]---
Jun 14 17:49:33 lt pcscd: eventhandler.c:148:EHDestroyEventHandler() Thread stomped.
Jun 14 17:49:33 lt pcscd: readerfactory.c:1164:RFUnInitializeReader() Attempting shutdown of O2 Micro Oz776 00 00.
Jun 14 17:49:33 lt pcscd: ifdhandler.c:222:IFDHCloseChannel() lun: 0
Jun 14 17:49:33 lt kernel: [drm:drm_release] *ERROR* Device busy: 1
Jun 14 17:49:33 lt pcscd: commands.c:688:CmdPowerOff Card absent or mute
Jun 14 17:49:33 lt pcscd: readerfactory.c:1025:RFUnloadReader() Unloading reader driver.
Jun 14 17:49:33 lt pcscd: pcscdaemon.c:532:at_exit() cleaning /var/run
Jun 14 17:49:35 lt console-kit-daemon[1933]: WARNING: Couldn't connect to system bus: Failed to connect to socket /var/run/dbus/system_bus_socket: Connection refused
Jun 14 17:49:36 lt kernel: Kernel logging (proc) stopped.
