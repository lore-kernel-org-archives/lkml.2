Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754744Ab2FMTh5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 15:37:57 -0400
Received: from zoneX.GCU-Squad.org ([194.213.125.0]:45135 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754423Ab2FMTh4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 15:37:56 -0400
Date: Wed, 13 Jun 2012 21:37:36 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Andrew Armenia <andrew@asquaredlabs.com>
Cc: Ben Dooks <ben-linux@fluff.org>, Wolfram Sang <w.sang@pengutronix.de>,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] i2c-piix4: eliminate piix4_smba global variable
Message-ID: <20120613213736.7b5bc18d@endymion.delvare>
In-Reply-To: <1339606749-4578-2-git-send-email-andrew@asquaredlabs.com>
References: <20120613094739.360967aa@endymion.delvare>
	<1339606749-4578-1-git-send-email-andrew@asquaredlabs.com>
	<1339606749-4578-2-git-send-email-andrew@asquaredlabs.com>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Jun 2012 12:59:07 -0400, Andrew Armenia wrote:
> Some chipsets have multiple sets of piix4-compatible SMBus registers.
> Eliminating the global variable will allow these chipsets to be fully
> supported.
> 
> Return value from piix4_setup and piix4_sb800_setup now returns the smba
> value detected. This is stored in a struct i2c_piix4_adapdata. Thus
> the global variable is eliminated.
> 
> Signed-off-by: Andrew Armenia <andrew@asquaredlabs.com>
> ---
>  drivers/i2c/busses/i2c-piix4.c |   54 ++++++++++++++++++++++++++++------------
>  1 file changed, 38 insertions(+), 16 deletions(-)
> 
> diff --git a/drivers/i2c/busses/i2c-piix4.c b/drivers/i2c/busses/i2c-piix4.c
> index c14d48d..61a85c9 100644
> --- a/drivers/i2c/busses/i2c-piix4.c
> +++ b/drivers/i2c/busses/i2c-piix4.c
> (...)
> -static void __devexit piix4_remove(struct pci_dev *dev)
> +static void __devinit piix4_adap_remove(struct i2c_adapter *adap)

You mean __devexit here.

Other than this, looks good, applied, thanks.

-- 
Jean Delvare
