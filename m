Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752955Ab1IFWZB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Sep 2011 18:25:01 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:53660 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750958Ab1IFWY4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Sep 2011 18:24:56 -0400
MIME-Version: 1.0
In-Reply-To: <CAC9WiBg8ecC0oborzCH=0oaok2FK7QvZhV_UNAxFPkVJ+wFP=Q@mail.gmail.com>
References: <CAC9WiBg8ecC0oborzCH=0oaok2FK7QvZhV_UNAxFPkVJ+wFP=Q@mail.gmail.com>
Date: Tue, 6 Sep 2011 18:24:55 -0400
Message-ID: <CAOULuOb41-TZuN=kj6whg_wn4cw3k01K3aHJ_X9Ha4iTD3ainw@mail.gmail.com>
Subject: Re: Some issues/regression when upgrading to 3.1-rc5
From: Parag Warudkar <parag.lkml@gmail.com>
To: Francis Moreau <francis.moro@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 6, 2011 at 5:15 PM, Francis Moreau <francis.moro@gmail.com> wrote:
>
> [   13.335961] cfg80211: Calling CRDA to update world regulatory domain
> [   13.386127] b43-phy0: Broadcom 4313 WLAN found (core revision 24)
> [   13.510112] bcma: PLL enable timeout
> [   13.510125] b43-phy0 ERROR: FOUND UNSUPPORTED PHY (Analog 10, Type
> 8, Revision 1)
> [   13.510148] b43: probe of bcma0:0 failed with error -95
> [   13.510194] Broadcom 43xx driver loaded [ Features: PMNLS,
> Firmware-ID: FW13 ]

Sounds like with 3.x kernel the bcma/b43 combo is getting loaded which
doesn't support your wireless card.
While earlier on brcmsmac was getting loaded which did support your hardware.

You can try either disabling or blacklisting b43/bcma and only loading brcmsmac.

Unsure about the sound.

Parag

>
> whereas with 2.6.39 I had:
>
> [   13.580317] brcmsmac: module is from the staging directory, the
> quality is unknown, you have been warned.
> [   13.583668] brcmsmac 0000:12:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
> [   13.583676] brcmsmac 0000:12:00.0: setting latency timer to 64
>
> and the wireless network was working fine.
>
> Another point is that I can see now a lot of the following message:
>
> [   13.910324] hda_codec: too deep connection for 0x18
> [   13.910473] hda_codec: too deep connection for 0x18
> [   13.910560] hda_codec: too deep connection for 0x18
> [   13.910562] hda_codec: too deep connection for 0x18
> [   13.910563] hda_codec: too deep connection for 0x18
> ...
> [   13.911401] hda_codec: too deep connection for 0x11
> [   13.911407] autoconfig: line_outs=1 (0xd/0x0/0x0/0x0/0x0) type:speaker
> [   13.911409]    speaker_outs=0 (0x0/0x0/0x0/0x0/0x0)
> [   13.911410]    hp_outs=1 (0xb/0x0/0x0/0x0/0x0)
> [   13.911411]    mono: mono_out=0x0
> [   13.911412]    inputs: Mic=0xa
> [   13.911686] stac92xx: dac_nids=1 (0x13/0x0/0x0/0x0/0x0)
> [   13.911988] hda_codec: too deep connection for 0x17
> [   13.911989] hda_codec: too deep connection for 0x17
> ...
>
> however the sound is still working.
>
> Hope someone can help me.
>
> Thanks
> --
> Francis
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
>
>
