Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757433Ab0G2Te5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jul 2010 15:34:57 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:47519 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755163Ab0G2Te4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jul 2010 15:34:56 -0400
Date: Thu, 29 Jul 2010 21:34:55 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Aristeu Rozanski <aris@redhat.com>
Cc: Michal Marek <mmarek@suse.cz>, lkml <linux-kernel@vger.kernel.org>,
        linux-kbuild <linux-kbuild@vger.kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Roman Zippel <zippel@linux-m68k.org>,
        Uwe Kleine-Koig <u.kleine-koenig@pengutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC PATCH] kconfig: use long options in conf
Message-ID: <20100729193454.GC7877@merkur.ravnborg.org>
References: <20100725213808.GA5814@merkur.ravnborg.org> <20100725214021.GD5834@merkur.ravnborg.org> <4C4EFE80.7050808@suse.cz> <20100728203622.GA32086@merkur.ravnborg.org> <20100729081316.GA4990@merkur.ravnborg.org> <4C5148A5.10809@suse.cz> <20100729144748.GI6249@redhat.com> <4C519899.9020206@suse.cz> <20100729151650.GA20261@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100729151650.GA20261@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Aristeu.

> > >>> nonint_oldconfig:
> > >>> - renamed to listnewconfig
> > >>> - print new options to stdout (to better support redirect)
> > >>> - no longer saves a new configuration
> > >>> - does ot exist with a failure code if there is new options
> > > but this kills its usefulness. nonint_oldconfig is used so you can script
> > > the use of a generated configuration (think distro kernel RPMs). if something
> > > is not set, it fails listing what's not set. otherwise it'll save the
> > > configuration and whatever script is using it can proceed.
> > > "listnewconfig" is a new, different target to me.

If you have a simple command that give you a list of new
symbols then this is easy to script as Michal also
shows with the below example.

> > How about
> > new=$(make listnewconfig)
> > if test -n "$new"; then
> >     echo "Please set the following options:" >&2
> >     echo "$new" >&2
> >     exit 1
> > fi
> > ? Wouldn't that be the same as nonint_oldconfig before?
> what's the other use cases for listnewconfig (other than a incomplete
> nonint_oldconfig)?

listnewconfig is for everyone that like to see a list of new
config options - without touching the current configuration.

By limiting listnewconfig to do only one thing you actually
create further uses than before.

This is not about how well it applies to the tailored
use in redhat's current scripts.
This is about creating a command which by doing only
a single thing (and to do so well) allows others
to utilize this.

	Sam
