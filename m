Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752804Ab0KFSrF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Nov 2010 14:47:05 -0400
Received: from netrider.rowland.org ([192.131.102.5]:44432 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751828Ab0KFSrD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Nov 2010 14:47:03 -0400
Date: Sat, 6 Nov 2010 14:47:02 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: David Brownell <david-b@pacbell.net>
cc: Vasiliy Kulikov <segooon@gmail.com>, <kernel-janitors@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@suse.de>, Oliver Neukum <oliver@neukum.org>,
        Andi Kleen <ak@linux.intel.com>, Chris Frey <cdfrey@foursquare.net>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] usb: core: fix information leak to userland
In-Reply-To: <502882.59497.qm@web180306.mail.gq1.yahoo.com>
Message-ID: <Pine.LNX.4.44L0.1011061441150.28403-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 6 Nov 2010, David Brownell wrote:

> --- On Sat, 11/6/10, Alan Stern <stern@rowland.harvard.edu> wrote:
> 
> > Are you sure that adding an initializer
> > like this will zero out the 
> > padding bytes?  It might be safer just to call
> > memset.
> 
> ISTR the C standard says things get initted to
> zero in this case too ... and that compilers will
> as a rule use memset to do it.  One could look
> at the generated code to make sure of that.

Unfortunately I don't have a copy of the C standard here to consult.  
However...  Although I'm perfectly willing to believe that the standard
requires fields in a structure to be initialized to 0 if they
aren't mentioned explicitly in the initializer, I'm considerably more
doubtful that it also requires padding to be initialized!

And I certainly wouldn't want to depend on compilers _always_ using 
memset to do this initialization.

> There's certainly a fair amount of code I've seen
> that uses runtime initializers like that, to zero
> memory.  I can't believe i's _all_ broken!  ;)

Zeroing memory that belongs to a declared field is different from 
zeroing padding bytes.  Maybe what you remember seeing is the first and 
not the second.

Alan Stern

