Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755237Ab2AODg4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jan 2012 22:36:56 -0500
Received: from netrider.rowland.org ([192.131.102.5]:46257 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753517Ab2AODgy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jan 2012 22:36:54 -0500
Date: Sat, 14 Jan 2012 22:36:53 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Greg KH <gregkh@suse.de>
cc: Tony Luck <tony.luck@intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Ming Lei <tom.leiming@gmail.com>, Djalal Harouni <tixxdz@opendz.org>,
        Borislav Petkov <borislav.petkov@amd.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Ingo Molnar <mingo@elte.hu>, Andi Kleen <ak@linux.intel.com>,
        <linux-kernel@vger.kernel.org>, Kay Sievers <kay.sievers@vrfy.org>,
        <gouders@et.bocholt.fh-gelsenkirchen.de>,
        Marcos Souza <marcos.mage@gmail.com>,
        Linux PM mailing list <linux-pm@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        "tglx@linutronix.de" <tglx@linutronix.de>, <prasad@linux.vnet.ibm.com>,
        <justinmattock@gmail.com>, Jeff Chua <jeff.chua.linux@gmail.com>,
        Suresh B Siddha <suresh.b.siddha@intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Mel Gorman <mgorman@suse.de>,
        Gilad Ben-Yossef <gilad@benyossef.com>
Subject: Re: x86/mce: machine check warning during poweroff
In-Reply-To: <20120115023404.GA4268@suse.de>
Message-ID: <Pine.LNX.4.44L0.1201142233400.14635-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 14 Jan 2012, Greg KH wrote:

> On Sat, Jan 14, 2012 at 06:05:24PM -0800, Tony Luck wrote:
> > On Sat, Jan 14, 2012 at 8:30 AM, Alan Stern <stern@rowland.harvard.edu> wrote:
> > > The driver core isn't designed to handle device structures that get
> > > unregistered and then spring back to life; callers are supposed to
> > > allocate a fresh new structure instead.
> > 
> > Does every caller use "kzalloc()" for this fresh new structure (or even
> > for the original registration) rather than "kmalloc()"?
> 
> They better, as that's what they are required to do :)
> 
> The kernel would be crashing with slab debugging enabled, if it wasn't
> so today.

These are both important restrictions on the use of the driver core,
and they don't seem to be explained anywhere in the kernel source.  
Would you like to receive a documentation patch?

Alan Stern

