Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161521Ab1FAM2q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 08:28:46 -0400
Received: from smtp.microsoft.com ([131.107.115.214]:45051 "EHLO
	smtp.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161198Ab1FAM2n convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 08:28:43 -0400
From: KY Srinivasan <kys@microsoft.com>
To: Andre Bartke <andre.bartke@googlemail.com>,
        "gregkh@suse.de" <gregkh@suse.de>
CC: "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        Andre Bartke <andre.bartke@gmail.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] staging/hv: Fix memory leak of storvsc_dev_add()
Thread-Topic: [PATCH] staging/hv: Fix memory leak of storvsc_dev_add()
Thread-Index: AQHMH9xSg+d0MDS0BU6LVitfjOnOf5SniZ5w
Date: Wed, 1 Jun 2011 12:28:40 +0000
Message-ID: <6E21E5352C11B742B20C142EB499E0480813C89C@TK5EX14MBXC122.redmond.corp.microsoft.com>
References: <1306878352-14450-1-git-send-email-andre.bartke@gmail.com>
In-Reply-To: <1306878352-14450-1-git-send-email-andre.bartke@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.54.51.37]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: devel-bounces@linuxdriverproject.org [mailto:devel-
> bounces@linuxdriverproject.org] On Behalf Of Andre Bartke
> Sent: Tuesday, May 31, 2011 5:46 PM
> To: gregkh@suse.de
> Cc: devel@driverdev.osuosl.org; Andre Bartke; Haiyang Zhang; linux-
> kernel@vger.kernel.org
> Subject: [PATCH] staging/hv: Fix memory leak of storvsc_dev_add()
> 
> stor_device is not freed in storvsc_dev_add()
> causing a memory leak in case of an allocation error.
> 
> Signed-off-by: Andre Bartke <andre.bartke@gmail.com>
> ---
>  drivers/staging/hv/storvsc.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/staging/hv/storvsc.c b/drivers/staging/hv/storvsc.c
> index 06cd327..92b44f4 100644
> --- a/drivers/staging/hv/storvsc.c
> +++ b/drivers/staging/hv/storvsc.c
> @@ -414,6 +414,7 @@ int storvsc_dev_add(struct hv_device *device,
>  	device_info->target_id = stor_device->target_id;
> 
>  cleanup:
> +	free_stor_device(stor_device);
>  	return ret;

Was this patch tested? Even the normal path falls through the cleanup label
and obviously you should not be freeing the stor_device in that case. I have 
patches queued up to cleanup some of the unnecessary labels and meaningless
return values that I will be sending soon.

Regards,

K. Y
 


