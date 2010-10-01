Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756140Ab0JAKPg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 06:15:36 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:52417 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752046Ab0JAKPf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 06:15:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Hard/DykLJiEl9JHQ1x3U8Ex0L9MiVobq1jQ+VIswLUrUBjH/O+93hRHZVaWAKC/lv
         5i9AZXUesGY1Wd/09bWZmen0DM38m8S0mn8fTzA4VF2rRduzlM83oLVS7W/mmzLiJhCo
         +0J9ihWpyF3j1UAbcfApxlUQjgGLUQf/YC+QM=
MIME-Version: 1.0
In-Reply-To: <20101001021548.GA7115@localhost>
References: <Pine.LNX.4.64.1009302047410.25061@boston.corp.fedex.com>
	<s5hsk0rtlun.wl%tiwai@suse.de>
	<AANLkTinT3EU3aLSBt5WmA=qDOf1cFABUNG+RiT3Nvx3e@mail.gmail.com>
	<s5h4od7tf43.wl%tiwai@suse.de>
	<20100930154557.GD11399@localhost>
	<AANLkTinnTeseJY4RDuGNkTjNE--QJ0Mw_S8FVKy_RT7h@mail.gmail.com>
	<20101001021548.GA7115@localhost>
Date: Fri, 1 Oct 2010 18:15:32 +0800
Message-ID: <AANLkTi=1=jT5LnjjP9uGMx-Q9kM7X6kx5=NeKK6Sa9g8@mail.gmail.com>
Subject: Re: Microphone not working on PCI ID 8086:3b56
From: Jeff Chua <jeff.chua.linux@gmail.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Takashi Iwai <tiwai@suse.de>, Linux Kernel <linux-kernel@vger.kernel.org>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 1, 2010 at 10:15 AM, Wu Fengguang <fengguang.wu@intel.com> wrote:

