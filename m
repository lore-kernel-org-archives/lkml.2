Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753448Ab1ASGHe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 01:07:34 -0500
Received: from cantor2.suse.de ([195.135.220.15]:50999 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750820Ab1ASGHd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 01:07:33 -0500
Date: Tue, 18 Jan 2011 21:37:15 -0800
From: Greg KH <gregkh@suse.de>
To: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: Haiyang Zhang <haiyangz@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging/hv/osd: don't reimplement ALIGN macro
Message-ID: <20110119053715.GA26304@suse.de>
References: <1295365151-9527-1-git-send-email-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1295365151-9527-1-git-send-email-u.kleine-koenig@pengutronix.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 18, 2011 at 04:39:11PM +0100, Uwe Kleine-König wrote:
> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> ---
>  drivers/staging/hv/osd.h |    5 ++---
>  1 files changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/staging/hv/osd.h b/drivers/staging/hv/osd.h
> index ce064e8..61ae54c 100644
> --- a/drivers/staging/hv/osd.h
> +++ b/drivers/staging/hv/osd.h
> @@ -28,10 +28,9 @@
>  #include <linux/workqueue.h>
>  
>  /* Defines */
> -#define ALIGN_UP(value, align)	(((value) & (align-1)) ?		\
> -				 (((value) + (align-1)) & ~(align-1)) :	\
> -				 (value))
> +#define ALIGN_UP(value, align)		ALIGN((value), (align))

How about dropping ALIGN_UP entirely and just using the built-in ALIGN()
macro instead?


>  #define ALIGN_DOWN(value, align)	((value) & ~(align-1))

Any chance to get rid of this as well with the ALIGN() macro, or is that
really not possible?

thanks,

greg k-h
