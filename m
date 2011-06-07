Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757217Ab1FGQ43 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 12:56:29 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:56320 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757190Ab1FGQ42 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 12:56:28 -0400
Date: Tue, 7 Jun 2011 18:56:22 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: Greg Dietsche <gregory.dietsche@cuw.edu>
Cc: Gilles.Muller@lip6.fr, npalix.work@gmail.com, cocci@diku.dk,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] coccinelle: if(ret)return ret; return ret; semantic
 patch
In-Reply-To: <4DEE482D.7020505@cuw.edu>
Message-ID: <Pine.LNX.4.64.1106071855540.4074@ask.diku.dk>
References: <1307320012-31292-1-git-send-email-Gregory.Dietsche@cuw.edu>
 <Pine.LNX.4.64.1106060651320.7113@ask.diku.dk> <4DEE482D.7020505@cuw.edu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 7 Jun 2011, Greg Dietsche wrote:

> Hi Julia,
> 
> On 06/05/2011 11:55 PM, Julia Lawall wrote:
> > Thanks.  I tried this too, but I wasn't sure about the results.  The
> > question is why stop here.
> very interesting! Honestly I hadn't thought much further than what you see in
> my semantic patch. I'd noticed piece of code in the iwlegacy driver and
> wondered what'd happen if I taught myself a little bit about cocci :)
> >    For example, there are IS_ERR calls that one
> > could consider as well.  Or ret<  0.  Or why not just:
> >
> > @@
> > expression ret;
> > @@
> >
> > - if (...) return ret;
> >    return ret;
> >
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
> >    
> There seem to be many variations on the theme to consider... though hopefully
> the compiler optimizes most of these out... For example, in
> sound/soc/codecs/wm8940.c, Jonathan Cameron pointed some code out to me that
> looks like this:
> 
>         if (ret)
>                 goto error_ret;
> 
> error_ret:
>         return ret;

Good one :)

> As an aside, I added a feature to the script for myself so that I can for
> example write 'make coccicheck M=drivers/net/wireless/' for example to focus
> in on that directory and just run the checks there... I can submit a patch for
> this... though I was wondering if there is already a way to do this and I just
> missed it. The thought was to make it work the same way you'd build a module.

I think it is possible, but Nicolas would know better.

julia
