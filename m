Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756613Ab1EXRUr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 13:20:47 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:58096 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752153Ab1EXRUp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 13:20:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=HvknnIdEhuv3k55s+QZIAbAwe54s/B5uGIhf/JVIIibvgdz6b6b8IjT0W7kOoNEdsU
         3t+II+GfmuQYNAISnXFqS5oqnGvT4rjGewHJIXO4PLxF0ptOr6UpoyZm5Iiuk6AHeDmu
         hdwGWrz2oqdnvTVfhOiFt4cNXAGnjN5vNi3sk=
MIME-Version: 1.0
In-Reply-To: <1306231330-11158-6-git-send-email-tlinder@codeaurora.org>
References: <1306231330-11158-1-git-send-email-tlinder@codeaurora.org> <1306231330-11158-6-git-send-email-tlinder@codeaurora.org>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Tue, 24 May 2011 13:20:24 -0400
Message-ID: <BANLkTi=0Esm7w-TJ03ugPfVTuCr158=Y1Q@mail.gmail.com>
Subject: Re: [PATCH v13 5/8] usb:gadget: Add SuperSpeed support to the Gadget Framework
To: Tatyana Brokhman <tlinder@codeaurora.org>
Cc: greg@kroah.com, linux-usb@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        balbi@ti.com, ablay@codeaurora.org,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 24, 2011 at 06:02, Tatyana Brokhman wrote:
> +config USB_GADGET_SUPERSPEED
> +       boolean "Gadget operating in Super Speed"

perhaps better phrasing would be: Enable Super Speed support

maybe i didnt look too closely, but it seems like very little even
depends upon this Kconfig option in the actual source.  only the
"gadget_is_superspeed()", and that is used lightly.  so i wonder how
useful this is even having ...

> +                               value = min(w_length, (u16) value);

i know you're just following existing style, but i wonder if these all
shouldnt just be min_t(u16, ...)

> +                               ERROR(cdev, "func_suspend() returned "
> +                                           "error %d\n", value);

please dont split string literals over multiple lines


> +               default:
> +                       break;
> +               }

isnt that the default behavior already ?  so these two lines are pointless ?


> --- a/include/linux/usb/ch9.h
> +++ b/include/linux/usb/ch9.h
> @@ -142,8 +142,6 @@
>  #define USB_DEVICE_LTM_ENABLE  50      /* dev may send LTM */
>  #define USB_INTRF_FUNC_SUSPEND 0       /* function suspend */
>
> -#define USB_INTR_FUNC_SUSPEND_OPT_MASK 0xFF00
> -
>  #define USB_ENDPOINT_HALT              0       /* IN/OUT will STALL */
>
>  /* Bit array elements as returned by the USB_REQ_GET_STATUS request. */

erm, seems unrelated to this patchset ?  did this sneak in by accident ?

> +static inline int gadget_is_superspeed(struct usb_gadget *g)
> +{
> +#ifdef CONFIG_USB_GADGET_SUPERSPEED
> +       /* runtime test would check "g->is_superspeed" ... that might be
> +        * useful to work around hardware bugs, but is mostly pointless
> +        */

multiline comments should read:
  /*
   * foo .....
   */
-mike
