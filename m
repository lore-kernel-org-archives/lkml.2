Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933022Ab1IMWmX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Sep 2011 18:42:23 -0400
Received: from claw.goop.org ([74.207.240.146]:35894 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933006Ab1IMWmM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Sep 2011 18:42:12 -0400
Message-ID: <4E6FDC3E.8030702@goop.org>
Date: Tue, 13 Sep 2011 15:42:06 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0.2) Gecko/20110906 Thunderbird/6.0.2
MIME-Version: 1.0
To: Philip Rakity <prakity@marvell.com>
CC: Chris Ball <cjb@laptop.org>, linux-mmc@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Manoj Iyer <manoj.iyer@canonical.com>
Subject: Re: SDHCI regression since 2.6.39
References: <4E6EA3E4.5080401@goop.org> <m2bouo37by.fsf@bob.laptop.org> <4E6F8C24.3090207@goop.org> <m2wrdc1i5b.fsf@bob.laptop.org> <4E6FA44F.1050705@goop.org> <m2aaa89t1m.fsf@bob.laptop.org> <alpine.DEB.2.02.1109131419430.3556@lazy> <4E6FBCA1.6040307@goop.org> <D45CBF70-F0B1-453A-9E31-A621F52C21B9@marvell.com> <4E6FC422.9080306@goop.org> <7C3ED924-555D-4C50-9000-36077650328C@marvell.com> <4E6FCE28.5040403@goop.org> <F54ECF19-5E4C-40A6-8E26-99BF223F9FE2@marvell.com> <4E6FDA0B.9060007@goop.org>
In-Reply-To: <4E6FDA0B.9060007@goop.org>
X-Enigmail-Version: 1.3.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/13/2011 03:32 PM, Jeremy Fitzhardinge wrote:
> [ Re-added Cc:s ]
>
> On 09/13/2011 02:48 PM, Philip Rakity wrote:
>> cool -- rules out ALL sdhci 3.0 changes.
>>
>>
>> next step 
>>
>> in sdhci.c -- look for -E  (case matters)
>>
>> will show where errors are detected.
>>
>> add
>>
>> 		sdhci_dumpregs(host);
>>
>> so we can see the registers when the error happens.
> OK, I did that, and got this on modload:

Here's that again with MMC_DEBUG=y

