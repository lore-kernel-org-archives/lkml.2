Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753236Ab1AASBS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Jan 2011 13:01:18 -0500
Received: from ppsw-51.csi.cam.ac.uk ([131.111.8.151]:48587 "EHLO
	ppsw-51.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752493Ab1AASBR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Jan 2011 13:01:17 -0500
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4D1F6C0F.8060906@cam.ac.uk>
Date: Sat, 01 Jan 2011 18:01:51 +0000
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101231 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: roel kluin <roel.kluin@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>
Subject: Re: [PATCH] iio: --/++ confusion in build_channel_array() error cleanup
References: <4D1F53E0.9050802@gmail.com>
In-Reply-To: <4D1F53E0.9050802@gmail.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/01/11 16:18, roel kluin wrote:
> Fix loop: it should decrement
> 
Good spot.

cc'd Greg KH for merging into staging.
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Acked-by: Jonathan Cameron <jic23@cam.ac.uk>
> ---
>  drivers/staging/iio/Documentation/iio_utils.h |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/staging/iio/Documentation/iio_utils.h b/drivers/staging/iio/Documentation/iio_utils.h
> index 0372424..4dc961c 100644
> --- a/drivers/staging/iio/Documentation/iio_utils.h
> +++ b/drivers/staging/iio/Documentation/iio_utils.h
> @@ -398,7 +398,7 @@ inline int build_channel_array(const char *device_dir,
>  	return 0;
>  
>  error_cleanup_array:
> -	for (i = count - 1;  i >= 0; i++)
> +	for (i = count - 1;  i >= 0; i--)
>  		free((*ci_array)[i].name);
>  	free(*ci_array);
>  error_close_dir:
> 

