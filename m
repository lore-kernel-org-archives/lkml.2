Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752198Ab2IVSkk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Sep 2012 14:40:40 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:48527 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751664Ab2IVSkj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Sep 2012 14:40:39 -0400
Date: Sat, 22 Sep 2012 11:47:23 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Russell King <rmk@arm.linux.org.uk>
Cc: Cyrill Gorcunov <gorcunov@openvz.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org,
        Linux-Arch <linux-arch@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: sys_kcmp (was: Re: [PATCH 1/2] ARM: add finit_module syscall to
 ARM)
Message-Id: <20120922114723.d7f07fb6.akpm@linux-foundation.org>
In-Reply-To: <20120922132046.GA4260@flint.arm.linux.org.uk>
References: <CAMuHMdXVKvaCoJTRb4O+Z4GuifzTEopdcRfRHBahQmpuX+Xi0w@mail.gmail.com>
	<20120922114549.GA11610@moon>
	<20120922132046.GA4260@flint.arm.linux.org.uk>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 22 Sep 2012 14:20:46 +0100 Russell King <rmk@arm.linux.org.uk> wrote:

> On Sat, Sep 22, 2012 at 03:45:49PM +0400, Cyrill Gorcunov wrote:
> > On Sat, Sep 22, 2012 at 12:56:42PM +0200, Geert Uytterhoeven wrote:
> > > On Fri, Sep 21, 2012 at 6:51 PM, Russell King <rmk@arm.linux.org.uk> wrote:
> > > > That brings up another question though - when was kcmp added to x86, and
> > > > why aren't we getting notifications from checksyscalls.sh that ARM hasn't
> > > > been updated?
> > > >
> > > > It seems to be that the script was broken, and no one has noticed.
> > > 
> > > It seems Heiko did notice: http://www.serverphorums.com/read.php?12,559093
> > > 
> > > Now, I'm a bit puzzled by what follows: Heiko proposes a patch to
> > > ignore sys_kcmp,
> > > as it's x86-specific, which is acked by Cyrill. Then it suddenly
> > 
> > hpa@ pointed that better approach is to implement kcmp on other archs
> > after i've acked the patch. so then Heiko provided a patch for s390.
> 
> I discussed with hpa yesterday, and it seems the situation is as follows:
> 
> 1. There exists a patch to fix checksyscalls.sh, and it's allegedly sitting
>    in akpm's tree, and no one knows why it's just sitting there and hasn't
>    been merged upstream.

People sometimes just reply to my commit emails, ignoring the
reply-to:lkml and the "Before you just go and hit reply" request.  I could
start cc'ing the lists like tip-bot, but that seems a bit noisy.

> 2. There allegedly exists a patch to remove x86isms from sys_kcmp -
>    allegedly also in akpm's tree.  However, I've looked through the code in
>    mainline, and nothing stands out.  Ralf Beachle also said yesterday that
>    he has looked through from the MIPS PoV and also can't see any x86isms,
>    so we're both thinking that it should merely have the x86 dependency
>    removed.

http://ozlabs.org/~akpm/mmotm/broken-out/syscalls-make-kcmp-syscall-available-for-all-architectures.patch

I have that queued for 3.7.  There is of course a little risk here.  We
do have a test in tools/testing/selftests/kcmp/ - I suggest that arch
people run it!  In fact all the tools/testing/selftests should execute
successfully on all architectures - if not, please let's fix things
up.

> 3. Until the x86 dependency is gone (that depends on what akpm proposes to
>    do with the patches he's allegedly sitting on), non-x86 arches can only
>    reserve the syscall, and add an IGNORE for it.
> 
> Maybe akpm can provide some input to this thread, and let us know what the
> intentions are for checksyscalls.sh and kernel/kcmp.c, and whether he does
> indeed have outstanding patches for these.
> 
> It would be good to at least get checksyscalls.sh fixed so arch maintainers
> get their warnings for new syscalls back.

http://ozlabs.org/~akpm/mmotm/broken-out/checksyscalls-fix-here-document-handling.patch

I had it queued for 3.7.  I now see that was a mistake and I'll get it
into 3.6.
