Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752749Ab1F3Lwg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 07:52:36 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:57291 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751626Ab1F3Lw1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 07:52:27 -0400
From: Marek Vasut <marek.vasut@gmail.com>
To: linux-arm-kernel@lists.infradead.org
Subject: Re: kernel panic in spi_complete() on spitz (PXA270)
Date: Thu, 30 Jun 2011 13:52:21 +0200
User-Agent: KMail/1.13.7 (Linux/2.6.39-1-amd64; KDE/4.6.3; x86_64; ; )
Cc: Stanislav Brabec <utx@penguin.cz>, zaurus-devel@www.linuxtogo.org,
        spi-devel-general@lists.sourceforge.net,
        Igor Grinberg <grinberg@compulab.co.il>, vapier@gentoo.org,
        khilman@deeprootsystems.com, dmitry.torokhov@gmail.com,
        linux-kernel@vger.kernel.org, pavel@ucw.cz,
        linux-input@vger.kernel.org, eric.y.miao@gmail.com,
        akpm@linux-foundation.org, broonie@opensource.wolfsonmicro.com
References: <1308845380.4533.54.camel@oct.suse.cz>
In-Reply-To: <1308845380.4533.54.camel@oct.suse.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201106301352.21684.marek.vasut@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, June 23, 2011 06:09:40 PM Stanislav Brabec wrote:
> Hallo.
> 
> These Oops and kernel panic were observed on a Zaurus (spitz) machine
> (ARMv5, PXA270).

Looks similar to "Re: [PATCH v2] Input: Make ADS7846 independent on regulator"

