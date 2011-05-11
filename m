Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753848Ab1EKRam (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 13:30:42 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:43009 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751225Ab1EKRak (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 13:30:40 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6342"; a="90749738"
From: "Tanya Brokhman" <tlinder@codeaurora.org>
To: <balbi@ti.com>
Cc: <greg@kroah.com>, <linux-usb@vger.kernel.org>,
        <linux-arm-msm@vger.kernel.org>, <ablay@codeaurora.org>,
        "'open list'" <linux-kernel@vger.kernel.org>
References: <1304853414-10234-1-git-send-email-tlinder@codeaurora.org> <1304853414-10234-5-git-send-email-tlinder@codeaurora.org> <20110509091904.GE1254@legolas.emea.dhcp.ti.com>
In-Reply-To: <20110509091904.GE1254@legolas.emea.dhcp.ti.com>
Subject: RE: [PATCH v9 4/7] usb:gadget: Add SuperSpeed support to the Gadget Framework
Date: Wed, 11 May 2011 16:00:24 +0300
Message-ID: <000901cc0fdb$66ec7a10$34c56e30$@org>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: AcwOKiDiOcLIjAjGQB2Jezscn3tbSQBsPKSQ
Content-Language: en-us
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > @@ -157,7 +167,31 @@ ep_found:
> >  	/* commit results */
> >  	_ep->maxpacket = le16_to_cpu(chosen_desc->wMaxPacketSize);
> >  	_ep->desc = chosen_desc;
> > -
> > +	_ep->comp_desc = NULL;
> > +	_ep->maxburst = 0;
> > +	_ep->mult = 0;
> > +	if (want_comp_desc) {
> > +		/*
> > +		 * Companion descriptor should follow EP descriptor
> > +		 * USB 3.0 spec, #9.6.7
> > +		 */
> > +		comp_desc = (struct usb_ss_ep_comp_descriptor *)*(++d_spd);
> > +		if (!comp_desc ||
> > +		    (comp_desc->bDescriptorType !=
> USB_DT_SS_ENDPOINT_COMP))
> > +			return -EIO;
> > +		_ep->comp_desc = comp_desc;
> > +		if (g->speed == USB_SPEED_SUPER) {
> > +			int xfer_type = _ep->bEndpointAddress &
> > +				USB_ENDPOINT_XFERTYPE_MASK ;
> 
> how about something liks:
> 
> switch (usb_endpoint_type(_ep->desc) {
> case USB_ENDPOINT_XFER_BULK:
> case USB_ENDPOINT_XFER_INT:
> 	_ep->maxburst = comp_desc->bMaxBurst;
> 	break;
> case USB_ENDPOINT_XFER_ISOC:
> 	_ep->mult = comp_desc->bmAttributes & 0x03;
> 	break;
> default:
> 	/* nothing to do for control endpoints */
> 	break;
> }
> 
> --
> balbi

You're right. Your way is nicer. Will do.
Are you finished with reviewing the patches or should I wait with another
version?

Best regards,
Tanya Brokhman
Consultant for Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum




