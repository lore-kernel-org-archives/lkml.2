Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753957Ab2BRVup (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Feb 2012 16:50:45 -0500
Received: from cantor2.suse.de ([195.135.220.15]:54103 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753812Ab2BRVun (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Feb 2012 16:50:43 -0500
Date: Sat, 18 Feb 2012 22:50:33 +0100
From: Holger Macht <holger@homac.de>
To: Hugh Dickins <hughd@google.com>
Cc: Hillf Danton <dhillf@gmail.com>, Matthew Garrett <mjg@redhat.com>,
        Jeff Garzik <jgarzik@redhat.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: linux-next: dock_link_device is oopsy
Message-ID: <20120218215031.GA9925@homac.suse.de>
References: <20120217230107.GA12929@homac.suse.de>
 <alpine.LSU.2.00.1202171541040.3155@eggly.anvils>
 <20120218111419.GA2488@homac.suse.de>
 <CAJd=RBDRZSizawvRYqr7=U75Su5TLvMfgdagRA49wzJr40DqSg@mail.gmail.com>
 <20120218132610.GA15265@homac.suse.de>
 <CAJd=RBAhnsuP4+pRS=MLyOaqx8O1gOR30bcoZC0Owabh1-1nzA@mail.gmail.com>
 <20120218140449.GA2558@homac.suse.de>
 <alpine.LSU.2.00.1202181034380.3512@eggly.anvils>
 <20120218195722.GA2590@homac.suse.de>
 <alpine.LSU.2.00.1202181251200.4819@eggly.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.00.1202181251200.4819@eggly.anvils>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sa 18. Feb - 13:03:34, Hugh Dickins wrote:
> On Sat, 18 Feb 2012, Holger Macht wrote:
> > On Sa 18. Feb - 10:46:04, Hugh Dickins wrote:
> > > On Sat, 18 Feb 2012, Holger Macht wrote:
> > > > How about that one?
> > > 
> > > It's more broken than that.  Here's my attempt.  It boots on the
> > > systems with dock_station_count 0, and it boots on my laptop with
> > > dock_station_count 2; but I don't actually have any docking station,
> > > so it still doesn't test very much (dock is 0 after the loop).
> > 
> > Well, there doesn't have to actually exist a physical dock station (or
> > bay device) for dock_station_count to be > 0. It just tells that the
> > ACPI objects are present and thus the system is capable of it.
> > 
> > So does this function actually also break on your laptop and you're
> > getting the oops there, too?
> 
> It oopsed on the 4-year-old Fujitsu-Siemens laptop whose dock_station_count
> was 0.  It did not oops on the new ThinkPad laptop whose dock_station_count
> is 2, but no docks were found: so the function would only have been leaking
> memory on that.

It should actually have successfully linked the dock to the device, if
for instance you had a device in your bay. At least this is working fine
with two Thinkpads I tested with. That's why I didn't encounter this
problem at all before resubmitting the corresponding patch set.

> If docks were found, then I suspect it could have been scribbling, but I
> cannot actually check if that's true (for all I know, dock_station_count
> may be always 1 bigger than the most that that double loop can discover);
> but at least the loop is now made safe against scribbling.

It was actually working fine multiple times, out of pure luck it seems.

Regards,
 Holger
