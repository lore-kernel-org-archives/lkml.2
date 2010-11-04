Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753203Ab0KDVgW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 17:36:22 -0400
Received: from 1wt.eu ([62.212.114.60]:46911 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752574Ab0KDVgV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 17:36:21 -0400
Date: Thu, 4 Nov 2010 22:29:20 +0100
From: Willy Tarreau <w@1wt.eu>
To: Ingo Molnar <mingo@elte.hu>
Cc: Marcus Meissner <meissner@suse.de>, security@kernel.org, mort@sgi.com,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, fweisbec@gmail.com,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        jason.wessel@windriver.com, tj@kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Security] [PATCH] kernel: make /proc/kallsyms mode 400 to reduce ease of attacking
Message-ID: <20101104212920.GA31256@1wt.eu>
References: <20101104100914.GC25118@suse.de> <20101104114648.GA23381@elte.hu> <20101104122906.GH25118@suse.de> <20101104135802.GA31416@elte.hu> <20101104141104.GA31753@elte.hu> <20101104143322.GL25118@suse.de> <20101104190804.GA16099@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101104190804.GA16099@elte.hu>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 04, 2010 at 08:08:04PM +0100, Ingo Molnar wrote:
> 
> * Marcus Meissner <meissner@suse.de> wrote:
> 
> > > For example, on a Fedora testbox i have this version info:
> > > 
> > >   $ uname -r
> > >   2.6.35.6-48.fc14.x86_64
> > > 
> > > Any attacker can download that rpm from:
> > > 
> > >   http://download.fedora.redhat.com/pub/fedora/linux/updates/14/x86_64/kernel-2.6.35.6-48.fc14.x86_64.rpm
> > > 
> > > And can extract the System.map from it, using rpm2cpio and cpio -i -d. That will 
> > > include all the symbol addresses - without the attacker having any access to the 
> > > System.map or /proc/kallsyms on this particular box.
> > > 
> > > I.e. on distro kernel installations (which comprise the _vast_ majority of our 
> > > userbase) your patch brings little security benefits.
> > > 
> > > What i suggested in later parts of my mail might provide more security: to 
> > > sandbox kernel version information from unprivileged user-space - if we decide 
> > > that we want to sandbox kernel version information ...
> > > 
> > > That is a big if, because it takes a considerable amount of work. Would be worth 
> > > trying it - but feel-good non-solutions that do not bring much improvement to 
> > > the majority of users IMHO hinder such efforts.
> > 
> > Hiding the OS version is really quite hard I think.
> 
> Yes. Hard but it would be useful - especially if we start adding things like known 
> exploit honeypots. Forcing attackers to probe the kernel by actually running a 
> kernel exploit, and risking an alarm would be a very powerful security feature.
> 
> Removing version info will upset some tools/libraries that rely on kernel version 
> information for quirks though.

Quite honnestly, it's the worst idea I've ever read to protect the kernel.
Kernel version is needed at many places, when building some code which relies
on presence of syscall X or Y depending on a version, etc... If our kernel is
so buggy that we can only rely on its version to be kept secret, then we have
already failed.

The kernel version should not be a secret, and anyway there are many ways to
guess it. And judging by past exploits, some of them work on a wide variety
of kernels so that's often pointless. It's just like when admins used to hide
their product names from HTTP response headers, this did not stop exploits at
all because there were always ways to guess the information.

Also, keep in mind that the most info you'll hide from unprivileged users,
the more you'll need root access for anything, which is a lot worse. On
systems that are secured that way, there are sudoers for everyone to do
anything (even ping). This becomes unmanageable and that opens even more
flaws in the whole system. We'll be proud of saying that those are not
kernel issues anymore but management issues but it's a bit easy to point
the finger at the poor guy who tries to keep his system usable despite
our efforts not to do so. And BTW, yes I *do* have access to such a system
where sudo is required for many things and some flaws already give me root
access.

When you secure an environment too much, users build a sub-environment inside
it with lower controls. It's common to see one user provide a complete tool
suite to other users because nothing was installed for fear of opening a hole.
But when you provide all the tools to everyone with you own account, it's just
as if you were root. So that's just pushing the problem somewhere else.

Focusing on ways to make the kernel more reliable when some information is
known is more efficient than trying to hide that information and relying on
this fact.

Willy

