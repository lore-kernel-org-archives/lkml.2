Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754205Ab0J0H1j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 03:27:39 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:39556 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752124Ab0J0H1h convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 03:27:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ZxOShQiLbGKKh4uBThM9/QFfKkt2fX9x5xT1wqHcqEMq/8S3qZnPT0zZhjK6GzvpiL
         0GN1dPUYtbdQE2v4snydg/P4VS6ho2RYMVk82KJrfknrbBz0BRoW9clSBTDzjikegffJ
         mJNFZt5+6oSH9AGvByXeUB7TXWVrVteB/FdOk=
MIME-Version: 1.0
In-Reply-To: <s5hiq0o5gp2.wl%tiwai@suse.de>
References: <AANLkTinzFbVbzvYDL23G6T_J0gLkbQ3oYXRLFvXAFdyY@mail.gmail.com>
	<s5hbp6h0yoh.wl%tiwai@suse.de>
	<AANLkTi=eROZrLq36zX1YRCE1TDWxccs9c+AtrRaLHGsB@mail.gmail.com>
	<s5hiq0o5gp2.wl%tiwai@suse.de>
Date: Wed, 27 Oct 2010 12:57:35 +0530
Message-ID: <AANLkTinVkWexfarMcrT9+zbg-TJ_w27QqUPZKf3hHzdE@mail.gmail.com>
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

On Wed, Oct 27, 2010 at 11:18 AM, Takashi Iwai <tiwai@suse.de> wrote:
> At Wed, 27 Oct 2010 10:05:06 +0530,
> Jaswinder Singh wrote:
>>
>
> OK, and does it work with other kernel versions or other OS?
>

Yes, I also tried with older kernel version but no success.

Only Linux OS is installed on this machine.

>>
>> If more information is needed or need to run some tests, please let me know.
>
> Try probing as a module.  It makes easier to debug.

I loaded it as module with debugging :

$ lsmod
Module                  Size  Used by
snd_hda_codec_hdmi     23156  1
snd_hda_intel          24921  0
snd_hda_codec          83458  2 snd_hda_codec_hdmi,snd_hda_intel
snd_hwdep               5916  1 snd_hda_codec

[    7.854510] IOAPIC[0]: Set routing entry (8-22 -> 0xa9 -> IRQ 22
Mode:1 Active:1)
[    7.854515] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 22 (level,
low) -> IRQ 22
[    7.854569] HDA Intel 0000:00:1b.0: irq 47 for MSI/MSI-X
[    7.854589] HDA Intel 0000:00:1b.0: setting latency timer to 64
[    7.854593] ALSA sound/pci/hda/hda_intel.c:2529: chipset global
capabilities = 0x4401
[    7.859681] ALSA sound/pci/hda/hda_intel.c:913: codec_mask = 0x0
[    7.859687] ALSA sound/pci/hda/hda_intel.c:2624: no codecs found!
[    7.859727] HDA Intel 0000:00:1b.0: PCI INT A disabled
[    7.859748] HDA Intel 0000:02:00.1: PCI INT B -> GSI 17 (level,
low) -> IRQ 17
[    7.859787] HDA Intel 0000:02:00.1: irq 47 for MSI/MSI-X
[    7.859801] HDA Intel 0000:02:00.1: setting latency timer to 64
[    7.859804] ALSA sound/pci/hda/hda_intel.c:2529: chipset global
capabilities = 0x1001
[    7.863672] ALSA sound/pci/hda/hda_intel.c:913: codec_mask = 0x1
[    7.863711] ALSA sound/pci/hda/hda_intel.c:1351: codec #0 probed OK
..
[   19.359243] [drm] Setting GART location based on new memory map
[   19.359463] [drm] Loading RV620 CP Microcode
[   19.453202] [drm] Resetting GPU
[   19.453261] [drm] writeback test succeeded in 1 usecs
[   24.314141] ALSA sound/pci/hda/hda_intel.c:1675: azx_pcm_prepare:
bufsize=0x4b00, format=0x11
[   24.314150] ALSA sound/pci/hda/hda_codec.c:1227:
hda_codec_setup_stream: NID=0x2, stream=0x1, channel=0, format=0x11
[   24.315942] ALSA sound/pci/hda/hda_intel.c:1675: azx_pcm_prepare:
bufsize=0x4b00, format=0x11
[   24.315949] ALSA sound/pci/hda/hda_codec.c:1227:
hda_codec_setup_stream: NID=0x2, stream=0x1, channel=0, format=0x11
[   24.316604] ALSA sound/pci/hda/hda_codec.c:1290:
hda_codec_cleanup_stream: NID=0x2
[   24.316631] ALSA sound/pci/hda/hda_codec.c:1290:
hda_codec_cleanup_stream: NID=0x2
[   24.318073] ALSA sound/pci/hda/hda_intel.c:1675: azx_pcm_prepare:
bufsize=0x10000, format=0x11
[   24.318082] ALSA sound/pci/hda/hda_codec.c:1227:
hda_codec_setup_stream: NID=0x2, stream=0x1, channel=0, format=0x11
[   24.318100] ALSA sound/pci/hda/hda_intel.c:1675: azx_pcm_prepare:
bufsize=0x10000, format=0x11
[   24.318106] ALSA sound/pci/hda/hda_codec.c:1227:
hda_codec_setup_stream: NID=0x2, stream=0x1, channel=0, format=0x11
[   24.350300] hda-intel: IRQ timing workaround is activated for card
#0. Suggest a bigger bdl_pos_adj.
[   27.634907] eth1: no IPv6 routers present
[   29.044300] ALSA sound/pci/hda/hda_codec.c:1290:
hda_codec_cleanup_stream: NID=0x2
[   29.044332] ALSA sound/pci/hda/hda_codec.c:1290:
hda_codec_cleanup_stream: NID=0x2
[   31.347000] ALSA sound/pci/hda/hda_intel.c:1675: azx_pcm_prepare:
bufsize=0x4b00, format=0x11
[   31.347009] ALSA sound/pci/hda/hda_codec.c:1227:
hda_codec_setup_stream: NID=0x2, stream=0x1, channel=0, format=0x11
[   31.347028] ALSA sound/pci/hda/hda_intel.c:1675: azx_pcm_prepare:
bufsize=0x4b00, format=0x11
[   31.347035] ALSA sound/pci/hda/hda_codec.c:1227:
hda_codec_setup_stream: NID=0x2, stream=0x1, channel=0, format=0x11
[   31.347712] ALSA sound/pci/hda/hda_codec.c:1290:
hda_codec_cleanup_stream: NID=0x2
[   31.347742] ALSA sound/pci/hda/hda_codec.c:1290:
hda_codec_cleanup_stream: NID=0x2
[   31.363221] ALSA sound/pci/hda/hda_intel.c:1675: azx_pcm_prepare:
bufsize=0x10000, format=0x11
[   31.363229] ALSA sound/pci/hda/hda_codec.c:1227:
hda_codec_setup_stream: NID=0x2, stream=0x1, channel=0, format=0x11
[   31.363245] ALSA sound/pci/hda/hda_intel.c:1675: azx_pcm_prepare:
bufsize=0x10000, format=0x11
[   31.363252] ALSA sound/pci/hda/hda_codec.c:1227:
hda_codec_setup_stream: NID=0x2, stream=0x1, channel=0, format=0x11
[   36.564753] ALSA sound/pci/hda/hda_codec.c:1290:
hda_codec_cleanup_stream: NID=0x2
[   36.564798] ALSA sound/pci/hda/hda_codec.c:1290:
hda_codec_cleanup_stream: NID=0x2

Thanks,
--
Jaswinder Singh.
