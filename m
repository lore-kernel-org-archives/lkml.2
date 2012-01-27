Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756164Ab2A0Q1x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 11:27:53 -0500
Received: from mga03.intel.com ([143.182.124.21]:15481 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751534Ab2A0Q1w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 11:27:52 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="100405225"
From: "R, Durgadoss" <durgadoss.r@intel.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>, "mjg@redhat.com" <mjg@redhat.com>,
        "platform-driver-x86@vger.kernel.org" 
	<platform-driver-x86@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 5/5] platform-x86: intel_mid_thermal: turn off
 thermistor voltage by default
Thread-Topic: [PATCH 5/5] platform-x86: intel_mid_thermal: turn off
 thermistor voltage by default
Thread-Index: AQHM3FDAKy9iAQdgfUm65HLCeevLwZYgaE2g
Date: Fri, 27 Jan 2012 16:27:47 +0000
Message-ID: <4D68720C2E767A4AA6A8796D42C8EB5902FDBA@BGSMSX101.gar.corp.intel.com>
References: <20120126173729.16719.15431.stgit@bob.linux.org.uk>
 <20120126173943.16719.16596.stgit@bob.linux.org.uk>
In-Reply-To: <20120126173943.16719.16596.stgit@bob.linux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.223.10.10]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q0RGS0OJ020468

> -----Original Message-----
> From: platform-driver-x86-owner@vger.kernel.org [mailto:platform-driver-x86-
> owner@vger.kernel.org] On Behalf Of Alan Cox
> Sent: Thursday, January 26, 2012 11:10 PM
> To: mjg@redhat.com; platform-driver-x86@vger.kernel.org; linux-
> kernel@vger.kernel.org
> Subject: [PATCH 5/5] platform-x86: intel_mid_thermal: turn off thermistor
> voltage by default
> 
> From: Mika Westerberg <mika.westerberg@linux.intel.com>
> 
> Instead of complaining that the voltage is on, we can just ask the MSIC to
> turn the voltage off. This should save some power.
> 
> Voltage for thermistors is turned on when ADC conversion is initiated.

Acked-by: Durgadoss R <durgadoss.r@intel.com>

Thanks,
Durga

> 
> Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> Signed-off-by: Alan Cox <alan@linux.intel.com>
> ---
> 
>  drivers/platform/x86/intel_mid_thermal.c |    6 ++++--
>  1 files changed, 4 insertions(+), 2 deletions(-)
> 
> 
> diff --git a/drivers/platform/x86/intel_mid_thermal.c
> b/drivers/platform/x86/intel_mid_thermal.c
> index aef4979..a4e56be 100644
> --- a/drivers/platform/x86/intel_mid_thermal.c
> +++ b/drivers/platform/x86/intel_mid_thermal.c
> @@ -360,8 +360,10 @@ static int mid_initialize_adc(struct device *dev)
>  	if (ret)
>  		return ret;
> 
> -	if (data & MSIC_ADCTHERM_MASK)
> -		dev_warn(dev, "ADCTHERM already set");
> +	data &= ~MSIC_ADCTHERM_MASK;
> +	ret = intel_msic_reg_write(INTEL_MSIC_ADC1CNTL3, data);
> +	if (ret)
> +		return ret;
> 
>  	/* Index of the first channel in which the stop bit is set */
>  	channel_index = find_free_channel();
> 
> --
> To unsubscribe from this list: send the line "unsubscribe platform-driver-x86"
> in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
