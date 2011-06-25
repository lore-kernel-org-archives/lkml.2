Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751713Ab1FYLIo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jun 2011 07:08:44 -0400
Received: from ppsw-41.csi.cam.ac.uk ([131.111.8.141]:49768 "EHLO
	ppsw-41.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751480Ab1FYLIm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jun 2011 07:08:42 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4E05C397.9090701@cam.ac.uk>
Date: Sat, 25 Jun 2011 12:16:39 +0100
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110509 Lightning/1.0b3pre Thunderbird/3.1.10
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, gregkh <greg@kroah.com>,
        linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        linux-iio@vger.kernel.org
Subject: Re: [PATCH] staging: fix more iio builds when IIO_RING_BUFFER is
 not enabled
References: <20110624155822.cb8cf6eb.sfr@canb.auug.org.au> <20110624092832.36ef2eae.randy.dunlap@oracle.com>
In-Reply-To: <20110624092832.36ef2eae.randy.dunlap@oracle.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/24/11 17:28, Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Fix lots more build errors in staging/iio when CONFIG_IIO_RING_BUFFER
> is not enabled by moving enums and defines outside of the
> CONFIG_IIO_RING_BUFFER ifdef block.
> 
> Examples (one from each driver; there were 116 total errors):
> 
> drivers/staging/iio/accel/adis16204_core.c:437: error: 'ADIS16204_SCAN_SUPPLY' undeclared here (not in a function)
> drivers/staging/iio/accel/adis16209_core.c:410: error: 'ADIS16209_SCAN_SUPPLY' undeclared here (not in a function)
> drivers/staging/iio/gyro/adis16260_core.c:420: error: 'ADIS16260_SCAN_GYRO' undeclared here (not in a function)
> drivers/staging/iio/imu/adis16400_core.c:565: error: 'ADIS16400_SCAN_SUPPLY' undeclared here (not in a function)
Thanks Randy! I should really have taken the time to test the rest of these after
your first patch.

There's one more hiding in there I think, the adis16240.
I'll fire off a patch for this one with you as reported-by.
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Acked-by: Jonathan Cameron <jic23@cam.ac.uk>
> Cc: Jonathan Cameron <jic23@cam.ac.uk>
> Cc: linux-iio@vger.kernel.org
> ---
>  drivers/staging/iio/accel/adis16204.h |    2 +-
>  drivers/staging/iio/accel/adis16209.h |    4 ++--
>  drivers/staging/iio/gyro/adis16260.h  |    2 +-
>  drivers/staging/iio/imu/adis16400.h   |    2 +-
>  4 files changed, 5 insertions(+), 5 deletions(-)
> 
> --- linux-next-20110624.orig/drivers/staging/iio/accel/adis16204.h
> +++ linux-next-20110624/drivers/staging/iio/accel/adis16204.h
> @@ -84,7 +84,6 @@ struct adis16204_state {
>  
>  int adis16204_set_irq(struct iio_dev *indio_dev, bool enable);
>  
> -#ifdef CONFIG_IIO_RING_BUFFER
>  enum adis16204_scan {
>  	ADIS16204_SCAN_SUPPLY,
>  	ADIS16204_SCAN_ACC_X,
> @@ -93,6 +92,7 @@ enum adis16204_scan {
>  	ADIS16204_SCAN_TEMP,
>  };
>  
> +#ifdef CONFIG_IIO_RING_BUFFER
>  void adis16204_remove_trigger(struct iio_dev *indio_dev);
>  int adis16204_probe_trigger(struct iio_dev *indio_dev);
>  
> --- linux-next-20110624.orig/drivers/staging/iio/accel/adis16209.h
> +++ linux-next-20110624/drivers/staging/iio/accel/adis16209.h
> @@ -121,8 +121,6 @@ struct adis16209_state {
>  
>  int adis16209_set_irq(struct iio_dev *indio_dev, bool enable);
>  
> -#ifdef CONFIG_IIO_RING_BUFFER
> -
>  #define ADIS16209_SCAN_SUPPLY	0
>  #define ADIS16209_SCAN_ACC_X	1
>  #define ADIS16209_SCAN_ACC_Y	2
> @@ -132,6 +130,8 @@ int adis16209_set_irq(struct iio_dev *in
>  #define ADIS16209_SCAN_INCLI_Y	6
>  #define ADIS16209_SCAN_ROT	7
>  
> +#ifdef CONFIG_IIO_RING_BUFFER
> +
>  void adis16209_remove_trigger(struct iio_dev *indio_dev);
>  int adis16209_probe_trigger(struct iio_dev *indio_dev);
>  
> --- linux-next-20110624.orig/drivers/staging/iio/gyro/adis16260.h
> +++ linux-next-20110624/drivers/staging/iio/gyro/adis16260.h
> @@ -104,7 +104,6 @@ struct adis16260_state {
>  
>  int adis16260_set_irq(struct iio_dev *indio_dev, bool enable);
>  
> -#ifdef CONFIG_IIO_RING_BUFFER
>  /* At the moment triggers are only used for ring buffer
>   * filling. This may change!
>   */
> @@ -115,6 +114,7 @@ int adis16260_set_irq(struct iio_dev *in
>  #define ADIS16260_SCAN_TEMP	3
>  #define ADIS16260_SCAN_ANGL	4
>  
> +#ifdef CONFIG_IIO_RING_BUFFER
>  void adis16260_remove_trigger(struct iio_dev *indio_dev);
>  int adis16260_probe_trigger(struct iio_dev *indio_dev);
>  
> --- linux-next-20110624.orig/drivers/staging/iio/imu/adis16400.h
> +++ linux-next-20110624/drivers/staging/iio/imu/adis16400.h
> @@ -158,7 +158,6 @@ struct adis16400_state {
>  
>  int adis16400_set_irq(struct iio_dev *indio_dev, bool enable);
>  
> -#ifdef CONFIG_IIO_RING_BUFFER
>  /* At the moment triggers are only used for ring buffer
>   * filling. This may change!
>   */
> @@ -182,6 +181,7 @@ int adis16400_set_irq(struct iio_dev *in
>  #define ADIS16300_SCAN_INCLI_X	12
>  #define ADIS16300_SCAN_INCLI_Y	13
>  
> +#ifdef CONFIG_IIO_RING_BUFFER
>  void adis16400_remove_trigger(struct iio_dev *indio_dev);
>  int adis16400_probe_trigger(struct iio_dev *indio_dev);
>  

