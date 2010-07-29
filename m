Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757801Ab0G2XEW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jul 2010 19:04:22 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:35653 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757389Ab0G2XEV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jul 2010 19:04:21 -0400
Date: Fri, 30 Jul 2010 01:04:19 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Aristeu Rozanski <aris@redhat.com>
Cc: Michal Marek <mmarek@suse.cz>, lkml <linux-kernel@vger.kernel.org>,
        linux-kbuild <linux-kbuild@vger.kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Roman Zippel <zippel@linux-m68k.org>,
        Uwe Kleine-Koig <u.kleine-koenig@pengutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC PATCH] kconfig: use long options in conf
Message-ID: <20100729230419.GA9357@merkur.ravnborg.org>
References: <20100725214021.GD5834@merkur.ravnborg.org> <4C4EFE80.7050808@suse.cz> <20100728203622.GA32086@merkur.ravnborg.org> <20100729081316.GA4990@merkur.ravnborg.org> <4C5148A5.10809@suse.cz> <20100729144748.GI6249@redhat.com> <4C519899.9020206@suse.cz> <20100729151650.GA20261@redhat.com> <20100729193454.GC7877@merkur.ravnborg.org> <20100729195052.GB20261@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100729195052.GB20261@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 29, 2010 at 03:50:52PM -0400, Aristeu Rozanski wrote:
> On Thu, Jul 29, 2010 at 09:34:55PM +0200, Sam Ravnborg wrote:
> > If you have a simple command that give you a list of new
> > symbols then this is easy to script as Michal also
> > shows with the below example.
> > 
> > > > How about
> > > > new=$(make listnewconfig)
> > > > if test -n "$new"; then
> > > >     echo "Please set the following options:" >&2
> > > >     echo "$new" >&2
> > > >     exit 1
> > > > fi
> > > > ? Wouldn't that be the same as nonint_oldconfig before?
> > > what's the other use cases for listnewconfig (other than a incomplete
> > > nonint_oldconfig)?
> > 
> > listnewconfig is for everyone that like to see a list of new
> > config options - without touching the current configuration.
> > 
> > By limiting listnewconfig to do only one thing you actually
> > create further uses than before.

First off let me correct myself.
nonint_oldconfig does the following:
- print any new options to stderr
- if tere are any new options exit with exit code 2
- it does _not_ touch the current configuration (as I wrongly implied above)

listnewconfig does the following:
- print any new options to stdout
- return with exit code 0 (success)
- it does not touch the current configuration

So the change we discuss is only the exit code.
You indicated you were OK with the name change,
and I assume the change from stderr => stdout is OK too.

> > 
> > This is not about how well it applies to the tailored
> > use in redhat's current scripts.
> *sigh* I think we have people able to handle such complex changes.
> 
> this is not what it's about. I don't care how it's called or if scripts
> will need to be changed. What I want to know is if either:
> a) we're reducing functionality of something in order to support more *real*
>    use cases with the same code, making it more generic;
> or
> b) we're reducing functionality based in theorical use cases.
> 
> if it's (a), you get my ACK

I can try to come up with some use cases that I consider real...

a) List the number of new options after I upgraded my kernel.
   It can be used to judge the amount of time used to answer
   oldconfig manually.
   If make tells me that conf had an exit code != success how
   do I then know the list is complete?

b) List the number of new options when I bring in an old config.
   Same comment as in a) about the exit code.

c) List the options I need to carefully lookup to judge what to do about them.
   A variant of a) and b) - the one I expect all distributions uses in some way.
   [scripts/diffconfig is one way]

d) We can use listnewconfig in scripts without failing due to
   conf exit with an error code when there are new options.
   And use of stdout is thus more convinient.
   [And I know the counter argument is that with the exit code it is easy
   to judge if there is any new options].


I hope this shows enough examples that you consider in the _real_
category that you can give it your ack.

	Sam
