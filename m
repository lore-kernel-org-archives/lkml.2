Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753974Ab1CKTMO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 14:12:14 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:37175 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753803Ab1CKTMM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 14:12:12 -0500
Date: Fri, 11 Mar 2011 14:12:10 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: andy.green@linaro.org
cc: Greg KH <greg@kroah.com>, Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Linux USB list <linux-usb@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: RFC: Platform data for onboard USB assets
In-Reply-To: <4D7A654F.7010709@linaro.org>
Message-ID: <Pine.LNX.4.44L0.1103111406270.1975-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Mar 2011, Andy Green wrote:

> I don't believe I referred to class devices anywhere.  It does not 
> matter if the main chip function is class device or not.

It matters because the class specification for a USB device is never 
going to mention information sources that are outside the USB protocol, 
such as board definitions.  Consequently a class driver will never need 
to use such a thing.

> If there is any kind of "functional implementation" knowledge that is 
> outside the chip and driver itself, it has to be held somewhere, and 
> applied appropriately.  platform_data from the board definition file is 
> the established place for that knowledge that is specific to a board.

Since essentially all of the USB drivers currently in the kernel _are_
class drivers (at least, I'm not aware of any non-trivial exceptions),
this means none of the existing USB drivers should need to access any
platform data.

Of course, this doesn't rule out the possibility of platform-specific 
USB drivers that _do_ need this information.

> > Also, do you have a real example of a USB driver today that needs this?
> 
> I think you find without devpath -> platform_data mapping, the kind of 
> layout given above is made quite difficult to support in Linux.

What would be needed to support such a mapping?  It seems to me that we 
probably have all the necessary ingredients in place already.

Alan Stern

