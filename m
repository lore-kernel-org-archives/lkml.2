Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753211Ab3AFVXX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2013 16:23:23 -0500
Received: from smtp24.services.sfr.fr ([93.17.128.83]:14292 "EHLO
	smtp24.services.sfr.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752482Ab3AFVXU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2013 16:23:20 -0500
X-Greylist: delayed 621 seconds by postgrey-1.27 at vger.kernel.org; Sun, 06 Jan 2013 16:23:19 EST
X-SFR-UUID: 20130106211255650.9ECD37000098@msfrf2411.sfr.fr
Message-ID: <50E9E8D3.6080504@sfr.fr>
Date: Sun, 06 Jan 2013 22:12:51 +0100
From: Patrice Chotard <patrice.chotard@sfr.fr>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0
	Thunderbird/17.0
MIME-Version: 1.0
To: Emil Goode <emilgoode@gmail.com>
CC: patricechotard@free.fr, martin.blumenstingl@googlemail.com,
        gregkh@linuxfoundation.org, crope@iki.fi, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] [media] ngene: Use newly created function
References: <1357505952-14439-1-git-send-email-emilgoode@gmail.com>
In-Reply-To: <1357505952-14439-1-git-send-email-emilgoode@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Emil,

You are right, there was a missing piece of code.

During merge, part of the orignal patch was missing. I have signaled it
to Mauro who have fixed it in media_tree.

Regards.

Le 06/01/2013 21:59, Emil Goode a écrit :
> The function demod_attach_drxd was split into two by commit 36a495a3.
> This resulted in a new function tuner_attach_dtt7520x that is not used.
> We should register tuner_attach_dtt7520x as a callback in the ngene_info
> struct in the same way as done with the other part of the split function.
> 
> Sparse warning:
> 
> drivers/media/pci/ngene/ngene-cards.c:333:12: warning:
>         ‘tuner_attach_dtt7520x’ defined but not used [-Wunused-function]
> 
> Signed-off-by: Emil Goode <emilgoode@gmail.com>
> ---
> This patch is a guess at what was intended. I'm not familiar with this code
> and I don't have the hardware to test it.
> 
>  drivers/media/pci/ngene/ngene-cards.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/media/pci/ngene/ngene-cards.c b/drivers/media/pci/ngene/ngene-cards.c
> index c99f779..60605c8 100644
> --- a/drivers/media/pci/ngene/ngene-cards.c
> +++ b/drivers/media/pci/ngene/ngene-cards.c
> @@ -732,6 +732,7 @@ static struct ngene_info ngene_info_terratec = {
>  	.name           = "Terratec Integra/Cinergy2400i Dual DVB-T",
>  	.io_type        = {NGENE_IO_TSIN, NGENE_IO_TSIN},
>  	.demod_attach   = {demod_attach_drxd, demod_attach_drxd},
> +	.tuner_attach   = {tuner_attach_dtt7520x, tuner_attach_dtt7520x},
>  	.fe_config      = {&fe_terratec_dvbt_0, &fe_terratec_dvbt_1},
>  	.i2c_access     = 1,
>  };
> 
