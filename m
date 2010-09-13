Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754195Ab0IMVuT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 17:50:19 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:57021 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752710Ab0IMVuR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 17:50:17 -0400
Message-ID: <4C8E9C95.8070201@infradead.org>
Date: Mon, 13 Sep 2010 18:50:13 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100827 Red Hat/3.1.3-1.el6 Lightning/1.0b2 Thunderbird/3.1.3
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: linux-kernel@vger.kernel.org, mjpeg-users@lists.sourceforge.net,
        linux-media@vger.kernel.org
Subject: Re: [PATCH 07/25] drivers/media: Use static const char arrays
References: <cover.1284406638.git.joe@perches.com> <6b7055a2e53510e8903828a53cad300a7d5bb912.1284406638.git.joe@perches.com>
In-Reply-To: <6b7055a2e53510e8903828a53cad300a7d5bb912.1284406638.git.joe@perches.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 13-09-2010 16:47, Joe Perches escreveu:
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  drivers/media/video/zoran/zoran_device.c |    5 ++---
>  1 files changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/media/video/zoran/zoran_device.c b/drivers/media/video/zoran/zoran_device.c
> index 6f846ab..ea8a1e9 100644
> --- a/drivers/media/video/zoran/zoran_device.c
> +++ b/drivers/media/video/zoran/zoran_device.c
> @@ -1470,8 +1470,7 @@ zoran_irq (int             irq,
>  		    (zr->codec_mode == BUZ_MODE_MOTION_DECOMPRESS ||
>  		     zr->codec_mode == BUZ_MODE_MOTION_COMPRESS)) {
>  			if (zr36067_debug > 1 && (!zr->frame_num || zr->JPEG_error)) {
> -				char sc[] = "0000";
> -				char sv[5];
> +				char sv[sizeof("0000")];
>  				int i;
>  
>  				printk(KERN_INFO
> @@ -1481,7 +1480,7 @@ zoran_irq (int             irq,
>  				       zr->jpg_settings.field_per_buff,
>  				       zr->JPEG_missed);
>  
> -				strcpy(sv, sc);
> +				strcpy(sv, "0000");
>  				for (i = 0; i < 4; i++) {
>  					if (le32_to_cpu(zr->stat_com[i]) & 1)
>  						sv[i] = '1';

This looks ugly to me, as someone may change the string at strcpy and not change at sizeof.
Could you please try to work on a better alternative?

The cleaner way seems to be to rewrite it as:

#define BUZ_MODE_STAT	4

char sv[BUZ_MODE_STAT + 1];
...
for (i = 0; i < BUZ_MODE_STAT; i++)
	sv[i] = (le32_to_cpu(zr->stat_com[i]) & 1)? '1' : '0';



Cheers,
Mauro
