Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933258Ab0JFWvS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 18:51:18 -0400
Received: from cantor.suse.de ([195.135.220.2]:45394 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932979Ab0JFWvR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 18:51:17 -0400
Date: Wed, 6 Oct 2010 15:51:04 -0700
From: Greg KH <gregkh@suse.de>
To: Kees Cook <kees.cook@canonical.com>
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Stefan Ringel <stefan.ringel@arcor.de>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH] staging: fix possible use-before-NULL-check crash
Message-ID: <20101006225104.GA21013@suse.de>
References: <20101006223941.GW14666@outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101006223941.GW14666@outflux.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 06, 2010 at 03:39:41PM -0700, Kees Cook wrote:
> Found via http://coccinelle.lip6.fr/rules/mini_null_ref.cocci
> 
> Signed-off-by: Kees Cook <kees.cook@canonical.com>
> ---
>  drivers/staging/tm6000/tm6000-alsa.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/staging/tm6000/tm6000-alsa.c b/drivers/staging/tm6000/tm6000-alsa.c
> index 087137d..c1aff0e 100644
> --- a/drivers/staging/tm6000/tm6000-alsa.c
> +++ b/drivers/staging/tm6000/tm6000-alsa.c
> @@ -426,10 +426,11 @@ error:
>  
>  static int tm6000_audio_fini(struct tm6000_core *dev)
>  {
> -	struct snd_tm6000_card	*chip = dev->adev;
> +	struct snd_tm6000_card	*chip;
>  
>  	if (!dev)
>  		return 0;
> +	chip = dev->adev;

Nice catch, but I don't think that the dev pointer can ever be NULL
here.

Mauro, can you queue this up through your tree, as you handle this one?

thanks,

greg k-h
