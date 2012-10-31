Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422709Ab2JaKgI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 06:36:08 -0400
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:48475 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932340Ab2JaKgB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 06:36:01 -0400
Message-ID: <5090FF0C.90204@kernel.org>
Date: Wed, 31 Oct 2012 10:35:56 +0000
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121012 Thunderbird/16.0.1
MIME-Version: 1.0
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
CC: srinivas pandruvada <srinivas.pandruvada@intel.com>,
        Jonathan Cameron <jic23@cam.ac.uk>, linux-iio@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] iio: hid-sensors: convert HID_SENSOR_ENUM_BASE_QUIRKS
 to bool
References: <1350892674-4000-1-git-send-email-kirill.shutemov@linux.intel.com>
In-Reply-To: <1350892674-4000-1-git-send-email-kirill.shutemov@linux.intel.com>
X-Enigmail-Version: 1.4.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/22/2012 08:57 AM, Kirill A. Shutemov wrote:
> From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
> 
> It's non-sense to use tristate for the option, it's bool.
> 
Good point.

Applied to fixes-togreg branch of

git://git.kernel.org/pub/scm/linux/kernel/git/jic23/iio.git

Thanks,

Jonathan

> Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> ---
>  drivers/iio/common/hid-sensors/Kconfig              |    2 +-
>  drivers/iio/common/hid-sensors/hid-sensor-trigger.c |    6 ++----
>  2 files changed, 3 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/iio/common/hid-sensors/Kconfig b/drivers/iio/common/hid-sensors/Kconfig
> index 8e63d81..ae10778 100644
> --- a/drivers/iio/common/hid-sensors/Kconfig
> +++ b/drivers/iio/common/hid-sensors/Kconfig
> @@ -15,7 +15,7 @@ config HID_SENSOR_IIO_COMMON
>  	  attributes.
>  
>  config HID_SENSOR_ENUM_BASE_QUIRKS
> -	tristate "ENUM base quirks for HID Sensor IIO drivers"
> +	bool "ENUM base quirks for HID Sensor IIO drivers"
>  	depends on HID_SENSOR_IIO_COMMON
>  	help
>  	  Say yes here to build support for sensor hub FW using
> diff --git a/drivers/iio/common/hid-sensors/hid-sensor-trigger.c b/drivers/iio/common/hid-sensors/hid-sensor-trigger.c
> index d4b790d..d60198a 100644
> --- a/drivers/iio/common/hid-sensors/hid-sensor-trigger.c
> +++ b/drivers/iio/common/hid-sensors/hid-sensor-trigger.c
> @@ -36,10 +36,8 @@ static int hid_sensor_data_rdy_trigger_set_state(struct iio_trigger *trig,
>  	int state_val;
>  
>  	state_val = state ? 1 : 0;
> -#if (defined CONFIG_HID_SENSOR_ENUM_BASE_QUIRKS) || \
> -	(defined CONFIG_HID_SENSOR_ENUM_BASE_QUIRKS_MODULE)
> -	++state_val;
> -#endif
> +	if (IS_ENABLED(CONFIG_HID_SENSOR_ENUM_BASE_QUIRKS))
> +		++state_val;
>  	st->data_ready = state;
>  	sensor_hub_set_feature(st->hsdev, st->power_state.report_id,
>  					st->power_state.index,
> 
