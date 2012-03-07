Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965338Ab2CGWlc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 17:41:32 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:34492 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030758Ab2CGWlD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 17:41:03 -0500
Message-ID: <1331160054.2191.202.camel@work-vm>
Subject: Re: [PATCH 11/13] android: persistent_trace: ftrace into
 persistent_ram
From: John Stultz <john.stultz@linaro.org>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: lkml <linux-kernel@vger.kernel.org>, Colin Cross <ccross@android.com>,
        Android Kernel Team <kernel-team@android.com>, tony.luck@intel.com
Date: Wed, 07 Mar 2012 14:40:54 -0800
In-Reply-To: <20120307221002.GC16652@kroah.com>
References: <1331157503-3413-1-git-send-email-john.stultz@linaro.org>
	 <1331157503-3413-12-git-send-email-john.stultz@linaro.org>
	 <20120307221002.GC16652@kroah.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12030722-9360-0000-0000-0000045631A2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-03-07 at 14:10 -0800, Greg KH wrote:
> On Wed, Mar 07, 2012 at 01:58:21PM -0800, John Stultz wrote:
> > From: Colin Cross <ccross@android.com>
> > 
> > persistent_trace uses the ftrace infrastructure, but traces
> > into a persistent_ram buffer instead of the regular ftrace
> > ringbuffer.  After a reset or panic, the trace can be
> > decoded with cat /sys/kernel/debug/persistent_trace.
> 
> Has this patch been run by the tracing kernel developers?

Probably not. If you'd prefer, we can drop this one and come back to it
later.

> And what's the status on merging the persistent_ram stuff in with the
> in-kernel api for this type of thing?  That should then get rid of this
> separate tracing module, or at the least, let it be accepted directly by
> the tracing developers and not need to go through staging, right?

>From my understanding, ram_console/persistent_ram functionality isn't
really the same as pstore/ramoops.

When asked earlier about this, Colin said:
"pstore is just an interface to write to a persistent storage, with a
tiny driver on it to dump console messages after a panic.  With the
number of crashes we see on ARM cpus that are not panics (mostly
watchdog resets), logging only after a panic is not appropriate, so it
can't replace ramconsole.  persistent_ram could easily be a pstore
driver, but that would not give any new useful functionality, since
ramconsole is better for us than pstore_dump.

Looking at ramoops, it is exactly the same as pstore on ioremapped
ram, but was originally implemented separately.  I see patches now
that convert it to a pstore backend, which leaves us in the same state
as above - only logging panics."

As for the long term merging story, I think Colin's idea of using
persistent_ram a backing for pstore, then adapting pstore as needed to
provide similar continuous console logging like ram_console might be a
way forward, but I don't know of anyone actively working on that atm.

Tony: Do you have any thoughts here?

thanks
-john


