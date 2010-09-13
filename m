Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752141Ab0IMOsU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 10:48:20 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:33101 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751598Ab0IMOsS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 10:48:18 -0400
Date: Mon, 13 Sep 2010 10:48:17 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Jiri Slaby <jslaby@suse.cz>
cc: phil@ipom.com, <stable@kernel.org>, Greg KH <gregkh@suse.de>,
        USB list <linux-usb@vger.kernel.org>,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: [34-stable regression] USB delay init quirk causes device events
 loss
In-Reply-To: <4C8E33CE.4010105@suse.cz>
Message-ID: <Pine.LNX.4.44L0.1009131045000.1584-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 13 Sep 2010, Jiri Slaby wrote:

> On 09/13/2010 04:16 PM, Alan Stern wrote:
> > On Mon, 13 Sep 2010, Jiri Slaby wrote:
> >> The problem is that the patch shuffles with usb_detect_quirks which used
> >> to disable autosuspend by default. Apparently it no longer does.
> > 
> > I don't see how that patch could have the effect you claim.  
> > usb_detect_quirks still calls usb_disable_autosuspend.  Can you do a 
> > little more debugging to find out why it isn't working as expected?  
> > Reverting the commit is not a good solution.
> 
> Ok, I could, but I have a near-zero knowledge about usb core stuff. What
> I see is that usb_detect_quirks moved from usb_new_device to
> hub_port_connect_change. Might that be that there are broken devices
> which doesn't generate state changes properly?

No, that's not possible.  That state change comes from the device's 
parent hub; without it we wouldn't know that the device was plugged 
in at all.

> In other words, what I could do is to add some printks into
> hub_port_connect_change if that's called at all. If you need some
> thorough debugging printks, please send me a patch to test instead.

Hmm.  I'd prefer to explain how it's all supposed to work and let you
figure out where best to look.  Or try to debug it myself.  Does this
happen with other sorts of USB devices as well, or just wacom?

Alan Stern

