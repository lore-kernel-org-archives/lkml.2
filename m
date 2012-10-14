Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752605Ab2JNKe6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2012 06:34:58 -0400
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.120]:16705 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752338Ab2JNKe5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2012 06:34:57 -0400
X-Authority-Analysis: v=2.0 cv=EOyEIilC c=1 sm=0 a=YPDeGStqRoQnMAluW+pq4Q==:17 a=65KWcu232dMA:10 a=h9GbcFHyNoYA:10 a=DpEkYpXRGzUA:10 a=05ChyHeVI94A:10 a=IkcTkHD0fZMA:10 a=ayC55rCoAAAA:8 a=nULq49Tkjo8A:10 a=eKWvBVOvAAAA:8 a=jyj_SigjoFlB_d4ZaxwA:9 a=QEXdDO2ut3YA:10 a=YPDeGStqRoQnMAluW+pq4Q==:117
X-Cloudmark-Score: 0
X-Originating-IP: 50.89.247.146
Message-ID: <507A9550.1060309@cfl.rr.com>
Date: Sun, 14 Oct 2012 06:34:56 -0400
From: Mark Hounschell <dmarkh@cfl.rr.com>
Reply-To: dmarkh@cfl.rr.com
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:15.0) Gecko/20120825 Thunderbird/15.0
MIME-Version: 1.0
To: =?UTF-8?B?QnJ1bm8gUHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
CC: markh@compro.net, linux-kernel@vger.kernel.org,
        Intel Graphics Development <intel-gfx@lists.freedesktop.org>
Subject: Re: Intel graphics drm issue?
References: <507812E8.3060607@compro.net> <20121012231459.166e29fd@neptune.home> <5079B97C.7020401@cfl.rr.com> <5079BE5C.8020401@cfl.rr.com> <20121014104138.7e8a9c59@neptune.home>
In-Reply-To: <20121014104138.7e8a9c59@neptune.home>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/14/2012 04:41 AM, Bruno Prémont wrote:
> Hi Mark,
>
> On Sat, 13 October 2012 Mark Hounschell <dmarkh@cfl.rr.com> wrote:
>> On 10/13/2012 02:57 PM, Mark Hounschell wrote:
>>> On 10/12/2012 05:14 PM, Bruno Prémont wrote:
>>>>> TV - LG 42lb9df
>>>>> PC - intel DH77DF motherboard
>>>>
>>> I have another AMD based PC here with an nvidia card and HDMI port. Using
>>> the nvidia driver, it boots up with no output to the tv until X starts.
>>> Once X starts I get my kdm login screen. All is well except the resolution
>>> is 800x600 and I have no VTs. I suspect if I had a properly configured
>>> xorg.conf file, my resolution would be what I defined in it and work.
>>>
>>> Using the nouveau driver, I get nothing but "no signal" on the tv.  Just
>>> like the the intel box, except no EDID messages in the log file. I've
>>> attached a dmesg outputs for each config.
>>>
>>> Back on the Intel machine. I boot up with a normal monitor connected to the
>>> DVI port of the PC. Then at the kdm login screen, I disconnect the DVI
>>> cable from the PC and connect the TV to the PCs DVI port using a DVI/HDMI
>>> adapter. I get a beautiful 1600x1200 resolution screen on the TV. This does
>>> not happen using the PC HDMI port.
>>>
>>
>> One other thing I failed to mention. If i connect the TV HDMI to the Intel
>> boards DVI port using the adapter, at power up I get all the BIOS messages
>> and can enter the BIOS and all is fine. But when I let it boot all the way
>> up like this, I get nothing but "no signal" after leaving BIOS mode.
>> Turning the tv on/off, cable plug/unplug does not help.
>
> Did you also try the DVI-HDMI adapter cable with the nVidia card?
>

No, I didn't try that. I certainly can though.

> But will all that info I would say the issues is at the side of you TV that
> just does not provide (valid) EDID information, thus the driver does not know
> what the display supports.
>
> The 1600x1200 when switching DVI displays on Intel would seem like the driver
> just kept on display what it had, not reconfiguring anything.
>

Right, that's what I thought was happening. But at least it tells me that 
the tv can in fact "probably" operate in whatever resolution I force it to. 
Is there no way, like in the past we had to do, to just not care what the 
tv/monitor says or does, and just use a fixed resolution?

> For the 800x600 of nVidia, that kind of the default fallback when display
> capabilities are unknown as any remotely recent display should alt least be
> capable to understand that.
>

Yep, that's what I figured here too. nvidia provides a "default/fallback" 
so you can at least access the desktop. Seems a reasonable thing, no?

>
> Your best solution is probably to write an EDID blob (or reuse one you find
> somewhere) that provides at least one mode matching your TV's native mode
> (probably full-HD).
>
> Google suggested the following document:
> http://www.jordansmanuals.com/ServiceManuals%5CLG%5CTV%5CLCD%5C42LB9DF%5C42LB9DF%20Service%20Manual.pdf
> which on page 13/14 shows the full EDID blob for the various HDMI outputs of the
> TV. You may want to read that document, convert the EDID blobs to 512 bytes binary
> files and hell DRM core to use the right one via module/kernel cmdline option:
>
>   drm_kms_helper.edid_firmware=edid/lg42lb9df.edid
> or
>   modprobe drm-kms-helper edid_firmware=edid/lg42lb9df.edid
>
> where
>   /lib/firmware/edid/lg42lb9df.edid
> is the 512-bytes EDID blob created according to data from above manual.
> (note, that will only work for intel, radeon and nouveau drivers but will
>   not work for closed drivers of AMD/nVidia)
>

Thanks for this tip. I will investigate this asap.

> PS: If you didn't already do so, try all of the HDMI connectors or the TV and
> if available, also two distinct HDMI cables of different brand.

Did all that, first thing.

Thanks
Mark



