Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753166Ab1A0NS7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 08:18:59 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:12747 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751000Ab1A0NS6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 08:18:58 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6238"; a="71972840"
From: "Tanya Brokhman" <tlinder@codeaurora.org>
To: "'Greg KH'" <greg@kroah.com>
Cc: <gregkh@suse.de>, <linux-usb@vger.kernel.org>,
        <linux-arm-msm@vger.kernel.org>,
        "'David Brownell'" <dbrownell@users.sourceforge.net>,
        <linux-kernel@vger.kernel.org>
References: <1290084400-25440-1-git-send-email-tlinder@codeaurora.org> <20101118145623.GB16565@kroah.com>
In-Reply-To: <20101118145623.GB16565@kroah.com>
Subject: RE: [PATCH v4 1/4] usb gadget: Add usb_endpoint_descriptor to be part of the struct usb_ep
Date: Thu, 27 Jan 2011 15:18:47 +0200
Message-ID: <000001cbbe24$bd64a1a0$382de4e0$@org>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: AcuHML9tHfFkJEChSLyIPhXyPNJNLg1ZPkQw
Content-Language: en-us
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Thu, Nov 18, 2010 at 02:46:38PM +0200, Tatyana Brokhman wrote:
> > Change usb_ep_enable() prototype to use endpoint descriptor from
> usb_ep.
> > This optimization spares the FDs from saving the endpoint chosen
> > descriptor.
> 
> Why is this a good thing to do?
> 

Because the FDs don't modify the ep descriptor, just pass it through
different functions so there is no need for the FD to save a copy of the
chosen ep descriptor.

> > This optimization is not full though. To fully exploit this
> > change one needs to update all the UDCs as well since in the current
> > implementation each of them saves the endpoint descriptor in it's
> > internal (and extended) endpoint structure.
> 
> Do you do that optimization later on in this patch series?
> 
 
No, we don't because we don't have the ability to test all the UDCs. Right
now the UDCs weren't modified and there is a code duplication. Meaning the
ep descriptor is saved both in the usb_ep structure and in the UDCs internal
ep structure. It's not very "clean" but nothing is broken.

> > +++ b/include/linux/usb/gadget.h
> > @@ -131,20 +131,22 @@ struct usb_ep_ops {
> >   * @maxpacket:The maximum packet size used on this endpoint.  The
> initial
> >   *	value can sometimes be reduced (hardware allowing), according to
> >   *      the endpoint descriptor used to configure the endpoint.
> > - * @driver_data:for use by the gadget driver.  all other fields are
> > - *	read-only to gadget drivers.
> > + * @driver_data:for use by the gadget driver.
> 
> Why did you change the "all other fields..." portion?

Because the FD updates the usb_ep->desc field as well (with the value
returned from ep_choose()).

Sorry for the late response and the bad quoting (the email is a bit old). My
reply was delayed because our intention was to release the UT I mentioned
with the next version but unfortunately getting legal approval is taking
longer than we expected.

Best regards,
Tanya Brokhman
Consultant for Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum




