Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759481Ab2BJRn0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 12:43:26 -0500
Received: from casper.infradead.org ([85.118.1.10]:33992 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750780Ab2BJRnY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 12:43:24 -0500
Subject: Re: [RFC 0/5] kernel: backtrace unwind support
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Jiri Olsa <jolsa@redhat.com>
Cc: acme@redhat.com, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com,
        linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        Jan Blunck <jblunck@suse.de>
In-Reply-To: <1328873119-21553-1-git-send-email-jolsa@redhat.com>
References: <1328873119-21553-1-git-send-email-jolsa@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 10 Feb 2012 18:43:15 +0100
Message-ID: <1328895795.25989.29.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-02-10 at 12:25 +0100, Jiri Olsa wrote:
> I was recently dealing with libunwind and wanted to try out
> the dwarf backtrace unwind in kernel space.
> 
> The attached patchset implements dwarf backtrace unwind
> based on the exception header frames (.eh_frame_hdr and 
> .eh_frame ELF sections). The code is mostly stolen from
> libunwind (git://git.sv.gnu.org/libunwind.git).
> 
> I'm not sure how much of usage this can be given that we
> already have quite reliable stack backtrace, and given
> the complexity of the dwarf unwind. But I might be
> overlooking something and this could be of use for someone
> else.
> 
> Also it needs to be said, that the state of this patchset
> is far from being done. It's in state 'working for me' on
> x86_64 and seems to provide reliable backtrace.
> 
> attached patches:
>  - 1/5 unwind, kconfig: Adding UNWIND* options
>  - 2/5 unwind, x86: Generate exception frames data for UNWIND_EH_FRAME option
>  - 3/5 unwind, dwarf: Add dwarf unwind support
>  - 4/5 unwind, api: Add unwind interface and implementation for x86_64
>  - 5/5 unwind, test: Add backtrace unwind test code 

Right, so last time someone did a x86 dwarf unwinder there was a bit of
a 'discussion' and Linus basically told people to go away. That said,
there are a number of literate dwarfs in various architectures because
that simply the only way to get a backtrace on them.

So I CC'ed Linus who has a strong here, jejb since he's the one that
told me several time there's a number of literate dwarfs already in the
kernel and Jan because I think it was him that tried last on x86.

