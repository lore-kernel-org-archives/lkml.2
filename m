Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756223Ab0E0BPc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 21:15:32 -0400
Received: from rex.securecomputing.com ([203.24.151.4]:46721 "EHLO
	cyberguard.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753131Ab0E0BPa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 21:15:30 -0400
Message-ID: <4BFDC855.4030604@snapgear.com>
Date: Thu, 27 May 2010 11:18:13 +1000
From: Greg Ungerer <gerg@snapgear.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100411)
MIME-Version: 1.0
To: Christoph Egger <siccegge@cs.fau.de>
CC: Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, Greg Ungerer <gerg@uclinux.org>,
       Thiago Farina <tfransosi@gmail.com>, linux-kernel@vger.kernel.org,
       vamos@i4.informatik.uni-erlangen.de
Subject: Re: [PATCH] config CONSOLE
References: <20100526133343.GA7508@faui49.informatik.uni-erlangen.de>
In-Reply-To: <20100526133343.GA7508@faui49.informatik.uni-erlangen.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Christoph,

Christoph Egger wrote:
> 	As part of the VAMOS[0] research project at the University of
> Erlangen we are looking at multiple integrity errors in linux'
> configuration system.
> 
> 	CONSOLE is such a generic term that maybe someone just
> expected this option exists. Or maybe it existed ages ago but I can't
> find any trace of it. Anyway that code has been dead for quite some
> time withoutanybody noticing so it's probably just unneeded.

As far as I can tell it comes from the old 2.0.x out-of-main-line
uClinux patches. But yes, dead and gone for quite some time.


> 	Please keep me informed of this patch getting confirmed /
> merged so we can keep track of it.

I am happy to apply to the m68knommu git tree for eventual pushing
to main-line from there.

Regards
Greg



> [0] http://vamos1.informatik.uni-erlangen.de/
> 
> ----
>>From 4a3b6fda1bb3a229c7ea8ca8992ed2573f07e5ba Mon Sep 17 00:00:00 2001
> From: Christoph Egger <siccegge@cs.fau.de>
> Date: Wed, 26 May 2010 15:18:26 +0200
> Subject: [PATCH] There's no config CONSOLE
> 
> as there's no config CONSOLE (never has been as far as I can tell) and
> noone has ever missed that piece of code, it should be safe to remove
> it making the kernel a tiny bit less complex.
> 
> Signed-off-by: Christoph Egger <siccegge@cs.fau.de>
> ---
>  drivers/serial/68328serial.c |    7 -------
>  1 files changed, 0 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/serial/68328serial.c b/drivers/serial/68328serial.c
> index 3046386..193a242 100644
> --- a/drivers/serial/68328serial.c
> +++ b/drivers/serial/68328serial.c
> @@ -78,10 +78,6 @@ struct m68k_serial *m68k_consinfo = 0;
>  
>  #define M68K_CLOCK (16667000) /* FIXME: 16MHz is likely wrong */
>  
> -#ifdef CONFIG_CONSOLE
> -extern wait_queue_head_t keypress_wait; 
> -#endif
> -
>  struct tty_driver *serial_driver;
>  
>  /* number of characters left in xmit buffer before we ask for more */
> @@ -301,9 +297,5 @@ static void receive_chars(struct m68k_serial *info, unsigned short rx)
>  #endif /* CONFIG_MAGIC_SYSRQ */
>  			}
> - 			/* It is a 'keyboard interrupt' ;-) */
> -#ifdef CONFIG_CONSOLE
> -			wake_up(&keypress_wait);
> -#endif			
>  		}
>  
>  		if(!tty)


-- 
------------------------------------------------------------------------
Greg Ungerer  --  Principal Engineer        EMAIL:     gerg@snapgear.com
SnapGear Group, McAfee                      PHONE:       +61 7 3435 2888
8 Gardner Close                             FAX:         +61 7 3217 5323
Milton, QLD, 4064, Australia                WEB: http://www.SnapGear.com
