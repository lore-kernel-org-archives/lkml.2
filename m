Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756407Ab0FCVBq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 17:01:46 -0400
Received: from smtp.outflux.net ([198.145.64.163]:35338 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751105Ab0FCVBn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 17:01:43 -0400
Date: Thu, 3 Jun 2010 14:00:51 -0700
From: Kees Cook <kees.cook@canonical.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Dave Young <hidave.darkstar@gmail.com>, Al Viro <viro@zeniv.linux.org.uk>,
       Eric Paris <eparis@redhat.com>, Christoph Hellwig <hch@infradead.org>,
       James Morris <jmorris@namei.org>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-doc@vger.kernel.org, Randy Dunlap <rdunlap@xenotime.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jiri Kosina <jkosina@suse.cz>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       David Howells <dhowells@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Tim Gardner <tim.gardner@canonical.com>,
       "Serge E. Hallyn" <serue@us.ibm.com>, tytso@mit.edu,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH v6] fs: allow protected cross-uid sticky symlinks
Message-ID: <20100603210051.GD4714@outflux.net>
References: <20100603080158.GE4971@outflux.net>
 <m11vcnlw9j.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m11vcnlw9j.fsf@fess.ebiederm.org>
Organization: Canonical
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 03, 2010 at 01:02:48PM -0700, Eric W. Biederman wrote:
> Kees Cook <kees.cook@canonical.com> writes:
> > A long-standing class of security issues is the symlink-based
> > time-of-check-time-of-use race, most commonly seen in world-writable
> > directories like /tmp. The common method of exploitation of this flaw
> 
> Nacked-by: "Eric W. Biederman" <ebiederm@xmission.com>
> 
> This approach to fix the problem to of /tmp looks to me like it
> will have the opposite effect.  I think this patch will encourage
> more badly written applications.

How to safely deal with /tmp has been well understood for well over
a decade.  I don't think this change would "encourage" poor code.

> This patch does not actually fix the problem of recurring security
> issues in /tmp.  Fundamentally /tmp is a design flaw. You have
> evidence that even the introduction of the sticky bit, and O_NOFOLLOW
> did not fix this design flaw, I don't see how yet another kernel feature
> will make finally make /tmp secure.  The design flaw in /tmp is that we
> encourage storing files that we care little about (temporary files) in
> a location that is shared between everyone.  From a security point of
> view sharing of files needs to be done very carefully, and as such
> should only be done for files that we really care about and intend to
> share.

I agree about /tmp being perilous.  This change, however, fixes a class of
problems that exist now and has a simple solution.

> Furthermore the set of applications with security problems you are intending
> to address are privileged applications.   There is no excuse not to audit
> and fix those applications.  If you include this patch I see no reason why
> audits won't get more lax and other related security issues won't crop up.

If there were no excuse, then all software would be audited.  This just
isn't the reality of our world.  Auditing is not a binary process and
auditing for security issues is, unfortunately, not a high priority for
many projects or organizations.  If auditing was critically important,
able to find all flaws, and there was no excuse not to do it, then Linux
would never have any security vulnerabilities.  I do not believe in
perfect security; I believe in layered security.  Find and fix what we
can when we can.  This change provides coverage for all software running
on the kernel for this flaw.

> The real solution to this problem of inadvertently sharing things that are
> not safe to be shared is not to have a shared /tmp at all.
> 
> Per user tmp can be as simple as:
> export TMPDIR=$HOME/tmp/
> chmod 0500 /tmp

Again, I agree the traditional /tmp should ultimately go away.  It is,
however, not that simple today.  I'm all for having distros go this
route and fix the various issues surrounding getting rid of the common
/tmp area.  This patch is to solve one specific problem with no trade-off.

> So is your interest in actually fixing this problem, or do you just
> want to encourage more bad applications to be written without worrying
> about inadvertent sharing in /tmp?

I obviously don't believe it is one or the other.  I want to fix /tmp
symlink races today and then see to fixing /tmp sharing next.

-Kees

-- 
Kees Cook
Ubuntu Security Team
