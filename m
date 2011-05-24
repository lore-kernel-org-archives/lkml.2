Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932667Ab1EXOUk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 10:20:40 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:44944 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932554Ab1EXOUi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 10:20:38 -0400
Date: Tue, 24 May 2011 10:20:37 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Tanya Brokhman <tlinder@codeaurora.org>
cc: balbi@ti.com, "'Sarah Sharp'" <sarah.a.sharp@linux.intel.com>,
        <greg@kroah.com>, <linux-usb@vger.kernel.org>,
        <linux-arm-msm@vger.kernel.org>, <ablay@codeaurora.org>,
        "'open list'" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v12 7/8] usb: Adding SuperSpeed support to dummy_hcd
In-Reply-To: <011d01cc19ff$616055c0$24210140$@org>
Message-ID: <Pine.LNX.4.44L0.1105241012080.1913-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 May 2011, Tanya Brokhman wrote:

> Hi Felipe
> 
> > > Yes :) The driver->speed is updated in usb_composite_probe() if
> > > CONFIG_USB_GADGET_SUPERSPEED is defined.
> > >
> > > So, are we ok with this solution? The module parameter I mean?
> > > Are you going to try the v13 in your branch? Please let me know how
> > it
> > > goes and of course if you have any comments.
> > 
> > I think it still gives the possibility for failure. I would rather not
> > take that until all gadget drivers are fixed. We can help you doing
> > that and we only change driver->speed after all gadget drivers have
> > their "sensible defaults" SuperSpeed descriptors.
> 
> By "until all gadget drivers are fixed" you mean until all gadget drivers
> provide SS descriptors? This will take for ever... 
> I wasn't about to modify all gadget drivers and to add SS descriptors for
> them. I can add default values (as generate_ss_descriptors() did if you
> remember) but I don't think this is the right approach because as you said -
> different gadget drivers might have different SS descriptors and I don't
> feel confident enough to set these values. Nor do I have the ability to test
> each of the gadget drivers the way I would like to after this change.
> The only gadget driver I felt confident adding SS descriptors for is UASP,
> which I tested properly.
> 
> Actually if the CONFIG_USB_GADGET_SUPERSPEED is turned off, which is the
> default of it, the speed won't be updated and all these series won't be
> functional so I don't see any possibilities for failure in such
> configuration. Or am I missing something?

dummy_hcd should work when CONFIG_USB_GADGET_SUPERSPEED is enabled,
even if the usb_gadget_driver structure is initialized with the speed
field set to USB_SPEED_HIGH.  This will be true for all the standalone
gadget drivers until they are updated.

Which leaves a question about the composite gadget framework.  Should
it be updated with SS support?  Probably not until the various function
drivers have all been updated.

Alan Stern

