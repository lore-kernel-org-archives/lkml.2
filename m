Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754023Ab1FBTQj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jun 2011 15:16:39 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:56301 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753608Ab1FBTQi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jun 2011 15:16:38 -0400
Message-ID: <4DE7E191.5030606@kernel.dk>
Date: Thu, 02 Jun 2011 21:16:33 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Jan Kara <jack@suse.cz>
CC: Mika Bostrom <bostik+lkml@bostik.iki.fi>, linux-kernel@vger.kernel.org
Subject: Re: Reproducible OOPS with UDF on flash
References: <20110602072411.GA26739@bostik.iki.fi> <20110602155102.GC5718@quack.suse.cz>
In-Reply-To: <20110602155102.GC5718@quack.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-06-02 17:51, Jan Kara wrote:
> On Thu 02-06-11 10:24:11, Mika Bostrom wrote:
>>   Hello hackers. I found a reliable way to oops the kernel - both
>> 2.6.38.6 and 2.6.39 are affected.
>>
>>   The setup is this:
>> - debian unstable
>> - configured udisks + usbmount to automount thumb drives
>> - attached a thumbdrive with UDF filesystem on it
>> - checked that drive was mounted
>> - removed drive
>> ==> OOPS
>   Thanks for report.
> 
>> Jun  1 20:45:18 odin usbmount[12856]: executing command: mount -tudf -onoexec,nodev,noatime,nodiratime /dev/sdf1 /media/usb0
>> Jun  1 20:45:18 odin kernel: UDF-fs: No anchor found
>> Jun  1 20:45:18 odin kernel: UDF-fs: Rescanning with blocksize 2048
>> Jun  1 20:45:18 odin kernel: UDF-fs INFO UDF: Mounting volume 'LinuxUDF', timestamp 2009/04/30 07:14 (1000)
>> Jun  1 20:45:18 odin usbmount[12856]: executing command: run-parts /etc/usbmount/mount.d
>> Jun  1 20:45:56 odin kernel: usb 2-1.1: USB disconnect, address 12
>> Jun  1 20:45:56 odin usbmount[12931]: executing command: umount -l /media/usb0
>> Jun  1 20:45:56 odin kernel: *pdpt = 00000000062d3001 *pde = 0000000000000000 
>> Jun  1 20:45:56 odin kernel: Modules linked in: udf crc_itu_t vfat fat vboxnetadp vboxnetflt fuse ipt_MASQUERADE iptable_nat nf_nat nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 iptable_filter ip_tables x_tables bridge ipv6 stp llc vboxdrv coretemp hwmon krng eseqiv rng aes_i586 aes_generic xts gf128mul cryptomgr aead dm_crypt crypto_hash crypto_blkcipher crypto_algapi dm_mod usb_storage raid1 md_mod hid_microsoft i915 fbcon font usbhid bitblit snd_hda_codec_idt snd_hda_intel snd_hda_codec softcursor snd_pcm_oss drm_kms_helper snd_mixer_oss drm fb fbdev snd_pcm snd_seq_dummy snd_seq_oss snd_seq_midi snd_rawmidi sr_mod cdrom i2c_algo_bit cfbcopyarea snd_seq_midi_event ata_generic video snd_seq intel_agp pata_marvell uhci_hcd ide_pci_generic snd_timer snd_seq_device e1000e backlight intel_gtt agpgart cfbimgblt cfbfillrect ehci_hcd snd evdev psmouse serio_raw i2c_i801 usbcore soundcore snd_page_alloc i2c_core processor button
>> Jun  1 20:45:56 odin kernel: 
>> Jun  1 20:45:56 odin kernel: Pid: 12936, comm: umount Not tainted 2.6.38.6 #2                  /DG965OT
>> Jun  1 20:45:56 odin kernel: EIP: 0060:[<c11daaaf>] EFLAGS: 00010002 CPU: 1
>> Jun  1 20:45:56 odin kernel: EIP is at __percpu_counter_add+0x1f/0xe0
>> Jun  1 20:45:56 odin kernel: EAX: 00000000 EBX: f526f390 ECX: 00000000 EDX: 00000001
>> Jun  1 20:45:56 odin kernel: ESI: f57785c0 EDI: e6e70758 EBP: ec94be9c ESP: ec94be84
>> Jun  1 20:45:56 odin kernel:  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
>> Jun  1 20:45:56 odin kernel:  ec94be94 e6e70748 f57785c0 f41166c0 f57785c0 e6e70758 ec94beb0 c1083323
>> Jun  1 20:45:56 odin kernel:  00000010 f57785c0 e6e70748 ec94bec8 c10cd6d7 00000000 f2269000 c7dae858
>> Jun  1 20:45:56 odin kernel:  c7dae800 ec94bed4 c10cd7a5 eb9cfc80 ec94bef4 fb3f8a81 c7dae810 eb9cfce4
>> Jun  1 20:45:56 odin kernel:  [<c1083323>] account_page_dirtied+0x63/0x90
>> Jun  1 20:45:56 odin kernel:  [<c10cd6d7>] __set_page_dirty+0x37/0xb0
>> Jun  1 20:45:56 odin kernel:  [<c10cd7a5>] mark_buffer_dirty+0x55/0x80
>> Jun  1 20:45:56 odin kernel:  [<fb3f8a81>] udf_close_lvid+0xb1/0xe0 [udf]
>> Jun  1 20:45:56 odin kernel:  [<fb3f8ee5>] udf_put_super+0xa5/0xc0 [udf]
>> Jun  1 20:45:56 odin kernel:  [<c10aad39>] generic_shutdown_super+0x59/0xd0
>> Jun  1 20:45:56 odin kernel:  [<c10aadd4>] kill_block_super+0x24/0x70
>> Jun  1 20:45:56 odin kernel:  [<c10ab0a5>] deactivate_locked_super+0x35/0x60
>> Jun  1 20:45:56 odin kernel:  [<c10abcc2>] deactivate_super+0x42/0x60
>> Jun  1 20:45:56 odin kernel:  [<c10c2302>] mntput_no_expire+0x82/0xd0
>> Jun  1 20:45:56 odin kernel:  [<c10c2d30>] sys_umount+0x60/0x330
>> Jun  1 20:45:56 odin kernel:  [<c1002bd0>] sysenter_do_call+0x12/0x26
>   This looks like the same problem as bug
> https://bugzilla.kernel.org/show_bug.cgi?id=36262
> 
>   And indeed in your case I'm not that surprised that BDI has been
> destroyed before the filesystem was unmounted. Jens, these BDI lifetime
> rules should really be sorted out... I remember you were looking into these
> issues already, weren't you?

Churning, I'll try and post something real soon now. I have fiddled with
it, just didn't get the time to finish it.

-- 
Jens Axboe

