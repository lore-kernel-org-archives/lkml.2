Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755616Ab1CQVLX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 17:11:23 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39770 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755422Ab1CQVLV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 17:11:21 -0400
Date: Thu, 17 Mar 2011 14:11:08 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: make checkpatch warn about memset with swapped arguments.
Message-Id: <20110317141108.52697d81.akpm@linux-foundation.org>
In-Reply-To: <1300394224.16880.518.camel@gandalf.stny.rr.com>
References: <20110317045209.GA18656@redhat.com>
	<20110317193645.GD14675@home.goodmis.org>
	<20110317200215.GA4084@redhat.com>
	<1300394224.16880.518.camel@gandalf.stny.rr.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Mar 2011 16:37:04 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:

> On Thu, 2011-03-17 at 16:02 -0400, Dave Jones wrote:
> > On Thu, Mar 17, 2011 at 03:36:45PM -0400, Steven Rostedt wrote:
> > 
> >  > > +		if ($line =~ /memset.*\,(\ |)(0x|)0(\ |0|)\);/) {
> >  > 
> >  > Wouldn't this be a better regex:
> >  > 
> >  > 	if ($line =~ /memset.*\,\s*(0x)?0\s*\)\s*;/)
> > 
> > I dunno, regexps are all gobble-de-gook to me.  Why is it better ?
> 
> :) I love regex :)
> 
> But the reason for better is more robust. This will catch other bad
> things users may do, like having tabs and such instead of spaces. Or
> they may have more than one space. Although this should be caught by
> other errors or warnings in checkpatch.
> 
> \s stands for any whitespace, 
> so ",\s*x" is ,[any-amount-of-white-space]x"
> 
> The (0x)? is common for (0x|) in perl, but either is fine. I'm just use
> to the '?' one.
> 

Dave's patch is tested (I assume), so it wins ;)

Maybe it's just me, but I think it would be better to use bzero() for
this operation - it's more readable and it can't be screwed up.  Then
checkpatch checks for memset(xxx, 0, xxx) and for memset(xxx, xxx, 0)
and says "hey, use bzero".  
