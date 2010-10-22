Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754905Ab0JVLvn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 07:51:43 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:60406 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753445Ab0JVLvm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 07:51:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=L8Fg5s/5btFVxivxTXZEYnstpP87M2dQfzeaSlgMV1uINN6BaOB1M/+ZKCSjs+BAcC
         qtnjsi4sBqKp9J0SssqU267UKtICjVvlvDJjdHvSsCaImOFHnpS0phXGz+xmKQJHbdpJ
         N0YsfOqmsxHCn/JAYTtN/RTNdXdQC5gF+hQXQ=
Message-ID: <4CC17ACA.2090802@gmail.com>
Date: Fri, 22 Oct 2010 13:51:38 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.11) Gecko/20101013 SUSE/3.1.5 Thunderbird/3.1.5
MIME-Version: 1.0
To: Clemens Ladisch <clemens@ladisch.de>
CC: Takashi Iwai <tiwai@suse.de>, alsa-devel@alsa-project.org,
        mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org,
        Valdis.Kletnieks@vt.edu, akpm@linux-foundation.org
Subject: Re: [alsa-devel] HDA: no sound [was: mmotm 2010-10-20-15-01	uploaded]
References: <201010202233.o9KMXNoL008303@imap1.linux-foundation.org>	<4CBFEE94.7020103@gmail.com>	<s5hlj5sc7do.wl%tiwai@suse.de>	<4CBFF25C.2080908@gmail.com>	<s5hfww0c6oj.wl%tiwai@suse.de> <4CC085F5.9070905@gmail.com> <4CC17629.6050703@ladisch.de>
In-Reply-To: <4CC17629.6050703@ladisch.de>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/22/2010 01:31 PM, Clemens Ladisch wrote:
> Jiri Slaby wrote:
>> On 10/21/2010 10:05 AM, Takashi Iwai wrote:
>>>   commit de8c85f7840e5e29629de95f5af24297fb325e0b
>>>     ALSA: HDA: Sigmatel: work around incorrect master muting
>>
>> Reverting this one helps.
> 
> This one introduced even more wrong volume information on some codecs.
> Pleasy try this patch on top:

Yup, works for me.

> --- a/sound/pci/hda/patch_sigmatel.c
> +++ b/sound/pci/hda/patch_sigmatel.c
> @@ -32,6 +32,7 @@
>  #include <sound/core.h>
>  #include <sound/asoundef.h>
>  #include <sound/jack.h>
> +#include <sound/tlv.h>
>  #include "hda_codec.h"
>  #include "hda_local.h"
>  #include "hda_beep.h"
> @@ -1145,7 +1146,7 @@ static int stac92xx_build_controls(struct hda_codec *codec)
>  		/* correct volume offset */
>  		vmaster_tlv[2] += vmaster_tlv[3] * spec->volume_offset;
>  		/* minimum value is actually mute */
> -		vmaster_tlv[3] |= 0x1000;
> +		vmaster_tlv[3] |= TLV_DB_SCALE_MUTE;
>  		err = snd_hda_add_vmaster(codec, "Master Playback Volume",
>  					  vmaster_tlv, slave_vols);
>  		if (err < 0)
> 

thanks,
-- 
js
