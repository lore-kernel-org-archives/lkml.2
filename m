Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754056Ab1DFK6M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 06:58:12 -0400
Received: from ppsw-41.csi.cam.ac.uk ([131.111.8.141]:59870 "EHLO
	ppsw-41.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750807Ab1DFK6L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 06:58:11 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4D9C477E.4050400@cam.ac.uk>
Date: Wed, 06 Apr 2011 11:59:10 +0100
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20110122 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: Sonny Rao <sonnyrao@chromium.org>
CC: linux-pm@lists.linux-foundation.org, bleung@chromium.org,
        snanda@chromium.org, Greg Kroah-Hartman <gregkh@suse.de>,
        Manuel Stahl <manuel.stahl@iis.fraunhofer.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Phillip Kurtenbach <pkurtenbach@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>
Subject: Re: [PATCH] Enable async suspend/resume on industrial IO devices
References: <1302057915-13549-1-git-send-email-sonnyrao@chromium.org>
In-Reply-To: <1302057915-13549-1-git-send-email-sonnyrao@chromium.org>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/06/11 03:45, Sonny Rao wrote:
> Industrial I/O devices can sometimes take a long time to resume,
> allowing them to be asynchronus saves 50ms on one light sensor
> 
Hi Sonny,

cc'd linux-iio

I'm not particularly familiar with this.  Are there any disadvantages?
I just wonder if it would be better to push this into individual drivers
rather than the core?

Jonathan
> Signed-off-by: Sonny Rao <sonnyrao@chromium.org>
> 
> ---
>  drivers/staging/iio/industrialio-core.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/staging/iio/industrialio-core.c b/drivers/staging/iio/industrialio-core.c
> index 768f448..a4b099f 100644
> --- a/drivers/staging/iio/industrialio-core.c
> +++ b/drivers/staging/iio/industrialio-core.c
> @@ -811,6 +811,8 @@ int iio_device_register(struct iio_dev *dev_info)
>  	if (dev_info->modes & INDIO_RING_TRIGGERED)
>  		iio_device_register_trigger_consumer(dev_info);
>  
> +	device_enable_async_suspend(&dev_info->dev);
> +
>  	return 0;
>  
>  error_free_sysfs:

