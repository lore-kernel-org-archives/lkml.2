Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753293Ab1E1Gj0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 May 2011 02:39:26 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:43931 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752317Ab1E1GjZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 May 2011 02:39:25 -0400
Date: Sat, 28 May 2011 08:39:19 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: Kees Cook <kees.cook@canonical.com>
Cc: Emese Revfy <re.emese@gmail.com>, linux-kernel@vger.kernel.org,
        cocci@diku.dk
Subject: Re: [Cocci] Re: status of constification
In-Reply-To: <20110528031348.GA19633@outflux.net>
Message-ID: <Pine.LNX.4.64.1105280838150.30088@ask.diku.dk>
References: <20101108223844.GS5876@outflux.net> <4CD9BF25.4090306@gmail.com>
 <20110528031348.GA19633@outflux.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 May 2011, Kees Cook wrote:

> Hi Emese,
> 
> I got distracted, but I'd like to get back to this thread...
> 
> On Tue, Nov 09, 2010 at 10:37:41PM +0100, Emese Revfy wrote:
> > I will gladly break up my current patch for the next -rc by structure
> > type or maintainer (some preferred it one way or the other) and send
> > it in some time next week so that you can handle the upstream submission
> > process (I will continue to maintain my patch in grsecurity).
> > 
> > There are many structures that can be constified, you can use the following
> > command to find most of them (use it on an allyesconfig kernel preferably):
> > 
> > grep _ops System.map |grep -Ewi 'b|d' | awk '{print $3}' | \
> > while read i ; do cscope -d -L -1 $i | grep -E "struct[ \t]*([^ ]*)[ \t]*" \
> > --color=none -o | awk '{print $2}' ; done |sort -u
> > 
> > Also there are always new instances of structures going in that should have
> > been constified.
> 
> Just in my running kernel, I see 56 _ops structures reported from the above
> search. :)
> 
> Do you have a new stack of patches I can help usher into the kernel? I
> don't want reinvent the wheel if I don't have to. :)
> 
> > I tried to automate the whole process with Coccinelle but I abandoned it
> > because Coccinelle didn't support recursive header file inclusion at the time.
> > If someone feels like fixing Coccinelle then I would quickly finish my script
> > (it has a few bugs because I could never test it for real), but see the end
> > of the mail for the current version. I think it would be a good idea because
> > it would take a few hours only to generate a constification patch for a new
> > kernel. One thing that probably cannot be automated with Coccinelle is that
> > once the script determines that a given structure cannot be constified, it
> > cannot undo already emitted patches for the given structure so it must be
> > cleaned up by post processing script.

Could I see the semantic patch?  The clean up issue sounds interesting.  
Perhaps there is a way around it.

julia

> Has there been any update to your Coccinelle script since the addition of
> -recursive_includes?
> 
> Thanks!
> 
> -Kees
> 
> -- 
> Kees Cook
> Ubuntu Security Team
> _______________________________________________
> Cocci mailing list
> Cocci@diku.dk
> http://lists.diku.dk/mailman/listinfo/cocci
> (Web access from inside DIKUs LAN only)
> 
