Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755427Ab2EHN4n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 09:56:43 -0400
Received: from na3sys009aog107.obsmtp.com ([74.125.149.197]:53561 "EHLO
	na3sys009aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753815Ab2EHN4m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 09:56:42 -0400
From: Preston Fick <Preston.Fick@silabs.com>
To: =?utf-8?B?QmrDuHJuIE1vcms=?= <bjorn@mork.no>,
        Preston Fick <pffick@gmail.com>
CC: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>
Date: Tue, 8 May 2012 08:56:33 -0500
Subject: RE: [PATCH 1/3] usb: cp210x: Corrected USB request type definitions
Thread-Topic: [PATCH 1/3] usb: cp210x: Corrected USB request type definitions
Thread-Index: Ac0pCwAc4PCm1ZJBSEu8jONjJa+7EQEFxqDw
Message-ID: <00374F755A5C474884D69FBCA77349D105227D9ED9@EXCAUS002.silabs.com>
References: <1335845210-5147-1-git-send-email-preston.fick@silabs.com>
 <87ipgd3ako.fsf@nemi.mork.no>
In-Reply-To: <87ipgd3ako.fsf@nemi.mork.no>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q48DupUF026381

Hi Bjorn -

I agree - I was not the original author of this driver, but am helping to bring it up to date to fix some issues and add missing support from our product line. I just simply added this in to stick with the way that it had already been developed, however I can submit another patch to setup those defines using the standard USB definitions. Thanks for the suggestion.

Kind Regards -
Preston

-----Original Message-----
From: BjÃ¸rn Mork [mailto:bjorn@mork.no] 
Sent: Thursday, May 03, 2012 3:59 AM
To: Preston Fick
Cc: gregkh@linuxfoundation.org; linux-usb@vger.kernel.org; linux-kernel@vger.kernel.org; linux-serial@vger.kernel.org; Preston Fick
Subject: Re: [PATCH 1/3] usb: cp210x: Corrected USB request type definitions

Preston Fick <pffick@gmail.com> writes:

> diff --git a/drivers/usb/serial/cp210x.c b/drivers/usb/serial/cp210x.c
> index ec30f95..e67ccf3 100644
> --- a/drivers/usb/serial/cp210x.c
> +++ b/drivers/usb/serial/cp210x.c
> @@ -188,8 +188,10 @@ static struct usb_serial_driver * const serial_drivers[] = {
>  };
>  
>  /* Config request types */
> -#define REQTYPE_HOST_TO_DEVICE	0x41
> -#define REQTYPE_DEVICE_TO_HOST	0xc1
> +#define REQTYPE_HOST_TO_INTERFACE	0x41
> +#define REQTYPE_INTERFACE_TO_HOST	0xc1
> +#define REQTYPE_HOST_TO_DEVICE	0x40
> +#define REQTYPE_DEVICE_TO_HOST	0xc0


Any particular reason you need to define these instead of just using the
standard flags from linux/usb/ch9.h directly in the requests?:

(USB_TYPE_VENDOR | USB_RECIP_INTERFACE | USB_DIR_OUT)
(USB_TYPE_VENDOR | USB_RECIP_INTERFACE | USB_DIR_IN)
(USB_TYPE_VENDOR | USB_RECIP_DEVICE | USB_DIR_OUT)
(USB_TYPE_VENDOR | USB_RECIP_DEVICE | USB_DIR_IN)

If nothing else, using those from the beginning would have avoided the
mis-labelling you are fixing up.



BjÃ¸rn

This message (including any attachments) is intended only for the use of the individual or entity to which it is addressed and may contain information that is non-public, proprietary, privileged, confidential, and exempt from disclosure under applicable law or may constitute as attorney work product.  If you are not the intended recipient, you are hereby notified that any use, dissemination, distribution, or copying of this communication is strictly prohibited. If you have received this communication in error, notify us immediately by telephone and (i) destroy this message if a facsimile or (ii) delete this message immediately if this is an electronic communication.  

Thank you.

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
