Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758153Ab1LGSms (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 13:42:48 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:45957 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756968Ab1LGSmq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 13:42:46 -0500
MIME-Version: 1.0
In-Reply-To: <4EDF5231.6080309@bitmer.com>
References: <1323105820-25946-1-git-send-email-felipe.contreras@nokia.com>
	<1323105820-25946-3-git-send-email-felipe.contreras@nokia.com>
	<CAMP44s3Szzm9iXxghXfNCBjKyUw-nRrG1aEeweKnRCidaxmxEA@mail.gmail.com>
	<4EDF5231.6080309@bitmer.com>
Date: Wed, 7 Dec 2011 20:42:46 +0200
Message-ID: <CAMP44s0a6hcORZn8wDxHUJKxs=wjAmkhRfiT9kEA_MoDYeAmfg@mail.gmail.com>
Subject: Re: [PATCH 2/2] Revert "ARM: RX-51: Enable isp1704 power on/off"
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Jarkko Nikula <jarkko.nikula@bitmer.com>
Cc: Felipe Contreras <felipe.contreras@nokia.com>,
        linux-main <linux-kernel@vger.kernel.org>,
        Kalle Jokiniemi <kalle.jokiniemi@nokia.com>,
        Heikki Krogerus <heikki.krogerus@nokia.com>,
        Anton Vorontsov <cbouatmailru@gmail.com>,
        Tony Lindgren <tony@atomide.com>, linux-omap@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 7, 2011 at 1:46 PM, Jarkko Nikula <jarkko.nikula@bitmer.com> wrote:
> On 12/05/2011 07:31 PM, Felipe Contreras wrote:
>>
>> Should probably have CC'ed linux-omap.
>>
>> On Mon, Dec 5, 2011 at 7:23 PM, Felipe Contreras
>> <felipe.contreras@nokia.com>  wrote:
>>>
>>> From: Felipe Contreras<felipe.contreras@gmail.com>
>>>
>>> This reverts commit 10299e2e4e3ed3b16503d4e04edd48b33083f4e2.
>>>
>>> This seems to break USB networking stuff.
>>>
> I don't think revert is needed since CONFIG_CHARGER_ISP1704=y should make it
> working. Although I don't know do we really need to drive the ISP1704 into
> reset in board-rx51-peripherals.c? Would it be better to leave gpio state as
> it was set by the bootloader and let the driver to do reset sequence if
> needed?
>
> http://marc.info/?l=linux-omap&m=130795363204884&w=2

Nope, that's actually worst:

Unhandled fault: external abort on non-linefetch (0x1028) at 0xfa0ab001
Internal error: : 1028 [#1]
Modules linked in:
CPU: 0    Tainted: G        W     (3.2.0-rc4-n900+ #5)
PC is at musb_ulpi_write+0x18/0x70
LR is at isp1704_charger_probe+0x7c/0x354
pc : [<c0186188>]    lr : [<c022e720>]    psr: a0000013
sp : ce81df08  ip : ce843f80  fp : 00000000
r10: 00000000  r9 : 00000000  r8 : 00000000
r7 : c0345984  r6 : c032d988  r5 : c032d9c4  r4 : fa0ab076
r3 : fa0ab000  r2 : 000000aa  r1 : 00000016  r0 : 00000000
Flags: NzCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment kernel
Control: 10c5387d  Table: 80004019  DAC: 00000015
Process swapper (pid: 1, stack limit = 0xce81c2e8)
Stack: (0xce81df08 to 0xce81e000)
df00:                   cea76840 c022e720 c032d990 c032d9c4 c0345984 c0345984
df20: 00000000 c0168d48 c0168d30 c0167ba4 00000000 c032d990 c032d9c4 c0345984
df40: 00000000 c0167cc0 c0345984 00000000 c0167c60 c016741c ce806ef8 ce85fa70
df60: c0345984 cea768c0 c0343e10 c0166d88 c02a1768 c02a1768 00000074 c0345984
df80: c030ef3c c000e874 00000000 00000000 00000000 c01682c4 c031b15c c030ef3c
dfa0: c000e874 00000000 00000000 c0008560 0000005f 0000000d c031ae90 00003539
dfc0: 00000000 c031b15c c031ae90 c000e874 00000013 00000000 00000000 00000000
dfe0: 00000000 c02f9208 00000000 00000000 c02f9198 c000e874 00000000 00000000
[<c0186188>] (musb_ulpi_write+0x18/0x70) from [<c022e720>]
(isp1704_charger_probe+0x7c/0x354)
[<c022e720>] (isp1704_charger_probe+0x7c/0x354) from [<c0168d48>]
(platform_drv_probe+0x18/0x1c)
[<c0168d48>] (platform_drv_probe+0x18/0x1c) from [<c0167ba4>]
(driver_probe_device+0xc8/0x184)
[<c0167ba4>] (driver_probe_device+0xc8/0x184) from [<c0167cc0>]
(__driver_attach+0x60/0x84)
[<c0167cc0>] (__driver_attach+0x60/0x84) from [<c016741c>]
(bus_for_each_dev+0x44/0x74)
[<c016741c>] (bus_for_each_dev+0x44/0x74) from [<c0166d88>]
(bus_add_driver+0x9c/0x20c)
[<c0166d88>] (bus_add_driver+0x9c/0x20c) from [<c01682c4>]
(driver_register+0xa4/0x130)
[<c01682c4>] (driver_register+0xa4/0x130) from [<c0008560>]
(do_one_initcall+0x94/0x164)
[<c0008560>] (do_one_initcall+0x94/0x164) from [<c02f9208>]
(kernel_init+0x70/0x118)
[<c02f9208>] (kernel_init+0x70/0x118) from [<c000e874>]
(kernel_thread_exit+0x0/0x8)
Code: e6ef2072 e6ef1071 e2834076 e3a00000 (e5d3c001)
------------[ cut here ]------------
WARNING: at arch/arm/mach-omap2/omap_l3_smx.c:161 omap3_l3_app_irq+0xe8/0x12c()
In-band Error seen by MPU  at address 0
Modules linked in:
[<c0012aa4>] (unwind_backtrace+0x0/0xec) from [<c002f97c>]
(warn_slowpath_common+0x4c/0x64)
[<c002f97c>] (warn_slowpath_common+0x4c/0x64) from [<c002fa14>]
(warn_slowpath_fmt+0x2c/0x3c)
[<c002fa14>] (warn_slowpath_fmt+0x2c/0x3c) from [<c0021d84>]
(omap3_l3_app_irq+0xe8/0x12c)
[<c0021d84>] (omap3_l3_app_irq+0xe8/0x12c) from [<c005a338>]
(handle_irq_event_percpu+0x28/0x174)
[<c005a338>] (handle_irq_event_percpu+0x28/0x174) from [<c005a4ac>]
(handle_irq_event+0x28/0x38)
[<c005a4ac>] (handle_irq_event+0x28/0x38) from [<c005c8c8>]
(handle_level_irq+0xb8/0xe0)
[<c005c8c8>] (handle_level_irq+0xb8/0xe0) from [<c0059fe8>]
(generic_handle_irq+0x28/0x30)
[<c0059fe8>] (generic_handle_irq+0x28/0x30) from [<c000e80c>]
(handle_IRQ+0x60/0x84)
[<c000e80c>] (handle_IRQ+0x60/0x84) from [<c000d4f4>] (__irq_svc+0x34/0x80)
[<c000d4f4>] (__irq_svc+0x34/0x80) from [<c002f8b0>] (oops_exit+0x0/0x18)
[<c002f8b0>] (oops_exit+0x0/0x18) from [<0000000b>] (0xb)
---[ end trace 1b75b31a2719ed1e ]---
---[ end trace 1b75b31a2719ed1f ]---
Kernel panic - not syncing: Attempted to kill init!
[<c0012aa4>] (unwind_backtrace+0x0/0xec) from [<c022ee84>] (panic+0x54/0x184)
[<c022ee84>] (panic+0x54/0x184) from [<c00327a4>] (do_exit+0x98/0x5bc)
[<c00327a4>] (do_exit+0x98/0x5bc) from [<c0011010>] (die+0x27c/0x2b8)
[<c0011010>] (die+0x27c/0x2b8) from [<c0008444>] (do_DataAbort+0x80/0x94)
[<c0008444>] (do_DataAbort+0x80/0x94) from [<c000d498>] (__dabt_svc+0x38/0x60)
Exception stack(0xce81dec0 to 0xce81df08)
dec0: 00000000 00000016 000000aa fa0ab000 fa0ab076 c032d9c4 c032d988 c0345984
dee0: 00000000 00000000 00000000 00000000 ce843f80 ce81df08 c022e720 c0186188
df00: a0000013 ffffffff
[<c000d498>] (__dabt_svc+0x38/0x60) from [<c0186188>]
(musb_ulpi_write+0x18/0x70)
[<c0186188>] (musb_ulpi_write+0x18/0x70) from [<c022e720>]
(isp1704_charger_probe+0x7c/0x354)
[<c022e720>] (isp1704_charger_probe+0x7c/0x354) from [<c0168d48>]
(platform_drv_probe+0x18/0x1c)
[<c0168d48>] (platform_drv_probe+0x18/0x1c) from [<c0167ba4>]
(driver_probe_device+0xc8/0x184)
[<c0167ba4>] (driver_probe_device+0xc8/0x184) from [<c0167cc0>]
(__driver_attach+0x60/0x84)
[<c0167cc0>] (__driver_attach+0x60/0x84) from [<c016741c>]
(bus_for_each_dev+0x44/0x74)
[<c016741c>] (bus_for_each_dev+0x44/0x74) from [<c0166d88>]
(bus_add_driver+0x9c/0x20c)
[<c0166d88>] (bus_add_driver+0x9c/0x20c) from [<c01682c4>]
(driver_register+0xa4/0x130)
[<c01682c4>] (driver_register+0xa4/0x130) from [<c0008560>]
(do_one_initcall+0x94/0x164)
[<c0008560>] (do_one_initcall+0x94/0x164) from [<c02f9208>]
(kernel_init+0x70/0x118)
[<c02f9208>] (kernel_init+0x70/0x118) from [<c000e874>]
(kernel_thread_exit+0x0/0x8)

-- 
Felipe Contreras
