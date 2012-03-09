Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753875Ab2CIR5x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 12:57:53 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:65032 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753477Ab2CIR5v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 12:57:51 -0500
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH] spi: Trivial warning fix
To: Shubhrajyoti D <shubhrajyoti@ti.com>,
        spi-devel-general@lists.sourceforge.net
Cc: Vitaly Wool <vwool@ru.mvista.com>, linux-kernel@vger.kernel.org,
        Shubhrajyoti D <shubhrajyoti@ti.com>
In-Reply-To: <1330351145-3564-1-git-send-email-shubhrajyoti@ti.com>
References: <1330351145-3564-1-git-send-email-shubhrajyoti@ti.com>
Date: Fri, 09 Mar 2012 10:57:48 -0700
Message-Id: <20120309175748.49BD13E0880@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 27 Feb 2012 19:29:05 +0530, Shubhrajyoti D <shubhrajyoti@ti.com> wrote:
> The loop count i traverses for ntrans which is unsigned
> so make the loop count i also unsigned.
> 
> Fix the below warning
> In file included from drivers/spi/spi-omap2-mcspi.c:38:
> include/linux/spi/spi.h: In function 'spi_message_alloc':
> include/linux/spi/spi.h:556: warning: comparison between signed and unsigned integer expressions
> 
> Cc: Vitaly Wool <vwool@ru.mvista.com>
> Signed-off-by: Shubhrajyoti D <shubhrajyoti@ti.com>
> ---

Applied, thanks.

g.

> Untested !
> 
>  include/linux/spi/spi.h |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/include/linux/spi/spi.h b/include/linux/spi/spi.h
> index 176fce9..6ae4993 100644
> --- a/include/linux/spi/spi.h
> +++ b/include/linux/spi/spi.h
> @@ -549,7 +549,7 @@ static inline struct spi_message *spi_message_alloc(unsigned ntrans, gfp_t flags
>  			+ ntrans * sizeof(struct spi_transfer),
>  			flags);
>  	if (m) {
> -		int i;
> +		unsigned i;
>  		struct spi_transfer *t = (struct spi_transfer *)(m + 1);
>  
>  		INIT_LIST_HEAD(&m->transfers);
> -- 
> 1.7.0.4
> 
> 
> ------------------------------------------------------------------------------
> Try before you buy = See our experts in action!
> The most comprehensive online learning library for Microsoft developers
> is just $99.99! Visual Studio, SharePoint, SQL - plus HTML5, CSS3, MVC3,
> Metro Style Apps, more. Free future releases when you subscribe now!
> http://p.sf.net/sfu/learndevnow-dev2
> _______________________________________________
> spi-devel-general mailing list
> spi-devel-general@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/spi-devel-general

-- 
Grant Likely, B.Sc, P.Eng.
Secret Lab Technologies,Ltd.
