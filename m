Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752740Ab0FGQoH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 12:44:07 -0400
Received: from smtp.outflux.net ([198.145.64.163]:56610 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752343Ab0FGQoF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 12:44:05 -0400
Date: Mon, 7 Jun 2010 09:42:57 -0700
From: Kees Cook <kees.cook@canonical.com>
To: Valdis.Kletnieks@vt.edu
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Dave Young <hidave.darkstar@gmail.com>,
       Al Viro <viro@zeniv.linux.org.uk>, Eric Paris <eparis@redhat.com>,
       Christoph Hellwig <hch@infradead.org>, James Morris <jmorris@namei.org>,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, linux-doc@vger.kernel.org,
       Randy Dunlap <rdunlap@xenotime.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jiri Kosina <jkosina@suse.cz>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       David Howells <dhowells@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Tim Gardner <tim.gardner@canonical.com>,
       "Serge E. Hallyn" <serue@us.ibm.com>, tytso@mit.edu,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH v6] fs: allow protected cross-uid sticky symlinks
Message-ID: <20100607164257.GD6839@outflux.net>
References: <20100603080158.GE4971@outflux.net>
 <m11vcnlw9j.fsf@fess.ebiederm.org>
 <20100603210051.GD4714@outflux.net>
 <6305.1275927536@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6305.1275927536@localhost>
Organization: Canonical
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 07, 2010 at 12:18:56PM -0400, Valdis.Kletnieks@vt.edu wrote:
> On Thu, 03 Jun 2010 14:00:51 PDT, Kees Cook said:
> > On Thu, Jun 03, 2010 at 01:02:48PM -0700, Eric W. Biederman wrote:
> > > Kees Cook <kees.cook@canonical.com> writes:
> > > > A long-standing class of security issues is the symlink-based
> > > > time-of-check-time-of-use race, most commonly seen in world-writable
> > > > directories like /tmp. The common method of exploitation of this flaw
> > > 
> > > Nacked-by: "Eric W. Biederman" <ebiederm@xmission.com>
> > > 
> > > This approach to fix the problem to of /tmp looks to me like it
> > > will have the opposite effect.  I think this patch will encourage
> > > more badly written applications.
> > 
> > How to safely deal with /tmp has been well understood for well over
> > a decade.  I don't think this change would "encourage" poor code.
> 
> The fact that you're proposing this patch a decade after we "well understood"
> the problem should suggest that it *will* encourage poor code, as the same
> programmers who don't currently get it right (and are thus the targets of your
> patch) will quite likely just say "Oh, I saw a patch for that, I don't have to
> try to do it right..."

This objection and its rebuttal are entirely conjecture and I don't think
it matters since we can never know the objective truth about the education
or motivation of nameless coders.  That said, I would assume that anyone
well-educated enough about /tmp races to think "oh I saw a kernel patch
for that" was either going to get it right to begin with or was going to
ignore best practices anyway.  The issue is more about the people that
just don't think about it at all.  I would argue that people are still
doing it, for over a decade, when it's still vulnerable, is evidence
that it is not something that will improve.

-Kees

-- 
Kees Cook
Ubuntu Security Team
