Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752028Ab1HPXCB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Aug 2011 19:02:01 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:65455 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751873Ab1HPXB6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Aug 2011 19:01:58 -0400
MIME-Version: 1.0
In-Reply-To: <20110815041524.GA7578@kroah.com>
References: <20110815041524.GA7578@kroah.com>
Date: Tue, 16 Aug 2011 16:01:57 -0700
Message-ID: <CA+bK7J7_EKdQACnoJGWkd4asH+096SJ-gjEvsnjmRX6Dmc6dpA@mail.gmail.com>
Subject: Re: Future of the -longterm kernel releases (i.e. how we pick them).
From: Tim Bird <tbird20d@gmail.com>
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        stable-review@kernel.org, stable@kernel.org, tim.bird@am.sony.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>Greg KH wrote:
> To keep this all out in the open, let's figure out what to do here.
> Consumer devices have a 1-2 year lifespan, and want and need the
> experience of the kernel community maintaining their "base" kernel for
> them.  There is no real "enterprise" embedded distro out there from what
> I can see.  montaVista and WindRiver have some offerings in this area, but
> they are not that widely used and are usually more "deep embedded".
> There's also talk that the CELF group and Linaro are wanting to do
> something on a "longterm" basis, and are fishing around for how to
> properly handle this with the community to share the workload.  Android
> also is another huge player here, upgrading their kernel every major
> release, and they could use the support of a longterm kernel as well.

Well I certainly hope that there's more participation on sharing the
workload by embedded companies than there has historically been.
I'm not at LinuxCon this week, but I want to follow up with you
(maybe at KS?) on good ways that CE companies can help with
this effort.

> Proposal:
>
> Here's a first cut at a proposal, let me know if you like it, hate it,
> would work for you and your company, or not at all:
>
> - a new -longterm kernel is picked every year.
> - a -longterm kernel is maintained for 2 years and then dropped.
> - -stable kernels keep the same schedule that they have been (dropping
>  the last one after a new release happens.)  These releases are best
>  for products that require new hardware updates (desktop distros,
>  community distros, fast-moving embedded distros (like Yocto)).
> - the normal -stable rules apply to these -longterm kernels as described
>  in Documentation/stable_kernel_rules.txt
>
> This means that there are 2 -longterm kernels being maintained at the
> same time, and one -stable kernel.  I'm volunteering to do this work, as
> it's pretty much what I'm doing today anyway, and I have all of the
> scripts and workflow down.

This all sounds great to me. As you know CEWG (formerly CELF) is very
interested in supporting LTS work.  What you describe
would be a good base for what we envision.

That said, I echo the concerns about version selection.  It would be
good to have a "settle" period longer than 1 stable release for selecting
a kernel (but then again, we don't want to wait too long to pick each
longterm release).

Rolling, overlapping, longterm versions seems like a nice idea.
I like the idea of looking for a volunteer to continue maintenance after
2 years, and if none is found dropping the release.  That way, someone
can step up if there is continued interest in a particular longterm version.

Also, the more people using a particular LTS kernel, the better. In the past
the embedded guys didn't coordinate well enough with other parties.  If
we could get enterprise, desktop and embedded on a single LT release, that
would be really nice.  I'm not sure how you're keeping track of interested
parties, but if there's a mailing list (besides 'stable') let me know so I can
sign up.

With regard to version selection, I know different companies will have
different versions they'd like to see selected.  Having consensus on
a version is more important than the particular version chosen.

Having said that, here are some (non-BSP) things we look at for selecting
kernel versions at Sony:

One specific issue I have is support for PREEMPT_RT, so that's a big
factor in selecting Sony kernel versions.  Thus, coordinating with the
RT patchset kernel versions is important to me.  Currently
that would mean 3.0 is a good candidate.

The other major out-of-tree patches we usually integrate are
1) Android
2) LTTng, but I've heard that this might soon be buildable as
a loadable module (eliminating the need for any patch integration).

Thanks,
  -- Tim
