Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753872Ab0CZVH4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Mar 2010 17:07:56 -0400
Received: from mail-fx0-f223.google.com ([209.85.220.223]:35355 "EHLO
	mail-fx0-f223.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751512Ab0CZVHz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Mar 2010 17:07:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=S/e3s3Wcv5JfEfP481X9koYkKnIiMAu4wyS8F3GS+ZxMuiS9bFQX1ZPKxNDBjBUYIJ
         zhWnQMGOLbggnv8GVciwB5Y5HEyr3VrjQj8CK23fpAJ/87KzlPsQ+N/QnvqRF8/UnCAJ
         tlhTSYJM66oLdsKH42+5ndYYZ4tZTuiSl7JSs=
MIME-Version: 1.0
In-Reply-To: <s5hhbo26d68.wl%tiwai@suse.de>
References: <64bb37e1003261025l14e2d82r64ba1e90d024bea6@mail.gmail.com>
	 <s5hfx3nm1lh.wl%tiwai@suse.de>
	 <64bb37e1003261059w3de67654m11ca17f1645f6c1@mail.gmail.com>
	 <s5hhbo26d68.wl%tiwai@suse.de>
Date: Fri, 26 Mar 2010 22:07:53 +0100
Message-ID: <64bb37e1003261407y4d46c71cr3b39fc3058e0294a@mail.gmail.com>
Subject: Re: Regressions: MSI vs HDA-Intel
From: Torsten Kaiser <just.for.lkml@googlemail.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: Jaroslav Kysela <perex@perex.cz>, alsa-devel@alsa-project.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 26, 2010 at 9:27 PM, Takashi Iwai <tiwai@suse.de> wrote:
> At Fri, 26 Mar 2010 18:59:17 +0100,
> Torsten Kaiser wrote:
>>
>> On Fri, Mar 26, 2010 at 6:31 PM, Takashi Iwai <tiwai@suse.de> wrote:
>> > At Fri, 26 Mar 2010 18:25:22 +0100,
>> > Torsten Kaiser wrote:
>> >>
>> >> I have two systems that use the alsa hda-intel driver, both show
>> >> regressions in relation to MSI.
>> >>
>> >> System 1: Athlon(tm) X2 BE-2400 with an AMD RS690/SB600 chipset
>> >> 00:14.2 Audio device [0403]: ATI Technologies Inc SBx00 Azalia (Intel
>> >> HDA) [1002:4383]
>> >> (Mainboard is a MSI MS-7368)
>> >>
>> >> After upgrading from 2.6.31 to 2.6.33 I get a delay during bootup:
>> >> [    1.155925] HDA Intel 0000:00:14.2: PCI INT A -> GSI 16 (level,
>> >> low) -> IRQ 16
>> >> [    1.159143] input: AT Translated Set 2 keyboard as
>> >> /devices/platform/i8042/serio0/input/input2
>> >> [    1.232595] firewire_core: created device fw0: GUID 00dc10000129c48f, S400
>> >> [    1.252677] hda_codec: ALC888: BIOS auto-probing.
>> >> [    1.259226] HDA Intel 0000:01:05.2: PCI INT B -> GSI 19 (level,
>> >> low) -> IRQ 19
>> >> [    1.260293] HDA Intel 0000:01:05.2: irq 27 for MSI/MSI-X
>> >> [    1.314712] input: GenPS/2 Genius Mouse as
>> >> /devices/platform/i8042/serio1/input/input3
>> >> [    4.322508] hda-intel: azx_get_response timeout, switching to
>> >> polling mode: last cmd=0x000f0000
>> >> [    5.332508] hda-intel: No response from codec, disabling MSI: last
>> >> cmd=0x000f0000
>> >> [    6.342508] hda-intel: Codec #0 probe error; disabling it...
>> >> [    7.392508] hda_intel: azx_get_response timeout, switching to
>> >> single_cmd mode: last cmd=0x000f0000
>> >> [    7.430464] ALSA device list:
>> >> [    7.431549]   #0: HDA ATI SB at 0xfe7f4000 irq 16
>> >> [    7.432656]   #1: HDA ATI HDMI at 0xfe9e8000 irq 27
>> >>
>> >> 2.6.34-rc2 does not boot on this system, something related to the new
>> >> bootmem allocator, so I can't say if this might already be fixed for
>> >> 2.6.34.
>> >>
>> >> Should the system be blacklisted like the two Asus Athlon X2 boards,
>> >> or is this some other bug?
>> >
>> > If it happens on 2.6.33 and enable_msi=0 solves the issue, then yes,
>> > we should put them on the blacklist.
>>
>> Surprisingly this did not fix the delay. After all the trouble I had
>> with MSI on the other system, I was sure it was related to the fact,
>> that 2.6.33 tried to use MSI.
>> 2.6.33 with snd_hda_intel.enable_msi=0:
>> [    1.155712] HDA Intel 0000:00:14.2: PCI INT A -> GSI 16 (level,
>> low) -> IRQ 16
>> [    1.158852] input: AT Translated Set 2 keyboard as
>> /devices/platform/i8042/serio0/in
>> put/input2
>> [    1.232597] firewire_core: created device fw0: GUID 00dc10000129c48f, S400
>> [    1.252679] hda_codec: ALC888: BIOS auto-probing.
>> [    1.259206] HDA Intel 0000:01:05.2: PCI INT B -> GSI 19 (level,
>> low) -> IRQ 19
>> [    1.314745] input: GenPS/2 Genius Mouse as
>> /devices/platform/i8042/serio1/input/input3
>> [    4.322508] hda-intel: azx_get_response timeout, switching to
>> polling mode: last cmd=0x000f0000
>> [    5.332508] hda-intel: Codec #0 probe error; disabling it...
>> [    6.382508] hda_intel: azx_get_response timeout, switching to
>> single_cmd mode: last cmd=0x000f0000
>> [    6.420470] ALSA device list:
>> [    6.421545]   #0: HDA ATI SB at 0xfe7f4000 irq 16
>> [    6.422628]   #1: HDA ATI HDMI at 0xfe9e8000 irq 19
>>
>> ... if I had read these messages, instead of just copy&pasting them, I
>> could have noted, that the delay is from codec *0*, but MSI gets
>> enabled for codec *1*.
>> Info about the HDMI output:
>> 01:05.2 Audio device [0403]: ATI Technologies Inc Radeon X1200 Series
>> Audio Controller [1002:7919]
>>
>> But that is a clear bug in the alsa code: After codec 0 (the
>> integrated audio from the SB600) does not responds, it disables the
>> MSI support for codec 1 (part of the intregrated graphic chipset).
>> (I don't know if the HDMI audio support is working or not, as I do not
>> have an HDMI display I could attach there.)
>
> It's no bug.  The driver has only one flag to use MSI or not.
> So it disable MSI for both.  It's on the same board, after all,
> so better to take a safer option.

It's a bug, because the failing codec 0 never used MSI at all. So
disabling it will not help.

The first log (without the MSI disable option) showed:
codec 0 was using IRQ 16
codec 1 was using IRQ 19, but got switched to MSI-IRQ 27
then the 5 sec pause followed, because codec 0 failed.
switching off MSI for codec 1 seemed to work, because I only see
hda_intel on IRQ 16 and 19 in /proc/interrupts.
But the device list still showed "#1: HDA ATI HDMI at 0xfe9e8000 irq
27" after the "No response from codec, disabling MSI" message!

The second log showed the same sequence:
codec 0 using IRQ 16, codec 1 using 19, but this time without the switch to 27
the 5 sec pause and the failing of codec 0 still append, because the
ALC888 never used MSI.

So I think there are two bugs:
One (the regression) that the ALC888 codec is no longer initialized
correctly, and so causing the delay during the boot.
And two that the fallback in azx_rirb_get_response() tries to disable
the never enabled MSI.
... Umm. The code disagrees with my description of bug two: It already
does check for an per chip msi flag.

I will try to add more debug to see what codec emits what errors, and
post again, with that information.

Thanks, Torsten
