Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755460Ab2JTMQU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Oct 2012 08:16:20 -0400
Received: from smtprelay0177.b.hostedemail.com ([64.98.42.177]:40900 "EHLO
	smtprelay.b.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755334Ab2JTMQR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Oct 2012 08:16:17 -0400
X-Greylist: delayed 561 seconds by postgrey-1.27 at vger.kernel.org; Sat, 20 Oct 2012 08:16:17 EDT
X-Panda: scanned!
X-Session-Marker: 742E617274656D406C79636F732E636F6D
X-Filterd-Recvd-Size: 10120
Date: Sat, 20 Oct 2012 12:06:55 +0000 (GMT)
From: "Artem S. Tashkinov" <t.artem@lycos.com>
To: linux-kernel@vger.kernel.org
Message-ID: <2104474742.26357.1350734815286.JavaMail.mail@webmail05>
Subject: A reliable kernel panic (3.6.2) and system crash when visiting a
 particular website
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Mailer: Webmail
X-Originating-IP: [46.146.72.189]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I'm running vanilla Linux 3.6.2 x86 on top of CentOS 6.3 userspace.

Every time when I enter the chat roulette website, right click anywhere and choose "Settings",
 my PC crashes (with or without NVIDIA drivers running, it happens even when I'm running Vesa).

Web browser: google-chrome-stable-22.0.1229.94-161065.i386.rpm
OS: Linux 3.6.2 vanilla x86
CPU: Intel Core i5 2500 (non-overclocked)
GCC: 4.7.2 vanilla

The latest crash:

Oct 20 07:15:22 localhost kernel: [  224.293756] Modules linked in: pppoe pppox ppp_synctty ppp_async crc_ccitt ppp_generic slhc ipv6 nf_conntrack_ftp nf_conntrack_netbios_ns nf_conntrack_broadcast xt_LOG xt_limit nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack xt_tcpudp xt_pkttype ipt_ULOG xt_owner xt_multiport iptable_filter ip_tables x_tables w83627ehf adt7475 hwmon_vid vboxpci(O) 
vboxnetadp(O) vboxnetflt(O) vboxdrv(O) binfmt_misc fuse hid_generic snd_usb_audio snd_hwdep snd_usbmidi_lib snd_rawmidi uvcvideo videobuf2_core videodev 
videobuf2_vmalloc videobuf2_memops usbhid hid sr_mod cdrom coretemp aesni_intel ablk_helper cryptd aes_i586 aes_generic microcode agpgart pcspkr snd_hda_codec_realtek 
snd_hda_intel snd_hda_codec snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss snd_mixer_oss snd_pcm snd_timer snd snd_page_alloc i2c_i801 sg xhci_hcd fan ehci_hcd e1000e evdev [last unloaded: nvidia]

Oct 20 07:15:22 localhost kernel: [  224.293811] Pid: 2569, comm: console-kit-dae Tainted: P           O 3.6.2-ic #2
Oct 20 07:15:22 localhost kernel: [  224.293811] Call Trace:
Oct 20 07:15:22 localhost kernel: [  224.293813]  [<c102e6bd>] warn_slowpath_common+0x6d/0xa0
Oct 20 07:15:22 localhost kernel: [  224.293817]  [<c10209eb>] ? default_send_IPI_mask_logical+0x9b/0xd0
Oct 20 07:15:22 localhost kernel: [  224.293819]  [<c10209eb>] ? default_send_IPI_mask_logical+0x9b/0xd0
Oct 20 07:15:22 localhost kernel: [  224.293822]  [<c102e76e>] warn_slowpath_fmt+0x2e/0x30
Oct 20 07:15:22 localhost kernel: [  224.293824]  [<c10209eb>] default_send_IPI_mask_logical+0x9b/0xd0
Oct 20 07:15:22 localhost kernel: [  224.293827]  [<c101eb90>] native_send_call_func_ipi+0x40/0x60
Oct 20 07:15:22 localhost kernel: [  224.293830]  [<c106aa6a>] smp_call_function_many+0x16a/0x200
Oct 20 07:15:22 localhost kernel: [  224.293834]  [<c102b116>] native_flush_tlb_others+0x26/0x30
Oct 20 07:15:22 localhost kernel: [  224.293836]  [<c102b422>] flush_tlb_page+0x82/0xd0
Oct 20 07:15:22 localhost kernel: [  224.293839]  [<c102a3a1>] ptep_set_access_flags+0x51/0x60
Oct 20 07:15:22 localhost kernel: [  224.293841]  [<c109e030>] handle_pte_fault+0x380/0xc40
Oct 20 07:15:22 localhost kernel: [  224.293846]  [<c109f6d4>] handle_mm_fault+0x1c4/0x240
Oct 20 07:15:22 localhost kernel: [  224.293848]  [<c1026870>] ? vmalloc_sync_all+0x10/0x10
Oct 20 07:15:22 localhost kernel: [  224.293852]  [<c1026967>] do_page_fault+0xf7/0x3e0
Oct 20 07:15:22 localhost kernel: [  224.293855]  [<c1051782>] ? finish_task_switch+0x42/0xa0
Oct 20 07:15:22 localhost kernel: [  224.293858]  [<c1052c1b>] ? schedule_tail+0x1b/0x90
Oct 20 07:15:22 localhost kernel: [  224.293861]  [<c1026870>] ? vmalloc_sync_all+0x10/0x10
Oct 20 07:15:22 localhost kernel: [  224.293863]  [<c12f950a>] error_code+0x5a/0x60
Oct 20 07:15:22 localhost kernel: [  224.293867]  [<c1026870>] ? vmalloc_sync_all+0x10/0x10
Oct 20 07:15:22 localhost kernel: [  224.293871] ---[ end trace c30478a5e27a7255 ]---

Another crash:

Oct 20 07:08:21 localhost kernel: [  146.992435] ------------[ cut here ]------------
Oct 20 07:08:21 localhost kernel: [  146.992444] WARNING: at arch/x86/kernel/apic/ipi.c:109 default_send_IPI_mask_logical+0x9b/0xd0()
Oct 20 07:08:21 localhost kernel: [  146.992447] Hardware name: System Product Name
Oct 20 07:08:21 localhost kernel: [  146.992448] empty IPI mask
Oct 20 07:08:21 localhost kernel: [  146.992450] Modules linked in: pppoe pppox ppp_synctty ppp_async crc_ccitt ppp_generic slhc ipv6 nf_conntrack_ftp nf_con
ntrack_netbios_ns nf_conntrack_broadcast xt_LOG xt_limit nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack xt_tcpudp xt_pkttype ipt_ULOG xt_owner xt_mul
tiport iptable_filter ip_tables x_tables w83627ehf adt7475 hwmon_vid vboxpci(O) vboxnetadp(O) vboxnetflt(O) vboxdrv(O) binfmt_misc fuse hid_generic uvcvideo
videobuf2_core videodev videobuf2_vmalloc videobuf2_memops snd_usb_audio snd_hwdep snd_usbmidi_lib snd_rawmidi usbhid hid sg coretemp aesni_intel ablk_helper
 cryptd aes_i586 aes_generic microcode sr_mod cdrom pcspkr i2c_i801 xhci_hcd snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_seq_oss snd_seq_midi_event
 snd_seq snd_seq_device snd_pcm_oss snd_mixer_oss snd_pcm snd_timer snd snd_page_alloc ehci_hcd nvidia(PO) agpgart e1000e fan evdev
Oct 20 07:08:21 localhost kernel: [  146.992503] Pid: 2451, comm: Chrome_ProcessL Tainted: P           O 3.6.2-ic #2
Oct 20 07:08:21 localhost kernel: [  146.992504] Call Trace:
Oct 20 07:08:21 localhost kernel: [  146.992509]  [<c102e6bd>] warn_slowpath_common+0x6d/0xa0
Oct 20 07:08:21 localhost kernel: [  146.992512]  [<c10209eb>] ? default_send_IPI_mask_logical+0x9b/0xd0
Oct 20 07:08:21 localhost kernel: [  146.992514]  [<c10209eb>] ? default_send_IPI_mask_logical+0x9b/0xd0
Oct 20 07:08:21 localhost kernel: [  146.992517]  [<c102e76e>] warn_slowpath_fmt+0x2e/0x30
Oct 20 07:08:21 localhost kernel: [  146.992519]  [<c10209eb>] default_send_IPI_mask_logical+0x9b/0xd0
Oct 20 07:08:21 localhost kernel: [  146.992523]  [<c101eb90>] native_send_call_func_ipi+0x40/0x60
Oct 20 07:08:21 localhost kernel: [  146.992527]  [<c106aa6a>] smp_call_function_many+0x16a/0x200
Oct 20 07:08:21 localhost kernel: [  146.992530]  [<c102b116>] native_flush_tlb_others+0x26/0x30
Oct 20 07:08:21 localhost kernel: [  146.992532]  [<c102b422>] flush_tlb_page+0x82/0xd0
Oct 20 07:08:21 localhost kernel: [  146.992536]  [<c10aa13f>] ptep_clear_flush+0x1f/0x30
Oct 20 07:08:21 localhost kernel: [  146.992540]  [<c109e239>] handle_pte_fault+0x589/0xc40
Oct 20 07:08:21 localhost kernel: [  146.992543]  [<c10bfc7f>] ? pipe_write+0x37f/0x490
Oct 20 07:08:21 localhost kernel: [  146.992546]  [<c109f6d4>] handle_mm_fault+0x1c4/0x240
Oct 20 07:08:21 localhost kernel: [  146.992550]  [<c1026870>] ? vmalloc_sync_all+0x10/0x10
Oct 20 07:08:21 localhost kernel: [  146.992553]  [<c1026967>] do_page_fault+0xf7/0x3e0
Oct 20 07:08:21 localhost kernel: [  146.992556]  [<c10b7ddf>] ? vfs_write+0x11f/0x170
Oct 20 07:08:21 localhost kernel: [  146.992558]  [<c10b5abf>] ? filp_close+0x4f/0x80
Oct 20 07:08:21 localhost kernel: [  146.992561]  [<c10b5b5d>] ? sys_close+0x6d/0xc0
Oct 20 07:08:21 localhost kernel: [  146.992564]  [<c1026870>] ? vmalloc_sync_all+0x10/0x10
Oct 20 07:08:21 localhost kernel: [  146.992568]  [<c12f950a>] error_code+0x5a/0x60
Oct 20 07:08:21 localhost kernel: [  146.992571]  [<c1026870>] ? vmalloc_sync_all+0x10/0x10
Oct 20 07:08:21 localhost kernel: [  146.992573] ---[ end trace ac116d5460229ce4 ]---

Yet another crash:

Oct 20 07:03:25 localhost kernel: [   84.600996] chrome: Corrupted page table at address 46e15000
Oct 20 07:03:25 localhost kernel: [   84.601001] *pdpt = 0000000000000000 *pde = f000eef3f000eef3
Oct 20 07:03:25 localhost kernel: [   84.601006] Bad pagetable: 000f [#1] PREEMPT SMP
Oct 20 07:03:25 localhost kernel: [   84.601010] Modules linked in: pppoe pppox ppp_synctty ppp_async crc_ccitt ppp_generic slhc ipv6 nf_conntrack_ftp nf_con
ntrack_netbios_ns nf_conntrack_broadcast xt_LOG xt_limit nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack xt_tcpudp xt_pkttype ipt_ULOG xt_owner xt_mul
tiport iptable_filter ip_tables x_tables w83627ehf adt7475 hwmon_vid vboxpci(O) vboxnetadp(O) vboxnetflt(O) vboxdrv(O) binfmt_misc fuse hid_generic uvcvideo
videobuf2_core videodev videobuf2_vmalloc videobuf2_memops snd_usb_audio snd_hwdep snd_usbmidi_lib snd_rawmidi usbhid hid coretemp aesni_intel ablk_helper cr
yptd aes_i586 aes_generic microcode sg sr_mod cdrom pcspkr i2c_i801 fan e1000e snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_seq_oss snd_seq_midi_eve
nt snd_seq snd_seq_device snd_pcm_oss snd_mixer_oss snd_pcm snd_timer snd snd_page_alloc xhci_hcd evdev ehci_hcd nvidia(PO) agpgart
Oct 20 07:03:25 localhost kernel: [   84.601072] Pid: 2359, comm: chrome Tainted: P           O 3.6.2-ic #2 System manufacturer System Product Name/P8P67 PRO
Oct 20 07:03:25 localhost kernel: [   84.601075] EIP: 0073:[<b4791468>] EFLAGS: 00010202 CPU: 2
Oct 20 07:03:25 localhost kernel: [   84.601079] EIP is at 0xb4791468
Oct 20 07:03:25 localhost kernel: [   84.601081] EAX: 46e15000 EBX: b785fff4 ECX: 00000007 EDX: 00000057
Oct 20 07:03:25 localhost kernel: [   84.601083] ESI: bfc48348 EDI: 46e15000 EBP: bfc482f8 ESP: bfc482e0
Oct 20 07:03:25 localhost kernel: [   84.601086]  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 007b
Oct 20 07:03:25 localhost kernel: [   84.601088] Process chrome (pid: 2359, ti=dcd88000 task=f267d360 task.ti=dcd88000)
Oct 20 07:03:25 localhost kernel: [   84.601089]
Oct 20 07:03:25 localhost kernel: [   84.601091] EIP: [<b4791468>] 0xb4791468 SS:ESP 007b:bfc482e0
Oct 20 07:03:25 localhost kernel: [   84.601097] ---[ end trace 2fe495949bdb4add ]---

I wonder what can cause it.

I will try 3.5.x soon.

Best wishes,

Artem
