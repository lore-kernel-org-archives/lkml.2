Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753492Ab2LEPqD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 10:46:03 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:52778 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752495Ab2LEPp7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 10:45:59 -0500
Date: Wed, 5 Dec 2012 07:48:00 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Eli Billauer <eli.billauer@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] New driver: Xillybus generic interface for FPGA
 (programmable logic)
Message-ID: <20121205154800.GA4025@kroah.com>
References: <1354117293-13632-1-git-send-email-eli.billauer@gmail.com>
 <20121204034128.GC911@kroah.com>
 <50BDCCCA.4000000@gmail.com>
 <201212042043.18221.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201212042043.18221.arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 04, 2012 at 08:43:18PM +0000, Arnd Bergmann wrote:
> On Tuesday 04 December 2012, Eli Billauer wrote:
> > I'm currently writing some documentation which will cover the API and 
> > also help reading the code, I hope. It takes some time...
> > 
> > Until it's done, let's look at a usage example: Suppose that the FPGA's 
> > application is to receive a high-speed bitstream with time multiplexed 
> > data, demultiplex the bitstream into individual channel streams, and 
> > send each channel's data to the host. And let's say that there are 64 
> > channels in original bitstream. So the FPGA has now 64 independent 
> > sources of data.
> > 
> > For that purpose, the Xillybus IP core (on the FPGA) is configured to 
> > create 64 pipes for FPGA to host communication. The names of these pipes 
> > (say, "chan00", "chan01", ...) are also stored in the FPGA.
> > 
> > When the driver starts, it queries the FPGA for its Xillybus 
> > configuration, and creates 64 device nodes: /dev/xillybus_chan00, 
> > /dev/xillybus_chan01, ... /dev/xillybus_chan63.
> > 
> > If the user wants to dump the data in channel 43 into a file, it's just:
> > 
> > $ cat /dev/xillybus_chan43 > mydump.dat
> > 
> > I hope this clarified things a bit.
> > 
> > I can't see how the firmware interface would help here.
> 
> I think a lot of us (including Greg and me) were confused about
> the purpose of the driver, since you did not include much documentation.
> 
> The request_firmware interface would be useful for loading a model
> into the FPGA, but that doesn't seem to be what your driver is
> concerned with. It's also a bit confusing because it doesn't appear
> to be a "bus" in the Linux sense of being something that provides
> an abstract interface between hardware and kernel device drivers.

Yes, that's what I was confused about as well.  I'll wait for a new
patch with new documentation, before commenting further.

greg k-h
