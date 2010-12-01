Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755083Ab0LARVX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 12:21:23 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:41677 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752886Ab0LARVV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 12:21:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=CliHxtCU51Lj/fbqPb/Y+zvblgLH6xudVWOZZvXMFsPF4r6hSmnuDT+9zHbSA1CYFN
         5T9JgCtXgfMNecwRD5YT5APPb0nS+nvXAcihexvevyL9cJDbdqgHzBkSHfSjnvp83k0e
         GhE4uFTOcRkJDCuC2WFFdzK2z2BM1RrRJaFyU=
Date: Wed, 1 Dec 2010 09:20:59 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Namhyung Kim <namhyung@gmail.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Input: turbografx - fix reference counting
Message-ID: <20101201172059.GC11196@core.coreip.homeip.net>
References: <1291208701-3016-1-git-send-email-namhyung@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1291208701-3016-1-git-send-email-namhyung@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 01, 2010 at 10:05:01PM +0900, Namhyung Kim wrote:
> The ref-count of parport gained from parport_find_number()
> was not released in normal path.
> 

Applied, thanks.

> Signed-off-by: Namhyung Kim <namhyung@gmail.com>
> ---
>  drivers/input/joystick/turbografx.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/input/joystick/turbografx.c b/drivers/input/joystick/turbografx.c
> index d53b9e9..27b6a3c 100644
> --- a/drivers/input/joystick/turbografx.c
> +++ b/drivers/input/joystick/turbografx.c
> @@ -245,6 +245,7 @@ static struct tgfx __init *tgfx_probe(int parport, int *n_buttons, int n_devs)
>  		goto err_free_tgfx;
>          }
>  
> +	parport_put_port(pp);
>  	return tgfx;
>  
>   err_free_dev:
> -- 
> 1.7.0.4
> 

-- 
Dmitry
