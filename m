Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755681Ab1CKWHm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 17:07:42 -0500
Received: from gate.crashing.org ([63.228.1.57]:55181 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755144Ab1CKWHj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 17:07:39 -0500
Subject: Re: RFC: Platform data for onboard USB assets
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: andy.green@linaro.org
Cc: Greg KH <greg@kroah.com>, Linux USB list <linux-usb@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>
In-Reply-To: <4D7A50B2.9030603@linaro.org>
References: <4D79F068.2080009@linaro.org> <20110311160815.GA7426@kroah.com>
	 <4D7A4BDE.7050206@linaro.org> <20110311163628.GB9291@kroah.com>
	 <4D7A50B2.9030603@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 12 Mar 2011 09:07:29 +1100
Message-ID: <1299881249.22236.646.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-03-11 at 16:41 +0000, Andy Green wrote:
> >> Is it true that for on-board devices, it can sometimes be legitimate
> >> and useful to be able to deliver platform_data from the board file
> >> through to stuff on a USB bus, same as you would for memory mapped,
> >> I2C, other busses?
> >>
> >> Or is that it since it is USB, it can never be useful or legitimate,
> >> no matter what different kind of wired-up on-board USB device it is,
> >> to have the board definition file configure the driver for that
> >> instantiation?
> >
> > Since it is USB, it is always discoverable, so it doesn't make any sense
> > to have this type of thing.
> >
> > And since your only example was a network device, I think you proved
> > your point :)

Actually there are reasons to pass that sort of static informations for
"discoverable" devices, essentially when such devices are wired on a
board. MAC addresses come to mind (how many on-board NICs don't have a
MAC SEEPROM wired to them ? Even on PCI we've seen that...) etc...

However, the device-tree would deal with that quite nicely. It doesn't
require you to represent discoverable devices but you -can- do it, and
it's typically a good idea for soldered devices for that reason.

The USB binding for device-trees uses physical port numbers in Hubs as
the primary addressing scheme so it would work just fine to represent
the USB devices soldered on the board as well.

And here you get your transport. The USB core wouldn't need more than a
handful of lines of code to generically update the usb_device's struct
device embedded device_node pointer when a match exists, so the driver
only needs to check if the device is linked to a device-tree node, and
if it is, fetch informations from there.

As to how the device-tree is constructed, all the usual stuff applies
here, can be in flash, can be "fixed up" by FW or platform code (to
stick a unique MAC address from flash for example or calculated from a
serial number etc....).

But you have you "transport" mechanism sorted.

Cheers,
Ben.

