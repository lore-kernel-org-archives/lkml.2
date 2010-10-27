Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761087Ab0J0MX4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 08:23:56 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:47588 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761018Ab0J0MXx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 08:23:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Bdw7aX+lSRV9jrB187t3tQAs4Tt91lpZWZ0zh33BbHIJi9l9VgD0Bkn5CXrgOm5HyJ
         FhYNR7aF9wx2uYkdvMyuxUlNtpQ90WbJtn+qrt/KpAQF0U/ZCvaYAmTRf4pdDn3ehd0b
         5BRUu49h//t7nMkx8UwEjZb+d4t88pmdouFXA=
MIME-Version: 1.0
In-Reply-To: <s5hwrp43wsf.wl%tiwai@suse.de>
References: <AANLkTinzFbVbzvYDL23G6T_J0gLkbQ3oYXRLFvXAFdyY@mail.gmail.com>
	<s5hbp6h0yoh.wl%tiwai@suse.de>
	<AANLkTi=eROZrLq36zX1YRCE1TDWxccs9c+AtrRaLHGsB@mail.gmail.com>
	<s5hiq0o5gp2.wl%tiwai@suse.de>
	<AANLkTinVkWexfarMcrT9+zbg-TJ_w27QqUPZKf3hHzdE@mail.gmail.com>
	<s5hwrp43wsf.wl%tiwai@suse.de>
Date: Wed, 27 Oct 2010 17:53:52 +0530
Message-ID: <AANLkTincmwKyA+rDrHmcFhvT8z+b7kcyT60SW3EMjfzk@mail.gmail.com>
Subject: Re: ALSA sound/pci/hda/hda_intel.c:2624: no codecs found
From: Jaswinder Singh <jaswinderlinux@gmail.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: Jaroslav Kysela <perex@perex.cz>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 27, 2010 at 1:14 PM, Takashi Iwai <tiwai@suse.de> wrote:
> At Wed, 27 Oct 2010 12:57:35 +0530,
> Jaswinder Singh wrote:
>>
>>
>> [    7.854510] IOAPIC[0]: Set routing entry (8-22 -> 0xa9 -> IRQ 22
>> Mode:1 Active:1)
>> [    7.854515] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 22 (level,
>> low) -> IRQ 22
>> [    7.854569] HDA Intel 0000:00:1b.0: irq 47 for MSI/MSI-X
>> [    7.854589] HDA Intel 0000:00:1b.0: setting latency timer to 64
>> [    7.854593] ALSA sound/pci/hda/hda_intel.c:2529: chipset global
>> capabilities = 0x4401
>> [    7.859681] ALSA sound/pci/hda/hda_intel.c:913: codec_mask = 0x0
>> [    7.859687] ALSA sound/pci/hda/hda_intel.c:2624: no codecs found!
>
> So, the hardware (BIOS) tells no codec is connected to this bus.
>

Hmm, very strange, but In BIOS sound is enable. How is this possible.

> As a last resort, you can try to load with probe_mask=0x10f.  This
> will probe the codec chips forcibly no matter whether it's present or
> not.
>

# /sbin/insmod sound/pci/hda/snd-hda-intel.ko probe_mask=0x10f

