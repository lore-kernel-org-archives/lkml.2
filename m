Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932997Ab1IMWcu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Sep 2011 18:32:50 -0400
Received: from claw.goop.org ([74.207.240.146]:35880 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932958Ab1IMWct (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Sep 2011 18:32:49 -0400
Message-ID: <4E6FDA0B.9060007@goop.org>
Date: Tue, 13 Sep 2011 15:32:43 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0.2) Gecko/20110906 Thunderbird/6.0.2
MIME-Version: 1.0
To: Philip Rakity <prakity@marvell.com>
CC: Chris Ball <cjb@laptop.org>, linux-mmc@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Manoj Iyer <manoj.iyer@canonical.com>
Subject: Re: SDHCI regression since 2.6.39
References: <4E6EA3E4.5080401@goop.org> <m2bouo37by.fsf@bob.laptop.org> <4E6F8C24.3090207@goop.org> <m2wrdc1i5b.fsf@bob.laptop.org> <4E6FA44F.1050705@goop.org> <m2aaa89t1m.fsf@bob.laptop.org> <alpine.DEB.2.02.1109131419430.3556@lazy> <4E6FBCA1.6040307@goop.org> <D45CBF70-F0B1-453A-9E31-A621F52C21B9@marvell.com> <4E6FC422.9080306@goop.org> <7C3ED924-555D-4C50-9000-36077650328C@marvell.com> <4E6FCE28.5040403@goop.org> <F54ECF19-5E4C-40A6-8E26-99BF223F9FE2@marvell.com>
In-Reply-To: <F54ECF19-5E4C-40A6-8E26-99BF223F9FE2@marvell.com>
X-Enigmail-Version: 1.3.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ Re-added Cc:s ]

On 09/13/2011 02:48 PM, Philip Rakity wrote:
> cool -- rules out ALL sdhci 3.0 changes.
>
>
> next step 
>
> in sdhci.c -- look for -E  (case matters)
>
> will show where errors are detected.
>
> add
>
> 		sdhci_dumpregs(host);
>
> so we can see the registers when the error happens.

OK, I did that, and got this on modload:

