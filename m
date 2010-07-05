Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756318Ab0GEWMV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jul 2010 18:12:21 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:42542 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754550Ab0GEWMT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jul 2010 18:12:19 -0400
Message-ID: <4C3258B7.5070900@infradead.org>
Date: Mon, 05 Jul 2010 19:12:07 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.4) Gecko/20100628 Red Hat/3.1-1.el6 Lightning/1.0b2 Thunderbird/3.1
MIME-Version: 1.0
To: Renzo Dani <arons7@gmail.com>
CC: adams.xu@azwave.com.cn, rdunlap@xenotime.net, o.endriss@gmx.de,
       awalls@radix.net, crope@iki.fi, manu@linuxtv.org,
       linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-doc@vger.kernel.org
Subject: Re: [PATCH 1/1] Added Technisat Skystar USB HD CI
References: <1277719055-14585-1-git-send-email-arons7@gmail.com>
In-Reply-To: <1277719055-14585-1-git-send-email-arons7@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 28-06-2010 06:57, Renzo Dani escreveu:
> From: Renzo Dani <arons7@gmail.com>
> 
> 
> Signed-off-by: Renzo Dani <arons7@gmail.com>
> ---
>  Documentation/dvb/get_dvb_firmware |   19 ++++++++++++++++++-
>  drivers/media/dvb/dvb-usb/az6027.c |   14 ++++++++++++--


Please, re-base your patch against upstream and send the firmware patch on a separate
email.

Cheers,
Mauro
>  2 files changed, 30 insertions(+), 3 deletions(-)
> 
> diff --git a/Documentation/dvb/get_dvb_firmware b/Documentation/dvb/get_dvb_firmware
> index 239cbdb..c203e94 100644
> --- a/Documentation/dvb/get_dvb_firmware
> +++ b/Documentation/dvb/get_dvb_firmware
> @@ -26,7 +26,7 @@ use IO::Handle;
>  		"dec3000s", "vp7041", "dibusb", "nxt2002", "nxt2004",
>  		"or51211", "or51132_qam", "or51132_vsb", "bluebird",
>  		"opera1", "cx231xx", "cx18", "cx23885", "pvrusb2", "mpc718",
> -		"af9015", "ngene");
> +		"af9015", "ngene", "az6027");
>  
>  # Check args
>  syntax() if (scalar(@ARGV) != 1);
> @@ -567,6 +567,23 @@ sub ngene {
>      "$file1, $file2";
>  }
>  
> +sub az6027{
> +    my $file = "AZ6027_Linux_Driver.tar.gz";
> +	my $url = "http://linux.terratec.de/files/$file";
> +    my $firmware = "dvb-usb-az6027-03.fw";
> +
> +	wgetfile($file, $url);
> +
> +	#untar
> +    if( system("tar xzvf $file")){
> +		die "failed to untar firmware";
> +	}
> +	if( system("rm -rf AZ6027_Linux_Driver; rm $file")){
> +		die ("unable to remove unnecessary files");
> +    }
> +
> +    $firmware;
> +}
>  # ---------------------------------------------------------------
>  # Utilities
>  
> diff --git a/drivers/media/dvb/dvb-usb/az6027.c b/drivers/media/dvb/dvb-usb/az6027.c
> index d7290b2..891ae04 100644
> --- a/drivers/media/dvb/dvb-usb/az6027.c
> +++ b/drivers/media/dvb/dvb-usb/az6027.c
> @@ -1103,13 +1103,23 @@ static struct dvb_usb_device_properties az6027_properties = {
>  	.rc_query         = az6027_rc_query,
>  	.i2c_algo         = &az6027_i2c_algo,
>  
> -	.num_device_descs = 1,
> +	.num_device_descs = 2,
>  	.devices = {
>  		{
>  			.name = "AZUREWAVE DVB-S/S2 USB2.0 (AZ6027)",
>  			.cold_ids = { &az6027_usb_table[0], NULL },
>  			.warm_ids = { NULL },
>  		},
> +		{
> +		    .name = " Terratec DVB 2 CI",
> +			.cold_ids = { &az6027_usb_table[1], NULL },
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

