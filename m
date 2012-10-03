Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933000Ab2JCSCR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 14:02:17 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:48762 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932245Ab2JCSCO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 14:02:14 -0400
Date: Wed, 3 Oct 2012 13:02:04 -0500
From: Serge Hallyn <serge.hallyn@canonical.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH] make CONFIG_EXPERIMENTAL invisible and default
Message-ID: <20121003180204.GA23425@sergelap>
References: <20121002195042.GA16087@www.outflux.net>
 <20121003132538.GE13192@linux.vnet.ibm.com>
 <20121003161702.GA22008@kroah.com>
 <20121003164712.GF2527@linux.vnet.ibm.com>
 <20121003172142.GA5061@kroah.com>
 <20121003174621.GJ2527@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121003174621.GJ2527@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Paul E. McKenney (paulmck@linux.vnet.ibm.com):
> On Wed, Oct 03, 2012 at 10:21:42AM -0700, Greg Kroah-Hartman wrote:
> > On Wed, Oct 03, 2012 at 09:47:12AM -0700, Paul E. McKenney wrote:
> > > On Wed, Oct 03, 2012 at 09:17:02AM -0700, Greg Kroah-Hartman wrote:
> > > > On Wed, Oct 03, 2012 at 06:25:38AM -0700, Paul E. McKenney wrote:
> > > > > On Tue, Oct 02, 2012 at 12:50:42PM -0700, Kees Cook wrote:
> > > > > > This config item has not carried much meaning for a while now and is
> > > > > > almost always enabled by default. As agreed during the Linux kernel
> > > > > > summit, it should be removed. As a first step, remove it from being
> > > > > > listed, and default it to on. Once it has been removed from all
> > > > > > subsystem Kconfigs, it will be dropped entirely.
> > > > > > 
> > > > > > CC: Greg KH <gregkh@linuxfoundation.org>
> > > > > > CC: "Eric W. Biederman" <ebiederm@xmission.com>
> > > > > > CC: Serge Hallyn <serge.hallyn@canonical.com>
> > > > > > CC: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> > > > > > CC: Andrew Morton <akpm@linux-foundation.org>
> > > > > > CC: Frederic Weisbecker <fweisbec@gmail.com>
> > > > > > Signed-off-by: Kees Cook <keescook@chromium.org>
> > > > > > ---
> > > > > > 
> > > > > > This is the first of a series of 202 patches removing EXPERIMENTAL from
> > > > > > all the Kconfigs in the tree. Should I send them all to lkml (with all
> > > > > > the associated CCs), or do people want to cherry-pick changes from my
> > > > > > tree? I don't want to needlessly flood the list.
> > > > > > 
> > > > > > http://git.kernel.org/?p=linux/kernel/git/kees/linux.git;a=shortlog;h=refs/heads/experimental
> > > > > > 
> > > > > > I figure this patch can stand alone to at least make EXPERIMENTAL go
> > > > > > away from the menus, and give us a taste of what the removal would do
> > > > > > to builds.
> > > > > 
> > > > > OK, I will bite...  How should I flag an option that is initially only
> > > > > intended for those willing to take some level of risk?
> > > > 
> > > > In the text say "You really don't want to enable this option, use at
> > > > your own risk!"  Or something like that :)
> > > 
> > > OK, so the only real hope for experimental features is to refrain from
> > > creating a config option for them, so that people wishing to use them
> > > must modify the code?  Or is the philosophy that we keep things out of
> > > tree until we are comfortable with distros turning them on?
> > 
> > I think that should have been your philosophy for a long time, as they
> > turn on everything, and I don't blame them.  Why would we have included
> > it in the kernel tree, unless we wanted people to use the option?
> 
> Because some sizeable group of people would like to use the option,
> but it is not helpful to many others?

The way that is worded, that wouldn't sound like CONFIG_EXPERIMENTAL
even if that worked the way we wanted.  Just a clearly worded separate
config option for your feature would be best in that case.  Yes there
are tons of options to wade through, but you can't make
CONFIG_EXPERIMENTAL a binary for what you describe, since the
experimental options i'd want (user namespaces, etc) would not be the
same ones you'd want.

-serge