[ 3069.546447] sdhci-pci 0000:0d:00.0: PCI INT A disabled
[ 3124.284534] sdhci: Secure Digital Host Controller Interface driver
[ 3124.284544] sdhci: Copyright(c) Pierre Ossman
[ 3124.285185] sdhci-pci 0000:0d:00.0: SDHCI controller found [1180:e823] (rev 4)
[ 3124.285433] sdhci-pci 0000:0d:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[ 3124.285679] sdhci-pci 0000:0d:00.0: setting latency timer to 64
[ 3124.285837] Registered led device: mmc0::
[ 3124.286048] mmc0: SDHCI controller on PCI [0000:0d:00.0] using DMA
[ 3124.307455] sdhci: =========== REGISTER DUMP (mmc0)===========
[ 3124.307479] sdhci: Sys addr: 0xfff44000 | Version:  0x00000502
[ 3124.307484] sdhci: Blk size: 0x00007200 | Blk cnt:  0x00000008
[ 3124.307489] sdhci: Argument: 0xb3680000 | Trn mode: 0x00000033
[ 3124.307494] sdhci: Present:  0x01f20000 | Host ctl: 0x00000005
[ 3124.307500] sdhci: Power:    0x0000000f | Blk gap:  0x00000000
[ 3124.307505] sdhci: Wake-up:  0x00000000 | Clock:    0x00002a07
[ 3124.307510] sdhci: Timeout:  0x00000009 | Int stat: 0x00000000
[ 3124.307514] sdhci: Int enab: 0x00ff0043 | Sig enab: 0x00ff0043
[ 3124.307519] sdhci: AC12 err: 0x00000000 | Slot int: 0x00000000
[ 3124.307525] sdhci: Caps:     0x21e8c8b2 | Caps_1:   0x00008073
[ 3124.307530] sdhci: Cmd:      0x00000d1a | Max curr: 0x00000040
[ 3124.307533] sdhci: Host ctl2: 0x00000000
[ 3124.307534] sdhci: ===========================================
[ 3124.307552] sdhci: =========== REGISTER DUMP (mmc0)===========
[ 3124.307557] sdhci: Sys addr: 0xfff44000 | Version:  0x00000502
[ 3124.307562] sdhci: Blk size: 0x00007200 | Blk cnt:  0x00000008
[ 3124.307567] sdhci: Argument: 0xb3680000 | Trn mode: 0x00000033
[ 3124.307572] sdhci: Present:  0x01f20000 | Host ctl: 0x00000005
[ 3124.307577] sdhci: Power:    0x0000000f | Blk gap:  0x00000000
[ 3124.307582] sdhci: Wake-up:  0x00000000 | Clock:    0x00002a07
[ 3124.307586] sdhci: Timeout:  0x00000009 | Int stat: 0x00000000
[ 3124.307591] sdhci: Int enab: 0x00ff0043 | Sig enab: 0x00ff0043
[ 3124.307596] sdhci: AC12 err: 0x00000000 | Slot int: 0x00000000
[ 3124.307601] sdhci: Caps:     0x21e8c8b2 | Caps_1:   0x00008073
[ 3124.307607] sdhci: Cmd:      0x00000d1a | Max curr: 0x00000040
[ 3124.307610] sdhci: Host ctl2: 0x00000000
[ 3124.307611] sdhci: ===========================================
[ 3124.309336] sdhci: =========== REGISTER DUMP (mmc0)===========
[ 3124.309342] sdhci: Sys addr: 0xfff44000 | Version:  0x00000502
[ 3124.309348] sdhci: Blk size: 0x00007200 | Blk cnt:  0x00000008
[ 3124.309353] sdhci: Argument: 0xb3680000 | Trn mode: 0x00000033
[ 3124.309358] sdhci: Present:  0x01f20000 | Host ctl: 0x00000005
[ 3124.309364] sdhci: Power:    0x0000000f | Blk gap:  0x00000000
[ 3124.309369] sdhci: Wake-up:  0x00000000 | Clock:    0x00002a07
[ 3124.309374] sdhci: Timeout:  0x00000009 | Int stat: 0x00000000
[ 3124.309379] sdhci: Int enab: 0x00ff0043 | Sig enab: 0x00ff0043
[ 3124.309384] sdhci: AC12 err: 0x00000000 | Slot int: 0x00000000
[ 3124.309388] sdhci: Caps:     0x21e8c8b2 | Caps_1:   0x00008073
[ 3124.309393] sdhci: Cmd:      0x00000d1a | Max curr: 0x00000040
[ 3124.309396] sdhci: Host ctl2: 0x00000000
[ 3124.309397] sdhci: ===========================================
[ 3124.313404] sdhci: =========== REGISTER DUMP (mmc0)===========
[ 3124.313418] sdhci: Sys addr: 0xfff44000 | Version:  0x00000502
[ 3124.313427] sdhci: Blk size: 0x00007200 | Blk cnt:  0x00000008
[ 3124.313436] sdhci: Argument: 0xb3680000 | Trn mode: 0x00000033
[ 3124.313444] sdhci: Present:  0x01f20000 | Host ctl: 0x00000005
[ 3124.313451] sdhci: Power:    0x0000000f | Blk gap:  0x00000000
[ 3124.313459] sdhci: Wake-up:  0x00000000 | Clock:    0x00002a07
[ 3124.313466] sdhci: Timeout:  0x00000009 | Int stat: 0x00000000
[ 3124.313474] sdhci: Int enab: 0x00ff0043 | Sig enab: 0x00ff0043
[ 3124.313481] sdhci: AC12 err: 0x00000000 | Slot int: 0x00000000
[ 3124.313489] sdhci: Caps:     0x21e8c8b2 | Caps_1:   0x00008073
[ 3124.313497] sdhci: Cmd:      0x00000d1a | Max curr: 0x00000040
[ 3124.313502] sdhci: Host ctl2: 0x00000000
[ 3124.313505] sdhci: ===========================================
[ 3124.313569] sdhci: =========== REGISTER DUMP (mmc0)===========
[ 3124.313578] sdhci: Sys addr: 0xfff44000 | Version:  0x00000502
[ 3124.313586] sdhci: Blk size: 0x00007200 | Blk cnt:  0x00000008
[ 3124.313593] sdhci: Argument: 0xb3680000 | Trn mode: 0x00000033
[ 3124.313600] sdhci: Present:  0x01f20000 | Host ctl: 0x00000005
[ 3124.313608] sdhci: Power:    0x0000000f | Blk gap:  0x00000000
[ 3124.313615] sdhci: Wake-up:  0x00000000 | Clock:    0x00002a07
[ 3124.313623] sdhci: Timeout:  0x00000009 | Int stat: 0x00000000
[ 3124.313630] sdhci: Int enab: 0x00ff0043 | Sig enab: 0x00ff0043
[ 3124.313637] sdhci: AC12 err: 0x00000000 | Slot int: 0x00000000
[ 3124.313645] sdhci: Caps:     0x21e8c8b2 | Caps_1:   0x00008073
[ 3124.313652] sdhci: Cmd:      0x00000d1a | Max curr: 0x00000040
[ 3124.313657] sdhci: Host ctl2: 0x00000000
[ 3124.313660] sdhci: ===========================================
[ 3124.313687] sdhci: =========== REGISTER DUMP (mmc0)===========
[ 3124.313692] sdhci: Sys addr: 0xfff44000 | Version:  0x00000502
[ 3124.313697] sdhci: Blk size: 0x00007200 | Blk cnt:  0x00000008
[ 3124.313702] sdhci: Argument: 0xb3680000 | Trn mode: 0x00000033
[ 3124.313707] sdhci: Present:  0x01f20000 | Host ctl: 0x00000005
[ 3124.313711] sdhci: Power:    0x0000000f | Blk gap:  0x00000000
[ 3124.313716] sdhci: Wake-up:  0x00000000 | Clock:    0x00002a07
[ 3124.313720] sdhci: Timeout:  0x00000009 | Int stat: 0x00000000
[ 3124.313725] sdhci: Int enab: 0x00ff0043 | Sig enab: 0x00ff0043
[ 3124.313730] sdhci: AC12 err: 0x00000000 | Slot int: 0x00000000
[ 3124.313735] sdhci: Caps:     0x21e8c8b2 | Caps_1:   0x00008073
[ 3124.313747] sdhci: Cmd:      0x00000d1a | Max curr: 0x00000040
[ 3124.313749] sdhci: Host ctl2: 0x00000000
[ 3124.313750] sdhci: ===========================================
[ 3124.313759] sdhci: =========== REGISTER DUMP (mmc0)===========
[ 3124.313763] sdhci: Sys addr: 0xfff44000 | Version:  0x00000502
[ 3124.313768] sdhci: Blk size: 0x00007200 | Blk cnt:  0x00000008
[ 3124.313773] sdhci: Argument: 0xb3680000 | Trn mode: 0x00000033
[ 3124.313778] sdhci: Present:  0x01f20000 | Host ctl: 0x00000005
[ 3124.313782] sdhci: Power:    0x0000000f | Blk gap:  0x00000000
[ 3124.313787] sdhci: Wake-up:  0x00000000 | Clock:    0x00002a07
[ 3124.313791] sdhci: Timeout:  0x00000009 | Int stat: 0x00000000
[ 3124.313796] sdhci: Int enab: 0x00ff0043 | Sig enab: 0x00ff0043
[ 3124.313801] sdhci: AC12 err: 0x00000000 | Slot int: 0x00000000
[ 3124.313805] sdhci: Caps:     0x21e8c8b2 | Caps_1:   0x00008073
[ 3124.313810] sdhci: Cmd:      0x00000d1a | Max curr: 0x00000040
[ 3124.313813] sdhci: Host ctl2: 0x00000000
[ 3124.313814] sdhci: ===========================================
[ 3124.313822] sdhci: =========== REGISTER DUMP (mmc0)===========
[ 3124.313826] sdhci: Sys addr: 0xfff44000 | Version:  0x00000502
[ 3124.313831] sdhci: Blk size: 0x00007200 | Blk cnt:  0x00000008
[ 3124.313836] sdhci: Argument: 0xb3680000 | Trn mode: 0x00000033
[ 3124.313841] sdhci: Present:  0x01f20000 | Host ctl: 0x00000005
[ 3124.313845] sdhci: Power:    0x0000000f | Blk gap:  0x00000000
[ 3124.313850] sdhci: Wake-up:  0x00000000 | Clock:    0x00002a07
[ 3124.313855] sdhci: Timeout:  0x00000009 | Int stat: 0x00000000
[ 3124.313859] sdhci: Int enab: 0x00ff0043 | Sig enab: 0x00ff0043
[ 3124.313864] sdhci: AC12 err: 0x00000000 | Slot int: 0x00000000
[ 3124.313869] sdhci: Caps:     0x21e8c8b2 | Caps_1:   0x00008073
[ 3124.313873] sdhci: Cmd:      0x00000d1a | Max curr: 0x00000040
[ 3124.313876] sdhci: Host ctl2: 0x00000000
[ 3124.313877] sdhci: ===========================================
[ 3124.319394] sdhci: =========== REGISTER DUMP (mmc0)===========
[ 3124.319408] sdhci: Sys addr: 0xfff44000 | Version:  0x00000502
[ 3124.319417] sdhci: Blk size: 0x00007200 | Blk cnt:  0x00000008
[ 3124.319426] sdhci: Argument: 0xb3680000 | Trn mode: 0x00000033
[ 3124.319434] sdhci: Present:  0x01f20000 | Host ctl: 0x00000005
[ 3124.319441] sdhci: Power:    0x0000000f | Blk gap:  0x00000000
[ 3124.319449] sdhci: Wake-up:  0x00000000 | Clock:    0x00002a07
[ 3124.319456] sdhci: Timeout:  0x00000009 | Int stat: 0x00000000
[ 3124.319464] sdhci: Int enab: 0x00ff0043 | Sig enab: 0x00ff0043
[ 3124.319471] sdhci: AC12 err: 0x00000000 | Slot int: 0x00000000
[ 3124.319479] sdhci: Caps:     0x21e8c8b2 | Caps_1:   0x00008073
[ 3124.319487] sdhci: Cmd:      0x00000d1a | Max curr: 0x00000040
[ 3124.319493] sdhci: Host ctl2: 0x00000000
[ 3124.319496] sdhci: ===========================================
[ 3124.319547] sdhci: =========== REGISTER DUMP (mmc0)===========
[ 3124.319561] sdhci: Sys addr: 0xfff44000 | Version:  0x00000502
[ 3124.319568] sdhci: Blk size: 0x00007200 | Blk cnt:  0x00000008
[ 3124.319576] sdhci: Argument: 0xb3680000 | Trn mode: 0x00000033
[ 3124.319584] sdhci: Present:  0x01f20000 | Host ctl: 0x00000005
[ 3124.319591] sdhci: Power:    0x0000000f | Blk gap:  0x00000000
[ 3124.319598] sdhci: Wake-up:  0x00000000 | Clock:    0x00002a07
[ 3124.319606] sdhci: Timeout:  0x00000009 | Int stat: 0x00000000
[ 3124.319613] sdhci: Int enab: 0x00ff0043 | Sig enab: 0x00ff0043
[ 3124.319621] sdhci: AC12 err: 0x00000000 | Slot int: 0x00000000
[ 3124.319629] sdhci: Caps:     0x21e8c8b2 | Caps_1:   0x00008073
[ 3124.319636] sdhci: Cmd:      0x00000d1a | Max curr: 0x00000040
[ 3124.319641] sdhci: Host ctl2: 0x00000000
[ 3124.319644] sdhci: ===========================================
[ 3124.319680] sdhci: =========== REGISTER DUMP (mmc0)===========
[ 3124.319690] sdhci: Sys addr: 0xfff44000 | Version:  0x00000502
[ 3124.319698] sdhci: Blk size: 0x00007200 | Blk cnt:  0x00000008
[ 3124.319706] sdhci: Argument: 0xb3680000 | Trn mode: 0x00000033
[ 3124.319713] sdhci: Present:  0x01f20000 | Host ctl: 0x00000005
[ 3124.319721] sdhci: Power:    0x0000000f | Blk gap:  0x00000000
[ 3124.319728] sdhci: Wake-up:  0x00000000 | Clock:    0x00002a07
[ 3124.319735] sdhci: Timeout:  0x00000009 | Int stat: 0x00000000
[ 3124.319742] sdhci: Int enab: 0x00ff0043 | Sig enab: 0x00ff0043
[ 3124.319750] sdhci: AC12 err: 0x00000000 | Slot int: 0x00000000
[ 3124.319757] sdhci: Caps:     0x21e8c8b2 | Caps_1:   0x00008073
[ 3124.319764] sdhci: Cmd:      0x00000d1a | Max curr: 0x00000040
[ 3124.319770] sdhci: Host ctl2: 0x00000000
[ 3124.319773] sdhci: ===========================================
[ 3124.319805] sdhci: =========== REGISTER DUMP (mmc0)===========
[ 3124.319813] sdhci: Sys addr: 0xfff44000 | Version:  0x00000502
[ 3124.319821] sdhci: Blk size: 0x00007200 | Blk cnt:  0x00000008
[ 3124.319828] sdhci: Argument: 0xb3680000 | Trn mode: 0x00000033
[ 3124.319836] sdhci: Present:  0x01f20000 | Host ctl: 0x00000005
[ 3124.319843] sdhci: Power:    0x0000000f | Blk gap:  0x00000000
[ 3124.319851] sdhci: Wake-up:  0x00000000 | Clock:    0x00002a07
[ 3124.319858] sdhci: Timeout:  0x00000009 | Int stat: 0x00000000
[ 3124.319866] sdhci: Int enab: 0x00ff0043 | Sig enab: 0x00ff0043
[ 3124.319873] sdhci: AC12 err: 0x00000000 | Slot int: 0x00000000
[ 3124.319880] sdhci: Caps:     0x21e8c8b2 | Caps_1:   0x00008073
[ 3124.319888] sdhci: Cmd:      0x00000d1a | Max curr: 0x00000040
[ 3124.319893] sdhci: Host ctl2: 0x00000000
[ 3124.319896] sdhci: ===========================================
[ 3124.319929] sdhci: =========== REGISTER DUMP (mmc0)===========
[ 3124.319937] sdhci: Sys addr: 0xfff44000 | Version:  0x00000502
[ 3124.319945] sdhci: Blk size: 0x00007200 | Blk cnt:  0x00000008
[ 3124.319952] sdhci: Argument: 0xb3680000 | Trn mode: 0x00000033
[ 3124.319960] sdhci: Present:  0x01f20000 | Host ctl: 0x00000005
[ 3124.319967] sdhci: Power:    0x0000000f | Blk gap:  0x00000000
[ 3124.319975] sdhci: Wake-up:  0x00000000 | Clock:    0x00002a07
[ 3124.319982] sdhci: Timeout:  0x00000009 | Int stat: 0x00000000
[ 3124.319989] sdhci: Int enab: 0x00ff0043 | Sig enab: 0x00ff0043
[ 3124.319996] sdhci: AC12 err: 0x00000000 | Slot int: 0x00000000
[ 3124.320004] sdhci: Caps:     0x21e8c8b2 | Caps_1:   0x00008073
[ 3124.320011] sdhci: Cmd:      0x00000d1a | Max curr: 0x00000040
[ 3124.320016] sdhci: Host ctl2: 0x00000000
[ 3124.320019] sdhci: ===========================================
[ 3124.341313] sdhci: =========== REGISTER DUMP (mmc0)===========
[ 3124.341327] sdhci: Sys addr: 0xfff44000 | Version:  0x00000502
[ 3124.341336] sdhci: Blk size: 0x00007200 | Blk cnt:  0x00000008
[ 3124.341344] sdhci: Argument: 0xb3680000 | Trn mode: 0x00000033
[ 3124.341352] sdhci: Present:  0x01f20000 | Host ctl: 0x00000005
[ 3124.341360] sdhci: Power:    0x0000000f | Blk gap:  0x00000000
[ 3124.341368] sdhci: Wake-up:  0x00000000 | Clock:    0x00003707
[ 3124.341375] sdhci: Timeout:  0x00000009 | Int stat: 0x00000000
[ 3124.341383] sdhci: Int enab: 0x00ff0043 | Sig enab: 0x00ff0043
[ 3124.341390] sdhci: AC12 err: 0x00000000 | Slot int: 0x00000000
[ 3124.341398] sdhci: Caps:     0x21e8c8b2 | Caps_1:   0x00008073
[ 3124.341406] sdhci: Cmd:      0x00000d1a | Max curr: 0x00000040
[ 3124.341411] sdhci: Host ctl2: 0x00000000
[ 3124.341414] sdhci: ===========================================
[ 3124.341474] sdhci: =========== REGISTER DUMP (mmc0)===========
[ 3124.341485] sdhci: Sys addr: 0xfff44000 | Version:  0x00000502
[ 3124.341493] sdhci: Blk size: 0x00007200 | Blk cnt:  0x00000008
[ 3124.341500] sdhci: Argument: 0xb3680000 | Trn mode: 0x00000033
[ 3124.341508] sdhci: Present:  0x01f20000 | Host ctl: 0x00000005
[ 3124.341515] sdhci: Power:    0x0000000f | Blk gap:  0x00000000
[ 3124.341523] sdhci: Wake-up:  0x00000000 | Clock:    0x00003707
[ 3124.341531] sdhci: Timeout:  0x00000009 | Int stat: 0x00000000
[ 3124.341538] sdhci: Int enab: 0x00ff0043 | Sig enab: 0x00ff0043
[ 3124.341545] sdhci: AC12 err: 0x00000000 | Slot int: 0x00000000
[ 3124.341553] sdhci: Caps:     0x21e8c8b2 | Caps_1:   0x00008073
[ 3124.341560] sdhci: Cmd:      0x00000d1a | Max curr: 0x00000040
[ 3124.341566] sdhci: Host ctl2: 0x00000000
[ 3124.341569] sdhci: ===========================================
[ 3124.343270] sdhci: =========== REGISTER DUMP (mmc0)===========
[ 3124.343280] sdhci: Sys addr: 0xfff44000 | Version:  0x00000502
[ 3124.343287] sdhci: Blk size: 0x00007200 | Blk cnt:  0x00000008
[ 3124.343295] sdhci: Argument: 0xb3680000 | Trn mode: 0x00000033
[ 3124.343302] sdhci: Present:  0x01f20000 | Host ctl: 0x00000005
[ 3124.343309] sdhci: Power:    0x0000000f | Blk gap:  0x00000000
[ 3124.343317] sdhci: Wake-up:  0x00000000 | Clock:    0x00003707
[ 3124.343324] sdhci: Timeout:  0x00000009 | Int stat: 0x00000000
[ 3124.343331] sdhci: Int enab: 0x00ff0043 | Sig enab: 0x00ff0043
[ 3124.343339] sdhci: AC12 err: 0x00000000 | Slot int: 0x00000000
[ 3124.343346] sdhci: Caps:     0x21e8c8b2 | Caps_1:   0x00008073
[ 3124.343354] sdhci: Cmd:      0x00000d1a | Max curr: 0x00000040
[ 3124.343359] sdhci: Host ctl2: 0x00000000
[ 3124.343362] sdhci: ===========================================
[ 3124.347308] sdhci: =========== REGISTER DUMP (mmc0)===========
[ 3124.347322] sdhci: Sys addr: 0xfff44000 | Version:  0x00000502
[ 3124.347330] sdhci: Blk size: 0x00007200 | Blk cnt:  0x00000008
[ 3124.347339] sdhci: Argument: 0xb3680000 | Trn mode: 0x00000033
[ 3124.347347] sdhci: Present:  0x01f20000 | Host ctl: 0x00000005
[ 3124.347354] sdhci: Power:    0x0000000f | Blk gap:  0x00000000
[ 3124.347362] sdhci: Wake-up:  0x00000000 | Clock:    0x00003707
[ 3124.347370] sdhci: Timeout:  0x00000009 | Int stat: 0x00000000
[ 3124.347377] sdhci: Int enab: 0x00ff0043 | Sig enab: 0x00ff0043
[ 3124.347385] sdhci: AC12 err: 0x00000000 | Slot int: 0x00000000
[ 3124.347393] sdhci: Caps:     0x21e8c8b2 | Caps_1:   0x00008073
[ 3124.347400] sdhci: Cmd:      0x00000d1a | Max curr: 0x00000040
[ 3124.347406] sdhci: Host ctl2: 0x00000000
[ 3124.347409] sdhci: ===========================================
[ 3124.347476] sdhci: =========== REGISTER DUMP (mmc0)===========
[ 3124.347485] sdhci: Sys addr: 0xfff44000 | Version:  0x00000502
[ 3124.347493] sdhci: Blk size: 0x00007200 | Blk cnt:  0x00000008
[ 3124.347500] sdhci: Argument: 0xb3680000 | Trn mode: 0x00000033
[ 3124.347508] sdhci: Present:  0x01f20000 | Host ctl: 0x00000005
[ 3124.347515] sdhci: Power:    0x0000000f | Blk gap:  0x00000000
[ 3124.347522] sdhci: Wake-up:  0x00000000 | Clock:    0x00003707
[ 3124.347530] sdhci: Timeout:  0x00000009 | Int stat: 0x00000000
[ 3124.347538] sdhci: Int enab: 0x00ff0043 | Sig enab: 0x00ff0043
[ 3124.347545] sdhci: AC12 err: 0x00000000 | Slot int: 0x00000000
[ 3124.347553] sdhci: Caps:     0x21e8c8b2 | Caps_1:   0x00008073
[ 3124.347560] sdhci: Cmd:      0x00000d1a | Max curr: 0x00000040
[ 3124.347566] sdhci: Host ctl2: 0x00000000
[ 3124.347569] sdhci: ===========================================
[ 3124.347590] sdhci: =========== REGISTER DUMP (mmc0)===========
[ 3124.347598] sdhci: Sys addr: 0xfff44000 | Version:  0x00000502
[ 3124.347606] sdhci: Blk size: 0x00007200 | Blk cnt:  0x00000008
[ 3124.347613] sdhci: Argument: 0xb3680000 | Trn mode: 0x00000033
[ 3124.347621] sdhci: Present:  0x01f20000 | Host ctl: 0x00000005
[ 3124.347630] sdhci: Power:    0x0000000f | Blk gap:  0x00000000
[ 3124.347637] sdhci: Wake-up:  0x00000000 | Clock:    0x00003707
[ 3124.347644] sdhci: Timeout:  0x00000009 | Int stat: 0x00000000
[ 3124.347652] sdhci: Int enab: 0x00ff0043 | Sig enab: 0x00ff0043
[ 3124.347659] sdhci: AC12 err: 0x00000000 | Slot int: 0x00000000
[ 3124.347667] sdhci: Caps:     0x21e8c8b2 | Caps_1:   0x00008073
[ 3124.347675] sdhci: Cmd:      0x00000d1a | Max curr: 0x00000040
[ 3124.347680] sdhci: Host ctl2: 0x00000000
[ 3124.347683] sdhci: ===========================================
[ 3124.347696] sdhci: =========== REGISTER DUMP (mmc0)===========
[ 3124.347704] sdhci: Sys addr: 0xfff44000 | Version:  0x00000502
[ 3124.347711] sdhci: Blk size: 0x00007200 | Blk cnt:  0x00000008
[ 3124.347718] sdhci: Argument: 0xb3680000 | Trn mode: 0x00000033
[ 3124.347725] sdhci: Present:  0x01f20000 | Host ctl: 0x00000005
[ 3124.347733] sdhci: Power:    0x0000000f | Blk gap:  0x00000000
[ 3124.347740] sdhci: Wake-up:  0x00000000 | Clock:    0x00003707
[ 3124.347748] sdhci: Timeout:  0x00000009 | Int stat: 0x00000000
[ 3124.347756] sdhci: Int enab: 0x00ff0043 | Sig enab: 0x00ff0043
[ 3124.347763] sdhci: AC12 err: 0x00000000 | Slot int: 0x00000000
[ 3124.347770] sdhci: Caps:     0x21e8c8b2 | Caps_1:   0x00008073
[ 3124.347778] sdhci: Cmd:      0x00000d1a | Max curr: 0x00000040
[ 3124.347783] sdhci: Host ctl2: 0x00000000
[ 3124.347786] sdhci: ===========================================
[ 3124.347799] sdhci: =========== REGISTER DUMP (mmc0)===========
[ 3124.347806] sdhci: Sys addr: 0xfff44000 | Version:  0x00000502
[ 3124.347813] sdhci: Blk size: 0x00007200 | Blk cnt:  0x00000008
[ 3124.347821] sdhci: Argument: 0xb3680000 | Trn mode: 0x00000033
[ 3124.347828] sdhci: Present:  0x01f20000 | Host ctl: 0x00000005
[ 3124.347835] sdhci: Power:    0x0000000f | Blk gap:  0x00000000
[ 3124.347842] sdhci: Wake-up:  0x00000000 | Clock:    0x00003707
[ 3124.347850] sdhci: Timeout:  0x00000009 | Int stat: 0x00000000
[ 3124.347858] sdhci: Int enab: 0x00ff0043 | Sig enab: 0x00ff0043
[ 3124.347865] sdhci: AC12 err: 0x00000000 | Slot int: 0x00000000
[ 3124.347872] sdhci: Caps:     0x21e8c8b2 | Caps_1:   0x00008073
[ 3124.347880] sdhci: Cmd:      0x00000d1a | Max curr: 0x00000040
[ 3124.347886] sdhci: Host ctl2: 0x00000000
[ 3124.347889] sdhci: ===========================================
[ 3124.353433] sdhci: =========== REGISTER DUMP (mmc0)===========
[ 3124.353443] sdhci: Sys addr: 0xfff44000 | Version:  0x00000502
[ 3124.353450] sdhci: Blk size: 0x00007200 | Blk cnt:  0x00000008
[ 3124.353458] sdhci: Argument: 0xb3680000 | Trn mode: 0x00000033
[ 3124.353465] sdhci: Present:  0x01f20000 | Host ctl: 0x00000005
[ 3124.353473] sdhci: Power:    0x0000000f | Blk gap:  0x00000000
[ 3124.353480] sdhci: Wake-up:  0x00000000 | Clock:    0x00003707
[ 3124.353487] sdhci: Timeout:  0x00000009 | Int stat: 0x00000000
[ 3124.353495] sdhci: Int enab: 0x00ff0043 | Sig enab: 0x00ff0043
[ 3124.353502] sdhci: AC12 err: 0x00000000 | Slot int: 0x00000000
[ 3124.353510] sdhci: Caps:     0x21e8c8b2 | Caps_1:   0x00008073
[ 3124.353518] sdhci: Cmd:      0x00000d1a | Max curr: 0x00000040
[ 3124.353523] sdhci: Host ctl2: 0x00000000
[ 3124.353526] sdhci: ===========================================
[ 3124.353624] sdhci: =========== REGISTER DUMP (mmc0)===========
[ 3124.353634] sdhci: Sys addr: 0xfff44000 | Version:  0x00000502
[ 3124.353642] sdhci: Blk size: 0x00007200 | Blk cnt:  0x00000008
[ 3124.353651] sdhci: Argument: 0xb3680000 | Trn mode: 0x00000033
[ 3124.353659] sdhci: Present:  0x01f20000 | Host ctl: 0x00000005
[ 3124.353668] sdhci: Power:    0x0000000f | Blk gap:  0x00000000
[ 3124.353676] sdhci: Wake-up:  0x00000000 | Clock:    0x00003707
[ 3124.353684] sdhci: Timeout:  0x00000009 | Int stat: 0x00000000
[ 3124.353693] sdhci: Int enab: 0x00ff0043 | Sig enab: 0x00ff0043
[ 3124.353703] sdhci: AC12 err: 0x00000000 | Slot int: 0x00000000
[ 3124.353711] sdhci: Caps:     0x21e8c8b2 | Caps_1:   0x00008073
[ 3124.353718] sdhci: Cmd:      0x00000d1a | Max curr: 0x00000040
[ 3124.353725] sdhci: Host ctl2: 0x00000000
[ 3124.353728] sdhci: ===========================================
[ 3124.353762] sdhci: =========== REGISTER DUMP (mmc0)===========
[ 3124.353773] sdhci: Sys addr: 0xfff44000 | Version:  0x00000502
[ 3124.353781] sdhci: Blk size: 0x00007200 | Blk cnt:  0x00000008
[ 3124.353789] sdhci: Argument: 0xb3680000 | Trn mode: 0x00000033
[ 3124.353798] sdhci: Present:  0x01f20000 | Host ctl: 0x00000005
[ 3124.353807] sdhci: Power:    0x0000000f | Blk gap:  0x00000000
[ 3124.353816] sdhci: Wake-up:  0x00000000 | Clock:    0x00003707
[ 3124.353824] sdhci: Timeout:  0x00000009 | Int stat: 0x00000000
[ 3124.353833] sdhci: Int enab: 0x00ff0043 | Sig enab: 0x00ff0043
[ 3124.353842] sdhci: AC12 err: 0x00000000 | Slot int: 0x00000000
[ 3124.353851] sdhci: Caps:     0x21e8c8b2 | Caps_1:   0x00008073
[ 3124.353860] sdhci: Cmd:      0x00000d1a | Max curr: 0x00000040
[ 3124.353867] sdhci: Host ctl2: 0x00000000
[ 3124.353871] sdhci: ===========================================
[ 3124.353903] sdhci: =========== REGISTER DUMP (mmc0)===========
[ 3124.353913] sdhci: Sys addr: 0xfff44000 | Version:  0x00000502
[ 3124.353921] sdhci: Blk size: 0x00007200 | Blk cnt:  0x00000008
[ 3124.353930] sdhci: Argument: 0xb3680000 | Trn mode: 0x00000033
[ 3124.353939] sdhci: Present:  0x01f20000 | Host ctl: 0x00000005
[ 3124.353947] sdhci: Power:    0x0000000f | Blk gap:  0x00000000
[ 3124.353956] sdhci: Wake-up:  0x00000000 | Clock:    0x00003707
[ 3124.353965] sdhci: Timeout:  0x00000009 | Int stat: 0x00000000
[ 3124.353974] sdhci: Int enab: 0x00ff0043 | Sig enab: 0x00ff0043
[ 3124.353983] sdhci: AC12 err: 0x00000000 | Slot int: 0x00000000
[ 3124.353993] sdhci: Caps:     0x21e8c8b2 | Caps_1:   0x00008073
[ 3124.354003] sdhci: Cmd:      0x00000d1a | Max curr: 0x00000040
[ 3124.354010] sdhci: Host ctl2: 0x00000000
[ 3124.354014] sdhci: ===========================================
[ 3124.354047] sdhci: =========== REGISTER DUMP (mmc0)===========
[ 3124.354057] sdhci: Sys addr: 0xfff44000 | Version:  0x00000502
[ 3124.354066] sdhci: Blk size: 0x00007200 | Blk cnt:  0x00000008
[ 3124.354075] sdhci: Argument: 0xb3680000 | Trn mode: 0x00000033
[ 3124.354083] sdhci: Present:  0x01f20000 | Host ctl: 0x00000005
[ 3124.354092] sdhci: Power:    0x0000000f | Blk gap:  0x00000000
[ 3124.354101] sdhci: Wake-up:  0x00000000 | Clock:    0x00003707
[ 3124.354110] sdhci: Timeout:  0x00000009 | Int stat: 0x00000000
[ 3124.354120] sdhci: Int enab: 0x00ff0043 | Sig enab: 0x00ff0043
[ 3124.354129] sdhci: AC12 err: 0x00000000 | Slot int: 0x00000000
[ 3124.354139] sdhci: Caps:     0x21e8c8b2 | Caps_1:   0x00008073
[ 3124.354147] sdhci: Cmd:      0x00000d1a | Max curr: 0x00000040
[ 3124.354154] sdhci: Host ctl2: 0x00000000
[ 3124.354157] sdhci: ===========================================
[ 3124.375276] sdhci: =========== REGISTER DUMP (mmc0)===========
[ 3124.375291] sdhci: Sys addr: 0xfff44000 | Version:  0x00000502
[ 3124.375300] sdhci: Blk size: 0x00007200 | Blk cnt:  0x00000008
[ 3124.375308] sdhci: Argument: 0xb3680000 | Trn mode: 0x00000033
[ 3124.375316] sdhci: Present:  0x01f20000 | Host ctl: 0x00000005
[ 3124.375324] sdhci: Power:    0x0000000f | Blk gap:  0x00000000
[ 3124.375332] sdhci: Wake-up:  0x00000000 | Clock:    0x00005307
[ 3124.375340] sdhci: Timeout:  0x00000009 | Int stat: 0x00000000
[ 3124.375348] sdhci: Int enab: 0x00ff0043 | Sig enab: 0x00ff0043
[ 3124.375355] sdhci: AC12 err: 0x00000000 | Slot int: 0x00000000
[ 3124.375363] sdhci: Caps:     0x21e8c8b2 | Caps_1:   0x00008073
[ 3124.375371] sdhci: Cmd:      0x00000d1a | Max curr: 0x00000040
[ 3124.375376] sdhci: Host ctl2: 0x00000000
[ 3124.375379] sdhci: ===========================================
[ 3124.375445] sdhci: =========== REGISTER DUMP (mmc0)===========
[ 3124.375457] sdhci: Sys addr: 0xfff44000 | Version:  0x00000502
[ 3124.375466] sdhci: Blk size: 0x00007200 | Blk cnt:  0x00000008
[ 3124.375474] sdhci: Argument: 0xb3680000 | Trn mode: 0x00000033
[ 3124.375481] sdhci: Present:  0x01f20000 | Host ctl: 0x00000005
[ 3124.375489] sdhci: Power:    0x0000000f | Blk gap:  0x00000000
[ 3124.375497] sdhci: Wake-up:  0x00000000 | Clock:    0x00005307
[ 3124.375504] sdhci: Timeout:  0x00000009 | Int stat: 0x00000000
[ 3124.375511] sdhci: Int enab: 0x00ff0043 | Sig enab: 0x00ff0043
[ 3124.375519] sdhci: AC12 err: 0x00000000 | Slot int: 0x00000000
[ 3124.375527] sdhci: Caps:     0x21e8c8b2 | Caps_1:   0x00008073
[ 3124.375534] sdhci: Cmd:      0x00000d1a | Max curr: 0x00000040
[ 3124.375540] sdhci: Host ctl2: 0x00000000
[ 3124.375543] sdhci: ===========================================
[ 3124.377193] sdhci: =========== REGISTER DUMP (mmc0)===========
[ 3124.377202] sdhci: Sys addr: 0xfff44000 | Version:  0x00000502
[ 3124.377210] sdhci: Blk size: 0x00007200 | Blk cnt:  0x00000008
[ 3124.377218] sdhci: Argument: 0xb3680000 | Trn mode: 0x00000033
[ 3124.377225] sdhci: Present:  0x01f20000 | Host ctl: 0x00000005
[ 3124.377233] sdhci: Power:    0x0000000f | Blk gap:  0x00000000
[ 3124.377240] sdhci: Wake-up:  0x00000000 | Clock:    0x00005307
[ 3124.377248] sdhci: Timeout:  0x00000009 | Int stat: 0x00000000
[ 3124.377255] sdhci: Int enab: 0x00ff0043 | Sig enab: 0x00ff0043
[ 3124.377262] sdhci: AC12 err: 0x00000000 | Slot int: 0x00000000
[ 3124.377270] sdhci: Caps:     0x21e8c8b2 | Caps_1:   0x00008073
[ 3124.377277] sdhci: Cmd:      0x00000d1a | Max curr: 0x00000040
[ 3124.377282] sdhci: Host ctl2: 0x00000000
[ 3124.377285] sdhci: ===========================================
[ 3124.381210] sdhci: =========== REGISTER DUMP (mmc0)===========
[ 3124.381225] sdhci: Sys addr: 0xfff44000 | Version:  0x00000502
[ 3124.381236] sdhci: Blk size: 0x00007200 | Blk cnt:  0x00000008
[ 3124.381246] sdhci: Argument: 0xb3680000 | Trn mode: 0x00000033
[ 3124.381256] sdhci: Present:  0x01f20000 | Host ctl: 0x00000005
[ 3124.381266] sdhci: Power:    0x0000000f | Blk gap:  0x00000000
[ 3124.381276] sdhci: Wake-up:  0x00000000 | Clock:    0x00005307
[ 3124.381283] sdhci: Timeout:  0x00000009 | Int stat: 0x00000000
[ 3124.381291] sdhci: Int enab: 0x00ff0043 | Sig enab: 0x00ff0043
[ 3124.381299] sdhci: AC12 err: 0x00000000 | Slot int: 0x00000000
[ 3124.381306] sdhci: Caps:     0x21e8c8b2 | Caps_1:   0x00008073
[ 3124.381314] sdhci: Cmd:      0x00000d1a | Max curr: 0x00000040
[ 3124.381319] sdhci: Host ctl2: 0x00000000
[ 3124.381322] sdhci: ===========================================
[ 3124.381366] sdhci: =========== REGISTER DUMP (mmc0)===========
[ 3124.381375] sdhci: Sys addr: 0xfff44000 | Version:  0x00000502
[ 3124.381383] sdhci: Blk size: 0x00007200 | Blk cnt:  0x00000008
[ 3124.381391] sdhci: Argument: 0xb3680000 | Trn mode: 0x00000033
[ 3124.381398] sdhci: Present:  0x01f20000 | Host ctl: 0x00000005
[ 3124.381406] sdhci: Power:    0x0000000f | Blk gap:  0x00000000
[ 3124.381414] sdhci: Wake-up:  0x00000000 | Clock:    0x00005307
[ 3124.381421] sdhci: Timeout:  0x00000009 | Int stat: 0x00000000
[ 3124.381429] sdhci: Int enab: 0x00ff0043 | Sig enab: 0x00ff0043
[ 3124.381437] sdhci: AC12 err: 0x00000000 | Slot int: 0x00000000
[ 3124.381444] sdhci: Caps:     0x21e8c8b2 | Caps_1:   0x00008073
[ 3124.381452] sdhci: Cmd:      0x00000d1a | Max curr: 0x00000040
[ 3124.381457] sdhci: Host ctl2: 0x00000000
[ 3124.381460] sdhci: ===========================================
[ 3124.381479] sdhci: =========== REGISTER DUMP (mmc0)===========
[ 3124.381487] sdhci: Sys addr: 0xfff44000 | Version:  0x00000502
[ 3124.381494] sdhci: Blk size: 0x00007200 | Blk cnt:  0x00000008
[ 3124.381502] sdhci: Argument: 0xb3680000 | Trn mode: 0x00000033
[ 3124.381509] sdhci: Present:  0x01f20000 | Host ctl: 0x00000005
[ 3124.381516] sdhci: Power:    0x0000000f | Blk gap:  0x00000000
[ 3124.381524] sdhci: Wake-up:  0x00000000 | Clock:    0x00005307
[ 3124.381532] sdhci: Timeout:  0x00000009 | Int stat: 0x00000000
[ 3124.381539] sdhci: Int enab: 0x00ff0043 | Sig enab: 0x00ff0043
[ 3124.381546] sdhci: AC12 err: 0x00000000 | Slot int: 0x00000000
[ 3124.381554] sdhci: Caps:     0x21e8c8b2 | Caps_1:   0x00008073
[ 3124.381562] sdhci: Cmd:      0x00000d1a | Max curr: 0x00000040
[ 3124.381567] sdhci: Host ctl2: 0x00000000
[ 3124.381569] sdhci: ===========================================
[ 3124.381583] sdhci: =========== REGISTER DUMP (mmc0)===========
[ 3124.381590] sdhci: Sys addr: 0xfff44000 | Version:  0x00000502
[ 3124.381597] sdhci: Blk size: 0x00007200 | Blk cnt:  0x00000008
[ 3124.381605] sdhci: Argument: 0xb3680000 | Trn mode: 0x00000033
[ 3124.381612] sdhci: Present:  0x01f20000 | Host ctl: 0x00000005
[ 3124.381620] sdhci: Power:    0x0000000f | Blk gap:  0x00000000
[ 3124.381627] sdhci: Wake-up:  0x00000000 | Clock:    0x00005307
[ 3124.381634] sdhci: Timeout:  0x00000009 | Int stat: 0x00000000
[ 3124.381641] sdhci: Int enab: 0x00ff0043 | Sig enab: 0x00ff0043
[ 3124.381649] sdhci: AC12 err: 0x00000000 | Slot int: 0x00000000
[ 3124.381657] sdhci: Caps:     0x21e8c8b2 | Caps_1:   0x00008073
[ 3124.381664] sdhci: Cmd:      0x00000d1a | Max curr: 0x00000040
[ 3124.381669] sdhci: Host ctl2: 0x00000000
[ 3124.381672] sdhci: ===========================================
[ 3124.381685] sdhci: =========== REGISTER DUMP (mmc0)===========
[ 3124.381693] sdhci: Sys addr: 0xfff44000 | Version:  0x00000502
[ 3124.381700] sdhci: Blk size: 0x00007200 | Blk cnt:  0x00000008
[ 3124.381708] sdhci: Argument: 0xb3680000 | Trn mode: 0x00000033
[ 3124.381715] sdhci: Present:  0x01f20000 | Host ctl: 0x00000005
[ 3124.381723] sdhci: Power:    0x0000000f | Blk gap:  0x00000000
[ 3124.381730] sdhci: Wake-up:  0x00000000 | Clock:    0x00005307
[ 3124.381737] sdhci: Timeout:  0x00000009 | Int stat: 0x00000000
[ 3124.381745] sdhci: Int enab: 0x00ff0043 | Sig enab: 0x00ff0043
[ 3124.381752] sdhci: AC12 err: 0x00000000 | Slot int: 0x00000000
[ 3124.381760] sdhci: Caps:     0x21e8c8b2 | Caps_1:   0x00008073
[ 3124.381767] sdhci: Cmd:      0x00000d1a | Max curr: 0x00000040
[ 3124.381772] sdhci: Host ctl2: 0x00000000
[ 3124.381775] sdhci: ===========================================
[ 3124.387394] sdhci: =========== REGISTER DUMP (mmc0)===========
[ 3124.387408] sdhci: Sys addr: 0xfff44000 | Version:  0x00000502
[ 3124.387416] sdhci: Blk size: 0x00007200 | Blk cnt:  0x00000008
[ 3124.387424] sdhci: Argument: 0xb3680000 | Trn mode: 0x00000033
[ 3124.387433] sdhci: Present:  0x01f20000 | Host ctl: 0x00000005
[ 3124.387440] sdhci: Power:    0x0000000f | Blk gap:  0x00000000
[ 3124.387448] sdhci: Wake-up:  0x00000000 | Clock:    0x00005307
[ 3124.387456] sdhci: Timeout:  0x00000009 | Int stat: 0x00000000
[ 3124.387463] sdhci: Int enab: 0x00ff0043 | Sig enab: 0x00ff0043
[ 3124.387471] sdhci: AC12 err: 0x00000000 | Slot int: 0x00000000
[ 3124.387478] sdhci: Caps:     0x21e8c8b2 | Caps_1:   0x00008073
[ 3124.387486] sdhci: Cmd:      0x00000d1a | Max curr: 0x00000040
[ 3124.387492] sdhci: Host ctl2: 0x00000000
[ 3124.387495] sdhci: ===========================================
[ 3124.387560] sdhci: =========== REGISTER DUMP (mmc0)===========
[ 3124.387569] sdhci: Sys addr: 0xfff44000 | Version:  0x00000502
[ 3124.387577] sdhci: Blk size: 0x00007200 | Blk cnt:  0x00000008
[ 3124.387585] sdhci: Argument: 0xb3680000 | Trn mode: 0x00000033
[ 3124.387592] sdhci: Present:  0x01f20000 | Host ctl: 0x00000005
[ 3124.387599] sdhci: Power:    0x0000000f | Blk gap:  0x00000000
[ 3124.387607] sdhci: Wake-up:  0x00000000 | Clock:    0x00005307
[ 3124.387614] sdhci: Timeout:  0x00000009 | Int stat: 0x00000000
[ 3124.387621] sdhci: Int enab: 0x00ff0043 | Sig enab: 0x00ff0043
[ 3124.387629] sdhci: AC12 err: 0x00000000 | Slot int: 0x00000000
[ 3124.387636] sdhci: Caps:     0x21e8c8b2 | Caps_1:   0x00008073
[ 3124.387644] sdhci: Cmd:      0x00000d1a | Max curr: 0x00000040
[ 3124.387650] sdhci: Host ctl2: 0x00000000
[ 3124.387652] sdhci: ===========================================
[ 3124.387689] sdhci: =========== REGISTER DUMP (mmc0)===========
[ 3124.387698] sdhci: Sys addr: 0xfff44000 | Version:  0x00000502
[ 3124.387706] sdhci: Blk size: 0x00007200 | Blk cnt:  0x00000008
[ 3124.387713] sdhci: Argument: 0xb3680000 | Trn mode: 0x00000033
[ 3124.387721] sdhci: Present:  0x01f20000 | Host ctl: 0x00000005
[ 3124.387728] sdhci: Power:    0x0000000f | Blk gap:  0x00000000
[ 3124.387735] sdhci: Wake-up:  0x00000000 | Clock:    0x00005307
[ 3124.387743] sdhci: Timeout:  0x00000009 | Int stat: 0x00000000
[ 3124.387750] sdhci: Int enab: 0x00ff0043 | Sig enab: 0x00ff0043
[ 3124.387757] sdhci: AC12 err: 0x00000000 | Slot int: 0x00000000
[ 3124.387764] sdhci: Caps:     0x21e8c8b2 | Caps_1:   0x00008073
[ 3124.387772] sdhci: Cmd:      0x00000d1a | Max curr: 0x00000040
[ 3124.387777] sdhci: Host ctl2: 0x00000000
[ 3124.387780] sdhci: ===========================================
[ 3124.387813] sdhci: =========== REGISTER DUMP (mmc0)===========
[ 3124.387821] sdhci: Sys addr: 0xfff44000 | Version:  0x00000502
[ 3124.387828] sdhci: Blk size: 0x00007200 | Blk cnt:  0x00000008
[ 3124.387835] sdhci: Argument: 0xb3680000 | Trn mode: 0x00000033
[ 3124.387843] sdhci: Present:  0x01f20000 | Host ctl: 0x00000005
[ 3124.387850] sdhci: Power:    0x0000000f | Blk gap:  0x00000000
[ 3124.387857] sdhci: Wake-up:  0x00000000 | Clock:    0x00005307
[ 3124.387864] sdhci: Timeout:  0x00000009 | Int stat: 0x00000000
[ 3124.387872] sdhci: Int enab: 0x00ff0043 | Sig enab: 0x00ff0043
[ 3124.387879] sdhci: AC12 err: 0x00000000 | Slot int: 0x00000000
[ 3124.387886] sdhci: Caps:     0x21e8c8b2 | Caps_1:   0x00008073
[ 3124.387894] sdhci: Cmd:      0x00000d1a | Max curr: 0x00000040
[ 3124.387899] sdhci: Host ctl2: 0x00000000
[ 3124.387903] sdhci: ===========================================
[ 3124.387936] sdhci: =========== REGISTER DUMP (mmc0)===========
[ 3124.387944] sdhci: Sys addr: 0xfff44000 | Version:  0x00000502
[ 3124.387952] sdhci: Blk size: 0x00007200 | Blk cnt:  0x00000008
[ 3124.387959] sdhci: Argument: 0xb3680000 | Trn mode: 0x00000033
[ 3124.387967] sdhci: Present:  0x01f20000 | Host ctl: 0x00000005
[ 3124.387974] sdhci: Power:    0x0000000f | Blk gap:  0x00000000
[ 3124.387981] sdhci: Wake-up:  0x00000000 | Clock:    0x00005307
[ 3124.387988] sdhci: Timeout:  0x00000009 | Int stat: 0x00000000
[ 3124.387996] sdhci: Int enab: 0x00ff0043 | Sig enab: 0x00ff0043
[ 3124.388003] sdhci: AC12 err: 0x00000000 | Slot int: 0x00000000
[ 3124.388010] sdhci: Caps:     0x21e8c8b2 | Caps_1:   0x00008073
[ 3124.388017] sdhci: Cmd:      0x00000d1a | Max curr: 0x00000040
[ 3124.388023] sdhci: Host ctl2: 0x00000000
[ 3124.388025] sdhci: ===========================================
[ 3124.409216] sdhci: =========== REGISTER DUMP (mmc0)===========
[ 3124.409230] sdhci: Sys addr: 0xfff44000 | Version:  0x00000502
[ 3124.409239] sdhci: Blk size: 0x00007200 | Blk cnt:  0x00000008
[ 3124.409247] sdhci: Argument: 0xb3680000 | Trn mode: 0x00000033
[ 3124.409255] sdhci: Present:  0x01f20000 | Host ctl: 0x00000005
[ 3124.409262] sdhci: Power:    0x0000000f | Blk gap:  0x00000000
[ 3124.409270] sdhci: Wake-up:  0x00000000 | Clock:    0x0000a507
[ 3124.409277] sdhci: Timeout:  0x00000009 | Int stat: 0x00000000
[ 3124.409285] sdhci: Int enab: 0x00ff0043 | Sig enab: 0x00ff0043
[ 3124.409292] sdhci: AC12 err: 0x00000000 | Slot int: 0x00000000
[ 3124.409300] sdhci: Caps:     0x21e8c8b2 | Caps_1:   0x00008073
[ 3124.409308] sdhci: Cmd:      0x00000d1a | Max curr: 0x00000040
[ 3124.409314] sdhci: Host ctl2: 0x00000000
[ 3124.409316] sdhci: ===========================================
[ 3124.409376] sdhci: =========== REGISTER DUMP (mmc0)===========
[ 3124.409385] sdhci: Sys addr: 0xfff44000 | Version:  0x00000502
[ 3124.409393] sdhci: Blk size: 0x00007200 | Blk cnt:  0x00000008
[ 3124.409400] sdhci: Argument: 0xb3680000 | Trn mode: 0x00000033
[ 3124.409407] sdhci: Present:  0x01f20000 | Host ctl: 0x00000005
[ 3124.409414] sdhci: Power:    0x0000000f | Blk gap:  0x00000000
[ 3124.409422] sdhci: Wake-up:  0x00000000 | Clock:    0x0000a507
[ 3124.409429] sdhci: Timeout:  0x00000009 | Int stat: 0x00000000
[ 3124.409437] sdhci: Int enab: 0x00ff0043 | Sig enab: 0x00ff0043
[ 3124.409444] sdhci: AC12 err: 0x00000000 | Slot int: 0x00000000
[ 3124.409451] sdhci: Caps:     0x21e8c8b2 | Caps_1:   0x00008073
[ 3124.409459] sdhci: Cmd:      0x00000d1a | Max curr: 0x00000040
[ 3124.409464] sdhci: Host ctl2: 0x00000000
[ 3124.409467] sdhci: ===========================================
[ 3124.411131] sdhci: =========== REGISTER DUMP (mmc0)===========
[ 3124.411141] sdhci: Sys addr: 0xfff44000 | Version:  0x00000502
[ 3124.411148] sdhci: Blk size: 0x00007200 | Blk cnt:  0x00000008
[ 3124.411155] sdhci: Argument: 0xb3680000 | Trn mode: 0x00000033
[ 3124.411163] sdhci: Present:  0x01f20000 | Host ctl: 0x00000005
[ 3124.411170] sdhci: Power:    0x0000000f | Blk gap:  0x00000000
[ 3124.411177] sdhci: Wake-up:  0x00000000 | Clock:    0x0000a507
[ 3124.411184] sdhci: Timeout:  0x00000009 | Int stat: 0x00000000
[ 3124.411192] sdhci: Int enab: 0x00ff0043 | Sig enab: 0x00ff0043
[ 3124.411200] sdhci: AC12 err: 0x00000000 | Slot int: 0x00000000
[ 3124.411207] sdhci: Caps:     0x21e8c8b2 | Caps_1:   0x00008073
[ 3124.411214] sdhci: Cmd:      0x00000d1a | Max curr: 0x00000040
[ 3124.411220] sdhci: Host ctl2: 0x00000000
[ 3124.411223] sdhci: ===========================================
[ 3124.415132] sdhci: =========== REGISTER DUMP (mmc0)===========
[ 3124.415146] sdhci: Sys addr: 0xfff44000 | Version:  0x00000502
[ 3124.415154] sdhci: Blk size: 0x00007200 | Blk cnt:  0x00000008
[ 3124.415162] sdhci: Argument: 0xb3680000 | Trn mode: 0x00000033
[ 3124.415170] sdhci: Present:  0x01f20000 | Host ctl: 0x00000005
[ 3124.415179] sdhci: Power:    0x0000000f | Blk gap:  0x00000000
[ 3124.415186] sdhci: Wake-up:  0x00000000 | Clock:    0x0000a507
[ 3124.415194] sdhci: Timeout:  0x00000009 | Int stat: 0x00000000
[ 3124.415202] sdhci: Int enab: 0x00ff0043 | Sig enab: 0x00ff0043
[ 3124.415210] sdhci: AC12 err: 0x00000000 | Slot int: 0x00000000
[ 3124.415217] sdhci: Caps:     0x21e8c8b2 | Caps_1:   0x00008073
[ 3124.415225] sdhci: Cmd:      0x00000d1a | Max curr: 0x00000040
[ 3124.415231] sdhci: Host ctl2: 0x00000000
[ 3124.415234] sdhci: ===========================================
[ 3124.415291] sdhci: =========== REGISTER DUMP (mmc0)===========
[ 3124.415301] sdhci: Sys addr: 0xfff44000 | Version:  0x00000502
[ 3124.415309] sdhci: Blk size: 0x00007200 | Blk cnt:  0x00000008
[ 3124.415316] sdhci: Argument: 0xb3680000 | Trn mode: 0x00000033
[ 3124.415323] sdhci: Present:  0x01f20000 | Host ctl: 0x00000005
[ 3124.415330] sdhci: Power:    0x0000000f | Blk gap:  0x00000000
[ 3124.415338] sdhci: Wake-up:  0x00000000 | Clock:    0x0000a507
[ 3124.415345] sdhci: Timeout:  0x00000009 | Int stat: 0x00000000
[ 3124.415353] sdhci: Int enab: 0x00ff0043 | Sig enab: 0x00ff0043
[ 3124.415361] sdhci: AC12 err: 0x00000000 | Slot int: 0x00000000
[ 3124.415368] sdhci: Caps:     0x21e8c8b2 | Caps_1:   0x00008073
[ 3124.415376] sdhci: Cmd:      0x00000d1a | Max curr: 0x00000040
[ 3124.415381] sdhci: Host ctl2: 0x00000000
[ 3124.415384] sdhci: ===========================================
[ 3124.415406] sdhci: =========== REGISTER DUMP (mmc0)===========
[ 3124.415414] sdhci: Sys addr: 0xfff44000 | Version:  0x00000502
[ 3124.415421] sdhci: Blk size: 0x00007200 | Blk cnt:  0x00000008
[ 3124.415428] sdhci: Argument: 0xb3680000 | Trn mode: 0x00000033
[ 3124.415436] sdhci: Present:  0x01f20000 | Host ctl: 0x00000005
[ 3124.415443] sdhci: Power:    0x0000000f | Blk gap:  0x00000000
[ 3124.415451] sdhci: Wake-up:  0x00000000 | Clock:    0x0000a507
[ 3124.415458] sdhci: Timeout:  0x00000009 | Int stat: 0x00000000
[ 3124.415465] sdhci: Int enab: 0x00ff0043 | Sig enab: 0x00ff0043
[ 3124.415473] sdhci: AC12 err: 0x00000000 | Slot int: 0x00000000
[ 3124.415481] sdhci: Caps:     0x21e8c8b2 | Caps_1:   0x00008073
[ 3124.415488] sdhci: Cmd:      0x00000d1a | Max curr: 0x00000040
[ 3124.415494] sdhci: Host ctl2: 0x00000000
[ 3124.415496] sdhci: ===========================================
[ 3124.415511] sdhci: =========== REGISTER DUMP (mmc0)===========
[ 3124.415519] sdhci: Sys addr: 0xfff44000 | Version:  0x00000502
[ 3124.415526] sdhci: Blk size: 0x00007200 | Blk cnt:  0x00000008
[ 3124.415534] sdhci: Argument: 0xb3680000 | Trn mode: 0x00000033
[ 3124.415542] sdhci: Present:  0x01f20000 | Host ctl: 0x00000005
[ 3124.415549] sdhci: Power:    0x0000000f | Blk gap:  0x00000000
[ 3124.415556] sdhci: Wake-up:  0x00000000 | Clock:    0x0000a507
[ 3124.415563] sdhci: Timeout:  0x00000009 | Int stat: 0x00000000
[ 3124.415571] sdhci: Int enab: 0x00ff0043 | Sig enab: 0x00ff0043
[ 3124.415578] sdhci: AC12 err: 0x00000000 | Slot int: 0x00000000
[ 3124.415586] sdhci: Caps:     0x21e8c8b2 | Caps_1:   0x00008073
[ 3124.415593] sdhci: Cmd:      0x00000d1a | Max curr: 0x00000040
[ 3124.415599] sdhci: Host ctl2: 0x00000000
[ 3124.415601] sdhci: ===========================================
[ 3124.415616] sdhci: =========== REGISTER DUMP (mmc0)===========
[ 3124.415624] sdhci: Sys addr: 0xfff44000 | Version:  0x00000502
[ 3124.415632] sdhci: Blk size: 0x00007200 | Blk cnt:  0x00000008
[ 3124.415639] sdhci: Argument: 0xb3680000 | Trn mode: 0x00000033
[ 3124.415646] sdhci: Present:  0x01f20000 | Host ctl: 0x00000005
[ 3124.415654] sdhci: Power:    0x0000000f | Blk gap:  0x00000000
[ 3124.415661] sdhci: Wake-up:  0x00000000 | Clock:    0x0000a507
[ 3124.415668] sdhci: Timeout:  0x00000009 | Int stat: 0x00000000
[ 3124.415676] sdhci: Int enab: 0x00ff0043 | Sig enab: 0x00ff0043
[ 3124.415683] sdhci: AC12 err: 0x00000000 | Slot int: 0x00000000
[ 3124.415691] sdhci: Caps:     0x21e8c8b2 | Caps_1:   0x00008073
[ 3124.415698] sdhci: Cmd:      0x00000d1a | Max curr: 0x00000040
[ 3124.415704] sdhci: Host ctl2: 0x00000000
[ 3124.415706] sdhci: ===========================================
[ 3124.421317] sdhci: =========== REGISTER DUMP (mmc0)===========
[ 3124.421331] sdhci: Sys addr: 0xfff44000 | Version:  0x00000502
[ 3124.421339] sdhci: Blk size: 0x00007200 | Blk cnt:  0x00000008
[ 3124.421347] sdhci: Argument: 0xb3680000 | Trn mode: 0x00000033
[ 3124.421355] sdhci: Present:  0x01f20000 | Host ctl: 0x00000005
[ 3124.421363] sdhci: Power:    0x0000000f | Blk gap:  0x00000000
[ 3124.421371] sdhci: Wake-up:  0x00000000 | Clock:    0x0000a507
[ 3124.421379] sdhci: Timeout:  0x00000009 | Int stat: 0x00000000
[ 3124.421386] sdhci: Int enab: 0x00ff0043 | Sig enab: 0x00ff0043
[ 3124.421393] sdhci: AC12 err: 0x00000000 | Slot int: 0x00000000
[ 3124.421402] sdhci: Caps:     0x21e8c8b2 | Caps_1:   0x00008073
[ 3124.421410] sdhci: Cmd:      0x00000d1a | Max curr: 0x00000040
[ 3124.421415] sdhci: Host ctl2: 0x00000000
[ 3124.421418] sdhci: ===========================================
[ 3124.421484] sdhci: =========== REGISTER DUMP (mmc0)===========
[ 3124.421494] sdhci: Sys addr: 0xfff44000 | Version:  0x00000502
[ 3124.421501] sdhci: Blk size: 0x00007200 | Blk cnt:  0x00000008
[ 3124.421509] sdhci: Argument: 0xb3680000 | Trn mode: 0x00000033
[ 3124.421516] sdhci: Present:  0x01f20000 | Host ctl: 0x00000005
[ 3124.421524] sdhci: Power:    0x0000000f | Blk gap:  0x00000000
[ 3124.421531] sdhci: Wake-up:  0x00000000 | Clock:    0x0000a507
[ 3124.421538] sdhci: Timeout:  0x00000009 | Int stat: 0x00000000
[ 3124.421546] sdhci: Int enab: 0x00ff0043 | Sig enab: 0x00ff0043
[ 3124.421553] sdhci: AC12 err: 0x00000000 | Slot int: 0x00000000
[ 3124.421561] sdhci: Caps:     0x21e8c8b2 | Caps_1:   0x00008073
[ 3124.421568] sdhci: Cmd:      0x00000d1a | Max curr: 0x00000040
[ 3124.421574] sdhci: Host ctl2: 0x00000000
[ 3124.421576] sdhci: ===========================================
[ 3124.421615] sdhci: =========== REGISTER DUMP (mmc0)===========
[ 3124.421624] sdhci: Sys addr: 0xfff44000 | Version:  0x00000502
[ 3124.421632] sdhci: Blk size: 0x00007200 | Blk cnt:  0x00000008
[ 3124.421640] sdhci: Argument: 0xb3680000 | Trn mode: 0x00000033
[ 3124.421647] sdhci: Present:  0x01f20000 | Host ctl: 0x00000005
[ 3124.421654] sdhci: Power:    0x0000000f | Blk gap:  0x00000000
[ 3124.421662] sdhci: Wake-up:  0x00000000 | Clock:    0x0000a507
[ 3124.421669] sdhci: Timeout:  0x00000009 | Int stat: 0x00000000
[ 3124.421677] sdhci: Int enab: 0x00ff0043 | Sig enab: 0x00ff0043
[ 3124.421684] sdhci: AC12 err: 0x00000000 | Slot int: 0x00000000
[ 3124.421691] sdhci: Caps:     0x21e8c8b2 | Caps_1:   0x00008073
[ 3124.421698] sdhci: Cmd:      0x00000d1a | Max curr: 0x00000040
[ 3124.421704] sdhci: Host ctl2: 0x00000000
[ 3124.421706] sdhci: ===========================================
[ 3124.421742] sdhci: =========== REGISTER DUMP (mmc0)===========
[ 3124.421749] sdhci: Sys addr: 0xfff44000 | Version:  0x00000502
[ 3124.421757] sdhci: Blk size: 0x00007200 | Blk cnt:  0x00000008
[ 3124.421764] sdhci: Argument: 0xb3680000 | Trn mode: 0x00000033
[ 3124.421772] sdhci: Present:  0x01f20000 | Host ctl: 0x00000005
[ 3124.421779] sdhci: Power:    0x0000000f | Blk gap:  0x00000000
[ 3124.421786] sdhci: Wake-up:  0x00000000 | Clock:    0x0000a507
[ 3124.421793] sdhci: Timeout:  0x00000009 | Int stat: 0x00000000
[ 3124.421801] sdhci: Int enab: 0x00ff0043 | Sig enab: 0x00ff0043
[ 3124.421808] sdhci: AC12 err: 0x00000000 | Slot int: 0x00000000
[ 3124.421815] sdhci: Caps:     0x21e8c8b2 | Caps_1:   0x00008073
[ 3124.421823] sdhci: Cmd:      0x00000d1a | Max curr: 0x00000040
[ 3124.421828] sdhci: Host ctl2: 0x00000000
[ 3124.421831] sdhci: ===========================================
[ 3124.421865] sdhci: =========== REGISTER DUMP (mmc0)===========
[ 3124.421873] sdhci: Sys addr: 0xfff44000 | Version:  0x00000502
[ 3124.421880] sdhci: Blk size: 0x00007200 | Blk cnt:  0x00000008
[ 3124.421887] sdhci: Argument: 0xb3680000 | Trn mode: 0x00000033
[ 3124.421895] sdhci: Present:  0x01f20000 | Host ctl: 0x00000005
[ 3124.421902] sdhci: Power:    0x0000000f | Blk gap:  0x00000000
[ 3124.421910] sdhci: Wake-up:  0x00000000 | Clock:    0x0000a507
[ 3124.421917] sdhci: Timeout:  0x00000009 | Int stat: 0x00000000
[ 3124.421924] sdhci: Int enab: 0x00ff0043 | Sig enab: 0x00ff0043
[ 3124.421931] sdhci: AC12 err: 0x00000000 | Slot int: 0x00000000
[ 3124.421939] sdhci: Caps:     0x21e8c8b2 | Caps_1:   0x00008073
[ 3124.421946] sdhci: Cmd:      0x00000d1a | Max curr: 0x00000040
[ 3124.421951] sdhci: Host ctl2: 0x00000000
[ 3124.421954] sdhci: ===========================================


