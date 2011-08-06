Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756365Ab1HFRXr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Aug 2011 13:23:47 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:48822 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754408Ab1HFRXp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Aug 2011 13:23:45 -0400
Subject: Re: [PATCH] [SCSI] aic7xxx: use kstrdup()
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Thomas Meyer <thomas@m3y3r.de>
Cc: hare@suse.de, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
In-Reply-To: <1312622577.5589.63.camel@localhost.localdomain>
References: <1312622577.5589.63.camel@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 06 Aug 2011 12:23:42 -0500
Message-ID: <1312651422.11515.37.camel@mulgrave>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 (2.32.2-1+jejb.1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2011-08-06 at 11:22 +0200, Thomas Meyer wrote:
> From: Thomas Meyer <thomas@m3y3r.de>
> 
>  Use kstrdup rather than duplicating its implementation
> 
>  The semantic patch that makes this output is available
>  in scripts/coccinelle/api/kstrdup.cocci.
> 
>  More information about semantic patching is available at
>  http://coccinelle.lip6.fr/
> 
> Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
> ---
> 
> diff -u -p a/drivers/scsi/aic7xxx/aic79xx_osm_pci.c b/drivers/scsi/aic7xxx/aic79xx_osm_pci.c
> --- a/drivers/scsi/aic7xxx/aic79xx_osm_pci.c 2010-09-13 07:01:17.520528007 +0200
> +++ b/drivers/scsi/aic7xxx/aic79xx_osm_pci.c 2011-08-01 21:15:58.925094946 +0200
> @@ -178,10 +178,9 @@ ahd_linux_pci_dev_probe(struct pci_dev *
>  		ahd_get_pci_bus(pci),
>  		ahd_get_pci_slot(pci),
>  		ahd_get_pci_function(pci));
> -	name = kmalloc(strlen(buf) + 1, GFP_ATOMIC);
> +	name = kstrdup(buf, GFP_ATOMIC);
>         if (name == NULL)
>                 return (-ENOMEM);
> -       strcpy(name, buf);

All adaptec drivers are in deep maintenance mode because the hardware
isn't being produced any longer.  The only things we really apply to
them now is essential bug fixes, which this isn't.

James


