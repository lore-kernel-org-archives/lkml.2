Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755503Ab2FFPox (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 11:44:53 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:51277 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752178Ab2FFPov (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 11:44:51 -0400
Date: Wed, 6 Jun 2012 11:44:50 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
cc: Ming Lei <ming.lei@canonical.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        USB list <linux-usb@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] driver core: fix shutdown races with probe/remove
In-Reply-To: <20120606151448.GJ19601@linux.vnet.ibm.com>
Message-ID: <Pine.LNX.4.44L0.1206061143170.1788-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 Jun 2012, Paul E. McKenney wrote:

> > That just seems wrong.  By the same reasoning, the compiler is within 
> > its rights to transform either the original code or the code using 
> > ACCESS_ONCE into:
> > 
> > 	b = 999;
> > 	if (a)
> > 		b = 9;
> > 	else
> > 		b = 42;
> > 
> > and again, other code would be confused.  The simple fact is that 
> > SMP-safe code is not likely to be produced by a compiler that assumes 
> > everything is single-threaded.
> 
> If you use ACCESS_ONCE(), the compiler is prohibited from inserting
> the "b = 999".

What prohibits it?

>  If you don't use ACCESS_ONCE(), the compiler really
> is permitted to insert the "b = 999".  So, why would the compiler do
> such a thing?  One possible reason would be from optimizations using
> large registers to hold multiple values.  A store from such a register
> could clobber unrelated variables, but as long as the compiler fixes
> up the clobbering after the fact, it is within its rights to do so.
> 
> The sad fact is that the C standard really does permit the compiler
> to assume that it is generating sequential code.

Compiling the kernel requires quite a few extensions to the C standard.  
Assumptions about generating sequential code may well be among them.

Alan Stern

