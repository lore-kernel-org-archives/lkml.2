Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752109Ab2AYLFb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jan 2012 06:05:31 -0500
Received: from mga06.intel.com ([134.134.136.21]:9641 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751180Ab2AYLF3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jan 2012 06:05:29 -0500
MIME-Version: 1.0
In-Reply-To: <20120121011243.GC23916@ZenIV.linux.org.uk>
References: <20120121011243.GC23916@ZenIV.linux.org.uk>
Date: Wed, 25 Jan 2012 13:05:28 +0200
Message-ID: <CALLzPKZ8iR0TumBc5wa+BLTFZeo7ABv47O4P4d=sv8MaSzeTLA@mail.gmail.com>
Subject: Re: sparc32 vs lib/mpi
From: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 21, 2012 at 3:12 AM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>        I realize that very few people care about sparc32 these days,
> but...
>        a) __clz_tab[] is defined (with identical contents) in
> lib/mpi/mpi-bit.c and arch/sparc/lib/divdi3.S.  Linker is unhappy,
> of course...
>        b) the same thing ends up using __udiv_qrnnd(), which simply
> does not exist on sparc32.  There's a Cthulhu-scaring cascade of
> ifdefs in lib/mpi/longlong.h, with several variants of udiv_qrnnd()
> for sparc.  Unfortunately, it falls back on use of __udiv_qrnnd()...
> Note that arch/sparc/math-emu/sfp-util_32.h has a definition of
> udiv_qrnnd() which might match one of inline assembly variants in

Would need to test it and see how it works...

> lib/mpi/longlong.h.  Or not.  BTW, what the hell is LONGLONG_STANDALONE?
>

i see that it comes from gnupg code as it is, but do not see any
scripts which might define it.

>        Could somebody who might remember still remember that stuff
> come up with comments?  For now I'm disabling everything from
> INTEGRITY_SIGNATURE down to MPILIB on sparc32 cross-build, but it
> would be nice to get it at least somewhat sorted out...
