Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755982Ab0HKHdP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 03:33:15 -0400
Received: from cantor.suse.de ([195.135.220.2]:55572 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753827Ab0HKHdO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 03:33:14 -0400
Date: Wed, 11 Aug 2010 09:33:13 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Xing Wei <weixing@hanwang.com.cn>
Cc: linux-input <linux-input@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] drivers/hid: the support for Hanwang tablet
In-Reply-To: <201008111148203123394@hanwang.com.cn>
Message-ID: <alpine.LNX.2.00.1008110931240.2702@pobox.suse.cz>
References: <201008111148203123394@hanwang.com.cn>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
