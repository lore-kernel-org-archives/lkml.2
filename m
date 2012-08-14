Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752465Ab2HNFCp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 01:02:45 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:58125 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751684Ab2HNFCo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 01:02:44 -0400
Message-ID: <5029DBE5.7080106@ti.com>
Date: Tue, 14 Aug 2012 10:32:29 +0530
From: Prabhakar Lad <prabhakar.lad@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@infradead.org>
CC: Prabhakar Lad <prabhakar.lad@ti.com>, LMML <linux-media@vger.kernel.org>,
        dlos <davinci-linux-open-source@linux.davincidsp.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] davinci: fix build warning when CONFIG_DEBUG_SECTION_MISMATCH
 is enabled
References: <1344850337-6852-1-git-send-email-prabhakar.lad@ti.com>
In-Reply-To: <1344850337-6852-1-git-send-email-prabhakar.lad@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mauro,

Please drop this patch which is queued for 3.7, the actual fix should be
to annotate probe with __devinit. I'll be sending V2 with the correct fix.

Thx,
--Prabhakar

On Monday 13 August 2012 03:02 PM, Prabhakar Lad wrote:
> From: Lad, Prabhakar <prabhakar.lad@ti.com>
> 
> Signed-off-by: Lad, Prabhakar <prabhakar.lad@ti.com>
> Signed-off-by: Manjunath Hadli <manjunath.hadli@ti.com>
> ---
>  drivers/media/video/davinci/dm355_ccdc.c   |    2 +-
>  drivers/media/video/davinci/dm644x_ccdc.c  |    2 +-
>  drivers/media/video/davinci/isif.c         |    2 +-
>  drivers/media/video/davinci/vpfe_capture.c |    2 +-
>  drivers/media/video/davinci/vpif.c         |    2 +-
>  drivers/media/video/davinci/vpss.c         |    2 +-
>  6 files changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/media/video/davinci/dm355_ccdc.c b/drivers/media/video/davinci/dm355_ccdc.c
> index 5b68847..2eb7dbd 100644
> --- a/drivers/media/video/davinci/dm355_ccdc.c
> +++ b/drivers/media/video/davinci/dm355_ccdc.c
> @@ -1060,7 +1060,7 @@ static int dm355_ccdc_remove(struct platform_device *pdev)
>  	return 0;
>  }
>  
> -static struct platform_driver dm355_ccdc_driver = {
> +static __refdata struct platform_driver dm355_ccdc_driver = {
>  	.driver = {
>  		.name	= "dm355_ccdc",
>  		.owner = THIS_MODULE,
> diff --git a/drivers/media/video/davinci/dm644x_ccdc.c b/drivers/media/video/davinci/dm644x_ccdc.c
> index 9303fe5..3ffb7f2 100644
> --- a/drivers/media/video/davinci/dm644x_ccdc.c
> +++ b/drivers/media/video/davinci/dm644x_ccdc.c
> @@ -1068,7 +1068,7 @@ static const struct dev_pm_ops dm644x_ccdc_pm_ops = {
>  	.resume = dm644x_ccdc_resume,
>  };
>  
> -static struct platform_driver dm644x_ccdc_driver = {
> +static __refdata struct platform_driver dm644x_ccdc_driver = {
>  	.driver = {
>  		.name	= "dm644x_ccdc",
>  		.owner = THIS_MODULE,
> diff --git a/drivers/media/video/davinci/isif.c b/drivers/media/video/davinci/isif.c
> index 5278fe7..6ce4249 100644
> --- a/drivers/media/video/davinci/isif.c
> +++ b/drivers/media/video/davinci/isif.c
> @@ -1148,7 +1148,7 @@ static int isif_remove(struct platform_device *pdev)
>  	return 0;
>  }
>  
> -static struct platform_driver isif_driver = {
> +static __refdata struct platform_driver isif_driver = {
>  	.driver = {
>  		.name	= "isif",
>  		.owner = THIS_MODULE,
> diff --git a/drivers/media/video/davinci/vpfe_capture.c b/drivers/media/video/davinci/vpfe_capture.c
> index 49a845f..572d8f0 100644
> --- a/drivers/media/video/davinci/vpfe_capture.c
> +++ b/drivers/media/video/davinci/vpfe_capture.c
> @@ -2066,7 +2066,7 @@ static const struct dev_pm_ops vpfe_dev_pm_ops = {
>  	.resume = vpfe_resume,
>  };
>  
> -static struct platform_driver vpfe_driver = {
> +static __refdata struct platform_driver vpfe_driver = {
>  	.driver = {
>  		.name = CAPTURE_DRV_NAME,
>  		.owner = THIS_MODULE,
> diff --git a/drivers/media/video/davinci/vpif.c b/drivers/media/video/davinci/vpif.c
> index b3637af..a058fed 100644
> --- a/drivers/media/video/davinci/vpif.c
> +++ b/drivers/media/video/davinci/vpif.c
> @@ -490,7 +490,7 @@ static const struct dev_pm_ops vpif_pm = {
>  #define vpif_pm_ops NULL
>  #endif
>  
> -static struct platform_driver vpif_driver = {
> +static __refdata struct platform_driver vpif_driver = {
>  	.driver = {
>  		.name	= "vpif",
>  		.owner = THIS_MODULE,
> diff --git a/drivers/media/video/davinci/vpss.c b/drivers/media/video/davinci/vpss.c
> index 3e5cf27..8f682d8 100644
> --- a/drivers/media/video/davinci/vpss.c
> +++ b/drivers/media/video/davinci/vpss.c
> @@ -460,7 +460,7 @@ static int __devexit vpss_remove(struct platform_device *pdev)
>  	return 0;
>  }
>  
> -static struct platform_driver vpss_driver = {
> +static __refdata struct platform_driver vpss_driver = {
>  	.driver = {
>  		.name	= "vpss",
>  		.owner = THIS_MODULE,
> 

