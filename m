Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965120Ab2DLO2D (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 10:28:03 -0400
Received: from ppsw-41.csi.cam.ac.uk ([131.111.8.141]:54054 "EHLO
	ppsw-41.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964887Ab2DLO2B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 10:28:01 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4F86E667.6060606@cam.ac.uk>
Date: Thu, 12 Apr 2012 15:27:51 +0100
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:11.0) Gecko/20120327 Thunderbird/11.0.1
MIME-Version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>
CC: gregkh@linuxfoundation.org, grant.likely@secretlab.ca,
        rob.herring@calxeda.com, jbrenner@taosinc.com, rklein@nvidia.com,
        max@stro.at, linux-iio@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH V4 1/2] staging: iio: add channel info for sampling frequency
References: <1334239266-29505-1-git-send-email-ldewangan@nvidia.com> <1334239266-29505-2-git-send-email-ldewangan@nvidia.com>
In-Reply-To: <1334239266-29505-2-git-send-email-ldewangan@nvidia.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/12/2012 3:01 PM, Laxman Dewangan wrote:
> Adding channel info IIO_CHAN_INFO_SAMP_FREQ to select
> different sampling frequency per channel wise.
>
> Signed-off-by: Laxman Dewangan<ldewangan@nvidia.com>
Acked-by: Jonathan Cameron <jic23@kernel.org>
> ---
> changes from V3:
>   - Change the info name to "sampling_frequency"
>
>   drivers/staging/iio/iio.h               |    5 +++++
>   drivers/staging/iio/industrialio-core.c |    1 +
>   2 files changed, 6 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/staging/iio/iio.h b/drivers/staging/iio/iio.h
> index b9cd454..9aa0dd5 100644
> --- a/drivers/staging/iio/iio.h
> +++ b/drivers/staging/iio/iio.h
> @@ -36,6 +36,7 @@ enum iio_chan_info_enum {
>   	IIO_CHAN_INFO_QUADRATURE_CORRECTION_RAW,
>   	IIO_CHAN_INFO_AVERAGE_RAW,
>   	IIO_CHAN_INFO_LOW_PASS_FILTER_3DB_FREQUENCY,
> +	IIO_CHAN_INFO_SAMP_FREQ,
>   };
>
>   #define IIO_CHAN_INFO_SHARED_BIT(type) BIT(type*2)
> @@ -81,6 +82,10 @@ enum iio_chan_info_enum {
>   #define IIO_CHAN_INFO_LOW_PASS_FILTER_3DB_FREQUENCY_SEPARATE_BIT \
>   	IIO_CHAN_INFO_SEPARATE_BIT(			       \
>   		IIO_CHAN_INFO_LOW_PASS_FILTER_3DB_FREQUENCY)
> +#define IIO_CHAN_INFO_SAMP_FREQ_SEPARATE_BIT		\
> +	IIO_CHAN_INFO_SEPARATE_BIT(IIO_CHAN_INFO_SAMP_FREQ)
> +#define IIO_CHAN_INFO_SAMP_FREQ_SHARED_BIT			\
> +	IIO_CHAN_INFO_SHARED_BIT(IIO_CHAN_INFO_SAMP_FREQ)
>
>   enum iio_endian {
>   	IIO_CPU,
> diff --git a/drivers/staging/iio/industrialio-core.c b/drivers/staging/iio/industrialio-core.c
> index d303bfb..9e42713 100644
> --- a/drivers/staging/iio/industrialio-core.c
> +++ b/drivers/staging/iio/industrialio-core.c
> @@ -90,6 +90,7 @@ static const char * const iio_chan_info_postfix[] = {
>   	[IIO_CHAN_INFO_AVERAGE_RAW] = "mean_raw",
>   	[IIO_CHAN_INFO_LOW_PASS_FILTER_3DB_FREQUENCY]
>   	= "filter_low_pass_3db_frequency",
> +	[IIO_CHAN_INFO_SAMP_FREQ] = "sampling_frequency",
>   };
>
>   const struct iio_chan_spec

