Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756095Ab2HGT1X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 15:27:23 -0400
Received: from mailhost.informatik.uni-hamburg.de ([134.100.9.70]:65052 "EHLO
	mailhost.informatik.uni-hamburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755964Ab2HGT1V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 15:27:21 -0400
Message-ID: <50216C98.9020900@metafoo.de>
Date: Tue, 07 Aug 2012 21:29:28 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20120613 Icedove/3.0.11
MIME-Version: 1.0
To: anish kumar <anish198519851985@gmail.com>
CC: myungjoo.ham@samsung.com, cw00.choi@samsung.com, jic23@cam.ac.uk,
        linux-kernel@vger.kernel.org, linux-iio@vger.kernel.org,
        anish kumar <anish.singh@samsung.com>
Subject: Re: [PATCH] [PATCH V3]Extcon: adc_jack: adc-jack driver to support
 3.5 pi or simliar devices
References: <1344322783-28253-1-git-send-email-anish198519851985@gmail.com>
In-Reply-To: <1344322783-28253-1-git-send-email-anish198519851985@gmail.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/07/2012 08:59 AM, anish kumar wrote:
> From: anish kumar <anish198519851985@gmail.com>
> 
> External connector devices that decides connection information based on
> ADC values may use adc-jack device driver. The user simply needs to
> provide a table of adc range and connection states. Then, extcon
> framework will automatically notify others.
> 
> Changes in V1:
> added Lars-Peter Clausen suggested changes:
> Using macros to get rid of boiler plate code such as devm_kzalloc
> and module_platform_driver.Other changes suggested are related to
> coding guidelines.
> 
> Changes in V2:
> Removed some unnecessary checks and changed the way we are un-regitering
> extcon and freeing the irq while removing.
> 
> Changes in this version:
> Renamed the files to comply with extcon naming.
> 
> Signed-off-by: anish kumar <anish.singh@samsung.com>
> Signed-off-by: MyungJoo Ham <myungjoo.ham@samsung.com>

Reviewed-by: Lars-Peter Clausen <lars@metafoo.de>

I missed one thing though in the previous reviews, sorry about that.

> ---
>  drivers/extcon/Kconfig                 |    5 +
>  drivers/extcon/Makefile                |    1 +
>  drivers/extcon/extcon-adc-jack.c       |  193 ++++++++++++++++++++++++++++++++
>  include/linux/extcon/extcon-adc-jack.h |   73 ++++++++++++
>  4 files changed, 272 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/extcon/extcon-adc-jack.c
>  create mode 100644 include/linux/extcon/extcon-adc-jack.h
> +
> +static int __devexit adc_jack_remove(struct platform_device *pdev)
> +{
> +	struct adc_jack_data *data = platform_get_drvdata(pdev);
> +
> +	free_irq(data->irq, data);

We should probably make sure that the work is not pending or running here.

> +	extcon_dev_unregister(&data->edev);
> +
> +	return 0;
> +}


