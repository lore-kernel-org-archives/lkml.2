Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755901Ab2DWW2L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 18:28:11 -0400
Received: from smtprelay-b22.telenor.se ([195.54.99.213]:39050 "EHLO
	smtprelay-b22.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753562Ab2DWW2I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 18:28:08 -0400
X-SENDER-IP: [85.230.169.225]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AlmJAKvWlU9V5qnhPGdsb2JhbABEiiqkGIILBIEPGQEBAQEeGQ0nggoBBTocMwgDRhQlChoBiCW6cBOLDoVLYwSVeYYEjSY
X-IronPort-AV: E=Sophos;i="4.75,470,1330902000"; 
   d="scan'208";a="101727872"
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Tue, 24 Apr 2012 00:31:46 +0200
To: Gustavo Padovan <gustavo@padovan.org>, Jiri Kosina <jkosina@suse.cz>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 4/6] hid: Create a generic device group
Message-ID: <20120423223146.GA6595@polaris.bitmath.org>
References: <1335175627-2270-1-git-send-email-rydberg@euromail.se>
 <1335175627-2270-5-git-send-email-rydberg@euromail.se>
 <20120423212659.GD18564@joana>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120423212659.GD18564@joana>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Gustavo,

> > @@ -586,12 +586,12 @@ struct hid_descriptor {
> >  	struct hid_class_descriptor desc[1];
> >  } __attribute__ ((packed));
> >  
> > -#define HID_DEVICE(b, ven, prod) \
> > -	.bus = (b), \
> > -	.vendor = (ven), .product = (prod)
> > -
> > -#define HID_USB_DEVICE(ven, prod)	HID_DEVICE(BUS_USB, ven, prod)
> > -#define HID_BLUETOOTH_DEVICE(ven, prod)	HID_DEVICE(BUS_BLUETOOTH, ven, prod)
> > +#define HID_DEVICE(b, g, ven, prod)					\
> > +	.bus = (b), .group = (g), .vendor = (ven), .product = (prod)
> > +#define HID_USB_DEVICE(ven, prod)				\
> > +	.bus = BUS_USB, .vendor = (ven), .product = (prod)
> > +#define HID_BLUETOOTH_DEVICE(ven, prod)					\
> > +	.bus = BUS_BLUETOOTH, .vendor = (ven), .product = (prod)
> 
> It seems we don't use this macro anywhere else, why did you keep it?

It is actually used extensively in device lists, see for instance in
drivers/hid/hid-core.c.

Henrik
