Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754324Ab2GQDzs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 23:55:48 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:54682 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754185Ab2GQDzl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 23:55:41 -0400
From: "Fangxiaozhi (Franko)" <fangxiaozhi@huawei.com>
To: =?utf-8?B?QmrDuHJuIE1vcms=?= <bjorn@mork.no>
CC: "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Xueguiying (Zihan)" <zihan.xue@huawei.com>,
        "greg@kroah.com" <greg@kroah.com>,
        "smurf@smurf.noris.de" <smurf@smurf.noris.de>,
        "Linlei (Lei Lin)" <lei.lin@huawei.com>,
        "Liuqifeng (Qifeng)" <qifeng.liuqifeng@huawei.com>,
        Wangyeqi <wangyeqi@huawei.com>,
        Wangchangliang <wangchangliang@huawei.com>,
        Zhuxinbo <zhuxinbo@huawei.com>, Gustavo Padovan <gustavo@padovan.org>
Subject: =?utf-8?B?562U5aSNOiBbUEFUQ0ggNy8xM10gVVNCOnN1cHBvcnQgdGhlIG5ldyBpbnRl?=
 =?utf-8?B?cmZhY2VzIG9mIEh1YXdlaSBEYXRhIENhcmQgZGV2aWNlcyBpbiBvcHRpb24g?=
 =?utf-8?Q?driver?=
Thread-Topic: [PATCH 7/13] USB:support the new interfaces of Huawei Data
 Card devices in option driver
Thread-Index: Ac1gzTK4DnZ8Xb5EQmOskzHlz+Hq8wAIbmcrALeVR8A=
Date: Tue, 17 Jul 2012 03:53:19 +0000
Message-ID: <910F9D9E13B84F4C8FA771DC9BDE99F326D4B940@szxeml546-mbs.china.huawei.com>
References: <910F9D9E13B84F4C8FA771DC9BDE99F326D427A5@szxeml546-mbs.china.huawei.com>
 <874npbg9gf.fsf@nemi.mork.no>
In-Reply-To: <874npbg9gf.fsf@nemi.mork.no>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.11.37.117]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q6H3tvMK031537

Dear bjorn:

"Fangxiaozhi (Franko)" <fangxiaozhi@huawei.com> writes:

> From: fangxiaozhi <huananhu@huawei.com>
> 1. This patch is based on the kernel of 3.5-rc6 
> 2. In this patch, we add new micro for matching the series USB devices with vendor ID and interface information.
> 3. In this patch, we add new declarations into option.c to support the new interfaces of Huawei Data Card devices.
> Signed-off-by: fangxiaozhi <huananhu@huawei.com>
> -----------------------
> --- ../test/linux-3.5-rc6/include/linux/usb.h	2012-07-08 08:23:56.000000000 +0800
> +++ include/linux/usb.h	2012-07-13 17:45:59.000000000 +0800
> @@ -828,6 +828,27 @@ static inline int usb_make_path(struct u
>  	.bInterfaceClass = (cl), \
>  	.bInterfaceSubClass = (sc), \
>  	.bInterfaceProtocol = (pr)
> +/**
> + *  * USB_VENDOR_AND_INTERFACE_INFO - describe a specific usb device with a class of usb interfaces, but independent of product ID


This chunk seems like a copy of the patch Gustavo Padovan just
submitted?  Should really be listed as a precondition instead of
included here, should it not?
-----In your opinions, it is better to declare this defining in the option.c file, but not usb.h file, right?


> --- ../test/linux-3.5-rc6/drivers/usb/serial/option.c	2012-07-13 14:22:52.000000000 +0800
> +++ drivers/usb/serial/option.c	2012-07-13 17:38:38.000000000 +0800
> @@ -572,6 +572,115 @@ static const struct option_blacklist_inf
>  };
>  
>  static const struct usb_device_id option_ids[] = {
> +	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x01, 0x01) },
> +	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x01, 0x02) },
> +	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x01, 0x03) },

I guess this means that the device specific entries matching this could
and should be removed, does it not?  All these seem redundant with your
patch: 
------The new matching rule is independent of the special product ID, so it can support a series products of Huawei Data Card.
-----The following matching rule is only for the specific product, and it is covered by the new matching rule, so I think that we can remove the following matching sentences.

        { USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_K4605, 0xff, 0x01, 0x31) },
        { USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_K4605, 0xff, 0x01, 0x32) },
        { USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_K5005, 0xff, 0x01, 0x31) },
        { USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_K5005, 0xff, 0x01, 0x32) },
        { USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_K5005, 0xff, 0x01, 0x33) },
        { USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_K3770, 0xff, 0x02, 0x31) },
        { USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_K3770, 0xff, 0x02, 0x32) },
        { USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_K3771, 0xff, 0x02, 0x31) },
        { USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_K3771, 0xff, 0x02, 0x32) },
        { USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_K4510, 0xff, 0x01, 0x31) },
        { USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_K4510, 0xff, 0x01, 0x32) },
        { USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_K4511, 0xff, 0x01, 0x31) },
        { USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_K4511, 0xff, 0x01, 0x32) },
        { USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_E353, 0xff, 0x01, 0x01) },
        { USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_E353, 0xff, 0x01, 0x02) },
        { USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_E353, 0xff, 0x01, 0x03) },
        { USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_E353, 0xff, 0x01, 0x10) },
        { USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_E353, 0xff, 0x01, 0x12) },
        { USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_E353, 0xff, 0x01, 0x13) },
        { USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_E353, 0xff, 0x02, 0x01) },  /* E398 3G Modem */
        { USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_E353, 0xff, 0x02, 0x02) },  /* E398 3G PC UI Interface */
        { USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_E353, 0xff, 0x02, 0x03) },  /* E398 3G Application Interface */



> +	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x01, 0x04) },
> +	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x01, 0x05) },
> +	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x01, 0x06) },
> +	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x01, 0x0A) },
> +	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x01, 0x0B) },
> +	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x01, 0x0D) },
> +	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x01, 0x0E) },
> +	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x01, 0x0F) },
> +	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x01, 0x10) },
> +	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x01, 0x12) },

I see that the holes I know of are there, like protocol 0x08, 0x09 and
0x11.  You wouldn't happen to have a complete list of those as well? I
am interested in the ones which can be expected to work with the
qmi_wwan driver.  Currently we match 

 0xff, 0x01, 0x09 (along with a 0xff, 0x01, 0x08 data interface)
 0xff, 0x01, 0x11
 0xff, 0x01, 0x39 (along with a 0xff, 0x01, 0x38 data interface)

but I suspect there are more variants which could be handled by that
driver.
------Sorry, protocol 0x08, 0x09 and 0x11 is defined as the ECM port, they are supported by other kernel driver, but not option.c driver.
------So, we don't declare them in option.c.


[..]
> +	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x02, 0x79) },
> +	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x02, 0x7A) },
> +	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x02, 0x7B) },
> +	{ USB_VENDOR_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0xff, 0x02, 0x7C) },
> +
>  	{ USB_DEVICE(OPTION_VENDOR_ID, OPTION_PRODUCT_COLT) },
>  	{ USB_DEVICE(OPTION_VENDOR_ID, OPTION_PRODUCT_RICOLA) },
>  	{ USB_DEVICE(OPTION_VENDOR_ID, OPTION_PRODUCT_RICOLA_LIGHT) },

And should the new entries be sorted with the other Huawei entries?
Putting them in front of the Option entries looks a bit strange
-------OK, we will improve this, and then update the patch.


Best Regards,

Franko Fang
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
