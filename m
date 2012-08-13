Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752326Ab2HMNjT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 09:39:19 -0400
Received: from mga11.intel.com ([192.55.52.93]:49570 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752086Ab2HMNjR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 09:39:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,759,1336374000"; 
   d="scan'208";a="199729066"
Date: Mon, 13 Aug 2012 21:39:10 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>, kernel-janitors@vger.kernel.org,
        Greg Ungerer <gerg@uclinux.org>, linux-m68k@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [userns:userns-always-map-user-v45 80/99] fs/namespace.c:2290:1:
 error: unknown type name 'atomic64_t'
Message-ID: <20120813133910.GA30532@localhost>
References: <20120812145023.GA17077@localhost>
 <87k3x3z3de.fsf@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87k3x3z3de.fsf@xmission.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 12, 2012 at 11:56:45PM -0700, Eric W. Biederman wrote:
> Fengguang Wu <fengguang.wu@intel.com> writes:
> 
> > Hi Geert,
> >
> > This is the build error I get, on Eric's userns tree.
> >
> > tree:   git://git.kernel.org/pub/scm/linux/kernel/git/ebiederm/user-namespace.git userns-always-map-user-v45
> > head:   38a0b1b84f5f613ff4e01fffda27f87d4cb2b649
> > commit: 5ea9fc30545b658380d4794340227fe821b83701 [80/99] vfs: Add setns support for the mount namespace
> > config: m68k-m5475evb_defconfig (attached as .config)
> >
> > All related error/warning messages:
> >
> > fs/namespace.c:2290:1: error: unknown type name 'atomic64_t'
> > fs/namespace.c:2290:1: error: implicit declaration of function 'ATOMIC64_INIT' [-Werror=implicit-function-declaration]
> > fs/namespace.c:2290:1: error: initializer element is not constant
> > fs/namespace.c: In function 'alloc_mnt_ns':
> > fs/namespace.c:2299:2: error: implicit declaration of function 'atomic64_add_return' [-Werror=implicit-function-declaration]
> > cc1: some warnings being treated as errors
> 
> Fengguang is m68k the only place you are seeing build failures?

Yes.

> Exactly how I get a 64bit counter in that code path is not terribly
> important.  I picked an atomic64_t because it looked simple and cheap.

Fair enough. As long as it's not in hot code path, it definitely helps
to use simple solutions.

> If this is limited to a couple of m68k sub-arches I will let you guys
> finish fixing this up so people can depend on atomic64_t being
> available.  Otherwise it probably makes sense to go to with a different
> abstraction.

I'd suggest to fix it in m68k and make atomic64_t generally available.

Thanks,
Fengguang
