Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757235Ab0EEUEL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 16:04:11 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:51086 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752062Ab0EEUED (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 16:04:03 -0400
Date: Wed, 5 May 2010 16:04:00 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Matthew Garrett <mjg@redhat.com>
cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Brian Swetland <swetland@google.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Kevin Hilman <khilman@deeprootsystems.com>,
       Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
       <linux-pm@lists.linux-foundation.org>, <linux-kernel@vger.kernel.org>,
       Tejun Heo <tj@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
       Paul Walmsley <paul@pwsan.com>, <magnus.damm@gmail.com>,
       mark gross <mgross@linux.intel.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Geoff Smith <geoffx.smith@intel.com>
Subject: Re: [PATCH 0/8] Suspend block api (version 6)
In-Reply-To: <20100505192811.GA5468@srcf.ucam.org>
Message-ID: <Pine.LNX.4.44L0.1005051554490.1885-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 5 May 2010, Matthew Garrett wrote:

> On Wed, May 05, 2010 at 03:20:40PM -0400, Alan Stern wrote:
> 
> > One the face of it, a runtime-PM solution would dictate that the
> > codec's driver ought to turn off the codec whenever the driver thinks
> > it isn't being used.  Ergo, if the driver didn't know when a call was
> > in progress, it would use runtime PM to turn off the codec during a
> > call.
> 
> Well, part of the problem is that right now most of our beliefs about 
> imposed constraints tend to be based on what userspace is doing - "Don't 
> power down the audio codec when userspace has it open", for instance. 
> But that goes away with opportunistic suspend. In most cases you don't 
> want the audio codec to stay awake just because userspace was using it 
> to make bouncing cow noises, especially if you've just frozen userspace. 
> So the problem becomes more complicated than it would otherwise be.

It sounds like the problem can be stated simply enough: At the moment, 
nobody knows when the codec should be powered down!  Userspace might 
have some idea, but even if its ideas are right it has no way of 
communicating them to the kernel.

The power/control sysfs attribute was intended for just that purpose,
although it was aimed at runtime PM rather than system PM.  
Nevertheless, it or something like it could be used.  Of course, there 
would still remain the issue of userspace telling the kernel not to 
power down the codec while making bouncing cow noises -- but at this 
point it's not really a kernel problem any more.

Alan Stern

P.S.: What happens if a suspend occurs while a call is in progress, so
the codec is left powered up, and then the call ends?  Does the system
wake up at that point?  Or does it stay suspended with the codec still
powered, even though it's not needed any more?

