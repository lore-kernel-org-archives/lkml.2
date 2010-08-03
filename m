Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932321Ab0HCPuS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 11:50:18 -0400
Received: from cantor.suse.de ([195.135.220.2]:38057 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932204Ab0HCPuP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 11:50:15 -0400
Date: Tue, 3 Aug 2010 08:46:15 -0700
From: Greg KH <gregkh@suse.de>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Valdis.Kletnieks@vt.edu, "Justin P. Mattock" <justinmattock@gmail.com>,
        linux-usb@vger.kernel.org, dbrownell@users.sourceforge.net,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2]drivers/usb/core/sysfs.c Fix variable 'retval' set
 but not used
Message-ID: <20100803154615.GA32034@suse.de>
References: <66093.1280848412@localhost>
 <Pine.LNX.4.44L0.1008031133270.1853-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1008031133270.1853-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 03, 2010 at 11:34:26AM -0400, Alan Stern wrote:
> On Tue, 3 Aug 2010 Valdis.Kletnieks@vt.edu wrote:
> 
> > > Failure to create a file in sysfs is almost never fatal and usually not 
> > > even dangerous.  Ignoring the error is generally better than failing 
> > > the entire operation.
> > 
> > Then why the __must_check attribute if it's usually ignorable? I thought
> > that was reserved for functions that you damned sight better well check
> > for errors because bad things are afoot otherwise?
> 
> That's a good question.  Perhaps Greg KH knows the answer.

You should check the return value for that function.  To not do that is
a bug.  This one looks like it snuck through.  Fixing it properly is the
correct thing to do.

thanks,

greg k-h
