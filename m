Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756064Ab2ECI7M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 04:59:12 -0400
Received: from canardo.mork.no ([148.122.252.1]:39586 "EHLO canardo.mork.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752313Ab2ECI7K convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 04:59:10 -0400
From: =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To: Preston Fick <pffick@gmail.com>
Cc: gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        preston.fick@silabs.com
Subject: Re: [PATCH 1/3] usb: cp210x: Corrected USB request type definitions
Organization: m
References: <1335845210-5147-1-git-send-email-preston.fick@silabs.com>
Date: Thu, 03 May 2012 10:58:31 +0200
In-Reply-To: <1335845210-5147-1-git-send-email-preston.fick@silabs.com>
	(Preston Fick's message of "Mon, 30 Apr 2012 23:06:48 -0500")
Message-ID: <87ipgd3ako.fsf@nemi.mork.no>
User-Agent: Gnus/5.11002 (No Gnus v0.20) Emacs/23.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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



Bjørn
