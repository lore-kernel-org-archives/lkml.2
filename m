Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756657Ab0LMC7P (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 21:59:15 -0500
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:31407 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754844Ab0LMC7N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 21:59:13 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEABkaBU15LdLl/2dsb2JhbACjf3nAUoVKBA
Date: Mon, 13 Dec 2010 13:59:10 +1100
From: Nick Piggin <npiggin@kernel.dk>
To: Ed Tomlinson <edt@aei.ca>
Cc: Nick Piggin <npiggin@kernel.dk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: rcu-walk and dcache scaling tree update and status
Message-ID: <20101213025910.GA6981@amd>
References: <20101213023733.GB6522@amd>
 <201012122153.33427.edt@aei.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201012122153.33427.edt@aei.ca>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 12, 2010 at 09:53:32PM -0500, Ed Tomlinson wrote:
> On Sunday 12 December 2010 21:37:33 Nick Piggin wrote:
> > Final note:
> > You won't be able to reproduce the parallel path walk scalability
> > numbers that I've posted, because the vfsmount refcounting scalability
> > patch is not included. I have a new idea for that now, so I'll be asking
> > for comments with that soon.
> 
> I get this when building:
> 
> security/security.c: In function 'security_inode_exec_permission':
> security/security.c:520: error: 'rcu' undeclared (first use in this function)
> security/security.c:520: error: (Each undeclared identifier is reported only once
> security/security.c:520: error: for each function it appears in.)
> make[1]: *** [security/security.o] Error 1
> make: *** [security] Error 2
> 
> Missing include maybe?

Ah, missed permutation while doing a final build check. `rcu` should
just be renamed to `flags`.

