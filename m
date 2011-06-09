Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756130Ab1FIU4f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 16:56:35 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:19498 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756039Ab1FIU4c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 16:56:32 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6372"; a="96543729"
From: "Tanya Brokhman" <tlinder@codeaurora.org>
To: "'Alan Stern'" <stern@rowland.harvard.edu>
Cc: <greg@kroah.com>, <linux-usb@vger.kernel.org>,
        <linux-arm-msm@vger.kernel.org>, <balbi@ti.com>,
        <ablay@codeaurora.org>, "'open list'" <linux-kernel@vger.kernel.org>
References: <1307635009-5741-1-git-send-email-tlinder@codeaurora.org> <Pine.LNX.4.44L0.1106091449490.2081-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1106091449490.2081-100000@iolanthe.rowland.org>
Subject: RE: [PATCH v2] usb:dummy_hcd: Force FS device connection according to module parameter
Date: Thu, 9 Jun 2011 23:56:22 +0300
Message-ID: <027301cc26e7$b5c99690$215cc3b0$@org>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
thread-index: Acwm1kF18jy0SMTsTiW2Oax1yb7SnAAEQ50w
Content-Language: en-us
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > @@ -904,12 +908,15 @@ usb_gadget_probe_driver(struct
> usb_gadget_driver *driver,
> >  	dum->gadget.ep0 = &dum->ep [0].ep;
> >  	if (mod_data.is_super_speed)
> >  		dum->gadget.speed = driver->speed;
> > -	else
> > +	else if (mod_data.is_high_speed)
> >  		dum->gadget.speed = min((u8)USB_SPEED_HIGH, (u8)driver-
> >speed);
> 
> Use min_t().

Ok, will update.

> 
> > +	else
> > +		dum->gadget.speed = USB_SPEED_FULL;
> >  	if (dum->gadget.speed < driver->speed)
> > -		dev_dbg(udc_dev(dum), "This device can perform faster if"
> > -				      " you connect it to a "
> > -				      "SupeSpeed port...\n");
> > +		dev_dbg(udc_dev(dum), "This device can perform faster"
> > +				" if you connect it to a %s port...\n",
> > +			(driver->speed == USB_SPEED_SUPER ?
> > +			 "SuperSpeed" : "HighSpeed"));
> >
> >  	if (dum->gadget.speed == USB_SPEED_SUPER) {
> >  		for (i = 0; i < DUMMY_ENDPOINTS; i++)
> > @@ -2417,6 +2424,9 @@ static int __init init (void)
> >  	if (usb_disabled ())
> >  		return -ENODEV;
> >
> > +	if (!mod_data.is_high_speed && mod_data.is_super_speed)
> > +		return -EINVAL;
> 
> Print an error message in the log so that the user will know why the
> failure occurred.
> 

But when the module fails to load the message sais that it's invalid
parameter (or something like that). That's why I thought it will be enough. 
You mean to add something that explains WHY these values are wrong?


Thanks,
Tanya Brokhman
---
Sent by an consultant of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.