CCing previously involved people, I'd like to see their opinion.
> 
> Kernel version: config-3.0.0-rc4+ (2992c4b)
> 
> Unable to handle kernel NULL pointer dereference at virtual address
> 00000000 pgd = c0004000
> [00000000] *pgd=00000000
> Internal error: Oops: 17 [#1] PREEMPT
> Modules linked in: uinput g_ether cryptomgr aead arc4 crypto_algapi
> rt2800usb rt2800lib rt2x00usb rt2x00lib mac80211 cfg80211 sg pcmciamtd
> mousedev snd_soc_wm8750 snd_soc_pxa2xx_i2s snd_soc_core ohci_hcd usbcore
> pxa27x_udc physmap snd_pcm_oss snd_pcm snd_timer snd_page_alloc
> snd_mixer_oss snd soundcore rfcomm pxaficp_ir ircomm_tty ircomm irda ipv6
> hidp hid bluetooth rfkill crc16 CPU: 0    Not tainted  (3.0.0-rc4+ #5)
> PC is at complete+0x28/0x7c
> LR is at complete+0x28/0x7c
> pc : [<c0036b6c>]    lr : [<c0036b6c>]    psr: 80000093
> sp : c3897b68  ip : c3897b68  fp : c3897b84
> r10: c4806000  r9 : c381f3e0  r8 : 0000000a
> r7 : c30f0da8  r6 : 00000000  r5 : 00000000  r4 : a0000013
> r3 : c3896000  r2 : 00000000  r1 : 00000103  r0 : 00000004
> Flags: Nzcv  IRQs off  FIQs on  Mode SVC_32  ISA ARM  Segment kernel
> Control: 0000397f  Table: a080c000  DAC: 00000017
> Process kswapd0 (pid: 270, stack limit = 0xc3896278)
> Stack: (0xc3897b68 to 0xc3898000)
> 7b60:                   00000000 c3808158 c3808158 c30f0da8 c3897b94
> c3897b88 7b80: c01e9b0c c0036b50 c3897bb4 c3897b98 c01eac2c c01e9b08
> c3808158 c388e220 7ba0: c30f0df8 c30f0da8 c3897bf4 c3897bb8 c01eb60c
> c01eab24 00000000 00000010 7bc0: 00000000 00000000 00000001 c03b3f00
> c039b5d4 00000000 00000103 0000000a 7be0: 00000006 00000000 c3897c14
> c3897bf8 c0044924 c01eb4dc c0044894 c3896000 7c00: 00000001 c03b3f3c
> c3897c4c c3897c18 c0044eb8 c00448a0 00000000 c38046c0 7c20: c3897c44
> 00000010 00000000 00100000 00000002 00000001 c3896000 00000000 7c40:
> c3897c5c c3897c50 c00453a0 c0044e2c c3897c74 c3897c60 c002406c c0045360
> 7c60: ffffffff c3897cac c3897cfc c3897c78 c0024b84 c002400c 4022d320
> 4022e000 7c80: 08000075 00001000 c32273c0 c03ce1c0 c2b49b78 4022d000
> c2b420b4 00000001 7ca0: 00000000 c3897cfc 00000000 c3897cc0 c00afc54
> c002edd8 00000013 ffffffff 7cc0: 00000000 c0447550 00000002 c32273f4
> c3897d3c c2b49b78 c3897d3c 00000000 7ce0: c341fbec 00000003 00000001
> c03ce1c0 c3897d84 c3897d00 c00affd8 c00afb9c 7d00: c00af774 c003505c
> 00000000 c03ce1c0 00000000 c341fc10 c03ce1c0 00000000 7d20: c30d0c28
> c3897d50 c341fc10 c3897e44 c3897d9c c341fbec c00b09cc c3be9308 7d40:
> 00000080 00000000 00000000 c341fc00 00000074 00000074 00000000 c03ce1c0
> 7d60: c03ce1c0 c3897f44 c341fbec 00000003 00000001 c3897e44 c3897d9c
> c3897d88 7d80: c00b07ac c00aff4c 00000001 c03ce1d8 c3897e2c c3897da0
> c009b940 c00b0778 7da0: 00000001 c03acfc8 00000000 00000000 c3896000
> 00000000 c04032a0 c04032c0 7dc0: c040cc20 c040cc40 c040cc60 c040cc80
> c3897e2c c3897de0 c009a908 c009a7c0 7de0: c0403220 c03bbd14 c3897e54
> c03ce198 c03cec38 c3897df4 c3897df4 00000000 7e00: 00000000 c03acfc8
> c3897f44 00000020 00000020 0000000c c3896000 00000001 7e20: c3897e7c
> c3897e30 c009c448 c009b6a4 00000000 00000000 00000001 c3897e38 7e40:
> c3897e40 c04445d8 c03ce1f8 00000020 00000000 00000020 c03acfc8 00000002
> 7e60: c3897f44 00000020 0000000c 00000001 c3897f04 c3897e80 c009c8f8
> c009c23c 7e80: 00000001 00000014 c3897f44 00000020 c3897f44 0000000c
> c03ad224 c03ad228 7ea0: 00000000 ffffffff 00000001 00000003 c3897ecc
> 00000000 00000000 00000000 7ec0: 00000020 c3897ed0 00000056 00000000
> 000018c9 00000000 c03acfc8 c03acfc8 7ee0: 00000000 c03acfc8 c03acfc8
> 00000000 0000000c 00000000 c3897fbc c3897f08 7f00: c009ceb0 c009c580
> 00000000 c039af90 c3897fbc 00000000 c03acfc8 c3897f84 7f20: 00000000
> c3897f8c 00000001 c3896000 00000000 00002f2e 00000000 00000000 7f40:
> 184c1a27 00000048 00000000 ffffffff 00000000 000000d0 00000001 00000001
> 7f60: 00000001 0000003c 00000000 00000003 00000000 00000000 000000d0
> 00000000 7f80: c0059f8c c3897f84 c3897f84 00000000 c3897fbc c3825f38
> c03acfc8 c009ca20 7fa0: 00000013 00000000 00000000 00000000 c3897ff4
> c3897fc0 c0059be0 c009ca2c 7fc0: c3825f38 00000000 c03acfc8 00000000
> c3897fd0 c3897fd0 00000000 c3825f38 7fe0: c0059b50 c00258d8 00000000
> c3897ff8 c00258d8 c0059b5c 00000000 00000000 [<c0036b6c>]
> (complete+0x28/0x7c) from [<c01e9b0c>] (spi_complete+0x10/0x14)
> [<c01e9b0c>] (spi_complete+0x10/0x14) from [<c01eac2c>]
> (giveback+0x114/0x12c) [<c01eac2c>] (giveback+0x114/0x12c) from
> [<c01eb60c>] (pump_transfers+0x13c/0x6f8) [<c01eb60c>]
> (pump_transfers+0x13c/0x6f8) from [<c0044924>] (tasklet_action+0x90/0xf0)
> [<c0044924>] (tasklet_action+0x90/0xf0) from [<c0044eb8>]
> (__do_softirq+0x98/0x138) [<c0044eb8>] (__do_softirq+0x98/0x138) from
> [<c00453a0>] (irq_exit+0x4c/0xa8) [<c00453a0>] (irq_exit+0x4c/0xa8) from
> [<c002406c>] (asm_do_IRQ+0x6c/0x8c) [<c002406c>] (asm_do_IRQ+0x6c/0x8c)
> from [<c0024b84>] (__irq_svc+0x44/0xcc) Exception stack(0xc3897c78 to
> 0xc3897cc0)
> 7c60:                                                       4022d320
> 4022e000 7c80: 08000075 00001000 c32273c0 c03ce1c0 c2b49b78 4022d000
> c2b420b4 00000001 7ca0: 00000000 c3897cfc 00000000 c3897cc0 c00afc54
> c002edd8 00000013 ffffffff [<c0024b84>] (__irq_svc+0x44/0xcc) from
> [<c002edd8>] (xscale_flush_user_cache_range+0x18/0x3c) [<c002edd8>]
> (xscale_flush_user_cache_range+0x18/0x3c) from [<c00affd8>]
> (try_to_unmap_file+0x98/0x4ec) [<c00affd8>] (try_to_unmap_file+0x98/0x4ec)
> from [<c00b07ac>] (try_to_unmap+0x40/0x60) [<c00b07ac>]
> (try_to_unmap+0x40/0x60) from [<c009b940>] (shrink_page_list+0x2a8/0x8cc)
> [<c009b940>] (shrink_page_list+0x2a8/0x8cc) from [<c009c448>]
> (shrink_inactive_list+0x218/0x344) [<c009c448>]
> (shrink_inactive_list+0x218/0x344) from [<c009c8f8>]
> (shrink_zone+0x384/0x4ac) [<c009c8f8>] (shrink_zone+0x384/0x4ac) from
> [<c009ceb0>] (kswapd+0x490/0x7d0) [<c009ceb0>] (kswapd+0x490/0x7d0) from
> [<c0059be0>] (kthread+0x90/0x98) [<c0059be0>] (kthread+0x90/0x98) from
> [<c00258d8>] (kernel_thread_exit+0x0/0x8) Code: e3843080 e121f003 e3a00001
> ebfff96a (e5953000)
> ---[ end trace a4b97c165577d355 ]---
> Kernel panic - not syncing: Fatal exception in interrupt
> [<c00298fc>] (unwind_backtrace+0x0/0xe4) from [<c0295e1c>]
> (dump_stack+0x18/0x1c) [<c0295e1c>] (dump_stack+0x18/0x1c) from
> [<c0295e84>] (panic+0x64/0x18c) [<c0295e84>] (panic+0x64/0x18c) from
> [<c002842c>] (die+0x300/0x358) [<c002842c>] (die+0x300/0x358) from
> [<c002c294>] (__do_kernel_fault+0x6c/0x90) [<c002c294>]
> (__do_kernel_fault+0x6c/0x90) from [<c002c508>]
> (do_page_fault+0x250/0x270) [<c002c508>] (do_page_fault+0x250/0x270) from
> [<c0024214>] (do_DataAbort+0x38/0xa0) [<c0024214>]
> (do_DataAbort+0x38/0xa0) from [<c0024b2c>] (__dabt_svc+0x4c/0x60)
> Exception stack(0xc3897b20 to 0xc3897b68)
> 7b20: 00000004 00000103 00000000 c3896000 a0000013 00000000 00000000
> c30f0da8 7b40: 0000000a c381f3e0 c4806000 c3897b84 c3897b68 c3897b68
> c0036b6c c0036b6c 7b60: 80000093 ffffffff
> [<c0024b2c>] (__dabt_svc+0x4c/0x60) from [<c0036b6c>] (complete+0x28/0x7c)
> [<c0036b6c>] (complete+0x28/0x7c) from [<c01e9b0c>]
> (spi_complete+0x10/0x14) [<c01e9b0c>] (spi_complete+0x10/0x14) from
> [<c01eac2c>] (giveback+0x114/0x12c) [<c01eac2c>] (giveback+0x114/0x12c)
> from [<c01eb60c>] (pump_transfers+0x13c/0x6f8) [<c01eb60c>]
> (pump_transfers+0x13c/0x6f8) from [<c0044924>] (tasklet_action+0x90/0xf0)
> [<c0044924>] (tasklet_action+0x90/0xf0) from [<c0044eb8>]
> (__do_softirq+0x98/0x138) [<c0044eb8>] (__do_softirq+0x98/0x138) from
> [<c00453a0>] (irq_exit+0x4c/0xa8) [<c00453a0>] (irq_exit+0x4c/0xa8) from
> [<c002406c>] (asm_do_IRQ+0x6c/0x8c) [<c002406c>] (asm_do_IRQ+0x6c/0x8c)
> from [<c0024b84>] (__irq_svc+0x44/0xcc) Exception stack(0xc3897c78 to
> 0xc3897cc0)
> 7c60:                                                       4022d320
> 4022e000 7c80: 08000075 00001000 c32273c0 c03ce1c0 c2b49b78 4022d000
> c2b420b4 00000001 7ca0: 00000000 c3897cfc 00000000 c3897cc0 c00afc54
> c002edd8 00000013 ffffffff [<c0024b84>] (__irq_svc+0x44/0xcc) from
> [<c002edd8>] (xscale_flush_user_cache_range+0x18/0x3c) [<c002edd8>]
> (xscale_flush_user_cache_range+0x18/0x3c) from [<c00affd8>]
> (try_to_unmap_file+0x98/0x4ec) [<c00affd8>] (try_to_unmap_file+0x98/0x4ec)
> from [<c00b07ac>] (try_to_unmap+0x40/0x60) [<c00b07ac>]
> (try_to_unmap+0x40/0x60) from [<c009b940>] (shrink_page_list+0x2a8/0x8cc)
> [<c009b940>] (shrink_page_list+0x2a8/0x8cc) from [<c009c448>]
> (shrink_inactive_list+0x218/0x344) [<c009c448>]
> (shrink_inactive_list+0x218/0x344) from [<c009c8f8>]
> (shrink_zone+0x384/0x4ac) [<c009c8f8>] (shrink_zone+0x384/0x4ac) from
> [<c009ceb0>] (kswapd+0x490/0x7d0) [<c009ceb0>] (kswapd+0x490/0x7d0) from
> [<c0059be0>] (kthread+0x90/0x98) [<c0059be0>] (kthread+0x90/0x98) from
> [<c00258d8>] (kernel_thread_exit+0x0/0x8)
> 
> 
> My config:
> http://www.penguin.cz/~utx/zaurus/feed/images/spitz/config-3.0.0-rc4+-spitz
> 
> Only small ads7846 patch was applied on top of it:
> http://www.penguin.cz/~utx/zaurus/feed/images/spitz/zImage-3.0.0-rc4+-spitz
> .diff
