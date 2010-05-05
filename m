Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757888Ab0EETNz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 15:13:55 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:58128 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752834Ab0EETNx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 15:13:53 -0400
Date: Wed, 5 May 2010 15:13:52 -0400 (EDT)
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
       Geoff Smith <geoffx.smith@intel.com>, <rebecca@android.com>
Subject: Re: [PATCH 0/8] Suspend block api (version 6)
In-Reply-To: <20100505185225.GA4411@srcf.ucam.org>
Message-ID: <Pine.LNX.4.44L0.1005051511040.1885-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 5 May 2010, Matthew Garrett wrote:

> > Clearly if there's a call in progress you don't want to shut the codec
> > down.  Are there any other circumstances?  Would they vary according to
> > whether the suspend was forced or opportunistic?
> 
> Yeah, ok. We probably do need to figure this out.
> 
> (Cc:ing Rebecca to see how this got handled on Droid)
> 
> The current state of affairs is that a system suspend request is 
> expected to put the device in as low a power state as possible given the 
> required wakeup events. Runtime power management is expected to put the 
> device in as low a power state as possible given its usage constraints. 
> If opportunistic suspend does the former then it'll tear down devices 
> that may be in use, but we don't have any real way to indicate usage 
> constraints other than the phone app taking a wakelock - and that means 
> leaving userspace running during calls, which seems excessive.
> 
> Mark's right in that the only case I can think of that's really relevant 
> right now is the audio hardware, so the inelegant solution is that this 
> is something that could be provided at the audio level. Is this 
> something we want a generic solution for? If so, what should it look 
> like?

Should the audio driver be smart enough to know that the codec needs to
remain powered up during every opportunistic suspend?

Or only during opportunistic suspends while a call is in progress?  

Does it know when a call is in progress?

Does Android use forced suspends?

If it does, are they supposed to shut down the codec?

Alan Stern

