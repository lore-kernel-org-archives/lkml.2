Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932161Ab2IMNCp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 09:02:45 -0400
Received: from smtp-out-026.synserver.de ([212.40.185.26]:1253 "EHLO
	smtp-out-026.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932130Ab2IMNCn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 09:02:43 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 1962
Message-ID: <5051D92F.1090309@metafoo.de>
Date: Thu, 13 Sep 2012 15:01:35 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.6esrpre) Gecko/20120817 Icedove/10.0.6
MIME-Version: 1.0
To: "Patil, Rachna" <rachna@ti.com>
CC: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        linux-iio@vger.kernel.org, Samuel Ortiz <sameo@linux.intel.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Dmitry Torokhov <dtor@mail.ru>, Jonathan Cameron <jic23@cam.ac.uk>
Subject: Re: [PATCH v3 5/5] MFD: ti_tscadc: add suspend/resume functionality
References: <1347532819-505-1-git-send-email-rachna@ti.com> <1347532819-505-6-git-send-email-rachna@ti.com>
In-Reply-To: <1347532819-505-6-git-send-email-rachna@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/13/2012 12:40 PM, Patil, Rachna wrote:
> This patch adds support for suspend/resume of
> TSC/ADC MFDevice.
> 
> Signed-off-by: Patil, Rachna <rachna@ti.com>
> ---
> Changes in v2:
> 	Added this patch newly in this patch series.
> 
> Changes in v3:
> 	No changes.
> 
>  drivers/iio/adc/ti_adc.c           |   32 ++++++++++++++++++++++++++++++++
>  drivers/input/touchscreen/ti_tsc.c |   33 +++++++++++++++++++++++++++++++++
>  drivers/mfd/ti_tscadc.c            |   33 ++++++++++++++++++++++++++++++++-
>  include/linux/mfd/ti_tscadc.h      |    3 +++
>  4 files changed, 100 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/iio/adc/ti_adc.c b/drivers/iio/adc/ti_adc.c
> index 56f8af2..69f19f0 100644
> --- a/drivers/iio/adc/ti_adc.c
> +++ b/drivers/iio/adc/ti_adc.c
> @@ -207,6 +207,36 @@ static int __devexit tiadc_remove(struct platform_device *pdev)
>  	return 0;
>  }
>  
[...]
>  static struct platform_driver tiadc_driver = {
>  	.driver = {
>  		.name   = "tiadc",
> @@ -214,6 +244,8 @@ static struct platform_driver tiadc_driver = {
>  	},
>  	.probe	= tiadc_probe,
>  	.remove	= __devexit_p(tiadc_remove),
> +	.suspend = adc_suspend,
> +	.resume = adc_resume,
>  };
>  


Using the suspend/resume callbacks is deprecated, please use dev_pm_ops.
Same comment applies to the other two drivers.


