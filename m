Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759586Ab0EMW1y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 18:27:54 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:38016 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753228Ab0EMW1w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 18:27:52 -0400
Date: Thu, 13 May 2010 23:27:49 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Greg KH <gregkh@suse.de>
Cc: Daniel Walker <dwalker@fifo99.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Matthew Garrett <mjg@redhat.com>, Brian Swetland <swetland@google.com>,
       Paul Walmsley <paul@pwsan.com>,
       Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Tejun Heo <tj@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
       Tony Lindgren <tony@atomide.com>,
       Kevin Hilman <khilman@deeprootsystems.com>,
       Alan Stern <stern@rowland.harvard.edu>, magnus.damm@gmail.com,
       "Theodore Ts'o" <tytso@mit.edu>, mark gross <mgross@linux.intel.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Geoff Smith <geoffx.smith@intel.com>,
       =?iso-8859-1?Q?Beno=EEt?= Cousson <b-cousson@ti.com>,
       linux-omap@vger.kernel.org, Vitaly Wool <vitalywool@gmail.com>,
       Liam Girdwood <lrg@slimlogic.co.uk>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 6)
Message-ID: <20100513222748.GA3240@opensource.wolfsonmicro.com>
References: <1272667021-21312-1-git-send-email-arve@android.com> <201005132311.26293.rjw@sisk.pl> <1273785399.19100.98.camel@c-dwalke-linux.qualcomm.com> <201005132327.16163.rjw@sisk.pl> <1273786409.19100.104.camel@c-dwalke-linux.qualcomm.com> <20100513214653.GA21120@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100513214653.GA21120@suse.de>
X-Cookie: You'll be sorry...
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 13, 2010 at 02:46:53PM -0700, Greg KH wrote:
> On Thu, May 13, 2010 at 02:33:29PM -0700, Daniel Walker wrote:

> > You get the driver mainlined, then maintain a small patch to add
> > wakelocks. Not hard at all , with lots of incentive to do so since you
> > don't have to maintain such a large block of code out of tree.

> Sorry, but it doesn't seem to work that way.  Look at the large number
> of out-of-tree android device drivers that remain sitting there because
> of the lack of this interface being in the kernel.

Is that really the issue?  The ones I've looked at have mostly suffered
from being built on 2.6.29 and needing refreshes for current kernel APIs
or from general code quality issues - I don't recall ever looking at one
and thinking that the wakelocks were the one issue.

> Also note that such a driver, without wakelocks, would never get tested,
> and so, things start quickly diverging.

Chances are that if the driver is useful people will start using it in
non-Android systems anyway.  As people have already observed wakelocks
needn't have any practical effect on the running system so if the
drivers are broken without wakelocks they'd be broken anyway.  

If this really is a big concern with getting drivers into mainline then
surely we could just add some noop wakelock functions for the drivers to
call?  It's not particularly pretty but it'd deal with the driver merge
side of things.
