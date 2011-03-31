Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758597Ab1CaQAW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 12:00:22 -0400
Received: from adelie.canonical.com ([91.189.90.139]:38895 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753276Ab1CaQAT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 12:00:19 -0400
Message-ID: <4D94A510.4040509@canonical.com>
Date: Thu, 31 Mar 2011 11:00:16 -0500
From: Manoj <manoj.iyer@canonical.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110223 Thunderbird/3.1.8
MIME-Version: 1.0
To: Chris Ball <cjb@laptop.org>
CC: linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: SDHCI: Ricoh [1180:e823] unable to mount MMC cards.
References: <4D93AD5C.1070308@canonical.com>	<m34o6k43c4.fsf@pullcord.laptop.org> <4D93BDA9.1020107@canonical.com>	<m3vcz02mi1.fsf@pullcord.laptop.org> <4D948BC4.6020904@canonical.com>	<m3sju3z6yc.fsf@pullcord.laptop.org> <4D949298.4000701@canonical.com> <m3oc4rz5kp.fsf@pullcord.laptop.org>
In-Reply-To: <m3oc4rz5kp.fsf@pullcord.laptop.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tried your patch, also enabled CONFIG_MMC_DEBUG=y 
CONFIG_MMC_RICOH_MMC=y, with the same result. MMC did not mount.

Here is a portion of dmesg:


[    1.176793] sdhci: Secure Digital Host Controller Interface driver
[    1.176795] sdhci: Copyright(c) Pierre Ossman
[    1.178043] sdhci-pci 0000:0d:00.0: SDHCI controller found 
[1180:e823] (rev 5)
[    1.178049] sdhci-pci 0000:0d:00.0: found 1 slot(s)
[    1.178071] sdhci-pci 0000:0d:00.0: PCI INT A -> GSI 16 (level, low) 
-> IRQ 16
[    1.178139] mmc0: Unknown controller version (2). You may experience 
problems.
[    1.178149] sdhci-pci 0000:0d:00.0: setting latency timer to 64
[    1.178163] sdhci: ============== REGISTER DUMP ==============
[    1.178169] sdhci: Sys addr: 0x00000000 | Version:  0x00000502
[    1.178174] sdhci: Blk size: 0x00000000 | Blk cnt:  0x00000000
[    1.178180] sdhci: Argument: 0x00000000 | Trn mode: 0x00000000
[    1.178186] sdhci: Present:  0x01f20000 | Host ctl: 0x00000000
[    1.178192] sdhci: Power:    0x00000000 | Blk gap:  0x00000000
[    1.178197] sdhci: Wake-up:  0x00000000 | Clock:    0x00000000
[    1.178203] sdhci: Timeout:  0x00000000 | Int stat: 0x00000000
[    1.178209] sdhci: Int enab: 0x00ff0003 | Sig enab: 0x00ff0003
[    1.178214] sdhci: AC12 err: 0x00000000 | Slot int: 0x00000000
[    1.178220] sdhci: Caps:     0x21e8c8b2 | Max curr: 0x00000040
[    1.178226] sdhci: ADMA Err: 0x00000000 | ADMA Ptr: 0x00000000
[    1.178227] sdhci: ===========================================
[    1.178250] Registered led device: mmc0::
[    1.178272] mmc0: clock 0Hz busmode 1 powermode 0 cs 0 Vdd 0 width 0 
timing 0
[    1.178331] mmc0: clock 0Hz busmode 1 powermode 1 cs 0 Vdd 21 width 0 
timing 0
[    1.178409] mmc0: SDHCI controller on PCI [0000:0d:00.0] using ADMA
[    1.186216] agpgart-intel 0000:00:00.0: Intel Sandybridge Chipset
[    1.187272] agpgart-intel 0000:00:00.0: detected 65532K stolen 
memory, trimming to 32768K
[    1.190407] e1000e: Intel(R) PRO/1000 Network Driver - 1.0.2-k4
[    1.190409] e1000e: Copyright (c) 1999 - 2009 Intel Corporation.
[    1.206059] mmc0: clock 400000Hz busmode 1 powermode 2 cs 0 Vdd 21 
width 0 timing 0
[    1.212187] agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xc0000000
[    1.212204] ahci 0000:00:1f.2: version 3.0
[    1.212221] ahci 0000:00:1f.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    1.212258]   alloc irq_desc for 44 on node -1
[    1.212260]   alloc kstat_irqs on node -1
[    1.212270] ahci 0000:00:1f.2: irq 44 for MSI/MSI-X
[    1.212309] ahci: SSS flag set, parallel bus scan disabled
[    1.219649] mmc0: starting CMD52 arg 00000c00 flags 00000195
[    1.221698] mmc0: req done (CMD52): -123: 00000000 00000000 00000000 
00000000
[    1.221704] mmc0: starting CMD52 arg 80000c08 flags 00000195
[    1.223714] mmc0: req done (CMD52): -123: 00000000 00000000 00000000 
00000000
[    1.223719] mmc0: clock 400000Hz busmode 1 powermode 2 cs 1 Vdd 21 
width 0 timing 0
[    1.224717] mmc0: starting CMD0 arg 00000000 flags 000000c0
[    1.226726] mmc0: req done (CMD0): -123: 00000000 00000000 00000000 
00000000
[    1.227723] mmc0: clock 400000Hz busmode 1 powermode 2 cs 0 Vdd 21 
width 0 timing 0
[    1.228720] mmc0: starting CMD8 arg 000001aa flags 000002f5
[    1.230724] mmc0: req done (CMD8): -123: 00000000 00000000 00000000 
00000000
[    1.230728] mmc0: starting CMD5 arg 00000000 flags 000002e1
[    1.230919] ahci 0000:00:1f.2: AHCI 0001.0300 32 slots 6 ports 6 Gbps 
0x1b impl SATA mode
[    1.230922] ahci 0000:00:1f.2: flags: 64bit ncq sntf ilck stag pm led 
clo pio slum part ems sxs apst
[    1.230927] ahci 0000:00:1f.2: setting latency timer to 64
[    1.232731] mmc0: req failed (CMD5): -123, retrying...
[    1.234730] mmc0: req failed (CMD5): -123, retrying...
[    1.236730] mmc0: req failed (CMD5): -123, retrying...
[    1.238731] mmc0: req done (CMD5): -123: 00000000 00000000 00000000 
00000000
[    1.238735] mmc0: starting CMD55 arg 00000000 flags 000000f5
[    1.240741] mmc0: req done (CMD55): -123: 00000000 00000000 00000000 
00000000
[    1.240746] mmc0: starting CMD55 arg 00000000 flags 000000f5
[    1.242754] mmc0: req done (CMD55): -123: 00000000 00000000 00000000 
00000000
[    1.242758] mmc0: starting CMD55 arg 00000000 flags 000000f5
[    1.242895] [drm] Initialized drm 1.1.0 20060810
[    1.244764] mmc0: req done (CMD55): -123: 00000000 00000000 00000000 
00000000
[    1.244768] mmc0: starting CMD55 arg 00000000 flags 000000f5
[    1.246774] mmc0: req done (CMD55): -123: 00000000 00000000 00000000 
00000000
[    1.246780] mmc0: starting CMD1 arg 00000000 flags 000000e1
[    1.248787] mmc0: req done (CMD1): -123: 00000000 00000000 00000000 
00000000
[    1.248792] mmc0: clock 0Hz busmode 1 powermode 0 cs 0 Vdd 0 width 0 
timing 0
[   27.508892] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000040
[   27.706286] mmc0: clock 0Hz busmode 1 powermode 1 cs 0 Vdd 21 width 0 
timing 0
[   27.722274] mmc0: clock 400000Hz busmode 1 powermode 2 cs 0 Vdd 21 
width 0 timing 0
[   27.738270] mmc0: starting CMD52 arg 00000c00 flags 00000195
[   27.738399] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[   27.740399] mmc0: req done (CMD52): -110: 00000000 00000000 00000000 
00000000
[   27.740407] mmc0: starting CMD52 arg 80000c08 flags 00000195
[   27.740485] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[   27.742492] mmc0: req done (CMD52): -110: 00000000 00000000 00000000 
00000000
[   27.742497] mmc0: clock 400000Hz busmode 1 powermode 2 cs 1 Vdd 21 
width 0 timing 0
[   27.743493] mmc0: starting CMD0 arg 00000000 flags 000000c0
[   27.743540] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000001
[   27.743546] mmc0: req done (CMD0): 0: 00000000 00000000 00000000 00000000
[   27.744543] mmc0: clock 400000Hz busmode 1 powermode 2 cs 0 Vdd 21 
width 0 timing 0
[   27.745539] mmc0: starting CMD8 arg 000001aa flags 000002f5
[   27.745580] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[   27.747584] mmc0: req done (CMD8): -110: 00000000 00000000 00000000 
00000000
[   27.747639] mmc0: starting CMD5 arg 00000000 flags 000002e1
[   27.747675] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[   27.749671] mmc0: req failed (CMD5): -110, retrying...
[   27.749708] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[   27.751710] mmc0: req failed (CMD5): -110, retrying...
[   27.751743] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[   27.753738] mmc0: req failed (CMD5): -110, retrying...
[   27.753771] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[   27.755771] mmc0: req done (CMD5): -110: 00000000 00000000 00000000 
00000000
[   27.755790] mmc0: starting CMD55 arg 00000000 flags 000000f5
[   27.755826] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[   27.757824] mmc0: req done (CMD55): -110: 00000000 00000000 00000000 
00000000
[   27.757828] mmc0: starting CMD55 arg 00000000 flags 000000f5
[   27.757863] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[   27.759863] mmc0: req done (CMD55): -110: 00000000 00000000 00000000 
00000000
[   27.759905] mmc0: starting CMD55 arg 00000000 flags 000000f5
[   27.759941] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[   27.761939] mmc0: req done (CMD55): -110: 00000000 00000000 00000000 
00000000
[   27.761942] mmc0: starting CMD55 arg 00000000 flags 000000f5
[   27.761981] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[   27.763985] mmc0: req done (CMD55): -110: 00000000 00000000 00000000 
00000000
[   27.764026] mmc0: starting CMD1 arg 00000000 flags 000000e1
[   27.764060] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000001
[   27.764067] mmc0: req done (CMD1): 0: 003f8000 00000000 00000000 00000000
[   27.764072] mmc0: clock 400000Hz busmode 1 powermode 2 cs 0 Vdd 20 
width 0 timing 0
[   27.764077] mmc0: clock 400000Hz busmode 1 powermode 2 cs 1 Vdd 20 
width 0 timing 0
[   27.765073] mmc0: starting CMD0 arg 00000000 flags 000000c0
[   27.765096] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000001
[   27.765100] mmc0: req done (CMD0): 0: 00000000 00000000 00000000 00000000
[   27.766094] mmc0: clock 400000Hz busmode 1 powermode 2 cs 0 Vdd 20 
width 0 timing 0
[   27.767090] mmc0: starting CMD1 arg 40300000 flags 000000e1
[   27.767129] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000001
[   27.767142] mmc0: req done (CMD1): 0: 003f8000 00000000 00000000 00000000
[   27.782251] mmc0: starting CMD1 arg 40300000 flags 000000e1
[   27.782309] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000001
[   27.782324] mmc0: req done (CMD1): 0: 003f8000 00000000 00000000 00000000
[   27.798246] mmc0: starting CMD1 arg 40300000 flags 000000e1
[   27.798320] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000001
[   27.798336] mmc0: req done (CMD1): 0: 003f8000 00000000 00000000 00000000
[   27.814242] mmc0: starting CMD1 arg 40300000 flags 000000e1
[   27.814314] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000001
[   27.814331] mmc0: req done (CMD1): 0: 003f8000 00000000 00000000 00000000
[   27.830232] mmc0: starting CMD1 arg 40300000 flags 000000e1
[   27.830288] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000001
[   27.830304] mmc0: req done (CMD1): 0: 003f8000 00000000 00000000 00000000
[   27.846231] mmc0: starting CMD1 arg 40300000 flags 000000e1
[   27.846285] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000001
[   27.846301] mmc0: req done (CMD1): 0: 003f8000 00000000 00000000 00000000
[   27.862226] mmc0: starting CMD1 arg 40300000 flags 000000e1
[   27.862299] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000001
[   27.862315] mmc0: req done (CMD1): 0: 003f8000 00000000 00000000 00000000
[   27.878217] mmc0: starting CMD1 arg 40300000 flags 000000e1
[   27.878273] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000001
[   27.878290] mmc0: req done (CMD1): 0: 803f8000 00000000 00000000 00000000
[   27.878303] mmc0: starting CMD2 arg 00000000 flags 00000067
[   27.878359] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00000001
[   27.878382] mmc0: req done (CMD2): 0: ffffffff ffffffff ffffffff ffffff00
[   27.878399] mmc0: starting CMD3 arg 00010000 flags 00000015
[   27.878438] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[   27.880442] mmc0: req failed (CMD3): -110, retrying...
[   27.880474] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[   27.882468] mmc0: req failed (CMD3): -110, retrying...
[   27.882501] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[   27.884498] mmc0: req failed (CMD3): -110, retrying...
[   27.884532] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[   27.886530] mmc0: req done (CMD3): -110: 00000000 00000000 00000000 
00000000
[   27.886537] mmc0: clock 0Hz busmode 1 powermode 0 cs 0 Vdd 0 width 0 
timing 0
[   27.886548] mmc0: error -110 whilst initialising MMC card
[   27.886550] mmc0: clock 0Hz busmode 1 powermode 0 cs 0 Vdd 0 width 0 
timing 0




