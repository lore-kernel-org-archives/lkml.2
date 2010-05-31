Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756868Ab0EaR60 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 13:58:26 -0400
Received: from smtp.outflux.net ([198.145.64.163]:55895 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755030Ab0EaR6Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 13:58:24 -0400
Date: Mon, 31 May 2010 10:57:33 -0700
From: Kees Cook <kees.cook@canonical.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, linux-doc@vger.kernel.org,
       Randy Dunlap <rdunlap@xenotime.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jiri Kosina <jkosina@suse.cz>, Dave Young <hidave.darkstar@gmail.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       James Morris <jmorris@namei.org>, Eric Paris <eparis@redhat.com>,
       David Howells <dhowells@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Tim Gardner <tim.gardner@canonical.com>,
       "Serge E. Hallyn" <serue@us.ibm.com>
Subject: Re: [PATCH v2] fs: block cross-uid sticky symlinks
Message-ID: <20100531175733.GD4098@outflux.net>
References: <20100531030402.GQ6056@outflux.net>
 <20100531103510.GA30021@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100531103510.GA30021@infradead.org>
Organization: Canonical
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Christoph,

On Mon, May 31, 2010 at 06:35:10AM -0400, Christoph Hellwig wrote:
> NAK for changing this in core code.  These are long-living and
> documented semantics that we can't simply break, and as Alan mentioned
> having there's good enough workaround that don't break applications.

I totally disagree -- there are no applications that depend on this
behavior in sticky world-writable directories.  Adding this logic (where
ever it lands) fixes /tmp symlink races forever and breaks nothing.

> Feel free to shovel it into the crackpot LSM of your choice.

I have no strong opinion about where it should live.  The strong opinion
I have is that all Linux users, regardless of LSM choice, should benefit
from the fix.

I'd like to separate objections about implementation from objections about
the change in semantics itself.  If every user of Linux gains this symlink
protection, does it matter if it's in core VFS or in commoncaps?

Expecting the push-back from VFS, I wrote this patch against commoncaps.

James, would you take it there (along with the patch to SELinux to call
out to commoncaps) if there is no way to proceed with the VFS core towards
solving this?

Thanks,

-Kees

-- 
Kees Cook
Ubuntu Security Team
