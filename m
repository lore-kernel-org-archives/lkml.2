Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754234Ab1GRUxB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jul 2011 16:53:01 -0400
Received: from smtp.snhosting.dk ([87.238.248.203]:54510 "EHLO
	smtp.domainteam.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753873Ab1GRUw7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jul 2011 16:52:59 -0400
Date: Mon, 18 Jul 2011 22:52:57 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: David Miller <davem@davemloft.net>
Cc: sfr@canb.auug.org.au, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the final tree
Message-ID: <20110718205257.GA2537@merkur.ravnborg.org>
References: <20110718193053.623d28dc4643ab488b6347d5@canb.auug.org.au> <20110718.105821.1680531803712429890.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110718.105821.1680531803712429890.davem@davemloft.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 18, 2011 at 10:58:21AM -0700, David Miller wrote:
> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Mon, 18 Jul 2011 19:30:53 +1000
> 
> > After merging the final tree, today's linux-next build (sparc64 defconfig)
> > failed like this:
> > 
> > In file included from arch/sparc/include/asm/pgtable.h:4:0,
> >                  from include/linux/mm.h:41,
> >                  from include/linux/fs.h:395,
> >                  from include/linux/compat.h:15,
> >                  from arch/sparc/include/asm/siginfo.h:19,
> >                  from include/linux/signal.h:5,
> >                  from include/linux/sched.h:73,
> >                  from arch/sparc/kernel/asm-offsets.c:13:
> > arch/sparc/include/asm/pgtable_64.h: In function '__set_pte_at':
> > arch/sparc/include/asm/pgtable_64.h:674:6: error: 'init_mm' undeclared (first use in this function)
> > 
> > I assume some include file changes.  Anyone have any clues how to find
> > this?
> 
> The great irony is that sparc64 doesn't use anything this file
> generates (you won't find a single asm-offsets.h include in any
> sparc64 code).
Today sparc64 code actually uses AOFF_mm_context from asm-offsets.h.
The asm-offsets.h file is likely pulled in by some other header file.

> This asm-offset mechanim is, for whatever reason, enabled on every
> single architecture whether it's needed or not.  Maybe we should
> rethink that.
Most archs uses asm-offsets to some extent - trying to make it optional
would just result in a lot of otherwise pointless ifdefs.

With respect to the bug that triggered the mail....
It looks like another definition stuffed down in sched.h where is does not
belong. mm_types.h looks like the right place.
Then arch/sparc/include/asm/pgtable.h should obviously pull in this header.
But I do not have -next handy to try it out.

	Sam
