Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751568Ab2GPGHW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 02:07:22 -0400
Received: from mga11.intel.com ([192.55.52.93]:14574 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750789Ab2GPGHU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 02:07:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="193242933"
Subject: Re: [PATCH 5/7 v2] dma: sh: use an integer slave ID to improve API
 compatibility
From: Vinod Koul <vinod.koul@linux.intel.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Magnus Damm <magnus.damm@gmail.com>, linux-sh@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <1341484183-10757-6-git-send-email-g.liakhovetski@gmx.de>
References: <1341484183-10757-1-git-send-email-g.liakhovetski@gmx.de>
	 <1341484183-10757-6-git-send-email-g.liakhovetski@gmx.de>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 16 Jul 2012 11:37:08 +0530
Message-ID: <1342418828.1726.37.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-07-05 at 12:29 +0200, Guennadi Liakhovetski wrote:
> diff --git a/include/linux/sh_dma.h b/include/linux/sh_dma.h
> index a79f10a..4e83f3e 100644
> --- a/include/linux/sh_dma.h
> +++ b/include/linux/sh_dma.h
> @@ -27,10 +27,10 @@ struct sh_dmae_slave {
>   * a certain peripheral
>   */
>  struct sh_dmae_slave_config {
> -       unsigned int                    slave_id;
> -       dma_addr_t                      addr;
> -       u32                             chcr;
> -       char                            mid_rid;
> +       int             slave_id;
> +       dma_addr_t      addr;
> +       u32             chcr;
> +       char            mid_rid;
>  }; 
why would you want to keep your own slave_id and addr fields when they
are already provided in struct dma_slave_config. Also while at it, what
would be the use of last tow fields, what do they describe?
Would it be possible to get rid of this structure completely? At least
first two fields should go away.

-- 
~Vinod

