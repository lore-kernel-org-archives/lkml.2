Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752509Ab1BHDnX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 22:43:23 -0500
Received: from tundra.namei.org ([65.99.196.166]:40194 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750758Ab1BHDnW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 22:43:22 -0500
Date: Tue, 8 Feb 2011 14:43:15 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: Kees Cook <kees.cook@canonical.com>
cc: linux-kernel@vger.kernel.org, Al Viro <viro@ftp.linux.org.uk>
Subject: Re: [SECURITY] /proc/$pid/ leaks contents across setuid exec
In-Reply-To: <20110208011445.GF1457@outflux.net>
Message-ID: <alpine.LRH.2.00.1102081437430.3879@tundra.namei.org>
References: <20110207231416.GD1457@outflux.net> <alpine.LRH.2.00.1102081127330.3342@tundra.namei.org> <20110208011445.GF1457@outflux.net>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 7 Feb 2011, Kees Cook wrote:

> Sure, I know about O_CLOEXEC, but this is about protecting the
> just-been-execed setuid process from the attacking process that has no
> reason to set O_CLOEXEC.
> 
> Something like this needs to be enforced on the kernel side. I.e. these
> file in /proc need to have O_CLOEXEC set in a way that cannot be unset.
> 
> > Changing the behavior in the core kernel will break userspace.
> 
> I don't think /proc/$pid/* needs to stay open across execs, does it? Or at
> least the non-0444 files should be handled separately.

Actually, this seems like a more general kind of bug in proc rather than a 
leaked fd.  Each child task should only see its own /proc/[pid] data.



- James
-- 
James Morris
<jmorris@namei.org>
