Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760359Ab0JGLw0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 07:52:26 -0400
Received: from tango.tkos.co.il ([62.219.50.35]:37474 "EHLO tango.tkos.co.il"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753283Ab0JGLwZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 07:52:25 -0400
Date: Thu, 7 Oct 2010 13:51:56 +0200
From: Baruch Siach <baruch@tkos.co.il>
To: Felipe Contreras <felipe.contreras@gmail.com>
Cc: linux-main <linux-kernel@vger.kernel.org>,
        linux-arm <linux-arm-kernel@lists.infradead.org>,
        Arnd Hannemann <arnd@arndnet.de>,
        Han Jonghun <jonghun79.han@gmail.com>,
        Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Hemant Pedanekar <hemantp@ti.com>
Subject: Re: [PATCH] ARM: allow, but warn, when issuing ioremap() on RAM
Message-ID: <20101007115156.GE27250@jasper.tkos.co.il>
References: <1286444662-16843-1-git-send-email-felipe.contreras@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1286444662-16843-1-git-send-email-felipe.contreras@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Felipe,

On Thu, Oct 07, 2010 at 12:44:22PM +0300, Felipe Contreras wrote:
> Many drivers are broken, and there's no alternative in sight. Such a big
> change should stay as a warning for now, and only later should it
> actually fail.
> 
> The drivers are not doing something correct, we get it, but for now it's
> better to allow them to work (they do 99% of the time anyway) rather
> than to force everyone to revert this patch in their internal trees
> until there's a solution. A slightly broken functionality is better than
> no functionality at all.
> 
> A warning lets people know that what they are doing is not right, and
> they should fix it.

[snip]

> --- a/arch/arm/mm/ioremap.c
> +++ b/arch/arm/mm/ioremap.c
> @@ -204,8 +204,7 @@ void __iomem * __arm_ioremap_pfn_caller(unsigned long pfn,
>  	/*
>  	 * Don't allow RAM to be mapped - this causes problems with ARMv6+
>  	 */

Please change the comment to match the (new) code.

> -	if (WARN_ON(pfn_valid(pfn)))
> -		return NULL;
> +	WARN_ON(pfn_valid(pfn));
>  
>  	type = get_mem_type(mtype);
>  	if (!type)

baruch

-- 
                                                     ~. .~   Tk Open Systems
=}------------------------------------------------ooO--U--Ooo------------{=
   - baruch@tkos.co.il - tel: +972.2.679.5364, http://www.tkos.co.il -
