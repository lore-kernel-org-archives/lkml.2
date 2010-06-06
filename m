Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754587Ab0FFJHI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jun 2010 05:07:08 -0400
Received: from webbox4.loswebos.de ([213.187.93.205]:46705 "EHLO
	webbox4.loswebos.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754164Ab0FFJHG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jun 2010 05:07:06 -0400
X-Greylist: delayed 433 seconds by postgrey-1.27 at vger.kernel.org; Sun, 06 Jun 2010 05:07:06 EDT
Date: Sun, 6 Jun 2010 10:59:30 +0200
From: Marc Koschewski <marc@osknowledge.org>
To: Linux-LKLM <linux-kernel@vger.kernel.org>
Subject: [2.6.35-rc1-marc-00691-g7f0d384] Oops in dup_mm
Message-ID: <20100606085930.GA10311@shmoo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-PGP-Fingerprint: D514 7DC1 B5F5 8989 083E  38C9 5ECF E5BD 3430 ABF5
X-PGP-Key: http://www.osknowledge.org/~marc/pubkey.asc
X-Operating-System: Linux shmoo 2.6.35-rc1-marc-00261-g03cd373
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi folks,

this morning I got a new Oops introduced. The system is overall 'slower', the
framebuffer is not re-drawn (nouveau, which works perfectly until 2.6.35-rc1-marc-00261-g03cd373)
and init is unable to send KILL and TERM when shuting down the machine. Shutdown
was further processes after hitting PWRBTN but still the box wasn't shutdown
completely.


Jun  6 10:38:33 shmoo kernel: [  309.342010] Oops: 0002 [#1] 
Jun  6 10:38:33 shmoo kernel: [  309.342010] last sysfs file: /sys/devices/pci0000:00/0000:00:1d.2/usb2/2-1/2-1:1.0/bInterfaceClass
Jun  6 10:38:33 shmoo kernel: [  309.342010] Modules linked in: vboxnetflt vboxnetadp vboxdrv ipv6 af_packet snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss snd_mixer_oss tun serial_cs i8k cpufreq_userspace cpufreq_powersave cpufreq_ondemand bluetooth acpi_cpufreq freq_table mperf p54pci p54common mac80211 mousedev cfg80211 usbmouse firewire_ohci ch7006 snd_intel8x0 rfkill usbhid firewire_core prism54 snd_intel8x0m nouveau snd_ac97_codec crc_itu_t ttm rtc_cmos ohci1394 pcmcia video rtc_core drm_kms_helper ieee1394 ac97_bus intel_rng dcdbas uhci_hcd psmouse evdev serio_raw rtc_lib yenta_socket pcmcia_rsrc pcmcia_core snd_pcm snd_timer sg rng_core usbcore output snd intel_agp 3c59x mii soundcore snd_page_alloc
Jun  6 10:38:33 shmoo kernel: [  309.342010] 
Jun  6 10:38:33 shmoo kernel: [  309.342010] Pid: 2400, comm: preload Tainted: G       A    2.6.35-rc1-marc-00691-g7f0d384 #1 Inspiron 8200            /Inspiron 8200                   
Jun  6 10:38:33 shmoo kernel: [  309.342010] EIP: 0060:[<b0170431>] EFLAGS: 00010282 CPU: 0
Jun  6 10:38:33 shmoo kernel: [  309.342010] EIP is at anon_vma_fork+0x79/0x9a
Jun  6 10:38:33 shmoo kernel: [  309.342010] EAX: f61b7d40 EBX: f68963c8 ECX: f61b7d50 EDX: 0e200e20
Jun  6 10:38:33 shmoo kernel: [  309.342010] ESI: f61b0738 EDI: f61b073c EBP: f6043eb4 ESP: f6043ea8
Jun  6 10:38:33 shmoo kernel: [  309.342010]  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
Jun  6 10:38:33 shmoo kernel: [  309.342010] Process preload (pid: 2400, ti=f6043000 task=f7092f40 task.ti=f6043000)
Jun  6 10:38:33 shmoo kernel: [  309.342010] Stack:
Jun  6 10:38:33 shmoo kernel: [  309.342010]  f68963c8 f6073f98 f689641c f6043ef8 b011fcd3 f6896338 f69ca938 f69ca338
Jun  6 10:38:33 shmoo kernel: [  309.342010] <0> f7092f40 f7092f40 f689638c f6896390 f6896380 00000001 f6073f44 f69ca300
Jun  6 10:38:33 shmoo kernel: [  309.342010] <0> f69ca900 f7096740 f69dde40 f70658c0 f6043f34 b01206b9 b043e0a0 f6043f20
Jun  6 10:38:33 shmoo kernel: [  309.342010] Call Trace:
Jun  6 10:38:33 shmoo kernel: [  309.342010]  [<b011fcd3>] ? dup_mm+0x1bd/0x3c0
Jun  6 10:38:33 shmoo kernel: [  309.342010]  [<b01206b9>] ? copy_process+0x789/0xbc5
Jun  6 10:38:33 shmoo kernel: [  309.342010]  [<b011f0d0>] ? check_preempt_wakeup+0x66/0xab
Jun  6 10:38:33 shmoo kernel: [  309.342010]  [<b0120b60>] ? do_fork+0x6b/0x2f9
Jun  6 10:38:33 shmoo kernel: [  309.342010]  [<b011d67f>] ? __dequeue_entity+0x31/0x35
Jun  6 10:38:33 shmoo kernel: [  309.342010]  [<b0108376>] ? sys_clone+0x2b/0x32
Jun  6 10:38:33 shmoo kernel: [  309.342010]  [<b01029dd>] ? ptregs_clone+0x15/0x38
Jun  6 10:38:33 shmoo kernel: [  309.342010]  [<b0102910>] ? sysenter_do_call+0x12/0x26
Jun  6 10:38:33 shmoo kernel: [  309.342010] Code: 18 89 70 04 8d 50 08 8b 4b 34 89 51 04 89 48 08 8d 4b 34 89 48 0c 89 53 34 8d 48 10 8b 56 08 89 4e 08 8d 7e 04 89 78 10 89 50 14 <89> 0a 89 73 3c 31 c0 eb 8f 89 f0 e8 44 fe ff ff 89 d8 e8 4e fe 
Jun  6 10:38:33 shmoo kernel: [  309.342010] EIP: [<b0170431>] anon_vma_fork+0x79/0x9a SS:ESP 0068:f6043ea8
Jun  6 10:38:33 shmoo kernel: [  309.342010] CR2: 000000000e200e20
Jun  6 10:38:33 shmoo kernel: [  309.344889] ---[ end trace a44762bd457c0179 ]---

Jun  6 10:38:40 shmoo kernel: [  315.772559] BUG: unable to handle kernel paging request at 0e200e20
Jun  6 10:38:40 shmoo kernel: [  315.772637] IP: [<b0170373>] anon_vma_clone+0x59/0x9e
Jun  6 10:38:40 shmoo kernel: [  315.772692] *pde = 00000000 
Jun  6 10:38:40 shmoo kernel: [  315.772724] Oops: 0002 [#2] 
Jun  6 10:38:40 shmoo kernel: [  315.772755] last sysfs file: /sys/devices/pci0000:00/0000:00:1d.2/usb2/2-1/2-1:1.0/bInterfaceClass
Jun  6 10:38:40 shmoo kernel: [  315.772814] Modules linked in: vboxnetflt vboxnetadp vboxdrv ipv6 af_packet snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss snd_mixer_oss tun serial_cs i8k cpufreq_userspace cpufreq_powersave cpufreq_ondemand bluetooth acpi_cpufreq freq_table mperf p54pci p54common mac80211 mousedev cfg80211 usbmouse firewire_ohci ch7006 snd_intel8x0 rfkill usbhid firewire_core prism54 snd_intel8x0m nouveau snd_ac97_codec crc_itu_t ttm rtc_cmos ohci1394 pcmcia video rtc_core drm_kms_helper ieee1394 ac97_bus intel_rng dcdbas uhci_hcd psmouse evdev serio_raw rtc_lib yenta_socket pcmcia_rsrc pcmcia_core snd_pcm snd_timer sg rng_core usbcore output snd intel_agp 3c59x mii soundcore snd_page_alloc
Jun  6 10:38:40 shmoo kernel: [  315.773009] 
Jun  6 10:38:40 shmoo kernel: [  315.773009] Pid: 2770, comm: login Tainted: G      DA    2.6.35-rc1-marc-00691-g7f0d384 #1 Inspiron 8200            /Inspiron 8200                   
Jun  6 10:38:40 shmoo kernel: [  315.773009] EIP: 0060:[<b0170373>] EFLAGS: 00210296 CPU: 0
Jun  6 10:38:40 shmoo kernel: [  315.773009] EIP is at anon_vma_clone+0x59/0x9e
Jun  6 10:38:40 shmoo kernel: [  315.773009] EAX: f60be8d8 EBX: f61cbb18 ECX: 0e200e20 EDX: f61b06a0
Jun  6 10:38:40 shmoo kernel: [  315.773009] ESI: f69ab860 EDI: f60be8e8 EBP: f69cfea0 ESP: f69cfe8c
Jun  6 10:38:40 shmoo kernel: [  315.773009]  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
Jun  6 10:38:40 shmoo kernel: [  315.773009] Process login (pid: 2770, ti=f69cf000 task=f60cb780 task.ti=f69cf000)
Jun  6 10:38:40 shmoo kernel: [  315.773009] Stack:
Jun  6 10:38:40 shmoo kernel: [  315.773009]  f69ab894 f61c5840 f69ab860 f61c5860 f69ab8b4 f69cfeb4 b01703d5 f69ab860
Jun  6 10:38:40 shmoo kernel: [  315.773009] <0> f61c5860 f69ab8b4 f69cfef8 b011fcd3 f60d2c14 f6893738 f6893938 f60cb780
Jun  6 10:38:40 shmoo kernel: [  315.773009] <0> f60cb780 f69ab824 f69ab828 f69ab818 00000001 f61c580c f6893900 f6893700
Jun  6 10:38:40 shmoo kernel: [  315.773009] Call Trace:
Jun  6 10:38:40 shmoo kernel: [  315.773009]  [<b01703d5>] ? anon_vma_fork+0x1d/0x9a
Jun  6 10:38:40 shmoo kernel: [  315.773009]  [<b011fcd3>] ? dup_mm+0x1bd/0x3c0
Jun  6 10:38:40 shmoo kernel: [  315.773009]  [<b01206b9>] ? copy_process+0x789/0xbc5
Jun  6 10:38:40 shmoo kernel: [  315.773009]  [<b0163d73>] ? shmem_notify_change+0xee/0x13e
Jun  6 10:38:40 shmoo kernel: [  315.773009]  [<b0120b60>] ? do_fork+0x6b/0x2f9
Jun  6 10:38:40 shmoo kernel: [  315.773009]  [<b021b034>] ? copy_to_user+0x2e/0x11a
Jun  6 10:38:40 shmoo kernel: [  315.773009]  [<b012abae>] ? sys_rt_sigaction+0x5f/0x80
Jun  6 10:38:40 shmoo kernel: [  315.773009]  [<b0108376>] ? sys_clone+0x2b/0x32
Jun  6 10:38:40 shmoo kernel: [  315.773009]  [<b01029dd>] ? ptregs_clone+0x15/0x38
Jun  6 10:38:40 shmoo kernel: [  315.773009]  [<b0102910>] ? sysenter_do_call+0x12/0x26
Jun  6 10:38:40 shmoo kernel: [  315.773009] Code: 30 89 50 04 8d 48 08 8b 7e 34 89 4f 04 89 78 08 8b 7d ec 89 78 0c 89 4e 34 8d 78 10 8b 4a 08 89 7a 08 83 c2 04 89 50 10 89 48 14 <89> 39 8b 43 0c 8d 58 f8 8b 53 0c 0f 18 02 90 39 45 f0 74 27 ba 
Jun  6 10:38:40 shmoo kernel: [  315.773009] EIP: [<b0170373>] anon_vma_clone+0x59/0x9e SS:ESP 0068:f69cfe8c
Jun  6 10:38:40 shmoo kernel: [  315.773009] CR2: 000000000e200e20
Jun  6 10:38:40 shmoo kernel: [  315.779177] ---[ end trace a44762bd457c017a ]---

HTH,
	Marc

-- 
Marc Koschewski
