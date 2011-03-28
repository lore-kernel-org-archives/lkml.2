Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754025Ab1C1NEh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 09:04:37 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:40779 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753360Ab1C1NEg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 09:04:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=F8C3hUpSwKw2BgbRa2xZXhnmFmZCcxuEAqtNXA0BZY94gC8c/uGvOVbSsKCl/noT5H
         hQG5ehAY8ii5IzbmyfMZgAtSqVvl7OTFqGP6qKRtB3f3HAbBl8jH6TZOrdS6GbYuAumX
         uxsq0qqZbxE2T7DooTvWS9izLb0+tSFgx6V8A=
Subject: Re: [PATCH v3] ata: pata_at91.c bugfix for high master clock
From: Igor Plyatov <plyatov@gmail.com>
Reply-To: plyatov@gmail.com
To: Jeff Garzik <jgarzik@pobox.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <1301313595-23156-1-git-send-email-plyatov@gmail.com>
References: <1301313595-23156-1-git-send-email-plyatov@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 28 Mar 2011 17:04:29 +0400
Message-ID: <1301317469.29670.5.camel@homepc>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

Please abandon this patch and use its new version 4 with subjects:
* "[PATCH v4 1/2] ata: pata_at91.c bugfix for initial_timing
initialisation"
* "[PATCH v4 2/2] ata: pata_at91.c bugfix for high master clock"

Best regards!
--
Igor Plyatov

> The AT91SAM9 microcontrollers with master clock higher then 105 MHz
> and PIO0, have overflow of the NCS_RD_PULSE value in the MSB. This
> lead to "NCS_RD_PULSE" pulse longer then "NRD_CYCLE" pulse and driver
> does not detect ATA device.
> 
> Signed-off-by: Igor Plyatov <plyatov@gmail.com>
> ---
>  drivers/ata/pata_at91.c |    8 +++++++-
>  1 files changed, 7 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/ata/pata_at91.c b/drivers/ata/pata_at91.c
> index d1aaeb5..3c2bf86 100644
> --- a/drivers/ata/pata_at91.c
> +++ b/drivers/ata/pata_at91.c
> @@ -33,11 +33,12 @@
>  
> 
>  #define DRV_NAME "pata_at91"
> -#define DRV_VERSION "0.1"
> +#define DRV_VERSION "0.2"
>  
>  #define CF_IDE_OFFSET	    0x00c00000
>  #define CF_ALT_IDE_OFFSET   0x00e00000
>  #define CF_IDE_RES_SIZE     0x08
> +#define NCS_RD_PULSE_LIMIT  0x3f /* maximal value for pulse bitfields */
>  
>  struct at91_ide_info {
>  	unsigned long mode;
> @@ -110,6 +111,11 @@ static void set_smc_timing(struct device *dev,
>  	/* (CS0, CS1, DIR, OE) <= (CFCE1, CFCE2, CFRNW, NCSX) timings */
>  	ncs_read_setup = 1;
>  	ncs_read_pulse = read_cycle - 2;
> +	if (ncs_read_pulse > NCS_RD_PULSE_LIMIT) {
> +		ncs_read_pulse = NCS_RD_PULSE_LIMIT;
> +		dev_warn(dev, "ncs_read_pulse limited to maximal value %lu\n",
> +			ncs_read_pulse);
> +	}
>  
>  	/* Write timings same as read timings */
>  	write_cycle = read_cycle;


