Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755197Ab2CZIka (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 04:40:30 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:49269 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753937Ab2CZIk3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 04:40:29 -0400
MIME-Version: 1.0
From: Guan Xin <guanx.bac@gmail.com>
Date: Mon, 26 Mar 2012 10:39:48 +0200
Message-ID: <CANeMGR5xS6GwG18q5QnKt5_pWJB4fEKFoywZDx=kA_JFVREGxw@mail.gmail.com>
Subject: Re: Remove over-broad module alias from zaurus.
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Fri, 17 Jun 2011 20:02:10 -0400, Dave Jones wrote:
> This module and a bunch of dependancies are getting loaded on several
> of laptops I have (probably picking up the mobile broadband device),
> that have nothing to do with zaurus. Matching by class without
> any vendor/device pair isn't the right thing to do here, as it
> will prevent any other driver from correctly binding to it.
> (Or in the absense of a driver, will just waste time & memory by
>  unnecessarily loading modules)
>
> Signed-off-by: Dave Jones <davej@redhat.com>
>
> diff --git a/drivers/net/usb/zaurus.c b/drivers/net/usb/zaurus.c
> index 241756e..1a2234c 100644
> --- a/drivers/net/usb/zaurus.c
> +++ b/drivers/net/usb/zaurus.c
> @@ -331,17 +331,7 @@ static const struct usb_device_id	products [] = {
>  	ZAURUS_MASTER_INTERFACE,
>  	.driver_info = ZAURUS_PXA_INFO,
>  },
> -
> -
> -/* At least some of the newest PXA units have very different lies about
> - * their standards support:  they claim to be cell phones offering
> - * direct access to their radios!  (No, they don't conform to CDC MDLM.)
> - */
>  {
> -	USB_INTERFACE_INFO(USB_CLASS_COMM, USB_CDC_SUBCLASS_MDLM,
> -			USB_CDC_PROTO_NONE),
> -	.driver_info = (unsigned long) &bogus_mdlm_info,
> -}, {
>  	/* Motorola MOTOMAGX phones */
>  	USB_DEVICE_AND_INTERFACE_INFO(0x22b8, 0x6425, USB_CLASS_COMM,
>  			USB_CDC_SUBCLASS_MDLM, USB_CDC_PROTO_NONE),

After removal of this, my Motorola Rokr E6 (22b8:6027) cannot be recognized.
Can this be added back with more specific device info, just like the
Motorola MOTOMAGX phones?

Regards,
Guan
