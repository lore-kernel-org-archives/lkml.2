Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759308Ab2FFXZQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 19:25:16 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:35265 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758916Ab2FFXZO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 19:25:14 -0400
Date: Wed, 6 Jun 2012 16:24:06 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Ming Lei <ming.lei@canonical.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        USB list <linux-usb@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] driver core: fix shutdown races with probe/remove
Message-ID: <20120606232406.GP19601@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20120606155515.GM19601@linux.vnet.ibm.com>
 <Pine.LNX.4.44L0.1206061256400.1788-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1206061256400.1788-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12060623-7408-0000-0000-000005A4BDDB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 06, 2012 at 12:58:29PM -0400, Alan Stern wrote:
> On Wed, 6 Jun 2012, Paul E. McKenney wrote:
> 
> > On Wed, Jun 06, 2012 at 11:44:50AM -0400, Alan Stern wrote:
> > > On Wed, 6 Jun 2012, Paul E. McKenney wrote:
> > > 
> > > > > That just seems wrong.  By the same reasoning, the compiler is within 
> > > > > its rights to transform either the original code or the code using 
> > > > > ACCESS_ONCE into:
> > > > > 
> > > > > 	b = 999;
> > > > > 	if (a)
> > > > > 		b = 9;
> > > > > 	else
> > > > > 		b = 42;
> > > > > 
> > > > > and again, other code would be confused.  The simple fact is that 
> > > > > SMP-safe code is not likely to be produced by a compiler that assumes 
> > > > > everything is single-threaded.
> > > > 
> > > > If you use ACCESS_ONCE(), the compiler is prohibited from inserting
> > > > the "b = 999".
> > > 
> > > What prohibits it?
> > 
> > The compiler cannot move a volatile access across a sequence point, for
> > example, across a statement boundary.
> 
> How does inserting a store to a non-volatile value qualify as moving a
> volatile access?

Assuming that there is no access to "b" prior to the "if", then any
access to or modification of "b" would have to be associated with the
two assignments, which could not precede the volatile (at least as I
understand the sequencing rules).  If there is some use of "b" prior
to the "if", then yes, the "b = 999" might be associated with those
prior accesses.

							Thanx, Paul

