Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757691Ab1JRMyh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 08:54:37 -0400
Received: from ppsw-52.csi.cam.ac.uk ([131.111.8.152]:42871 "EHLO
	ppsw-52.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751240Ab1JRMyg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 08:54:36 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4E9D770F.90700@cam.ac.uk>
Date: Tue, 18 Oct 2011 13:54:39 +0100
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20111003 Thunderbird/7.0.1
MIME-Version: 1.0
To: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
CC: dmitry.torokhov@gmail.com, sameo@linux.intel.com, peter.ujfalusi@ti.com,
        aghayal@codeaurora.org, david@hardeman.nu, Shubhrajyoti@ti.com,
        saaguirre@ti.com, hemanthv@ti.com, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2 2/7] input/cma3000_d0x: Check silicon version
References: <1318939596-27330-1-git-send-email-ricardo.ribalda@gmail.com> <1318939596-27330-3-git-send-email-ricardo.ribalda@gmail.com>
In-Reply-To: <1318939596-27330-3-git-send-email-ricardo.ribalda@gmail.com>
X-Enigmail-Version: 1.4a1pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/18/11 13:06, Ricardo Ribalda Delgado wrote:
> Improve probing of the cma3000 chip, by checking the revision of the
> device.
> 
> ---
> 
> v2: Fixes suggested by Jonathan Cameron
> 	-Remove WhoamI pr_info
> 
> Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Acked-by: Jonathan Cameron <jic23@cam.ac.uk>
> ---
>  drivers/input/misc/cma3000_d0x.c |    8 +++++++-
>  1 files changed, 7 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/input/misc/cma3000_d0x.c b/drivers/input/misc/cma3000_d0x.c
> index f2e87e3..3877cbe 100644
> --- a/drivers/input/misc/cma3000_d0x.c
> +++ b/drivers/input/misc/cma3000_d0x.c
> @@ -26,6 +26,8 @@
>  
>  #include "cma3000_d0x.h"
>  
> +#define CMA3000_REV         0x10
> +
>  #define CMA3000_WHOAMI      0x00
>  #define CMA3000_REVID       0x01
>  #define CMA3000_CTRL        0x02
> @@ -366,7 +368,11 @@ struct cma3000_accl_data *cma3000_init(struct device *dev, int irq,
>  		error = rev;
>  		goto err_free_mem;
>  	}
> -
> +	if (rev != CMA3000_REV) {
> +		error = -EINVAL;
> +		pr_err("CMA3000 Accelerometer: Unknown Revision %x\n", rev);
> +		goto err_free_mem;
> +	}
>  	pr_info("CMA3000 Accelerometer: Revision %x\n", rev);
>  
>  	error = request_threaded_irq(irq, NULL, cma3000_thread_irq,

