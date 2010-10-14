Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755176Ab0JNO1G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 10:27:06 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:46288 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754594Ab0JNO1E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 10:27:04 -0400
Date: Thu, 14 Oct 2010 08:27:01 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Borislav Petkov <bp@amd64.org>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Doug Thompson <dougthompson@xmission.com>,
        akpm <akpm@linux-foundation.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>
Subject: Re: [PATCH] bitops.h: Widen BIT macro to support 64-bit types
Message-ID: <20101014142701.GP10421@parisc-linux.org>
References: <20101013131057.88238be6.randy.dunlap@oracle.com> <20101014042409.GB29342@aftab> <20101014105855.GB31247@aftab> <20101014111213.GO10421@parisc-linux.org> <20101014121230.GC31247@aftab>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101014121230.GC31247@aftab>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 14, 2010 at 02:12:30PM +0200, Borislav Petkov wrote:
> From: Matthew Wilcox <matthew@wil.cx>
> Date: Thu, Oct 14, 2010 at 07:12:13AM -0400
> 
> > On Thu, Oct 14, 2010 at 12:58:55PM +0200, Borislav Petkov wrote:
> > >  #ifdef	__KERNEL__
> > > -#define BIT(nr)			(1UL << (nr))
> > > +#define BIT(nr)			(U64_C(1) << (nr))
> > 
> > Why not just use 1ULL instead?
> 
> Wanted to be __ASSEMBLY__ safe.

Admirable, but the entire file is __ASSEMBLY__ unsafe at this point,
so I don't see the point.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
