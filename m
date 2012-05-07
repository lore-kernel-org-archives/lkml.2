Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757787Ab2EGVD5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 17:03:57 -0400
Received: from smtp.snhosting.dk ([87.238.248.203]:45132 "EHLO
	smtp.domainteam.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757550Ab2EGVD4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 17:03:56 -0400
Date: Mon, 7 May 2012 23:03:55 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [patch 01/18] fork: Remove the weak insanity
Message-ID: <20120507210355.GA10761@merkur.ravnborg.org>
References: <20120505150007.543515803@linutronix.de> <20120505150141.306358267@linutronix.de> <20120505155824.GA14468@merkur.ravnborg.org> <alpine.LFD.2.02.1205072243500.6271@ionos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1205072243500.6271@ionos>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 07, 2012 at 10:55:18PM +0200, Thomas Gleixner wrote:
> On Sat, 5 May 2012, Sam Ravnborg wrote:
> 
> > On Sat, May 05, 2012 at 03:05:40PM -0000, Thomas Gleixner wrote:
> > > We error out when compiling with gcc4.1.[01] as it miscompiles
> > > __weak. The workaround with magic defines is not longer
> > > necessary. Make it __weak again.
> > 
> > The cleanup is much appreciated!
> > 
> > But the magic defines is IMO much better than the CONFIG_ based approach
> > that this patch-set introduces in the last patch.
> > 
> > If you do:
> > 
> >     $git grep arch_task_cache_init
> > 
> > Then if you see:
> > 
> >     #define arch_task_cache_init arch_task_cache_init
> > 
> > Then you know alrady that this arch will provide a local implementation
> > of arch_task_cache_init().
> > No need to grep for an ARCH_XXX symbol that you need to look up
> > somewhere else.
> 
> I'm not following that argument.
> 
> Removing that magic define thing does not change anything. The change
> is:
...
> 
> Now for the last patch in the series:
> 
> It merily moves 
> 
> #define __HAVE_ARCH_THREAD_INFO_ALLOCATOR 
> 
> to a Kconfig based
> 
>    select ARCH_THREAD_INFO_ALLOCATOR

The point was that rather than using a Kconfig symbol for this the
architecutres that required a dedicated implementation could do the:

    #define foo foo

trick.


And the generic implmentation should then do:
#ifndef foo
void foo(int bar)
{
}
#endif

You are right that the archs implmenting foo() will stand
out in the grep anyway.
But using the define trick you do not spread it up to the Kconfig level,
for individual functions.

	Sam
