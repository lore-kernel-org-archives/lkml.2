Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932426Ab1LOKBZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 05:01:25 -0500
Received: from newsmtp5.atmel.com ([204.2.163.5]:38425 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932400Ab1LOKBX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 05:01:23 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH v3 2/2] [media] V4L: atmel-isi: add clk_prepare()/clk_unprepare() functions
Date: Thu, 15 Dec 2011 18:00:41 +0800
Message-ID: <4C79549CB6F772498162A641D92D532803B5255C@penmb01.corp.atmel.com>
In-Reply-To: <1323339530-26117-2-git-send-email-josh.wu@atmel.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH v3 2/2] [media] V4L: atmel-isi: add clk_prepare()/clk_unprepare() functions
Thread-Index: Acy1ksmUMD6ekrEGTY+MOntut/EfKQFe+pGw
References: <1323339530-26117-1-git-send-email-josh.wu@atmel.com> <1323339530-26117-2-git-send-email-josh.wu@atmel.com>
From: "Wu, Josh" <Josh.wu@atmel.com>
To: "Wu, Josh" <Josh.wu@atmel.com>, <g.liakhovetski@gmx.de>,
        <linux-media@vger.kernel.org>, <linux@arm.linux.org.uk>
Cc: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        "Ferre, Nicolas" <Nicolas.FERRE@atmel.com>
X-OriginalArrivalTime: 15 Dec 2011 10:00:46.0053 (UTC) FILETIME=[6A14F150:01CCBB10]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Guennadi

Would you acknowledge these two v3 patches and queue them for 3.3 merge
window? Thanks.

Best Regards,
Josh Wu

On Thursday, December 08, 2011 6:19 PM, Josh Wu wrote:

> Signed-off-by: Josh Wu <josh.wu@atmel.com>
> ---
> in v2 version, made the label name to be consistent

> drivers/media/video/atmel-isi.c |   15 +++++++++++++++
> 1 files changed, 15 insertions(+), 0 deletions(-)

> diff --git a/drivers/media/video/atmel-isi.c
b/drivers/media/video/atmel-isi.c
> index ea4eef4..91ebcfb 100644
> --- a/drivers/media/video/atmel-isi.c
> +++ b/drivers/media/video/atmel-isi.c
> @@ -922,7 +922,9 @@ static int __devexit atmel_isi_remove(struct
platform_device *pdev)
> 			isi->fb_descriptors_phys);
 
> 	iounmap(isi->regs);
> +	clk_unprepare(isi->mck);
> 	clk_put(isi->mck);
> +	clk_unprepare(isi->pclk);
> 	clk_put(isi->pclk);
> 	kfree(isi);
 
> @@ -955,6 +957,12 @@ static int __devinit atmel_isi_probe(struct
platform_device *pdev)
>  	if (IS_ERR(pclk))
> 		return PTR_ERR(pclk);
 
> +	ret = clk_prepare(pclk);
> +	if (ret) {
> +		clk_put(pclk);
> +		return ret;
> +	}
> +
> 	isi = kzalloc(sizeof(struct atmel_isi), GFP_KERNEL);
> 	if (!isi) {
> 		ret = -ENOMEM;
> @@ -978,6 +986,10 @@ static int __devinit atmel_isi_probe(struct
platform_device *pdev)
> 		goto err_clk_get;
> 	}
> 
> +	ret = clk_prepare(isi->mck);
> +	if (ret)
> +		goto err_clk_prepare_mck;
> +
> 	/* Set ISI_MCK's frequency, it should be faster than pixel clock
*/
> 	ret = clk_set_rate(isi->mck, pdata->mck_hz);
> 	if (ret < 0)
> @@ -1059,10 +1071,13 @@ err_alloc_ctx:
> 			isi->fb_descriptors_phys);
> err_alloc_descriptors:
> err_set_mck_rate:
> +	clk_unprepare(isi->mck);
> +err_clk_prepare_mck:
> 	clk_put(isi->mck);
> err_clk_get:
> 	kfree(isi);
> err_alloc_isi:
> +	clk_unprepare(pclk);
> 	clk_put(pclk);
> 
> 	return ret;
> -- 
> 1.6.3.3

