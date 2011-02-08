Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754045Ab1BHE1Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 23:27:16 -0500
Received: from smtp.outflux.net ([198.145.64.163]:46950 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752563Ab1BHE1P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 23:27:15 -0500
Date: Mon, 7 Feb 2011 20:27:08 -0800
From: Kees Cook <kees.cook@canonical.com>
To: James Morris <jmorris@namei.org>
Cc: linux-kernel@vger.kernel.org, Al Viro <viro@ftp.linux.org.uk>
Subject: Re: [SECURITY] /proc/$pid/ leaks contents across setuid exec
Message-ID: <20110208042708.GG1457@outflux.net>
References: <20110207231416.GD1457@outflux.net>
 <alpine.LRH.2.00.1102081127330.3342@tundra.namei.org>
 <20110208011445.GF1457@outflux.net>
 <alpine.LRH.2.00.1102081437430.3879@tundra.namei.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.00.1102081437430.3879@tundra.namei.org>
Organization: Canonical
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 08, 2011 at 02:43:15PM +1100, James Morris wrote:
> On Mon, 7 Feb 2011, Kees Cook wrote:
> > Sure, I know about O_CLOEXEC, but this is about protecting the
> > just-been-execed setuid process from the attacking process that has no
> > reason to set O_CLOEXEC.
> > 
> > Something like this needs to be enforced on the kernel side. I.e. these
> > file in /proc need to have O_CLOEXEC set in a way that cannot be unset.
> > 
> > > Changing the behavior in the core kernel will break userspace.
> > 
> > I don't think /proc/$pid/* needs to stay open across execs, does it? Or at
> > least the non-0444 files should be handled separately.
> 
> Actually, this seems like a more general kind of bug in proc rather than a 
> leaked fd.  Each child task should only see its own /proc/[pid] data.

Right, that's precisely the problem. The unprivileged process can read
the setuid process's /proc files.

-Kees

-- 
Kees Cook
Ubuntu Security Team
