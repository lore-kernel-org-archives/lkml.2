Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754002Ab2BAGlO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 01:41:14 -0500
Received: from rere.qmqm.pl ([89.167.52.164]:37041 "EHLO rere.qmqm.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753176Ab2BAGlN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 01:41:13 -0500
Date: Wed, 1 Feb 2012 07:41:11 +0100
From: =?iso-8859-2?Q?Micha=B3_Miros=B3aw?= <mirq-linux@rere.qmqm.pl>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Pierre Ossman <pierre@ossman.eu>,
        Chris Ball <cjb@laptop.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] mmc: cb710 core: Add missing spin_lock_init for
 irq_lock of struct cb710_chip
Message-ID: <20120201064111.GA18146@rere.qmqm.pl>
References: <1328070707.3533.6.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1328070707.3533.6.camel@phoenix>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 01, 2012 at 12:31:47PM +0800, Axel Lin wrote:
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
>  drivers/misc/cb710/core.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/misc/cb710/core.c b/drivers/misc/cb710/core.c
> index 68cd05b..85cc7710 100644
> --- a/drivers/misc/cb710/core.c
> +++ b/drivers/misc/cb710/core.c
> @@ -245,6 +245,7 @@ static int __devinit cb710_probe(struct pci_dev *pdev,
>  	if (err)
>  		return err;
>  
> +	spin_lock_init(&chip->irq_lock);
>  	chip->pdev = pdev;
>  	chip->iobase = pcim_iomap_table(pdev)[0];
>  

Acked-by: Micha³ Miros³aw <mirq-linux@rere.qmqm.pl>

This is -stable material for those using lockdep daily.

Best Regards,
Micha³ Miros³aw
