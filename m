Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753660Ab2KEKWm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 05:22:42 -0500
Received: from mail-lb0-f174.google.com ([209.85.217.174]:54513 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751642Ab2KEKWl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 05:22:41 -0500
Message-ID: <5097936C.2040205@googlemail.com>
Date: Mon, 05 Nov 2012 10:22:36 +0000
From: Chris Clayton <chris2553@googlemail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121030 Thunderbird/16.0.2
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
Subject: linux-3.7.0-rc3+: Warning found in log files
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Whilst browsing the log file on my laptop (looking for diagnostics for a 
problem I have resuming from a suspend to disc), I spotted the warning 
below.

I see that vlc is mentioned. I did have a problem yesterday when, 
through vlc's UPNP functionality, I was unable to play a video stored on 
my NAS. I can't be sure whether that is related to this warning because 
I parked it and got on with investigating my resume problem. I've had 
few goes at playing the video this morning and I still can't get it to 
play via upnp, but the warning hasn't appeared, so this may be a read 
herring.

Nov  4 10:26:14 laptop kernel: ------------[ cut here ]------------
Nov  4 10:26:15 laptop kernel: WARNING: at 
arch/x86/kernel/apic/ipi.c:109 default_send_IPI_mask_logical+0xa6/0xd0()
Nov  4 10:26:15 laptop kernel: Hardware name: LIFEBOOK AH531
Nov  4 10:26:15 laptop kernel: empty IPI mask
Nov  4 10:26:15 laptop kernel: Modules linked in: r8169 iptable_filter 
xt_conntrack ipt_MASQUERADE iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 
nf_nat_ipv4 nf_nat nf_conntrack coretemp hwmon kvm_intel 
snd_hda_codec_hdmi usb_storage kvm snd_hda_codec_realtek snd_hda_intel 
snd_hda_codec fujitsu_laptop [last unloaded: r8169]
Nov  4 10:26:15 laptop kernel: Pid: 25461, comm: vlc Not tainted 
3.7.0-rc3+ #39
Nov  4 10:26:15 laptop kernel: Call Trace:
Nov  4 10:26:15 laptop kernel:  [<c102f1d8>] ? 
warn_slowpath_common+0x78/0xb0
Nov  4 10:26:15 laptop kernel:  [<c1021346>] ? 
default_send_IPI_mask_logical+0xa6/0xd0
Nov  4 10:26:15 laptop kernel:  [<c1021346>] ? 
default_send_IPI_mask_logical+0xa6/0xd0
Nov  4 10:26:15 laptop kernel:  [<c102f2a3>] ? warn_slowpath_fmt+0x33/0x40
Nov  4 10:26:15 laptop kernel:  [<c1021346>] ? 
default_send_IPI_mask_logical+0xa6/0xd0
Nov  4 10:26:15 laptop kernel:  [<c101f5df>] ? 
native_send_call_func_ipi+0x3f/0x60
Nov  4 10:26:15 laptop kernel:  [<c1072b68>] ? 
smp_call_function_many+0x178/0x220
Nov  4 10:26:15 laptop kernel:  [<c102bbf0>] ? do_flush_tlb_all+0x60/0x60
Nov  4 10:26:15 laptop kernel:  [<c102bc98>] ? 
native_flush_tlb_others+0x28/0x30
Nov  4 10:26:15 laptop kernel:  [<c102bfa2>] ? flush_tlb_page+0x82/0xd0
Nov  4 10:26:15 laptop kernel:  [<c102ad01>] ? 
ptep_set_access_flags+0x61/0x70
Nov  4 10:26:15 laptop kernel:  [<c10ad60a>] ? do_wp_page+0x33a/0x7f0
Nov  4 10:26:15 laptop kernel:  [<c1059a9f>] ? enqueue_task_fair+0x9f/0x1e0
Nov  4 10:26:15 laptop kernel:  [<c10aeeed>] ? handle_pte_fault+0x49d/0x870
Nov  4 10:26:15 laptop kernel:  [<c1350c79>] ? move_addr_to_user+0x69/0x80
Nov  4 10:26:15 laptop kernel:  [<c1351f15>] ? sys_getpeername+0x65/0xa0
Nov  4 10:26:15 laptop kernel:  [<c10b005a>] ? handle_mm_fault+0xda/0x140
Nov  4 10:26:15 laptop kernel:  [<c1026f61>] ? __do_page_fault+0x141/0x460
Nov  4 10:26:15 laptop kernel:  [<c1072f73>] ? 
generic_smp_call_function_interrupt+0x73/0x160
Nov  4 10:26:16 laptop kernel:  [<c1036364>] ? irq_exit+0x54/0x90
Nov  4 10:26:16 laptop kernel:  [<c13f2f0d>] ? 
call_function_interrupt+0x2d/0x34
Nov  4 10:26:16 laptop kernel:  [<c1027290>] ? vmalloc_sync_all+0x10/0x10
Nov  4 10:26:16 laptop kernel:  [<c13f3236>] ? error_code+0x5a/0x60
Nov  4 10:26:16 laptop kernel:  [<c1027290>] ? vmalloc_sync_all+0x10/0x10
Nov  4 10:26:16 laptop kernel: ---[ end trace ceb5cce1ffac0038 ]---

Let me know if I can provide any additional diagnostics, but please cc 
me as I'm not subscribed.

Chris
