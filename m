Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751291Ab0KDMsR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 08:48:17 -0400
Received: from mga11.intel.com ([192.55.52.93]:12868 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751157Ab0KDMsN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 08:48:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.58,295,1286175600"; 
   d="scan'208";a="623484485"
From: "Luck, Tony" <tony.luck@intel.com>
To: Tejun Heo <tj@kernel.org>, Oren Laadan <orenl@cs.columbia.edu>
CC: "ksummit-2010-discuss@lists.linux-foundation.org" 
	<ksummit-2010-discuss@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 4 Nov 2010 05:48:10 -0700
Subject: RE: [Ksummit-2010-discuss] checkpoint-restart: naked patch
Thread-Topic: [Ksummit-2010-discuss] checkpoint-restart: naked patch
Thread-Index: Act8BPOebk9S/wFaRWqoFhoq1zZ2jwAFpMsg
Message-ID: <987664A83D2D224EAE907B061CE93D53016480D1DE@orsmsx505.amr.corp.intel.com>
References: <Pine.LNX.4.64.1011021530470.12128@takamine.ncl.cs.columbia.edu>
	<4CD08419.5050803@kernel.org> <4CD23087.30900@cs.columbia.edu>
 <4CD28033.1000700@kernel.org>
In-Reply-To: <4CD28033.1000700@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> If you think only about target processes, yeah sure, you can cover
> most of the stuff but that's not the impossible part.  What's not
> defined is interaction with the rest of the system and userland.
> Userland ecosystem is crazy complex.  You simply cannot stop, say,
> banshee or even pidgin, let it mingle with the rest of the system and
> restore it later in any safe way.

This is why I think it is important to define the limits of
which kernel state features are covered (or going to be
covered) by checkpoint/restart - and then list applications
that are supported (Oren mentioned mysql server in this thread).
It will always be easy for someone to point at some application
like powertop and say "we can't migrate that, so checkpoint
restart is therefore useless" ... this just is not true. This
can be useful without having to be complete (as long as the
limits are well defined).

> I'm afraid I can't agree with that.  You can store and restore the
> states which kernel is aware of but that's a very small fraction of
> the whole picture.

See above - it may be enough to cover a significant number of
useful cases.

> Sure, you can freeze whole tree of related processes and move them
> around, but if you think about it, it's an already broken scenario.
> For example, dbus (or rather agents listening to it) doesn't only
> carry states specific to the set of applications being snapshotted.
> It also carries whole bunch of system-wide states or states for other
> applications.  As soon as the system goes on executing after
> checkpointing, the checkpointed image of dbus and its agents become
> inconsistent and useless.  You can't restore it later.  You don't know
> what happened to other parts of the system inbetween.

Okay - so "dbus" is in the list of "can't so that no, and will
never be able to checkpoint/restore that class" - big deal. I'm
getting repetitive no, but one last time: just because this can't
handle every conceivable case doesn't make it useless.

> I'm afraid that's not general or transparent at all.  It's extremely
> invasive to how a system is setup and used.  It basically is poor
> man's virtualization or rather partitioning without hardware support
> and at this point I find it very difficult to justify the added
> complexity.  Let's just make virtualization better.

I don't think that you'll ever make virtualization good enough
to make the HPC people happy.

>> I know of several places that do not use C/R because they can't
>> stop their long running processes for longer than a few milliseconds.
>> I know how to solve their problems with linux-cr. I doubt if any
>> userspace mechanism can get there.
>
> I'm sure there will be some benefits to in-kernel implementation but
> the added complexity is crazy in comparison.  I don't think it would
> be wise to include this invasive amount of code for several places
> which can't CR because they can't afford a few millisecs.

The CR cool-aid hasn't gotten so far into my system to accept
this claim.  If these "can't stop for more than a few milli-seconds"
processes are HPC workloads, then I'm not seeing how you can do
much to help them.  I think these applications are using almost
all of the RAM on the system, and most of the pages are anonymous.
Just how do you checkpoint several GB of dirty pages in a few
milli-seconds (when there is almost no free memory on the system)?

If you have something else in mind, then please explain a little more.

-Tony
