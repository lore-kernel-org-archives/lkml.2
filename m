Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753351Ab2IXJQL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 05:16:11 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:28419 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752009Ab2IXJQK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 05:16:10 -0400
Message-id: <506024D5.1050007@samsung.com>
Date: Mon, 24 Sep 2012 11:16:05 +0200
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827
 Thunderbird/15.0
MIME-version: 1.0
Newsgroups: gmane.linux.drivers.video-input-infrastructure,gmane.linux.kernel
To: Peter Senna Tschudin <peter.senna@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] drivers/media/platform/s5p-tv/sdo_drv.c: fix error
 return code
References: <1346775269-12191-4-git-send-email-peter.senna@gmail.com>
 <1346920709-8711-1-git-send-email-peter.senna@gmail.com>
In-reply-to: <1346920709-8711-1-git-send-email-peter.senna@gmail.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On 09/06/2012 10:38 AM, Peter Senna Tschudin wrote:
> From: Peter Senna Tschudin <peter.senna@gmail.com>
> 
> Convert a nonnegative error return code to a negative one, as returned
> elsewhere in the function.
> 
> A simplified version of the semantic match that finds this problem is as
> follows: (http://coccinelle.lip6.fr/)
> 
> // <smpl>
> (
> if@p1 (\(ret < 0\|ret != 0\))
>  { ... return ret; }
> |
> ret@p1 = 0
> )
> ... when != ret = e1
>     when != &ret
> *if(...)
> {
>   ... when != ret = e2
>       when forall
>  return ret;
> }
> 
> // </smpl>
> 
> Signed-off-by: Peter Senna Tschudin <peter.senna@gmail.com>

Acked-by: Tomasz Stanislawski <t.stanislaws@samsung.com>

> 
> ---
>  drivers/media/platform/s5p-tv/sdo_drv.c |    3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/media/platform/s5p-tv/sdo_drv.c b/drivers/media/platform/s5p-tv/sdo_drv.c
> index ad68bbe..58cf56d 100644
> --- a/drivers/media/platform/s5p-tv/sdo_drv.c
> +++ b/drivers/media/platform/s5p-tv/sdo_drv.c
> @@ -369,6 +369,7 @@ static int __devinit sdo_probe(struct platform_device *pdev)
>  	sdev->fout_vpll = clk_get(dev, "fout_vpll");
>  	if (IS_ERR_OR_NULL(sdev->fout_vpll)) {
>  		dev_err(dev, "failed to get clock 'fout_vpll'\n");
> +		ret = -ENXIO;
>  		goto fail_dacphy;
>  	}
>  	dev_info(dev, "fout_vpll.rate = %lu\n", clk_get_rate(sclk_vpll));
> @@ -377,11 +378,13 @@ static int __devinit sdo_probe(struct platform_device *pdev)
>  	sdev->vdac = devm_regulator_get(dev, "vdd33a_dac");
>  	if (IS_ERR_OR_NULL(sdev->vdac)) {
>  		dev_err(dev, "failed to get regulator 'vdac'\n");
> +		ret = -ENXIO;
>  		goto fail_fout_vpll;
>  	}
>  	sdev->vdet = devm_regulator_get(dev, "vdet");
>  	if (IS_ERR_OR_NULL(sdev->vdet)) {
>  		dev_err(dev, "failed to get regulator 'vdet'\n");
> +		ret = -ENXIO;
>  		goto fail_fout_vpll;
>  	}
>  
> 
