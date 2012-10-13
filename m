Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754061Ab2JMTRu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2012 15:17:50 -0400
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.120]:32637 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754027Ab2JMTRt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2012 15:17:49 -0400
X-Authority-Analysis: v=2.0 cv=Dp3UCRD+ c=1 sm=0 a=YPDeGStqRoQnMAluW+pq4Q==:17 a=65KWcu232dMA:10 a=h9GbcFHyNoYA:10 a=DpEkYpXRGzUA:10 a=05ChyHeVI94A:10 a=IkcTkHD0fZMA:10 a=ayC55rCoAAAA:8 a=nULq49Tkjo8A:10 a=LN7EJh0wAAAA:8 a=JZkw4t6ntCqZGzDCqOIA:9 a=QEXdDO2ut3YA:10 a=1N10a5YcSQUA:10 a=YPDeGStqRoQnMAluW+pq4Q==:117
X-Cloudmark-Score: 0
X-Originating-IP: 50.89.247.146
Message-ID: <5079BE5C.8020401@cfl.rr.com>
Date: Sat, 13 Oct 2012 15:17:48 -0400
From: Mark Hounschell <dmarkh@cfl.rr.com>
Reply-To: dmarkh@cfl.rr.com
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:15.0) Gecko/20120825 Thunderbird/15.0
MIME-Version: 1.0
To: dmarkh@cfl.rr.com
CC: =?UTF-8?B?QnJ1bm8gUHLDqW1vbnQ=?= <bonbons@linux-vserver.org>,
        markh@compro.net, linux-kernel@vger.kernel.org,
        Intel Graphics Development <intel-gfx@lists.freedesktop.org>
Subject: Re: Intel graphics drm issue?
References: <507812E8.3060607@compro.net> <20121012231459.166e29fd@neptune.home> <5079B97C.7020401@cfl.rr.com>
In-Reply-To: <5079B97C.7020401@cfl.rr.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/13/2012 02:57 PM, Mark Hounschell wrote:
> Hi Bruno,
>
> Thanks for the response.
>
> On 10/12/2012 05:14 PM, Bruno Prémont wrote:
>> Hi Mark,
>>
>> [CCing intel-gfx]
>>
>> On Fri, 12 October 2012 Mark Hounschell <markh@compro.net> wrote:
>>> Not sure this is the correct place to ask about a possible drm issue. I
>>> have an intel based PC with an HDMI port that I'm trying to connect to
>>> an LG TV. I have successfully used this HDMI port connected to an Optima
>>> projector. Using that projector, everything from the BIOS post, BIOS
>>> configuration, and all the way up to a graphical login worked just fine.
>>> The same HDMI port and cable connected to this TV gives me the below
>>> messages during boot. I also get no BIOS post or BIOS configuration
>>> output while in the BIOS. I have a monitor connected to the DVI port so
>>> I can see what I should see on the TV there, just as when I was
>>> connected to the Optima projector. That alone makes me pretty sure it's
>>> not a kernel issue but here are the messages anyway. Maybe they will
>>> give someone a hint as to what the problem may be, in the case they
>>> might be willing to give me any pointers.
>>>
>>> TV - LG 42lb9df
>>> PC - intel DH77DF motherboard
>>
>>> [    0.000000] Linux version 3.4.10-lcrs (root@geexbox) (gcc version
>>> 4.7.1 20120723 [gcc-4_7-branch revision 189773] (SUSE Linux) ) #1 SMP
>>> PREEMPT Wed Oct 10 16:16:16 EDT 2012
>>> ...
>>> [    1.897955] [drm] MTRR allocation failed.  Graphics performance may
>>> suffer.
>>> [    1.898045] i915 0000:00:02.0: irq 43 for MSI/MSI-X
>>> [    1.898050] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
>>> [    1.898051] [drm] Driver supports precise vblank timestamp query.
>>> [    1.898084] [drm:intel_dsm_platform_mux_info] *ERROR* MUX INFO call
>>> failed
>>> [    1.898737] vgaarb: device changed decodes:
>>> PCI:0000:00:02.0,olddecodes=io+mem,decodes=io+mem:owns=io+mem
>>> [    1.995523] [drm] Enabling RC6 states: RC6 on, RC6p on, RC6pp off
>>> [    2.299535] [drm:drm_edid_block_valid] *ERROR* EDID checksum is
>>> invalid, remainder is 128
>>> [    2.299865] Raw EDID:
>>> [    2.299957]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>>> [    2.300188]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>>> [    2.300418]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>>> [    2.300648]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>>> [    2.300879]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>>> [    2.301109]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>>> [    2.301339]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>>> [    2.301569]          ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>>
>> This looks like your LG TV either does not provide EDID information via HDMI
>> connector, or otherwise behaves in a special way which makes reading EDID
>> fail.
>>
>> Did you try the TV on some other computer to check if EDID can be read there
>> (e.g. with nvidia/amd GPU and matching open/closed driver)?
>>
>> Also make sure the TV is on (neither off nor on stand-by) as some TVs
>> disable too much of connector interface in those states.
>>
>
> I have another AMD based PC here with an nvidia card and HDMI port. Using
> the nvidia driver, it boots up with no output to the tv until X starts.
> Once X starts I get my kdm login screen. All is well except the resolution
> is 800x600 and I have no VTs. I suspect if I had a properly configured
> xorg.conf file, my resolution would be what I defined in it and work.
>
> Using the nouveau driver, I get nothing but "no signal" on the tv.  Just
> like the the intel box, except no EDID messages in the log file. I've
> attached a dmesg outputs for each config.
>
> Back on the Intel machine. I boot up with a normal monitor connected to the
> DVI port of the PC. Then at the kdm login screen, I disconnect the DVI
> cable from the PC and connect the TV to the PCs DVI port using a DVI/HDMI
> adapter. I get a beautiful 1600x1200 resolution screen on the TV. This does
> not happen using the PC HDMI port.
>

