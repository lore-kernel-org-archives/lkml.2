Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932468Ab0EMWpl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 18:45:41 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:54937 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750785Ab0EMWpi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 18:45:38 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 6)
Date: Fri, 14 May 2010 00:46:33 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.34-rc7-rjw; KDE/4.3.5; x86_64; ; )
Cc: Greg KH <gregkh@suse.de>, Daniel Walker <dwalker@fifo99.com>,
       Matthew Garrett <mjg@redhat.com>, Brian Swetland <swetland@google.com>,
       Paul Walmsley <paul@pwsan.com>,
       Arve =?iso-8859-1?q?Hj=F8nnev=E5g?= <arve@android.com>,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Tejun Heo <tj@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
       Tony Lindgren <tony@atomide.com>,
       Kevin Hilman <khilman@deeprootsystems.com>,
       Alan Stern <stern@rowland.harvard.edu>, magnus.damm@gmail.com,
       "Theodore Ts'o" <tytso@mit.edu>, mark gross <mgross@linux.intel.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Geoff Smith <geoffx.smith@intel.com>,
       =?iso-8859-1?q?Beno=EEt_Cousson?= <b-cousson@ti.com>,
       linux-omap@vger.kernel.org, Vitaly Wool <vitalywool@gmail.com>,
       Liam Girdwood <lrg@slimlogic.co.uk>
References: <1272667021-21312-1-git-send-email-arve@android.com> <20100513214653.GA21120@suse.de> <20100513222748.GA3240@opensource.wolfsonmicro.com>
In-Reply-To: <20100513222748.GA3240@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201005140046.33508.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 14 May 2010, Mark Brown wrote:
> On Thu, May 13, 2010 at 02:46:53PM -0700, Greg KH wrote:
> > On Thu, May 13, 2010 at 02:33:29PM -0700, Daniel Walker wrote:
> 
> > > You get the driver mainlined, then maintain a small patch to add
> > > wakelocks. Not hard at all , with lots of incentive to do so since you
> > > don't have to maintain such a large block of code out of tree.
> 
> > Sorry, but it doesn't seem to work that way.  Look at the large number
> > of out-of-tree android device drivers that remain sitting there because
> > of the lack of this interface being in the kernel.
> 
> Is that really the issue?  The ones I've looked at have mostly suffered
> from being built on 2.6.29 and needing refreshes for current kernel APIs
> or from general code quality issues - I don't recall ever looking at one
> and thinking that the wakelocks were the one issue.
> 
> > Also note that such a driver, without wakelocks, would never get tested,
> > and so, things start quickly diverging.
> 
> Chances are that if the driver is useful people will start using it in
> non-Android systems anyway.

You're missing the point IMO.  Even if they are only used on Android, there
still is a problem if they don't go into the mainline, because that leads to
code divergence that's growing over time and will ultimately create an entire
ecosystem that's independent of the mainline.

We've been successful in avoiding that for quite some time and I don't think
we should allow that to happen right now because of the opportunistic suspend
feature.

I'm not a big fan of suspend blockers myself, but let's face it, _currently_
there's no alternative and we need to stop the trend, the sooner the better.

> As people have already observed wakelocks
> needn't have any practical effect on the running system so if the
> drivers are broken without wakelocks they'd be broken anyway.  

You need to prove the reverse, ie. that a driver working correctly with
wakelocks will also work correctly without them, which is not a given.

> If this really is a big concern with getting drivers into mainline then
> surely we could just add some noop wakelock functions for the drivers to
> call?

Well, I don't see a big difference between that and adding the feature
depending on a .config option.  Really.

> It's not particularly pretty but it'd deal with the driver merge
> side of things.

Again, I don't see why you hate that feature so much.  What is there to worry
about?

Rafael
