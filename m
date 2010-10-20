Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752622Ab0JTXoS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 19:44:18 -0400
Received: from mga09.intel.com ([134.134.136.24]:13477 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751211Ab0JTXoR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 19:44:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.57,357,1283756400"; 
   d="scan'208";a="669316527"
Date: Wed, 20 Oct 2010 16:44:15 -0700
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Brokhman Tatyana <tlinder@codeaurora.org>, linux-usb@vger.kernel.org,
        David Brownell <dbrownell@users.sourceforge.net>,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: [RFC/PATCH 2/2] usb: Adding SuperSpeed support to dummy_hcd
Message-ID: <20101020234346.GA2634@xanatos>
References: <3bcbaf2980892d18960a399f235fd993.squirrel@www.codeaurora.org>
 <Pine.LNX.4.44L0.1010120953070.1705-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1010120953070.1705-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 12, 2010 at 09:55:29AM -0400, Alan Stern wrote:
> On Tue, 12 Oct 2010, Brokhman Tatyana wrote:
> 
> > Hi Alan
> > 
> > Thanks you for your comments. Please see my reply inline.
> 
> > > In addition, I suspect the dummy_hcd driver structure shouldn't contain
> > > an address_device entry.  It should be present only in dummy_ss_hcd.
> > 
> > I'm not sure I follow...
> > According to the code and comments in hub.c address_device cb is used if
> > the host controller wishes to choose the device address itself instead of
> > the address chosen by the core.
> 
> Correct.
> 
> >  It seems to me that there is nothing
> > preventing the dummy_hcd from supplying such cb as well. Is there?
> > Having both HS and SS dummy_hcd determine the device address seems more
> > convenient for testing proposes.
> 
> For testing purposes, it is best to imitate the behavior of a real 
> device as closely as possible.  USB-2.0 host controllers do not assign 
> their own addresses to devices; they use the addresses provided by 
> usbcore.  I think this is also true for the low/full/high-speed 
> components of a USB-3.0 controller.

There is only one controller, the xHCI controller, that handles all
device speeds.  There are no companion controllers for a USB 3.0 host
controller.  The xHCI host controller uses the hardware assigned address
for all devices (LS/FS/HS/SS), not the usbcore address.

But I'll admit I don't understand what dummy-hcd is supposed to do, so
I'm a bit confused as to why it needs an address_device function.  Is it
supposed to be the gadget-side interface to the hardware that's
transmitting over USB (i.e. responding to the USB host)?  Or does it
have something to do with a gadget switching over to host mode for OTG?

Sarah Sharp