>
> for example
>
> static void sdhci_cmd_irq(struct sdhci_host *host, u32 intmask)
> {
> 	BUG_ON(intmask == 0);
>
> 	if (!host->cmd) {
> 		printk(KERN_ERR "%s: Got command interrupt 0x%08x even "
> 			"though no command operation was in progress.\n",
> 			mmc_hostname(host->mmc), (unsigned)intmask);
> 		sdhci_dumpregs(host);
> 		return;
> 	}
>
> 	if (intmask & SDHCI_INT_TIMEOUT)
> 		host->cmd->error = -ETIMEDOUT;
> 	else if (intmask & (SDHCI_INT_CRC | SDHCI_INT_END_BIT |
> 			SDHCI_INT_INDEX))
> 		host->cmd->error = -EILSEQ;
>
> 	if (host->cmd->error) {
> #if 1
> 		sdhci_dumpregs(host);
> #endif
> 		tasklet_schedule(&host->finish_tasklet);
> 		return;
> 	}
>
> ====
> 		printk(KERN_ERR "%s: Got data interrupt 0x%08x even "
> 			"though no data operation was in progress.\n",
> 			mmc_hostname(host->mmc), (unsigned)intmask);
> 		sdhci_dumpregs(host);
>
> 		return;
> 	}
>
> 	if (intmask & SDHCI_INT_DATA_TIMEOUT)
> 		host->data->error = -ETIMEDOUT;
> 	else if (intmask & SDHCI_INT_DATA_END_BIT)
> 		host->data->error = -EILSEQ;
> 	else if ((intmask & SDHCI_INT_DATA_CRC) &&
> 		SDHCI_GET_CMD(sdhci_readw(host, SDHCI_COMMAND))
> 			!= MMC_BUS_TEST_R)
> 		host->data->error = -EILSEQ;
> 	else if (intmask & SDHCI_INT_ADMA_ERROR) {
> 		printk(KERN_ERR "%s: ADMA error\n", mmc_hostname(host->mmc));
> 		sdhci_show_adma_error(host);
> 		host->data->error = -EIO;
> 	}
>
> #if 1
> 	if (host->data->error)
> 		sdhci_dumpregs(host);
> #endif
>
> 	if (host->data->error)
> 		sdhci_finish_data(host);
>
>
>
> On Sep 13, 2011, at 2:42 PM, Jeremy Fitzhardinge wrote:
>
>> On 09/13/2011 02:06 PM, Philip Rakity wrote:
>>> On Sep 13, 2011, at 1:59 PM, Jeremy Fitzhardinge wrote:
>>>
>>>> On 09/13/2011 01:39 PM, Philip Rakity wrote:
>>>>> I noticed the version is sd 3.0.  As a HACK edit the sdhci.c code and RESET version to 2.0.
>>>> What change would I make to do this?  
>>> drivers/mmc/host/sdhci.c
>>>
>>> int sdhci_add_host(struct sdhci_host *host)
>>> {
>>> 	struct mmc_host *mmc;
>>> 	u32 caps[2];
>>> 	u32 max_current_caps;
>>> 	unsigned int ocr_avail;
>>> 	int ret;
>>>
>>> 	WARN_ON(host == NULL);
>>> 	if (host == NULL)
>>> 		return -EINVAL;
>>>
>>> 	mmc = host->mmc;
>>>
>>> 	if (debug_quirks)
>>> 		host->quirks = debug_quirks;
>>>
>>> 	sdhci_reset(host, SDHCI_RESET_ALL);
>>>
>>> 	host->version = sdhci_readw(host, SDHCI_HOST_VERSION);
>>> 	host->version = (host->version & SDHCI_SPEC_VER_MASK)
>>> 				>> SDHCI_SPEC_VER_SHIFT;
>>>
>>> #if 1
>>> #warning FORCE VERSION 2.0
>>> 	host->version = SDHCI_SPEC_200;
>>> #endif
>> This change made no difference; I still see errors on inserting the
>> 8GB/Class 10 PNY card.
>>
>>    J
>>

