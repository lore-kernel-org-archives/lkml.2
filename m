Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754463Ab0KTQvl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Nov 2010 11:51:41 -0500
Received: from netrider.rowland.org ([192.131.102.5]:53214 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753844Ab0KTQvk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Nov 2010 11:51:40 -0500
Date: Sat, 20 Nov 2010 11:51:39 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Ben Hutchings <ben@decadent.org.uk>
cc: linux-kernel@vger.kernel.org, <stable@kernel.org>,
        David Brownell <david-b@pacbell.net>, <akpm@linux-foundation.org>,
        <torvalds@linux-foundation.org>, <stable-review@kernel.org>,
        <alan@lxorguk.ukuu.org.uk>, Greg KH <gregkh@suse.de>
Subject: Re: [Stable-review] [39/45] OHCI: work around for nVidia shutdown
 problem
In-Reply-To: <1290221557.3818.117.camel@localhost>
Message-ID: <Pine.LNX.4.44L0.1011201139540.5871-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 20 Nov 2010, Ben Hutchings wrote:

> On Fri, 2010-11-19 at 13:43 -0800, Greg KH wrote:
> > 2.6.32-stable review patch.  If anyone has any objections, please let us know.
> > 
> > ------------------
> > 
> > From: Alan Stern <stern@rowland.harvard.edu>
> > 
> > commit 3df7169e73fc1d71a39cffeacc969f6840cdf52b upstream.
> > 
> > This patch (as1417) fixes a problem affecting some (or all) nVidia
> > chipsets.  When the computer is shut down, the OHCI controllers
> > continue to power the USB buses and evidently they drive a Reset
> > signal out all their ports.  This prevents attached devices from going
> > to low power.  Mouse LEDs stay on, for example, which is disconcerting
> > for users and a drain on laptop batteries.
> > 
> > The fix involves leaving each OHCI controller in the OPERATIONAL state
> > during system shutdown rather than putting it in the RESET state.
> > Although this nominally means the controller is running, in fact it's
> > not doing very much since all the schedules are all disabled.  However
> > there is ongoing DMA to the Host Controller Communications Area, so
> > the patch also disables the bus-master capability of all PCI USB
> > controllers after the shutdown routine runs.
> [...]
> 
> This last bit seems like a major change in behaviour, and this commit
> has only just gone into the 2.6.37 cycle.  How thoroughly has this been
> tested on other OHCI controllers?  Wouldn't it make more sense to use
> the same quirk condition?

Ben is right; let's hold off on putting this patch into any of the 
stable kernels.  There has been a bug report submitted against it, 
Bugzilla #22562.

Alan Stern

