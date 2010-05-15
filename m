Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754022Ab0EOXlb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 May 2010 19:41:31 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:32807 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753830Ab0EOXl2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 May 2010 19:41:28 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Kevin Hilman <khilman@deeprootsystems.com>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 6)
Date: Sat, 15 May 2010 22:14:33 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.34-rc7-rjw; KDE/4.3.5; x86_64; ; )
Cc: Tony Lindgren <tony@atomide.com>, Matthew Garrett <mjg@redhat.com>,
       Alan Stern <stern@rowland.harvard.edu>, Paul Walmsley <paul@pwsan.com>,
       Arve =?iso-8859-1?q?Hj=F8nnev=E5g?= <arve@android.com>,
       "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Tejun Heo <tj@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
       magnus.damm@gmail.com, "Theodore Ts'o" <tytso@mit.edu>,
       mark gross <mgross@linux.intel.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Geoff Smith <geoffx.smith@intel.com>,
       Brian Swetland <swetland@google.com>,
       =?iso-8859-1?q?Beno=EEt_Cousson?= <b-cousson@ti.com>,
       linux-omap@vger.kernel.org, Vitaly Wool <vitalywool@gmail.com>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Liam Girdwood <lrg@slimlogic.co.uk>
References: <alpine.DEB.2.00.1005122118530.7624@utopia.booyaka.com> <201005142350.01222.rjw@sisk.pl> <87k4r69k61.fsf@deeprootsystems.com>
In-Reply-To: <87k4r69k61.fsf@deeprootsystems.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201005152214.33691.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 15 May 2010, Kevin Hilman wrote:
> "Rafael J. Wysocki" <rjw@sisk.pl> writes:
> 
> > On Friday 14 May 2010, Kevin Hilman wrote:
> >> Kevin Hilman <khilman@deeprootsystems.com> writes:
> >> 
> >> > "Rafael J. Wysocki" <rjw@sisk.pl> writes:
> >> >
> >> >> On Thursday 13 May 2010, Tony Lindgren wrote:
> >> >>> * Rafael J. Wysocki <rjw@sisk.pl> [100513 14:16]:
> >> >
> >> > [...]
> >> >
> >> >>>  
> >> >>> > It solves a practical issue that _at_ _the_ _moment_ cannot be solved
> >> >>> > differently, while there's a growing number of out-of-tree drivers depending
> >> >>> > on this framework.  We need those drivers in and because we don't have any
> >> >>> > viable alternative at hand, we have no good reason to reject it.
> >> >>> 
> >> >>> Nothing is preventing merging the drivers can be merged without
> >> >>> these calls.
> >> >>
> >> >> And yet, there _is_ a growing nuber of drivers that don't get merge because
> >> >> of that.  That's _reality_.  Are you going to discuss with facts, or what?
> >> >
> >> > It may be reality, but IMO, "preventing other drivers" isn't a good
> >> > *technical* argument for merging a feature.  It feels like these "for
> >> > the 'good' of the community" arguments are being used to trump the
> >> > technical arguments.  Maybe we need to keep the separate.
> >> 
> >> To continue along the "for the good of the community" path...
> >> 
> >> If it truly is the lack of a suspend blocker API that is preventing
> >> the merge of these out of tree drivers, I second Mark's proposal[1] to
> >> merge a noop version of the API while the technical issues continue to
> >> be discussed.
> >
> > I'm against that, sorry.
> 
> OK, I'll bite... Why?

Because in that case the real feature will always be opposed as "unnecessary"
and never merged.  I very much prefer to decide whether to merge it or reject
it right now.

> >> Then we would see how many drivers get submitted and merged.
> >>
> >> Personally, I suspect that lack of this feature is not the real
> >> obstacle to getting these out-of-tree drivers upstream.  Having this
> >> API upstream will not change the product schedules and corporate
> >> cultures that have prevented code from making its way upstream.
> >
> > But apparently it is considered as a suitable excuse.
> 
> No, it is not a _technical_ excuse.  Just a healthy, experience-based
> dose of skepticism.

I didn't mean that, actually.  What I wanted to say is that people use the
lack of "wakelocks" in the mainline as an excuse not to push their drivers
upstream (which is kind of understandable, because there's a zero benefit to
them from mainlining their code, as they will have to maintain a separate
"Android" version of it anyway).

Sorry for the confusion.

> It was expressed because I find the arguments above for merging
> because it prevents out-of-tree drivers from merging quite
> unconvincing.  This is not just about opportunistic suspend + suspend
> blockers specifically but comes from several years experience in the
> embedded Linux world.

In this particular case, the lack of the mainline's support for opportunistic
suspend (in the form of "wakelocks" to be precise) has been given as a main
obstacle against merging of several drivers at least.

So, let's not just easily generalize, please.

And this is not the only reason to push the opportunistic suspend feature
upstream IMO.

First, I think it is a legitimate approach to power management, whether you
like it or not.  I haven't seen anyone seriously arguing against that yet.

Second, (as said above) there is a number of drivers _already_ depending
on it and that number is only going to grow given the popularity of Android.
They are not mainlined in part because their authors don't see a benefit from
doing so (usually the benefit is that you don't have to maintain your code out
of the tree, because the mainline does it for you to some extent, so if you
need to maintain a separate version yourself, the benefit is zero).

Next, the only thing the Arve's patches do is to give people an _option_ to use
opportunistic suspend if they need it or want it.  It's not mandatory and not
even enabled by default, so I don't really see what the problem is.  Quite on
the contrary, I'd like people to be able to use the mainline on Android systems
without major modifications, because potentially that can increase our tester
base (and developer base too in consequence) and including opportunistic
suspend in the mainline would be a step in that direction.

Finally, it appears to address some issues that at the moment we don't
seriously know how to address in a different way.

Thanks,
Rafael

