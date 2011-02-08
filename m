Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754591Ab1BHBOt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 20:14:49 -0500
Received: from smtp.outflux.net ([198.145.64.163]:33063 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753313Ab1BHBOs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 20:14:48 -0500
Date: Mon, 7 Feb 2011 17:14:45 -0800
From: Kees Cook <kees.cook@canonical.com>
To: James Morris <jmorris@namei.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [SECURITY] /proc/$pid/ leaks contents across setuid exec
Message-ID: <20110208011445.GF1457@outflux.net>
References: <20110207231416.GD1457@outflux.net>
 <alpine.LRH.2.00.1102081127330.3342@tundra.namei.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.00.1102081127330.3342@tundra.namei.org>
Organization: Canonical
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi James,

On Tue, Feb 08, 2011 at 11:44:40AM +1100, James Morris wrote:
> On Mon, 7 Feb 2011, Kees Cook wrote:
> 
> > $ ./procleak.py auxv,syscall /usr/bin/passwd
> > running
> > AT_BASE:   0x7f2828bde000
> > AT_RANDOM: 0x7fff80bde7c9
> > Changing password for kees.
> > (current) UNIX password: 0 0x0 0x7fff80bdda90 0x1ff 0x7fff80bdd580 0x7f2828dc57c0 0x7f28287cec1d 0x7fff80bdd088 0x7f28282fe6c0
> > 
> > There needs to be some way to break the connection to these files across
> > the setuid exec, or perform some sort of revalidation of permissions. (Maybe
> > check dumpable?)
> 
> The way to do this is to set O_CLOEXEC.

Sure, I know about O_CLOEXEC, but this is about protecting the
just-been-execed setuid process from the attacking process that has no
reason to set O_CLOEXEC.

Something like this needs to be enforced on the kernel side. I.e. these
file in /proc need to have O_CLOEXEC set in a way that cannot be unset.

> Changing the behavior in the core kernel will break userspace.

I don't think /proc/$pid/* needs to stay open across execs, does it? Or at
least the non-0444 files should be handled separately.

-Kees

-- 
Kees Cook
Ubuntu Security Team
