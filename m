Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755226Ab1BVTlf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 14:41:35 -0500
Received: from cantor.suse.de ([195.135.220.2]:37064 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752232Ab1BVTle (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 14:41:34 -0500
Date: Tue, 22 Feb 2011 11:33:14 -0800
From: Greg KH <gregkh@suse.de>
To: Kees Cook <kees.cook@canonical.com>
Cc: linux-kernel@vger.kernel.org, Eugene Teo <eugeneteo@kernel.sg>,
        Ralph Campbell <infinipath@qlogic.com>,
        Roland Dreier <roland@kernel.org>, Sean Hefty <sean.hefty@intel.com>,
        Hal Rosenstock <hal.rosenstock@gmail.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Miklos Szeredi <miklos@szeredi.hu>,
        "J. Bruce Fields" <bfields@fieldses.org>, Neil Brown <neilb@suse.de>,
        Matthew Wilcox <matthew@wil.cx>, James Morris <jmorris@namei.org>,
        Stephen Smalley <sds@tycho.nsa.gov>,
        Eric Paris <eparis@parisplace.org>, Nick Piggin <npiggin@kernel.dk>,
        Arnd Bergmann <arnd@arndb.de>, Ian Campbell <ian.campbell@citrix.com>,
        Jarkko Sakkinen <ext-jarkko.2.sakkinen@nokia.com>,
        Tejun Heo <tj@kernel.org>, Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: [PATCH 2/2] debugfs: only allow root access to debugging
 interfaces
Message-ID: <20110222193314.GA11033@suse.de>
References: <1298398198-18482-1-git-send-email-kees.cook@canonical.com>
 <1298398198-18482-2-git-send-email-kees.cook@canonical.com>
 <20110222181613.GU4000@outflux.net>
 <20110222191333.GA9991@suse.de>
 <20110222192248.GX4000@outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110222192248.GX4000@outflux.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 22, 2011 at 11:22:48AM -0800, Kees Cook wrote:
> On Tue, Feb 22, 2011 at 11:13:33AM -0800, Greg KH wrote:
> > On Tue, Feb 22, 2011 at 10:16:13AM -0800, Kees Cook wrote:
> > > Har har, I forgot --compose to "git send-email".
> > > 
> > > Anyway, with the continuing deluge of bugs in the "debug" filesystem, I
> > > would like to make that filesystem's root directory mode 0700 by default
> > > since it's filled with crazy stuff that regular users do not need to see.
> > 
> > But that will break existing users of this interface, right?
> > 
> > > Better to try to just close the door completely on all the stuff in there.
> > > It is, after all, supposed to only be used for debugging, right?
> > 
> > No, not really, people use it for all sorts of crazy things.
> > 
> > Remember, the only rule in debugfs is:
> > 	There are no rules in debugfs.
> 
> Right, which seems extremely dangerous to me. I think debugfs should either
> be:
>  a) used only by the root user (would prefer this was actually CAP_DEBUG or
>     something)
> or
>  b) used by userspace tools
> 
> But not both. Creating interfaces with no rules for userspace consumption
> is going to lead to disaster. You can't disallow "break[ing] existing
> users of this interface" and say there are no rules at the same time. :)

I'm not going to argue that the wisdom of putting userspace tool
interfaces in debugfs wasn't a bad idea, but that was not for me to
decide, it was the creators of that interface's decision.  And even
then, it was something the evolved over time and I doubt that anyone
when it was first created, would have imagined the perf interface being
in debugfs today.

And even then, there's been a proposal to move that to a new filesystem
which would solve that issue.

I will say that you can not break existing users, as I want all users to
have access to the debugfs files I have created in there for a wide
range of valid reasons.

So no, I'm not going to change the whole filesystem to not allow all
users to access it, that is a per-file/directory decision by the creator
of that file/directory.

Again, let's fix the real problems here, world-writable debugfs files.
Nothing different here from sysfs which had the same issues, just that
no one thought to ask for zillions of CVE entries to panic the world
with when we resolved all of them...

thanks,

greg k-h