[ 3634.737941] sdhci: Secure Digital Host Controller Interface driver
[ 3634.737948] sdhci: Copyright(c) Pierre Ossman
[ 3634.738496] sdhci-pci 0000:0d:00.0: SDHCI controller found [1180:e823] (rev 4)
[ 3634.738557] sdhci-pci 0000:0d:00.0: found 1 slot(s)
[ 3634.738589] sdhci-pci 0000:0d:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[ 3634.738858] sdhci-pci 0000:0d:00.0: setting latency timer to 64
[ 3634.738867] sdhci [sdhci_add_host()]: mmc0: Auto-CMD23 unavailable
[ 3634.738929] sdhci: =========== REGISTER DUMP (mmc0)===========
[ 3634.738938] sdhci: Sys addr: 0xfff44000 | Version:  0x00000502
[ 3634.738946] sdhci: Blk size: 0x00007200 | Blk cnt:  0x00000008
[ 3634.738954] sdhci: Argument: 0xb3680000 | Trn mode: 0x00000033
[ 3634.738961] sdhci: Present:  0x01f20000 | Host ctl: 0x00000004
[ 3634.738969] sdhci: Power:    0x00000000 | Blk gap:  0x00000000
[ 3634.738977] sdhci: Wake-up:  0x00000000 | Clock:    0x0000a500
[ 3634.738984] sdhci: Timeout:  0x00000009 | Int stat: 0x00000000
[ 3634.738992] sdhci: Int enab: 0x00ff0003 | Sig enab: 0x00ff0003
[ 3634.739000] sdhci: AC12 err: 0x00000000 | Slot int: 0x00000000
[ 3634.739008] sdhci: Caps:     0x21e8c8b2 | Caps_1:   0x00008073
[ 3634.739016] sdhci: Cmd:      0x00000d1a | Max curr: 0x00000040
[ 3634.739021] sdhci: Host ctl2: 0x00000000
[ 3634.739024] sdhci: ===========================================
[ 3634.739083] Registered led device: mmc0::
[ 3634.739172] mmc0: clock 0Hz busmode 1 powermode 0 cs 0 Vdd 0 width 0 timing 0
[ 3634.739312] mmc0: SDHCI controller on PCI [0000:0d:00.0] using DMA
[ 3634.739439] mmc0: mmc_rescan_try_freq: trying to init card at 400000 Hz
[ 3634.739447] mmc0: clock 0Hz busmode 1 powermode 1 cs 0 Vdd 21 width 0 timing 0
[ 3634.750163] mmc0: clock 400000Hz busmode 1 powermode 2 cs 0 Vdd 21 width 0 timing 0
[ 3634.761145] mmc0: starting CMD52 arg 00000c00 flags 00000195
[ 3634.761202] sdhci: =========== REGISTER DUMP (mmc0)===========
[ 3634.761211] sdhci: Sys addr: 0xfff44000 | Version:  0x00000502
[ 3634.761219] sdhci: Blk size: 0x00007200 | Blk cnt:  0x00000008
[ 3634.761227] sdhci: Argument: 0xb3680000 | Trn mode: 0x00000033
[ 3634.761235] sdhci: Present:  0x01f20000 | Host ctl: 0x00000005
[ 3634.761243] sdhci: Power:    0x0000000f | Blk gap:  0x00000000
[ 3634.761250] sdhci: Wake-up:  0x00000000 | Clock:    0x00002a07
[ 3634.761257] sdhci: Timeout:  0x00000009 | Int stat: 0x00000000
[ 3634.761265] sdhci: Int enab: 0x00ff0043 | Sig enab: 0x00ff0043
[ 3634.761272] sdhci: AC12 err: 0x00000000 | Slot int: 0x00000000
[ 3634.761280] sdhci: Caps:     0x21e8c8b2 | Caps_1:   0x00008073
[ 3634.761287] sdhci: Cmd:      0x00000d1a | Max curr: 0x00000040
[ 3634.761292] sdhci: Host ctl2: 0x00000000
[ 3634.761295] sdhci: ===========================================
[ 3634.761324] mmc0: req done (CMD52): -123: 00000000 00000000 00000000 00000000
[ 3634.761348] mmc0: starting CMD52 arg 80000c08 flags 00000195
[ 3634.761359] sdhci: =========== REGISTER DUMP (mmc0)===========
[ 3634.761367] sdhci: Sys addr: 0xfff44000 | Version:  0x00000502
[ 3634.761374] sdhci: Blk size: 0x00007200 | Blk cnt:  0x00000008
[ 3634.761382] sdhci: Argument: 0xb3680000 | Trn mode: 0x00000033
[ 3634.761389] sdhci: Present:  0x01f20000 | Host ctl: 0x00000005
[ 3634.761397] sdhci: Power:    0x0000000f | Blk gap:  0x00000000
[ 3634.761404] sdhci: Wake-up:  0x00000000 | Clock:    0x00002a07
[ 3634.761411] sdhci: Timeout:  0x00000009 | Int stat: 0x00000000
[ 3634.761419] sdhci: Int enab: 0x00ff0043 | Sig enab: 0x00ff0043
[ 3634.761426] sdhci: AC12 err: 0x00000000 | Slot int: 0x00000000
[ 3634.761433] sdhci: Caps:     0x21e8c8b2 | Caps_1:   0x00008073
[ 3634.761441] sdhci: Cmd:      0x00000d1a | Max curr: 0x00000040
[ 3634.761446] sdhci: Host ctl2: 0x00000000
[ 3634.761449] sdhci: ===========================================
[ 3634.761470] mmc0: req done (CMD52): -123: 00000000 00000000 00000000 00000000
[ 3634.761489] mmc0: clock 400000Hz busmode 1 powermode 2 cs 1 Vdd 21 width 0 timing 0
[ 3634.763103] mmc0: starting CMD0 arg 00000000 flags 000000c0
[ 3634.763114] sdhci: =========== REGISTER DUMP (mmc0)===========
[ 3634.763123] sdhci: Sys addr: 0xfff44000 | Version:  0x00000502
[ 3634.763132] sdhci: Blk size: 0x00007200 | Blk cnt:  0x00000008
[ 3634.763140] sdhci: Argument: 0xb3680000 | Trn mode: 0x00000033
[ 3634.763148] sdhci: Present:  0x01f20000 | Host ctl: 0x00000005
[ 3634.763155] sdhci: Power:    0x0000000f | Blk gap:  0x00000000
[ 3634.763163] sdhci: Wake-up:  0x00000000 | Clock:    0x00002a07
[ 3634.763170] sdhci: Timeout:  0x00000009 | Int stat: 0x00000000
[ 3634.763178] sdhci: Int enab: 0x00ff0043 | Sig enab: 0x00ff0043
[ 3634.763185] sdhci: AC12 err: 0x00000000 | Slot int: 0x00000000
[ 3634.763193] sdhci: Caps:     0x21e8c8b2 | Caps_1:   0x00008073
[ 3634.763200] sdhci: Cmd:      0x00000d1a | Max curr: 0x00000040
[ 3634.763206] sdhci: Host ctl2: 0x00000000
[ 3634.763209] sdhci: ===========================================
[ 3634.763237] mmc0: req done (CMD0): -123: 00000000 00000000 00000000 00000000
[ 3634.765113] mmc0: clock 400000Hz busmode 1 powermode 2 cs 0 Vdd 21 width 0 timing 0
[ 3634.767090] mmc0: starting CMD8 arg 000001aa flags 000002f5
[ 3634.767098] sdhci: =========== REGISTER DUMP (mmc0)===========
[ 3634.767106] sdhci: Sys addr: 0xfff44000 | Version:  0x00000502
[ 3634.767113] sdhci: Blk size: 0x00007200 | Blk cnt:  0x00000008
[ 3634.767121] sdhci: Argument: 0xb3680000 | Trn mode: 0x00000033
[ 3634.767128] sdhci: Present:  0x01f20000 | Host ctl: 0x00000005
[ 3634.767136] sdhci: Power:    0x0000000f | Blk gap:  0x00000000
[ 3634.767143] sdhci: Wake-up:  0x00000000 | Clock:    0x00002a07
[ 3634.767150] sdhci: Timeout:  0x00000009 | Int stat: 0x00000000
[ 3634.767158] sdhci: Int enab: 0x00ff0043 | Sig enab: 0x00ff0043
[ 3634.767166] sdhci: AC12 err: 0x00000000 | Slot int: 0x00000000
[ 3634.767173] sdhci: Caps:     0x21e8c8b2 | Caps_1:   0x00008073
[ 3634.767181] sdhci: Cmd:      0x00000d1a | Max curr: 0x00000040
[ 3634.767186] sdhci: Host ctl2: 0x00000000
[ 3634.767189] sdhci: ===========================================
[ 3634.767209] mmc0: req done (CMD8): -123: 00000000 00000000 00000000 00000000
[ 3634.767229] mmc0: starting CMD5 arg 00000000 flags 000002e1
[ 3634.767237] sdhci: =========== REGISTER DUMP (mmc0)===========
[ 3634.767245] sdhci: Sys addr: 0xfff44000 | Version:  0x00000502
[ 3634.767252] sdhci: Blk size: 0x00007200 | Blk cnt:  0x00000008
[ 3634.767259] sdhci: Argument: 0xb3680000 | Trn mode: 0x00000033
[ 3634.767267] sdhci: Present:  0x01f20000 | Host ctl: 0x00000005
[ 3634.767274] sdhci: Power:    0x0000000f | Blk gap:  0x00000000
[ 3634.767281] sdhci: Wake-up:  0x00000000 | Clock:    0x00002a07
[ 3634.767288] sdhci: Timeout:  0x00000009 | Int stat: 0x00000000
[ 3634.767296] sdhci: Int enab: 0x00ff0043 | Sig enab: 0x00ff0043
[ 3634.767303] sdhci: AC12 err: 0x00000000 | Slot int: 0x00000000
[ 3634.767310] sdhci: Caps:     0x21e8c8b2 | Caps_1:   0x00008073
[ 3634.767318] sdhci: Cmd:      0x00000d1a | Max curr: 0x00000040
[ 3634.767324] sdhci: Host ctl2: 0x00000000
[ 3634.767327] sdhci: ===========================================
[ 3634.767342] mmc0: req failed (CMD5): -123, retrying...
[ 3634.767348] sdhci: =========== REGISTER DUMP (mmc0)===========
[ 3634.767355] sdhci: Sys addr: 0xfff44000 | Version:  0x00000502
[ 3634.767363] sdhci: Blk size: 0x00007200 | Blk cnt:  0x00000008
[ 3634.767370] sdhci: Argument: 0xb3680000 | Trn mode: 0x00000033
[ 3634.767377] sdhci: Present:  0x01f20000 | Host ctl: 0x00000005
[ 3634.767384] sdhci: Power:    0x0000000f | Blk gap:  0x00000000
[ 3634.767392] sdhci: Wake-up:  0x00000000 | Clock:    0x00002a07
[ 3634.767399] sdhci: Timeout:  0x00000009 | Int stat: 0x00000000
[ 3634.767406] sdhci: Int enab: 0x00ff0043 | Sig enab: 0x00ff0043
[ 3634.767413] sdhci: AC12 err: 0x00000000 | Slot int: 0x00000000
[ 3634.767421] sdhci: Caps:     0x21e8c8b2 | Caps_1:   0x00008073
[ 3634.767428] sdhci: Cmd:      0x00000d1a | Max curr: 0x00000040
[ 3634.767433] sdhci: Host ctl2: 0x00000000
[ 3634.767436] sdhci: ===========================================
[ 3634.767447] mmc0: req failed (CMD5): -123, retrying...
[ 3634.767453] sdhci: =========== REGISTER DUMP (mmc0)===========
[ 3634.767460] sdhci: Sys addr: 0xfff44000 | Version:  0x00000502
[ 3634.767468] sdhci: Blk size: 0x00007200 | Blk cnt:  0x00000008
[ 3634.767475] sdhci: Argument: 0xb3680000 | Trn mode: 0x00000033
[ 3634.767483] sdhci: Present:  0x01f20000 | Host ctl: 0x00000005
[ 3634.767490] sdhci: Power:    0x0000000f | Blk gap:  0x00000000
[ 3634.767497] sdhci: Wake-up:  0x00000000 | Clock:    0x00002a07
[ 3634.767505] sdhci: Timeout:  0x00000009 | Int stat: 0x00000000
[ 3634.767512] sdhci: Int enab: 0x00ff0043 | Sig enab: 0x00ff0043
[ 3634.767519] sdhci: AC12 err: 0x00000000 | Slot int: 0x00000000
[ 3634.767527] sdhci: Caps:     0x21e8c8b2 | Caps_1:   0x00008073
[ 3634.767534] sdhci: Cmd:      0x00000d1a | Max curr: 0x00000040
[ 3634.767539] sdhci: Host ctl2: 0x00000000
[ 3634.767542] sdhci: ===========================================
[ 3634.767553] mmc0: req failed (CMD5): -123, retrying...
[ 3634.767558] sdhci: =========== REGISTER DUMP (mmc0)===========
[ 3634.767566] sdhci: Sys addr: 0xfff44000 | Version:  0x00000502
[ 3634.767574] sdhci: Blk size: 0x00007200 | Blk cnt:  0x00000008
[ 3634.767581] sdhci: Argument: 0xb3680000 | Trn mode: 0x00000033
[ 3634.767589] sdhci: Present:  0x01f20000 | Host ctl: 0x00000005
[ 3634.767596] sdhci: Power:    0x0000000f | Blk gap:  0x00000000
[ 3634.767604] sdhci: Wake-up:  0x00000000 | Clock:    0x00002a07
[ 3634.767611] sdhci: Timeout:  0x00000009 | Int stat: 0x00000000
[ 3634.767618] sdhci: Int enab: 0x00ff0043 | Sig enab: 0x00ff0043
[ 3634.767625] sdhci: AC12 err: 0x00000000 | Slot int: 0x00000000
[ 3634.767633] sdhci: Caps:     0x21e8c8b2 | Caps_1:   0x00008073
[ 3634.767640] sdhci: Cmd:      0x00000d1a | Max curr: 0x00000040
[ 3634.767646] sdhci: Host ctl2: 0x00000000
[ 3634.767648] sdhci: ===========================================
[ 3634.767663] mmc0: req done (CMD5): -123: 00000000 00000000 00000000 00000000
[ 3634.773089] mmc0: starting CMD55 arg 00000000 flags 000000f5
[ 3634.773101] sdhci: =========== REGISTER DUMP (mmc0)===========
[ 3634.773111] sdhci: Sys addr: 0xfff44000 | Version:  0x00000502
[ 3634.773120] sdhci: Blk size: 0x00007200 | Blk cnt:  0x00000008
[ 3634.773130] sdhci: Argument: 0xb3680000 | Trn mode: 0x00000033
[ 3634.773139] sdhci: Present:  0x01f20000 | Host ctl: 0x00000005
[ 3634.773149] sdhci: Power:    0x0000000f | Blk gap:  0x00000000
[ 3634.773158] sdhci: Wake-up:  0x00000000 | Clock:    0x00002a07
[ 3634.773165] sdhci: Timeout:  0x00000009 | Int stat: 0x00000000
[ 3634.773173] sdhci: Int enab: 0x00ff0043 | Sig enab: 0x00ff0043
[ 3634.773181] sdhci: AC12 err: 0x00000000 | Slot int: 0x00000000
[ 3634.773189] sdhci: Caps:     0x21e8c8b2 | Caps_1:   0x00008073
[ 3634.773196] sdhci: Cmd:      0x00000d1a | Max curr: 0x00000040
[ 3634.773201] sdhci: Host ctl2: 0x00000000
[ 3634.773204] sdhci: ===========================================
[ 3634.773227] mmc0: req done (CMD55): -123: 00000000 00000000 00000000 00000000
[ 3634.773246] mmc0: starting CMD55 arg 00000000 flags 000000f5
[ 3634.773255] sdhci: =========== REGISTER DUMP (mmc0)===========
[ 3634.773263] sdhci: Sys addr: 0xfff44000 | Version:  0x00000502
[ 3634.773271] sdhci: Blk size: 0x00007200 | Blk cnt:  0x00000008
[ 3634.773278] sdhci: Argument: 0xb3680000 | Trn mode: 0x00000033
[ 3634.773285] sdhci: Present:  0x01f20000 | Host ctl: 0x00000005
[ 3634.773292] sdhci: Power:    0x0000000f | Blk gap:  0x00000000
[ 3634.773300] sdhci: Wake-up:  0x00000000 | Clock:    0x00002a07
[ 3634.773307] sdhci: Timeout:  0x00000009 | Int stat: 0x00000000
[ 3634.773314] sdhci: Int enab: 0x00ff0043 | Sig enab: 0x00ff0043
[ 3634.773322] sdhci: AC12 err: 0x00000000 | Slot int: 0x00000000
[ 3634.773329] sdhci: Caps:     0x21e8c8b2 | Caps_1:   0x00008073
[ 3634.773336] sdhci: Cmd:      0x00000d1a | Max curr: 0x00000040
[ 3634.773342] sdhci: Host ctl2: 0x00000000
[ 3634.773344] sdhci: ===========================================
[ 3634.773363] mmc0: req done (CMD55): -123: 00000000 00000000 00000000 00000000
[ 3634.773379] mmc0: starting CMD55 arg 00000000 flags 000000f5
[ 3634.773388] sdhci: =========== REGISTER DUMP (mmc0)===========
[ 3634.773396] sdhci: Sys addr: 0xfff44000 | Version:  0x00000502
[ 3634.773403] sdhci: Blk size: 0x00007200 | Blk cnt:  0x00000008
[ 3634.773411] sdhci: Argument: 0xb3680000 | Trn mode: 0x00000033
[ 3634.773418] sdhci: Present:  0x01f20000 | Host ctl: 0x00000005
[ 3634.773425] sdhci: Power:    0x0000000f | Blk gap:  0x00000000
[ 3634.773433] sdhci: Wake-up:  0x00000000 | Clock:    0x00002a07
[ 3634.773441] sdhci: Timeout:  0x00000009 | Int stat: 0x00000000
[ 3634.773448] sdhci: Int enab: 0x00ff0043 | Sig enab: 0x00ff0043
[ 3634.773456] sdhci: AC12 err: 0x00000000 | Slot int: 0x00000000
[ 3634.773463] sdhci: Caps:     0x21e8c8b2 | Caps_1:   0x00008073
[ 3634.773471] sdhci: Cmd:      0x00000d1a | Max curr: 0x00000040
[ 3634.773476] sdhci: Host ctl2: 0x00000000
[ 3634.773479] sdhci: ===========================================
[ 3634.773497] mmc0: req done (CMD55): -123: 00000000 00000000 00000000 00000000
[ 3634.773512] mmc0: starting CMD55 arg 00000000 flags 000000f5
[ 3634.773521] sdhci: =========== REGISTER DUMP (mmc0)===========
[ 3634.773528] sdhci: Sys addr: 0xfff44000 | Version:  0x00000502
[ 3634.773536] sdhci: Blk size: 0x00007200 | Blk cnt:  0x00000008
[ 3634.773543] sdhci: Argument: 0xb3680000 | Trn mode: 0x00000033
[ 3634.773551] sdhci: Present:  0x01f20000 | Host ctl: 0x00000005
[ 3634.773558] sdhci: Power:    0x0000000f | Blk gap:  0x00000000
[ 3634.773565] sdhci: Wake-up:  0x00000000 | Clock:    0x00002a07
[ 3634.773572] sdhci: Timeout:  0x00000009 | Int stat: 0x00000000
[ 3634.773580] sdhci: Int enab: 0x00ff0043 | Sig enab: 0x00ff0043
[ 3634.773587] sdhci: AC12 err: 0x00000000 | Slot int: 0x00000000
[ 3634.773595] sdhci: Caps:     0x21e8c8b2 | Caps_1:   0x00008073
[ 3634.773602] sdhci: Cmd:      0x00000d1a | Max curr: 0x00000040
[ 3634.773608] sdhci: Host ctl2: 0x00000000
[ 3634.773611] sdhci: ===========================================
[ 3634.773628] mmc0: req done (CMD55): -123: 00000000 00000000 00000000 00000000
[ 3634.773644] mmc0: starting CMD1 arg 00000000 flags 000000e1
[ 3634.773653] sdhci: =========== REGISTER DUMP (mmc0)===========
[ 3634.773661] sdhci: Sys addr: 0xfff44000 | Version:  0x00000502
[ 3634.773668] sdhci: Blk size: 0x00007200 | Blk cnt:  0x00000008
[ 3634.773675] sdhci: Argument: 0xb3680000 | Trn mode: 0x00000033
[ 3634.773683] sdhci: Present:  0x01f20000 | Host ctl: 0x00000005
[ 3634.773691] sdhci: Power:    0x0000000f | Blk gap:  0x00000000
[ 3634.773699] sdhci: Wake-up:  0x00000000 | Clock:    0x00002a07
[ 3634.773706] sdhci: Timeout:  0x00000009 | Int stat: 0x00000000
[ 3634.773714] sdhci: Int enab: 0x00ff0043 | Sig enab: 0x00ff0043
[ 3634.773721] sdhci: AC12 err: 0x00000000 | Slot int: 0x00000000
[ 3634.773728] sdhci: Caps:     0x21e8c8b2 | Caps_1:   0x00008073
[ 3634.773736] sdhci: Cmd:      0x00000d1a | Max curr: 0x00000040
[ 3634.773741] sdhci: Host ctl2: 0x00000000
[ 3634.773744] sdhci: ===========================================
[ 3634.773761] mmc0: req done (CMD1): -123: 00000000 00000000 00000000 00000000
[ 3634.773778] mmc0: clock 0Hz busmode 1 powermode 0 cs 0 Vdd 0 width 0 timing 0
[ 3634.773802] mmc0: mmc_rescan_try_freq: trying to init card at 300000 Hz
[ 3634.773808] mmc0: clock 0Hz busmode 1 powermode 1 cs 0 Vdd 21 width 0 timing 0
[ 3634.784133] mmc0: clock 300000Hz busmode 1 powermode 2 cs 0 Vdd 21 width 0 timing 0
[ 3634.795063] mmc0: starting CMD52 arg 00000c00 flags 00000195
[ 3634.795076] sdhci: =========== REGISTER DUMP (mmc0)===========
[ 3634.795085] sdhci: Sys addr: 0xfff44000 | Version:  0x00000502
[ 3634.795092] sdhci: Blk size: 0x00007200 | Blk cnt:  0x00000008
[ 3634.795101] sdhci: Argument: 0xb3680000 | Trn mode: 0x00000033
[ 3634.795109] sdhci: Present:  0x01f20000 | Host ctl: 0x00000005
[ 3634.795116] sdhci: Power:    0x0000000f | Blk gap:  0x00000000
[ 3634.795124] sdhci: Wake-up:  0x00000000 | Clock:    0x00003707
[ 3634.795131] sdhci: Timeout:  0x00000009 | Int stat: 0x00000000
[ 3634.795140] sdhci: Int enab: 0x00ff0043 | Sig enab: 0x00ff0043
[ 3634.795147] sdhci: AC12 err: 0x00000000 | Slot int: 0x00000000
[ 3634.795155] sdhci: Caps:     0x21e8c8b2 | Caps_1:   0x00008073
[ 3634.795163] sdhci: Cmd:      0x00000d1a | Max curr: 0x00000040
[ 3634.795169] sdhci: Host ctl2: 0x00000000
[ 3634.795172] sdhci: ===========================================
[ 3634.795210] mmc0: req done (CMD52): -123: 00000000 00000000 00000000 00000000
[ 3634.795243] mmc0: starting CMD52 arg 80000c08 flags 00000195
[ 3634.795254] sdhci: =========== REGISTER DUMP (mmc0)===========
[ 3634.795262] sdhci: Sys addr: 0xfff44000 | Version:  0x00000502
[ 3634.795269] sdhci: Blk size: 0x00007200 | Blk cnt:  0x00000008
[ 3634.795277] sdhci: Argument: 0xb3680000 | Trn mode: 0x00000033
[ 3634.795284] sdhci: Present:  0x01f20000 | Host ctl: 0x00000005
[ 3634.795291] sdhci: Power:    0x0000000f | Blk gap:  0x00000000
[ 3634.795298] sdhci: Wake-up:  0x00000000 | Clock:    0x00003707
[ 3634.795306] sdhci: Timeout:  0x00000009 | Int stat: 0x00000000
[ 3634.795313] sdhci: Int enab: 0x00ff0043 | Sig enab: 0x00ff0043
[ 3634.795320] sdhci: AC12 err: 0x00000000 | Slot int: 0x00000000
[ 3634.795328] sdhci: Caps:     0x21e8c8b2 | Caps_1:   0x00008073
[ 3634.795335] sdhci: Cmd:      0x00000d1a | Max curr: 0x00000040
[ 3634.795341] sdhci: Host ctl2: 0x00000000
[ 3634.795344] sdhci: ===========================================
[ 3634.795366] mmc0: req done (CMD52): -123: 00000000 00000000 00000000 00000000
[ 3634.795386] mmc0: clock 300000Hz busmode 1 powermode 2 cs 1 Vdd 21 width 0 timing 0
[ 3634.797041] mmc0: starting CMD0 arg 00000000 flags 000000c0
[ 3634.797056] sdhci: =========== REGISTER DUMP (mmc0)===========
[ 3634.797065] sdhci: Sys addr: 0xfff44000 | Version:  0x00000502
[ 3634.797073] sdhci: Blk size: 0x00007200 | Blk cnt:  0x00000008
[ 3634.797081] sdhci: Argument: 0xb3680000 | Trn mode: 0x00000033
[ 3634.797088] sdhci: Present:  0x01f20000 | Host ctl: 0x00000005
[ 3634.797096] sdhci: Power:    0x0000000f | Blk gap:  0x00000000
[ 3634.797104] sdhci: Wake-up:  0x00000000 | Clock:    0x00003707
[ 3634.797111] sdhci: Timeout:  0x00000009 | Int stat: 0x00000000
[ 3634.797120] sdhci: Int enab: 0x00ff0043 | Sig enab: 0x00ff0043
[ 3634.797127] sdhci: AC12 err: 0x00000000 | Slot int: 0x00000000
[ 3634.797135] sdhci: Caps:     0x21e8c8b2 | Caps_1:   0x00008073
[ 3634.797143] sdhci: Cmd:      0x00000d1a | Max curr: 0x00000040
[ 3634.797148] sdhci: Host ctl2: 0x00000000
[ 3634.797151] sdhci: ===========================================
[ 3634.797176] mmc0: req done (CMD0): -123: 00000000 00000000 00000000 00000000
[ 3634.799026] mmc0: clock 300000Hz busmode 1 powermode 2 cs 0 Vdd 21 width 0 timing 0
[ 3634.801023] mmc0: starting CMD8 arg 000001aa flags 000002f5
[ 3634.801034] sdhci: =========== REGISTER DUMP (mmc0)===========
[ 3634.801041] sdhci: Sys addr: 0xfff44000 | Version:  0x00000502
[ 3634.801049] sdhci: Blk size: 0x00007200 | Blk cnt:  0x00000008
[ 3634.801067] sdhci: Argument: 0xb3680000 | Trn mode: 0x00000033
[ 3634.801074] sdhci: Present:  0x01f20000 | Host ctl: 0x00000005
[ 3634.801082] sdhci: Power:    0x0000000f | Blk gap:  0x00000000
[ 3634.801090] sdhci: Wake-up:  0x00000000 | Clock:    0x00003707
[ 3634.801097] sdhci: Timeout:  0x00000009 | Int stat: 0x00000000
[ 3634.801104] sdhci: Int enab: 0x00ff0043 | Sig enab: 0x00ff0043
[ 3634.801112] sdhci: AC12 err: 0x00000000 | Slot int: 0x00000000
[ 3634.801119] sdhci: Caps:     0x21e8c8b2 | Caps_1:   0x00008073
[ 3634.801126] sdhci: Cmd:      0x00000d1a | Max curr: 0x00000040
[ 3634.801132] sdhci: Host ctl2: 0x00000000
[ 3634.801135] sdhci: ===========================================
[ 3634.801160] mmc0: req done (CMD8): -123: 00000000 00000000 00000000 00000000
[ 3634.801185] mmc0: starting CMD5 arg 00000000 flags 000002e1
[ 3634.801194] sdhci: =========== REGISTER DUMP (mmc0)===========
[ 3634.801202] sdhci: Sys addr: 0xfff44000 | Version:  0x00000502
[ 3634.801209] sdhci: Blk size: 0x00007200 | Blk cnt:  0x00000008
[ 3634.801217] sdhci: Argument: 0xb3680000 | Trn mode: 0x00000033
[ 3634.801224] sdhci: Present:  0x01f20000 | Host ctl: 0x00000005
[ 3634.801232] sdhci: Power:    0x0000000f | Blk gap:  0x00000000
[ 3634.801239] sdhci: Wake-up:  0x00000000 | Clock:    0x00003707
[ 3634.801247] sdhci: Timeout:  0x00000009 | Int stat: 0x00000000
[ 3634.801254] sdhci: Int enab: 0x00ff0043 | Sig enab: 0x00ff0043
[ 3634.801261] sdhci: AC12 err: 0x00000000 | Slot int: 0x00000000
[ 3634.801269] sdhci: Caps:     0x21e8c8b2 | Caps_1:   0x00008073
[ 3634.801276] sdhci: Cmd:      0x00000d1a | Max curr: 0x00000040
[ 3634.801282] sdhci: Host ctl2: 0x00000000
[ 3634.801285] sdhci: ===========================================
[ 3634.801302] mmc0: req failed (CMD5): -123, retrying...
[ 3634.801308] sdhci: =========== REGISTER DUMP (mmc0)===========
[ 3634.801315] sdhci: Sys addr: 0xfff44000 | Version:  0x00000502
[ 3634.801323] sdhci: Blk size: 0x00007200 | Blk cnt:  0x00000008
[ 3634.801330] sdhci: Argument: 0xb3680000 | Trn mode: 0x00000033
[ 3634.801338] sdhci: Present:  0x01f20000 | Host ctl: 0x00000005
[ 3634.801345] sdhci: Power:    0x0000000f | Blk gap:  0x00000000
[ 3634.801352] sdhci: Wake-up:  0x00000000 | Clock:    0x00003707
[ 3634.801359] sdhci: Timeout:  0x00000009 | Int stat: 0x00000000
[ 3634.801367] sdhci: Int enab: 0x00ff0043 | Sig enab: 0x00ff0043
[ 3634.801374] sdhci: AC12 err: 0x00000000 | Slot int: 0x00000000
[ 3634.801382] sdhci: Caps:     0x21e8c8b2 | Caps_1:   0x00008073
[ 3634.801389] sdhci: Cmd:      0x00000d1a | Max curr: 0x00000040
[ 3634.801394] sdhci: Host ctl2: 0x00000000
[ 3634.801397] sdhci: ===========================================
[ 3634.801409] mmc0: req failed (CMD5): -123, retrying...
[ 3634.801414] sdhci: =========== REGISTER DUMP (mmc0)===========
[ 3634.801422] sdhci: Sys addr: 0xfff44000 | Version:  0x00000502
[ 3634.801429] sdhci: Blk size: 0x00007200 | Blk cnt:  0x00000008
[ 3634.801437] sdhci: Argument: 0xb3680000 | Trn mode: 0x00000033
[ 3634.801444] sdhci: Present:  0x01f20000 | Host ctl: 0x00000005
[ 3634.801452] sdhci: Power:    0x0000000f | Blk gap:  0x00000000
[ 3634.801459] sdhci: Wake-up:  0x00000000 | Clock:    0x00003707
[ 3634.801466] sdhci: Timeout:  0x00000009 | Int stat: 0x00000000
[ 3634.801474] sdhci: Int enab: 0x00ff0043 | Sig enab: 0x00ff0043
[ 3634.801482] sdhci: AC12 err: 0x00000000 | Slot int: 0x00000000
[ 3634.801489] sdhci: Caps:     0x21e8c8b2 | Caps_1:   0x00008073
[ 3634.801497] sdhci: Cmd:      0x00000d1a | Max curr: 0x00000040
[ 3634.801503] sdhci: Host ctl2: 0x00000000
[ 3634.801505] sdhci: ===========================================
[ 3634.801516] mmc0: req failed (CMD5): -123, retrying...
[ 3634.801522] sdhci: =========== REGISTER DUMP (mmc0)===========
[ 3634.801530] sdhci: Sys addr: 0xfff44000 | Version:  0x00000502
[ 3634.801538] sdhci: Blk size: 0x00007200 | Blk cnt:  0x00000008
[ 3634.801545] sdhci: Argument: 0xb3680000 | Trn mode: 0x00000033
[ 3634.801553] sdhci: Present:  0x01f20000 | Host ctl: 0x00000005
[ 3634.801560] sdhci: Power:    0x0000000f | Blk gap:  0x00000000
[ 3634.801567] sdhci: Wake-up:  0x00000000 | Clock:    0x00003707
[ 3634.801574] sdhci: Timeout:  0x00000009 | Int stat: 0x00000000
[ 3634.801582] sdhci: Int enab: 0x00ff0043 | Sig enab: 0x00ff0043
[ 3634.801589] sdhci: AC12 err: 0x00000000 | Slot int: 0x00000000
[ 3634.801597] sdhci: Caps:     0x21e8c8b2 | Caps_1:   0x00008073
[ 3634.801604] sdhci: Cmd:      0x00000d1a | Max curr: 0x00000040
[ 3634.801609] sdhci: Host ctl2: 0x00000000
[ 3634.801612] sdhci: ===========================================
[ 3634.801626] mmc0: req done (CMD5): -123: 00000000 00000000 00000000 00000000
[ 3634.807223] mmc0: starting CMD55 arg 00000000 flags 000000f5
[ 3634.807237] sdhci: =========== REGISTER DUMP (mmc0)===========
[ 3634.807245] sdhci: Sys addr: 0xfff44000 | Version:  0x00000502
[ 3634.807253] sdhci: Blk size: 0x00007200 | Blk cnt:  0x00000008
[ 3634.807261] sdhci: Argument: 0xb3680000 | Trn mode: 0x00000033
[ 3634.807269] sdhci: Present:  0x01f20000 | Host ctl: 0x00000005
[ 3634.807277] sdhci: Power:    0x0000000f | Blk gap:  0x00000000
[ 3634.807285] sdhci: Wake-up:  0x00000000 | Clock:    0x00003707
[ 3634.807292] sdhci: Timeout:  0x00000009 | Int stat: 0x00000000
[ 3634.807300] sdhci: Int enab: 0x00ff0043 | Sig enab: 0x00ff0043
[ 3634.807307] sdhci: AC12 err: 0x00000000 | Slot int: 0x00000000
[ 3634.807314] sdhci: Caps:     0x21e8c8b2 | Caps_1:   0x00008073
[ 3634.807321] sdhci: Cmd:      0x00000d1a | Max curr: 0x00000040
[ 3634.807327] sdhci: Host ctl2: 0x00000000
[ 3634.807330] sdhci: ===========================================
[ 3634.807365] mmc0: req done (CMD55): -123: 00000000 00000000 00000000 00000000
[ 3634.807403] mmc0: starting CMD55 arg 00000000 flags 000000f5
[ 3634.807412] sdhci: =========== REGISTER DUMP (mmc0)===========
[ 3634.807420] sdhci: Sys addr: 0xfff44000 | Version:  0x00000502
[ 3634.807428] sdhci: Blk size: 0x00007200 | Blk cnt:  0x00000008
[ 3634.807436] sdhci: Argument: 0xb3680000 | Trn mode: 0x00000033
[ 3634.807443] sdhci: Present:  0x01f20000 | Host ctl: 0x00000005
[ 3634.807450] sdhci: Power:    0x0000000f | Blk gap:  0x00000000
[ 3634.807458] sdhci: Wake-up:  0x00000000 | Clock:    0x00003707
[ 3634.807465] sdhci: Timeout:  0x00000009 | Int stat: 0x00000000
[ 3634.807472] sdhci: Int enab: 0x00ff0043 | Sig enab: 0x00ff0043
[ 3634.807480] sdhci: AC12 err: 0x00000000 | Slot int: 0x00000000
[ 3634.807487] sdhci: Caps:     0x21e8c8b2 | Caps_1:   0x00008073
[ 3634.807495] sdhci: Cmd:      0x00000d1a | Max curr: 0x00000040
[ 3634.807500] sdhci: Host ctl2: 0x00000000
[ 3634.807503] sdhci: ===========================================
[ 3634.807526] mmc0: req done (CMD55): -123: 00000000 00000000 00000000 00000000
[ 3634.807543] mmc0: starting CMD55 arg 00000000 flags 000000f5
[ 3634.807553] sdhci: =========== REGISTER DUMP (mmc0)===========
[ 3634.807560] sdhci: Sys addr: 0xfff44000 | Version:  0x00000502
[ 3634.807568] sdhci: Blk size: 0x00007200 | Blk cnt:  0x00000008
[ 3634.807575] sdhci: Argument: 0xb3680000 | Trn mode: 0x00000033
[ 3634.807583] sdhci: Present:  0x01f20000 | Host ctl: 0x00000005
[ 3634.807591] sdhci: Power:    0x0000000f | Blk gap:  0x00000000
[ 3634.807598] sdhci: Wake-up:  0x00000000 | Clock:    0x00003707
[ 3634.807606] sdhci: Timeout:  0x00000009 | Int stat: 0x00000000
[ 3634.807613] sdhci: Int enab: 0x00ff0043 | Sig enab: 0x00ff0043
[ 3634.807620] sdhci: AC12 err: 0x00000000 | Slot int: 0x00000000
[ 3634.807628] sdhci: Caps:     0x21e8c8b2 | Caps_1:   0x00008073
[ 3634.807636] sdhci: Cmd:      0x00000d1a | Max curr: 0x00000040
[ 3634.807641] sdhci: Host ctl2: 0x00000000
[ 3634.807644] sdhci: ===========================================
[ 3634.807662] mmc0: req done (CMD55): -123: 00000000 00000000 00000000 00000000
[ 3634.807678] mmc0: starting CMD55 arg 00000000 flags 000000f5
[ 3634.807686] sdhci: =========== REGISTER DUMP (mmc0)===========
[ 3634.807694] sdhci: Sys addr: 0xfff44000 | Version:  0x00000502
[ 3634.807702] sdhci: Blk size: 0x00007200 | Blk cnt:  0x00000008
[ 3634.807709] sdhci: Argument: 0xb3680000 | Trn mode: 0x00000033
[ 3634.807716] sdhci: Present:  0x01f20000 | Host ctl: 0x00000005
[ 3634.807723] sdhci: Power:    0x0000000f | Blk gap:  0x00000000
[ 3634.807731] sdhci: Wake-up:  0x00000000 | Clock:    0x00003707
[ 3634.807738] sdhci: Timeout:  0x00000009 | Int stat: 0x00000000
[ 3634.807746] sdhci: Int enab: 0x00ff0043 | Sig enab: 0x00ff0043
[ 3634.807753] sdhci: AC12 err: 0x00000000 | Slot int: 0x00000000
[ 3634.807761] sdhci: Caps:     0x21e8c8b2 | Caps_1:   0x00008073
[ 3634.807768] sdhci: Cmd:      0x00000d1a | Max curr: 0x00000040
[ 3634.807774] sdhci: Host ctl2: 0x00000000
[ 3634.807776] sdhci: ===========================================
[ 3634.807794] mmc0: req done (CMD55): -123: 00000000 00000000 00000000 00000000
[ 3634.807810] mmc0: starting CMD1 arg 00000000 flags 000000e1
[ 3634.807818] sdhci: =========== REGISTER DUMP (mmc0)===========
[ 3634.807825] sdhci: Sys addr: 0xfff44000 | Version:  0x00000502
[ 3634.807833] sdhci: Blk size: 0x00007200 | Blk cnt:  0x00000008
[ 3634.807840] sdhci: Argument: 0xb3680000 | Trn mode: 0x00000033
[ 3634.807848] sdhci: Present:  0x01f20000 | Host ctl: 0x00000005
[ 3634.807856] sdhci: Power:    0x0000000f | Blk gap:  0x00000000
[ 3634.807863] sdhci: Wake-up:  0x00000000 | Clock:    0x00003707
[ 3634.807870] sdhci: Timeout:  0x00000009 | Int stat: 0x00000000
[ 3634.807878] sdhci: Int enab: 0x00ff0043 | Sig enab: 0x00ff0043
[ 3634.807885] sdhci: AC12 err: 0x00000000 | Slot int: 0x00000000
[ 3634.807893] sdhci: Caps:     0x21e8c8b2 | Caps_1:   0x00008073
[ 3634.807900] sdhci: Cmd:      0x00000d1a | Max curr: 0x00000040
[ 3634.807905] sdhci: Host ctl2: 0x00000000
[ 3634.807908] sdhci: ===========================================
[ 3634.807926] mmc0: req done (CMD1): -123: 00000000 00000000 00000000 00000000
[ 3634.807942] mmc0: clock 0Hz busmode 1 powermode 0 cs 0 Vdd 0 width 0 timing 0
[ 3634.807967] mmc0: mmc_rescan_try_freq: trying to init card at 200000 Hz
[ 3634.807973] mmc0: clock 0Hz busmode 1 powermode 1 cs 0 Vdd 21 width 0 timing 0
[ 3634.819072] mmc0: clock 200000Hz busmode 1 powermode 2 cs 0 Vdd 21 width 0 timing 0
[ 3634.830048] mmc0: starting CMD52 arg 00000c00 flags 00000195
[ 3634.830062] sdhci: =========== REGISTER DUMP (mmc0)===========
[ 3634.830071] sdhci: Sys addr: 0xfff44000 | Version:  0x00000502
[ 3634.830079] sdhci: Blk size: 0x00007200 | Blk cnt:  0x00000008
[ 3634.830087] sdhci: Argument: 0xb3680000 | Trn mode: 0x00000033
[ 3634.830095] sdhci: Present:  0x01f20000 | Host ctl: 0x00000005
[ 3634.830102] sdhci: Power:    0x0000000f | Blk gap:  0x00000000
[ 3634.830110] sdhci: Wake-up:  0x00000000 | Clock:    0x00005307
[ 3634.830117] sdhci: Timeout:  0x00000009 | Int stat: 0x00000000
[ 3634.830125] sdhci: Int enab: 0x00ff0043 | Sig enab: 0x00ff0043
[ 3634.830132] sdhci: AC12 err: 0x00000000 | Slot int: 0x00000000
[ 3634.830139] sdhci: Caps:     0x21e8c8b2 | Caps_1:   0x00008073
[ 3634.830146] sdhci: Cmd:      0x00000d1a | Max curr: 0x00000040
[ 3634.830152] sdhci: Host ctl2: 0x00000000
[ 3634.830155] sdhci: ===========================================
[ 3634.830182] mmc0: req done (CMD52): -123: 00000000 00000000 00000000 00000000
[ 3634.830226] mmc0: starting CMD52 arg 80000c08 flags 00000195
[ 3634.830235] sdhci: =========== REGISTER DUMP (mmc0)===========
[ 3634.830243] sdhci: Sys addr: 0xfff44000 | Version:  0x00000502
[ 3634.830250] sdhci: Blk size: 0x00007200 | Blk cnt:  0x00000008
[ 3634.830258] sdhci: Argument: 0xb3680000 | Trn mode: 0x00000033
[ 3634.830265] sdhci: Present:  0x01f20000 | Host ctl: 0x00000005
[ 3634.830273] sdhci: Power:    0x0000000f | Blk gap:  0x00000000
[ 3634.830280] sdhci: Wake-up:  0x00000000 | Clock:    0x00005307
[ 3634.830287] sdhci: Timeout:  0x00000009 | Int stat: 0x00000000
[ 3634.830295] sdhci: Int enab: 0x00ff0043 | Sig enab: 0x00ff0043
[ 3634.830303] sdhci: AC12 err: 0x00000000 | Slot int: 0x00000000
[ 3634.830310] sdhci: Caps:     0x21e8c8b2 | Caps_1:   0x00008073
[ 3634.830317] sdhci: Cmd:      0x00000d1a | Max curr: 0x00000040
[ 3634.830323] sdhci: Host ctl2: 0x00000000
[ 3634.830326] sdhci: ===========================================
[ 3634.830349] mmc0: req done (CMD52): -123: 00000000 00000000 00000000 00000000
[ 3634.830369] mmc0: clock 200000Hz busmode 1 powermode 2 cs 1 Vdd 21 width 0 timing 0
[ 3634.831945] mmc0: starting CMD0 arg 00000000 flags 000000c0
[ 3634.831954] sdhci: =========== REGISTER DUMP (mmc0)===========
[ 3634.831962] sdhci: Sys addr: 0xfff44000 | Version:  0x00000502
[ 3634.831970] sdhci: Blk size: 0x00007200 | Blk cnt:  0x00000008
[ 3634.831977] sdhci: Argument: 0xb3680000 | Trn mode: 0x00000033
[ 3634.831985] sdhci: Present:  0x01f20000 | Host ctl: 0x00000005
[ 3634.831992] sdhci: Power:    0x0000000f | Blk gap:  0x00000000
[ 3634.832000] sdhci: Wake-up:  0x00000000 | Clock:    0x00005307
[ 3634.832007] sdhci: Timeout:  0x00000009 | Int stat: 0x00000000
[ 3634.832015] sdhci: Int enab: 0x00ff0043 | Sig enab: 0x00ff0043
[ 3634.832022] sdhci: AC12 err: 0x00000000 | Slot int: 0x00000000
[ 3634.832030] sdhci: Caps:     0x21e8c8b2 | Caps_1:   0x00008073
[ 3634.832037] sdhci: Cmd:      0x00000d1a | Max curr: 0x00000040
[ 3634.832042] sdhci: Host ctl2: 0x00000000
[ 3634.832045] sdhci: ===========================================
[ 3634.832066] mmc0: req done (CMD0): -123: 00000000 00000000 00000000 00000000
[ 3634.833942] mmc0: clock 200000Hz busmode 1 powermode 2 cs 0 Vdd 21 width 0 timing 0
[ 3634.835941] mmc0: starting CMD8 arg 000001aa flags 000002f5
[ 3634.835953] sdhci: =========== REGISTER DUMP (mmc0)===========
[ 3634.835961] sdhci: Sys addr: 0xfff44000 | Version:  0x00000502
[ 3634.835969] sdhci: Blk size: 0x00007200 | Blk cnt:  0x00000008
[ 3634.835976] sdhci: Argument: 0xb3680000 | Trn mode: 0x00000033
[ 3634.835984] sdhci: Present:  0x01f20000 | Host ctl: 0x00000005
[ 3634.835992] sdhci: Power:    0x0000000f | Blk gap:  0x00000000
[ 3634.835999] sdhci: Wake-up:  0x00000000 | Clock:    0x00005307
[ 3634.836006] sdhci: Timeout:  0x00000009 | Int stat: 0x00000000
[ 3634.836014] sdhci: Int enab: 0x00ff0043 | Sig enab: 0x00ff0043
[ 3634.836021] sdhci: AC12 err: 0x00000000 | Slot int: 0x00000000
[ 3634.836028] sdhci: Caps:     0x21e8c8b2 | Caps_1:   0x00008073
[ 3634.836035] sdhci: Cmd:      0x00000d1a | Max curr: 0x00000040
[ 3634.836041] sdhci: Host ctl2: 0x00000000
[ 3634.836044] sdhci: ===========================================
[ 3634.836067] mmc0: req done (CMD8): -123: 00000000 00000000 00000000 00000000
[ 3634.836090] mmc0: starting CMD5 arg 00000000 flags 000002e1
[ 3634.836099] sdhci: =========== REGISTER DUMP (mmc0)===========
[ 3634.836107] sdhci: Sys addr: 0xfff44000 | Version:  0x00000502
[ 3634.836115] sdhci: Blk size: 0x00007200 | Blk cnt:  0x00000008
[ 3634.836122] sdhci: Argument: 0xb3680000 | Trn mode: 0x00000033
[ 3634.836129] sdhci: Present:  0x01f20000 | Host ctl: 0x00000005
[ 3634.836137] sdhci: Power:    0x0000000f | Blk gap:  0x00000000
[ 3634.836145] sdhci: Wake-up:  0x00000000 | Clock:    0x00005307
[ 3634.836152] sdhci: Timeout:  0x00000009 | Int stat: 0x00000000
[ 3634.836159] sdhci: Int enab: 0x00ff0043 | Sig enab: 0x00ff0043
[ 3634.836167] sdhci: AC12 err: 0x00000000 | Slot int: 0x00000000
[ 3634.836174] sdhci: Caps:     0x21e8c8b2 | Caps_1:   0x00008073
[ 3634.836181] sdhci: Cmd:      0x00000d1a | Max curr: 0x00000040
[ 3634.836187] sdhci: Host ctl2: 0x00000000
[ 3634.836190] sdhci: ===========================================
[ 3634.836208] mmc0: req failed (CMD5): -123, retrying...
[ 3634.836214] sdhci: =========== REGISTER DUMP (mmc0)===========
[ 3634.836221] sdhci: Sys addr: 0xfff44000 | Version:  0x00000502
[ 3634.836228] sdhci: Blk size: 0x00007200 | Blk cnt:  0x00000008
[ 3634.836236] sdhci: Argument: 0xb3680000 | Trn mode: 0x00000033
[ 3634.836244] sdhci: Present:  0x01f20000 | Host ctl: 0x00000005
[ 3634.836251] sdhci: Power:    0x0000000f | Blk gap:  0x00000000
[ 3634.836259] sdhci: Wake-up:  0x00000000 | Clock:    0x00005307
[ 3634.836266] sdhci: Timeout:  0x00000009 | Int stat: 0x00000000
[ 3634.836274] sdhci: Int enab: 0x00ff0043 | Sig enab: 0x00ff0043
[ 3634.836281] sdhci: AC12 err: 0x00000000 | Slot int: 0x00000000
[ 3634.836288] sdhci: Caps:     0x21e8c8b2 | Caps_1:   0x00008073
[ 3634.836296] sdhci: Cmd:      0x00000d1a | Max curr: 0x00000040
[ 3634.836302] sdhci: Host ctl2: 0x00000000
[ 3634.836304] sdhci: ===========================================
[ 3634.836316] mmc0: req failed (CMD5): -123, retrying...
[ 3634.836322] sdhci: =========== REGISTER DUMP (mmc0)===========
[ 3634.836329] sdhci: Sys addr: 0xfff44000 | Version:  0x00000502
[ 3634.836336] sdhci: Blk size: 0x00007200 | Blk cnt:  0x00000008
[ 3634.836343] sdhci: Argument: 0xb3680000 | Trn mode: 0x00000033
[ 3634.836351] sdhci: Present:  0x01f20000 | Host ctl: 0x00000005
[ 3634.836358] sdhci: Power:    0x0000000f | Blk gap:  0x00000000
[ 3634.836365] sdhci: Wake-up:  0x00000000 | Clock:    0x00005307
[ 3634.836373] sdhci: Timeout:  0x00000009 | Int stat: 0x00000000
[ 3634.836380] sdhci: Int enab: 0x00ff0043 | Sig enab: 0x00ff0043
[ 3634.836387] sdhci: AC12 err: 0x00000000 | Slot int: 0x00000000
[ 3634.836395] sdhci: Caps:     0x21e8c8b2 | Caps_1:   0x00008073
[ 3634.836403] sdhci: Cmd:      0x00000d1a | Max curr: 0x00000040
[ 3634.836408] sdhci: Host ctl2: 0x00000000
[ 3634.836411] sdhci: ===========================================
[ 3634.836422] mmc0: req failed (CMD5): -123, retrying...
[ 3634.836428] sdhci: =========== REGISTER DUMP (mmc0)===========
[ 3634.836435] sdhci: Sys addr: 0xfff44000 | Version:  0x00000502
[ 3634.836443] sdhci: Blk size: 0x00007200 | Blk cnt:  0x00000008
[ 3634.836450] sdhci: Argument: 0xb3680000 | Trn mode: 0x00000033
[ 3634.836457] sdhci: Present:  0x01f20000 | Host ctl: 0x00000005
[ 3634.836464] sdhci: Power:    0x0000000f | Blk gap:  0x00000000
[ 3634.836472] sdhci: Wake-up:  0x00000000 | Clock:    0x00005307
[ 3634.836480] sdhci: Timeout:  0x00000009 | Int stat: 0x00000000
[ 3634.836487] sdhci: Int enab: 0x00ff0043 | Sig enab: 0x00ff0043
[ 3634.836494] sdhci: AC12 err: 0x00000000 | Slot int: 0x00000000
[ 3634.836502] sdhci: Caps:     0x21e8c8b2 | Caps_1:   0x00008073
[ 3634.836509] sdhci: Cmd:      0x00000d1a | Max curr: 0x00000040
[ 3634.836515] sdhci: Host ctl2: 0x00000000
[ 3634.836517] sdhci: ===========================================
[ 3634.836532] mmc0: req done (CMD5): -123: 00000000 00000000 00000000 00000000
[ 3634.842131] mmc0: starting CMD55 arg 00000000 flags 000000f5
[ 3634.842144] sdhci: =========== REGISTER DUMP (mmc0)===========
[ 3634.842153] sdhci: Sys addr: 0xfff44000 | Version:  0x00000502
[ 3634.842161] sdhci: Blk size: 0x00007200 | Blk cnt:  0x00000008
[ 3634.842169] sdhci: Argument: 0xb3680000 | Trn mode: 0x00000033
[ 3634.842176] sdhci: Present:  0x01f20000 | Host ctl: 0x00000005
[ 3634.842185] sdhci: Power:    0x0000000f | Blk gap:  0x00000000
[ 3634.842192] sdhci: Wake-up:  0x00000000 | Clock:    0x00005307
[ 3634.842200] sdhci: Timeout:  0x00000009 | Int stat: 0x00000000
[ 3634.842207] sdhci: Int enab: 0x00ff0043 | Sig enab: 0x00ff0043
[ 3634.842215] sdhci: AC12 err: 0x00000000 | Slot int: 0x00000000
[ 3634.842223] sdhci: Caps:     0x21e8c8b2 | Caps_1:   0x00008073
[ 3634.842230] sdhci: Cmd:      0x00000d1a | Max curr: 0x00000040
[ 3634.842235] sdhci: Host ctl2: 0x00000000
[ 3634.842238] sdhci: ===========================================
[ 3634.842272] mmc0: req done (CMD55): -123: 00000000 00000000 00000000 00000000
[ 3634.842313] mmc0: starting CMD55 arg 00000000 flags 000000f5
[ 3634.842322] sdhci: =========== REGISTER DUMP (mmc0)===========
[ 3634.842330] sdhci: Sys addr: 0xfff44000 | Version:  0x00000502
[ 3634.842337] sdhci: Blk size: 0x00007200 | Blk cnt:  0x00000008
[ 3634.842344] sdhci: Argument: 0xb3680000 | Trn mode: 0x00000033
[ 3634.842352] sdhci: Present:  0x01f20000 | Host ctl: 0x00000005
[ 3634.842360] sdhci: Power:    0x0000000f | Blk gap:  0x00000000
[ 3634.842367] sdhci: Wake-up:  0x00000000 | Clock:    0x00005307
[ 3634.842374] sdhci: Timeout:  0x00000009 | Int stat: 0x00000000
[ 3634.842382] sdhci: Int enab: 0x00ff0043 | Sig enab: 0x00ff0043
[ 3634.842389] sdhci: AC12 err: 0x00000000 | Slot int: 0x00000000
[ 3634.842397] sdhci: Caps:     0x21e8c8b2 | Caps_1:   0x00008073
[ 3634.842404] sdhci: Cmd:      0x00000d1a | Max curr: 0x00000040
[ 3634.842409] sdhci: Host ctl2: 0x00000000
[ 3634.842412] sdhci: ===========================================
[ 3634.842436] mmc0: req done (CMD55): -123: 00000000 00000000 00000000 00000000
[ 3634.842453] mmc0: starting CMD55 arg 00000000 flags 000000f5
[ 3634.842462] sdhci: =========== REGISTER DUMP (mmc0)===========
[ 3634.842469] sdhci: Sys addr: 0xfff44000 | Version:  0x00000502
[ 3634.842477] sdhci: Blk size: 0x00007200 | Blk cnt:  0x00000008
[ 3634.842485] sdhci: Argument: 0xb3680000 | Trn mode: 0x00000033
[ 3634.842492] sdhci: Present:  0x01f20000 | Host ctl: 0x00000005
[ 3634.842499] sdhci: Power:    0x0000000f | Blk gap:  0x00000000
[ 3634.842507] sdhci: Wake-up:  0x00000000 | Clock:    0x00005307
[ 3634.842514] sdhci: Timeout:  0x00000009 | Int stat: 0x00000000
[ 3634.842521] sdhci: Int enab: 0x00ff0043 | Sig enab: 0x00ff0043
[ 3634.842529] sdhci: AC12 err: 0x00000000 | Slot int: 0x00000000
[ 3634.842537] sdhci: Caps:     0x21e8c8b2 | Caps_1:   0x00008073
[ 3634.842544] sdhci: Cmd:      0x00000d1a | Max curr: 0x00000040
[ 3634.842550] sdhci: Host ctl2: 0x00000000
[ 3634.842553] sdhci: ===========================================
[ 3634.842572] mmc0: req done (CMD55): -123: 00000000 00000000 00000000 00000000
[ 3634.842587] mmc0: starting CMD55 arg 00000000 flags 000000f5
[ 3634.842595] sdhci: =========== REGISTER DUMP (mmc0)===========
[ 3634.842603] sdhci: Sys addr: 0xfff44000 | Version:  0x00000502
[ 3634.842610] sdhci: Blk size: 0x00007200 | Blk cnt:  0x00000008
[ 3634.842618] sdhci: Argument: 0xb3680000 | Trn mode: 0x00000033
[ 3634.842626] sdhci: Present:  0x01f20000 | Host ctl: 0x00000005
[ 3634.842633] sdhci: Power:    0x0000000f | Blk gap:  0x00000000
[ 3634.842641] sdhci: Wake-up:  0x00000000 | Clock:    0x00005307
[ 3634.842648] sdhci: Timeout:  0x00000009 | Int stat: 0x00000000
[ 3634.842656] sdhci: Int enab: 0x00ff0043 | Sig enab: 0x00ff0043
[ 3634.842663] sdhci: AC12 err: 0x00000000 | Slot int: 0x00000000
[ 3634.842671] sdhci: Caps:     0x21e8c8b2 | Caps_1:   0x00008073
[ 3634.842678] sdhci: Cmd:      0x00000d1a | Max curr: 0x00000040
[ 3634.842684] sdhci: Host ctl2: 0x00000000
[ 3634.842686] sdhci: ===========================================
[ 3634.842705] mmc0: req done (CMD55): -123: 00000000 00000000 00000000 00000000
[ 3634.842721] mmc0: starting CMD1 arg 00000000 flags 000000e1
[ 3634.842728] sdhci: =========== REGISTER DUMP (mmc0)===========
[ 3634.842736] sdhci: Sys addr: 0xfff44000 | Version:  0x00000502
[ 3634.842743] sdhci: Blk size: 0x00007200 | Blk cnt:  0x00000008
[ 3634.842751] sdhci: Argument: 0xb3680000 | Trn mode: 0x00000033
[ 3634.842758] sdhci: Present:  0x01f20000 | Host ctl: 0x00000005
[ 3634.842765] sdhci: Power:    0x0000000f | Blk gap:  0x00000000
[ 3634.842772] sdhci: Wake-up:  0x00000000 | Clock:    0x00005307
[ 3634.842780] sdhci: Timeout:  0x00000009 | Int stat: 0x00000000
[ 3634.842787] sdhci: Int enab: 0x00ff0043 | Sig enab: 0x00ff0043
[ 3634.842794] sdhci: AC12 err: 0x00000000 | Slot int: 0x00000000
[ 3634.842802] sdhci: Caps:     0x21e8c8b2 | Caps_1:   0x00008073
[ 3634.842809] sdhci: Cmd:      0x00000d1a | Max curr: 0x00000040
[ 3634.842814] sdhci: Host ctl2: 0x00000000
[ 3634.842817] sdhci: ===========================================
[ 3634.842835] mmc0: req done (CMD1): -123: 00000000 00000000 00000000 00000000
[ 3634.842852] mmc0: clock 0Hz busmode 1 powermode 0 cs 0 Vdd 0 width 0 timing 0
[ 3634.842877] mmc0: mmc_rescan_try_freq: trying to init card at 100000 Hz
[ 3634.842883] mmc0: clock 0Hz busmode 1 powermode 1 cs 0 Vdd 21 width 0 timing 0
[ 3634.852931] mmc0: clock 100000Hz busmode 1 powermode 2 cs 0 Vdd 21 width 0 timing 0
[ 3634.863971] mmc0: starting CMD52 arg 00000c00 flags 00000195
[ 3634.863985] sdhci: =========== REGISTER DUMP (mmc0)===========
[ 3634.863994] sdhci: Sys addr: 0xfff44000 | Version:  0x00000502
[ 3634.864002] sdhci: Blk size: 0x00007200 | Blk cnt:  0x00000008
[ 3634.864010] sdhci: Argument: 0xb3680000 | Trn mode: 0x00000033
[ 3634.864018] sdhci: Present:  0x01f20000 | Host ctl: 0x00000005
[ 3634.864025] sdhci: Power:    0x0000000f | Blk gap:  0x00000000
[ 3634.864033] sdhci: Wake-up:  0x00000000 | Clock:    0x0000a507
[ 3634.864040] sdhci: Timeout:  0x00000009 | Int stat: 0x00000000
[ 3634.864049] sdhci: Int enab: 0x00ff0043 | Sig enab: 0x00ff0043
[ 3634.864057] sdhci: AC12 err: 0x00000000 | Slot int: 0x00000000
[ 3634.864065] sdhci: Caps:     0x21e8c8b2 | Caps_1:   0x00008073
[ 3634.864073] sdhci: Cmd:      0x00000d1a | Max curr: 0x00000040
[ 3634.864079] sdhci: Host ctl2: 0x00000000
[ 3634.864081] sdhci: ===========================================
[ 3634.864113] mmc0: req done (CMD52): -123: 00000000 00000000 00000000 00000000
[ 3634.864148] mmc0: starting CMD52 arg 80000c08 flags 00000195
[ 3634.864158] sdhci: =========== REGISTER DUMP (mmc0)===========
[ 3634.864165] sdhci: Sys addr: 0xfff44000 | Version:  0x00000502
[ 3634.864173] sdhci: Blk size: 0x00007200 | Blk cnt:  0x00000008
[ 3634.864181] sdhci: Argument: 0xb3680000 | Trn mode: 0x00000033
[ 3634.864188] sdhci: Present:  0x01f20000 | Host ctl: 0x00000005
[ 3634.864195] sdhci: Power:    0x0000000f | Blk gap:  0x00000000
[ 3634.864203] sdhci: Wake-up:  0x00000000 | Clock:    0x0000a507
[ 3634.864210] sdhci: Timeout:  0x00000009 | Int stat: 0x00000000
[ 3634.864218] sdhci: Int enab: 0x00ff0043 | Sig enab: 0x00ff0043
[ 3634.864226] sdhci: AC12 err: 0x00000000 | Slot int: 0x00000000
[ 3634.864233] sdhci: Caps:     0x21e8c8b2 | Caps_1:   0x00008073
[ 3634.864240] sdhci: Cmd:      0x00000d1a | Max curr: 0x00000040
[ 3634.864246] sdhci: Host ctl2: 0x00000000
[ 3634.864248] sdhci: ===========================================
[ 3634.864273] mmc0: req done (CMD52): -123: 00000000 00000000 00000000 00000000
[ 3634.864293] mmc0: clock 100000Hz busmode 1 powermode 2 cs 1 Vdd 21 width 0 timing 0
[ 3634.865870] mmc0: starting CMD0 arg 00000000 flags 000000c0
[ 3634.865880] sdhci: =========== REGISTER DUMP (mmc0)===========
[ 3634.865887] sdhci: Sys addr: 0xfff44000 | Version:  0x00000502
[ 3634.865895] sdhci: Blk size: 0x00007200 | Blk cnt:  0x00000008
[ 3634.865902] sdhci: Argument: 0xb3680000 | Trn mode: 0x00000033
[ 3634.865910] sdhci: Present:  0x01f20000 | Host ctl: 0x00000005
[ 3634.865917] sdhci: Power:    0x0000000f | Blk gap:  0x00000000
[ 3634.865925] sdhci: Wake-up:  0x00000000 | Clock:    0x0000a507
[ 3634.865932] sdhci: Timeout:  0x00000009 | Int stat: 0x00000000
[ 3634.865940] sdhci: Int enab: 0x00ff0043 | Sig enab: 0x00ff0043
[ 3634.865947] sdhci: AC12 err: 0x00000000 | Slot int: 0x00000000
[ 3634.865954] sdhci: Caps:     0x21e8c8b2 | Caps_1:   0x00008073
[ 3634.865961] sdhci: Cmd:      0x00000d1a | Max curr: 0x00000040
[ 3634.865967] sdhci: Host ctl2: 0x00000000
[ 3634.865969] sdhci: ===========================================
[ 3634.865992] mmc0: req done (CMD0): -123: 00000000 00000000 00000000 00000000
[ 3634.867866] mmc0: clock 100000Hz busmode 1 powermode 2 cs 0 Vdd 21 width 0 timing 0
[ 3634.869883] mmc0: starting CMD8 arg 000001aa flags 000002f5
[ 3634.869901] sdhci: =========== REGISTER DUMP (mmc0)===========
[ 3634.869913] sdhci: Sys addr: 0xfff44000 | Version:  0x00000502
[ 3634.869924] sdhci: Blk size: 0x00007200 | Blk cnt:  0x00000008
[ 3634.869932] sdhci: Argument: 0xb3680000 | Trn mode: 0x00000033
[ 3634.869940] sdhci: Present:  0x01f20000 | Host ctl: 0x00000005
[ 3634.869948] sdhci: Power:    0x0000000f | Blk gap:  0x00000000
[ 3634.869955] sdhci: Wake-up:  0x00000000 | Clock:    0x0000a507
[ 3634.869963] sdhci: Timeout:  0x00000009 | Int stat: 0x00000000
[ 3634.869970] sdhci: Int enab: 0x00ff0043 | Sig enab: 0x00ff0043
[ 3634.869978] sdhci: AC12 err: 0x00000000 | Slot int: 0x00000000
[ 3634.869986] sdhci: Caps:     0x21e8c8b2 | Caps_1:   0x00008073
[ 3634.869993] sdhci: Cmd:      0x00000d1a | Max curr: 0x00000040
[ 3634.869998] sdhci: Host ctl2: 0x00000000
[ 3634.870002] sdhci: ===========================================
[ 3634.870030] mmc0: req done (CMD8): -123: 00000000 00000000 00000000 00000000
[ 3634.870053] mmc0: starting CMD5 arg 00000000 flags 000002e1
[ 3634.870063] sdhci: =========== REGISTER DUMP (mmc0)===========
[ 3634.870071] sdhci: Sys addr: 0xfff44000 | Version:  0x00000502
[ 3634.870079] sdhci: Blk size: 0x00007200 | Blk cnt:  0x00000008
[ 3634.870086] sdhci: Argument: 0xb3680000 | Trn mode: 0x00000033
[ 3634.870094] sdhci: Present:  0x01f20000 | Host ctl: 0x00000005
[ 3634.870101] sdhci: Power:    0x0000000f | Blk gap:  0x00000000
[ 3634.870109] sdhci: Wake-up:  0x00000000 | Clock:    0x0000a507
[ 3634.870116] sdhci: Timeout:  0x00000009 | Int stat: 0x00000000
[ 3634.870123] sdhci: Int enab: 0x00ff0043 | Sig enab: 0x00ff0043
[ 3634.870130] sdhci: AC12 err: 0x00000000 | Slot int: 0x00000000
[ 3634.870138] sdhci: Caps:     0x21e8c8b2 | Caps_1:   0x00008073
[ 3634.870145] sdhci: Cmd:      0x00000d1a | Max curr: 0x00000040
[ 3634.870151] sdhci: Host ctl2: 0x00000000
[ 3634.870154] sdhci: ===========================================
[ 3634.870173] mmc0: req failed (CMD5): -123, retrying...
[ 3634.870179] sdhci: =========== REGISTER DUMP (mmc0)===========
[ 3634.870187] sdhci: Sys addr: 0xfff44000 | Version:  0x00000502
[ 3634.870194] sdhci: Blk size: 0x00007200 | Blk cnt:  0x00000008
[ 3634.870201] sdhci: Argument: 0xb3680000 | Trn mode: 0x00000033
[ 3634.870209] sdhci: Present:  0x01f20000 | Host ctl: 0x00000005
[ 3634.870216] sdhci: Power:    0x0000000f | Blk gap:  0x00000000
[ 3634.870224] sdhci: Wake-up:  0x00000000 | Clock:    0x0000a507
[ 3634.870231] sdhci: Timeout:  0x00000009 | Int stat: 0x00000000
[ 3634.870238] sdhci: Int enab: 0x00ff0043 | Sig enab: 0x00ff0043
[ 3634.870246] sdhci: AC12 err: 0x00000000 | Slot int: 0x00000000
[ 3634.870253] sdhci: Caps:     0x21e8c8b2 | Caps_1:   0x00008073
[ 3634.870260] sdhci: Cmd:      0x00000d1a | Max curr: 0x00000040
[ 3634.870265] sdhci: Host ctl2: 0x00000000
[ 3634.870268] sdhci: ===========================================
[ 3634.870282] mmc0: req failed (CMD5): -123, retrying...
[ 3634.870287] sdhci: =========== REGISTER DUMP (mmc0)===========
[ 3634.870295] sdhci: Sys addr: 0xfff44000 | Version:  0x00000502
[ 3634.870302] sdhci: Blk size: 0x00007200 | Blk cnt:  0x00000008
[ 3634.870309] sdhci: Argument: 0xb3680000 | Trn mode: 0x00000033
[ 3634.870317] sdhci: Present:  0x01f20000 | Host ctl: 0x00000005
[ 3634.870324] sdhci: Power:    0x0000000f | Blk gap:  0x00000000
[ 3634.870332] sdhci: Wake-up:  0x00000000 | Clock:    0x0000a507
[ 3634.870339] sdhci: Timeout:  0x00000009 | Int stat: 0x00000000
[ 3634.870347] sdhci: Int enab: 0x00ff0043 | Sig enab: 0x00ff0043
[ 3634.870354] sdhci: AC12 err: 0x00000000 | Slot int: 0x00000000
[ 3634.870361] sdhci: Caps:     0x21e8c8b2 | Caps_1:   0x00008073
[ 3634.870369] sdhci: Cmd:      0x00000d1a | Max curr: 0x00000040
[ 3634.870374] sdhci: Host ctl2: 0x00000000
[ 3634.870377] sdhci: ===========================================
[ 3634.870390] mmc0: req failed (CMD5): -123, retrying...
[ 3634.870395] sdhci: =========== REGISTER DUMP (mmc0)===========
[ 3634.870402] sdhci: Sys addr: 0xfff44000 | Version:  0x00000502
[ 3634.870410] sdhci: Blk size: 0x00007200 | Blk cnt:  0x00000008
[ 3634.870417] sdhci: Argument: 0xb3680000 | Trn mode: 0x00000033
[ 3634.870425] sdhci: Present:  0x01f20000 | Host ctl: 0x00000005
[ 3634.870432] sdhci: Power:    0x0000000f | Blk gap:  0x00000000
[ 3634.870440] sdhci: Wake-up:  0x00000000 | Clock:    0x0000a507
[ 3634.870447] sdhci: Timeout:  0x00000009 | Int stat: 0x00000000
[ 3634.870455] sdhci: Int enab: 0x00ff0043 | Sig enab: 0x00ff0043
[ 3634.870462] sdhci: AC12 err: 0x00000000 | Slot int: 0x00000000
[ 3634.870470] sdhci: Caps:     0x21e8c8b2 | Caps_1:   0x00008073
[ 3634.870477] sdhci: Cmd:      0x00000d1a | Max curr: 0x00000040
[ 3634.870482] sdhci: Host ctl2: 0x00000000
[ 3634.870485] sdhci: ===========================================
[ 3634.870501] mmc0: req done (CMD5): -123: 00000000 00000000 00000000 00000000
[ 3634.876100] mmc0: starting CMD55 arg 00000000 flags 000000f5
[ 3634.876114] sdhci: =========== REGISTER DUMP (mmc0)===========
[ 3634.876122] sdhci: Sys addr: 0xfff44000 | Version:  0x00000502
[ 3634.876131] sdhci: Blk size: 0x00007200 | Blk cnt:  0x00000008
[ 3634.876138] sdhci: Argument: 0xb3680000 | Trn mode: 0x00000033
[ 3634.876146] sdhci: Present:  0x01f20000 | Host ctl: 0x00000005
[ 3634.876154] sdhci: Power:    0x0000000f | Blk gap:  0x00000000
[ 3634.876161] sdhci: Wake-up:  0x00000000 | Clock:    0x0000a507
[ 3634.876169] sdhci: Timeout:  0x00000009 | Int stat: 0x00000000
[ 3634.876176] sdhci: Int enab: 0x00ff0043 | Sig enab: 0x00ff0043
[ 3634.876183] sdhci: AC12 err: 0x00000000 | Slot int: 0x00000000
[ 3634.876191] sdhci: Caps:     0x21e8c8b2 | Caps_1:   0x00008073
[ 3634.876200] sdhci: Cmd:      0x00000d1a | Max curr: 0x00000040
[ 3634.876205] sdhci: Host ctl2: 0x00000000
[ 3634.876208] sdhci: ===========================================
[ 3634.876243] mmc0: req done (CMD55): -123: 00000000 00000000 00000000 00000000
[ 3634.876282] mmc0: starting CMD55 arg 00000000 flags 000000f5
[ 3634.876292] sdhci: =========== REGISTER DUMP (mmc0)===========
[ 3634.876300] sdhci: Sys addr: 0xfff44000 | Version:  0x00000502
[ 3634.876307] sdhci: Blk size: 0x00007200 | Blk cnt:  0x00000008
[ 3634.876315] sdhci: Argument: 0xb3680000 | Trn mode: 0x00000033
[ 3634.876323] sdhci: Present:  0x01f20000 | Host ctl: 0x00000005
[ 3634.876330] sdhci: Power:    0x0000000f | Blk gap:  0x00000000
[ 3634.876338] sdhci: Wake-up:  0x00000000 | Clock:    0x0000a507
[ 3634.876346] sdhci: Timeout:  0x00000009 | Int stat: 0x00000000
[ 3634.876353] sdhci: Int enab: 0x00ff0043 | Sig enab: 0x00ff0043
[ 3634.876361] sdhci: AC12 err: 0x00000000 | Slot int: 0x00000000
[ 3634.876368] sdhci: Caps:     0x21e8c8b2 | Caps_1:   0x00008073
[ 3634.876376] sdhci: Cmd:      0x00000d1a | Max curr: 0x00000040
[ 3634.876382] sdhci: Host ctl2: 0x00000000
[ 3634.876384] sdhci: ===========================================
[ 3634.876409] mmc0: req done (CMD55): -123: 00000000 00000000 00000000 00000000
[ 3634.876426] mmc0: starting CMD55 arg 00000000 flags 000000f5
[ 3634.876436] sdhci: =========== REGISTER DUMP (mmc0)===========
[ 3634.876444] sdhci: Sys addr: 0xfff44000 | Version:  0x00000502
[ 3634.876452] sdhci: Blk size: 0x00007200 | Blk cnt:  0x00000008
[ 3634.876460] sdhci: Argument: 0xb3680000 | Trn mode: 0x00000033
[ 3634.876467] sdhci: Present:  0x01f20000 | Host ctl: 0x00000005
[ 3634.876474] sdhci: Power:    0x0000000f | Blk gap:  0x00000000
[ 3634.876482] sdhci: Wake-up:  0x00000000 | Clock:    0x0000a507
[ 3634.876489] sdhci: Timeout:  0x00000009 | Int stat: 0x00000000
[ 3634.876496] sdhci: Int enab: 0x00ff0043 | Sig enab: 0x00ff0043
[ 3634.876503] sdhci: AC12 err: 0x00000000 | Slot int: 0x00000000
[ 3634.876511] sdhci: Caps:     0x21e8c8b2 | Caps_1:   0x00008073
[ 3634.876518] sdhci: Cmd:      0x00000d1a | Max curr: 0x00000040
[ 3634.876523] sdhci: Host ctl2: 0x00000000
[ 3634.876526] sdhci: ===========================================
[ 3634.876547] mmc0: req done (CMD55): -123: 00000000 00000000 00000000 00000000
[ 3634.876562] mmc0: starting CMD55 arg 00000000 flags 000000f5
[ 3634.876571] sdhci: =========== REGISTER DUMP (mmc0)===========
[ 3634.876579] sdhci: Sys addr: 0xfff44000 | Version:  0x00000502
[ 3634.876586] sdhci: Blk size: 0x00007200 | Blk cnt:  0x00000008
[ 3634.876594] sdhci: Argument: 0xb3680000 | Trn mode: 0x00000033
[ 3634.876601] sdhci: Present:  0x01f20000 | Host ctl: 0x00000005
[ 3634.876608] sdhci: Power:    0x0000000f | Blk gap:  0x00000000
[ 3634.876616] sdhci: Wake-up:  0x00000000 | Clock:    0x0000a507
[ 3634.876623] sdhci: Timeout:  0x00000009 | Int stat: 0x00000000
[ 3634.876631] sdhci: Int enab: 0x00ff0043 | Sig enab: 0x00ff0043
[ 3634.876638] sdhci: AC12 err: 0x00000000 | Slot int: 0x00000000
[ 3634.876646] sdhci: Caps:     0x21e8c8b2 | Caps_1:   0x00008073
[ 3634.876653] sdhci: Cmd:      0x00000d1a | Max curr: 0x00000040
[ 3634.876658] sdhci: Host ctl2: 0x00000000
[ 3634.876661] sdhci: ===========================================
[ 3634.876681] mmc0: req done (CMD55): -123: 00000000 00000000 00000000 00000000
[ 3634.876697] mmc0: starting CMD1 arg 00000000 flags 000000e1
[ 3634.876705] sdhci: =========== REGISTER DUMP (mmc0)===========
[ 3634.876713] sdhci: Sys addr: 0xfff44000 | Version:  0x00000502
[ 3634.876720] sdhci: Blk size: 0x00007200 | Blk cnt:  0x00000008
[ 3634.876727] sdhci: Argument: 0xb3680000 | Trn mode: 0x00000033
[ 3634.876735] sdhci: Present:  0x01f20000 | Host ctl: 0x00000005
[ 3634.876742] sdhci: Power:    0x0000000f | Blk gap:  0x00000000
[ 3634.876749] sdhci: Wake-up:  0x00000000 | Clock:    0x0000a507
[ 3634.876756] sdhci: Timeout:  0x00000009 | Int stat: 0x00000000
[ 3634.876763] sdhci: Int enab: 0x00ff0043 | Sig enab: 0x00ff0043
[ 3634.876771] sdhci: AC12 err: 0x00000000 | Slot int: 0x00000000
[ 3634.876778] sdhci: Caps:     0x21e8c8b2 | Caps_1:   0x00008073
[ 3634.876785] sdhci: Cmd:      0x00000d1a | Max curr: 0x00000040
[ 3634.876790] sdhci: Host ctl2: 0x00000000
[ 3634.876793] sdhci: ===========================================
[ 3634.876814] mmc0: req done (CMD1): -123: 00000000 00000000 00000000 00000000
[ 3634.876948] mmc0: clock 0Hz busmode 1 powermode 0 cs 0 Vdd 0 width 0 timing 0

