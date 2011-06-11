Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758714Ab1FKPnl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jun 2011 11:43:41 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:41114 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758703Ab1FKPnk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jun 2011 11:43:40 -0400
Date: Sat, 11 Jun 2011 17:43:34 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: Greg Dietsche <gregory.dietsche@cuw.edu>
Cc: Gilles.Muller@lip6.fr, npalix.work@gmail.com, cocci@diku.dk,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] coccinelle: if(ret)return ret; return ret; semantic
 patch
In-Reply-To: <4DF38BAA.9050406@cuw.edu>
Message-ID: <Pine.LNX.4.64.1106111741250.13465@ask.diku.dk>
References: <1307320012-31292-1-git-send-email-Gregory.Dietsche@cuw.edu>
 <Pine.LNX.4.64.1106060651320.7113@ask.diku.dk> <4DF38BAA.9050406@cuw.edu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 11 Jun 2011, Greg Dietsche wrote:

> On 06/05/2011 11:55 PM, Julia Lawall wrote:
> > Thanks.  I tried this too, but I wasn't sure about the results.  The
> > question is why stop here.  For example, there are IS_ERR calls that one
> > could consider as well.  Or ret<  0.  Or why not just:
> >
> > @@
> > expression ret;
> > @@
> >
> > - if (...) return ret;
> >    return ret;
> >
> >    
> I've been thinking a bit more about this. Is there a community preference
> towards patches that are highly reliable v.s. ones that find things that might
> not be a problem? I'm leaning towards updating my patch to do the above and
> then later coming back when I have more time to fix it up to find only things
> that are really problems.

I tend to write the patch that returns the kinds of thing that I know how 
to fix :).  That is, if I see a lot of reports that I don't know what to 
do with, I write the semantic patch to avoid showing them to me.

When you put your patch in the kernel, you can put some comments at the 
beginning of it that say your confidence in the results and give some 
hints about possible false positives.

Overall, I think you should just use your judgement :)

thanks,
julia

> Greg
> > Although there might be function calls that one doesn't want to touch, so:
> >
> > @@
> > identifier f != IS_ERR;
> > expression ret;
> > statement S;
> > @@
> >
> > (
> > if (<+...f(...)...+>) S
> > |
> > - if (...) return ret;
> >    return ret;
> > )
> >
> > julia
> >
> >
> > On Sun, 5 Jun 2011, Greg Dietsche wrote:
> >
> >    
> > > This semantic patch finds code matching this pattern:
> > >  if(ret)
> > >  	return ret;
> > >  return ret;
> > >
> > > I will be submitting patches shortly against the mainline to cleanup all
> > > code matching this pattern.
> > >
> > > Signed-off-by: Greg Dietsche<Gregory.Dietsche@cuw.edu>
> > > ---
> > >   scripts/coccinelle/misc/doublereturn.cocci |   20 ++++++++++++++++++++
> > >   1 files changed, 20 insertions(+), 0 deletions(-)
> > >   create mode 100644 scripts/coccinelle/misc/doublereturn.cocci
> > >
> > > diff --git a/scripts/coccinelle/misc/doublereturn.cocci
> > > b/scripts/coccinelle/misc/doublereturn.cocci
> > > new file mode 100644
> > > index 0000000..656a118
> > > --- /dev/null
> > > +++ b/scripts/coccinelle/misc/doublereturn.cocci
> >> @@ -0,0 +1,20 @@
> > > +/// Remove unecessary if/return in code that follows this pattern:
> > > +///	if(retval)
> > > +///		return retval;
> > > +///	return retval;
> > > +//
> > > +// Confidence: High
> > > +// Copyright: (C) 2011 Greg Dietsche GPLv2.
> > > +// URL: http://www.gregd.org
> > > +// Comments:
> > > +// Options: -no_includes
> > > +
> > > +virtual patch
> > > +
> > > +@@
> > > +identifier retval;
> > > +@@
> > > +-if (retval)
> > > +-	return retval;
> > > +-return retval;
> > > ++return retval;
> > > -- 
> > > 1.7.2.5
> > >
> > >
> > >      
> >    
> 
