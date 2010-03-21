Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752671Ab0CUKVN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Mar 2010 06:21:13 -0400
Received: from webbox4.loswebos.de ([213.187.93.205]:43445 "EHLO
	webbox4.loswebos.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752289Ab0CUKVL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Mar 2010 06:21:11 -0400
X-Greylist: delayed 502 seconds by postgrey-1.27 at vger.kernel.org; Sun, 21 Mar 2010 06:21:10 EDT
Date: Sun, 21 Mar 2010 11:12:25 +0100
From: Marc Koschewski <marc@osknowledge.org>
To: Linux-LKLM <linux-kernel@vger.kernel.org>
Subject: BUG: scheduling while atomic: eix-update/4126/0x10000002
Message-ID: <20100321101223.GA32201@shmoo>
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


[ 1134.683978] BUG: scheduling while atomic: eix-update/4126/0x10000002
[ 1134.683987] Modules linked in: vboxnetflt vboxnetadp vboxdrv ipv6 af_packet bridge stp llc snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss snd_mixer_oss tun serial_cs i8k cpufreq_userspace cpufreq_powersave cpufreq_ondemand bluetooth acpi_cpufreq freq_table p54pci p54common mac80211 cfg80211 snd_intel8x0 mousedev snd_intel8x0m usbmouse firewire_ohci snd_ac97_codec usbhid firewire_core rfkill ac97_bus prism54 snd_pcm crc_itu_t snd_timer ohci1394 3c59x psmouse snd pcmcia rtc_cmos ieee1394 intel_agp sr_mod yenta_socket rsrc_nonstatic soundcore uhci_hcd dcdbas intel_rng rng_core mii serio_raw rtc_core pcmcia_core cdrom snd_page_alloc usbcore sg evdev rtc_lib floppy [last unloaded: microcode]
[ 1134.684088] Pid: 4126, comm: eix-update Tainted: G      DA   2.6.34-rc2-marc-19754-g220bf99 #1
[ 1134.684091] Call Trace:
[ 1134.684107]  [<c03ec5b2>] ? printk+0x18/0x1e
[ 1134.684117]  [<c011f850>] __schedule_bug+0x58/0x5a
[ 1134.684121]  [<c03ec999>] schedule+0x3ad/0x4b1
[ 1134.684127]  [<c011fab9>] __cond_resched+0x16/0x26
[ 1134.684131]  [<c03ecb35>] _cond_resched+0x20/0x27
[ 1134.684137]  [<c017f115>] unmap_vmas+0x5ca/0x678
[ 1134.684144]  [<c018343c>] exit_mmap+0x9f/0x150
[ 1134.684150]  [<c0125273>] mmput+0x2a/0xb9
[ 1134.684155]  [<c0128b37>] exit_mm+0xce/0xe1
[ 1134.684163]  [<c0153d23>] ? acct_collect+0x141/0x143
[ 1134.684168]  [<c012a0ae>] do_exit+0xd0/0x6b4
[ 1134.684175]  [<c0105562>] oops_end+0x6e/0x97
[ 1134.684184]  [<c0118ce6>] no_context+0xb0/0x17d
[ 1134.684189]  [<c0118e2e>] __bad_area_nosemaphore+0x7b/0x110
[ 1134.684195]  [<c0170af9>] ? __pagevec_free+0x1d/0x2a
[ 1134.684200]  [<c0118ed5>] bad_area_nosemaphore+0x12/0x14
[ 1134.684205]  [<c01191ec>] do_page_fault+0x213/0x2a7
[ 1134.684211]  [<c0118fd9>] ? do_page_fault+0x0/0x2a7
[ 1134.684217]  [<c03eea1a>] error_code+0x5e/0x64
[ 1134.684223]  [<c0118fd9>] ? do_page_fault+0x0/0x2a7
[ 1134.684228]  [<c01878f0>] ? page_referenced+0x17a/0x204
[ 1134.684235]  [<c017480f>] ? isolate_pages_global+0x8f/0x1d0
[ 1134.684240]  [<c0175523>] shrink_active_list+0x148/0x257
[ 1134.684246]  [<c017625f>] shrink_zone+0x2c5/0x371
[ 1134.684251]  [<c0176c27>] do_try_to_free_pages+0x120/0x23b
[ 1134.684256]  [<c0176e39>] try_to_free_pages+0x6b/0x73
[ 1134.684261]  [<c0174780>] ? isolate_pages_global+0x0/0x1d0
[ 1134.684266]  [<c0171231>] __alloc_pages_nodemask+0x2bb/0x546
[ 1134.684272]  [<c0172be8>] __do_page_cache_readahead+0xe0/0x1e6
[ 1134.684277]  [<c0172d0f>] ra_submit+0x21/0x27
[ 1134.684282]  [<c0172e76>] ondemand_readahead+0x8f/0x1d6
[ 1134.684289]  [<c016bcbd>] ? find_get_page+0x84/0xca
[ 1134.684300]  [<c017307c>] page_cache_sync_readahead+0x32/0x4a
[ 1134.684306]  [<c016d84b>] generic_file_aio_read+0x32e/0x623
[ 1134.684314]  [<c01940fa>] do_sync_read+0x98/0xc5
[ 1134.684319]  [<c0170a7d>] ? __free_pages+0x28/0x2c
[ 1134.684324]  [<c0170aa9>] ? free_pages+0x28/0x2a
[ 1134.684329]  [<c0194b20>] vfs_read+0x89/0x147
[ 1134.684334]  [<c0194062>] ? do_sync_read+0x0/0xc5
[ 1134.684339]  [<c0194c7f>] sys_read+0x3d/0x64
[ 1134.684344]  [<c0102a8c>] sysenter_do_call+0x12/0x22
[ 1134.691059] BUG: scheduling while atomic: eix-update/4126/0x10000002
[ 1134.691067] Modules linked in: vboxnetflt vboxnetadp vboxdrv ipv6 af_packet bridge stp llc snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss snd_mixer_oss tun serial_cs i8k cpufreq_userspace cpufreq_powersave cpufreq_ondemand bluetooth acpi_cpufreq freq_table p54pci p54common mac80211 cfg80211 snd_intel8x0 mousedev snd_intel8x0m usbmouse firewire_ohci snd_ac97_codec usbhid firewire_core rfkill ac97_bus prism54 snd_pcm crc_itu_t snd_timer ohci1394 3c59x psmouse snd pcmcia rtc_cmos ieee1394 intel_agp sr_mod yenta_socket rsrc_nonstatic soundcore uhci_hcd dcdbas intel_rng rng_core mii serio_raw rtc_core pcmcia_core cdrom snd_page_alloc usbcore sg evdev rtc_lib floppy [last unloaded: microcode]
[ 1134.691157] Pid: 4126, comm: eix-update Tainted: G      DA   2.6.34-rc2-marc-19754-g220bf99 #1
[ 1134.691161] Call Trace:
[ 1134.691175]  [<c03ec5b2>] ? printk+0x18/0x1e
[ 1134.691183]  [<c011f850>] __schedule_bug+0x58/0x5a
[ 1134.691188]  [<c03ec999>] schedule+0x3ad/0x4b1
[ 1134.691193]  [<c011fab9>] __cond_resched+0x16/0x26
[ 1134.691198]  [<c03ecb35>] _cond_resched+0x20/0x27
[ 1134.691203]  [<c017f115>] unmap_vmas+0x5ca/0x678
[ 1134.691210]  [<c018343c>] exit_mmap+0x9f/0x150
[ 1134.691216]  [<c0125273>] mmput+0x2a/0xb9
[ 1134.691221]  [<c0128b37>] exit_mm+0xce/0xe1
[ 1134.691229]  [<c0153d23>] ? acct_collect+0x141/0x143
[ 1134.691233]  [<c012a0ae>] do_exit+0xd0/0x6b4
[ 1134.691240]  [<c0105562>] oops_end+0x6e/0x97
[ 1134.691248]  [<c0118ce6>] no_context+0xb0/0x17d
[ 1134.691254]  [<c0118e2e>] __bad_area_nosemaphore+0x7b/0x110
[ 1134.691260]  [<c0170af9>] ? __pagevec_free+0x1d/0x2a
[ 1134.691265]  [<c0118ed5>] bad_area_nosemaphore+0x12/0x14
[ 1134.691270]  [<c01191ec>] do_page_fault+0x213/0x2a7
[ 1134.691275]  [<c0118fd9>] ? do_page_fault+0x0/0x2a7
[ 1134.691282]  [<c03eea1a>] error_code+0x5e/0x64
[ 1134.691288]  [<c0118fd9>] ? do_page_fault+0x0/0x2a7
[ 1134.691293]  [<c01878f0>] ? page_referenced+0x17a/0x204
[ 1134.691300]  [<c017480f>] ? isolate_pages_global+0x8f/0x1d0
[ 1134.691305]  [<c0175523>] shrink_active_list+0x148/0x257
[ 1134.691311]  [<c017625f>] shrink_zone+0x2c5/0x371
[ 1134.691317]  [<c0176c27>] do_try_to_free_pages+0x120/0x23b
[ 1134.691322]  [<c0176e39>] try_to_free_pages+0x6b/0x73
[ 1134.691327]  [<c0174780>] ? isolate_pages_global+0x0/0x1d0
[ 1134.691332]  [<c0171231>] __alloc_pages_nodemask+0x2bb/0x546
[ 1134.691338]  [<c0172be8>] __do_page_cache_readahead+0xe0/0x1e6
[ 1134.691343]  [<c0172d0f>] ra_submit+0x21/0x27
[ 1134.691348]  [<c0172e76>] ondemand_readahead+0x8f/0x1d6
[ 1134.691354]  [<c016bcbd>] ? find_get_page+0x84/0xca
[ 1134.691359]  [<c017307c>] page_cache_sync_readahead+0x32/0x4a
[ 1134.691364]  [<c016d84b>] generic_file_aio_read+0x32e/0x623
[ 1134.691372]  [<c01940fa>] do_sync_read+0x98/0xc5
[ 1134.691378]  [<c0170a7d>] ? __free_pages+0x28/0x2c
[ 1134.691384]  [<c0170aa9>] ? free_pages+0x28/0x2a
[ 1134.691389]  [<c0194b20>] vfs_read+0x89/0x147
[ 1134.691394]  [<c0194062>] ? do_sync_read+0x0/0xc5
[ 1134.691400]  [<c0194c7f>] sys_read+0x3d/0x64
[ 1134.691405]  [<c0102a8c>] sysenter_do_call+0x12/0x22
[ 1134.694372] BUG: scheduling while atomic: eix-update/4126/0x10000002
[ 1134.694380] Modules linked in: vboxnetflt vboxnetadp vboxdrv ipv6 af_packet bridge stp llc snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss snd_mixer_oss tun serial_cs i8k cpufreq_userspace cpufreq_powersave cpufreq_ondemand bluetooth acpi_cpufreq freq_table p54pci p54common mac80211 cfg80211 snd_intel8x0 mousedev snd_intel8x0m usbmouse firewire_ohci snd_ac97_codec usbhid firewire_core rfkill ac97_bus prism54 snd_pcm crc_itu_t snd_timer ohci1394 3c59x psmouse snd pcmcia rtc_cmos ieee1394 intel_agp sr_mod yenta_socket rsrc_nonstatic soundcore uhci_hcd dcdbas intel_rng rng_core mii serio_raw rtc_core pcmcia_core cdrom snd_page_alloc usbcore sg evdev rtc_lib floppy [last unloaded: microcode]
[ 1134.694467] Pid: 4126, comm: eix-update Tainted: G      DA   2.6.34-rc2-marc-19754-g220bf99 #1
[ 1134.694471] Call Trace:
[ 1134.694483]  [<c03ec5b2>] ? printk+0x18/0x1e
[ 1134.694492]  [<c011f850>] __schedule_bug+0x58/0x5a
[ 1134.694497]  [<c03ec999>] schedule+0x3ad/0x4b1
[ 1134.694502]  [<c011fab9>] __cond_resched+0x16/0x26
[ 1134.694506]  [<c03ecb35>] _cond_resched+0x20/0x27
[ 1134.694512]  [<c0128cc2>] put_files_struct+0x7d/0xc5
[ 1134.694517]  [<c0128d41>] exit_files+0x37/0x48
[ 1134.694521]  [<c012a63d>] do_exit+0x65f/0x6b4
[ 1134.694528]  [<c0105562>] oops_end+0x6e/0x97
[ 1134.694536]  [<c0118ce6>] no_context+0xb0/0x17d
[ 1134.694541]  [<c0118e2e>] __bad_area_nosemaphore+0x7b/0x110
[ 1134.694547]  [<c0170af9>] ? __pagevec_free+0x1d/0x2a
[ 1134.694553]  [<c0118ed5>] bad_area_nosemaphore+0x12/0x14
[ 1134.694558]  [<c01191ec>] do_page_fault+0x213/0x2a7
[ 1134.694563]  [<c0118fd9>] ? do_page_fault+0x0/0x2a7
[ 1134.694569]  [<c03eea1a>] error_code+0x5e/0x64
[ 1134.694575]  [<c0118fd9>] ? do_page_fault+0x0/0x2a7
[ 1134.694582]  [<c01878f0>] ? page_referenced+0x17a/0x204
[ 1134.694588]  [<c017480f>] ? isolate_pages_global+0x8f/0x1d0
[ 1134.694594]  [<c0175523>] shrink_active_list+0x148/0x257
[ 1134.694599]  [<c017625f>] shrink_zone+0x2c5/0x371
[ 1134.694605]  [<c0176c27>] do_try_to_free_pages+0x120/0x23b
[ 1134.694610]  [<c0176e39>] try_to_free_pages+0x6b/0x73
[ 1134.694615]  [<c0174780>] ? isolate_pages_global+0x0/0x1d0
[ 1134.694620]  [<c0171231>] __alloc_pages_nodemask+0x2bb/0x546
[ 1134.694626]  [<c0172be8>] __do_page_cache_readahead+0xe0/0x1e6
[ 1134.694631]  [<c0172d0f>] ra_submit+0x21/0x27
[ 1134.694636]  [<c0172e76>] ondemand_readahead+0x8f/0x1d6
[ 1134.694642]  [<c016bcbd>] ? find_get_page+0x84/0xca
[ 1134.694647]  [<c017307c>] page_cache_sync_readahead+0x32/0x4a
[ 1134.694652]  [<c016d84b>] generic_file_aio_read+0x32e/0x623
[ 1134.694660]  [<c01940fa>] do_sync_read+0x98/0xc5
[ 1134.694665]  [<c0170a7d>] ? __free_pages+0x28/0x2c
[ 1134.694669]  [<c0170aa9>] ? free_pages+0x28/0x2a
[ 1134.694675]  [<c0194b20>] vfs_read+0x89/0x147
[ 1134.694680]  [<c0194062>] ? do_sync_read+0x0/0xc5
[ 1134.694685]  [<c0194c7f>] sys_read+0x3d/0x64
[ 1134.694689]  [<c0102a8c>] sysenter_do_call+0x12/0x22
[ 1134.696751] BUG: scheduling while atomic: eix-update/4126/0x10000002
[ 1134.696759] Modules linked in: vboxnetflt vboxnetadp vboxdrv ipv6 af_packet bridge stp llc snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss snd_mixer_oss tun serial_cs i8k cpufreq_userspace cpufreq_powersave cpufreq_ondemand bluetooth acpi_cpufreq freq_table p54pci p54common mac80211 cfg80211 snd_intel8x0 mousedev snd_intel8x0m usbmouse firewire_ohci snd_ac97_codec usbhid firewire_core rfkill ac97_bus prism54 snd_pcm crc_itu_t snd_timer ohci1394 3c59x psmouse snd pcmcia rtc_cmos ieee1394 intel_agp sr_mod yenta_socket rsrc_nonstatic soundcore uhci_hcd dcdbas intel_rng rng_core mii serio_raw rtc_core pcmcia_core cdrom snd_page_alloc usbcore sg evdev rtc_lib floppy [last unloaded: microcode]
[ 1134.696843] Pid: 4126, comm: eix-update Tainted: G      DA   2.6.34-rc2-marc-19754-g220bf99 #1
[ 1134.696847] Call Trace:
[ 1134.696859]  [<c03ec5b2>] ? printk+0x18/0x1e
[ 1134.696868]  [<c011f850>] __schedule_bug+0x58/0x5a
[ 1134.696873]  [<c03ec999>] schedule+0x3ad/0x4b1
[ 1134.696878]  [<c011fab9>] __cond_resched+0x16/0x26
[ 1134.696882]  [<c03ecb35>] _cond_resched+0x20/0x27
[ 1134.696888]  [<c0128cc2>] put_files_struct+0x7d/0xc5
[ 1134.696893]  [<c0128d41>] exit_files+0x37/0x48
[ 1134.696897]  [<c012a63d>] do_exit+0x65f/0x6b4
[ 1134.696903]  [<c0105562>] oops_end+0x6e/0x97
[ 1134.696911]  [<c0118ce6>] no_context+0xb0/0x17d
[ 1134.696916]  [<c0118e2e>] __bad_area_nosemaphore+0x7b/0x110
[ 1134.696921]  [<c0170af9>] ? __pagevec_free+0x1d/0x2a
[ 1134.696927]  [<c0118ed5>] bad_area_nosemaphore+0x12/0x14
[ 1134.696932]  [<c01191ec>] do_page_fault+0x213/0x2a7
[ 1134.696937]  [<c0118fd9>] ? do_page_fault+0x0/0x2a7
[ 1134.696942]  [<c03eea1a>] error_code+0x5e/0x64
[ 1134.696948]  [<c0118fd9>] ? do_page_fault+0x0/0x2a7
[ 1134.696954]  [<c01878f0>] ? page_referenced+0x17a/0x204
[ 1134.696960]  [<c017480f>] ? isolate_pages_global+0x8f/0x1d0
[ 1134.696966]  [<c0175523>] shrink_active_list+0x148/0x257
[ 1134.696971]  [<c017625f>] shrink_zone+0x2c5/0x371
[ 1134.696977]  [<c0176c27>] do_try_to_free_pages+0x120/0x23b
[ 1134.696981]  [<c0176e39>] try_to_free_pages+0x6b/0x73
[ 1134.696986]  [<c0174780>] ? isolate_pages_global+0x0/0x1d0
[ 1134.696991]  [<c0171231>] __alloc_pages_nodemask+0x2bb/0x546
[ 1134.696997]  [<c0172be8>] __do_page_cache_readahead+0xe0/0x1e6
[ 1134.697026]  [<c0172d0f>] ra_submit+0x21/0x27
[ 1134.697031]  [<c0172e76>] ondemand_readahead+0x8f/0x1d6
[ 1134.697037]  [<c016bcbd>] ? find_get_page+0x84/0xca
[ 1134.697042]  [<c017307c>] page_cache_sync_readahead+0x32/0x4a
[ 1134.697047]  [<c016d84b>] generic_file_aio_read+0x32e/0x623
[ 1134.697055]  [<c01940fa>] do_sync_read+0x98/0xc5
[ 1134.697060]  [<c0170a7d>] ? __free_pages+0x28/0x2c
[ 1134.697064]  [<c0170aa9>] ? free_pages+0x28/0x2a
[ 1134.697069]  [<c0194b20>] vfs_read+0x89/0x147
[ 1134.697073]  [<c0194062>] ? do_sync_read+0x0/0xc5
[ 1134.697079]  [<c0194c7f>] sys_read+0x3d/0x64
[ 1134.697083]  [<c0102a8c>] sysenter_do_call+0x12/0x22
-- 
Marc Koschewski