> Jeff, this should make your mic work.
>
> diff --git a/sound/pci/hda/patch_conexant.c b/sound/pci/hda/patch_conexant.c
> index a6c68cb..c0c2b33 100644
> --- a/sound/pci/hda/patch_conexant.c
> +++ b/sound/pci/hda/patch_conexant.c
> @@ -3110,6 +3110,7 @@ static struct snd_pci_quirk cxt5066_cfg_tbl[] = {
>        SND_PCI_QUIRK(0x17aa, 0x21b2, "Thinkpad X100e", CXT5066_IDEAPAD),
>        SND_PCI_QUIRK(0x17aa, 0x21b3, "Thinkpad Edge 13 (197)", CXT5066_IDEAPAD),
>        SND_PCI_QUIRK(0x17aa, 0x21b4, "Thinkpad Edge", CXT5066_IDEAPAD),
> +       SND_PCI_QUIRK(0x17aa, 0x2156, "Lenovo X201s", CXT5066_THINKPAD),
>        SND_PCI_QUIRK(0x17aa, 0x215e, "Lenovo Thinkpad", CXT5066_THINKPAD),
>        SND_PCI_QUIRK(0x17aa, 0x38af, "Lenovo G series", CXT5066_IDEAPAD),
>        SND_PCI_QUIRK(0x17aa, 0x390a, "Lenovo S10-3t", CXT5066_IDEAPAD),


Getting closer, but mic still not working.


HDA Intel 0000:00:1b.0: PCI INT B -> GSI 17 (level, low) -> IRQ 17
HDA Intel 0000:00:1b.0: irq 42 for MSI/MSI-X
HDA Intel 0000:00:1b.0: setting latency timer to 64
ALSA sound/pci/hda/hda_intel.c:2518: chipset global capabilities = 0x4401
ALSA sound/pci/hda/hda_intel.c:908: codec_mask = 0x9
ALSA sound/pci/hda/hda_intel.c:1346: codec #0 probed OK
ALSA sound/pci/hda/hda_intel.c:1346: codec #3 probed OK
ALSA sound/pci/hda/hda_codec.c:3720: hda_codec: model 'thinkpad' is
selected for config 17aa:215e (Lenovo Thinkpad)
ALSA sound/pci/hda/hda_generic.c:683: hda_generic: no proper input path found
ALSA sound/pci/hda/hda_generic.c:288: Skip Digital OUT node 2
ALSA sound/pci/hda/hda_generic.c:288: Skip Digital OUT node 3
ALSA sound/pci/hda/hda_generic.c:431: hda_generic: no proper output path found
ALSA sound/pci/hda/hda_generic.c:1036: hda_generic: no PCM found
ALSA sound/pci/hda/patch_conexant.c:3032: CXT5066: init
ALSA sound/pci/hda/patch_conexant.c:2374: CXT5066: hp automute portA=0
portD=0 present=0
ALSA sound/pci/hda/patch_conexant.c:2110: CXT5066: update speaker, hp_present=0
ALSA sound/pci/hda/patch_conexant.c:2354: CXT5066: external microphone absent
ALSA device list:
  #0: HDA Intel at 0xf2520000 irq 42

ALSA sound/pci/hda/patch_conexant.c:2110: CXT5066: update speaker, hp_present=0
ALSA sound/pci/hda/patch_conexant.c:3032: CXT5066: init
ALSA sound/pci/hda/patch_conexant.c:2374: CXT5066: hp automute portA=0
portD=0 present=0
ALSA sound/pci/hda/patch_conexant.c:2110: CXT5066: update speaker, hp_present=0
ALSA sound/pci/hda/patch_conexant.c:2354: CXT5066: external microphone absent
ALSA sound/pci/hda/hda_intel.c:1670: azx_pcm_prepare: bufsize=0x10000,
format=0x11
ALSA sound/pci/hda/hda_codec.c:1226: hda_codec_setup_stream: NID=0x10,
stream=0x5, channel=0, format=0x11
ALSA sound/pci/hda/hda_codec.c:1284: hda_codec_cleanup_stream: NID=0x10
ALSA sound/pci/hda/hda_codec.c:1284: hda_codec_cleanup_stream: NID=0x10
ALSA sound/pci/hda/hda_intel.c:1670: azx_pcm_prepare: bufsize=0x10000,
format=0x11
ALSA sound/pci/hda/hda_codec.c:1226: hda_codec_setup_stream: NID=0x10,
stream=0x5, channel=0, format=0x11
ALSA sound/pci/hda/hda_codec.c:1284: hda_codec_cleanup_stream: NID=0x10
ALSA sound/pci/hda/hda_codec.c:1284: hda_codec_cleanup_stream: NID=0x10
ALSA sound/pci/hda/patch_conexant.c:3032: CXT5066: init
ALSA sound/pci/hda/patch_conexant.c:2374: CXT5066: hp automute portA=0
portD=0 present=0
ALSA sound/pci/hda/patch_conexant.c:2110: CXT5066: update speaker, hp_present=0
ALSA sound/pci/hda/patch_conexant.c:2354: CXT5066: external microphone absent
ALSA sound/pci/hda/patch_conexant.c:3032: CXT5066: init
ALSA sound/pci/hda/patch_conexant.c:2374: CXT5066: hp automute portA=1
portD=0 present=1
ALSA sound/pci/hda/patch_conexant.c:2110: CXT5066: update speaker, hp_present=1
ALSA sound/pci/hda/patch_conexant.c:2348: CXT5066: external microphone detected
ALSA sound/pci/hda/hda_intel.c:1670: azx_pcm_prepare: bufsize=0x10000,
format=0x31
ALSA sound/pci/hda/hda_codec.c:1226: hda_codec_setup_stream: NID=0x14,
stream=0x1, channel=0, format=0x31
ALSA sound/pci/hda/hda_intel.c:701: azx_get_response timeout, polling
the codec once: last cmd=0x014a0000
ALSA sound/pci/hda/hda_codec.c:1284: hda_codec_cleanup_stream: NID=0x14
ALSA sound/pci/hda/hda_intel.c:1670: azx_pcm_prepare: bufsize=0x10000,
format=0x31
ALSA sound/pci/hda/hda_codec.c:1226: hda_codec_setup_stream: NID=0x10,
stream=0x5, channel=0, format=0x31
ALSA sound/pci/hda/hda_codec.c:1284: hda_codec_cleanup_stream: NID=0x10
ALSA sound/pci/hda/patch_conexant.c:3032: CXT5066: init
ALSA sound/pci/hda/patch_conexant.c:2374: CXT5066: hp automute portA=1
portD=0 present=1
ALSA sound/pci/hda/patch_conexant.c:2110: CXT5066: update speaker, hp_present=1
ALSA sound/pci/hda/patch_conexant.c:2348: CXT5066: external microphone detected
ALSA sound/pci/hda/patch_conexant.c:2110: CXT5066: update speaker, hp_present=1
ALSA sound/pci/hda/patch_conexant.c:3032: CXT5066: init
ALSA sound/pci/hda/patch_conexant.c:2374: CXT5066: hp automute portA=1
portD=0 present=1
ALSA sound/pci/hda/patch_conexant.c:2110: CXT5066: update speaker, hp_present=1
ALSA sound/pci/hda/patch_conexant.c:2348: CXT5066: external microphone detected
ALSA sound/pci/hda/patch_conexant.c:2110: CXT5066: update speaker, hp_present=1
ALSA sound/pci/hda/patch_conexant.c:3032: CXT5066: init
ALSA sound/pci/hda/patch_conexant.c:2374: CXT5066: hp automute portA=1
portD=0 present=1
ALSA sound/pci/hda/patch_conexant.c:2110: CXT5066: update speaker, hp_present=1
ALSA sound/pci/hda/patch_conexant.c:2348: CXT5066: external microphone detected


Thanks,
Jeff.
