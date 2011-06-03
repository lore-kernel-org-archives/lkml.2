Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753011Ab1FCSAj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 14:00:39 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:34207 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751321Ab1FCSAh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 14:00:37 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6366"; a="95255393"
From: "Tanya Brokhman" <tlinder@codeaurora.org>
To: <balbi@ti.com>
Cc: <greg@kroah.com>, <linux-usb@vger.kernel.org>,
        <linux-arm-msm@vger.kernel.org>, <ablay@codeaurora.org>,
        "'open list'" <linux-kernel@vger.kernel.org>
References: <1306847914-19876-1-git-send-email-tlinder@codeaurora.org> <1306847914-19876-8-git-send-email-tlinder@codeaurora.org> <20110603080333.GS2409@legolas.emea.dhcp.ti.com>
In-Reply-To: <20110603080333.GS2409@legolas.emea.dhcp.ti.com>
Subject: RE: [PATCH v14 7/9] usb:gadget: Add SuperSpeed support to the Gadget Framework
Date: Fri, 3 Jun 2011 21:00:17 +0300
Message-ID: <003401cc2218$1ae868a0$50b939e0$@org>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
thread-index: AcwhxMBFicOJ61CWQkej0WH5yKnEkAAUlRpA
Content-Language: en-us
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Felipe,

> On Tue, May 31, 2011 at 04:18:27PM +0300, Tatyana Brokhman wrote:
> > @@ -377,9 +425,10 @@ static int config_desc(struct usb_composite_dev
> *cdev, unsigned w_value)
> >  	u8				type = w_value >> 8;
> >  	enum usb_device_speed		speed = USB_SPEED_UNKNOWN;
> >
> > -	if (gadget_is_dualspeed(gadget)) {
> > -		int			hs = 0;
> > -
> > +	if (gadget->speed == USB_SPEED_SUPER)
> 
> if (gadget_is_superspeed(gadget)) ??
I thought so too at first but then I decided that checking gadget->speed is
better here because it's possible that gadget_is_superspeed() will return
true but the actual speed will be for example HS. In that case we want to
enter the  else of this if (else if (gadget_is_dualspeed()) {... })


> > @@ -413,16 +469,22 @@ static int count_configs(struct
> usb_composite_dev *cdev, unsigned type)
> >  	struct usb_configuration	*c;
> >  	unsigned			count = 0;
> >  	int				hs = 0;
> > +	int				ss = 0;
> >
> >  	if (gadget_is_dualspeed(gadget)) {
> >  		if (gadget->speed == USB_SPEED_HIGH)
> >  			hs = 1;
> > +		if (gadget->speed == USB_SPEED_SUPER)
> > +			ss = 1;
> 
> is this really correct under gadget_is_dualspeed() ?? puzzled.
I think so. The assumption is that it's not possible that gadget speed will
be super if the gadget isn't dualspeed. When the COMFIG_GADGET_SUPERSPEED
flag was changeable to the user, it was dependant on the gadget being dual
speed. Now this flag should be turned on by the UDCs that support SS, but
the assumption that they are also dual speed remains.
BTW, are you ok with the handling of driver->speed in usb_composite_probe()?
You didn't reply to the solution me and Alan came up with...

Thanks,
Tanya Brokhman
---
Sent by an consultant of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.




