Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932440Ab0HCRJd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 13:09:33 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:38657 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756716Ab0HCRJc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 13:09:32 -0400
Date: Tue, 3 Aug 2010 13:09:31 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Greg KH <gregkh@suse.de>
cc: Valdis.Kletnieks@vt.edu, "Justin P. Mattock" <justinmattock@gmail.com>,
        <linux-usb@vger.kernel.org>, <dbrownell@users.sourceforge.net>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2]drivers/usb/core/sysfs.c Fix variable 'retval' set
 but not used
In-Reply-To: <20100803154615.GA32034@suse.de>
Message-ID: <Pine.LNX.4.44L0.1008031301490.1853-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Aug 2010, Greg KH wrote:

> On Tue, Aug 03, 2010 at 11:34:26AM -0400, Alan Stern wrote:
> > On Tue, 3 Aug 2010 Valdis.Kletnieks@vt.edu wrote:
> > 
> > > > Failure to create a file in sysfs is almost never fatal and usually not 
> > > > even dangerous.  Ignoring the error is generally better than failing 
> > > > the entire operation.
> > > 
> > > Then why the __must_check attribute if it's usually ignorable? I thought
> > > that was reserved for functions that you damned sight better well check
> > > for errors because bad things are afoot otherwise?
> > 
> > That's a good question.  Perhaps Greg KH knows the answer.
> 
> You should check the return value for that function.  To not do that is
> a bug.  This one looks like it snuck through.  Fixing it properly is the
> correct thing to do.

In other words, usb_set_configuration() should fail if 
usb_create_sysfs_intf_files() is unable to create the attribute file 
containing an interface's string descriptor?

And likewise, ehci_run() should fail if the "companion" and debugging 
files can't be created?

Alan Stern

