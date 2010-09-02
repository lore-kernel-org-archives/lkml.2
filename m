Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756407Ab0IBTUz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 15:20:55 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:46600 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753061Ab0IBTUx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 15:20:53 -0400
Date: Thu, 2 Sep 2010 15:20:52 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Simon Arlott <simon@fire.lp0.eu>
cc: Greg KH <greg@kroah.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        USB list <linux-usb@vger.kernel.org>
Subject: Re: [PATCH] USB: output an error message when the pipe type  doesn't
 match the endpoint type
In-Reply-To: <4C7FDABA.7080307@simon.arlott.org.uk>
Message-ID: <Pine.LNX.4.44L0.1009021516100.1311-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2 Sep 2010, Simon Arlott wrote:

> On 02/09/10 15:22, Alan Stern wrote:
> > On Thu, 2 Sep 2010, Simon Arlott wrote:
> > 
> >> On Wed, September 1, 2010 18:49, Alan Stern wrote:
> >> > On Wed, 1 Sep 2010, Simon Arlott wrote:
> >> >> > This is okay with me.  If you're serious about not changing the
> >> >> > behavior merely because debugging is enabled, you could move this test
> >> >> > out of the debug-only region and possibly change the dev_err to
> >> >> > dev_dbg.  However doing so might break some devices that are currently
> >> >> > working.
> > 
> > Which suggests that the best approach is to print the error message 
> > always, but allow the submission unless CONFIG_USB_DEBUG is set.
> 
> That could result in a lot of error messages, and it doesn't give any
> information on which driver caused it,

It would if you added the endpoint number and direction to the error 
message.

>  but a single WARN_ON() would
> only be triggered once globally. Each USB device (or endpoint) could
> have a "warned" flag.

That seems ridiculous, especially for such a rare bug.

Alan Stern

