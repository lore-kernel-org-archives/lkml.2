Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755060Ab1HRW1y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 18:27:54 -0400
Received: from lunge.queued.net ([173.255.254.236]:37007 "EHLO
	lunge.queued.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754435Ab1HRW1x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 18:27:53 -0400
Date: Thu, 18 Aug 2011 15:27:50 -0700
From: Andres Salomon <dilinger@queued.net>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, cjb@laptop.org, jon.nettleton@gmail.com,
        devel@driverdev.osuosl.org
Subject: Re: [PATCH 1/3] staging: olpc_dcon: remove noinit module variable
Message-ID: <20110818152750.6d393c43@debxo>
In-Reply-To: <20110721203743.71c0aaee@debxo>
References: <20110721203743.71c0aaee@debxo>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

Did you see these?  I haven't seen any emails about them being merged
into the staging tree yet..


On Thu, 21 Jul 2011
20:37:43 -0700 Andres Salomon <dilinger@queued.net> wrote:

> This came from Jordan's original 2007 gxfb_dcon commit.  I've never
> seen or heard of it actually being used.  Presumably it was once
> useful for skipping hardware initialization when reloading the module
> over and over during driver development..
> 
> Signed-off-by: Andres Salomon <dilinger@queued.net>
> ---
>  drivers/staging/olpc_dcon/olpc_dcon.c |    7 ++-----
>  1 files changed, 2 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/staging/olpc_dcon/olpc_dcon.c
> b/drivers/staging/olpc_dcon/olpc_dcon.c index 750fe50..cf4b454 100644
> --- a/drivers/staging/olpc_dcon/olpc_dcon.c
> +++ b/drivers/staging/olpc_dcon/olpc_dcon.c
> @@ -36,9 +36,6 @@
>  static int resumeline = 898;
>  module_param(resumeline, int, 0444);
>  
> -static int noinit;
> -module_param(noinit, int, 0444);
> -
>  /* Default off since it doesn't work on DCON ASIC in B-test OLPC
> board */ static int useaa = 1;
>  module_param(useaa, int, 0444);
> @@ -90,7 +87,7 @@ static int dcon_hw_init(struct dcon_priv *dcon, int
> is_init) }
>  	}
>  
> -	if (ver < 0xdc02 && !noinit) {
> +	if (ver < 0xdc02) {
>  		/* Initialize the DCON registers */
>  
>  		/* Start with work-arounds for DCON ASIC */
> @@ -106,7 +103,7 @@ static int dcon_hw_init(struct dcon_priv *dcon,
> int is_init) i2c_smbus_write_word_data(client, 0x3b, 0x002b);
>  		i2c_smbus_write_word_data(client, 0x41, 0x0101);
>  		i2c_smbus_write_word_data(client, 0x42, 0x0101);
> -	} else if (!noinit) {
> +	} else {
>  		/* SDRAM setup/hold time */
>  		i2c_smbus_write_word_data(client, 0x3a, 0xc040);
>  		i2c_smbus_write_word_data(client, 0x41, 0x0000);

