Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751914Ab1HOETu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 00:19:50 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:43051 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751838Ab1HOETm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 00:19:42 -0400
X-Sasl-enc: JWo6rWXr8F4TcLczEtcmsSpdUHbQoQnqqh89fhUCzYkA 1313381981
Date: Sun, 14 Aug 2011 21:15:24 -0700
From: Greg KH <greg@kroah.com>
To: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Cc: stable-review@kernel.org, stable@kernel.org
Subject: Future of the -longterm kernel releases (i.e. how we pick them).
Message-ID: <20110815041524.GA7578@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As I'm giving a talk about the -stable and -longterm kernels this week
at LinuxCon in Vancouver, and I've been talking with a lot of different
people about the future of the -longterm kernels, here's some thoughts
as to what I'm considering:


tl;dr;
	* -stable kernel releases stay the same
	* this proposal is how we pick the -longterm releases
	* -longterm kernels will be picked every year, and maintained
	  for 2 years before being dropped.
	* the same Documentation/stable_kernel_rules.txt will apply for
	  -longterm kernels, as before.

History:

2.6.16 became a "longterm" kernel because my day job (at SUSE) picked
the 2.6.16 kernel for its "enterprise" release and it made things a lot
easier for me to keep working at applying bugfixes and other stable
patches to it to make my job simpler (applying a known-good bunch of
patches in one stable update was easier than a set of smaller patches
that were only tested by a smaller group of people.)

Seeing that this worked well, a cabal of developers got together at a
few different Linux conferences and determined that based on their
future distro release cycles, we could all aim for standardizing on the
2.6.32 kernel, saving us all time and energy in the long run.  We turned
around and planted the proper seeds within the different organizations
and low-and-behold, project managers figured that this was their idea
and sold it to the rest of the groups and made it happen.  Right now all
of the major "enterprise" and "stable" distro releases are based on the
2.6.32 kernel, making this trial a huge success.

Last year, two different community members (Andi and Paul) asked me
if they could maintain the 2.6.34 and 2.6.35 kernels as -longterm kernel
releases as their companies needed this type of support.  I agreed, and
they have done a great job at this.

Andi reports that the 2.6.35 kernel is being used by a number of
different distros, but they will be phased out as their support lifetime
expires.  There are also a number of embedded users of the kernel as
well as some individual ones.  So that -longterm kernel is having a lot
of benefit for a wide range of users.


Today:

Now that 2.6.32 is over a year and a half, and the enterprise distros
are off doing their thing with their multi-year upgrade cycles, there's
no real need from the distros for a new longterm kernel release.  But it
turns out that the distros are not the only user of the kernel, other
groups and companies have been approaching me over the past year, asking
how they could pick the next longterm kernel, or what the process is in
determining this.

To keep this all out in the open, let's figure out what to do here.
Consumer devices have a 1-2 year lifespan, and want and need the
experience of the kernel community maintaining their "base" kernel for
them.  There is no real "enterprise" embedded distro out there from what
I can see.  montaVista and WindRiver have some offerings in this area, but
they are not that widely used and are usually more "deep embedded".
There's also talk that the CELF group and Linaro are wanting to do
something on a "longterm" basis, and are fishing around for how to
properly handle this with the community to share the workload.  Android
also is another huge player here, upgrading their kernel every major
release, and they could use the support of a longterm kernel as well.

Proposal:

Here's a first cut at a proposal, let me know if you like it, hate it,
would work for you and your company, or not at all:

- a new -longterm kernel is picked every year.
- a -longterm kernel is maintained for 2 years and then dropped.
- -stable kernels keep the same schedule that they have been (dropping
  the last one after a new release happens.)  These releases are best
  for products that require new hardware updates (desktop distros,
  community distros, fast-moving embedded distros (like Yocto)).
- the normal -stable rules apply to these -longterm kernels as described
  in Documentation/stable_kernel_rules.txt

This means that there are 2 -longterm kernels being maintained at the
same time, and one -stable kernel.  I'm volunteering to do this work, as
it's pretty much what I'm doing today anyway, and I have all of the
scripts and workflow down.

Public Notifications:

The current kernel.org site doesn't properly show what is and is not
being maintained as a -stable and -longterm kernel.  I have a proposal
for how to fix this involving 'git notes', I just need to sit down and
do the work with the kernel.org admins to get this running properly.

Thoughts?


greg k-h
