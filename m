Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759540Ab0E0S4w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 14:56:52 -0400
Received: from www.tglx.de ([62.245.132.106]:40443 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756891Ab0E0S4v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 14:56:51 -0400
Date: Thu, 27 May 2010 20:55:51 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Matthew Garrett <mjg59@srcf.ucam.org>
cc: Peter Zijlstra <peterz@infradead.org>,
       Alan Stern <stern@rowland.harvard.edu>, Paul@smtp1.linux-foundation.org,
       LKML <linux-kernel@vger.kernel.org>,
       Florian Mickler <florian@mickler.org>, felipe.balbi@nokia.com,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
In-Reply-To: <20100527182913.GO3543@srcf.ucam.org>
Message-ID: <alpine.LFD.2.00.1005272054070.3032@localhost.localdomain>
References: <Pine.LNX.4.44L0.1005271344040.3239-100000@iolanthe.rowland.org> <1274982779.27810.5708.camel@twins> <20100527175719.GD3543@srcf.ucam.org> <1274983333.27810.5744.camel@twins> <20100527181433.GG3543@srcf.ucam.org> <1274984291.27810.5802.camel@twins>
 <20100527182913.GO3543@srcf.ucam.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 May 2010, Matthew Garrett wrote:

> On Thu, May 27, 2010 at 08:18:11PM +0200, Peter Zijlstra wrote:
> > On Thu, 2010-05-27 at 19:14 +0100, Matthew Garrett wrote:
> > > If I get a WoL 
> > > packet in the 0.5 of a second between userspace deciding to suspend and 
> > > actually doing so, the system shouldn't suspend. 
> > 
> > Please re-read Thomas' description of how a driver should do the state
> > transition.
> >
> > So either we get the packet before suspend, and we cancel the suspend,
> > or we get it after and we wake up. What's the problem, and how does that
> > need suspend blockers?
> 
> In order to cancel the suspend we need to keep track of whether 
> userspace has consumed the event and reacted appropriately. Since we 
> can't do this with the process scheduler, we end up with something that 
> looks like suspend blockers.

And the scheduler based approach does exactly this and provides
exactly the same non guarantees to applications which are set to
QoS(NONE) as it does to applications which do not (or are not allowed
to) use the user space suspend blockers.

Thanks,

	tglx
