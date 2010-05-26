Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756100Ab0EZWDP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 18:03:15 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:44714 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752831Ab0EZWDN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 18:03:13 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [PATCH 1/8] PM: Opportunistic suspend support.
Date: Thu, 27 May 2010 00:03:58 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.34-tst; KDE/4.3.5; x86_64; ; )
Cc: Peter Zijlstra <peterz@infradead.org>,
       Arve =?iso-8859-1?q?Hj=F8nnev=E5g?= <arve@android.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
       Randy Dunlap <rdunlap@xenotime.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <ak@linux.intel.com>,
       Cornelia Huck <cornelia.huck@de.ibm.com>, Tejun Heo <tj@kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Nigel Cunningham <nigel@tuxonice.net>, Ming Lei <tom.leiming@gmail.com>,
       Wu Fengguang <fengguang.wu@intel.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>, linux-doc@vger.kernel.org,
       Greg KH <gregkh@suse.de>, tytso@mit.edu,
       James Bottomley <James.Bottomley@suse.de>
References: <Pine.LNX.4.44L0.1005251647530.1634-100000@iolanthe.rowland.org> <1274878665.27810.354.camel@twins> <20100526132051.GA1834@srcf.ucam.org>
In-Reply-To: <20100526132051.GA1834@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201005270003.58277.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 26 May 2010, Matthew Garrett wrote:
> On Wed, May 26, 2010 at 02:57:45PM +0200, Peter Zijlstra wrote:
> 
> > I fail to see why. In both cases the woken userspace will contact a
> > central governing task, either the kernel or the userspace suspend
> > manager, and inform it there is work to be done, and please don't
> > suspend now.
> 
> Thinking about this, you're right - we don't have to wait, but that does 
> result in another problem. Imagine we get two wakeup events 
> approximately simultaneously. In the kernel-level universe the kernel 
> knows when both have been handled. In the user-level universe, we may 
> have one task schedule, bump the count, handle the event, drop the count 
> and then we attempt a suspend again because the second event handler 
> hasn't had an opportunity to run yet. We'll then attempt a suspend and 
> immediately bounce back up. That's kind of wasteful, although it'd be 
> somewhat mitigated by checking that right at the top of suspend entry 
> and returning -EAGAIN or similar.

I still think it would cause a loop-alike behavior between the user space
power manager and the kernel PM core to happen, because the power manager
will always have to check the user space counter after a failing suspend
attempt.

Rafael
