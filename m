Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759705Ab0FPXXM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 19:23:12 -0400
Received: from smtp.outflux.net ([198.145.64.163]:48865 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759427Ab0FPXXK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 19:23:10 -0400
Date: Wed, 16 Jun 2010 16:22:30 -0700
From: Kees Cook <kees.cook@canonical.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org, Randy Dunlap <rdunlap@xenotime.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jiri Kosina <jkosina@suse.cz>, Dave Young <hidave.darkstar@gmail.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Roland McGrath <roland@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, David Howells <dhowells@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "Eric W. Biederman" <ebiederm@xmission.com>, linux-doc@vger.kernel.org
Subject: Re: [PATCH] ptrace: allow restriction of ptrace scope
Message-ID: <20100616232230.GP24749@outflux.net>
References: <20100616221833.GM24749@outflux.net>
 <20100617000120.13071be8@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100617000120.13071be8@lxorguk.ukuu.org.uk>
Organization: Canonical
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alan,

On Thu, Jun 17, 2010 at 12:01:20AM +0100, Alan Cox wrote:
> > As Linux grows in popularity, it will become a larger target for
> > malware. One particularly troubling weakness of the Linux process
> > interfaces is that a single user is able to examine the memory and
> > running state of any of their processes. For example, if one application
> 
> And this will help how - or don't you care about procfs.

I'm not sure I follow this comment.  Sensitive things in /proc/$PID/* are
already protected by ptrace_may_access() with mode == ATTACH.

> Other distributions do this sensibly by using things like SELinux which
> can describe the relationships in ways that matter and also arbitrate
> other access paths beyond ptrace which can be used for the same purpose.

Certainly.  PTRACE can already be confined by SELinux and AppArmor.  I'm
looking for a general approach that doesn't require a system builder to
create MAC policies for unknown software.  I want to define a common core
behavior.

> And even if you don't care about using the same security stuff the rest
> of the world is using to solve the problem this like the other half baked
> stuff you posted for links belongs as a security module.

The LSM isn't stackable, so I can't put it there and choose this and
SELinux (for the case of software-without-a-policy).

> If you'd put it all in security/ubuntu/grsecurity or similar probably
> nobody would care too much. The hooks are there so you can do different
> things with security policy without making a mess for anyone else.

I'm not clear how this is "a mess for anyone else" when it defaults to
the classic PTRACE behavior.  PTRACE itself is dangerous, so it's not
unreasonable to start inching away from it.

> So NAK. If you want to use bits of grsecurity then please just write
> yourselves a grsecurity kernel module that uses the security hooks
> properly and stop messing up the core code. It's all really quite simple,
> the infrastrucuture is there, so use it.

There is no infrastructure to selectively choose these general-purpose
features.  This is why there is a sysctl.  It's a global behavioral
change.

Since LSMs aren't arbitrarily stackable, asking me to move the code into
a new LSM isn't a particularly actionable suggestion.

-Kees

-- 
Kees Cook
Ubuntu Security Team
