Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754648Ab1FVJBm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 05:01:42 -0400
Received: from ppsw-41.csi.cam.ac.uk ([131.111.8.141]:50696 "EHLO
	ppsw-41.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752023Ab1FVJBl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 05:01:41 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4E01B154.6090704@cam.ac.uk>
Date: Wed, 22 Jun 2011 10:09:40 +0100
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110509 Lightning/1.0b3pre Thunderbird/3.1.10
MIME-Version: 1.0
To: Bryan Freed <bfreed@chromium.org>
CC: linux-kernel@vger.kernel.org, jbrenner@taosinc.com, gregkh@suse.de,
        arnd@arndb.de, "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>
Subject: Re: [PATCH 3/3] light sensor: Fix a panic in the tsl2563 driver.
References: <1308696897-25161-1-git-send-email-bfreed@chromium.org> <1308696897-25161-3-git-send-email-bfreed@chromium.org>
In-Reply-To: <1308696897-25161-3-git-send-email-bfreed@chromium.org>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/21/11 23:54, Bryan Freed wrote:
> Add the required read/write_raw functions to the tsl2563_info_no_irq data
> structure.  This structure is used insted of tsl2563_info when the I2C client
> has no IRQ.
> The absence of these functions causes a panic when reading or writing the
> created sysfs files.
Yikes.  Good spot.  I'd completely forgotten that no_irq version was there.

Greg, please pick these two up as fixes.  Sorry for the rubbish
conversion in the first place!
> 
> Signed-off-by: Bryan Freed <bfreed@chromium.org>
Acked-by: Jonathan Cameron <jic23@cam.ac.uk>
> ---
>  drivers/staging/iio/light/tsl2563.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/staging/iio/light/tsl2563.c b/drivers/staging/iio/light/tsl2563.c
> index d9be19c..bca99f1 100644
> --- a/drivers/staging/iio/light/tsl2563.c
> +++ b/drivers/staging/iio/light/tsl2563.c
> @@ -713,6 +713,8 @@ static struct i2c_driver tsl2563_i2c_driver;
>  
>  static const struct iio_info tsl2563_info_no_irq = {
>  	.driver_module = THIS_MODULE,
> +	.read_raw = &tsl2563_read_raw,
> +	.write_raw = &tsl2563_write_raw,
>  };
>  
>  static const struct iio_info tsl2563_info = {

