Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933118Ab0FQRAy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 13:00:54 -0400
Received: from smtp.outflux.net ([198.145.64.163]:34829 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933084Ab0FQRAx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 13:00:53 -0400
Date: Thu, 17 Jun 2010 09:59:40 -0700
From: Kees Cook <kees.cook@canonical.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: linux-kernel@vger.kernel.org, Randy Dunlap <rdunlap@xenotime.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jiri Kosina <jkosina@suse.cz>, Dave Young <hidave.darkstar@gmail.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Roland McGrath <roland@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, David Howells <dhowells@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       linux-doc@vger.kernel.org
Subject: Re: [PATCH] ptrace: allow restriction of ptrace scope
Message-ID: <20100617165940.GU24749@outflux.net>
References: <20100616221833.GM24749@outflux.net>
 <m1hbl1eta6.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1hbl1eta6.fsf@fess.ebiederm.org>
Organization: Canonical
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Jun 17, 2010 at 05:29:53AM -0700, Eric W. Biederman wrote:
> Kees Cook <kees.cook@canonical.com> writes:
> > running state of any of their processes. For example, if one application
> > (e.g. Pidgin) was compromised, it would be possible for an attacker to
> > attach to other running processes (e.g. Firefox, SSH sessions, GPG agent,
> > etc) to extract additional credentials and continue to expand the scope
> > of their attack without resorting to user-assisted phishing.
> 
> This is ineffective.  As an attacker after I gain access to a users
> system on ubuntu I can wait around until a package gets an update,
> and then run sudo and gain the power to do whatever I want.

I doesn't stop phishing, correct.  But it does stop immediate expansion of
an attack using already-existing credentials.

> Either that or I can inject something nasty into the suid pulse-audio.

Hmm?

$ ls -la /usr/bin/pulseaudio
-rwxr-xr-x 1 root root 71712 2010-06-10 11:59 /usr/bin/pulseaudio

But I take your meaning to be "can still exploit other vulnerabilities".
That'll always be true, but that's why I'm looking to make the attack
surface smaller.

> I tell you what.  If you really want something effective, help Serge
> and I finish getting the cross namespace issues fixed for the user
> namespace.  When complete, it will possible for an unprivileged process
> to create a new one, and since kernel capabilities along with everything
> else will be local to it, running pidgin, or firefox, or another network
> facing potentially buggy application in such a namespace will ensure that
> even if the process is compromised it won't have privileges to ptrace another
> process or do much else on the system.

It sounds pretty good, but isolating desktop applications is no simple
task.  They tend to like to have free reign over a user's entire home
directory.  But I think that's a bit of a tangent.  That said, I'd like to
know more; where can I find details?

I'm all for better separations.  In fact, I'd like to see /proc/sys using
caps instead of DAC so that containers mounting /proc can't fiddle with the
entire system.  Has anyone done anything with this?  It seems like it's
only seen sporadic attention (e.g. my patch to test CAP_SYS_RAWIO for
changing mmap_min_addr).  I would assume there are others that need a
similar protection?

-Kees

-- 
Kees Cook
Ubuntu Security Team
