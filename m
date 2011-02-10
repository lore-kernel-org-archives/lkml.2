Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756518Ab1BJPN1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 10:13:27 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:38190 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752313Ab1BJPN0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 10:13:26 -0500
Date: Thu, 10 Feb 2011 10:13:25 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Tanya Brokhman <tlinder@codeaurora.org>
cc: gregkh@suse.de, <linux-arm-msm@vger.kernel.org>,
        "'open list:USB GADGET/PERIPH...'" <linux-usb@vger.kernel.org>,
        "'open list'" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v7 1/5] usb: Adding SuperSpeed support to dummy_hcd
In-Reply-To: <001601cbc922$a0abb630$e2032290$@org>
Message-ID: <Pine.LNX.4.44L0.1102101011480.2029-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Feb 2011, Tanya Brokhman wrote:

> > > +	if (dum->gadget.speed < USB_SPEED_SUPER)
> > > +		max &= 0x3ff;
> > 
> > Strictly speaking, both the old and the new code are wrong.  For all
> > devices, regardless of speed, we should say:
> > 
> > 	max = le16_to_cpu(desc->wMaxPacketSize) & 0x7ff;
> > 
> > In other words, the speed is contained in bits 0..10 (not 0..9).
> > 
> 
> You're right about HS/FS/LS devices but I see something different in the
> USB30 spec for SS devices. Could you please refer me to what errata this was
> mentioned in? I looked through them and according to errata from 01/15/09
> the definition of wMaxPacketSize field in the SS endpoint descriptor is:
> 
> "Maximum packet size this endpoint is capable of sending or receiving when
> this configuration is selected. For control endpoints this field shall be
> set to 512. For bulk endpoint types this field shall be set to 1024."
> 
> So according to the above, for SS devices, the whole 2 bytes contain the
> maxpacketsize and not only bits 0..10. 
> Am I missing something?

No, you are right.  However, it is still true even with SS that the
value is contained in bits 0..10, since the value can never be larger
than 2047.

Alan Stern

