Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752574Ab0GMD7s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 23:59:48 -0400
Received: from rex.securecomputing.com ([203.24.151.4]:54562 "EHLO
	cyberguard.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751598Ab0GMD7q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 23:59:46 -0400
Message-ID: <4C3BE3EE.9030201@snapgear.com>
Date: Tue, 13 Jul 2010 13:56:30 +1000
From: Greg Ungerer <gerg@snapgear.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100411)
MIME-Version: 1.0
To: Christoph Egger <siccegge@cs.fau.de>
CC: Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Greg Kroah-Hartman <gregkh@suse.de>, Greg Ungerer <gerg@uclinux.org>,
        Thiago Farina <tfransosi@gmail.com>, linux-kernel@vger.kernel.org,
        vamos-dev@i4.informatik.uni-erlangen.de
Subject: Re: [PATCH 04/11] Removing dead (ALMA_ANS | DRAGONIXVZ | M68EZ328ADS)
References: <cover.1278682302.git.siccegge@cs.fau.de> <875b29bdbcde4a108967933020bc00283921b968.1278682302.git.siccegge@cs.fau.de>
In-Reply-To: <875b29bdbcde4a108967933020bc00283921b968.1278682302.git.siccegge@cs.fau.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Egger wrote:
> (ALMA_ANS | DRAGONIXVZ | M68EZ328ADS) doesn't exist in Kconfig,
> therefore removing all references for it from the source code.
> 
> Signed-off-by: Christoph Egger <siccegge@cs.fau.de>

Acked-by: Greg Ungerer <gerg@uclinux.org>



>  drivers/serial/68328serial.c |   16 +++++-----------
>  1 files changed, 5 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/serial/68328serial.c b/drivers/serial/68328serial.c
> index 3046386..db7d8eb 100644
> --- a/drivers/serial/68328serial.c
> +++ b/drivers/serial/68328serial.c
> @@ -102,19 +102,13 @@ static void change_speed(struct m68k_serial *info);
>   *	Setup for console. Argument comes from the boot command line.
>   */
>  
> -#if defined(CONFIG_M68EZ328ADS) || defined(CONFIG_ALMA_ANS) || defined(CONFIG_DRAGONIXVZ)
> -#define	CONSOLE_BAUD_RATE	115200
> -#define	DEFAULT_CBAUD		B115200
> -#else
> -	/* (es) */
> -	/* note: this is messy, but it works, again, perhaps defined somewhere else?*/
> -	#ifdef CONFIG_M68VZ328
> -	#define CONSOLE_BAUD_RATE	19200
> -	#define DEFAULT_CBAUD		B19200
> -	#endif
> -	/* (/es) */
> +/* note: this is messy, but it works, again, perhaps defined somewhere else?*/
> +#ifdef CONFIG_M68VZ328
> +#define CONSOLE_BAUD_RATE	19200
> +#define DEFAULT_CBAUD		B19200
>  #endif
>  
> +
>  #ifndef CONSOLE_BAUD_RATE
>  #define	CONSOLE_BAUD_RATE	9600
>  #define	DEFAULT_CBAUD		B9600


-- 
------------------------------------------------------------------------
Greg Ungerer  --  Principal Engineer        EMAIL:     gerg@snapgear.com
SnapGear Group, McAfee                      PHONE:       +61 7 3435 2888
8 Gardner Close                             FAX:         +61 7 3217 5323
Milton, QLD, 4064, Australia                WEB: http://www.SnapGear.com
