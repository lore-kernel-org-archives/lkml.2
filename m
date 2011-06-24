Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755946Ab1FXNUO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jun 2011 09:20:14 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:59285 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753237Ab1FXNUK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jun 2011 09:20:10 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Ralf Baechle <ralf@linux-mips.org>
Subject: Re: [PATCH] SOUND: Fix non-ISA_DMA_API build failure
Date: Fri, 24 Jun 2011 15:19:44 +0200
User-Agent: KMail/1.13.6 (Linux/3.0.0-rc1nosema+; KDE/4.6.3; x86_64; ; )
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        alsa-devel@alsa-project.org, linux-mips@linux-mips.org
References: <20110623144750.GA10180@linux-mips.org>
In-Reply-To: <20110623144750.GA10180@linux-mips.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201106241519.44425.arnd@arndb.de>
X-Provags-ID: V02:K0:Kll31sZ2ObiCu49hsfRhNp+VFq5KUIHIy+HPy4gbzPf
 5GNj551KAEJ72+2MP5jBr3yiq35+nmMZfybGa+KNquUkLe1PNC
 GW/NuUTzmGNHQVcyisEA46/GbDZbBT/bpUFEgVZa4bU8wZ96TQ
 8pTWH8o6qDTWZDXifVy3dny/+0OUU3j88QjKT/OwP1EyExxrBn
 xPz4dzFz5T62f211859bQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 23 June 2011 16:47:50 Ralf Baechle wrote:
> Fixed by adding an explicit dependency on ISA_DMA_API for all of the
> config statment that either result in the direction inclusion of code that
> calls the ISA DMA API or selects something which in turn would use the ISA
> DMA API.
> 
> The sole ISA sound driver that does not use the ISA DMA API is the Adlib
> driver so replaced the dependency of SND_ISA on ISA_DMA_API and add it to
> each of the drivers individually.

Do we really care all that much about the Adlib driver on platforms without
ISA_DMA_API? Right now all of sound/isa/ is hidden behind ISA_DMA_API and
I think that's acceptable

> diff --git a/drivers/media/radio/Kconfig b/drivers/media/radio/Kconfig
> index e4c97fd..0aeed28 100644
> --- a/drivers/media/radio/Kconfig
> +++ b/drivers/media/radio/Kconfig
> @@ -168,7 +168,7 @@ config RADIO_MAXIRADIO
>  
>  config RADIO_MIROPCM20
>         tristate "miroSOUND PCM20 radio"
> -       depends on ISA && VIDEO_V4L2 && SND
> +       depends on ISA && ISA_DMA_API && VIDEO_V4L2 && SND
>         select SND_ISA
>         select SND_MIRO
>         ---help---

Then this hunk by itself would be enough to solve the compile
errors, AFAICT.

	Arnd
