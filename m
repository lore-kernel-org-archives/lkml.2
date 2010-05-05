Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755751Ab0EESwx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 14:52:53 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:41926 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751773Ab0EESww (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 14:52:52 -0400
Date: Wed, 5 May 2010 19:52:25 +0100
From: Matthew Garrett <mjg@redhat.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Brian Swetland <swetland@google.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Kevin Hilman <khilman@deeprootsystems.com>,
       Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Tejun Heo <tj@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
       Paul Walmsley <paul@pwsan.com>, magnus.damm@gmail.com,
       mark gross <mgross@linux.intel.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Geoff Smith <geoffx.smith@intel.com>, rebecca@android.com
Subject: Re: [PATCH 0/8] Suspend block api (version 6)
Message-ID: <20100505185225.GA4411@srcf.ucam.org>
References: <20100505173337.GA1671@srcf.ucam.org> <Pine.LNX.4.44L0.1005051432120.1885-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1005051432120.1885-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 05, 2010 at 02:36:10PM -0400, Alan Stern wrote:

> This particular question could use a little more discussion.  I'm
> interested to know, for example, under what conditions you would or
> would not want to shut down an autonomous codec while going into system 
> suspend on a cell phone.
> 
> Clearly if there's a call in progress you don't want to shut the codec
> down.  Are there any other circumstances?  Would they vary according to
> whether the suspend was forced or opportunistic?

Yeah, ok. We probably do need to figure this out.

(Cc:ing Rebecca to see how this got handled on Droid)

The current state of affairs is that a system suspend request is 
expected to put the device in as low a power state as possible given the 
required wakeup events. Runtime power management is expected to put the 
device in as low a power state as possible given its usage constraints. 
If opportunistic suspend does the former then it'll tear down devices 
that may be in use, but we don't have any real way to indicate usage 
constraints other than the phone app taking a wakelock - and that means 
leaving userspace running during calls, which seems excessive.

Mark's right in that the only case I can think of that's really relevant 
right now is the audio hardware, so the inelegant solution is that this 
is something that could be provided at the audio level. Is this 
something we want a generic solution for? If so, what should it look 
like?

-- 
Matthew Garrett | mjg59@srcf.ucam.org
