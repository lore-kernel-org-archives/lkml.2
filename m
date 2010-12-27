Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753901Ab0L0OKZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Dec 2010 09:10:25 -0500
Received: from cantor.suse.de ([195.135.220.2]:49298 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753885Ab0L0OKY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Dec 2010 09:10:24 -0500
Date: Mon, 27 Dec 2010 15:10:18 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Jesper Juhl <jj@chaosbits.net>
Cc: linux-kernel@vger.kernel.org,
        James Courtier-Dutton <James@superbug.demon.co.uk>,
        alsa-devel@alsa-project.org, Alexey Dobriyan <adobriyan@gmail.com>,
        Andy Owen <andy-alsa@ultra-premium.com>, Takashi Iwai <tiwai@suse.de>,
        Jaroslav Kysela <perex@perex.cz>
Subject: Re: [PATCH][Trivial] sound, ca0106: Fix assignment to 'channel'.
In-Reply-To: <alpine.LNX.2.00.1012242152030.28973@swampdragon.chaosbits.net>
Message-ID: <alpine.LNX.2.00.1012271509560.16569@pobox.suse.cz>
References: <alpine.LNX.2.00.1012242152030.28973@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 24 Dec 2010, Jesper Juhl wrote:

> Hi,
> 
> The assignment to the local variable 'channel' in 
> snd_ca0106_pcm_pointer_capture() is a little crazy.
> Order of assignment is undefined. This fixes it.
> 
> Signed-off-by: Jesper Juhl <jj@chaosbits.net>
> ---
>  ca0106_main.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> diff --git a/sound/pci/ca0106/ca0106_main.c b/sound/pci/ca0106/ca0106_main.c
> index d2d12c0..01b4938 100644
> --- a/sound/pci/ca0106/ca0106_main.c
> +++ b/sound/pci/ca0106/ca0106_main.c
> @@ -1082,7 +1082,7 @@ snd_ca0106_pcm_pointer_capture(struct snd_pcm_substream *substream)
>  	struct snd_pcm_runtime *runtime = substream->runtime;
>  	struct snd_ca0106_pcm *epcm = runtime->private_data;
>  	snd_pcm_uframes_t ptr, ptr1, ptr2 = 0;
> -	int channel = channel=epcm->channel_id;
> +	int channel = epcm->channel_id;
>  
>  	if (!epcm->running)
>  		return 0;
> 

As this doesn't seem to be present in linux-next as of today, I have 
picked it up for trivial queue. Thanks,

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
