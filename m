Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932136Ab1EYHYN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 03:24:13 -0400
Received: from mtagate2.uk.ibm.com ([194.196.100.162]:50661 "EHLO
	mtagate2.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754041Ab1EYHYL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 03:24:11 -0400
Date: Wed, 25 May 2011 09:24:07 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: David Rientjes <rientjes@google.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Pekka Enberg <penberg@kernel.org>, Christoph Lameter <cl@linux.com>,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 1/6] s390, block: disable fixed buffer mode when DMA
 support is disabled
Message-ID: <20110525072407.GB2498@osiris.boeblingen.de.ibm.com>
References: <alpine.DEB.2.00.1105241650230.29780@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1105241650230.29780@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 24, 2011 at 04:53:45PM -0700, David Rientjes wrote:
> dasd=fixedbuffers must create a SLAB_CACHE_DMA cache, which is not
> possible if CONFIG_ZONE_DMA is disabled (a supported configuration
> without 64-bit support).
> 
> If passed, emit a warning and disable fixed buffer mode.
> 
> Signed-off-by: David Rientjes <rientjes@google.com>

What's the reasoning here?
On s390 for !CONFIG_64BIT ZONE_DMA would be equal to ZONE_NORMAL,
that's why we only have ZONE_NORMAL. So I don't see that something
wouldn't work...

> ---
>  drivers/s390/block/dasd_devmap.c |    5 +++++
>  1 files changed, 5 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/s390/block/dasd_devmap.c b/drivers/s390/block/dasd_devmap.c
> --- a/drivers/s390/block/dasd_devmap.c
> +++ b/drivers/s390/block/dasd_devmap.c
> @@ -282,6 +282,11 @@ dasd_parse_keyword( char *parsestring ) {
>  		return residual_str;
>  	}
>  	if (strncmp("fixedbuffers", parsestring, length) == 0) {
> +#ifndef CONFIG_ZONE_DMA
> +		DBF_EVENT(DBF_WARNING, "%s", "DMA support disabled, "
> +					"fixed buffer mode disabled.");
> +		return residual_str;
> +#endif
>  		if (dasd_page_cache)
>  			return residual_str;
>  		dasd_page_cache =
