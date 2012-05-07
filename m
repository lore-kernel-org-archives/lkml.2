Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932486Ab2EGUyw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 16:54:52 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:51252 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932189Ab2EGUyu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 16:54:50 -0400
Date: Mon, 7 May 2012 13:53:21 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [patch 03/18] fork: Move thread info gfp flags to header
Message-ID: <20120507205321.GC21152@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20120505150007.543515803@linutronix.de>
 <20120505150141.428211694@linutronix.de>
 <20120507043401.GA5406@linux.vnet.ibm.com>
 <alpine.LFD.2.02.1205072112400.6271@ionos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1205072112400.6271@ionos>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12050720-3270-0000-0000-0000062520E5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 07, 2012 at 09:14:04PM +0200, Thomas Gleixner wrote:
> On Sun, 6 May 2012, Paul E. McKenney wrote:
> 
> > On Sat, May 05, 2012 at 03:05:41PM -0000, Thomas Gleixner wrote:
> > > These flags can be useful for extra allocations outside of the core
> > > code.
> > > 
> > > Add __GFP_NOTRACE to them, so the archs which have kmemcheck do
> > > not have to provide extra allocators just for that reason.
> > 
> > This breaks powerpc builds due to __GFP_NOTRACE not being defined.
> > I restarted the test after removing the __GFP_NOTRACE as a testing-only
> > hack, and will let you know how it goes.  Also looking into why this
> > builds on 32-bit x86 but not on powerpc.
> 
> Hrmpf. Seems the idiot I am fatfingered __GFP_NOTRACK to __GFP_NOTRACE
> and then only tested with the DEBUG stuff disabled......

That sounds like something I would do...  ;-)

I will rerun with __GFP_NOTRACK.

							Thanx, Paul

