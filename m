Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755946Ab0KHXe3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 18:34:29 -0500
Received: from mail.perches.com ([173.55.12.10]:4660 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753902Ab0KHXe2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 18:34:28 -0500
Subject: Re: [PATCH 08/17][trivial] scsi: Remove unnecessary casts of void
 ptr returning alloc function return values
From: Joe Perches <joe@perches.com>
To: Jesper Juhl <jj@chaosbits.net>
Cc: linux-kernel@vger.kernel.org, trivial@kernel.org,
        linux-scsi@vger.kernel.org, osst-users@lists.sourceforge.net,
        "James E.J. Bottomley" <James.Bottomley@suse.de>,
        Hannes Reinecke <hare@suse.de>
In-Reply-To: <alpine.LNX.2.00.1011082334400.23697@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1011082334400.23697@swampdragon.chaosbits.net>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 08 Nov 2010 15:34:26 -0800
Message-ID: <1289259266.29216.486.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-11-09 at 00:09 +0100, Jesper Juhl wrote:
> Signed-off-by: Jesper Juhl <jj@chaosbits.net>
> diff --git a/drivers/scsi/aic7xxx/aic7xxx_core.c b/drivers/scsi/aic7xxx/aic7xxx_core.c
[]
> @@ -4780,7 +4780,7 @@ ahc_init_scbdata(struct ahc_softc *ahc)
>  	SLIST_INIT(&scb_data->sg_maps);
>  
>  	/* Allocate SCB resources */
> -	scb_data->scbarray = (struct scb *)kmalloc(sizeof(struct scb) * AHC_SCB_MAX_ALLOC, GFP_ATOMIC);
> +	scb_data->scbarray = kmalloc(sizeof(struct scb) * AHC_SCB_MAX_ALLOC, GFP_ATOMIC);
>  	if (scb_data->scbarray == NULL)
>  		return (ENOMEM);
>  	memset(scb_data->scbarray, 0, sizeof(struct scb) * AHC_SCB_MAX_ALLOC);

This would be better as:

	scb_data->scbarray = kcalloc(AHC_SCB_MAX_ALLOC, sizeof(struct scb), GFP_ATOMIC)

without the memset.


