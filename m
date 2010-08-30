Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754915Ab0H3Jiq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 05:38:46 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38592 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751747Ab0H3Jio (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 05:38:44 -0400
Date: Mon, 30 Aug 2010 11:38:43 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Xing Wei <weixing@hanwang.com.cn>
Cc: linux-input <linux-input@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "dmitry.torokhov" <dmitry.torokhov@gmail.com>
Subject: Re: [PATCH v1] input: Add support for Hanwang tablet
In-Reply-To: <201008301714040000489@hanwang.com.cn>
Message-ID: <alpine.LNX.2.00.1008301135150.1019@pobox.suse.cz>
References: <201008301714040000489@hanwang.com.cn>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Aug 2010, Xing Wei wrote:

> From: Xing Wei  <weixing@hanwang.com.cn>
> 
> Add support for Art Master III tablet of BeiJing HanwangTechnology Co, Ltd.
> 
> Signed-off-by: Xing Wei <weixing@hanwang.com.cn>
> 
> ---
> 
> This patch got several warnings(line over 80 characters).
> This is our first time to submit the patch for linux and I really appreciate the comment and advice.
> 
> diff -uprN -X linux-2.6.35.3-vanilla/Documentation/dontdiff linux-2.6.35.3-vanilla/drivers/hid/hid-core.c devel/linux-2.6.35.3/drivers/hid/hid-core.c
> --- linux-2.6.35.3-vanilla/drivers/hid/hid-core.c	2010-08-21 02:55:55.000000000 +0800
> +++ devel/linux-2.6.35.3/drivers/hid/hid-core.c	2010-08-25 18:02:15.942574998 +0800
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
> diff -uprN -X linux-2.6.35.3-vanilla/Documentation/dontdiff linux-2.6.35.3-vanilla/drivers/hid/hid-ids.h devel/linux-2.6.35.3/drivers/hid/hid-ids.h
> --- linux-2.6.35.3-vanilla/drivers/hid/hid-ids.h	2010-08-21 02:55:55.000000000 +0800
> +++ devel/linux-2.6.35.3/drivers/hid/hid-ids.h	2010-08-25 18:00:21.416574999 +0800
> @@ -526,5 +526,8 @@
>  #define USB_DEVICE_ID_KYE_ERGO_525V	0x0087
>  #define USB_DEVICE_ID_KYE_GPEN_560	0x5003
>  
> +#define USB_VENDOR_ID_HANWANG		0x0b57
> +#define USB_DEVICE_ID_HANWANG_TABLET_FIRST	0x5000
> +#define USB_DEVICE_ID_HANWANG_TABLET_LAST	0x8fff

Dmitry, once you are merging the driver, consider these hunks Acked by me. 
Thanks.

>  
>  #endif
> diff -uprN -X linux-2.6.35.3-vanilla/Documentation/dontdiff linux-2.6.35.3-vanilla/drivers/input/tablet/hanwang.c devel/linux-2.6.35.3/drivers/input/tablet/hanwang.c
> --- linux-2.6.35.3-vanilla/drivers/input/tablet/hanwang.c	1970-01-01 08:00:00.000000000 +0800
> +++ devel/linux-2.6.35.3/drivers/input/tablet/hanwang.c	2010-08-30 16:07:11.332569002 +0800
> @@ -0,0 +1,351 @@
> +/*
> + *  USB Hanwang tablet support
> + *
> + *  Version Infomation & Changelog
> + *  v0.1 - Hanwang Art Master III support(0604,0906,1308)
> + *                      Xing Wei <weixing@hanwang.com.cn>

I think we don't need this 'v0.1' stuff. It usually gets obsoleted very 
quickly (everyone forgets to update the comments in a consistent way), and 
git is much better tracking revisions and changes.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
