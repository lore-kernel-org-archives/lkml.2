Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752092Ab2DNIz1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2012 04:55:27 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:35730 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750956Ab2DNIzZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2012 04:55:25 -0400
Date: Sat, 14 Apr 2012 10:55:19 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, hpa@zytor.com,
        paulus@samba.org, eranian@google.com, linux-kernel@vger.kernel.org,
        efault@gmx.de, peterz@infradead.org, namhyung@gmail.com,
        fweisbec@gmail.com, dsahern@gmail.com,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>, tglx@linutronix.de,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perf/core] perf ui annotate browser: Allow toggling addr
 offset view
Message-ID: <20120414085519.GB28505@gmail.com>
References: <tip-4zpgimmz8xv7b5c920el7s45@git.kernel.org>
 <CA+55aFxnv5Wrix=uREQsEg+tSBE8SFvy0v_76csv3hrnmPYG2A@mail.gmail.com>
 <CA+55aFwcf2uPCccCVrNdCENZVKyev=ARprNj=5zwp5vxD942pw@mail.gmail.com>
 <20120414010410.GB22114@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20120414010410.GB22114@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Arnaldo Carvalho de Melo <acme@redhat.com> wrote:

> Em Fri, Apr 13, 2012 at 11:30:52AM -0700, Linus Torvalds escreveu:
> > On Fri, Apr 13, 2012 at 11:25 AM, Linus Torvalds
> > <torvalds@linux-foundation.org> wrote:
> > >
> > > <kmem_cache_free>:
> > >    1.91 :          push   %rbp
> > 
> > Oh, btw, talking about kmem_cache_free: that one uses altinstructions,
> > and so perf report shows the hottest instruction wrong (and I'm not
> > talking about "ugly"):
> 
> Well, if we use Masami's disassembler we would use the actual 
> code as it is being used and not the original DSO that was 
> later patched by altinstructions.

Key would be to use the kernel's live RAM image of instructions. 

I.e. we should provide a live /proc/vmlinux image in essence: a 
'virtual' ELF binary image constructed out of the live kernel 
RAM image - with no extra RAM overhead. (Maybe with modules 
included in an intelligent way - although personally I don't use 
modules when I instrument the kernel)

That plus the always-available /proc/kallsyms would offer rather 
powerful annotation already: without *any* debug info - out of 
box, on any Linux installation. (This was always the main 
advantage of /proc/profile and readprofile btw: it worked 
everywhere while most other profiling solutions needed a 
debuginfo, etc.)

Doing /proc/vmlinux would be different from /dev/mem as it only 
shows the kernel RAM image, and only in a read-only fashion.

Default permissions of /proc/vmlinux should probably track 
console permissions: it should be possible to allow people 
sitting in front of the computer to read /proc/vmlinux, while 
people logged in over the network wouldn't.

Doing such a live kernel vmlinux would have other debugging and 
instrumentation advantages as well: various code patching 
effects could be checked and observed directly.

Thanks,

	Ingo
