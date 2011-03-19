Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757628Ab1CSWGX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Mar 2011 18:06:23 -0400
Received: from smtpo.poczta.interia.pl ([217.74.65.205]:24598 "EHLO
	smtpo.poczta.interia.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757544Ab1CSWGV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Mar 2011 18:06:21 -0400
X-Greylist: delayed 574 seconds by postgrey-1.27 at vger.kernel.org; Sat, 19 Mar 2011 18:06:20 EDT
Date: Sat, 19 Mar 2011 23:06:18 +0100
From: Mac <kmac@poczta.fm>
Subject: 'scheduling while atomic' during ppp connection on 2.6.37.1 and
 2.6.38
To: linux-kernel@vger.kernel.org
Cc: linux-ppp@vger.kernel.org
X-Mailer: interia.pl/pf09
X-Originating-IP: 87.96.53.40
Message-Id: <fuopaigyaypsqveewtjx@pwmq>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-EMID: 96e841a0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
 
when I am connected to Internet through ppp connection by nozomi driver (PCMCIA Option N.V. Qualcomm MSM6275 UMTS chip) for almost every minute I get such messages on all terminal and opened xterms. In any other scenario - connection via Ethernet or WiFi issue not exists.
 
 
(Please add my e-mail address to CC when you will reply to this message! Thx!)
 
 
Message from syslogd@granit at Sat Mar 19 22:48:50 2011 ...
granit kernel: [ 8176.570123] Stack:

Message from syslogd@granit at Sat Mar 19 22:48:50 2011 ...
granit kernel: [ 8176.570168] Code: ff 0d fa 19 00 00 e8 59 1f fe e0 48 89 c7 b9 e8 03 00 00 31 d2 4c 29 e7 48 89 f8 48 f7 f1 49 89 c4 e8 17 fe fd e0 fb 80 7b 08 01 <74> 0f 48 8b 04 25 48 10 75 81 83 88 3c e0 ff ff 04 ff 43 18 31 
 
Message from syslogd@granit at Sat Mar 19 22:48:50 2011 ...
granit kernel: [ 8176.569158] Call Trace:

Message from syslogd@granit at Sat Mar 19 22:48:50 2011 ...
granit kernel: [ 8176.569186] Code: df e8 ca fc ff ff e8 7b 1e fe e0 48 89 c7 b9 e8 03 00 00 31 d2 4c 29 e7 48 89 f8 48 f7 f1 49 89 c4 e8 39 fd fd e0 fb 80 7b 08 01 <74> 0f 48 8b 04 25 48 10 75 81 83 88 3c e0 ff ff 04 ff 43 18 31 
 
Message from syslogd@granit at Sat Mar 19 22:48:50 2011 ...
granit kernel: [ 8176.570139] Call Trace:

Message from syslogd@granit at Sat Mar 19 22:48:50 2011 ...
granit kernel: [ 8176.569140] Stack:
 
--------------------------------
 
 dmesg returned:
 
    [ 9229.131031] BUG: scheduling while atomic: firefox-bin/1992/0x10000800
    [ 9229.131035] Modules linked in: ppp_async crc_ccitt ppp_generic slhc snd_hda_codec_realtek ath5k ath processor battery ac snd_hda_intel r8169 sdhci_pci sparse_keymap sdhci snd_hda_codec mmc_core nozomi container snd_hwdep
    [ 9229.131076] Pid: 1992, comm: firefox-bin Not tainted 2.6.38 #1
    [ 9229.131079] Call Trace:
    [ 9229.131089]  [] ? schedule+0x67/0x3db
    [ 9229.131095]  [] ? nf_conntrack_tuple_taken+0xa2/0xad
    [ 9229.131102]  [] ? __cond_resched+0x1c/0x25
    [ 9229.131105]  [] ? _cond_resched+0x16/0x20
    [ 9229.131109]  [] ? mutex_lock+0xe/0x21
    [ 9229.131116]  [] ? ntty_write+0x5d/0x192 [nozomi]
    [ 9229.131121]  [] ? __mod_timer.clone.30+0xbe/0xcc
    [ 9229.131126]  [] ? check_preempt_curr+0x60/0x6d
    [ 9229.131130]  [] ? __nf_ct_refresh_acct+0x75/0xbe
    [ 9229.131135]  [] ? ppp_async_push+0xa9/0x3bd [ppp_async]
    [ 9229.131140]  [] ? ppp_async_send+0x34/0x40 [ppp_async]
    [ 9229.131146]  [] ? ppp_push+0x6c/0x4f9 [ppp_generic]
    [ 9229.131152]  [] ? selinux_ip_postroute+0x3d/0x210
    [ 9229.131156]  [] ? ipt_do_table+0x300/0x328
    [ 9229.131162]  [] ? _local_bh_enable_ip.clone.10+0x1f/0x88
    [ 9229.131166]  [] ? ipt_do_table+0x300/0x328
    [ 9229.131171]  [] ? ppp_xmit_process+0x3f5/0x472 [ppp_generic]
    [ 9229.131176]  [] ? ppp_start_xmit+0x155/0x174 [ppp_generic]
    [ 9229.131181]  [] ? dev_hard_start_xmit+0x3c7/0x4a0
    [ 9229.131186]  [] ? sch_direct_xmit+0x3e/0xee
    [ 9229.131190]  [] ? dev_queue_xmit+0x1cd/0x322
    [ 9229.131194]  [] ? ip_queue_xmit+0x2d4/0x330
    [ 9229.131200]  [] ? file_update_time+0x30/0x101
    [ 9229.131204]  [] ? tcp_transmit_skb+0x6ee/0x721
    [ 9229.131208]  [] ? tcp_write_xmit+0x765/0x851
    [ 9229.131213]  [] ? __alloc_skb+0x81/0x121
    [ 9229.131217]  [] ? __tcp_push_pending_frames+0x18/0x44
    [ 9229.131221]  [] ? tcp_close+0x127/0x2f7
    [ 9229.131226]  [] ? inet_release+0x53/0x5c
    [ 9229.131231]  [] ? sock_release+0x19/0x6e
    [ 9229.131234]  [] ? sock_close+0x22/0x29
    [ 9229.131239]  [] ? fput+0xf8/0x19a
    [ 9229.131243]  [] ? filp_close+0x5d/0x68
    [ 9229.131246]  [] ? sys_close+0x6f/0x9e
    [ 9229.131251]  [] ? system_call_fastpath+0x16/0x1b
    [ 9261.546054] BUG: scheduling while atomic: firefox-bin/1983/0x10000900
    [ 9261.546057] Modules linked in: ppp_async crc_ccitt ppp_generic slhc snd_hda_codec_realtek ath5k ath processor battery ac snd_hda_intel r8169 sdhci_pci sparse_keymap sdhci snd_hda_codec mmc_core nozomi container snd_hwdep
    [ 9261.546077] CPU 0
    [ 9261.546078] Modules linked in: ppp_async crc_ccitt ppp_generic slhc snd_hda_codec_realtek ath5k ath processor battery ac snd_hda_intel r8169 sdhci_pci sparse_keymap sdhci snd_hda_codec mmc_core nozomi container snd_hwdep
    [ 9261.546094]
    [ 9261.546097] Pid: 1983, comm: firefox-bin Not tainted 2.6.38 #1 TOSHIBA Satellite A135/IAKAA
    [ 9261.546103] RIP: 0033:[<00007f61448c9325>]  [<00007f61448c9325>] 0x7f61448c93
    25
    [ 9261.546111] RSP: 002b:00007fffba8d5a10  EFLAGS: 00000246
    [ 9261.546114] RAX: 0000000000000000 RBX: 000000000000fe2e RCX: 000000000000000c
    [ 9261.546117] RDX: 0000000000000001 RSI: 0000000000000003 RDI: 0000000000000003
    [ 9261.546120] RBP: 00007f611b0015f0 R08: 00007f6144bc5040 R09: 00000000000007bf
    [ 9261.546123] R10: 00007f6135987c00 R11: 00007f6143528406 R12: ffffffff8100310e
    [ 9261.546126] R13: 00007fffba8d4c00 R14: 00007f6135987c00 R15: 00007f6135987c00
    [ 9261.546130] FS:  00007f6144cc6760(0000) GS:ffffffff81754000(0000) knlGS:0000000000000000
    [ 9261.546134] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
    [ 9261.546137] CR2: 00007f611f167000 CR3: 000000002e51d000 CR4: 00000000000006f0
    [ 9261.546140] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
    [ 9261.546143] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
    [ 9261.546147] Process firefox-bin (pid: 1983, threadinfo ffff88002e70c000, task ffff88002e697690)
    [ 9261.546150]
    [ 9261.546151] Call Trace:
    [ 9261.547048] BUG: scheduling while atomic: firefox-bin/1983/0x10000900
    [ 9261.547052] Modules linked in: ppp_async crc_ccitt ppp_generic slhc snd_hda_codec_realtek ath5k ath processor battery ac snd_hda_intel r8169 sdhci_pci sparse_keymap sdhci snd_hda_codec mmc_core nozomi container snd_hwdep
    [ 9261.547070] CPU 0
    [ 9261.547071] Modules linked in: ppp_async crc_ccitt ppp_generic slhc snd_hda_codec_realtek ath5k ath processor battery ac snd_hda_intel r8169 sdhci_pci sparse_keymap sdhci snd_hda_codec mmc_core nozomi container snd_hwdep
    [ 9261.547086]
    [ 9261.547090] Pid: 1983, comm: firefox-bin Not tainted 2.6.38 #1 TOSHIBA Satellite A135/IAKAA
    [ 9261.547095] RIP: 0033:[<00007f6143be649c>]  [<00007f6143be649c>] 0x7f6143be649c
    [ 9261.547102] RSP: 002b:00007fffba8d44c8  EFLAGS: 00000246
    [ 9261.547105] RAX: 00007f6134d32120 RBX: 000000000000fe2e RCX: fffbff61234c8068
    [ 9261.547109] RDX: 00007f6135bfe1c8 RSI: 00007f6135987c00 RDI: 0000000000000000
    [ 9261.547112] RBP: 00007fffba8d4fe0 R08: 0000000000000001 R09: 00000000000007bf
    [ 9261.547115] R10: 0000000000000000 R11: 00007f61437786fd R12: ffffffff8100310e
    [ 9261.547118] R13: 00007fffba8d4c00 R14: 00007f6135987c00 R15: 00007f6135987c00
    [ 9261.547122] FS:  00007f6144cc6760(0000) GS:ffffffff81754000(0000) knlGS:0000000000000000
    [ 9261.547125] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
    [ 9261.547128] CR2: 00007f611f167000 CR3: 000000002e51d000 CR4: 00000000000006f0
    [ 9261.547132] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
    [ 9261.547135] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
    [ 9261.547138] Process firefox-bin (pid: 1983, threadinfo ffff88002e70c000, task ffff88002e697690)
    [ 9261.547141]
    [ 9261.547142] Call Trace:
    [ 9357.607036] BUG: scheduling while atomic: swapper/0/0x10000900
    [ 9357.607040] Modules linked in: ppp_async crc_ccitt ppp_generic slhc snd_hda_codec_realtek ath5k ath processor battery ac snd_hda_intel r8169 sdhci_pci sparse_keymap sdhci snd_hda_codec mmc_core nozomi container snd_hwdep
    [ 9357.607059] CPU 0
    [ 9357.607060] Modules linked in: ppp_async crc_ccitt ppp_generic slhc snd_hda_codec_realtek ath5k ath processor battery ac snd_hda_intel r8169 sdhci_pci sparse_keymap sdhci snd_hda_codec mmc_core nozomi container snd_hwdep
    [ 9357.607076]
    [ 9357.607079] Pid: 0, comm: swapper Not tainted 2.6.38 #1 TOSHIBA Satellite A135/IAKAA
    [ 9357.607085] RIP: 0010:[]  [] acpi_idle_enter_bm+0x1ba/0x1ed [processor]
    [ 9357.607095] RSP: 0018:ffffffff8173bf18  EFLAGS: 00000246
    [ 9357.607098] RAX: 00000882bcd77470 RBX: 00000000ffffffff RCX: 00000882bccf66b0
    [ 9357.607102] RDX: 00000882bcd77470 RSI: 00000882bcd77470 RDI: 0000000000000035
    [ 9357.607105] RBP: ffff88003c26e000 R08: 0000000000000000 R09: 00000000000000bb
    [ 9357.607108] R10: 0000000000000001 R11: dead000000200200 R12: ffffffff8153b30e
    [ 9357.607111] R13: 00000000000000bb R14: ffffffff8104dbb6 R15: 0000000000000000
    [ 9357.607115] FS:  0000000000000000(0000) GS:ffffffff81754000(0000) knlGS:0000000000000000
    [ 9357.607119] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
    [ 9357.607122] CR2: 00007f5446b5f000 CR3: 000000003ba9c000 CR4: 00000000000006f0
    [ 9357.607125] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
    [ 9357.607128] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
    [ 9357.607132] Process swapper (pid: 0, threadinfo ffffffff8173a000, task ffffffff8174c040)
    [ 9357.607134] Stack:
    [ 9357.607138]  ffffffff810485c3 0000000000003e80 ffff88003c26e020 ffff88003c26e020
    [ 9357.607143]  ffff88003c26e150 ffff88003f67a380 ffffffffffffffff ffffffff813e357a
    [ 9357.607147]  ffffffff817f7b60 ffffffff8173a000 ffffffff817f7b60 ffffffff81001272
    [ 9357.607152] Call Trace:
    [ 9357.607160]  [] ? pm_qos_request+0x23/0x48
    [ 9357.607168]  [] ? cpuidle_idle_call+0x87/0xc4
    [ 9357.607173]  [] ? cpu_idle+0x79/0x9b
    [ 9357.607178]  [] ? start_kernel+0x388/0x393
    [ 9357.607182]  [] ? x86_64_start_kernel+0xfa/0x100
    [ 9357.607184] Code: ff 0d fa 19 00 00 e8 59 7f fa e0 48 89 c7 b9 e8 03 00 00 31 d2 4c 29 e7 48 89 f8 48 f7 f1 49 89 c4 e8 17 5e fa e0 fb 80 7b 08 01 <74> 0f 48 8b 04 25 48 30 75 81 83 88 3c e0 ff ff 04 ff 43 18 31
    [ 9357.607215] Call Trace:
    [ 9357.607219]  [] ? pm_qos_request+0x23/0x48
    [ 9357.607223]  [] ? cpuidle_idle_call+0x87/0xc4
    [ 9357.607227]  [] ? cpu_idle+0x79/0x9b
    [ 9357.607231]  [] ? start_kernel+0x388/0x393
    [ 9357.607235]  [] ? x86_64_start_kernel+0xfa/0x100

---------------------------------------------------

found on Slackware 13.1

bash-4.1$ uname -a
Linux granit 2.6.38 #3 Sat Mar 19 19:39:42 CET 2011 x86_64 Intel(R) Celeron(R) M CPU 520  @ 1.60GHz GenuineIntel GNU/Linux
 
glibc-2.11.1

-------------------------------------------------
Jeszcze wiecej informacji, jeszcze wiecej artykulow!
Nowa Interia >> http://linkint.pl/f294c

