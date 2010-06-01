Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756510Ab0FAWWI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 18:22:08 -0400
Received: from smtp.outflux.net ([198.145.64.163]:58110 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754477Ab0FAWWG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 18:22:06 -0400
Date: Tue, 1 Jun 2010 15:20:03 -0700
From: Kees Cook <kees.cook@canonical.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Eric Paris <eparis@redhat.com>, Christoph Hellwig <hch@infradead.org>,
       James Morris <jmorris@namei.org>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-doc@vger.kernel.org, Randy Dunlap <rdunlap@xenotime.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jiri Kosina <jkosina@suse.cz>, Dave Young <hidave.darkstar@gmail.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       David Howells <dhowells@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Tim Gardner <tim.gardner@canonical.com>,
       "Serge E. Hallyn" <serue@us.ibm.com>
Subject: Re: [PATCH v3] fs: allow protected cross-uid sticky symlinks
Message-ID: <20100601222003.GH4098@outflux.net>
References: <20100601185248.GB4098@outflux.net>
 <20100601190102.GT31073@ZenIV.linux.org.uk>
 <20100601210734.GD4098@outflux.net>
 <20100601214527.GU31073@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100601214527.GU31073@ZenIV.linux.org.uk>
Organization: Canonical
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 01, 2010 at 10:45:27PM +0100, Al Viro wrote:
> On Tue, Jun 01, 2010 at 02:07:34PM -0700, Kees Cook wrote:
> > > I don't buy it.  If we are concerned about the symlinks in the middle of
> > > pathname, your checks are useless (mkdir /tmp/a, ln -s whatever /tmp/a/b,
> > > have victim open /tmp/a/b/something).  If we are not, then your checks are
> > > in the wrong place.
> > 
> > Well, that's not traditionally where the problems happen, but I have no
> > problem strengthening the protection to include a full examination of the
> > entire path looking for sticky/world-writable directories.
> > 
> > If not, what is the right place for the checks?
> 
> Handling of trailing symlink on open().  At most.

What would this look like?  Moving the checks into may_open()?

> And I wouldn't be
> surprised if the real answer turns out to include "... if we have
> O_CREAT in flags", but that needs to be determined.

I think even without O_CREAT the protection is needed (some of the
/tmp-races are things like reading a file pointed to by a symlink and
spewing the contents to stderr, etc).

Thanks,

-Kees

-- 
Kees Cook
Ubuntu Security Team