[  536.851846] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 22 (level,
low) -> IRQ 22
[  536.851849] hda_intel: codec_mask forced to 0xf
[  536.851908] HDA Intel 0000:00:1b.0: irq 47 for MSI/MSI-X
[  536.851927] HDA Intel 0000:00:1b.0: setting latency timer to 64
[  536.851932] ALSA sound/pci/hda/hda_intel.c:2529: chipset global
capabilities = 0x4401
[  537.857929] ALSA sound/pci/hda/hda_intel.c:706: azx_get_response
timeout, polling the codec once: last cmd=0x000f0000
[  538.856516] ALSA sound/pci/hda/hda_intel.c:706: azx_get_response
timeout, polling the codec once: last cmd=0x000f0000
[  539.855096] ALSA sound/pci/hda/hda_intel.c:716: azx_get_response
timeout, switching to polling mode: last cmd=0x000f0000
[  540.853681] ALSA sound/pci/hda/hda_intel.c:724: No response from
codec, disabling MSI: last cmd=0x000f0000
[  541.852269] ALSA sound/pci/hda/hda_intel.c:1429: Codec #0 probe
error; disabling it...
[  542.858837] ALSA sound/pci/hda/hda_intel.c:1429: Codec #1 probe
error; disabling it...
[  543.865396] ALSA sound/pci/hda/hda_intel.c:1429: Codec #2 probe
error; disabling it...
[  544.871963] ALSA sound/pci/hda/hda_intel.c:1429: Codec #3 probe
error; disabling it...
[  544.879942] ALSA sound/pci/hda/hda_intel.c:913: codec_mask = 0x0
[  544.879949] ALSA sound/pci/hda/hda_intel.c:1456: no codecs initialized
[  544.880011] HDA Intel 0000:00:1b.0: PCI INT A disabled
[  544.880037] HDA Intel 0000:02:00.1: PCI INT B -> GSI 17 (level,
low) -> IRQ 17
[  544.880039] hda_intel: codec_mask forced to 0xf
[  544.880086] HDA Intel 0000:02:00.1: irq 47 for MSI/MSI-X
[  544.880102] HDA Intel 0000:02:00.1: setting latency timer to 64
[  544.880105] ALSA sound/pci/hda/hda_intel.c:2529: chipset global
capabilities = 0x1001
[  544.883989] ALSA sound/pci/hda/hda_intel.c:1351: codec #0 probed OK
[  545.882519] ALSA sound/pci/hda/hda_intel.c:706: azx_get_response
timeout, polling the codec once: last cmd=0x100f0000
[  546.881107] ALSA sound/pci/hda/hda_intel.c:706: azx_get_response
timeout, polling the codec once: last cmd=0x100f0000
[  547.879688] ALSA sound/pci/hda/hda_intel.c:716: azx_get_response
timeout, switching to polling mode: last cmd=0x100f0000
[  548.878273] ALSA sound/pci/hda/hda_intel.c:724: No response from
codec, disabling MSI: last cmd=0x100f0000
[  549.876863] ALSA sound/pci/hda/hda_intel.c:1429: Codec #1 probe
error; disabling it...
[  550.879431] ALSA sound/pci/hda/hda_intel.c:1429: Codec #2 probe
error; disabling it...
[  551.882009] ALSA sound/pci/hda/hda_intel.c:1429: Codec #3 probe
error; disabling it...
[  551.908789] ALSA sound/pci/hda/hda_intel.c:1675: azx_pcm_prepare:
bufsize=0x4b00, format=0x11
[  551.908800] ALSA sound/pci/hda/hda_codec.c:1227:
hda_codec_setup_stream: NID=0x2, stream=0x1, channel=0, format=0x11
[  551.908847] ALSA sound/pci/hda/hda_intel.c:1675: azx_pcm_prepare:
bufsize=0x4b00, format=0x11
[  551.908855] ALSA sound/pci/hda/hda_codec.c:1227:
hda_codec_setup_stream: NID=0x2, stream=0x1, channel=0, format=0x11
[  551.910077] ALSA sound/pci/hda/hda_codec.c:1290:
hda_codec_cleanup_stream: NID=0x2
[  551.910111] ALSA sound/pci/hda/hda_codec.c:1290:
hda_codec_cleanup_stream: NID=0x2
[  551.912482] ALSA sound/pci/hda/hda_intel.c:1675: azx_pcm_prepare:
bufsize=0x10000, format=0x11
[  551.912492] ALSA sound/pci/hda/hda_codec.c:1227:
hda_codec_setup_stream: NID=0x2, stream=0x1, channel=0, format=0x11
[  551.912515] ALSA sound/pci/hda/hda_intel.c:1675: azx_pcm_prepare:
bufsize=0x10000, format=0x11
[  551.912524] ALSA sound/pci/hda/hda_codec.c:1227:
hda_codec_setup_stream: NID=0x2, stream=0x1, channel=0, format=0x11
[  551.945208] hda-intel: IRQ timing workaround is activated for card
#0. Suggest a bigger bdl_pos_adj.


Thanks,
--
Jaswinder Singh.
