Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754985Ab2JCAoH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 20:44:07 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:63736 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754868Ab2JCAoE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 20:44:04 -0400
Date: Tue, 2 Oct 2012 17:43:20 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Andrew Morton <akpm@linux-foundation.org>
cc: Kees Cook <keescook@chromium.org>,
        Ard Biesheuvel <ard.biesheuvel@gmail.com>,
        linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        Ingo Molnar <mingo@kernel.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        James Morris <jmorris@namei.org>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>, linux-mm@kvack.org
Subject: Re: [PATCH] hardening: add PROT_FINAL prot flag to mmap/mprotect
In-Reply-To: <20121002153841.a03ad73b.akpm@linux-foundation.org>
Message-ID: <alpine.LSU.2.00.1210021733580.1343@eggly.anvils>
References: <E1T1N2q-0001xm-5X@morero.ard.nu> <20120820180037.GV4232@outflux.net> <CAKFga-dDRyRwxUu4Sv7QLcoyY5T3xxhw48LP2goWs=avGW0d_A@mail.gmail.com> <CAGXu5jJCqABZcMHuQNAaAcUKCEsSqOTn5=DHdwFdJ70zVLsmSQ@mail.gmail.com> <CAKFga-fB2JSAscSVi+YUOnFS4Lq4yzH5MHRwxDQBQYZfKAgB6A@mail.gmail.com>
 <CAGXu5jLj6qm+Rv3v2pmJqfEmhZBkKJsMUe0aRqxSa=s=w4wbDw@mail.gmail.com> <20121002153841.a03ad73b.akpm@linux-foundation.org>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2 Oct 2012, Andrew Morton wrote:
> On Tue, 2 Oct 2012 15:10:56 -0700
> Kees Cook <keescook@chromium.org> wrote:
> 
> > >> Has there been any more progress on this patch over-all?
> > >
> > > No progress.
> > 
> > Al, Andrew, anyone? Thoughts on this?
> > (First email is https://lkml.org/lkml/2012/8/14/448)
> 
> Wasn't cc'ed, missed it.
> 
> The patch looks straightforward enough.  Have the maintainers of the
> runtime linker (I guess that's glibc) provided any feedback on the
> proposal?

It looks reasonable to me too.  I checked through VM_MAYflag handling
and don't expect surprises (a few places already turn off VM_MAYWRITE
in much the same way that this does, I hadn't realized).

I'm disappointed to find that our mmap() is lax about checking its
PROT and MAP args, so old kernels will accept PROT_FINAL but do
nothing with it.  Luckily mprotect() is stricter, so that can be
used to check for whether it's supported.

The patch does need to be slightly extended though: alpha, mips,
parisc and xtensa have their own include/asm/mman.h, which does
not include asm-generic/mman-common.h at all.

Hugh
