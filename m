Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757714Ab0EETUn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 15:20:43 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:34369 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753457Ab0EETUk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 15:20:40 -0400
Date: Wed, 5 May 2010 15:20:40 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
cc: Matthew Garrett <mjg@redhat.com>, Brian Swetland <swetland@google.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Kevin Hilman <khilman@deeprootsystems.com>,
       Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
       <linux-pm@lists.linux-foundation.org>, <linux-kernel@vger.kernel.org>,
       Tejun Heo <tj@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
       Paul Walmsley <paul@pwsan.com>, <magnus.damm@gmail.com>,
       mark gross <mgross@linux.intel.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Geoff Smith <geoffx.smith@intel.com>
Subject: Re: [PATCH 0/8] Suspend block api (version 6)
In-Reply-To: <20100505190758.GG7139@rakim.wolfsonmicro.main>
Message-ID: <Pine.LNX.4.44L0.1005051515060.1885-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 5 May 2010, Mark Brown wrote:

> > In short, I'm trying to get at how much information drivers _really_ 
> > need to have about the reason for a system suspend.
> 
> It's not exactly the *reason* that makes the difference, it's more that
> this aggressive use of suspend makes much more apparent a problem which
> might exist anyway for this sort of hardware.

Then the underlying problem should be solved -- hopefully in a nice, 
system-independent way.  But I'm still trying to understand exactly 
what that underlying problem _is_.

That means understanding when the codec needs to be shut down and when
it doesn't, and knowing how much of this information is available to
the driver.

> When we get runtime PM delviering similar power levels we'll sidestep
> the problem since we won't need to do a system wide suspend.

One the face of it, a runtime-PM solution would dictate that the
codec's driver ought to turn off the codec whenever the driver thinks
it isn't being used.  Ergo, if the driver didn't know when a call was
in progress, it would use runtime PM to turn off the codec during a
call.

For this reason I don't see how using runtime PM instead of suspend
blockers would solve anything.

Alan Stern

