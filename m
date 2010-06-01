Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754480Ab0FADZ0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 23:25:26 -0400
Received: from smtp.outflux.net ([198.145.64.163]:47159 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755316Ab0FADZV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 23:25:21 -0400
Date: Mon, 31 May 2010 20:24:23 -0700
From: Kees Cook <kees.cook@canonical.com>
To: James Morris <jmorris@namei.org>
Cc: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-doc@vger.kernel.org, Randy Dunlap <rdunlap@xenotime.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jiri Kosina <jkosina@suse.cz>, Dave Young <hidave.darkstar@gmail.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Eric Paris <eparis@redhat.com>, David Howells <dhowells@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Tim Gardner <tim.gardner@canonical.com>,
       "Serge E. Hallyn" <serue@us.ibm.com>
Subject: Re: [PATCH v2] fs: block cross-uid sticky symlinks
Message-ID: <20100601032423.GL4098@outflux.net>
References: <20100531030402.GQ6056@outflux.net>
 <20100531103510.GA30021@infradead.org>
 <20100531175733.GD4098@outflux.net>
 <alpine.LRH.2.00.1006010904190.675@tundra.namei.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.00.1006010904190.675@tundra.namei.org>
Organization: Canonical
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 01, 2010 at 09:09:10AM +1000, James Morris wrote:
> On Mon, 31 May 2010, Kees Cook wrote:
> 
> > Expecting the push-back from VFS, I wrote this patch against commoncaps.
> > 
> > James, would you take it there (along with the patch to SELinux to call
> > out to commoncaps) if there is no way to proceed with the VFS core towards
> > solving this?
> 
> Isn't this just bypassing the VFS objections?

Well, that's what I'm trying to understand.  It sounds like there is some
general agreement that the issue needs to be solved, but some folks do not
want it in the core VFS.  As in, the objections aren't with how symlink
behavior is changed, just that the changes would be in the fs/ directory.

My rationale is that if it's in commoncaps, it's effective for everyone, so
it might as well be in core VFS.  If the VFS objections really do boil down
to "not in fs/" then I'm curious if doing this in commoncaps is acceptable.

Ironically, doing this in commoncaps is the patch I sent.  :P

To me, the VFS objections really seem like a obfuscated version of
"this should not be in the kernel in any way", which I think does not
admit to the problem existing in the first place.  Either there is a
problem or there isn't.  If there is a problem, it should be fixed.
I think there is a problem with the kernel semantics of symlinks.
Therefore, it should be fixed in the kernel.

I personally do not care if it's in fs/ or security/, I'm just seeking
the most efficient and complete solution.

-Kees

-- 
Kees Cook
Ubuntu Security Team
