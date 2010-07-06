Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754776Ab0GFT01 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jul 2010 15:26:27 -0400
Received: from mail.elliptictech.com ([209.217.122.41]:45214 "EHLO
	emergent.ellipticsemi.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753541Ab0GFT00 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jul 2010 15:26:26 -0400
Date: Tue, 6 Jul 2010 15:25:24 -0400
From: Nick Bowler <nbowler@elliptictech.com>
To: Joe Eloff <kagen101@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Alan Cox <alan@linux.intel.com>,
       devel <devel@driverdev.osuosl.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Staging: et131x: fix coding style issues in
 et131x_initpci.c
Message-ID: <20100706192524.GA16714@elliptictech.com>
Mail-Followup-To: Joe Eloff <kagen101@gmail.com>,
	Greg Kroah-Hartman <gregkh@suse.de>,
	Alan Cox <alan@linux.intel.com>, devel <devel@driverdev.osuosl.org>,
	linux-kernel <linux-kernel@vger.kernel.org>
References: <1278436628.5396.75.camel@dermezel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1278436628.5396.75.camel@dermezel>
Organization: Elliptic Technologies Inc.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19:17 Tue 06 Jul     , Joe Eloff wrote:
> >From e23e19537c4d62bc76ae982859d3c3225a45d9c2 Mon Sep 17 00:00:00 2001
> From: Joe Eloff <kagen101@gmail.com>
> Date: Tue, 6 Jul 2010 19:13:28 +0200
> Subject: [PATCH] Staging: et131x: fix coding style issues in et131x_initpci.c
> 
> This is a patch to the et131x_initpci.c file that fixes up all the
> line lengths over 80 by the checkpatch.pl tool.
> Signed-off-by: Joe Eloff <kagen101@gmail.com>
> ---
>  drivers/staging/et131x/et131x_initpci.c |   15 ++++++++++-----
>  1 files changed, 10 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/staging/et131x/et131x_initpci.c b/drivers/staging/et131x/et131x_initpci.c
> index 47baab3..ea93f83 100644
> --- a/drivers/staging/et131x/et131x_initpci.c
> +++ b/drivers/staging/et131x/et131x_initpci.c
> @@ -205,7 +205,8 @@ static int et131x_pci_init(struct et131x_adapter *adapter,
>  		if (pci_write_config_word(pdev, ET1310_PCI_REPLAY,
>  					       Replay[max_payload])) {
>  			dev_err(&pdev->dev,
> -			  "Could not write PCI config space for Replay Timer\n");
> +			  "Could not write PCI config space for Replay \
> +			   Timer\n");

First off, this change is wrong: you've just changed the error message
to contain a huge amount of white space between the words Replay and
Timer.

Secondly, please don't split printk strings onto multiple lines, because
it makes them impossible to grep for.

These same comments apply to the other printk hunks in this patch.

[...]
> @@ -539,10 +541,12 @@ static struct et131x_adapter *et131x_adapter_init(struct net_device *netdev,
>  
>  	struct et131x_adapter *etdev;
>  
> -	/* Setup the fundamental net_device and private adapter structure elements  */
> +	/* Setup the fundamental net_device and private
> +	   adapter structure elements  */

This new comment is much less readable than before due to the linebreak,
IMO.  Since the private adapter stuff is addressed by the subsequent
comment (bit rot?), we can simply remove that part of the sentence and
it will be shorter:

  Setup the fundamental net_device structure elements.

>  	SET_NETDEV_DEV(netdev, &pdev->dev);
>  
> -	/* Allocate private adapter struct and copy in relevant information */
> +	/* Allocate private adapter struct and copy
> +	   in relevant information */

This comment didn't exceed 80 columns to begin with.

-- 
Nick Bowler, Elliptic Technologies (http://www.elliptictech.com/)
