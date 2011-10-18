Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755250Ab1JRJKv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 05:10:51 -0400
Received: from mailservice.tudelft.nl ([130.161.131.5]:37750 "EHLO
	mailservice.tudelft.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751238Ab1JRJKu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 05:10:50 -0400
X-Spam-Flag: NO
X-Spam-Score: -21.9
Message-ID: <4E9D4293.6040304@tremplin-utc.net>
Date: Tue, 18 Oct 2011 11:10:43 +0200
From: =?UTF-8?B?w4lyaWMgUGllbA==?= <Eric.Piel@tremplin-utc.net>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:7.0.1) Gecko/20111006 Thunderbird/7.0.1
MIME-Version: 1.0
To: Takashi Iwai <tiwai@suse.de>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, alsa-devel@alsa-project.org,
        david.henningsson@canonical.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [REGRESSION] Sound goes too fast due to 798cb7e897210
References: <4E9D3466.5000901@tremplin-utc.net> <s5hzkgy1zf1.wl%tiwai@suse.de> <4E9D3AEE.6070809@tremplin-utc.net> <s5hty761ybk.wl%tiwai@suse.de>
In-Reply-To: <s5hty761ybk.wl%tiwai@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Op 18-10-11 10:46, Takashi Iwai schreef:
> At Tue, 18 Oct 2011 10:38:06 +0200,
> Éric Piel wrote:
>>
>> Op 18-10-11 10:23, Takashi Iwai schreef:
>>> At Tue, 18 Oct 2011 10:10:14 +0200,
>>> Éric Piel wrote:
>> :
>>> If that commit affects, the best fix would be to give a quirk specific
>>> to your device.  Try to pass either position_fix=1 or position_fix=2.
>>> Only one of them should work (likely 2).
>>>
>>> After checking it, you can add it to position_fix_list[] in
>>> sound/pci/hda/hda_intel.c together with PCI SSID.
>>
>> Hello,
>> Thanks for the quick response. Indeed forcing position_fix=1 does fix
>> the bug. I'll not try to make a patch for my device.
>
> Hm, interesting.  So, in your case, the position-buffer exists and
> reports some valid values, but the values are sloppy actually.
> It's hard to detect in the driver, unfortunately.  The relevant commit
> (and its original fix) were the attempts to detect better, but it
> seems that it fails...
>
> FWIW, the patch below is what I'm committing to the tree.
Thanks,
I've just tested it. It works like a charm :-)

Éric


>
>
> thanks,
>
> Takashi
>
> ---
> From: Takashi Iwai<tiwai@suse.de>
> Subject: [PATCH] ALSA: hda - Add position_fix quirk for Dell Inspiron 1010
>
> The previous fix for the position-buffer check gives yet another
> regression on a Dell laptop.  The safest fix right now is to add a
> static quirk for this device (and better to apply it for stable
> kernels too).
>
> Reported-by: Éric Piel<Eric.Piel@tremplin-utc.net>
> Cc:<stable@kernel.org>
> Signed-off-by: Takashi Iwai<tiwai@suse.de>
> ---
>   sound/pci/hda/hda_intel.c |    1 +
>   1 files changed, 1 insertions(+), 0 deletions(-)
>
> diff --git a/sound/pci/hda/hda_intel.c b/sound/pci/hda/hda_intel.c
> index e9a2a87..191284a 100644
> --- a/sound/pci/hda/hda_intel.c
> +++ b/sound/pci/hda/hda_intel.c
> @@ -2370,6 +2370,7 @@ static int azx_dev_free(struct snd_device *device)
>   static struct snd_pci_quirk position_fix_list[] __devinitdata = {
>   	SND_PCI_QUIRK(0x1028, 0x01cc, "Dell D820", POS_FIX_LPIB),
>   	SND_PCI_QUIRK(0x1028, 0x01de, "Dell Precision 390", POS_FIX_LPIB),
> +	SND_PCI_QUIRK(0x1028, 0x02c6, "Dell Inspiron 1010", POS_FIX_LPIB),
>   	SND_PCI_QUIRK(0x103c, 0x306d, "HP dv3", POS_FIX_LPIB),
>   	SND_PCI_QUIRK(0x1043, 0x813d, "ASUS P5AD2", POS_FIX_LPIB),
>   	SND_PCI_QUIRK(0x1043, 0x81b3, "ASUS", POS_FIX_LPIB),

