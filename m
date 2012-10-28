Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751977Ab2J1LpV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2012 07:45:21 -0400
Received: from zoneX.GCU-Squad.org ([194.213.125.0]:10493 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750891Ab2J1LpT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2012 07:45:19 -0400
Date: Sun, 28 Oct 2012 12:45:10 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org,
        "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>,
        "Wolfram Sang (embedded platforms)" <w.sang@pengutronix.de>,
        linux-i2c@vger.kernel.org
Subject: Re: [PATCH 08/16] i2c: Convert dev_printk(KERN_<LEVEL> to
 dev_<level>(
Message-ID: <20121028124510.76e23bd5@endymion.delvare>
In-Reply-To: <3e4988b083a8b5d03a458aabc18042cedb3dbd8a.1351411047.git.joe@perches.com>
References: <cover.1351411047.git.joe@perches.com>
	<3e4988b083a8b5d03a458aabc18042cedb3dbd8a.1351411047.git.joe@perches.com>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joe,

On Sun, 28 Oct 2012 01:05:46 -0700, Joe Perches wrote:
> dev_<level> calls take less code than dev_printk(KERN_<LEVEL>
> and reducing object size is good.
> Coalesce formats for easier grep.
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  drivers/i2c/busses/i2c-piix4.c |    5 ++---
>  1 files changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/i2c/busses/i2c-piix4.c b/drivers/i2c/busses/i2c-piix4.c
> index 8bbd6ec..f7216ed 100644
> --- a/drivers/i2c/busses/i2c-piix4.c
> +++ b/drivers/i2c/busses/i2c-piix4.c
> @@ -204,9 +204,8 @@ static int __devinit piix4_setup(struct pci_dev *PIIX4_dev,
>  			 */
>  			pci_write_config_byte(PIIX4_dev, SMBHSTCFG,
>  					      temp | 1);
> -			dev_printk(KERN_NOTICE, &PIIX4_dev->dev,
> -				"WARNING: SMBus interface has been "
> -				"FORCEFULLY ENABLED!\n");
> +			dev_notice(&PIIX4_dev->dev,
> +				   "WARNING: SMBus interface has been FORCEFULLY ENABLED!\n");
>  		} else {
>  			dev_err(&PIIX4_dev->dev,
>  				"Host SMBus controller not enabled!\n");

Applied, thanks.

-- 
Jean Delvare
