Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754690Ab0GAKBy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 06:01:54 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:37898 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751174Ab0GAKBx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 06:01:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=BA+SEM6/7UEawgLsypnneShmRk0I3f6PPo0KW1piAIx8/Z2K8MkQkoN3y4P+8R8XYb
         AZDP2Vu4UMRvWFqI944n9M+udriiRvGUpRdDXm58icgFkJIEEFAYq7z/p9HqH5IB0VJH
         n5vdyb3KyraqQi7sTcu/JoqtXcvb1ZthK6r3o=
Date: Thu, 1 Jul 2010 11:58:13 +0200
From: Kristoffer Ericson <kristoffer.ericson@gmail.com>
To: Christoph Egger <siccegge@cs.fau.de>
Cc: Eric Miao <eric.y.miao@gmail.com>, Russell King <linux@arm.linux.org.uk>,
       Pavel Machek <pavel@ucw.cz>, Arnaud Patard <arnaud.patard@rtp-net.org>,
       Uwe Kleine-K??nig <u.kleine-koenig@pengutronix.de>,
       linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
       vamos@i4.informatik.uni-erlangen.de
Subject: Re: [PATCH 25/33] Removing dead CORGI_SSP_DEPRECATED
Message-ID: <20100701095812.GA1096@boggieman>
Reply-To: Kristoffer Ericson <kristoffer.ericson@gmail.com>
References: <cover.1277911345.git.siccegge@cs.fau.de>
 <80c10751fb5b7d9be55656ac35827a403a5d6b2b.1277911346.git.siccegge@cs.fau.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <80c10751fb5b7d9be55656ac35827a403a5d6b2b.1277911346.git.siccegge@cs.fau.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 30, 2010 at 06:01:56PM +0200, Christoph Egger wrote:
> CORGI_SSP_DEPRECATED doesn't exist in Kconfig, therefore removing all
> references for it from the source code.
> 
> Signed-off-by: Christoph Egger <siccegge@cs.fau.de>

Cant see anything wrong with this.

acked-by: Kristoffer Ericson <kristoffer.ericson@gmail.com>

> ---
>  arch/arm/mach-pxa/sharpsl_pm.c |    5 -----
>  1 files changed, 0 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/arm/mach-pxa/sharpsl_pm.c b/arch/arm/mach-pxa/sharpsl_pm.c
> index 582701e..d8c5301 100644
> --- a/arch/arm/mach-pxa/sharpsl_pm.c
> +++ b/arch/arm/mach-pxa/sharpsl_pm.c
> @@ -180,17 +180,12 @@ int sharpsl_pm_pxa_read_max1111(int channel)
>  	if (machine_is_tosa())
>  	    return 0;
>  
> -#ifdef CONFIG_CORGI_SSP_DEPRECATED
> -	return corgi_ssp_max1111_get((channel << MAXCTRL_SEL_SH) | MAXCTRL_PD0 | MAXCTRL_PD1
> -			| MAXCTRL_SGL | MAXCTRL_UNI | MAXCTRL_STR);
> -#else
>  	extern int max1111_read_channel(int);
>  
>  	/* max1111 accepts channels from 0-3, however,
>  	 * it is encoded from 0-7 here in the code.
>  	 */
>  	return max1111_read_channel(channel >> 1);
> -#endif
>  }
>  
>  static int get_percentage(int voltage)
> -- 
> 1.7.0.4
