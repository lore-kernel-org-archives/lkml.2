Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752191Ab2JLVQH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 17:16:07 -0400
Received: from smtprelay.restena.lu ([158.64.1.62]:52854 "EHLO
	smtprelay.restena.lu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751577Ab2JLVQF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 17:16:05 -0400
Date: Fri, 12 Oct 2012 23:14:59 +0200
From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
To: markh@compro.net
Cc: linux-kernel@vger.kernel.org, Mark Hounschell <dmarkh@cfl.rr.com>,
        Intel Graphics Development <intel-gfx@lists.freedesktop.org>
Subject: Re: Intel graphics drm issue?
Message-ID: <20121012231459.166e29fd@neptune.home>
In-Reply-To: <507812E8.3060607@compro.net>
References: <507812E8.3060607@compro.net>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.12; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

[CCing intel-gfx]

On Fri, 12 October 2012 Mark Hounschell <markh@compro.net> wrote:
> Not sure this is the correct place to ask about a possible drm issue. I 
> have an intel based PC with an HDMI port that I'm trying to connect to 
> an LG TV. I have successfully used this HDMI port connected to an Optima 
> projector. Using that projector, everything from the BIOS post, BIOS 
> configuration, and all the way up to a graphical login worked just fine. 
> The same HDMI port and cable connected to this TV gives me the below 
> messages during boot. I also get no BIOS post or BIOS configuration 
> output while in the BIOS. I have a monitor connected to the DVI port so 
> I can see what I should see on the TV there, just as when I was 
> connected to the Optima projector. That alone makes me pretty sure it's 
> not a kernel issue but here are the messages anyway. Maybe they will 
> give someone a hint as to what the problem may be, in the case they 
> might be willing to give me any pointers.
> 
> TV - LG 42lb9df
> PC - intel DH77DF motherboard

> [    0.000000] Linux version 3.4.10-lcrs (root@geexbox) (gcc version 4.7.1 20120723 [gcc-4_7-branch revision 189773] (SUSE Linux) ) #1 SMP PREEMPT Wed Oct 10 16:16:16 EDT 2012
> ...
> [    1.897955] [drm] MTRR allocation failed.  Graphics performance may suffer.
> [    1.898045] i915 0000:00:02.0: irq 43 for MSI/MSI-X
> [    1.898050] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
> [    1.898051] [drm] Driver supports precise vblank timestamp query.
> [    1.898084] [drm:intel_dsm_platform_mux_info] *ERROR* MUX INFO call failed
> [    1.898737] vgaarb: device changed decodes: PCI:0000:00:02.0,olddecodes=io+mem,decodes=io+mem:owns=io+mem
> [    1.995523] [drm] Enabling RC6 states: RC6 on, RC6p on, RC6pp off
> [    2.299535] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 128
> [    2.299865] Raw EDID:
> [    2.299957]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> [    2.300188]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> [    2.300418]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> [    2.300648]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> [    2.300879]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> [    2.301109]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> [    2.301339]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> [    2.301569]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff

This looks like your LG TV either does not provide EDID information via HDMI
connector, or otherwise behaves in a special way which makes reading EDID
fail.

Did you try the TV on some other computer to check if EDID can be read there
(e.g. with nvidia/amd GPU and matching open/closed driver)?

Also make sure the TV is on (neither off nor on stand-by) as some TVs
disable too much of connector interface in those states.

> [    2.434378] i915 0000:00:02.0: HDMI-A-3: EDID block 0 invalid.
> [    2.477539] checking generic (e0000000 3ff0000) vs hw (e0000000 10000000)
> [    2.477541] fb: conflicting fb hw usage inteldrmfb vs VESA VGA - removing generic driver
> [    2.477549] Console: switching to colour dummy device 80x25
> [    2.477831] fbcon: inteldrmfb (fb0) is primary device
> [    2.637915] Console: switching to colour frame buffer device 128x48
> [    2.679625] fb0: inteldrmfb frame buffer device
> [    2.679626] drm: registered panic notifier
> [    2.691536] acpi device:4b: registered as cooling_device9
> [    2.691660] input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A08:00/LNXVIDEO:00/input/input4
> [    2.691698] ACPI: Video Device [GFX0] (multi-head: yes  rom: no  post: no)
> [    2.691709] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0

> geexbox:/home/mplayer # lspci
> 00:00.0 Host bridge: Intel Corporation Xeon E3-1200 v2/3rd Gen Core processor DRAM Controller (rev 09)
> ...
> 00:02.0 VGA compatible controller: Intel Corporation Xeon E3-1200 v2/3rd Gen Core processor Graphics Controller (rev 09)
> ...

Note, usually `lspci -nn` is more informative as it also provides vendor/device
IDs in addition to nice names.

Bruno
