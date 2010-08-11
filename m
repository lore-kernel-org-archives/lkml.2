Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758141Ab0HKJ2U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 05:28:20 -0400
Received: from hanwang.com.cn ([221.122.51.51]:40150 "EHLO mail.hanwang.com.cn"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758109Ab0HKJ2R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 05:28:17 -0400
Date: Wed, 11 Aug 2010 17:27:33 +0800
From: "Xing Wei" <weixing@hanwang.com.cn>
To: "Jiri Kosina" <jkosina@suse.cz>
Cc: "linux-input" <linux-input@vger.kernel.org>,
        "linux-kernel" <linux-kernel@vger.kernel.org>
References: <201008111148203123394@hanwang.com.cn>,
 <alpine.LNX.2.00.1008110931240.2702@pobox.suse.cz>
Subject: Re: Re: [PATCH] drivers/hid: the support for Hanwang tablet
Message-ID: <201008111727331714570@hanwang.com.cn>
X-mailer: Foxmail 6, 15, 201, 23 [cn]
Mime-Version: 1.0
Content-Type: text/plain;
	charset="gb2312"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id o7B9SgYm000946

ok,i'll fix it and submit it with driver later.
The driver is just using usb bus.

-------------------------------------------------------------
·¢¼şÈË£ºJiri Kosina
·¢ËÍÈÕÆÚ£º2010-08-11 15:34:49
ÊÕ¼şÈË£ºXing Wei
³­ËÍ£ºlinux-input; linux-kernel
Ö÷Ìâ£ºRe: [PATCH] drivers/hid: the support for Hanwang tablet

On Wed, 11 Aug 2010, Xing Wei wrote:

> From: Xing Wei  <weixing@hanwang.com.cn>
> 
> This patch is the support for tablet of BeiJing HanwangTechnology Co, Ltd.
> The main purpose is to make the device taken over by our driver.
> The driver code will be submitted later.
> 
> Signed-off-by: Xing Wei <weixing@hanwang.com.cn>
> 
> ---
> This is our first time to submit the patch for linux.We'll really appreciate the comment and advice.
> 
> diff -uprN -X linux-2.6.35-vanilla/Documentation/dontdiff linux-2.6.35-vanilla/drivers/hid/hid-core.c devel/linux-2.6.35/drivers/hid/hid-core.c
> --- linux-2.6.35-vanilla/drivers/hid/hid-core.c	2010-08-02 06:11:14.000000000 +0800
> +++ devel/linux-2.6.35/drivers/hid/hid-core.c	2010-08-11 18:20:13.832088816 +0800
> @@ -1759,6 +1759,11 @@ static bool hid_ignore(struct hid_device
>  		    hdev->product <= USB_DEVICE_ID_SOUNDGRAPH_IMON_LAST)
>  			return true;
>  		break;
> +	case USB_VENDOR_ID_HANWANG:
> +		if (hdev->product >= USB_DEVICE_ID_HANWANG_TABLET_FIRST &&
> +		    hdev->product <= USB_DEVICE_ID_HANWANG_TABLET_LAST)
> +			return true;
> +		break;
>  	}
>  
>  	if (hdev->type == HID_TYPE_USBMOUSE &&
> diff -uprN -X linux-2.6.35-vanilla/Documentation/dontdiff linux-2.6.35-vanilla/drivers/hid/hid-ids.h devel/linux-2.6.35/drivers/hid/hid-ids.h
> --- linux-2.6.35-vanilla/drivers/hid/hid-ids.h	2010-08-02 06:11:14.000000000 +0800
> +++ devel/linux-2.6.35/drivers/hid/hid-ids.h	2010-08-11 18:17:32.967089161 +0800
> @@ -526,5 +526,8 @@
>  #define USB_DEVICE_ID_KYE_ERGO_525V	0x0087
>  #define USB_DEVICE_ID_KYE_GPEN_560	0x5003
>  
> +#define USB_VENDOR_ID_HANWANG		0x0b57
> +#define USB_DEVICE_ID_HANWANG_TABLET_LAST	0x8fff
> +#define USB_DEVICE_ID_HANWANG_TABLET_FIRST	0x5000

The patch is fine (I'd only suggest swapping 'LAST' and 'FIRST' lines here 
to keep proper ordering), but I will be applying it only together with the 
driver once you submit it, as it doesn't make sense stand-alone.

The driver is not HID-based (i.e. not using hid bus), but completely 
standalone, right?

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
--
To unsubscribe from this list: send the line "unsubscribe linux-input" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
