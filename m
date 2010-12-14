Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932218Ab0LNPKV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 10:10:21 -0500
Received: from ppsw-50.csi.cam.ac.uk ([131.111.8.150]:39179 "EHLO
	ppsw-50.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759311Ab0LNPKL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 10:10:11 -0500
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4D0788D8.5080905@cam.ac.uk>
Date: Tue, 14 Dec 2010 15:10:16 +0000
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101213 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: michael.hennerich@analog.com
CC: linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org,
        drivers@analog.com, device-drivers-devel@blackfin.uclinux.org
Subject: Re: [PATCH 2/3] IIO: dds.h convenience macros
References: <1292338462-4299-1-git-send-email-michael.hennerich@analog.com> <1292338462-4299-2-git-send-email-michael.hennerich@analog.com>
In-Reply-To: <1292338462-4299-2-git-send-email-michael.hennerich@analog.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/14/10 14:54, michael.hennerich@analog.com wrote:
> From: Michael Hennerich <michael.hennerich@analog.com>
> 
> Changes since RFC/v1:
> IIO: Apply list review feedback
> 
> Apply list review feedback:
> 	Rename attributes to fit IIO convention used in other drivers.
> 	Provide ddsX_out_enable as opposed to ddsX_out_disable.
> 	Fix typos.
> 
> Changes since v2:
> IIO: dds.h: Apply more list review feedback
> 
> 	Fix mixture of X and [n] notation for indices.
> 	Remove duplicated descriptions.
> 	Add store methods to some dds convenience macros.
> 
> Signed-off-by: Michael Hennerich <michael.hennerich@analog.com>
Acked-by: Jonathan Cameron <jic23@cam.ac.uk>
> ---
>  drivers/staging/iio/dds/dds.h |  110 +++++++++++++++++++++++++++++++++++++++++
>  1 files changed, 110 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/staging/iio/dds/dds.h
> 
> diff --git a/drivers/staging/iio/dds/dds.h b/drivers/staging/iio/dds/dds.h
> new file mode 100644
> index 0000000..d8ac3a9
> --- /dev/null
> +++ b/drivers/staging/iio/dds/dds.h
> @@ -0,0 +1,110 @@
> +/*
> + * dds.h - sysfs attributes associated with DDS devices
> + *
> + * Copyright (c) 2010 Analog Devices Inc.
> + *
> + * Licensed under the GPL-2 or later.
> + */
> +
> +/**
> + * /sys/bus/iio/devices/.../ddsX_freqY
> + */
> +
> +#define IIO_DEV_ATTR_FREQ(_channel, _num, _mode, _show, _store, _addr)	\
> +	IIO_DEVICE_ATTR(dds##_channel##_freq##_num,			\
> +			_mode, _show, _store, _addr)
> +
> +/**
> + * /sys/bus/iio/devices/.../ddsX_freqY_scale
> + */
> +
> +#define IIO_CONST_ATTR_FREQ_SCALE(_channel, _string)			\
> +	IIO_CONST_ATTR(dds##_channel##_freq_scale, _string)
> +
> +/**
> + * /sys/bus/iio/devices/.../ddsX_freqsymbol
> + */
> +
> +#define IIO_DEV_ATTR_FREQSYMBOL(_channel, _mode, _show, _store, _addr)	\
> +	IIO_DEVICE_ATTR(dds##_channel##_freqsymbol,			\
> +			_mode, _show, _store, _addr);
> +
> +/**
> + * /sys/bus/iio/devices/.../ddsX_phaseY
> + */
> +
> +#define IIO_DEV_ATTR_PHASE(_channel, _num, _mode, _show, _store, _addr)	\
> +	IIO_DEVICE_ATTR(dds##_channel##_phase##_num,			\
> +			_mode, _show, _store, _addr)
> +
> +/**
> + * /sys/bus/iio/devices/.../ddsX_phaseY_scale
> + */
> +
> +#define IIO_CONST_ATTR_PHASE_SCALE(_channel, _string)			\
> +	IIO_CONST_ATTR(dds##_channel##_phase_scale, _string)
> +
> +/**
> + * /sys/bus/iio/devices/.../ddsX_phasesymbol
> + */
> +
> +#define IIO_DEV_ATTR_PHASESYMBOL(_channel, _mode, _show, _store, _addr)	\
> +	IIO_DEVICE_ATTR(dds##_channel##_phasesymbol,			\
> +			_mode, _show, _store, _addr);
> +
> +/**
> + * /sys/bus/iio/devices/.../ddsX_pincontrol_en
> + */
> +
> +#define IIO_DEV_ATTR_PINCONTROL_EN(_channel, _mode, _show, _store, _addr)\
> +	IIO_DEVICE_ATTR(dds##_channel##_pincontrol_en,			\
> +			_mode, _show, _store, _addr);
> +
> +/**
> + * /sys/bus/iio/devices/.../ddsX_pincontrol_freq_en
> + */
> +
> +#define IIO_DEV_ATTR_PINCONTROL_FREQ_EN(_channel, _mode, _show, _store, _addr)\
> +	IIO_DEVICE_ATTR(dds##_channel##_pincontrol_freq_en,		\
> +			_mode, _show, _store, _addr);
> +
> +/**
> + * /sys/bus/iio/devices/.../ddsX_pincontrol_phase_en
> + */
> +
> +#define IIO_DEV_ATTR_PINCONTROL_PHASE_EN(_channel, _mode, _show, _store, _addr)\
> +	IIO_DEVICE_ATTR(dds##_channel##_pincontrol_phase_en,		\
> +			_mode, _show, _store, _addr);
> +
> +/**
> + * /sys/bus/iio/devices/.../ddsX_out_enable
> + */
> +
> +#define IIO_DEV_ATTR_OUT_ENABLE(_channel, _mode, _show, _store, _addr)	\
> +	IIO_DEVICE_ATTR(dds##_channel##_out_enable,			\
> +			_mode, _show, _store, _addr);
> +
> +/**
> + * /sys/bus/iio/devices/.../ddsX_outY_enable
> + */
> +
> +#define IIO_DEV_ATTR_OUTY_ENABLE(_channel, _output,			\
> +			_mode, _show, _store, _addr)			\
> +	IIO_DEVICE_ATTR(dds##_channel##_out##_output##_enable,		\
> +			_mode, _show, _store, _addr);
> +
> +/**
> + * /sys/bus/iio/devices/.../ddsX_outY_wavetype
> + */
> +
> +#define IIO_DEV_ATTR_OUT_WAVETYPE(_channel, _output, _store, _addr)	\
> +	IIO_DEVICE_ATTR(dds##_channel##_out##_output##_wavetype,	\
> +			S_IWUSR, NULL, _store, _addr);
> +
> +/**
> + * /sys/bus/iio/devices/.../ddsX_outY_wavetype_available
> + */
> +
> +#define IIO_CONST_ATTR_OUT_WAVETYPES_AVAILABLE(_channel, _output, _modes)\
> +	IIO_CONST_ATTR(dds##_channel##_out##_output##_wavetype_available,\
> +			_modes);
> --
> 1.6.0.2
> 
> 

