Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753782Ab1FEGbh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jun 2011 02:31:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5172 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752592Ab1FEGbg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jun 2011 02:31:36 -0400
Subject: Re: drivers/drm/i915 maintenance process
From: Dave Airlie <airlied@redhat.com>
To: Keith Packard <keithp@keithp.com>
Cc: dri-devel@lists.freedesktop.org,
        "drivers, Intel" <Intel-gfx@lists.freedesktop.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date: Sun, 05 Jun 2011 16:23:43 +1000
In-Reply-To: <yunipskolss.fsf@aiko.keithp.com>
References: <yunipskolss.fsf@aiko.keithp.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Message-ID: <1307255026.17387.8.camel@t60prh>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2011-06-04 at 23:05 -0700, Keith Packard wrote:
> I'm trying to formalize the process for merging code into the drm/i915
> driver. Here's a first draft, please send along your comments.

Okay so you made the same mistake a lot of people make, the merge window
for -next from me to Linus is from when he releases a .x release.
However the merge window for you to me, should happen before this,
multiple -next merges are allowed before Linus releases a kernel, though
I'd really like to close the door around -rc6 in general. Generally I've
found though with graphics we are crunch time for late found regression
around rc6 time so I rarely push back too hard as I'd rather the kernel
release with no regressions than worry overly about -next.

So when Linus is releasing rc4/5 you should really be cutting down stuff
going into your -next, and getting the tree ready for me to take. We can
probably add your tree direct to the -next git list as well so that we
can get the benefits of -next testing earlier.


Some misc stuff inline:

<snip>
> 	The part I'm less sure about is how to deal with patches that
> 	affect both drm/i915 and drm itself. In that case, we may have
> 	patches on both drm-intel-fixes and drm-fixes which work
> 	together to resolve an issue. I think the right thing will be to
> 	have drm-intel-fixes get merged into drm and from there be
> 	merged into master. That's what I've done with a set of fixes
>         posted after 3.0-RC1.

Yes if you have any interdepends then you need to coordinate with me,
hopefully outside of -next we don't have that sort of work happening, as
generally individual drm patches should be in my tree anyways.

> 	I'm interested in hearing comments about whether this will cause
> 	too many additional issues with merges from other parts of the
> 	kernel, or whether we'll end up far behind other trees somehow.

Linus rule is to avoid misc merges, however if you are only getting fast
forwards then it seems like it should be fine as we are getting people
testing from a better base.

> 
> drm-intel-next
> 
> 	While the merge window is closed, this tree will be accumulating
> 	patches in preparation for the subsequent merge window. However,
> 	to reduce the divergence from drm-intel-fixes, I'm proposing
> 	that drm-intel-fixes get merged to drm-intel-next whenever it is
> 	merged to master. I fully expect this to cause merge conflicts,
> 	but resolving those within our own tree before they are sent
> 	upstream should reduce the conflicts at that level. As
> 	drm-intel-fixes is periodically fast-forwarded to points along
> 	master, those merges will get pulled across to drm-intel-next.
> 
> 	At the opening of the merge window, drm-intel-next should
> 	contain all of drm-intel-fixes from the release, and most of the
> 	rest of the release as well.

Just make sure any merge commits are documented in the commit, this
generally means having to git commit --amend the merge commit since most
of the time it doesn't allow you to write anything unless you get a
conflict, esp if its a strange non i915 commit (like say some ACPI or
bluetooth commit that fixes a test laptop).

Otherwise sounds good.

Dave.

