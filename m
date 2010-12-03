Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758628Ab0LCOdV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Dec 2010 09:33:21 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:52544 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758617Ab0LCOdT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Dec 2010 09:33:19 -0500
MIME-Version: 1.0
In-Reply-To: <E3D0B314C5E55043AC59C5FBDB298310EE11A5@008-AM1MPN1-005.mgdnok.nokia.com>
References: <4CEE4D6E.4030204@nokia.com>
	<4CF7D16D.4060009@schaufler-ca.com>
	<alpine.LRH.2.00.1012030823150.25347@tundra.namei.org>
	<alpine.LRH.2.00.1012030923560.26002@tundra.namei.org>
	<E3D0B314C5E55043AC59C5FBDB298310EE11A5@008-AM1MPN1-005.mgdnok.nokia.com>
Date: Fri, 3 Dec 2010 09:33:17 -0500
Message-ID: <AANLkTikjQuwvD4A0do0RAYheDKFeeXndjtDQvQC2WXEw@mail.gmail.com>
Subject: Re: VS: [PATCH] Smack: label for task objects (retry 2)
From: Eric Paris <eparis@parisplace.org>
To: ext-jarkko.2.sakkinen@nokia.com
Cc: jmorris@namei.org, casey@schaufler-ca.com, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 3, 2010 at 1:27 AM,  <ext-jarkko.2.sakkinen@nokia.com> wrote:
> Hi
>
> I don't like to whine about unnecessary things but it would really nice to get into the author field :) The patch that I sent to list did have merge issues. I  don't know what messed it.
>
> Casey, I propose we take some steps back and fix the workflow so next time things will go smoother. I propose that I create my own tree from your tree and put patch there and you can then cherry pick or merge my patch to his tree.  Then James can pick the patch from your tree.
>
> BR, Jarkko

You can't apply Sign-off's on a git-pull/git-merge.  I'm not sure if
James cares that he didn't sign the patch off either.  That doesn't
mean one can't do it, it just means it isn't an easy workflow.

If git tree owners use git am to apply mboxes (rather than patch + git
commit) the author/time/date type stuff will be correct.  The fact
that the original author forgot the signed-off is a problem unrelated
to git usage.

Now how could security set up git trees?  That is the question.

1) 'child' trees (I see child tree as the SELinux or SMACK tree)
should NEVER be based on something newer than security-testing.
Personally I don't think security-testing should merge Linus' except
maybe 2 times per upstream kernel cycle.  At release and then about
-rc4 or 5.  If we are doing things right security-testing shouldn't
need to merge ever, but I digress.  Linus would MUCH rather deal with
conflicts himself than have development trees merge his work quickly
or regularly.  That's a problem for James to deal with I guess.  We as
child tree owners need to just base off of James.

2) If #1 is true and you want to get Sign-off's in your parent tree
you can set up the child trees as a remote.  Then you can use:

git format-patch -k --stdout HEAD..remotes/[child]/[branch] | git am
-3 -k --whitespace=fix -s

Where you obviously set child/branch appropriately.  This will apply
the patches found in the child tree but not in the parent tree (which
is the reason the child must be behind) one at a time and will add
your Signed-off.

The problem with this method is that it makes it harder to check if
the pull request was done properly.  A merge gives a unified diff that
can be compared to a properly formated (git request-pull) pull request
to make it easy for the puller to verify he pulled what he was ask to
pull.  So the parent tree has to do that unified diff themselves and
double check.

Our tree is so simple I don't really understand why we need all this,
but if we need it, lets figure out what works best for everyone!

-Eric
