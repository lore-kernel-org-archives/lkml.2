Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755910Ab0FQVwV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 17:52:21 -0400
Received: from smtp.outflux.net ([198.145.64.163]:39617 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752632Ab0FQVwS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 17:52:18 -0400
Date: Thu, 17 Jun 2010 14:51:05 -0700
From: Kees Cook <kees.cook@canonical.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Randy Dunlap <rdunlap@xenotime.net>, James Morris <jmorris@namei.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Jiri Kosina <jkosina@suse.cz>, Dave Young <hidave.darkstar@gmail.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Roland McGrath <roland@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, David Howells <dhowells@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "Eric W. Biederman" <ebiederm@xmission.com>, linux-doc@vger.kernel.org,
       Stephen Smalley <sds@tycho.nsa.gov>, Daniel J Walsh <dwalsh@redhat.com>,
       linux-security-module@vger.kernel.org
Subject: Re: [PATCH] ptrace: allow restriction of ptrace scope
Message-ID: <20100617215105.GB24749@outflux.net>
References: <20100616221833.GM24749@outflux.net>
 <20100617000120.13071be8@lxorguk.ukuu.org.uk>
 <20100616232230.GP24749@outflux.net>
 <alpine.LRH.2.00.1006172336390.17282@tundra.namei.org>
 <20100617170453.GV24749@outflux.net>
 <20100617215349.2fac02f5@lxorguk.ukuu.org.uk>
 <20100617140630.c6ced27a.rdunlap@xenotime.net>
 <20100617221815.68ce30c5@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100617221815.68ce30c5@lxorguk.ukuu.org.uk>
Organization: Canonical
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 17, 2010 at 10:18:15PM +0100, Alan Cox wrote:
> > > Thats a nonsensical configuration so we don't care. If you are using
> > > SELinux you just do it via SELinux. If you are doing it via
> > > UbuntuHasToBeDifferent then you do it via that.
> > 
> > 
> > Well, surely there are people who use something other than Ubuntu
> > and also care about not using SELinux... eh?
> 
> Then they can load UbuntuSecurity and use that, just enabling the
> features they want.
> 
> I'm not against the Ubuntu stuff getting beaten into a security module
> and put where it belongs. Far from it - I just want to see it put where
> it belongs, which is not junk randomly spewed over the tree. Doubly so
> when they do it wrong *because* they are not using the security hooks.
> 
> It seems pretty easy to me. Kees needs to package up the grsecurity
> features that Ubuntu thinks are valuable into security/something/... with
> a set of sysfs entries to turn on/off the various features. Ubuntu is
> happy, people who want a simple set of sysfs feature controls for
> security are happy and nobody else will even notice.
> 
> It'll appeal to some people because it looks easy to work and it won't
> upset anyone else because its all nicely filed away where it belongs.

If all I cared about was the default Ubuntu distro, I wouldn't forward
these patches at all.  As it turns out, I care about all kinds of
configurations, e.g. people using SELinux on Ubuntu, AppArmor on SUSE,
no LSM on Fedora, grsecurity on Gentoo, or TOMOYO on Debian.  There are
all kinds of combinations, obviously, and I'm interested in making this
stuff available to anyone and everyone.

The "just use SELinux" reply is tiresome.  If "everyone" used SELinux,
there wouldn't be at least 3 other LSMs under active development.
Ignore that my email ends in "@canonical.com", as it seems to be
distracting these discussions.

The PTRACE, symlink, and other stuff are features people want.  If the
point of your argument is that the logic and configuration for each
of these features should be added to every LSM, that's not sensible.
An end user should be able to pick and choose what they want.  If I
create the security/hideous/ LSM tree, it would _exclude_ the ability to
use TOMOYO or Smack or SELinux or AppArmor.

At present, I'm aware of global PTRACE control being possible in SELinux,
AppArmor, grsecurity, and as a patch in Ubuntu's kernel.  I don't know
about TOMOYO or Smack, but configuring the default scope of PTRACE in
at least 4 different ways so far (or not being able to change it at all)
just seems crazy.

If the security API allowed the end user to pick and choose the features
they wanted, then those features would be developed in a single place
and configured in a single way.  Since that's not possible, I'm proposing
these features be central, and configured via /proc/sys.

-Kees

-- 
Kees Cook
Ubuntu Security Team