and when inserting a card, the dmesg buffer overflows, but I get:

[ 3763.964875] mmc0: starting CMD13 arg b3680000 flags 00000195
[ 3763.964892] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[ 3763.964894] sdhci: =========== REGISTER DUMP (mmc0)===========
[ 3763.964900] sdhci: Sys addr: 0xffe07000 | Version:  0x00000502
[ 3763.964905] sdhci: Blk size: 0x00007200 | Blk cnt:  0x00000008
[ 3763.964910] sdhci: Argument: 0xb3680000 | Trn mode: 0x00000033
[ 3763.964916] sdhci: Present:  0x01ff0001 | Host ctl: 0x00000007
[ 3763.964921] sdhci: Power:    0x0000000f | Blk gap:  0x00000000
[ 3763.964927] sdhci: Wake-up:  0x00000000 | Clock:    0x00000107
[ 3763.964932] sdhci: Timeout:  0x00000009 | Int stat: 0x00000000
[ 3763.964938] sdhci: Int enab: 0x02ff008b | Sig enab: 0x02ff008b
[ 3763.964943] sdhci: AC12 err: 0x00000000 | Slot int: 0x00000000
[ 3763.964949] sdhci: Caps:     0x21e8c8b2 | Caps_1:   0x00008073
[ 3763.964954] sdhci: Cmd:      0x00000d1a | Max curr: 0x00000040
[ 3763.964957] sdhci: Host ctl2: 0x00000000
[ 3763.964959] sdhci: ===========================================
[ 3763.964973] mmc0: req done (CMD13): -110: 00000000 00000000 00000000 00000000
[ 3763.964976] mmcblk0: error -110 sending status command, retrying
[ 3763.964978] mmc0: starting CMD13 arg b3680000 flags 00000195
[ 3763.964995] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[ 3763.964996] sdhci: =========== REGISTER DUMP (mmc0)===========
[ 3763.965000] sdhci: Sys addr: 0xffe07000 | Version:  0x00000502
[ 3763.965005] sdhci: Blk size: 0x00007200 | Blk cnt:  0x00000008
[ 3763.965009] sdhci: Argument: 0xb3680000 | Trn mode: 0x00000033
[ 3763.965014] sdhci: Present:  0x01ff0001 | Host ctl: 0x00000007
[ 3763.965018] sdhci: Power:    0x0000000f | Blk gap:  0x00000000
[ 3763.965023] sdhci: Wake-up:  0x00000000 | Clock:    0x00000107
[ 3763.965027] sdhci: Timeout:  0x00000009 | Int stat: 0x00000000
[ 3763.965032] sdhci: Int enab: 0x02ff008b | Sig enab: 0x02ff008b
[ 3763.965037] sdhci: AC12 err: 0x00000000 | Slot int: 0x00000000
[ 3763.965042] sdhci: Caps:     0x21e8c8b2 | Caps_1:   0x00008073
[ 3763.965046] sdhci: Cmd:      0x00000d1a | Max curr: 0x00000040
[ 3763.965049] sdhci: Host ctl2: 0x00000000
[ 3763.965050] sdhci: ===========================================
[ 3763.965063] mmc0: req done (CMD13): -110: 00000000 00000000 00000000 00000000
[ 3763.965066] mmcblk0: error -110 sending status command, aborting
[ 3763.965068] end_request: I/O error, dev mmcblk0, sector 0
[ 3763.966552] mmc0: starting CMD18 arg 00000000 flags 000000b5
[ 3763.966554] mmc0:     blksz 512 blocks 8 flags 00000200 tsac 100 ms nsac 0
[ 3763.966556] mmc0:     CMD12 arg 00000000 flags 0000049d
[ 3763.966581] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[ 3763.966582] sdhci: =========== REGISTER DUMP (mmc0)===========
[ 3763.966587] sdhci: Sys addr: 0xffe06000 | Version:  0x00000502
[ 3763.966592] sdhci: Blk size: 0x00007200 | Blk cnt:  0x00000008
[ 3763.966596] sdhci: Argument: 0x00000000 | Trn mode: 0x00000033
[ 3763.966601] sdhci: Present:  0x01ff0207 | Host ctl: 0x00000007
[ 3763.966607] sdhci: Power:    0x0000000f | Blk gap:  0x00000000
[ 3763.966613] sdhci: Wake-up:  0x00000000 | Clock:    0x00000107
[ 3763.966618] sdhci: Timeout:  0x00000009 | Int stat: 0x00000000
[ 3763.966623] sdhci: Int enab: 0x02ff008b | Sig enab: 0x02ff008b
[ 3763.966628] sdhci: AC12 err: 0x00000000 | Slot int: 0x00000000
[ 3763.966633] sdhci: Caps:     0x21e8c8b2 | Caps_1:   0x00008073
[ 3763.966639] sdhci: Cmd:      0x0000123a | Max curr: 0x00000040
[ 3763.966643] sdhci: Host ctl2: 0x00000000
[ 3763.966644] sdhci: ===========================================
[ 3763.966659] mmc0: req done (CMD18): -110: 00000000 00000000 00000000 00000000
[ 3763.966661] mmc0:     0 bytes transferred: 0
[ 3763.966663] mmc0:     (CMD12): 0: 00000000 00000000 00000000 00000000
[ 3763.966668] mmc0: starting CMD13 arg b3680000 flags 00000195
[ 3763.966685] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[ 3763.966687] sdhci: =========== REGISTER DUMP (mmc0)===========
[ 3763.966692] sdhci: Sys addr: 0xffe06000 | Version:  0x00000502
[ 3763.966698] sdhci: Blk size: 0x00007200 | Blk cnt:  0x00000008
[ 3763.966703] sdhci: Argument: 0xb3680000 | Trn mode: 0x00000033
[ 3763.966709] sdhci: Present:  0x01ff0001 | Host ctl: 0x00000007
[ 3763.966714] sdhci: Power:    0x0000000f | Blk gap:  0x00000000
[ 3763.966720] sdhci: Wake-up:  0x00000000 | Clock:    0x00000107
[ 3763.966725] sdhci: Timeout:  0x00000009 | Int stat: 0x00000000
[ 3763.966730] sdhci: Int enab: 0x02ff008b | Sig enab: 0x02ff008b
[ 3763.966735] sdhci: AC12 err: 0x00000000 | Slot int: 0x00000000
[ 3763.966740] sdhci: Caps:     0x21e8c8b2 | Caps_1:   0x00008073
[ 3763.966745] sdhci: Cmd:      0x00000d1a | Max curr: 0x00000040
[ 3763.966748] sdhci: Host ctl2: 0x00000000
[ 3763.966749] sdhci: ===========================================
[ 3763.966762] mmc0: req done (CMD13): -110: 00000000 00000000 00000000 00000000
[ 3763.966765] mmcblk0: error -110 sending status command, retrying
[ 3763.966766] mmc0: starting CMD13 arg b3680000 flags 00000195
[ 3763.966782] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[ 3763.966783] sdhci: =========== REGISTER DUMP (mmc0)===========
[ 3763.966787] sdhci: Sys addr: 0xffe06000 | Version:  0x00000502
[ 3763.966792] sdhci: Blk size: 0x00007200 | Blk cnt:  0x00000008
[ 3763.966797] sdhci: Argument: 0xb3680000 | Trn mode: 0x00000033
[ 3763.966802] sdhci: Present:  0x01ff0001 | Host ctl: 0x00000007
[ 3763.966806] sdhci: Power:    0x0000000f | Blk gap:  0x00000000
[ 3763.966811] sdhci: Wake-up:  0x00000000 | Clock:    0x00000107
[ 3763.966816] sdhci: Timeout:  0x00000009 | Int stat: 0x00000000
[ 3763.966820] sdhci: Int enab: 0x02ff008b | Sig enab: 0x02ff008b
[ 3763.966825] sdhci: AC12 err: 0x00000000 | Slot int: 0x00000000
[ 3763.966829] sdhci: Caps:     0x21e8c8b2 | Caps_1:   0x00008073
[ 3763.966835] sdhci: Cmd:      0x00000d1a | Max curr: 0x00000040
[ 3763.966837] sdhci: Host ctl2: 0x00000000
[ 3763.966838] sdhci: ===========================================
[ 3763.966851] mmc0: req done (CMD13): -110: 00000000 00000000 00000000 00000000
[ 3763.966853] mmcblk0: error -110 sending status command, retrying
[ 3763.966854] mmc0: starting CMD13 arg b3680000 flags 00000195
[ 3763.966870] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[ 3763.966871] sdhci: =========== REGISTER DUMP (mmc0)===========
[ 3763.966875] sdhci: Sys addr: 0xffe06000 | Version:  0x00000502
[ 3763.966880] sdhci: Blk size: 0x00007200 | Blk cnt:  0x00000008
[ 3763.966885] sdhci: Argument: 0xb3680000 | Trn mode: 0x00000033
[ 3763.966890] sdhci: Present:  0x01ff0001 | Host ctl: 0x00000007
[ 3763.966894] sdhci: Power:    0x0000000f | Blk gap:  0x00000000
[ 3763.966898] sdhci: Wake-up:  0x00000000 | Clock:    0x00000107
[ 3763.966903] sdhci: Timeout:  0x00000009 | Int stat: 0x00000000
[ 3763.966908] sdhci: Int enab: 0x02ff008b | Sig enab: 0x02ff008b
[ 3763.966913] sdhci: AC12 err: 0x00000000 | Slot int: 0x00000000
[ 3763.966917] sdhci: Caps:     0x21e8c8b2 | Caps_1:   0x00008073
[ 3763.966922] sdhci: Cmd:      0x00000d1a | Max curr: 0x00000040
[ 3763.966925] sdhci: Host ctl2: 0x00000000
[ 3763.966927] sdhci: ===========================================
[ 3763.966940] mmc0: req done (CMD13): -110: 00000000 00000000 00000000 00000000
[ 3763.966944] mmcblk0: error -110 sending status command, aborting
[ 3763.966947] end_request: I/O error, dev mmcblk0, sector 0
[ 3763.966964] mmc0: starting CMD18 arg 00000000 flags 000000b5
[ 3763.966966] mmc0:     blksz 512 blocks 8 flags 00000200 tsac 100 ms nsac 0
[ 3763.966968] mmc0:     CMD12 arg 00000000 flags 0000049d
[ 3763.966990] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[ 3763.966992] sdhci: =========== REGISTER DUMP (mmc0)===========
[ 3763.966998] sdhci: Sys addr: 0xffe05000 | Version:  0x00000502
[ 3763.967004] sdhci: Blk size: 0x00007200 | Blk cnt:  0x00000008
[ 3763.967010] sdhci: Argument: 0x00000000 | Trn mode: 0x00000033
[ 3763.967015] sdhci: Present:  0x01ff0207 | Host ctl: 0x00000007
[ 3763.967020] sdhci: Power:    0x0000000f | Blk gap:  0x00000000
[ 3763.967026] sdhci: Wake-up:  0x00000000 | Clock:    0x00000107
[ 3763.967031] sdhci: Timeout:  0x00000009 | Int stat: 0x00000000
[ 3763.967036] sdhci: Int enab: 0x02ff008b | Sig enab: 0x02ff008b
[ 3763.967042] sdhci: AC12 err: 0x00000000 | Slot int: 0x00000000
[ 3763.967048] sdhci: Caps:     0x21e8c8b2 | Caps_1:   0x00008073
[ 3763.967053] sdhci: Cmd:      0x0000123a | Max curr: 0x00000040
[ 3763.967057] sdhci: Host ctl2: 0x00000000
[ 3763.967058] sdhci: ===========================================
[ 3763.967072] mmc0: req done (CMD18): -110: 00000000 00000000 00000000 00000000
[ 3763.967073] mmc0:     0 bytes transferred: 0
[ 3763.967074] mmc0:     (CMD12): 0: 00000000 00000000 00000000 00000000
[ 3763.967076] mmc0: starting CMD13 arg b3680000 flags 00000195
[ 3763.967092] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[ 3763.967093] sdhci: =========== REGISTER DUMP (mmc0)===========
[ 3763.967097] sdhci: Sys addr: 0xffe05000 | Version:  0x00000502
[ 3763.967102] sdhci: Blk size: 0x00007200 | Blk cnt:  0x00000008
[ 3763.967106] sdhci: Argument: 0xb3680000 | Trn mode: 0x00000033
[ 3763.967111] sdhci: Present:  0x01ff0001 | Host ctl: 0x00000007
[ 3763.967116] sdhci: Power:    0x0000000f | Blk gap:  0x00000000
[ 3763.967120] sdhci: Wake-up:  0x00000000 | Clock:    0x00000107
[ 3763.967125] sdhci: Timeout:  0x00000009 | Int stat: 0x00000000
[ 3763.967130] sdhci: Int enab: 0x02ff008b | Sig enab: 0x02ff008b
[ 3763.967134] sdhci: AC12 err: 0x00000000 | Slot int: 0x00000000
[ 3763.967139] sdhci: Caps:     0x21e8c8b2 | Caps_1:   0x00008073
[ 3763.967143] sdhci: Cmd:      0x00000d1a | Max curr: 0x00000040
[ 3763.967146] sdhci: Host ctl2: 0x00000000
[ 3763.967147] sdhci: ===========================================
[ 3763.967160] mmc0: req done (CMD13): -110: 00000000 00000000 00000000 00000000
[ 3763.967163] mmcblk0: error -110 sending status command, retrying
[ 3763.967165] mmc0: starting CMD13 arg b3680000 flags 00000195
[ 3763.967182] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[ 3763.967185] sdhci: =========== REGISTER DUMP (mmc0)===========
[ 3763.967190] sdhci: Sys addr: 0xffe05000 | Version:  0x00000502
[ 3763.967195] sdhci: Blk size: 0x00007200 | Blk cnt:  0x00000008
[ 3763.967200] sdhci: Argument: 0xb3680000 | Trn mode: 0x00000033
[ 3763.967206] sdhci: Present:  0x01ff0001 | Host ctl: 0x00000007
[ 3763.967211] sdhci: Power:    0x0000000f | Blk gap:  0x00000000
[ 3763.967217] sdhci: Wake-up:  0x00000000 | Clock:    0x00000107
[ 3763.967223] sdhci: Timeout:  0x00000009 | Int stat: 0x00000000
[ 3763.967228] sdhci: Int enab: 0x02ff008b | Sig enab: 0x02ff008b
[ 3763.967234] sdhci: AC12 err: 0x00000000 | Slot int: 0x00000000
[ 3763.967240] sdhci: Caps:     0x21e8c8b2 | Caps_1:   0x00008073
[ 3763.967246] sdhci: Cmd:      0x00000d1a | Max curr: 0x00000040
[ 3763.967250] sdhci: Host ctl2: 0x00000000
[ 3763.967251] sdhci: ===========================================
[ 3763.967264] mmc0: req done (CMD13): -110: 00000000 00000000 00000000 00000000
[ 3763.967268] mmcblk0: error -110 sending status command, retrying
[ 3763.967270] mmc0: starting CMD13 arg b3680000 flags 00000195
[ 3763.967287] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[ 3763.967289] sdhci: =========== REGISTER DUMP (mmc0)===========
[ 3763.967295] sdhci: Sys addr: 0xffe05000 | Version:  0x00000502
[ 3763.967299] sdhci: Blk size: 0x00007200 | Blk cnt:  0x00000008
[ 3763.967304] sdhci: Argument: 0xb3680000 | Trn mode: 0x00000033
[ 3763.967309] sdhci: Present:  0x01ff0001 | Host ctl: 0x00000007
[ 3763.967313] sdhci: Power:    0x0000000f | Blk gap:  0x00000000
[ 3763.967318] sdhci: Wake-up:  0x00000000 | Clock:    0x00000107
[ 3763.967322] sdhci: Timeout:  0x00000009 | Int stat: 0x00000000
[ 3763.967327] sdhci: Int enab: 0x02ff008b | Sig enab: 0x02ff008b
[ 3763.967332] sdhci: AC12 err: 0x00000000 | Slot int: 0x00000000
[ 3763.967337] sdhci: Caps:     0x21e8c8b2 | Caps_1:   0x00008073
[ 3763.967342] sdhci: Cmd:      0x00000d1a | Max curr: 0x00000040
[ 3763.967345] sdhci: Host ctl2: 0x00000000
[ 3763.967345] sdhci: ===========================================
[ 3763.967358] mmc0: req done (CMD13): -110: 00000000 00000000 00000000 00000000
[ 3763.967360] mmcblk0: error -110 sending status command, aborting
[ 3763.967362] end_request: I/O error, dev mmcblk0, sector 0
[ 3763.967390] mmc0: starting CMD18 arg 00000000 flags 000000b5
[ 3763.967392] mmc0:     blksz 512 blocks 8 flags 00000200 tsac 100 ms nsac 0
[ 3763.967394] mmc0:     CMD12 arg 00000000 flags 0000049d
[ 3763.967417] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[ 3763.967419] sdhci: =========== REGISTER DUMP (mmc0)===========
[ 3763.967424] sdhci: Sys addr: 0xffe04000 | Version:  0x00000502
[ 3763.967429] sdhci: Blk size: 0x00007200 | Blk cnt:  0x00000008
[ 3763.967435] sdhci: Argument: 0x00000000 | Trn mode: 0x00000033
[ 3763.967441] sdhci: Present:  0x01ff0207 | Host ctl: 0x00000007
[ 3763.967446] sdhci: Power:    0x0000000f | Blk gap:  0x00000000
[ 3763.967452] sdhci: Wake-up:  0x00000000 | Clock:    0x00000107
[ 3763.967457] sdhci: Timeout:  0x00000009 | Int stat: 0x00000000
[ 3763.967463] sdhci: Int enab: 0x02ff008b | Sig enab: 0x02ff008b
[ 3763.967469] sdhci: AC12 err: 0x00000000 | Slot int: 0x00000000
[ 3763.967474] sdhci: Caps:     0x21e8c8b2 | Caps_1:   0x00008073
[ 3763.967480] sdhci: Cmd:      0x0000123a | Max curr: 0x00000040
[ 3763.967484] sdhci: Host ctl2: 0x00000000
[ 3763.967485] sdhci: ===========================================
[ 3763.967499] mmc0: req done (CMD18): -110: 00000000 00000000 00000000 00000000
[ 3763.967501] mmc0:     0 bytes transferred: 0
[ 3763.967503] mmc0:     (CMD12): 0: 00000000 00000000 00000000 00000000
[ 3763.967506] mmc0: starting CMD13 arg b3680000 flags 00000195
[ 3763.967522] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[ 3763.967523] sdhci: =========== REGISTER DUMP (mmc0)===========
[ 3763.967529] sdhci: Sys addr: 0xffe04000 | Version:  0x00000502
[ 3763.967534] sdhci: Blk size: 0x00007200 | Blk cnt:  0x00000008
[ 3763.967539] sdhci: Argument: 0xb3680000 | Trn mode: 0x00000033
[ 3763.967543] sdhci: Present:  0x01ff0001 | Host ctl: 0x00000007
[ 3763.967548] sdhci: Power:    0x0000000f | Blk gap:  0x00000000
[ 3763.967552] sdhci: Wake-up:  0x00000000 | Clock:    0x00000107
[ 3763.967557] sdhci: Timeout:  0x00000009 | Int stat: 0x00000000
[ 3763.967562] sdhci: Int enab: 0x02ff008b | Sig enab: 0x02ff008b
[ 3763.967567] sdhci: AC12 err: 0x00000000 | Slot int: 0x00000000
[ 3763.967572] sdhci: Caps:     0x21e8c8b2 | Caps_1:   0x00008073
[ 3763.967576] sdhci: Cmd:      0x00000d1a | Max curr: 0x00000040
[ 3763.967579] sdhci: Host ctl2: 0x00000000
[ 3763.967580] sdhci: ===========================================
[ 3763.967595] mmc0: req done (CMD13): -110: 00000000 00000000 00000000 00000000
[ 3763.967598] mmcblk0: error -110 sending status command, retrying
[ 3763.967599] mmc0: starting CMD13 arg b3680000 flags 00000195
[ 3763.967615] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[ 3763.967617] sdhci: =========== REGISTER DUMP (mmc0)===========
[ 3763.967622] sdhci: Sys addr: 0xffe04000 | Version:  0x00000502
[ 3763.967628] sdhci: Blk size: 0x00007200 | Blk cnt:  0x00000008
[ 3763.967633] sdhci: Argument: 0xb3680000 | Trn mode: 0x00000033
[ 3763.967639] sdhci: Present:  0x01ff0001 | Host ctl: 0x00000007
[ 3763.967645] sdhci: Power:    0x0000000f | Blk gap:  0x00000000
[ 3763.967650] sdhci: Wake-up:  0x00000000 | Clock:    0x00000107
[ 3763.967656] sdhci: Timeout:  0x00000009 | Int stat: 0x00000000
[ 3763.967661] sdhci: Int enab: 0x02ff008b | Sig enab: 0x02ff008b
[ 3763.967667] sdhci: AC12 err: 0x00000000 | Slot int: 0x00000000
[ 3763.967673] sdhci: Caps:     0x21e8c8b2 | Caps_1:   0x00008073
[ 3763.967678] sdhci: Cmd:      0x00000d1a | Max curr: 0x00000040
[ 3763.967681] sdhci: Host ctl2: 0x00000000
[ 3763.967683] sdhci: ===========================================
[ 3763.967696] mmc0: req done (CMD13): -110: 00000000 00000000 00000000 00000000
[ 3763.967700] mmcblk0: error -110 sending status command, retrying
[ 3763.967702] mmc0: starting CMD13 arg b3680000 flags 00000195
[ 3763.967719] sdhci [sdhci_irq()]: *** mmc0 got interrupt: 0x00018000
[ 3763.967721] sdhci: =========== REGISTER DUMP (mmc0)===========
[ 3763.967726] sdhci: Sys addr: 0xffe04000 | Version:  0x00000502
[ 3763.967732] sdhci: Blk size: 0x00007200 | Blk cnt:  0x00000008
[ 3763.967738] sdhci: Argument: 0xb3680000 | Trn mode: 0x00000033
[ 3763.967744] sdhci: Present:  0x01ff0001 | Host ctl: 0x00000007
[ 3763.967749] sdhci: Power:    0x0000000f | Blk gap:  0x00000000
[ 3763.967754] sdhci: Wake-up:  0x00000000 | Clock:    0x00000107
[ 3763.967758] sdhci: Timeout:  0x00000009 | Int stat: 0x00000000
[ 3763.967763] sdhci: Int enab: 0x02ff008b | Sig enab: 0x02ff008b
[ 3763.967767] sdhci: AC12 err: 0x00000000 | Slot int: 0x00000000
[ 3763.967772] sdhci: Caps:     0x21e8c8b2 | Caps_1:   0x00008073
[ 3763.967776] sdhci: Cmd:      0x00000d1a | Max curr: 0x00000040
[ 3763.967779] sdhci: Host ctl2: 0x00000000
[ 3763.967780] sdhci: ===========================================
[ 3763.967793] mmc0: req done (CMD13): -110: 00000000 00000000 00000000 00000000
[ 3763.967795] mmcblk0: error -110 sending status command, aborting
[ 3763.967797] end_request: I/O error, dev mmcblk0, sector 0


	J

