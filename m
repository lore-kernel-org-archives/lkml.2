Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754881Ab0GJMEe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jul 2010 08:04:34 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:57435 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752843Ab0GJMEd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jul 2010 08:04:33 -0400
Message-ID: <4C3861DA.7080604@infradead.org>
Date: Sat, 10 Jul 2010 09:04:42 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.4) Gecko/20100628 Red Hat/3.1-1.el6 Lightning/1.0b2 Thunderbird/3.1
MIME-Version: 1.0
To: Renzo Dani <arons7@gmail.com>
CC: rdunlap@xenotime.net, o.endriss@gmx.de, awalls@radix.net, crope@iki.fi,
       manu@linuxtv.org, linux-media@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH 1/2] Added Technisat Skystar USB HD CI
References: <1278411798-6437-1-git-send-email-arons7@gmail.com>
In-Reply-To: <1278411798-6437-1-git-send-email-arons7@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 06-07-2010 07:23, Renzo Dani escreveu:
> From: Renzo Dani <arons7@gmail.com>
> 
> 
> Signed-off-by: Renzo Dani <arons7@gmail.com>
> ---
>  drivers/media/dvb/dvb-usb/az6027.c |   14 ++++++++++++--
>  1 files changed, 12 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/dvb/dvb-usb/az6027.c b/drivers/media/dvb/dvb-usb/az6027.c
> index d7290b2..445851a 100644
> --- a/drivers/media/dvb/dvb-usb/az6027.c
> +++ b/drivers/media/dvb/dvb-usb/az6027.c
> @@ -1103,13 +1103,23 @@ static struct dvb_usb_device_properties az6027_properties = {
>  	.rc_query         = az6027_rc_query,
>  	.i2c_algo         = &az6027_i2c_algo,
>  
> -	.num_device_descs = 1,
> +	.num_device_descs = 3,

Your patch is not based on the current verson of az6027 driver. It currently have
5 devices, and it includes 2 Terratec and 2 Technisat USB ID's:

static struct usb_device_id az6027_usb_table[] = {
        { USB_DEVICE(USB_VID_AZUREWAVE, USB_PID_AZUREWAVE_AZ6027) },
        { USB_DEVICE(USB_VID_TERRATEC,  USB_PID_TERRATEC_DVBS2CI_V1) },
        { USB_DEVICE(USB_VID_TERRATEC,  USB_PID_TERRATEC_DVBS2CI_V2) },
       	{ USB_DEVICE(USB_VID_TECHNISAT, USB_PID_TECHNISAT_USB2_HDCI_V1) },
        { USB_DEVICE(USB_VID_TECHNISAT, USB_PID_TECHNISAT_USB2_HDCI_V2) },
       	{ },
};

The corresponding USB ID's for those devices, according with
drivers/media/dvb/dvb-usb/dvb-usb-ids.h, are:

#define USB_PID_TERRATEC_DVBS2CI_V1			0x10a4
#define USB_PID_TERRATEC_DVBS2CI_V2			0x10ac
#define USB_PID_TECHNISAT_USB2_HDCI_V1			0x0001
#define USB_PID_TECHNISAT_USB2_HDCI_V2			0x0002

>  	.devices = {
>  		{
>  			.name = "AZUREWAVE DVB-S/S2 USB2.0 (AZ6027)",
>  			.cold_ids = { &az6027_usb_table[0], NULL },
>  			.warm_ids = { NULL },
>  		},
> +		{
> +		    .name = " Terratec DVB 2 CI",
> +			.cold_ids = { &az6027_usb_table[1], NULL },

Your patch should be adding a new USB ID entry at az6027_usb_table.

> +			.warm_ids = { NULL },
> +		},
> +		{
> +		    .name = "TechniSat SkyStar USB 2 HD CI (AZ6027)",
> +			.cold_ids = { &az6027_usb_table[2], NULL },
> +			.warm_ids = { NULL },
> +		},
>  		{ NULL },
>  	}
>  };
> @@ -1118,7 +1128,7 @@ static struct dvb_usb_device_properties az6027_properties = {
>  static struct usb_driver az6027_usb_driver = {
>  	.name		= "dvb_usb_az6027",
>  	.probe 		= az6027_usb_probe,
> -	.disconnect 	= az6027_usb_disconnect,
> +	.disconnect	= az6027_usb_disconnect,
>  	.id_table 	= az6027_usb_table,
>  };
>  

Please check if the existing USB ID's correspond to the devices that you're
adding. If not, please rebase your patch against devel/for_v2.6.36 branch of my
git tree, at http://git.linuxtv.org/v4l-dvb.git.

Cheers,
Mauro
