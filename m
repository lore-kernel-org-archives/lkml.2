Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753492Ab2HMIWb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 04:22:31 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:63486 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751345Ab2HMIW3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 04:22:29 -0400
MIME-Version: 1.0
In-Reply-To: <s5hlihjw7a2.wl%tiwai@suse.de>
References: <1344677543-22591-1-git-send-email-chenhc@lemote.com>
	<1344677543-22591-15-git-send-email-chenhc@lemote.com>
	<s5hlihjw7a2.wl%tiwai@suse.de>
Date: Mon, 13 Aug 2012 16:22:27 +0800
Message-ID: <CAAhV-H6DoZ2qCAO=vZiCLXLmxv4-CLZtWRtEvWhuR6im2r3PDg@mail.gmail.com>
Subject: Re: [alsa-devel] [PATCH V5 14/18] ALSA: HDA: Make hda sound card
 usable for Loongson.
From: Huacai Chen <chenhuacai@gmail.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: Ralf Baechle <ralf@linux-mips.org>, linux-mips@linux-mips.org,
        alsa-devel@alsa-project.org, Zhangjin Wu <wuzhangjin@gmail.com>,
        Hua Yan <yanh@lemote.com>, Fuxin Zhang <zhangfx@lemote.com>,
        linux-kernel@vger.kernel.org, Hongliang Tao <taohl@lemote.com>,
        Jie Chen <chenj@lemote.com>, Huacai Chen <chenhc@lemote.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

OK, I will improve the code.

On Mon, Aug 13, 2012 at 4:00 PM, Takashi Iwai <tiwai@suse.de> wrote:
> At Sat, 11 Aug 2012 17:32:19 +0800,
> Huacai Chen wrote:
>>
>> Lemote A1004(Laptop) and A1205(All-In-One) use Conexant's hda codec,
>> this patch modify patch_conexant.c to add Lemote specific code.
>>
>> Signed-off-by: Jie Chen <chenj@lemote.com>
>> Signed-off-by: Huacai Chen <chenhc@lemote.com>
>> Signed-off-by: Hongliang Tao <taohl@lemote.com>
>> Signed-off-by: Hua Yan <yanh@lemote.com>
>> Cc: alsa-devel@alsa-project.org
>> ---
>>  include/linux/pci_ids.h        |    2 ++
>>  sound/pci/hda/patch_conexant.c |   24 ++++++++++++++++++++++++
>>  2 files changed, 26 insertions(+), 0 deletions(-)
>>
>> diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
>> index fc35260..b28270e 100644
>> --- a/include/linux/pci_ids.h
>> +++ b/include/linux/pci_ids.h
>> @@ -2918,3 +2918,5 @@
>>  #define PCI_DEVICE_ID_XEN_PLATFORM   0x0001
>>
>>  #define PCI_VENDOR_ID_OCZ            0x1b85
>> +
>> +#define PCI_VENDOR_ID_LEMOTE         0x1c06
>> diff --git a/sound/pci/hda/patch_conexant.c b/sound/pci/hda/patch_conexant.c
>> index 1436118..b7de368 100644
>> --- a/sound/pci/hda/patch_conexant.c
>> +++ b/sound/pci/hda/patch_conexant.c
>> @@ -4414,6 +4414,8 @@ static const struct hda_codec_ops cx_auto_patch_ops = {
>>  enum {
>>       CXT_PINCFG_LENOVO_X200,
>>       CXT_PINCFG_LENOVO_TP410,
>> +     CXT_PINCFG_LEMOTE_A1004,
>> +     CXT_PINCFG_LEMOTE_A1205,
>>       CXT_FIXUP_STEREO_DMIC,
>>  };
>>
>> @@ -4441,6 +4443,18 @@ static const struct hda_pintbl cxt_pincfg_lenovo_tp410[] = {
>>       {}
>>  };
>>
>> +/* Lemote A1004/A1205 with cxt5066 */
>> +static const struct hda_pintbl cxt_pincfg_lemote[] = {
>> +     { 0x1a, 0x90a10020 }, /* Internal mic */
>> +     { 0x1b, 0x03a11020 }, /* External mic */
>> +     { 0x1d, 0x400101f0 }, /* Not used */
>> +     { 0x1e, 0x40a701f0 }, /* Not used */
>> +     { 0x20, 0x404501f0 }, /* Not used */
>> +     { 0x22, 0x404401f0 }, /* Not used */
>> +     { 0x23, 0x40a701f0 }, /* Not used */
>> +     {}
>> +};
>> +
>>  static const struct hda_fixup cxt_fixups[] = {
>>       [CXT_PINCFG_LENOVO_X200] = {
>>               .type = HDA_FIXUP_PINS,
>> @@ -4450,6 +4464,14 @@ static const struct hda_fixup cxt_fixups[] = {
>>               .type = HDA_FIXUP_PINS,
>>               .v.pins = cxt_pincfg_lenovo_tp410,
>>       },
>> +     [CXT_PINCFG_LEMOTE_A1004] = {
>> +             .type = HDA_FIXUP_PINS,
>> +             .v.pins = cxt_pincfg_lemote,
>> +     },
>> +     [CXT_PINCFG_LEMOTE_A1205] = {
>> +             .type = HDA_FIXUP_PINS,
>> +             .v.pins = cxt_pincfg_lemote,
>> +     },
>
> Well, if both point to the same pin configuration, there is no merit
> to create two distinct fixup types.
> Just create CXT_PINCFG_LEMOTE_A1X05, then pass it in your both device
> entries.
>
>
>>       [CXT_FIXUP_STEREO_DMIC] = {
>>               .type = HDA_FIXUP_FUNC,
>>               .v.func = cxt_fixup_stereo_dmic,
>> @@ -4467,6 +4489,8 @@ static const struct snd_pci_quirk cxt5066_fixups[] = {
>>       SND_PCI_QUIRK(0x17aa, 0x215f, "Lenovo T510", CXT_PINCFG_LENOVO_TP410),
>>       SND_PCI_QUIRK(0x17aa, 0x21ce, "Lenovo T420", CXT_PINCFG_LENOVO_TP410),
>>       SND_PCI_QUIRK(0x17aa, 0x21cf, "Lenovo T520", CXT_PINCFG_LENOVO_TP410),
>> +     SND_PCI_QUIRK(PCI_VENDOR_ID_LEMOTE, 0x2011, "Lemote A1004", CXT_PINCFG_LEMOTE_A1004),
>> +     SND_PCI_QUIRK(PCI_VENDOR_ID_LEMOTE, 0x2012, "Lemote A1205", CXT_PINCFG_LEMOTE_A1205),
>>       SND_PCI_QUIRK(0x17aa, 0x3975, "Lenovo U300s", CXT_FIXUP_STEREO_DMIC),
>>       SND_PCI_QUIRK(0x17aa, 0x397b, "Lenovo S205", CXT_FIXUP_STEREO_DMIC),
>
> Don't put entries suddenly in the middle of others.
> As you can see, the list is sorted in the order of id numbers.
>
> Also, in this case, we prefer having numbers over PCI_* literals.
> It's easier to check through the table in the end.
>
>
> thanks,
>
> Takashi
