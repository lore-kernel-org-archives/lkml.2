Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754413Ab0DFL2D (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 07:28:03 -0400
Received: from ppsw-7.csi.cam.ac.uk ([131.111.8.137]:59714 "EHLO
	ppsw-7.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753279Ab0DFL15 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 07:27:57 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4BBB1B58.2000405@cam.ac.uk>
Date: Tue, 06 Apr 2010 12:30:32 +0100
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20100109 Thunderbird/3.0
MIME-Version: 1.0
To: sonic zhang <sonic.adi@gmail.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
       linux-iio <linux-iio@vger.kernel.org>
Subject: Re: [PATCH] IIO: struct iio_dev_attr should be defined as static.
References: <1270176948.3847.1.camel@eight.analog.com>
In-Reply-To: <1270176948.3847.1.camel@eight.analog.com>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/02/10 03:55, sonic zhang wrote:
> 
> Otherwise link errors "multiple definition of `iio_dev_attr_mode'"
> are reported when compile multiple different iio drivers with the
> same attribute name.

Hi Sonic,

Sorry for slow response had long weekend away from all computers!

NAK.  The right place to do this is in the call of the macro, not
in the macro itself. See the many examples in hwmon....

So 

static IIO_DEVICE_ATTR(accel_x, .... etc

This makes it explicit in the drivers.

There were a few calls that were missing this in the mainline driver
set but I think they are all fixed in patches that have gone to Greg
for merging. (Michael Hennerich's patch - the second one in the thread
[PATCH] IIO:sysfs.h: Use static declaration.
The first was as per your patch).

iirc there are a few exceptions where the static is in the header
due to the macro defining a pair of static structures.  Not sure if
there is a cleaner way to handle that.

Thanks,

Jonathan


> 
> Signed-off-by: Sonic Zhang <sonic.adi@gmail.com>
> ---
>  drivers/staging/iio/sysfs.h |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/staging/iio/sysfs.h b/drivers/staging/iio/sysfs.h
> index e501e13..39d207e 100644
> --- a/drivers/staging/iio/sysfs.h
> +++ b/drivers/staging/iio/sysfs.h
> @@ -95,16 +95,16 @@ struct iio_const_attr {
>  			.val2 = _val2 }
>  
>  #define IIO_DEVICE_ATTR(_name, _mode, _show, _store, _addr)	\
> -	struct iio_dev_attr iio_dev_attr_##_name		\
> +	static struct iio_dev_attr iio_dev_attr_##_name		\
>  	= IIO_ATTR(_name, _mode, _show, _store, _addr)
>  
>  
>  #define IIO_DEVICE_ATTR_2(_name, _mode, _show, _store, _addr, _val2)	\
> -	struct iio_dev_attr iio_dev_attr_##_name			\
> +	static struct iio_dev_attr iio_dev_attr_##_name			\
>  	= IIO_ATTR_2(_name, _mode, _show, _store, _addr, _val2)
>  
>  #define IIO_CONST_ATTR(_name, _string)					\
> -	struct iio_const_attr iio_const_attr_##_name			\
> +	static struct iio_const_attr iio_const_attr_##_name			\
>  	= { .string = _string,						\
>  	    .dev_attr = __ATTR(_name, S_IRUGO, iio_read_const_attr, NULL)}
>  

