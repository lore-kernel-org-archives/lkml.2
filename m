Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755865Ab2KIU2m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 15:28:42 -0500
Received: from mailout-de.gmx.net ([213.165.64.23]:51613 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753511Ab2KIU2l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 15:28:41 -0500
X-Authenticated: #5108953
X-Provags-ID: V01U2FsdGVkX19k319ZArNkQ/JtAer7YUsc2dXAD7dGkA8rXuuy0K
	468zGFLCo7L3cB
Message-ID: <509D6775.5080506@gmx.de>
Date: Fri, 09 Nov 2012 21:28:37 +0100
From: =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121028 Thunderbird/16.0.1
MIME-Version: 1.0
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: ipi.c:109 default_send_IPI_mask_logical+0xa3/0xe0()
X-Enigmail-Version: 1.5a1pre
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With recent stable kernels (3.6.x) at my stable Gentoo Linux
I observed few times within the last month this warning in my syslog :

2012-11-08T19:12:35.334+01:00 n22 kernel: ------------[ cut here ]------------
2012-11-08T19:12:35.334+01:00 n22 kernel: WARNING: at arch/x86/kernel/apic/ipi.c:109 default_send_IPI_mask_logical+0xa3/0xe0()
2012-11-08T19:12:35.334+01:00 n22 kernel: Hardware name: 4180F65
2012-11-08T19:12:35.334+01:00 n22 kernel: empty IPI mask
2012-11-08T19:12:35.334+01:00 n22 kernel: Modules linked in: ipt_MASQUERADE xt_owner xt_multiport ipt_REJECT xt_recent xt_tcpudp xt_mac nf_conntrack_ftp xt_state xt_limit xt_LOG iptable_nat nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_conntrack iptable_filter ip_tables x_tables af_packet pppoe pppox ppp_generic slhc bridge stp llc tun msr i915 cfbfillrect cfbimgblt i2c_algo_bit cfbcopyarea intel_agp intel_gtt fbcon bitblit softcursor font drm_kms_helper drm snd_hda_codec_conexant arc4 snd_hda_intel iwldvm mac80211 snd_hda_codec snd_pcm agpgart coretemp uvcvideo usblp e1000e kvm_intel iwlwifi fb sdhci_pci 8250_pci videobuf2_vmalloc videobuf2_memops sdhci 8250 videobuf2_core thinkpad_acpi snd_page_alloc nvram kvm snd_timer cfg80211 videodev thermal button snd fbdev acpi_cpufreq mperf tpm_tis processor i2c_i801 hwmon evdev psmouse i2c_core serial_core wmi rfkill soundcore mmc_core ac tpm battery video tpm_bios xts gf128mul aesni_intel ablk_helper cryptd aes_i586 aes_generic cbc fuse nfs lo
ckd sunrpc dm_crypt dm_mod hid_monterey hid_microsoft hid_logitech hid_ezkey hid_cypress hid_chicony hid_cherry hid_belkin hid_apple hid_a4tech hid_generic usbhid hid sr_mod cdrom sg [last unloaded: microcode]
2012-11-08T19:12:35.334+01:00 n22 kernel: Pid: 6384, comm: thunderbird Not tainted 3.6.6 #16
2012-11-08T19:12:35.334+01:00 n22 kernel: Call Trace:
2012-11-08T19:12:35.334+01:00 n22 kernel: [<c10323e2>] warn_slowpath_common+0x72/0xa0
2012-11-08T19:12:35.334+01:00 n22 kernel: [<c1022e93>] ? default_send_IPI_mask_logical+0xa3/0xe0
2012-11-08T19:12:35.334+01:00 n22 kernel: [<c1022e93>] ? default_send_IPI_mask_logical+0xa3/0xe0
2012-11-08T19:12:35.335+01:00 n22 kernel: [<c10324b3>] warn_slowpath_fmt+0x33/0x40
2012-11-08T19:12:35.335+01:00 n22 kernel: [<c1022e93>] default_send_IPI_mask_logical+0xa3/0xe0
2012-11-08T19:12:35.335+01:00 n22 kernel: [<c1020fc5>] native_send_call_func_ipi+0x45/0x60
2012-11-08T19:12:35.335+01:00 n22 kernel: [<c1081ffe>] smp_call_function_many+0x16e/0x210
2012-11-08T19:12:35.335+01:00 n22 kernel: [<c102e300>] ? do_flush_tlb_all+0x60/0x60
2012-11-08T19:12:35.335+01:00 n22 kernel: [<c102e3bb>] native_flush_tlb_others+0x2b/0x30
2012-11-08T19:12:35.335+01:00 n22 kernel: [<c102e644>] flush_tlb_page+0x54/0xa0
2012-11-08T19:12:35.335+01:00 n22 kernel: [<c102d523>] ptep_set_access_flags+0x63/0x80
2012-11-08T19:12:35.335+01:00 n22 kernel: [<c10eabc3>] do_wp_page+0x343/0x740
2012-11-08T19:12:35.335+01:00 n22 kernel: [<c10eab3e>] ? do_wp_page+0x2be/0x740
2012-11-08T19:12:35.336+01:00 n22 kernel: [<c10ec347>] handle_pte_fault+0x297/0x920
2012-11-08T19:12:35.336+01:00 n22 kernel: [<c10822e7>] ? generic_smp_call_function_interrupt+0xd7/0x180
2012-11-08T19:12:35.336+01:00 n22 kernel: [<c10822e7>] ? generic_smp_call_function_interrupt+0xd7/0x180
2012-11-08T19:12:35.336+01:00 n22 kernel: [<c13b12f9>] ? call_function_interrupt+0x31/0x38
2012-11-08T19:12:35.336+01:00 n22 kernel: [<c10ed7df>] handle_mm_fault+0x1bf/0x240
2012-11-08T19:12:35.336+01:00 n22 kernel: [<c10297d0>] ? vmalloc_sync_all+0x10/0x10
2012-11-08T19:12:35.336+01:00 n22 kernel: [<c10298d5>] do_page_fault+0x105/0x3b0
2012-11-08T19:12:35.336+01:00 n22 kernel: [<c1031857>] ? do_fork+0x107/0x310
2012-11-08T19:12:35.336+01:00 n22 kernel: [<c1075241>] ? getnstimeofday+0x41/0xf0
2012-11-08T19:12:35.336+01:00 n22 kernel: [<c10822e7>] ? generic_smp_call_function_interrupt+0xd7/0x180
2012-11-08T19:12:35.337+01:00 n22 kernel: [<c10297d0>] ? vmalloc_sync_all+0x10/0x10
2012-11-08T19:12:35.337+01:00 n22 kernel: [<c13b1633>] error_code+0x67/0x6c
2012-11-08T19:12:35.337+01:00 n22 kernel: [<c13b0000>] ? __schedule+0x4b0/0x680
2012-11-08T19:12:35.337+01:00 n22 kernel: ---[ end trace 7fd0c025124fd7ac ]---


Is there anything I should take care for ?

-- 
MfG/Sincerely
Toralf Förster
pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3
