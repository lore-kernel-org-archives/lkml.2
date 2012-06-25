Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757151Ab2FYOLq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 10:11:46 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:58395 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757029Ab2FYOLp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 10:11:45 -0400
Date: Mon, 25 Jun 2012 10:11:43 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
cc: Andrzej Pietrasiewicz <andrzej.p@samsung.com>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Kyungmin Park <kyungmin.park@samsung.com>, Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joel Becker <jlbec@evilplan.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [RFC 0/2] USB gadget - configfs
In-Reply-To: <4FE76F6C.1090300@linutronix.de>
Message-ID: <Pine.LNX.4.44L0.1206251006520.1770-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 24 Jun 2012, Sebastian Andrzej Siewior wrote:

> On 06/21/2012 12:55 PM, Andrzej Pietrasiewicz wrote:
> > $ echo 1>   /cfg/usb-function-gadget/G1/connect
> > $ file.img>  /cfg/usb-function-gadget/G1/C1/F1/f_mass_storage/lun0/file
> 
> connect should be available at UDC level which triggers the
> pull-up/down of the UDC. The gadget itself should be configured once
> and made available / bound to the UDC. And you may have more
> than once UDC at a time within a single a system.
> 
> > Each function, after creating its corresponding directory
> > (/cfg/usb-function-gadget/G1/C1/F1), must be "personalized" by storing
> > its name in the "name" attribute. After that it is possible to create
> > a child item of the same name ("f_mass_storage" here). The common code
> > handles everything from top of the hierarchy up to the function directory.
> > Under the function directory a function-specific stuff provided by each
> > function is used. The function-specific code is abstracted by the above
> > mentioned struct ufg_fn. In the example, the mass storage function is
> > supplied with one LUN.
> 
> The hierarchy looks good. C1 vs config1 is just taste.

My taste prefers "config1".  Same for "gadget1" and "func1" (or 
"function1").  Words -- even short or abbreviated words -- are a lot 
more meaningful to people than single letters are.

> > 4. Do we need module parameters for USB descriptors like iManufacturer
> >     and similar?
> No. No modules parameters at all. With one exception: Currently we set
> those things via modprobe. As a for compatibility interface I guess we
> have to keep this. In the end I would like have f_mass_storage gone as 
> it. We would have a new gadget_storage which provides only the function 
> and relies on configfs module and nothing else. The replacement
> g_mass_storage would simply be a small module which takes the
> iManufacturer parameters and others and configures the gadget the way
> the old gadget did i.e. without echo this and echo that.

In any case, iManufacturer should not be adjustable by the user.  It 
should always be managed by the composite-gadget layer, since it 
contains nothing but the index number of the Manufacturer string 
descriptor.

Alan Stern

