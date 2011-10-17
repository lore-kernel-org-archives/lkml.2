Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753586Ab1JQQ1d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 12:27:33 -0400
Received: from ppsw-52.csi.cam.ac.uk ([131.111.8.152]:37794 "EHLO
	ppsw-52.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752967Ab1JQQ1c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 12:27:32 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4E9C5777.5040904@cam.ac.uk>
Date: Mon, 17 Oct 2011 17:27:35 +0100
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20111003 Thunderbird/7.0.1
MIME-Version: 1.0
To: Jonathan Cameron <jic23@cam.ac.uk>
CC: linux-kernel@vger.kernel.org, linux-iio@vger.kernel.org,
        guenter.roeck@ericsson.com, khali@linux-fr.org,
        dmitry.torokhov@gmail.com, broonie@opensource.wolfsonmicro.com,
        gregkh@suse.de, alan@lxorguk.ukuu.org.uk, arnd@arndb.de
Subject: Re: [PATCH 1/6] IIO: Core sysfs only support.
References: <1318857381-13787-1-git-send-email-jic23@cam.ac.uk> <1318857381-13787-2-git-send-email-jic23@cam.ac.uk>
In-Reply-To: <1318857381-13787-2-git-send-email-jic23@cam.ac.uk>
X-Enigmail-Version: 1.4a1pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/17/11 14:16, Jonathan Cameron wrote:
> Add support for simple sysfs only interfaces.
> 
> Bulk of patch is concerned with taking struct iio_chan_spec
> arrays and generating all the relevant interfaces from them.
Sorry all, one little rather debilitating buglet in here.
Means no attrs actually get registered.
...
> +struct iio_dev *iio_device_allocate(int sizeof_priv)
> +{
> +	struct iio_dev *dev;
> +	size_t alloc_size;
> +
> +	alloc_size = sizeof(struct iio_dev);
> +	if (sizeof_priv) {
> +		alloc_size = ALIGN(alloc_size, IIO_ALIGN);
> +		alloc_size += sizeof_priv;
> +	}
> +	/* ensure cacheline alignment of whole construct */
> +	alloc_size += IIO_ALIGN - 1;
> +
> +	dev = kzalloc(alloc_size, GFP_KERNEL);
> +
> +	if (dev) {
Following line was missing for some reason.

		dev->dev.groups = dev->groups;
> +		dev->dev.type = &iio_dev_type;
> +		dev->dev.bus = &iio_bus_type;
> +		device_initialize(&dev->dev);
> +		dev_set_drvdata(&dev->dev, (void *)dev);
> +		mutex_init(&dev->mlock);
> +	}
> +
> +	return dev;
> +}
> +EXPORT_SYMBOL_GPL(iio_device_allocate);
..
