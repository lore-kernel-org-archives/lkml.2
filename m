Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932338Ab1AKQNk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 11:13:40 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53751 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932274Ab1AKQNj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 11:13:39 -0500
MIME-Version: 1.0
In-Reply-To: <AANLkTi=pvz-ou3_DK0dUSRYCARkwM_X9x7Xpnapjw_Ke@mail.gmail.com>
References: <alpine.DEB.2.00.1101091110520.5270@tiger> <AANLkTim0UBNG6bVgBDQsrBhVjS0FSdLbwaipBZGkTeWF@mail.gmail.com>
 <AANLkTi=pvz-ou3_DK0dUSRYCARkwM_X9x7Xpnapjw_Ke@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 11 Jan 2011 08:13:09 -0800
Message-ID: <AANLkTiknwXJF+pLJFQPqa7XPywi=boz-H+_JLk-T+Zp8@mail.gmail.com>
Subject: Re: [GIT PULL] SLAB changes for v2.6.38
To: Pekka Enberg <penberg@kernel.org>
Cc: cl@linux-foundation.org, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 11, 2011 at 2:41 AM, Pekka Enberg <penberg@kernel.org> wrote:
>
> Is cherry pick still sane from maintainer workflow point of view?

Yes, if it's the occasional random thing that happens once or twice,
it's much easier than a separate branch and merging it into other
branches.

We have the exact same thing happen every once in a while simply
because two people apply the same emailed patch to their trees. You
end up with the same diff and the same message. Yeah, it's not called
a "cherry-pick" then, but there's really not any technical difference
apart from the commands to generate the "duplicate" commits.

It can become a problem if there's a _lot_ of it going on, though. It
can cause subsequent merge issues if there are other changes in the
same area, for example. And it can be a sign of some bad workflow.

You could also simply think of it in terms of "number of extra
commits". If you cherry-pick and it shows up as one extra commit,
that's still easier to understand and fewer overall commits than
having a separate branch with just one commit, and then two merge
commits - to merge that special branch into the two branches you care
about.

Using that rough guideline, if you have three or more of these, it
would actually be better to have them in one branch, and then merge
that stable branch twice - fewer extraneous commits (but that also
requires that you don't merge after each one.

That said, "number of commits" is not a really meaningful measure
either. I really tend to like how the ACPI tree does things, with
separate branches for separate bugzilla entries - with nice relevant
branch naming (bug number or description) - and then merging them. At
that point you may well have a branch with just a single commit in it,
but now the extra merge actually _adds_ information and the history
looks better for it.

So there are no hard rules. I personally use "gitk" after pulling, and
quite frankly, "clean history" is pretty damn obvious.

                                Linus
