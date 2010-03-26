Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752766Ab0CZRZZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Mar 2010 13:25:25 -0400
Received: from mail-fx0-f223.google.com ([209.85.220.223]:62717 "EHLO
	mail-fx0-f223.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751426Ab0CZRZY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Mar 2010 13:25:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=RYSaTINvxR8+KPL/ZpRQOE3PV8vQOpVKIHtk4WRTFo2Okop4S9Yc5xVbJ2pR2Sd36t
         /HND8RqFBymzBoIbIiCAy0WUX5HCN4QzVIZ5G72ldEaEGWI7FsIJt9/PzPd762LGUPzJ
         qgN/ZV11eGDCJDXjzSA0aJUOIAqrzf23565yM=
MIME-Version: 1.0
Date: Fri, 26 Mar 2010 18:25:22 +0100
Message-ID: <64bb37e1003261025l14e2d82r64ba1e90d024bea6@mail.gmail.com>
Subject: Regressions: MSI vs HDA-Intel
From: Torsten Kaiser <just.for.lkml@googlemail.com>
To: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
       alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have two systems that use the alsa hda-intel driver, both show
regressions in relation to MSI.

System 1: Athlon(tm) X2 BE-2400 with an AMD RS690/SB600 chipset
00:14.2 Audio device [0403]: ATI Technologies Inc SBx00 Azalia (Intel
HDA) [1002:4383]
(Mainboard is a MSI MS-7368)

After upgrading from 2.6.31 to 2.6.33 I get a delay during bootup:
[    1.155925] HDA Intel 0000:00:14.2: PCI INT A -> GSI 16 (level,
low) -> IRQ 16
[    1.159143] input: AT Translated Set 2 keyboard as
/devices/platform/i8042/serio0/input/input2
[    1.232595] firewire_core: created device fw0: GUID 00dc10000129c48f, S400
[    1.252677] hda_codec: ALC888: BIOS auto-probing.
[    1.259226] HDA Intel 0000:01:05.2: PCI INT B -> GSI 19 (level,
low) -> IRQ 19
[    1.260293] HDA Intel 0000:01:05.2: irq 27 for MSI/MSI-X
[    1.314712] input: GenPS/2 Genius Mouse as
/devices/platform/i8042/serio1/input/input3
[    4.322508] hda-intel: azx_get_response timeout, switching to
polling mode: last cmd=0x000f0000
[    5.332508] hda-intel: No response from codec, disabling MSI: last
cmd=0x000f0000
[    6.342508] hda-intel: Codec #0 probe error; disabling it...
[    7.392508] hda_intel: azx_get_response timeout, switching to
single_cmd mode: last cmd=0x000f0000
[    7.430464] ALSA device list:
[    7.431549]   #0: HDA ATI SB at 0xfe7f4000 irq 16
[    7.432656]   #1: HDA ATI HDMI at 0xfe9e8000 irq 27

2.6.34-rc2 does not boot on this system, something related to the new
bootmem allocator, so I can't say if this might already be fixed for
2.6.34.

Should the system be blacklisted like the two Asus Athlon X2 boards,
or is this some other bug?


System 2: Opteron(tm) 2218 with an nVidia MCP55 chipset
00:06.1 Audio device [0403]: nVidia Corporation MCP55 High Definition
Audio [10de:0371] (rev a2)
(Mainboard is an ASUS KFN5-D SLI)

Commit 80c43ed724797627d8f86855248c497a6161a214 disabled MSI for this
system, but the MSI mode was working fine for all 2.6.33 versions I
used.

Should the generic blacklist disable MSI for all Athlon X2 instead of
all nNvidia chipsets?


If you need more information, please ask, I will try to provide
anything you need.

Thanks, Torsten
