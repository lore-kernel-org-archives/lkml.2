Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752589Ab1FHRBn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 13:01:43 -0400
Received: from mail-px0-f179.google.com ([209.85.212.179]:48301 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751343Ab1FHRBm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 13:01:42 -0400
Date: Wed, 8 Jun 2011 11:01:39 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: David Jander <david@protonic.nl>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 6/6] GPIO: pca953x.c: Add missing irq_mask_ack handler
 in struct irq_chip
Message-ID: <20110608170139.GH8499@ponder.secretlab.ca>
References: <1307537314-4345-1-git-send-email-david@protonic.nl>
 <1307537314-4345-7-git-send-email-david@protonic.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1307537314-4345-7-git-send-email-david@protonic.nl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 08, 2011 at 02:48:34PM +0200, David Jander wrote:
> Either .irq_mask_ack or .irq_ack need to be filled in, otherwise in
> kernel/irq/chip.c: mask_ack_irq() a non-initialized handler is called.
> 
> Signed-off-by: David Jander <david@protonic.nl>

Does this matter anymore given that the driver no longer sets a handler?

g.

> ---
>  drivers/gpio/pca953x.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/gpio/pca953x.c b/drivers/gpio/pca953x.c
> index dfed81f..b476c1c 100644
> --- a/drivers/gpio/pca953x.c
> +++ b/drivers/gpio/pca953x.c
> @@ -379,6 +379,7 @@ static int pca953x_irq_set_type(struct irq_data *d, unsigned int type)
>  static struct irq_chip pca953x_irq_chip = {
>  	.name			= "pca953x",
>  	.irq_mask		= pca953x_irq_mask,
> +	.irq_mask_ack		= pca953x_irq_mask,
>  	.irq_unmask		= pca953x_irq_unmask,
>  	.irq_bus_lock		= pca953x_irq_bus_lock,
>  	.irq_bus_sync_unlock	= pca953x_irq_bus_sync_unlock,
> -- 
> 1.7.4.1
> 
