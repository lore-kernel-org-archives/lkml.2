Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754624Ab1BJCpK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 21:45:10 -0500
Received: from tundra.namei.org ([65.99.196.166]:57013 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750946Ab1BJCpI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 21:45:08 -0500
Date: Thu, 10 Feb 2011 13:44:58 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
cc: Kees Cook <kees.cook@canonical.com>, linux-kernel@vger.kernel.org,
        Al Viro <viro@ftp.linux.org.uk>, Stephen Smalley <sds@tycho.nsa.gov>,
        linux-security-module@vger.kernel.org
Subject: Re: [SECURITY] /proc/$pid/ leaks contents across setuid exec
In-Reply-To: <m1ipwu5lj2.fsf@fess.ebiederm.org>
Message-ID: <alpine.LRH.2.00.1102101337100.19432@tundra.namei.org>
References: <20110207231416.GD1457@outflux.net> <alpine.LRH.2.00.1102081127330.3342@tundra.namei.org> <20110208011445.GF1457@outflux.net> <alpine.LRH.2.00.1102081437430.3879@tundra.namei.org> <20110208042708.GG1457@outflux.net>
 <m1ipwu5lj2.fsf@fess.ebiederm.org>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 Feb 2011, Eric W. Biederman wrote:

> Kees Cook <kees.cook@canonical.com> writes:
> 
> > On Tue, Feb 08, 2011 at 02:43:15PM +1100, James Morris wrote:

> >> > I don't think /proc/$pid/* needs to stay open across execs, does it? Or at
> >> > least the non-0444 files should be handled separately.
> >> 
> >> Actually, this seems like a more general kind of bug in proc rather than a 
> >> leaked fd.  Each child task should only see its own /proc/[pid] data.
> >
> > Right, that's precisely the problem. The unprivileged process can read
> > the setuid process's /proc files.
> 
> If these are things that we actually care about we should sprinkle in a
> few more ptrace_may_access calls into implementations of the relevant
> proc files.

This seems to be papering over a bug.

It is plainly broken to return an access error to a task which is 
legitimately accessing a file.  The task should not receive the wrong 
information from /proc/[pid]/* .


- James
-- 
James Morris
<jmorris@namei.org>
