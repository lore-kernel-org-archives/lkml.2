Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755248Ab1IFVPw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Sep 2011 17:15:52 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:35085 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752425Ab1IFVPr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Sep 2011 17:15:47 -0400
MIME-Version: 1.0
Date: Tue, 6 Sep 2011 23:15:46 +0200
Message-ID: <CAC9WiBg8ecC0oborzCH=0oaok2FK7QvZhV_UNAxFPkVJ+wFP=Q@mail.gmail.com>
Subject: Some issues/regression when upgrading to 3.1-rc5
From: Francis Moreau <francis.moro@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I was using the old good 2.6.39 and decided to make a jump to the last
kernel, namely 3.1-rc5.

After booting the new beast, I've got at least 2 issues:

  - My wireless card doesn't work anymore. It was previously driven by
brcmsmac module but for some reasons it now uses the b43 driver.
Here's the corresponding kernel log I can see:

[   13.335961] cfg80211: Calling CRDA to update world regulatory domain
[   13.386127] b43-phy0: Broadcom 4313 WLAN found (core revision 24)
[   13.510112] bcma: PLL enable timeout
[   13.510125] b43-phy0 ERROR: FOUND UNSUPPORTED PHY (Analog 10, Type
8, Revision 1)
[   13.510148] b43: probe of bcma0:0 failed with error -95
[   13.510194] Broadcom 43xx driver loaded [ Features: PMNLS,
Firmware-ID: FW13 ]

whereas with 2.6.39 I had:

[   13.580317] brcmsmac: module is from the staging directory, the
quality is unknown, you have been warned.
[   13.583668] brcmsmac 0000:12:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[   13.583676] brcmsmac 0000:12:00.0: setting latency timer to 64

and the wireless network was working fine.

Another point is that I can see now a lot of the following message:

[   13.910324] hda_codec: too deep connection for 0x18
[   13.910473] hda_codec: too deep connection for 0x18
[   13.910560] hda_codec: too deep connection for 0x18
[   13.910562] hda_codec: too deep connection for 0x18
[   13.910563] hda_codec: too deep connection for 0x18
...
[   13.911401] hda_codec: too deep connection for 0x11
[   13.911407] autoconfig: line_outs=1 (0xd/0x0/0x0/0x0/0x0) type:speaker
[   13.911409]    speaker_outs=0 (0x0/0x0/0x0/0x0/0x0)
[   13.911410]    hp_outs=1 (0xb/0x0/0x0/0x0/0x0)
[   13.911411]    mono: mono_out=0x0
[   13.911412]    inputs: Mic=0xa
[   13.911686] stac92xx: dac_nids=1 (0x13/0x0/0x0/0x0/0x0)
[   13.911988] hda_codec: too deep connection for 0x17
[   13.911989] hda_codec: too deep connection for 0x17
...

however the sound is still working.

Hope someone can help me.

Thanks
-- 
Francis
