Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752768Ab2FRRu4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 13:50:56 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:39480 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751629Ab2FRRuz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 13:50:55 -0400
MIME-Version: 1.0
In-Reply-To: <s5h8vfkn2bb.wl%tiwai@suse.de>
References: <1339444731-15678-1-git-send-email-elezegarcia@gmail.com>
	<1339444731-15678-2-git-send-email-elezegarcia@gmail.com>
	<s5h8vfkn2bb.wl%tiwai@suse.de>
Date: Mon, 18 Jun 2012 14:50:53 -0300
Message-ID: <CALF0-+Ukw2+whn5zpA4R6PjN0BoLm5aUhQKUNQt0rpWM1vNXFA@mail.gmail.com>
Subject: Re: [PATCH 2/3] swarm_cs4297: Rename AC97 registers to use
 sound/ac97_codec.h definitions
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org,
        Ralf Baechle <ralf@linux-mips.org>, Jaroslav Kysela <perex@perex.cz>,
        Clemens Ladisch <clemens@ladisch.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Takashi,

On Mon, Jun 18, 2012 at 11:04 AM, Takashi Iwai <tiwai@suse.de> wrote:
> At Mon, 11 Jun 2012 16:58:50 -0300,
> Ezequiel Garcia wrote:
>>
>> This patch removes the last usage of linux/ac97_codec.h
>> by renaming ac97 registers to use sound/ac97_codec.h definitions.
>> This will enable us to remove linux/ac97_codec.h.
>>
>> Not even compilation tested.
>>
>> Cc: Ralf Baechle <ralf@linux-mips.org>
>> Cc: Jaroslav Kysela <perex@perex.cz>
>> Cc: Takashi Iwai <tiwai@suse.de>
>> Cc: Clemens Ladisch <clemens@ladisch.de>
>> Signed-off-by: Ezequiel Garcia <elezegarcia@gmail.com>
>> ---
>> Hi all,
>>
>> This patch is important so we can remove linux/ac97_codec.h usage.
>> Since this driver is mips related, I can't test it until I install
>> a mips toolchain.
>> If someone can compile this for me, or even test it with real
>> hardware I think it would be better.
>> If not then I can install a mips toolchain and compile it myself,
>> but I won't be able to test it on real hardware.
>>
>> This patch should be treated with carefully and be applied only
>> if someone manages to test it.
>
> A slight concern by this change is that the driver includes
> sound/ac97_codec.h although it's based on OSS framework.
> sound/ac97_codec.h is the header for ALSA ac97 structs, and this can't
> be mixed up with OSS.
>
> If the intention is only about AC97 register definition, we may split
> ac97_codec.h into ac97_regs.h and ac97_codecs.h where the former
> contains only the register definitions (thus framework-neutral) and
> the latter includes the former.
>
>

Yes, splitting sounds good to me. It could be useful for other ac97
drivers (e.g. em28xx).

I wonder if anyone is using this swarm driver (and/or can test).

Also, is there any date scheduled for OSS removal?

Thanks for reviewing,
Ezequiel.
