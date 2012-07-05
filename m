Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757170Ab2GETIJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 15:08:09 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:62020 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752628Ab2GETIG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 15:08:06 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6763"; a="207731896"
X-IronPort-AV: E=Sophos;i="4.77,531,1336374000"; 
   d="scan'208";a="279148636"
Date: Thu, 5 Jul 2012 12:08:01 -0700
From: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
To: Sujith Manoharan <c_manoha@qca.qualcomm.com>
CC: "Balasubramanian, Senthil Kumar" <senthilb@qca.qualcomm.com>,
        "Manoharan, Rajkumar" <rmanohar@qca.qualcomm.com>,
        qca-linux-team <qca-linux-team@qualcomm.com>,
        Imran Ansari <imran@qca.qualcomm.com>,
        <linux-wireless@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <sfr@canb.auug.org.au>, <mcgrof@frijolero.org>, <hauke@hauke-m.de>,
        <ozancag@gmail.com>, <pstew@google.com>, <warthog9@kernel.org>,
        <jrnieder@gmail.com>, <ben@decadent.org.uk>,
        <akpm@linux-foundation.org>, <gregkh@linuxfoundation.org>,
        <linville@tuxdriver.com>
Subject: Re: 3.5 stable compat-wireless
Message-ID: <20120705190801.GB11228@tux>
References: <20468.35601.132955.802881@gargle.gargle.HOWL>
 <7A9ADFFA56024346AAE90B6BABC3BD15DD6DEB@NASANEXD02B.na.qualcomm.com>
 <20469.13787.767293.602337@gargle.gargle.HOWL>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20469.13787.767293.602337@gargle.gargle.HOWL>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Originating-IP: [172.30.39.5]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Making this discussion public and adding Stephen, maintainer
of linux-next.git. I'm also adding Andrew and Greg given their
previous efforts on trying to address these deltas and "crap".

On Thu, Jul 05, 2012 at 12:06:11PM +0530, Sujith Manoharan wrote:
> Rodriguez, Luis wrote:
> > 
> > Please do send me a public pull request just for public record but I already
> > merged this and made a public release based on this. Take a pick:
> > 
> > http://www.orbit-lab.org/kernel/compat-wireless-3-stable/v3.5/compat-wireless-3.5-rc5-1.tar.bz2
> > http://www.orbit-lab.org/kernel/compat-wireless-3-stable/v3.5/compat-wireless-3.5-rc5-1-sn.tar.bz2
> > http://www.orbit-lab.org/kernel/compat-wireless-3-stable/v3.5/compat-wireless-3.5-rc5-1-snpc.tar.bz2
> > 
> > http://www.orbit-lab.org/kernel/compat-wireless-3-stable/v3.5/ChangeLog-3.5-rc5
> > http://www.orbit-lab.org/kernel/compat-wireless-3-stable/v3.5/ckmake-3.5-rc5-1-snpc.log.bz2
> > 
> > All 3 releases test compiled across 21 kernels OK!
> 
> So a neat method to properly track upstream compat-wireless and manage internal
> SPE releases would be to not use the linux-next-pending/ directory. We can avoid
> unnecessary churn in the upstream repo and instead just push cherry picked patches
> to linux-next-cherry-picks/ and push out periodic releases.

We seem to have been thinking of optimizing the process at the same
time! I'll chime in with some thoughts on what you are suggesting
and later explain what my brain cells were last contemplating to
solve this problem.

Just to recap for those new to the idea. The stable compat-wireless releases
(soon to be renamed to compat-drivers) addresses allowing vendors / third parties
to add additional patches on top of stable releases of the Linux kernel but
by ensuring we prioritize the upstream process. At the same time we keep
metrics of these deltas. We accomplish allowing for deltas by enabling patches
to be applied to the stable releases by categorizing each patch into the
respective life cycle it is in on its way upstream. There are then 4 directories
for extra patches:

pending-stable/
linux-next-cherry-picks/
linux-next-pending/
crap/

This is all explained here:

http://wireless.kernel.org/en/users/Download/stable/#Additional_patches_to_stable_releases

