Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758189Ab2FTVyp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 17:54:45 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:32891 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754873Ab2FTVyo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 17:54:44 -0400
Message-ID: <1340229283.29885.23.camel@joe2Laptop>
Subject: Re: [PATCH] scripts/get_maintainer.pl: Add tested-by signature
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alexandre Pereira da Silva <aletes.xgr@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        Ian Campbell <Ian.Campbell@citrix.com>,
        Richard Weinberger <richard@nod.at>, linux-kernel@vger.kernel.org
Date: Wed, 20 Jun 2012 14:54:43 -0700
In-Reply-To: <20120620143959.394b9930.akpm@linux-foundation.org>
References: <1340193105-10734-1-git-send-email-aletes.xgr@gmail.com>
	 <1340209526.29885.14.camel@joe2Laptop>
	 <20120620143959.394b9930.akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-06-20 at 14:39 -0700, Andrew Morton wrote:
> On Wed, 20 Jun 2012 09:25:26 -0700
> Joe Perches <joe@perches.com> wrote:
> 
> > On Wed, 2012-06-20 at 08:51 -0300, Alexandre Pereira da Silva wrote:
> > > The tester of the patch should also be listed to receive patch
> > > notifications.
> > []
> > > diff --git a/scripts/get_maintainer.pl b/scripts/get_maintainer.pl
> > []
> > > @@ -81,6 +81,7 @@ my $penguin_chiefs = "\(" . join("|", @penguin_chief_names) . "\)";
> > >  my @signature_tags = ();
> > >  push(@signature_tags, "Signed-off-by:");
> > >  push(@signature_tags, "Reviewed-by:");
> > > +push(@signature_tags, "Tested-by:");
> > >  push(@signature_tags, "Acked-by:");
> > 
> > I have no objections to this, but maybe Florian Mickler
> > (cc'd) who did analysis on signatures awhile ago might.
> > 
> 
> Yes.  In my experience, a lot of tested-by's come from random internet
> victims who happened to report a bug and who we'll never hear from
> again and who don't want to be told other things about
> whatever-part-of-the-kernel-that-was.
> 
> Perhaps the set "has a tested-by, doesn't have reported-by" would
> filter out a lot of these, dunno.  It all sounds a bit marginal.
> 
> 
> 
> Also, lots of people have used a "Reported-and-tested-by" and there are
> even a few lysdexic "Tested-and-[rR]eported-by" tags in there.
> 
> Any time I see one of these things I stomp on it and turn it into
> separate reported-by and tested-by lines, as Reported-and-tested-by
> just adds pointless duplication, work and noise.  But I appear to have
> lost that fight.
> 
> 
> This fashion of adding new and innovative changelog tags just creates
> inaccuracy and work for people who wish to mine that data for something
> useful, as Alexandre is finding out.
> 
> <does some data mining>
> 
> Geeze, guys.  Who knew there were so many Kernel Komedians?

Lighten up.
I don't think there's a real issue with Kernel Komedy.
It's a real small % of all signatures.

But comedi is still gross and ugly, keep at it Harley...

$ git log --pretty=oneline --since=1-year-ago | \
  wc -l
59347

$ git log --format=email --since=1-year-ago | \
  grep -Eio "^\s*[a-z0-9_-]+by:"| \
  sed -r 's/^\s+//g' | sort | uniq -c | sort -rn
 103179 Signed-off-by:
  10516 Acked-by:
   5435 Reviewed-by:
   2748 Reported-by:
   2450 Tested-by:
    252 Suggested-by:
    178 Signed-Off-by:
    172 Reported-and-tested-by:
     50 Requested-by:
     35 Tested-By: 
     34 Reviewed-By:
     31 Reported-and-Tested-by:
     26 Acked-By:
     22 Reviewed-and-Tested-by:
     13 Acked-and-tested-by:
     12 Signed-of-by:
     12 Originally-by:
      9 Reviewed-and-tested-by:
      9 Reported-By:
      9 Reported-and-bisected-by:
      8 Bisected-by:
      7 Tested-and-Acked-by:
      7 Reviwed-by:
      7 Inspired-by:
      6 Original-patch-by:
      6 Based-on-patch-by:
      6 ACKed-by:
      5 signed-off-by:
      5 Ack-by:
      4 Tested-and-Reported-by:
      4 Tested-and-acked-by:
      4 Signed-Off-By:
      4 Requested-and-tested-by:
      4 Acked-and-Tested-by:
      3 Suggested-and-acked-by:
      3 Reported-bisected-and-tested-by:
      3 Reported-and-acked-by:
      3 Proposed-by:
      3 Patch-updated-by:
      3 Origionally-authored-by:
      3 Noticed-by:
      3 Hacked-by:
      3 Debugged-by:
      3 Analyzed-by:
      2 Tested-and-reviewed-by:
      2 Suggested-and-Acked-by:
      2 Singed-off-by:
      2 SIgned-off-by:
      2 Reviewied-by:
      2 Reported-and-analyzed-by:
      2 Reported-and-Acked-by:
      2 Maybe-reported-by:
      2 Helped-by:
      2 Found-by:
      2 Broken-by:
      2 Acked-off-by:
      2 Ackec-by:
      1 Verified-by:
      1 Tracked-down-by:
      1 Tested-and-bugfixed-by:
      1 Spotted-by:
      1 Sined-off-by:
      1 Sig-off-by:
      1 Signed-Signed-off-by:
      1 Signed-off-by-by:
      1 Signed-off-By:
      1 Signed-ff-by:
      1 Reviewed-and-wanted-by:
      1 Reported-Tested-by:
      1 Reported-tested-and-bisected-by:
      1 Reported-tested-and-acked-by:
      1 Reported-requested-and-tested-by:
      1 Reported-by-and-Tested-by:
      1 Reported-any-tested-by:
      1 Reported-and-Tested-By:
      1 Reported-and-Reviewed-and-Tested-by:
      1 Reported-and-requested-by:
      1 Reported-and-Debugged-by:
      1 Reported-and-debugged-by:
      1 Report-by:
      1 Reporetd-by:
      1 Partly-suggested-by:
      1 Original-idea-by:
      1 Liked-by:
      1 Last-bug-reported-by:
      1 Inspried-by:
      1 Grumpily-requested-by:
      1 Fucked-up-by:
      1 Fixes-by:
      1 Fixed-by:
      1 Fix-by:
      1 Finished-by:
      1 Encouraged-by:
      1 Diagnosed-by:
      1 Diagnoised-by:
      1 cked-by:
      1 Bisected-reported-and-tested-by:
      1 Antagonized-by:
      1 Analysed-by:
      1 Also-written-by:
      1 Also-Reported-by:
      1 Also-reported-by:
      1 Aked-by:
      1 Ackeded-by:
      1 Ackedby:
      1 Acked-and-reviewed-by:
      1 Ached-by:
      1 Accked-by:


