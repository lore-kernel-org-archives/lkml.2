Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751735Ab2IVNVn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Sep 2012 09:21:43 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:38048 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751419Ab2IVNVm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Sep 2012 09:21:42 -0400
Date: Sat, 22 Sep 2012 14:20:46 +0100
From: Russell King <rmk@arm.linux.org.uk>
To: Cyrill Gorcunov <gorcunov@openvz.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org,
        Linux-Arch <linux-arch@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: sys_kcmp (was: Re: [PATCH 1/2] ARM: add finit_module syscall
	to ARM)
Message-ID: <20120922132046.GA4260@flint.arm.linux.org.uk>
Mail-Followup-To: Cyrill Gorcunov <gorcunov@openvz.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org,
	Linux-Arch <linux-arch@vger.kernel.org>,
	Heiko Carstens <heiko.carstens@de.ibm.com>
References: <CAMuHMdXVKvaCoJTRb4O+Z4GuifzTEopdcRfRHBahQmpuX+Xi0w@mail.gmail.com> <20120922114549.GA11610@moon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120922114549.GA11610@moon>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 22, 2012 at 03:45:49PM +0400, Cyrill Gorcunov wrote:
> On Sat, Sep 22, 2012 at 12:56:42PM +0200, Geert Uytterhoeven wrote:
> > On Fri, Sep 21, 2012 at 6:51 PM, Russell King <rmk@arm.linux.org.uk> wrote:
> > > That brings up another question though - when was kcmp added to x86, and
> > > why aren't we getting notifications from checksyscalls.sh that ARM hasn't
> > > been updated?
> > >
> > > It seems to be that the script was broken, and no one has noticed.
> > 
> > It seems Heiko did notice: http://www.serverphorums.com/read.php?12,559093
> > 
> > Now, I'm a bit puzzled by what follows: Heiko proposes a patch to
> > ignore sys_kcmp,
> > as it's x86-specific, which is acked by Cyrill. Then it suddenly
> 
> hpa@ pointed that better approach is to implement kcmp on other archs
> after i've acked the patch. so then Heiko provided a patch for s390.

I discussed with hpa yesterday, and it seems the situation is as follows:

1. There exists a patch to fix checksyscalls.sh, and it's allegedly sitting
   in akpm's tree, and no one knows why it's just sitting there and hasn't
   been merged upstream.

2. There allegedly exists a patch to remove x86isms from sys_kcmp -
   allegedly also in akpm's tree.  However, I've looked through the code in
   mainline, and nothing stands out.  Ralf Beachle also said yesterday that
   he has looked through from the MIPS PoV and also can't see any x86isms,
   so we're both thinking that it should merely have the x86 dependency
   removed.

3. Until the x86 dependency is gone (that depends on what akpm proposes to
   do with the patches he's allegedly sitting on), non-x86 arches can only
   reserve the syscall, and add an IGNORE for it.

Maybe akpm can provide some input to this thread, and let us know what the
intentions are for checksyscalls.sh and kernel/kcmp.c, and whether he does
indeed have outstanding patches for these.

It would be good to at least get checksyscalls.sh fixed so arch maintainers
get their warnings for new syscalls back.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
