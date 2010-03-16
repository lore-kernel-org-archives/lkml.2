Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937753Ab0CPK6a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 06:58:30 -0400
Received: from ppsw-6.csi.cam.ac.uk ([131.111.8.136]:39103 "EHLO
	ppsw-6.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S937732Ab0CPK63 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 06:58:29 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4B9F64DC.3080602@cam.ac.uk>
Date: Tue, 16 Mar 2010 11:00:44 +0000
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20100109 Thunderbird/3.0
MIME-Version: 1.0
To: Dan Carpenter <error27@gmail.com>, Greg Kroah-Hartman <gregkh@suse.de>,
       devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [patch] iio: test for failed allocation
References: <20100316100349.GA4219@bicker>
In-Reply-To: <20100316100349.GA4219@bicker>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/16/10 10:03, Dan Carpenter wrote:
> We should return test to see if iio_allocate_trigger() fails and return -ENOMEM.
> 
> Signed-off-by: Dan Carpenter <error27@gmail.com>
Indeed.  Another one for the stupid errors pile!

Thanks.

Acked-by: Jonathan Cameron <jic23@cam.ac.uk>
> 
> diff --git a/drivers/staging/iio/accel/lis3l02dq_ring.c b/drivers/staging/iio/accel/lis3l02dq_ring.c
> index a6b7c72..db3270f 100644
> --- a/drivers/staging/iio/accel/lis3l02dq_ring.c
> +++ b/drivers/staging/iio/accel/lis3l02dq_ring.c
> @@ -492,6 +492,9 @@ int lis3l02dq_probe_trigger(struct iio_dev *indio_dev)
>  	struct lis3l02dq_state *state = indio_dev->dev_data;
>  
>  	state->trig = iio_allocate_trigger();
> +	if (!state->trig)
> +		return -ENOMEM;
> +
>  	state->trig->name = kmalloc(IIO_TRIGGER_NAME_LENGTH, GFP_KERNEL);
>  	if (!state->trig->name) {
>  		ret = -ENOMEM;
> 