One other thing I failed to mention. If i connect the TV HDMI to the Intel 
boards DVI port using the adapter, at power up I get all the BIOS messages 
and can enter the BIOS and all is fine. But when I let it boot all the way 
up like this, I get nothing but "no signal" after leaving BIOS mode. 
Turning the tv on/off, cable plug/unplug does not help.

Mark

> I have no control over the tv with regards to stand-by mode. Off is standby
> mode, on is on.
>
>>> [    2.434378] i915 0000:00:02.0: HDMI-A-3: EDID block 0 invalid.
>>> [    2.477539] checking generic (e0000000 3ff0000) vs hw (e0000000
>>> 10000000)
>>> [    2.477541] fb: conflicting fb hw usage inteldrmfb vs VESA VGA -
>>> removing generic driver
>>> [    2.477549] Console: switching to colour dummy device 80x25
>>> [    2.477831] fbcon: inteldrmfb (fb0) is primary device
>>> [    2.637915] Console: switching to colour frame buffer device 128x48
>>> [    2.679625] fb0: inteldrmfb frame buffer device
>>> [    2.679626] drm: registered panic notifier
>>> [    2.691536] acpi device:4b: registered as cooling_device9
>>> [    2.691660] input: Video Bus as
>>> /devices/LNXSYSTM:00/device:00/PNP0A08:00/LNXVIDEO:00/input/input4
>>> [    2.691698] ACPI: Video Device [GFX0] (multi-head: yes  rom: no
>>> post: no)
>>> [    2.691709] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on
>>> minor 0
>>
>>> geexbox:/home/mplayer # lspci
>>> 00:00.0 Host bridge: Intel Corporation Xeon E3-1200 v2/3rd Gen Core
>>> processor DRAM Controller (rev 09)
>>> ...
>>> 00:02.0 VGA compatible controller: Intel Corporation Xeon E3-1200 v2/3rd
>>> Gen Core processor Graphics Controller (rev 09)
>>> ...
>>
>> Note, usually `lspci -nn` is more informative as it also provides
>> vendor/device
>> IDs in addition to nice names.
>
> # lspci -nn
> 00:00.0 Host bridge [0600]: Intel Corporation Xeon E3-1200 v2/3rd Gen Core
> processor DRAM Controller [8086:0150] (rev 09)
> 00:01.0 PCI bridge [0604]: Intel Corporation Xeon E3-1200 v2/3rd Gen Core
> processor PCI Express Root Port [8086:0151] (rev 09)
> 00:02.0 VGA compatible controller [0300]: Intel Corporation Xeon E3-1200
> v2/3rd Gen Core processor Graphics Controller [8086:0162] (rev 09)
> 00:14.0 USB controller [0c03]: Intel Corporation 7 Series/C210 Series
> Chipset Family USB xHCI Host Controller [8086:1e31] (rev 04)
> 00:16.0 Communication controller [0780]: Intel Corporation 7 Series/C210
> Series Chipset Family MEI Controller #1 [8086:1e3a] (rev 04)
> 00:19.0 Ethernet controller [0200]: Intel Corporation 82579V Gigabit
> Network Connection [8086:1503] (rev 04)
> 00:1a.0 USB controller [0c03]: Intel Corporation 7 Series/C210 Series
> Chipset Family USB Enhanced Host Controller #2 [8086:1e2d] (rev 04)
> 00:1c.0 PCI bridge [0604]: Intel Corporation 7 Series/C210 Series Chipset
> Family PCI Express Root Port 1 [8086:1e10] (rev c4)
> 00:1c.7 PCI bridge [0604]: Intel Corporation 7 Series/C210 Series Chipset
> Family PCI Express Root Port 8 [8086:1e1e] (rev c4)
> 00:1d.0 USB controller [0c03]: Intel Corporation 7 Series/C210 Series
> Chipset Family USB Enhanced Host Controller #1 [8086:1e26] (rev 04)
> 00:1f.0 ISA bridge [0601]: Intel Corporation H77 Express Chipset LPC
> Controller [8086:1e4a] (rev 04)
> 00:1f.2 SATA controller [0106]: Intel Corporation 7 Series/C210 Series
> Chipset Family 6-port SATA Controller [AHCI mode] [8086:1e02] (rev 04)
> 00:1f.3 SMBus [0c05]: Intel Corporation 7 Series/C210 Series Chipset Family
> SMBus Controller [8086:1e22] (rev 04)
> 01:00.0 PCI bridge [0604]: PLX Technology, Inc. PEX8112 x1 Lane PCI
> Express-to-PCI Bridge [10b5:8112] (rev aa)
> 02:04.0 Multimedia audio controller [0401]: C-Media Electronics Inc CMI8788
> [Oxygen HD Audio] [13f6:8788]
>
>
> I can do more to help if asked.
>
> Regards
> Mark


