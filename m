Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754142Ab0JGSAg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 14:00:36 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:48801 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751193Ab0JGSAf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 14:00:35 -0400
Date: Thu, 7 Oct 2010 20:00:31 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Felipe Contreras <felipe.contreras@gmail.com>
Cc: linux-main <linux-kernel@vger.kernel.org>,
        linux-arm <linux-arm-kernel@lists.infradead.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Baruch Siach <baruch@tkos.co.il>,
        Han Jonghun <jonghun79.han@gmail.com>,
        Hemant Pedanekar <hemantp@ti.com>, Arnd Hannemann <arnd@arndnet.de>,
        Omar Ramirez Luna <omar.ramirez@ti.com>
Subject: Re: [PATCH v2] ARM: allow, but warn, when issuing ioremap() on RAM
Message-ID: <20101007180031.GT29673@pengutronix.de>
References: <20101007115156.GE27250@jasper.tkos.co.il> <1286454549-19690-1-git-send-email-felipe.contreras@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1286454549-19690-1-git-send-email-felipe.contreras@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, Oct 07, 2010 at 03:29:09PM +0300, Felipe Contreras wrote:
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
> 
> Cc: Han Jonghun <jonghun79.han@gmail.com>
> Cc: Hemant Pedanekar <hemantp@ti.com>
> Cc: Arnd Hannemann <arnd@arndnet.de>
> Cc: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> Cc: Omar Ramirez Luna <omar.ramirez@ti.com>
> Signed-off-by: Felipe Contreras <felipe.contreras@gmail.com>
> ---
>  arch/arm/mm/ioremap.c |    5 ++---
>  1 files changed, 2 insertions(+), 3 deletions(-)
> 
> For issues related to this:
> http://article.gmane.org/gmane.linux.ports.arm.kernel/84454
> http://article.gmane.org/gmane.linux.ports.sh.devel/8560
> http://www.spinics.net/lists/linux-fbdev/msg01745.html
> http://article.gmane.org/gmane.linux.drivers.video-input-infrastructure/22271
> 
> diff --git a/arch/arm/mm/ioremap.c b/arch/arm/mm/ioremap.c
> index ab50627..a168673 100644
> --- a/arch/arm/mm/ioremap.c
> +++ b/arch/arm/mm/ioremap.c
> @@ -202,10 +202,9 @@ void __iomem * __arm_ioremap_pfn_caller(unsigned long pfn,
>  		return NULL;
>  
>  	/*
> -	 * Don't allow RAM to be mapped - this causes problems with ARMv6+
> +	 * This causes problems with ARMv6+. Will be disallowed soon.
maybe specify soon as "before 2.6.37"?

Other than that, Acked-by: Uwe Kleine-König
<u.kleine-koenig@pengutronix.de>
because there is no other solution to make it into the kernel before
.36.

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
