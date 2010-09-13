Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752757Ab0IMWCS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 18:02:18 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:54071 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751805Ab0IMWCR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 18:02:17 -0400
From: "Savoy, Pavan" <pavan_savoy@ti.com>
To: "gregkh@suse.de" <gregkh@suse.de>,
        "alan@lxorguk.ukuu.org.uk" <alan@lxorguk.ukuu.org.uk>
CC: "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Tue, 14 Sep 2010 03:31:55 +0530
Subject: RE: [PATCH] drivers:staging:ti-st: fix kim platform device id
Thread-Topic: [PATCH] drivers:staging:ti-st: fix kim platform device id
Thread-Index: ActRGKcQ5fnZWvv1Rd291nEHmNzlaACdoUJg
Message-ID: <19F8576C6E063C45BE387C64729E739404689135FB@dbde02.ent.ti.com>
References: <1284148738-21643-1-git-send-email-pavan_savoy@ti.com>
 <1284148738-21643-2-git-send-email-pavan_savoy@ti.com>
In-Reply-To: <1284148738-21643-2-git-send-email-pavan_savoy@ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg,

 
----------------
Thanks & Regards,
Pavan Savoy | x0099669
 
> -----Original Message-----
> From: Savoy, Pavan
> Sent: Friday, September 10, 2010 2:59 PM
> To: gregkh@suse.de; alan@lxorguk.ukuu.org.uk
> Cc: devel@driverdev.osuosl.org; linux-kernel@vger.kernel.org; Savoy, Pavan
> Subject: [PATCH] drivers:staging:ti-st: fix kim platform device id
> 
> From: Pavan Savoy <pavan_savoy@ti.com>
> 
> Platform devices tend to have id as -1 when only 1 device exist and
> a value >=0 when multiple devices exist, since we plan to store all
> these platform devices if multiple exist, there was a requirement to
> have id to be >=0.
> The patch fixes this problem.

Please merge this patch, and I hope you find some time to review the rest of them.


> Signed-off-by: Pavan Savoy <pavan_savoy@ti.com>
> ---
>  drivers/staging/ti-st/st_kim.c |    9 ++++++++-
>  1 files changed, 8 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/staging/ti-st/st_kim.c b/drivers/staging/ti-st/st_kim.c
> index 9e99463..be18c7a 100644
> --- a/drivers/staging/ti-st/st_kim.c
> +++ b/drivers/staging/ti-st/st_kim.c
> @@ -638,7 +638,14 @@ static int kim_probe(struct platform_device *pdev)
>  	long *gpios = pdev->dev.platform_data;
>  	struct kim_data_s	*kim_gdata;
> 
> -	st_kim_devices[pdev->id] = pdev;
> +	if ((pdev->id != -1) && (pdev->id < MAX_ST_DEVICES)) {
> +		/* multiple devices could exist */
> +		st_kim_devices[pdev->id] = pdev;
> +	} else {
> +		/* platform's sure about existance of 1 device */
> +		st_kim_devices[0] = pdev;
> +	}
> +
>  	kim_gdata = kzalloc(sizeof(struct kim_data_s), GFP_ATOMIC);
>  	if (!kim_gdata) {
>  		pr_err("no mem to allocate");
> --
> 1.6.5

