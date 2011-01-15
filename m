Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753200Ab1AORXb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Jan 2011 12:23:31 -0500
Received: from mx1.redhat.com ([209.132.183.28]:29177 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751347Ab1AORX2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Jan 2011 12:23:28 -0500
Date: Sat, 15 Jan 2011 18:23:20 +0100
From: Andrea Arcangeli <aarcange@redhat.com>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "Luck, Tony" <tony.luck@intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>, linux-arch@vger.kernel.org
Subject: Re: ia64 broken by transparent huge pages - other arches too?
Message-ID: <20110115172320.GU9506@random.random>
References: <4d308cf5394566ccc@agluck-desktop.sc.intel.com>
 <1295076096.4875.60.camel@pasglop>
 <20110115155925.GT9506@random.random>
 <1295110048.5973.36.camel@mulgrave.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1295110048.5973.36.camel@mulgrave.site>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 15, 2011 at 10:47:28AM -0600, James Bottomley wrote:
> Andrea, what you say above isn't true, you're not thinking broadly
> enough: the kernel is a complex set of code interactions.  For instance,
> you caused this build break on parisc (which is a regression even though
> parisc has no transparent huge pages at all):
> 
> http://marc.info/?l=linux-arch&m=129504371532124

Yes I've seen the arm build fix. Thanks for it! ;)

> That was just from a simple code rearrangement (independent of any of
> the config options).
> 
> One of the points of getting stuff through linux-next is that all of
> these problems get sorted out long before the code hits mainline.  This
> happens because linux-next gets a wide range of config randomisation
> testing plus quite a few different architecture builds and runs.
> 
> The problem is very often not in the actual code, but in the side
> effects the code causes.  This is what linux-next integration helps
> mitigate. So, please use it next time.  Just testing on x86 in your own
> configuration isn't sufficient to pick up the problems.

I fully agree with you about build time regression, there linux-next
might have helped more. I'm talking about runtime regressions. If it
build it'll work because nothing relevant has changed for not-x86
archs.

By all means next times I'll try to get through linux-next too if this
is preferred, but the brainer part has been heavily tested and that's
the important thing as far as I can see.

I'm also not sure if having it in linux-next instead of -mm, would
have been better in terms of handling of the patchstream. I think
having it managed in -mm reviewed by all other -mm developers using
raw patches floating in the linux-mm and mm-commit lists, was ideal
and potentially more valuable for an increased amount of review, than
what a blind pull from linux-next could provide. For the brainer part,
maximizing the reviewing was certainly more valuable than checking if
it builds and boots on some arch not affected in any functional way.

I think the sparc/arm build issues because of cleanup code refactoring
are not worth worrying too much about, or at least they shouldn't be
the argument for lack of testing. Said that, I apologize for the
annoyance and I appreciate your help in the arm case. ia64 I fixed it
with a one liner already.

Overall I think the end result is great, perfection was the goal and
if these build issues are the only error I think we got as close as
humanly possible to it. And it's definitely thanks to an huge amount
of help and feedback from the whole Linux community (both developers,
maintainers and testers) if we could achieve this result, I could
never achieve this alone.

Sincerely thanks everyone!
Andrea
