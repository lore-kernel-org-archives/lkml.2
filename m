Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754941Ab1KGAaL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Nov 2011 19:30:11 -0500
Received: from lo.gmane.org ([80.91.229.12]:55904 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754272Ab1KGAaJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Nov 2011 19:30:09 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Michael Basse <michael@alpha-unix.de>
Subject: Re: Kernelpanic on eeePC and MSI Wind (both using rt2800pci) with
 Linux 3.x
Date: Mon, 07 Nov 2011 01:25:34 +0100
Message-ID: <j978hu$i23$1@dough.gmane.org>
References: <4EB4006F.3040602@alpha-unix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: p579173d7.dip0.t-ipconnect.de
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
In-Reply-To: <4EB4006F.3040602@alpha-unix.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everyone,

here is a complete netconsole-output from a kernel-panic (provided by
Hauke Jung) regarding to the topic
http://article.gmane.org/gmane.linux.kernel/1211290

[ 3888.374899] BUG: scheduling while atomic: kworker/u:21/5593/0x10010200
[ 3888.377441] Modules linked in: netconsole rt2800pci rt2800lib
crc_ccitt rt2x00pci rt2x00lib mac80211 cfg80211 eeprom_93cx6 r8169 bnep
rfcomm bluetooth pci_stub vboxpci vboxnetadp vboxnetflt vboxdrv deflate
zlib_deflate ctr twofish_generic parport_pc twofish_i586 twofish_common
ppdev camellia serpent blowfish cast5 des_generic xcbc rmd160
sha512_generic crypto_null af_key snd_hda_codec_realtek snd_hda_intel
snd_hda_codec snd_hwdep snd_pcm snd_seq_midi snd_rawmidi
snd_seq_midi_event snd_seq snd_timer snd_seq_device psmouse serio_raw
binfmt_misc snd i915 soundcore drm_kms_helper drm snd_page_alloc
i2c_algo_bit wmi video configfs arc4 lp parport ums_realtek usb_storage
uas [last unloaded: netconsole]
[ 3888.396165] Pid: 5593, comm: kworker/u:21 Tainted: G        W
3.0.0-13-generic #21-Ubuntu
[ 3888.399461] Call Trace:
[ 3888.402723]  [<c151902f>] ? printk+0x2d/0x2f
[ 3888.406014]  [<c15188c8>] __schedule_bug+0x5e/0x64
[ 3888.409302]  [<c152ab94>] __schedule+0x614/0x620
[ 3888.412562]  [<c12c034b>] ? fb_set_var+0x17b/0x2d0
[ 3888.415801]  [<c12846a5>] ? put_dec+0x85/0x90
[ 3888.419043]  [<c12858fa>] ? number.isra.3+0x30a/0x320
[ 3888.422289]  [<c10412c5>] schedule+0x35/0x50
[ 3888.425528]  [<c152b996>] __mutex_lock_slowpath+0xc6/0x120
[ 3888.428810]  [<c152b644>] mutex_lock+0x24/0x40
[ 3888.432088]  [<f81f1659>] drm_fb_helper_pan_display+0x29/0xb0
[drm_kms_helper]
[ 3888.435437]  [<f81f1630>] ? drm_fb_helper_fill_var+0x1a0/0x1a0
[drm_kms_helper]
[ 3888.438823]  [<c12bfa09>] fb_pan_display+0xb9/0x160
[ 3888.442203]  [<c12ced11>] bit_update_start+0x21/0x50
[ 3888.445571]  [<c12cc1a4>] fbcon_switch+0x3c4/0x570
[ 3888.448930]  [<c1324eab>] redraw_screen+0x13b/0x240
[ 3888.452370]  [<c12cb64d>] fbcon_blank+0x23d/0x300
[ 3888.455690]  [<c1284b41>] ? format_decode+0x311/0x380
[ 3888.459024]  [<c1286a38>] ? vsnprintf+0x2c8/0x390
[ 3888.462332]  [<c1026038>] ? default_spin_lock_flags+0x8/0x10
[ 3888.465653]  [<c152ca3d>] ? _raw_spin_lock_irqsave+0x2d/0x40
[ 3888.468976]  [<c106b6ec>] ? down_trylock+0x2c/0x40
[ 3888.472289]  [<c1026038>] ? default_spin_lock_flags+0x8/0x10
[ 3888.475611]  [<c152ca3d>] ? _raw_spin_lock_irqsave+0x2d/0x40
[ 3888.478965]  [<c105578b>] ? lock_timer_base.isra.30+0x2b/0x50
[ 3888.482334]  [<c1056838>] ? mod_timer+0x118/0x280
[ 3888.485718]  [<c108c62d>] ? crash_kexec+0x7d/0xe0
[ 3888.489100]  [<c1325a1f>] do_unblank_screen.part.20+0x7f/0x130
[ 3888.492508]  [<c1325b10>] do_unblank_screen+0x40/0x70
[ 3888.495835]  [<c1325b4f>] unblank_screen+0xf/0x20
[ 3888.499051]  [<c12894e5>] bust_spinlocks+0x15/0x40
[ 3888.502127]  [<c152de04>] oops_end+0x34/0xd0
[ 3888.505060]  [<c1518142>] no_context+0x13c/0x144
[ 3888.507844]  [<c151826a>] __bad_area_nosemaphore+0x120/0x128
[ 3888.510541]  [<c106a11a>] ? __run_hrtimer+0x9a/0x1b0
[ 3888.513102]  [<c152fd40>] ? vmalloc_fault+0xee/0xee
[ 3888.515566]  [<c12cf557>] ? bit_putcs+0x237/0x410
[ 3888.517979]  [<c12d0999>] ? bitfill_aligned+0x29/0x30
[ 3888.520379]  [<c12d06dc>] ? cfb_fillrect+0x14c/0x2c0
[ 3888.522768]  [<c12cf557>] ? bit_putcs+0x237/0x410
[ 3888.525181]  [<c12d0999>] ? bitfill_aligned+0x29/0x30
[ 3888.527571]  [<c12d06dc>] ? cfb_fillrect+0x14c/0x2c0
[ 3888.529978]  [<c12ca8ee>] ? get_color.isra.17+0x2e/0x140
[ 3888.532394]  [<c12d0970>] ? bitfill_aligned.part.1+0x120/0x120
[ 3888.534811]  [<c12ceb28>] ? bit_clear+0xb8/0xe0
[ 3888.537223]  [<f81e2565>] ? rtl8169_start_xmit+0x175/0x3d0 [r8169]
[ 3888.539659]  [<c142e828>] ? __alloc_skb+0x58/0x1f0
[ 3888.542065]  [<c144d8c3>] ? netpoll_send_udp+0x1c3/0x1e0
[ 3888.544442]  [<f8075311>] ? write_msg+0xc1/0xd0 [netconsole]
[ 3888.546781]  [<f8075250>] ? netconsole_netdev_event+0x1c0/0x1c0
[netconsole]
[ 3888.549193]  [<c1047b0d>] ? __call_console_drivers+0x7d/0x90
[ 3888.551599]  [<c1026038>] ? default_spin_lock_flags+0x8/0x10
[ 3888.554027]  [<c152ca3d>] ? _raw_spin_lock_irqsave+0x2d/0x40
[ 3888.556459]  [<c1047fe2>] ? console_unlock+0xa2/0xf0
[ 3888.558871]  [<c10f6889>] ? __mod_zone_page_state+0x59/0x60
[ 3888.561321]  [<c10e4e11>] ? free_pcppages_bulk+0x2b1/0x340
[ 3888.563752]  [<c10e4ec7>] ? drain_pages+0x27/0x90
[ 3888.566181]  [<c101c2fc>] ? clear_local_APIC+0x13c/0x2c0
[ 3888.568609]  [<c101c4d2>] ? disable_local_APIC+0x52/0x90
[ 3888.571012]  [<c104e4d0>] ? local_bh_enable_ip+0x90/0x90
[ 3888.573418]  [<c100a121>] ? stop_this_cpu+0x41/0x50
[ 3888.575790]  [<c101b3e7>] ? smp_reboot_interrupt+0x27/0x30
[ 3888.578277]  [<c152ce79>] ? reboot_interrupt+0x31/0x38
[ 3888.580679]  [<c104e4d0>] ? local_bh_enable_ip+0x90/0x90
[ 3888.583060]  [<c104007b>] ? proc_sched_show_task+0x1a1b/0x1a70
[ 3888.585488]  [<c104e515>] ? __do_softirq+0x45/0x1a0
[ 3888.587895]  [<c104e4d0>] ? local_bh_enable_ip+0x90/0x90
[ 3888.590327]  <IRQ>  [<c104e896>] ? irq_exit+0x76/0xa0
[ 3888.592785]  [<c1041832>] ? scheduler_ipi+0x32/0x40
[ 3888.595230]  [<c101b417>] ? smp_reschedule_interrupt+0x27/0x30
[ 3888.597712]  [<c152cd9d>] ? reschedule_interrupt+0x31/0x38
[ 3888.600184]  [<c10300d8>] ? tg_schedulable+0x198/0x270
[ 3888.602653]  [<c1037d43>] ? finish_task_switch+0x43/0xc0
[ 3888.605144]  [<c152a871>] ? __schedule+0x2f1/0x620
[ 3888.607623]  [<c10af55d>] ? rcu_irq_exit+0xd/0x10
[ 3888.610115]  [<c104e85c>] ? irq_exit+0x3c/0xa0
[ 3888.612594]  [<c10412c5>] ? schedule+0x35/0x50
[ 3888.615044]  [<c152ccc2>] ? work_resched+0x5/0x20
[ 3888.617516]  [<c1520000>] ? ext4_check_descriptors+0x224/0x34e
[ 3888.622833] ------------[ cut here ]------------
[ 3888.624011] WARNING: at
/build/buildd/linux-3.0.0/arch/x86/kernel/apic/ipi.c:113
default_send_IPI_mask_logical+0xdc/0xf0()
[ 3888.624011] Hardware name: U-100
[ 3888.624011] Modules linked in: netconsole rt2800pci rt2800lib
crc_ccitt rt2x00pci rt2x00lib mac80211 cfg80211 eeprom_93cx6 r8169 bnep
rfcomm bluetooth pci_stub vboxpci vboxnetadp vboxnetflt vboxdrv deflate
zlib_deflate ctr twofish_generic parport_pc twofish_i586 twofish_common
ppdev camellia serpent blowfish cast5 des_generic xcbc rmd160
sha512_generic crypto_null af_key snd_hda_codec_realtek snd_hda_intel
snd_hda_codec snd_hwdep snd_pcm snd_seq_midi snd_rawmidi
snd_seq_midi_event snd_seq snd_timer snd_seq_device psmouse serio_raw
binfmt_misc snd i915 soundcore drm_kms_helper drm snd_page_alloc
i2c_algo_bit wmi video configfs arc4 lp parport ums_realtek usb_storage
uas [last unloaded: netconsole]
[ 3888.624011] Pid: 559, comm: rsyslogd Tainted: G        W
3.0.0-13-generic #21-Ubuntu
[ 3888.624011] Call Trace:
[ 3888.624011]  [<c151902f>] ? printk+0x2d/0x2f
[ 3888.624011]  [<c1047982>] warn_slowpath_common+0x72/0xa0
[ 3888.624011]  [<c101d1dc>] ? default_send_IPI_mask_logical+0xdc/0xf0
[ 3888.624011]  [<c101d1dc>] ? default_send_IPI_mask_logical+0xdc/0xf0
[ 3888.624011]  [<c10479d2>] warn_slowpath_null+0x22/0x30
[ 3888.624011]  [<c101d1dc>] default_send_IPI_mask_logical+0xdc/0xf0
[ 3888.624011]  [<c10af55d>] ? rcu_irq_exit+0xd/0x10
[ 3888.624011]  [<c104e85c>] ? irq_exit+0x3c/0xa0
[ 3888.624011]  [<c102a97a>] flush_tlb_others_ipi+0xba/0xd0
[ 3888.624011]  [<c102aafd>] native_flush_tlb_others+0xd/0x10
[ 3888.624011]  [<c102ac3d>] flush_tlb_page+0x4d/0x90
[ 3888.624011]  [<c1029e3c>] ptep_clear_flush_young+0x2c/0x40
[ 3888.624011]  [<c1105aa0>] page_referenced_one+0x60/0x1e0
[ 3888.624011]  [<c1105cdf>] page_referenced_file+0xbf/0x110
[ 3888.624011]  [<c11072c5>] page_referenced+0x65/0xf0
[ 3888.624011]  [<c10ebee7>] page_check_references.isra.43+0x27/0x80
[ 3888.624011]  [<c10edff0>] shrink_page_list+0x1c0/0x4c0
[ 3888.624011]  [<c10ee631>] shrink_inactive_list+0x101/0x3e0
[ 3888.624011]  [<c10ecd61>] ? get_scan_count+0x271/0x380
[ 3888.624011]  [<c10ee9db>] shrink_list+0xcb/0x150
[ 3888.624011]  [<c10eeaed>] shrink_zone+0x8d/0x1a0
[ 3888.624011]  [<c10710bb>] ? ktime_get_ts+0xeb/0x120
[ 3888.624011]  [<c10ef375>] shrink_zones+0x55/0xe0
[ 3888.624011]  [<c10ef474>] do_try_to_free_pages+0x74/0x270
[ 3888.624011]  [<c10ef8cb>] try_to_free_pages+0x8b/0x120
[ 3888.624011]  [<c10e595f>] ? get_page_from_freelist+0x1df/0x2a0
[ 3888.624011]  [<c10e5f84>] __alloc_pages_nodemask+0x424/0x6e0
[ 3888.624011]  [<c10fb530>] do_anonymous_page+0x70/0x280
[ 3888.624011]  [<c10feec8>] handle_pte_fault+0x1f8/0x220
[ 3888.624011]  [<c10feff8>] handle_mm_fault+0x108/0x210
[ 3888.624011]  [<c152fd40>] ? vmalloc_fault+0xee/0xee
[ 3888.624011]  [<c152fe9b>] do_page_fault+0x15b/0x4a0
[ 3888.624011]  [<c1070bf4>] ? getnstimeofday+0x54/0x120
[ 3888.624011]  [<c12886c0>] ? copy_to_user+0x40/0x60
[ 3888.624011]  [<c104cfc2>] ? sys_gettimeofday+0x32/0x70
[ 3888.624011]  [<c152fd40>] ? vmalloc_fault+0xee/0xee
[ 3888.624011]  [<c152d30f>] error_code+0x67/0x6c
[ 3888.624011]  [<c1520000>] ? ext4_check_descriptors+0x224/0x34e
[ 3888.624011] ---[ end trace 4d06842269ea82cb ]---


Greetings

Michael Basse


