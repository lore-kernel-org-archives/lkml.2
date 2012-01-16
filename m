Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755860Ab2APSUw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 13:20:52 -0500
Received: from cantor2.suse.de ([195.135.220.15]:40981 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755780Ab2APSUv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 13:20:51 -0500
Date: Mon, 16 Jan 2012 10:15:36 -0800
From: Greg KH <gregkh@suse.de>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Tony Luck <tony.luck@intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Ming Lei <tom.leiming@gmail.com>, Djalal Harouni <tixxdz@opendz.org>,
        Borislav Petkov <borislav.petkov@amd.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Ingo Molnar <mingo@elte.hu>, Andi Kleen <ak@linux.intel.com>,
        linux-kernel@vger.kernel.org, Kay Sievers <kay.sievers@vrfy.org>,
        gouders@et.bocholt.fh-gelsenkirchen.de,
        Marcos Souza <marcos.mage@gmail.com>,
        Linux PM mailing list <linux-pm@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        "tglx@linutronix.de" <tglx@linutronix.de>, prasad@linux.vnet.ibm.com,
        justinmattock@gmail.com, Jeff Chua <jeff.chua.linux@gmail.com>,
        Suresh B Siddha <suresh.b.siddha@intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Mel Gorman <mgorman@suse.de>,
        Gilad Ben-Yossef <gilad@benyossef.com>
Subject: Re: x86/mce: machine check warning during poweroff
Message-ID: <20120116181536.GB23628@suse.de>
References: <20120115023404.GA4268@suse.de>
 <Pine.LNX.4.44L0.1201142233400.14635-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1201142233400.14635-100000@netrider.rowland.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 14, 2012 at 10:36:53PM -0500, Alan Stern wrote:
> On Sat, 14 Jan 2012, Greg KH wrote:
> 
> > On Sat, Jan 14, 2012 at 06:05:24PM -0800, Tony Luck wrote:
> > > On Sat, Jan 14, 2012 at 8:30 AM, Alan Stern <stern@rowland.harvard.edu> wrote:
> > > > The driver core isn't designed to handle device structures that get
> > > > unregistered and then spring back to life; callers are supposed to
> > > > allocate a fresh new structure instead.
> > > 
> > > Does every caller use "kzalloc()" for this fresh new structure (or even
> > > for the original registration) rather than "kmalloc()"?
> > 
> > They better, as that's what they are required to do :)
> > 
> > The kernel would be crashing with slab debugging enabled, if it wasn't
> > so today.
> 
> These are both important restrictions on the use of the driver core,
> and they don't seem to be explained anywhere in the kernel source.  
> Would you like to receive a documentation patch?

For some reason I thought it was documented somewhere, but I can't seem
to find that right now.  So yes, a patch documenting it would be great
to have.

thanks,

greg k-h
