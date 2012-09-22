Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752650Ab2IVPhv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Sep 2012 11:37:51 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:65001 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751627Ab2IVPht (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Sep 2012 11:37:49 -0400
Date: Sat, 22 Sep 2012 19:37:44 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org,
        Linux-Arch <linux-arch@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: sys_kcmp (was: Re: [PATCH 1/2] ARM: add finit_module syscall to
 ARM)
Message-ID: <20120922153744.GB11610@moon>
References: <CAMuHMdXVKvaCoJTRb4O+Z4GuifzTEopdcRfRHBahQmpuX+Xi0w@mail.gmail.com>
 <20120922114549.GA11610@moon>
 <20120922132046.GA4260@flint.arm.linux.org.uk>
 <20120922133847.GC20003@linux-mips.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120922133847.GC20003@linux-mips.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 22, 2012 at 03:38:47PM +0200, Ralf Baechle wrote:
> On Sat, Sep 22, 2012 at 02:20:46PM +0100, Russell King wrote:
> 
> > 2. There allegedly exists a patch to remove x86isms from sys_kcmp -
> >    allegedly also in akpm's tree.  However, I've looked through the code in
> >    mainline, and nothing stands out.  Ralf Beachle also said yesterday that
> >    he has looked through from the MIPS PoV and also can't see any x86isms,
> >    so we're both thinking that it should merely have the x86 dependency
> >    removed.
> > 
> > 3. Until the x86 dependency is gone (that depends on what akpm proposes to
> >    do with the patches he's allegedly sitting on), non-x86 arches can only
> >    reserve the syscall, and add an IGNORE for it.
> 
> There is a weak definition provided in kernel/sys_ni.c so it actually can
> be properly wired up in preparation for the day when the dependency in
> Kconfig gets fixed.
> 
> > It would be good to at least get checksyscalls.sh fixed so arch maintainers
> > get their warnings for new syscalls back.
> 
> Indeed.  That script has become just too important.

These are the patches from linux-next/akpm

commit 6dfc4cffd24b0c7dc04ca36471a4a6b2a9fc1377
Author: Heiko Carstens <heiko.carstens@de.ibm.com>
Date:   Fri Sep 21 11:01:56 2012 +1000

    syscalls: make kcmp syscall available for all architectures

commit 7f36f199e958ce7009285cd887323cb222ed6b1e
Author: Heiko Carstens <heiko.carstens@de.ibm.com>
Date:   Fri Sep 21 10:57:07 2012 +1000

    checksyscalls: fix "here document" handling

So I guess this tree in a good shape just checksyscalls.sh fix should
go upstream, right?