Manoj Iyer
Ubuntu/Canonical
Hardware Enablement

On 03/31/2011 10:13 AM, Chris Ball wrote:
> Hi,
>
> On Thu, Mar 31 2011, Manoj wrote:
>>> How about setting CONFIG_MMC_RICOH_MMC?
>>
>> Yes Sir... that was already set.
>> CONFIG_MMC_RICOH_MMC=y
>
> Ah, I think MMC_RICOH_MMC needs to know about this new PCI ID too.
> I don't know whether that code knows how to turn off the MMC controller
> on this model, though.
>
> Please try this patch:
>
> diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
> index bd80f63..0852046 100644
> --- a/drivers/pci/quirks.c
> +++ b/drivers/pci/quirks.c
> @@ -2758,6 +2758,9 @@ static void ricoh_mmc_fixup_r5c832(struct pci_dev *dev)
>   }
>   DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_RICOH, PCI_DEVICE_ID_RICOH_R5C832, ricoh_mmc_fixup_r5c832);
>   DECLARE_PCI_FIXUP_RESUME_EARLY(PCI_VENDOR_ID_RICOH, PCI_DEVICE_ID_RICOH_R5C832, ricoh_mmc_fixup_r5c832);
> +
> +DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_RICOH, PCI_DEVICE_ID_RICOH_R5C823, ricoh_mmc_fixup_r5c832);
> +DECLARE_PCI_FIXUP_RESUME_EARLY(PCI_VENDOR_ID_RICOH, PCI_DEVICE_ID_RICOH_R5C823, ricoh_mmc_fixup_r5c832);
>   #endif /*CONFIG_MMC_RICOH_MMC*/
>
>   #if defined(CONFIG_DMAR) || defined(CONFIG_INTR_REMAP)
> diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
> index 11fd381..9ec3316 100644
> --- a/include/linux/pci_ids.h
> +++ b/include/linux/pci_ids.h
> @@ -1535,6 +1535,7 @@
>   #define PCI_DEVICE_ID_RICOH_RL5C476	0x0476
>   #define PCI_DEVICE_ID_RICOH_RL5C478	0x0478
>   #define PCI_DEVICE_ID_RICOH_R5C822	0x0822
> +#define PCI_DEVICE_ID_RICOH_R5C823	0x0823
>   #define PCI_DEVICE_ID_RICOH_R5C832	0x0832
>   #define PCI_DEVICE_ID_RICOH_R5C843	0x0843
>
>
> and post dmesg of the result, as well as whether it worked.
>
> We're trying the 0x832 disable method on an 0x823 controller, so I don't
> know whether that'll work.
>
> Thanks,
>
> - Chris.
