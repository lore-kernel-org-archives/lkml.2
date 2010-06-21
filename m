Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932780Ab0FUPFW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 11:05:22 -0400
Received: from buzzloop.caiaq.de ([212.112.241.133]:55721 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932462Ab0FUPFV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 11:05:21 -0400
Date: Mon, 21 Jun 2010 17:05:16 +0200
From: Daniel Mack <daniel@caiaq.de>
To: Jiri Slaby <jslaby@suse.cz>
Cc: tiwai@suse.de, alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
       jirislaby@gmail.com, Clemens Ladisch <clemens@ladisch.de>
Subject: Re: [PATCH] SOUND: usb/endpoint, fix dangling pointer use
Message-ID: <20100621150515.GB17833@buzzloop.caiaq.de>
References: <1277132601-14375-1-git-send-email-jslaby@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1277132601-14375-1-git-send-email-jslaby@suse.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 21, 2010 at 05:03:21PM +0200, Jiri Slaby wrote:
> Stanse found that in snd_usb_parse_audio_endpoints, there is a
> dangling pointer dereference. When snd_usb_parse_audio_format fails,
> fp is freed, and continue invoked. On the next loop, there is
> "fp && fp->altsetting == 1 && fp->channels == 1" test, but fp is set
> from the last iteration (but is bogus) and thus ilegally dereferenced.
> 
> Set fp to NULL before "continue".

Oh, absolutely. Thanks.

> Signed-off-by: Jiri Slaby <jslaby@suse.cz>

Acked-by: Daniel Mack <daniel@caiaq.de>

I think this should go thru the ALSA tree.


Daniel


> Cc: Clemens Ladisch <clemens@ladisch.de>
> Cc: Takashi Iwai <tiwai@suse.de>
> ---
>  sound/usb/endpoint.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/sound/usb/endpoint.c b/sound/usb/endpoint.c
> index 9593b91..6f6596c 100644
> --- a/sound/usb/endpoint.c
> +++ b/sound/usb/endpoint.c
> @@ -427,6 +427,7 @@ int snd_usb_parse_audio_endpoints(struct snd_usb_audio *chip, int iface_no)
>  		if (snd_usb_parse_audio_format(chip, fp, format, fmt, stream, alts) < 0) {
>  			kfree(fp->rate_table);
>  			kfree(fp);
> +			fp = NULL;
>  			continue;
>  		}
>  
> -- 
> 1.7.1
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
