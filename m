Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754456Ab2HOOts (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 10:49:48 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:35287 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751164Ab2HOOtq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 10:49:46 -0400
Date: Wed, 15 Aug 2012 10:49:43 -0400 (EDT)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Ben Hutchings <ben@decadent.org.uk>
cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, alan@lxorguk.ukuu.org.uk,
        Arnd Bergmann <arnd@arndb.de>, Shan Kang <kangshan0910@gmail.com>,
        Will Deacon <will.deacon@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: Re: [ 20/82] ARM: 7467/1: mutex: use generic xchg-based implementation
 for ARMv6+
In-Reply-To: <1345039901.824.221.camel@deadeye.wl.decadent.org.uk>
Message-ID: <alpine.LFD.2.02.1208151035360.1541@xanadu.home>
References: <20120813201746.448504360@linuxfoundation.org> <20120813201748.202917513@linuxfoundation.org> <1345038982.824.216.camel@deadeye.wl.decadent.org.uk> <20120815140808.GD22871@kroah.com> <1345039901.824.221.camel@deadeye.wl.decadent.org.uk>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Aug 2012, Ben Hutchings wrote:

> On Wed, 2012-08-15 at 07:08 -0700, Greg Kroah-Hartman wrote:
> > On Wed, Aug 15, 2012 at 02:56:22PM +0100, Ben Hutchings wrote:
> > > On Mon, 2012-08-13 at 13:18 -0700, Greg Kroah-Hartman wrote:
> > > > From: Greg KH <gregkh@linuxfoundation.org>
> > > > 
> > > > 3.5-stable review patch.  If anyone has any objections, please let me know.
> > > > 
> > > > ------------------
> > > > 
> > > > From: Will Deacon <will.deacon@arm.com>
> > > > 
> > > > commit a76d7bd96d65fa5119adba97e1b58d95f2e78829 upstream.
> > > > 
> > > > The open-coded mutex implementation for ARMv6+ cores suffers from a
> > > > severe lack of barriers, so in the uncontended case we don't actually
> > > > protect any accesses performed during the critical section.
> > > > 
> > > > Furthermore, the code is largely a duplication of the ARMv6+ atomic_dec
> > > > code but optimised to remove a branch instruction, as the mutex fastpath
> > > > was previously inlined. Now that this is executed out-of-line, we can
> > > > reuse the atomic access code for the locking (in fact, we use the xchg
> > > > code as this produces shorter critical sections).
> > > > 
> > > > This patch uses the generic xchg based implementation for mutexes on
> > > > ARMv6+, which introduces barriers to the lock/unlock operations and also
> > > > has the benefit of removing a fair amount of inline assembly code.
> > > [...]
> > > 
> > > Here also, I think this should be deferred.
> > 
> > "also"?  Am I missing some context here?  Why should we deferr this one?
> > What do we need to wait for?
> 
> This is the same as 3.4.9-rc1 patch 10/65, which I queried as it
> apparently caused a regression.
> 
> Will Deacon wrote:
> > The additional patch should also be CC'd to stable and is sitting in -tip
> > somewhere I believe, so it shouldn't be long before it does hit mainline.
> > 
> > Without this patch there's a memory-ordering bug (which we seem to have hit
> > once in > 5 years). With the patch there's a mutex lockup issue on SMP systems
> > that I can provoke with enough hackbenching, so you may want to hold off for
> > now.

If you wish to really be stable, both this patch _and_ 
http://git.kernel.org/?p=linux/kernel/git/tip/tip.git;a=patch;h=0bce9c46bf
must be applied.  The later is going to hit mainline soon.


Nicolas
