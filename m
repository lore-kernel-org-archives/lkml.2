Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754439Ab2IWU3b (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Sep 2012 16:29:31 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:46980
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754200Ab2IWU3a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Sep 2012 16:29:30 -0400
Date: Sun, 23 Sep 2012 17:29:22 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Peter Senna Tschudin <peter.senna@gmail.com>
Cc: kernel-janitors@vger.kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers/media/pci/cx25821/cx25821-video-upstream-ch2.c:
 Replace kmemdup for kstrdup
Message-ID: <20120923172922.29f26f5d@infradead.org>
In-Reply-To: <1347281154-29515-1-git-send-email-peter.senna@gmail.com>
References: <1347281154-29515-1-git-send-email-peter.senna@gmail.com>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.11; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, 10 Sep 2012 14:45:54 +0200
Peter Senna Tschudin <peter.senna@gmail.com> escreveu:

> From: Peter Senna Tschudin <peter.senna@gmail.com>
> 
> Replace kmemdup for kstrdup and cleaning up the code.
> 
> Signed-off-by: Peter Senna Tschudin <peter.senna@gmail.com>

Maintainers/interested parties not copied. Also:

Hunk #1 succeeded at 708 (offset 1 line).
Hunk #2 FAILED at 742.
1 out of 2 hunks FAILED -- saving rejects to file drivers/media/pci/cx25821/cx25821-video-upstream-ch2.c.rej
 tmp/cx25821-video-upstream-ch2.c |   27 +++++++++------------------
 1 file changed, 9 insertions(+), 18 deletions(-)

> 
> ---
> It depends on the patch http://patchwork.linuxtv.org/patch/14231/
> 
>  tmp/cx25821-video-upstream-ch2.c |   27 +++++++++------------------
>  1 file changed, 9 insertions(+), 18 deletions(-)
> 
> diff --git a/drivers/media/pci/cx25821/cx25821-video-upstream-ch2.c b/drivers/media/pci/cx25821/cx25821-video-upstream-ch2.c
> index 273df94..b663dac 100644
> --- a/drivers/media/pci/cx25821/cx25821-video-upstream-ch2.c
> +++ b/tmp/cx25821-video-upstream-ch2.c
> @@ -707,7 +707,6 @@ int cx25821_vidupstream_init_ch2(struct cx25821_dev *dev, int channel_select,
>  	int err = 0;
>  	int data_frame_size = 0;
>  	int risc_buffer_size = 0;
> -	int str_length = 0;
>  
>  	if (dev->_is_running_ch2) {
>  		pr_info("Video Channel is still running so return!\n");
> @@ -743,24 +742,16 @@ int cx25821_vidupstream_init_ch2(struct cx25821_dev *dev, int channel_select,
>  	risc_buffer_size = dev->_isNTSC_ch2 ?
>  		NTSC_RISC_BUF_SIZE : PAL_RISC_BUF_SIZE;
>  
> -	if (dev->input_filename_ch2) {
> -		str_length = strlen(dev->input_filename_ch2);
> -		dev->_filename_ch2 = kmemdup(dev->input_filename_ch2,
> -					     str_length + 1, GFP_KERNEL);
> -
> -		if (!dev->_filename_ch2) {
> -			err = -ENOENT;
> -			goto error;
> -		}
> -	} else {
> -		str_length = strlen(dev->_defaultname_ch2);
> -		dev->_filename_ch2 = kmemdup(dev->_defaultname_ch2,
> -					     str_length + 1, GFP_KERNEL);
> +	if (dev->input_filename_ch2)
> +		dev->_filename_ch2 = kstrdup(dev->input_filename_ch2,
> +								GFP_KERNEL);
> +	else
> +		dev->_filename_ch2 = kstrdup(dev->_defaultname_ch2,
> +								GFP_KERNEL);
>  
> -		if (!dev->_filename_ch2) {
> -			err = -ENOENT;
> -			goto error;
> -		}
> +	if (!dev->_filename_ch2) {
> +		err = -ENOENT;
> +		goto error;
>  	}
>  
>  	/* Default if filename is empty string */
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html




Cheers,
Mauro
