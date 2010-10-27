Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754735Ab0J0EfL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 00:35:11 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:39227 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753582Ab0J0EfI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 00:35:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ZUu97k8OltwOIFyFuK/MTYM8P+wRrd0pt4QPremEeoKXI9NdwH/37hH9cdFuCK+rT/
         SUFfNeLrxVQLhltv7rgBbLHRI1yA3dSFeeHCx9xdunwf3jsJGmTYyJtBB6pz8vzTDMwd
         w0ziovn0eDLv9E081q9eKqz94YtGhqY+jtE/o=
MIME-Version: 1.0
In-Reply-To: <s5hbp6h0yoh.wl%tiwai@suse.de>
References: <AANLkTinzFbVbzvYDL23G6T_J0gLkbQ3oYXRLFvXAFdyY@mail.gmail.com>
	<s5hbp6h0yoh.wl%tiwai@suse.de>
Date: Wed, 27 Oct 2010 10:05:06 +0530
Message-ID: <AANLkTi=eROZrLq36zX1YRCE1TDWxccs9c+AtrRaLHGsB@mail.gmail.com>
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

Hello,

On Tue, Oct 26, 2010 at 8:49 PM, Takashi Iwai <tiwai@suse.de> wrote:
> At Tue, 26 Oct 2010 20:24:23 +0530,
> Jaswinder Singh wrote:
>>
>> Hello,
>>
>> Audio is not working with new Intel WX58BP Motherboard :
>>
>> [    4.843163] IOAPIC[0]: Set routing entry (8-22 -> 0xa9 -> IRQ 22
>> Mode:1 Active:1)
>> [    4.843168] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 22 (level,
>> low) -> IRQ 22
>> [    4.861627] HDA Intel 0000:00:1b.0: irq 47 for MSI/MSI-X
>> [    4.861645] HDA Intel 0000:00:1b.0: setting latency timer to 64
>> [    4.866678] ALSA sound/pci/hda/hda_intel.c:2624: no codecs found!
>> [    4.876300] HDA Intel 0000:00:1b.0: PCI INT A disabled
>> [    4.885826] HDA Intel 0000:02:00.1: PCI INT B -> GSI 17 (level,
>> low) -> IRQ 17
>> [    4.905269] HDA Intel 0000:02:00.1: irq 47 for MSI/MSI-X
>> [    4.905282] HDA Intel 0000:02:00.1: setting latency timer to 64
>> [    4.909136] ALSA device list:
>> [    4.918895]   #0: HDA ATI HDMI at 0xd0110000 irq 47
>>
>> dmesg : http://userweb.kernel.org/~jaswinder/Corei7/dmesg_b18cae4224b.txt
>> config : http://userweb.kernel.org/~jaswinder/Corei7/configs_b18cae4224b.txt
>>
>> $ lspci | grep Audio
>> 00:1b.0 Audio device: Intel Corporation 82801JI (ICH10 Family) HD
>> Audio Controller
>> 02:00.1 Audio device: ATI Technologies Inc RV620 Audio device [Radeon
>> HD 34xx Series]
>>
>> lspci : http://userweb.kernel.org/~jaswinder/Corei7/lspci.txt
>
> I don't see anything wrong.
> Are you sure that the analog on-board audio is enabled in BIOS?
>

Yes, audio is enabled in BIOS.

But Audio is not working and on-board Intel audio device is not
visible in Sound Preferences only RV620 Audio device [Radeon HD 34xx
Series] Digital Stereo (HDMI) Output device is available which I can
not use as Radeon HD 3450 is a graphics card.

Why I am getting "[    4.866678] ALSA sound/pci/hda/hda_intel.c:2624:
no codecs found!"

In my old WX58BP motherboard audio was working and I was not getting
codecs error and shows on-board Intel device is ALSA device list with
irq 31 :
[    3.439490] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 22 (level,
low) -> IRQ 22
[    3.439526] HDA Intel 0000:00:1b.0: irq 31 for MSI/MSI-X
[    3.439548] HDA Intel 0000:00:1b.0: setting latency timer to 64
..
[    3.746498] input: HDA Digital PCBeep as
/devices/pci0000:00/0000:00:1b.0/input/input3
[    3.749532] HDA Intel 0000:02:00.1: PCI INT B -> GSI 17 (level,
low) -> IRQ 17
[    3.749573] HDA Intel 0000:02:00.1: irq 32 for MSI/MSI-X
[    3.749597] HDA Intel 0000:02:00.1: setting latency timer to 64
[    3.753833] ALSA device list:
[    3.753837]   #0: HDA Intel at 0xf0000000 irq 31
[    3.753838]   #1: HDA ATI HDMI at 0xd0110000 irq 32

dmesg of old WX58BP Motherboard :
http://userweb.kernel.org/~jaswinder/Corei7/dmesg_apic_verbose.txt

If more information is needed or need to run some tests, please let me know.

Thanks,
--
Jaswinder Singh.