> To make internal releases, I do something like this:
> 
> * Maintain a 'linux-foo-pending' branch, add pending patches and kick out releases
>   for immediate testing.

A linux-foo-pending branch of linux-next.git ?

> * Time passes and the changes are pushed to a 'for-luis' branch and we send out a
>   pull request to our In-House Benevolent Dictator.
> 
> * More time passes, upstream is updated and a release is made.

This indeed could help but -- one of the benefits of having
a linux-next-pending/ directory is that we would be keeping track of
the metrics in a unified manner. I will be updated the metrics for
all releases throughout time in this public Google Fusion Table:

http://bit.ly/H6BTF7

Check out the shiny graphs starting at slide 22:

https://docs.google.com/presentation/d/1axVNEGwKZjnzG1ocdd289WMqPxzJ3qfMv70ghGcnUKc/edit

What you *do not see here yet* is metrics on the additional patches, but
the reason was that I had not yet hammered on folks to consider using
them, rather than keeping their own private deltas. Obviously now I've
been hammering a few folks to consider using this set of directories
for additional patches  but let me make it clear that I want to use
these also to be able to keep record of the size of each type of
deltas as it can tell us how we're doing in terms of:

  * How fast / slow are maintainers merging code in, and how is this
    changing over time ?
  * How much crap are we keeping to ourselves over time ?
	- Who is working on these items, is this growing or reducing in size ?
  * How many stable patches are being pumped out that is not yet merged
    on the latest RC ?

I intend to use this to evaluate our work, both at the driver level and also
community / components. But you're right -- the churn over managing patches
from linux-next-pending/ over to linux-next.git would be high if we continue
to pump out stable releases quite often. The numbering of the patches and
order of them itself is a pain in the ass to reorder once patches have
shifted from not being merged to being merged.

If you were considering a linux-foo-pending branch for a linux-next.git tree
then I am in agreement with you, this would indeed allow us to also keep
track of the linux-next-pending delta (patches posted but not yet merged
into linux-next.git) but... I'm thinking this is not only useful for us, but
for others as well.

I see this as a *general silicon company problem*, and hence my efforts
on trying to address this -- but in a way that allows us to prioritize
upstream, keep everyone in line on not deviating away from working
properly upstream. Many companies *need* to get these deltas merged
out to different types of trees and I believe we have seen a higher
need for this due to the rapid increase of adoption of Linux on mobile
devices and the desktop. We're at a point in time now where Linux gets
support for hardware prior to the hardware even hitting the "shelves".
Sometimes, silicon may not even end up shipping in any products !
This is a huge shift, and we should be considering how to best
enable these efforts but by helping such efforts to not derail
the upstream process.

So it makes me wonder instead of we should have something that takes
linux-next.git *two steps* beyond to account for the pending and also
for the crap.

  * linux-pending.git: based on linux-next.git and merges patches
    ASAP so long as they are public.

  * linux-crap.git: based on linux-next-pending.git and allows
    contributors to send pull requests of crap that is not *ready*
    to be sent properly upstream. Examples would be code we know
    we simply already know that is not dealing with proper architecture
    or style / etc. The drivers/staging/ allows vendors to post full
    crap drivers, this would enable us to merge crap patches but that
    some vendors might need / want.

The goal would be to provide an outlet for all this crap to be
merged somewhere, easily accessible, and to prioritize / educate
to work properly upstream.

In order for this to work I suppose maintainers would have to have
a respective subsystem-pending.git and subsystem-crap.git and
use the same magic that Stephen uses to pull all these together.
I wonder if the same scripts could be used.

I do wonder if the benefits are something that *some* subsystem maintainers
would be up to consider maintaining. We wouldn't need all subystem maintainers
to be up to do this to test it, just one or two. Or I wonder if patchwork (this
is why I added John Hawley) could help with this.  If we really are up to try
it, perhaps we can start with the 802.11 subsystem. John, what are your
thoughts ?

>  And we move on and contemplate on: "But what exactly *is* time ?".

I wonder if the existence of the Higgs Boson will change our notion
of time.

  Luis
