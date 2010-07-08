Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758474Ab0GHTNr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 15:13:47 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:55379 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756922Ab0GHTNp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 15:13:45 -0400
Message-ID: <4C362329.7070900@ru.mvista.com>
Date: Thu, 08 Jul 2010 23:12:41 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Patrick Pannuto <ppannuto@codeaurora.org>
CC: dbrownell@users.sourceforge.net, gregkh@suse.de, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org, sboyd@codeaurora.org
Subject: Re: [PATCH] usb: gadget: #include device.h in gadget.h
References: <4C35200C.2040209@codeaurora.org>
In-Reply-To: <4C35200C.2040209@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Patrick Pannuto wrote:

> gadget.h uses structures defined in device.h, it must include it. In
> most cases, gadget.h is preceded by linux/platform_device.h, but if
> you are grouping headers sanely, device.h may not be pulled in until
> *after* gadget (e.g. mach/msm_device.h), thus gadget.h should not
> rely on something else #including device.h

    Sigh, I've already submitted a more complete patch, adding 6 #include's 
but it seems that prevailing opinion in this list is to leave things as they 
are in the header, and deal with the fallout wherever it's used.

[...]

> diff --git a/include/linux/usb/gadget.h b/include/linux/usb/gadget.h
> index bbf45d5..ddca035 100644
> --- a/include/linux/usb/gadget.h
> +++ b/include/linux/usb/gadget.h
> @@ -15,6 +15,8 @@
>  #ifndef __LINUX_USB_GADGET_H
>  #define __LINUX_USB_GADGET_H
>  
> +#include <linux/device.h>
> +

    Besides, this is not against the recent kernel -- there should be #include 
<linux/slab.h> here.

>  struct usb_ep;
>  
>  /**

WBR, Sergei
