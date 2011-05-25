Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757877Ab1EYN0G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 09:26:06 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:55418 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756815Ab1EYN0F convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 09:26:05 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6356"; a="93552146"
From: "Tanya Brokhman" <tlinder@codeaurora.org>
To: "'Mike Frysinger'" <vapier.adi@gmail.com>
Cc: <greg@kroah.com>, <linux-usb@vger.kernel.org>,
        <linux-arm-msm@vger.kernel.org>, <balbi@ti.com>,
        <ablay@codeaurora.org>, "'open list'" <linux-kernel@vger.kernel.org>
References: <1306231330-11158-1-git-send-email-tlinder@codeaurora.org> <1306231330-11158-6-git-send-email-tlinder@codeaurora.org> <BANLkTi=0Esm7w-TJ03ugPfVTuCr158=Y1Q@mail.gmail.com>
In-Reply-To: <BANLkTi=0Esm7w-TJ03ugPfVTuCr158=Y1Q@mail.gmail.com>
Subject: RE: [PATCH v13 5/8] usb:gadget: Add SuperSpeed support to the Gadget Framework
Date: Wed, 25 May 2011 16:27:29 +0300
Message-ID: <01f801cc1adf$81059e40$8310dac0$@org>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: AcwaNt8SDn7x5cIyQCOsObeN2/uVQwAp+6Cg
Content-Language: en-us
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mike

 
> On Tue, May 24, 2011 at 06:02, Tatyana Brokhman wrote:
> > +config USB_GADGET_SUPERSPEED
> > +       boolean "Gadget operating in Super Speed"
> 
> perhaps better phrasing would be: Enable Super Speed support

Np. Will update.

> maybe i didnt look too closely, but it seems like very little even
> depends upon this Kconfig option in the actual source.  only the
> "gadget_is_superspeed()", and that is used lightly.  so i wonder how
> useful this is even having ...

No, this flag is VERY important :) If it's set the driver speed is updated to USB_SPEED_SUPER. Look at usb_composite_probe()

> > +                               value = min(w_length, (u16) value);
> 
> i know you're just following existing style, but i wonder if these all
> shouldnt just be min_t(u16, ...)

Perhaps, but it seems to me that this change also isn't related to these patch series so I prefer to follow existing style and maybe post a follow up patch to update all. 


> > +                               ERROR(cdev, "func_suspend() returned
> "
> > +                                           "error %d\n", value);
> 
> please dont split string literals over multiple lines

Done.

> 
> > +               default:
> > +                       break;
> > +               }
> 
> isnt that the default behavior already ?  so these two lines are
> pointless ?

Removed.

> 
> > --- a/include/linux/usb/ch9.h
> > +++ b/include/linux/usb/ch9.h
> > @@ -142,8 +142,6 @@
> >  #define USB_DEVICE_LTM_ENABLE  50      /* dev may send LTM */
> >  #define USB_INTRF_FUNC_SUSPEND 0       /* function suspend */
> >
> > -#define USB_INTR_FUNC_SUSPEND_OPT_MASK 0xFF00
> > -
> >  #define USB_ENDPOINT_HALT              0       /* IN/OUT will STALL
> */
> >
> >  /* Bit array elements as returned by the USB_REQ_GET_STATUS request.
> */
> 
> erm, seems unrelated to this patchset ?  did this sneak in by accident
> ?

You're right. It seems so...

> > +static inline int gadget_is_superspeed(struct usb_gadget *g)
> > +{
> > +#ifdef CONFIG_USB_GADGET_SUPERSPEED
> > +       /* runtime test would check "g->is_superspeed" ... that might
> be
> > +        * useful to work around hardware bugs, but is mostly
> pointless
> > +        */
> 
> multiline comments should read:
>   /*
>    * foo .....
>    */

Done. Thanks for catching that! (checkpatch didn't for some reason...)


Best regards,
Tanya Brokhman
Consultant for Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum




