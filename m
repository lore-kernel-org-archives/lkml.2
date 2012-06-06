Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757071Ab2FFQ6c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 12:58:32 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:51332 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752410Ab2FFQ6b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 12:58:31 -0400
Date: Wed, 6 Jun 2012 12:58:29 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
cc: Ming Lei <ming.lei@canonical.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        USB list <linux-usb@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] driver core: fix shutdown races with probe/remove
In-Reply-To: <20120606155515.GM19601@linux.vnet.ibm.com>
Message-ID: <Pine.LNX.4.44L0.1206061256400.1788-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 Jun 2012, Paul E. McKenney wrote:

> On Wed, Jun 06, 2012 at 11:44:50AM -0400, Alan Stern wrote:
> > On Wed, 6 Jun 2012, Paul E. McKenney wrote:
> > 
> > > > That just seems wrong.  By the same reasoning, the compiler is within 
> > > > its rights to transform either the original code or the code using 
> > > > ACCESS_ONCE into:
> > > > 
> > > > 	b = 999;
> > > > 	if (a)
> > > > 		b = 9;
> > > > 	else
> > > > 		b = 42;
> > > > 
> > > > and again, other code would be confused.  The simple fact is that 
> > > > SMP-safe code is not likely to be produced by a compiler that assumes 
> > > > everything is single-threaded.
> > > 
> > > If you use ACCESS_ONCE(), the compiler is prohibited from inserting
> > > the "b = 999".
> > 
> > What prohibits it?
> 
> The compiler cannot move a volatile access across a sequence point, for
> example, across a statement boundary.

How does inserting a store to a non-volatile value qualify as moving a
volatile access?

Alan Stern

