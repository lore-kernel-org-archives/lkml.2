Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752746Ab0CUK0M (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Mar 2010 06:26:12 -0400
Received: from webbox4.loswebos.de ([213.187.93.205]:41732 "EHLO
	webbox4.loswebos.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752595Ab0CUK0L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Mar 2010 06:26:11 -0400
Date: Sun, 21 Mar 2010 11:16:44 +0100
From: Marc Koschewski <marc@osknowledge.org>
To: Linux-LKLM <linux-kernel@vger.kernel.org>
Subject: BUG: unable to handle kernel paging request at 437d5ff0
Message-ID: <20100321101643.GB32201@shmoo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-PGP-Fingerprint: D514 7DC1 B5F5 8989 083E  38C9 5ECF E5BD 3430 ABF5
X-PGP-Key: http://www.osknowledge.org/~marc/pubkey.asc
X-Operating-System: Linux shmoo 2.6.34-rc2-marc-19754-g220bf99
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


[ 1134.673953] BUG: unable to handle kernel paging request at 437d5ff0
[ 1134.673965] IP: [<c01878f0>] page_referenced+0x17a/0x204
[ 1134.673979] *pdpt = 0000000035d84001 *pde = 000000007bab0067 
[ 1134.673984] Oops: 0000 [#2] PREEMPT 
[ 1134.673988] last sysfs file: /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
[ 1134.673993] Modules linked in: vboxnetflt vboxnetadp vboxdrv ipv6 af_packet bridge stp llc snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss snd_mixer_oss tun serial_cs i8k cpufreq_userspace cpufreq_powersave cpufreq_ondemand bluetooth acpi_cpufreq freq_table p54pci p54common mac80211 cfg80211 snd_intel8x0 mousedev snd_intel8x0m usbmouse firewire_ohci snd_ac97_codec usbhid firewire_core rfkill ac97_bus prism54 snd_pcm crc_itu_t snd_timer ohci1394 3c59x psmouse snd pcmcia rtc_cmos ieee1394 intel_agp sr_mod yenta_socket rsrc_nonstatic soundcore uhci_hcd dcdbas intel_rng rng_core mii serio_raw rtc_core pcmcia_core cdrom snd_page_alloc usbcore sg evdev rtc_lib floppy [last unloaded: microcode]
[ 1134.674015] 
[ 1134.674015] Pid: 4126, comm: eix-update Tainted: G      DA   2.6.34-rc2-marc-19754-g220bf99 #1 Inspiron 8200            /Inspiron 8200                   
[ 1134.674015] EIP: 0060:[<c01878f0>] EFLAGS: 00010286 CPU: 0
[ 1134.674015] EIP is at page_referenced+0x17a/0x204
[ 1134.674015] EAX: 464c457f EBX: 437d5ff0 ECX: f22d9750 EDX: 437d6000
[ 1134.674015] ESI: c1536740 EDI: 00000000 EBP: f5d17be0 ESP: f5d17ba0
[ 1134.674015]  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
[ 1134.674015] Process eix-update (pid: 4126, ti=f5d17000 task=f5d5f000 task.ti=f5d17000)
[ 1134.674015] Stack:
[ 1134.674015]  f5d17be0 c017480f f22d974c 00000000 f22d9750 ffffffff c057234c 00000020
[ 1134.674015] <0> 00000001 00000020 00000000 00000020 00000001 c1536740 f5d17ce0 c1536758
[ 1134.674015] <0> f5d17c48 c0175523 f5d17c34 00000001 c05720e0 00000000 00000001 00000000
[ 1134.674015] Call Trace:
[ 1134.674015]  [<c017480f>] ? isolate_pages_global+0x8f/0x1d0
[ 1134.674015]  [<c0175523>] ? shrink_active_list+0x148/0x257
[ 1134.674015]  [<c017625f>] ? shrink_zone+0x2c5/0x371
[ 1134.674015]  [<c0176c27>] ? do_try_to_free_pages+0x120/0x23b
[ 1134.674015]  [<c0176e39>] ? try_to_free_pages+0x6b/0x73
[ 1134.674015]  [<c0174780>] ? isolate_pages_global+0x0/0x1d0
[ 1134.674015]  [<c0171231>] ? __alloc_pages_nodemask+0x2bb/0x546
[ 1134.674015]  [<c0172be8>] ? __do_page_cache_readahead+0xe0/0x1e6
[ 1134.674015]  [<c0172d0f>] ? ra_submit+0x21/0x27
[ 1134.674015]  [<c0172e76>] ? ondemand_readahead+0x8f/0x1d6
[ 1134.674015]  [<c016bcbd>] ? find_get_page+0x84/0xca
[ 1134.674015]  [<c017307c>] ? page_cache_sync_readahead+0x32/0x4a
[ 1134.674015]  [<c016d84b>] ? generic_file_aio_read+0x32e/0x623
[ 1134.674015]  [<c01940fa>] ? do_sync_read+0x98/0xc5
[ 1134.674015]  [<c0170a7d>] ? __free_pages+0x28/0x2c
[ 1134.674015]  [<c0170aa9>] ? free_pages+0x28/0x2a
[ 1134.674015]  [<c0194b20>] ? vfs_read+0x89/0x147
[ 1134.674015]  [<c0194062>] ? do_sync_read+0x0/0xc5
[ 1134.674015]  [<c0194c7f>] ? sys_read+0x3d/0x64
[ 1134.674015]  [<c0102a8c>] ? sysenter_do_call+0x12/0x22
[ 1134.674015] Code: 00 00 00 8b 46 08 83 c0 01 89 45 f0 8b 45 c8 8b 50 04 8d 5a f0 8b 43 10 0f 18 00 90 8b 4d c8 83 c1 04 89 4d d0 31 ff 39 d1 74 4b <8b> 13 8b 4e 14 2b 4a 48 c1 e1 0c 03 4a 04 72 2a 3b 4a 08 73 25 
[ 1134.674015] EIP: [<c01878f0>] page_referenced+0x17a/0x204 SS:ESP 0068:f5d17ba0
-- 
Marc Koschewski
