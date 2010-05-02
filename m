Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754413Ab0EBAZX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 May 2010 20:25:23 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:46863 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750855Ab0EBAZS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 May 2010 20:25:18 -0400
Date: Sat, 1 May 2010 17:25:13 -0700
From: Matt Helsley <matthltc@us.ibm.com>
To: David Miller <davem@davemloft.net>
Cc: orenl@cs.columbia.edu, akpm@linux-foundation.org,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       serue@us.ibm.com, matthltc@us.ibm.com, xemul@openvz.org,
       sukadev@linux.vnet.ibm.com, linux-api@vger.kernel.org, x86@kernel.org,
       linux-s390@vger.kernel.org, linuxppc-dev@ozlabs.org
Subject: Re: [PATCH v21 001/100] eclone (1/11): Factor out code to allocate
 pidmap page
Message-ID: <20100502002513.GC31830@count0.beaverton.ibm.com>
References: <1272723382-19470-1-git-send-email-orenl@cs.columbia.edu>
 <1272723382-19470-2-git-send-email-orenl@cs.columbia.edu>
 <20100501.151022.190375136.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100501.151022.190375136.davem@davemloft.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 01, 2010 at 03:10:22PM -0700, David Miller wrote:
> NO WAY, there is no way in the world you should post 100 patches
> at a time to any mailing list, especially those at vger.kernel.org
> that have thousands upon thousands of subscribers.

I am sorry we concluded that sending these 100 patches at once was a
good idea. I will try, again, to find ways to divide the
set up into more manageable pieces. Regardless of how that goes
the whole set will not be submitted to LKML/vger all at once in the
future.

If anyone would like to offer more specific constructive suggestions
on subdividing the patches I'd be happy to try them.

That said, for anyone who's curious, we faced a few dilemmas which
pointed us down the wrong path here.

http://lkml.org/lkml/2010/3/1/422

Specifically the last part is rather hard to misinterpret:

"I'd suggest waiting until very shortly after 2.6.34-rc1 then please
send all the patches onto the list and let's get to work."

(ok, it's not shortly after 2.6.34-rc1 -- we were asked to reorganize
the code and we did...)

But even if one decides to ignore the common sense interpretation of
Andrew's reply there was more:

Standard procedure is to post to LKML when pushing patches upstream.

We were asked to create a useful implementation of checkpoint/restart
yet when we tried to submit a digestable piece we were told that
submitting it by itself was pointless (eclone). The rest of the code
was even more checkpoint/restart-specific so the same logic seemed to
apply.

We have public git trees and used the containers@ mailing list to post
patches for review but rarely received outside feedback on patches
there. Not even requests to divide the set.

So clearly we needed to post to relevant external lists and
reviewers. We tried that earlier and received complaints that lists
hadn't been Cc'd on some of the patches (e.g. fsdevel). So clearly we
needed to expand the Cc list for v21.

We looked at dividing the set but it always came down to trimming
functionality -- this conflicted with the "useful implementation"
we were asked for.

In summary: We've been given a fair number of conflicting instructions
		and we failed to find the right balance in following them.

> Post only small, well contained, sets of patches at a time.  At most
> 10 or so in one go.

We've tried to keep the individual patches small and reviewable. That
has the opposite effect on patch count unfortunately.

>
> Do you realize how much mail traffic you generate by posting so many
> patches at one time, and how unlikely it is for anyone to actually
> sift through and review your patches after you've spammed them by
> posting so many at one time?
>
> A second infraction and I will have no choice but to block you at the
> SMTP level at vger.kernel.org so please do not do it again.

We will not post nearly this many at once again.

I'm thinking we'll just provide URLs to git trees or quilt series
if subdividing is impossible and/or anyone needs wider context than
the 10 or so we post at a time.

Sorry again,
	-Matt Helsley
