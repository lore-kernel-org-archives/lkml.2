Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932488Ab2L1TWA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2012 14:22:00 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:39906 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753857Ab2L1TV5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2012 14:21:57 -0500
Date: Fri, 28 Dec 2012 19:21:52 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Vasily Kulikov <segoon@openwall.com>
Cc: kernel-hardening@lists.openwall.com,
        Containers <containers@lists.linux-foundation.org>,
        "Serge E. Hallyn" <serge.hallyn@ubuntu.com>,
        linux-kernel@vger.kernel.org,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH/RFC] user_ns: fix missing limiting of user_ns counts
Message-ID: <20121228192152.GA4939@ZenIV.linux.org.uk>
References: <20121228175627.GA7683@cachalot>
 <20121228184334.GZ4939@ZenIV.linux.org.uk>
 <20121228190435.GA8690@cachalot>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121228190435.GA8690@cachalot>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 28, 2012 at 11:04:35PM +0400, Vasily Kulikov wrote:

> > I'm sorry, but this is not a solution.  Kernel is not x86-only; there are
> > architectures with far bigger minimal stack frame size.  E.g. on sparc64
> > every fucking stack frame is at least 176 bytes.  So your 100 calls deep
> > call chain will happily overflow the damn stack all by itself - kernel
> > stack on sparc64 is 16Kb total, including struct thread_info living there.
> 
> Understood.  How to properly fix it then?  Looks like there are quite
> many kernel structures which may reference other structures which
> indirectly reference each other via kref, IOW it is not user_ns specific
> issue.  With unprivileged user_ns the way it should be freed must be
> somehow changed.

	There are many damn good reasons why kref should *not* be used without
thinking.  It's been oversold as easy solution to all refcounting problems;
it isn't one.  Don't use it here.
