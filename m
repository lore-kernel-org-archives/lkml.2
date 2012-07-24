Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754621Ab2GXV6W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 17:58:22 -0400
Received: from g1t0026.austin.hp.com ([15.216.28.33]:7927 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753086Ab2GXV6V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 17:58:21 -0400
Message-ID: <1343167097.25735.79.camel@ejdallLaptop>
Subject: Re: [PATCH] ene_ub6250: Use macros for firmware names
From: Betty Dall <betty.dall@hp.com>
To: Tim Gardner <tim.gardner@canonical.com>
Cc: linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, usb-storage@lists.one-eyed-alien.net
Date: Tue, 24 Jul 2012 15:58:17 -0600
In-Reply-To: <1343161869-129765-1-git-send-email-tim.gardner@canonical.com>
References: <1343161869-129765-1-git-send-email-tim.gardner@canonical.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tim,

I reviewed this patch and it looks good. Once small suggestion you can
take or leave...

On Tue, 2012-07-24 at 14:31 -0600, Tim Gardner wrote:
> Advertise firmware files using MODULE_FIRMWARE macros.
> 
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: linux-usb@vger.kernel.org
> Cc: usb-storage@lists.one-eyed-alien.net
> Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
> ---
>  drivers/usb/storage/ene_ub6250.c |   26 +++++++++++++++++++-------
>  1 file changed, 19 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/usb/storage/ene_ub6250.c b/drivers/usb/storage/ene_ub6250.c
> index b28f2ad..3fec82f 100644
> --- a/drivers/usb/storage/ene_ub6250.c
> +++ b/drivers/usb/storage/ene_ub6250.c
> @@ -29,9 +29,21 @@
>  #include "protocol.h"
>  #include "debug.h"
>  
> +#define SD_INIT1_FIRMWARE "ene-ub6250/sd_init1.bin"
> +#define SD_INIT2_FIRMWARE "ene-ub6250/sd_init2.bin"
> +#define SD_RW_FIRMWARE "ene-ub6250/sd_rdwr.bin"
> +#define MS_INIT_FIRMWARE "ene-ub6250/ms_init.bin"
> +#define MSP_RW_FIRMWARE "ene-ub6250/msp_rdwr.bin"
> +#define MS_RW_FIRMWARE "ene-ub6250/ms_rdwr.bin"
> +
>  MODULE_DESCRIPTION("Driver for ENE UB6250 reader");
>  MODULE_LICENSE("GPL");
> -
> +MODULE_FIRMWARE(SD_INIT1_FIRMWARE);
> +MODULE_FIRMWARE(SD_INIT2_FIRMWARE);
> +MODULE_FIRMWARE(SD_RW_FIRMWARE);
> +MODULE_FIRMWARE(MS_INIT_FIRMWARE);
> +MODULE_FIRMWARE(MSP_RW_FIRMWARE);
> +MODULE_FIRMWARE(MS_RW_FIRMWARE);
>  
>  /*
>   * The table of devices
> @@ -1883,28 +1895,28 @@ static int ene_load_bincode(struct us_data *us, unsigned char flag)
>  	/* For SD */
>  	case SD_INIT1_PATTERN:
>  		US_DEBUGP("SD_INIT1_PATTERN\n");
> -		fw_name = "ene-ub6250/sd_init1.bin";
> +		fw_name = SD_INIT1_FIRMWARE;
>  		break;
>  	case SD_INIT2_PATTERN:
>  		US_DEBUGP("SD_INIT2_PATTERN\n");
> -		fw_name = "ene-ub6250/sd_init2.bin";
> +		fw_name = SD_INIT2_FIRMWARE;
>  		break;
>  	case SD_RW_PATTERN:
>  		US_DEBUGP("SD_RDWR_PATTERN\n");

All the other rdwr patterns are RW not RDWR. So you could change this
one to be SD_RW_PATTERN to be consistent with MSP_RW_PATTERN and
MS_RW_PATTERN.  This is a nit.

> -		fw_name = "ene-ub6250/sd_rdwr.bin";
> +		fw_name = SD_RW_FIRMWARE;
>  		break;
>  	/* For MS */
>  	case MS_INIT_PATTERN:
>  		US_DEBUGP("MS_INIT_PATTERN\n");
> -		fw_name = "ene-ub6250/ms_init.bin";
> +		fw_name = MS_INIT_FIRMWARE;
>  		break;
>  	case MSP_RW_PATTERN:
>  		US_DEBUGP("MSP_RW_PATTERN\n");
> -		fw_name = "ene-ub6250/msp_rdwr.bin";
> +		fw_name = MSP_RW_FIRMWARE;
>  		break;
>  	case MS_RW_PATTERN:
>  		US_DEBUGP("MS_RW_PATTERN\n");
> -		fw_name = "ene-ub6250/ms_rdwr.bin";
> +		fw_name = MS_RW_FIRMWARE;
>  		break;
>  	default:
>  		US_DEBUGP("----------- Unknown PATTERN ----------\n");

-Betty


