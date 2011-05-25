Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755540Ab1EYLbk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 07:31:40 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:31658 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751892Ab1EYLbi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 07:31:38 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6356"; a="93518955"
From: "Tanya Brokhman" <tlinder@codeaurora.org>
To: <balbi@ti.com>
Cc: "'Alan Stern'" <stern@rowland.harvard.edu>,
        "'Sarah Sharp'" <sarah.a.sharp@linux.intel.com>, <greg@kroah.com>,
        <linux-usb@vger.kernel.org>, <linux-arm-msm@vger.kernel.org>,
        <ablay@codeaurora.org>, "'open list'" <linux-kernel@vger.kernel.org>
References: <Pine.LNX.4.44L0.1105241012080.1913-100000@iolanthe.rowland.org> <013201cc1a96$bdda7910$398f6b30$@org> <20110525092124.GI14556@legolas.emea.dhcp.ti.com> <015801cc1abd$ca534e20$5ef9ea60$@org> <20110525092743.GK14556@legolas.emea.dhcp.ti.com> <018e01cc1ac0$2b09b040$811d10c0$@org> <20110525094902.GM14556@legolas.emea.dhcp.ti.com> <01a601cc1ac2$f0041a00$d00c4e00$@org> <20110525102945.GN14556@legolas.emea.dhcp.ti.com> <01b401cc1ac9$d1c57870$75506950$@org> <20110525112350.GP14556@legolas.emea.dhcp.ti.com>
In-Reply-To: <20110525112350.GP14556@legolas.emea.dhcp.ti.com>
Subject: RE: [PATCH v12 7/8] usb: Adding SuperSpeed support to dummy_hcd
Date: Wed, 25 May 2011 14:33:18 +0300
Message-ID: <01c601cc1acf$8e28e920$aa7abb60$@org>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: Acwazj3XMalZc8oORm65sA2posm3IQAAIHeA
Content-Language: en-us
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Felipe

> > > ---
> > > -*/
> > >
> > >  static struct usb_gadget_driver composite_driver = {
> > > +#ifdef CONFIG_USB_GADGET_SUPERSPEED
> > > +       .speed          = USB_SPEE_SUPER,
> > > +#else
> > >         .speed          = USB_SPEED_HIGH,
> > > +#endif
> > >
> > >         .unbind         = composite_unbind,
> > >
> >
> > I have no problem updating static struct usb_gadget_driver
> > composite_driver as you suggested but it seems the same as updating
> it
> > @ usb_composite_probe()...
> 
> still, you will have two places poking at the same field. It's better
> to keep it at once, update only that and we will take your approach.
> 

Ok so just to make sure I understand you correctly:
You want me to remove the modification made to usb_composite_probe() and
instead add:
static struct usb_gadget_driver composite_driver = {
+#ifdef CONFIG_USB_GADGET_SUPERSPEED
+       .speed          = USB_SPEE_SUPER,
+#else
	  .speed          = USB_SPEED_HIGH,
+#endif
	  .unbind         = composite_unbind,

And then you'll be ok with change? Or is there anything else?

If this is it then I'm relieved :) and of course will update the code.


Best regards,
Tanya Brokhman
Consultant for Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum




