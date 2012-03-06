Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030939Ab2CFUD7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 15:03:59 -0500
Received: from oproxy3-pub.bluehost.com ([69.89.21.8]:45871 "HELO
	oproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1030374Ab2CFUD5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 15:03:57 -0500
Message-ID: <4F566D7A.1030400@xenotime.net>
Date: Tue, 06 Mar 2012 12:03:06 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Lars-Peter Clausen <lars@metafoo.de>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jonathan Cameron <jic23@cam.ac.uk>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Michael Hennerich <michael.hennerich@analog.com>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-iio@vger.kernel.org
Subject: Re: [PATCH] staging:iio: Fix compile error without CONFIG_DEBUG_FS
References: <4F565CB0.8070301@xenotime.net> <1331063025-25242-1-git-send-email-lars@metafoo.de>
In-Reply-To: <1331063025-25242-1-git-send-email-lars@metafoo.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/06/2012 11:43 AM, Lars-Peter Clausen wrote:

> commit e553f182d ("staging: iio: core: Introduce debugfs support, add support
> for direct register access") added a '#if defined(CONFIG_DEBUG_FS)' around
> iio_read_channel_ext_info and iio_write_channel_ext_info causing the following
> compile error if CONFIG_DEBUG_FS is not defined.
> 
> 	drivers/staging/iio/industrialio-core.c:621:11: error: 'iio_read_channel_ext_info' undeclared (first use in this function)
> 	drivers/staging/iio/industrialio-core.c:623:11: error: 'iio_write_channel_ext_info' undeclared (first use in this function)
> 
> This patch fixes the issue by moving the functions out of the '#if
> defined(CONFIG_DEBUG_FS)' section again.
> 
> Reported-by: Randy Dunlap <rdunlap@xenotime.net>
> Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>


Acked-by: Randy Dunlap <rdunlap@xenotime.net>

Thanks.


> ---
>  drivers/staging/iio/industrialio-core.c |   54 +++++++++++++++---------------
>  1 files changed, 27 insertions(+), 27 deletions(-)
> 
> diff --git a/drivers/staging/iio/industrialio-core.c b/drivers/staging/iio/industrialio-core.c
> index 27695df..d303bfb 100644
> --- a/drivers/staging/iio/industrialio-core.c
> +++ b/drivers/staging/iio/industrialio-core.c
> @@ -227,33 +227,6 @@ static void iio_device_unregister_debugfs(struct iio_dev *indio_dev)
>  	debugfs_remove_recursive(indio_dev->debugfs_dentry);
>  }
>  
> -static ssize_t iio_read_channel_ext_info(struct device *dev,
> -				     struct device_attribute *attr,
> -				     char *buf)
> -{
> -	struct iio_dev *indio_dev = dev_get_drvdata(dev);
> -	struct iio_dev_attr *this_attr = to_iio_dev_attr(attr);
> -	const struct iio_chan_spec_ext_info *ext_info;
> -
> -	ext_info = &this_attr->c->ext_info[this_attr->address];
> -
> -	return ext_info->read(indio_dev, this_attr->c, buf);
> -}
> -
> -static ssize_t iio_write_channel_ext_info(struct device *dev,
> -				     struct device_attribute *attr,
> -				     const char *buf,
> -					 size_t len)
> -{
> -	struct iio_dev *indio_dev = dev_get_drvdata(dev);
> -	struct iio_dev_attr *this_attr = to_iio_dev_attr(attr);
> -	const struct iio_chan_spec_ext_info *ext_info;
> -
> -	ext_info = &this_attr->c->ext_info[this_attr->address];
> -
> -	return ext_info->write(indio_dev, this_attr->c, buf, len);
> -}
> -
>  static int iio_device_register_debugfs(struct iio_dev *indio_dev)
>  {
>  	struct dentry *d;
> @@ -297,6 +270,33 @@ static void iio_device_unregister_debugfs(struct iio_dev *indio_dev)
>  }
>  #endif /* CONFIG_DEBUG_FS */
>  
> +static ssize_t iio_read_channel_ext_info(struct device *dev,
> +				     struct device_attribute *attr,
> +				     char *buf)
> +{
> +	struct iio_dev *indio_dev = dev_get_drvdata(dev);
> +	struct iio_dev_attr *this_attr = to_iio_dev_attr(attr);
> +	const struct iio_chan_spec_ext_info *ext_info;
> +
> +	ext_info = &this_attr->c->ext_info[this_attr->address];
> +
> +	return ext_info->read(indio_dev, this_attr->c, buf);
> +}
> +
> +static ssize_t iio_write_channel_ext_info(struct device *dev,
> +				     struct device_attribute *attr,
> +				     const char *buf,
> +					 size_t len)
> +{
> +	struct iio_dev *indio_dev = dev_get_drvdata(dev);
> +	struct iio_dev_attr *this_attr = to_iio_dev_attr(attr);
> +	const struct iio_chan_spec_ext_info *ext_info;
> +
> +	ext_info = &this_attr->c->ext_info[this_attr->address];
> +
> +	return ext_info->write(indio_dev, this_attr->c, buf, len);
> +}
> +
>  static ssize_t iio_read_channel_info(struct device *dev,
>  				     struct device_attribute *attr,
>  				     char *buf)



-- 
~Randy
