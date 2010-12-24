Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753326Ab0LXDbO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Dec 2010 22:31:14 -0500
Received: from mail-pw0-f66.google.com ([209.85.160.66]:50023 "EHLO
	mail-pw0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753200Ab0LXDbN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Dec 2010 22:31:13 -0500
Date: Thu, 23 Dec 2010 20:31:10 -0700
From: Grant Likely <grant.likely@secretlab.ca>
To: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
Cc: David Brownell <dbrownell@users.sourceforge.net>,
        spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] spi_topcliff_pch: Fix data transfer issue
Message-ID: <20101224033110.GD2491@angua.secretlab.ca>
References: <1293158450-3168-1-git-send-email-tomoya-linux@dsn.okisemi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1293158450-3168-1-git-send-email-tomoya-linux@dsn.okisemi.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 24, 2010 at 11:40:50AM +0900, Tomoya MORINAGA wrote:
> It seems spi_topcliff_pch of linux-2.6.37-rc6 degraded by previous patch.
> In fact, data transfer fails on evaluation board testing.
> I found like the following register miss-setting line.
> Using this patch, I have confirmed data transfer can work well.
> 
> Signed-off-by: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>

Looks okay to me, but I'm not an expert on the device.  I've picked
this patch up into my next-spi branch, but I can drop it if anyone has
concerns.

g.

> ---
>  drivers/spi/spi_topcliff_pch.c |    8 ++++----
>  1 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/spi/spi_topcliff_pch.c b/drivers/spi/spi_topcliff_pch.c
> index 58e187f..56b7588 100644
> --- a/drivers/spi/spi_topcliff_pch.c
> +++ b/drivers/spi/spi_topcliff_pch.c
> @@ -267,7 +267,7 @@ static void pch_spi_handler_sub(struct pch_spi_data *data, u32 reg_spsr_val,
>  	if (reg_spsr_val & SPSR_FI_BIT) {
>  		/* disable FI & RFI interrupts */
>  		pch_spi_setclr_reg(data->master, PCH_SPCR, 0,
> -				   SPCR_FIE_BIT | SPCR_TFIE_BIT);
> +				   SPCR_FIE_BIT | SPCR_RFIE_BIT);
>  
>  		/* transfer is completed;inform pch_spi_process_messages */
>  		data->transfer_complete = true;
> @@ -679,11 +679,11 @@ static void pch_spi_set_ir(struct pch_spi_data *data)
>  	if ((data->bpw_len) > PCH_MAX_FIFO_DEPTH) {
>  		/* set receive threhold to PCH_RX_THOLD */
>  		pch_spi_setclr_reg(data->master, PCH_SPCR,
> -				   PCH_RX_THOLD << SPCR_TFIC_FIELD,
> -				   ~MASK_TFIC_SPCR_BITS);
> +				   PCH_RX_THOLD << SPCR_RFIC_FIELD,
> +				   ~MASK_RFIC_SPCR_BITS);
>  		/* enable FI and RFI interrupts */
>  		pch_spi_setclr_reg(data->master, PCH_SPCR,
> -				   SPCR_RFIE_BIT | SPCR_TFIE_BIT, 0);
> +				   SPCR_RFIE_BIT | SPCR_FIE_BIT, 0);
>  	} else {
>  		/* set receive threhold to maximum */
>  		pch_spi_setclr_reg(data->master, PCH_SPCR,
> -- 
> 1.6.0.6
> 
