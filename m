Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753386Ab2DNIqZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2012 04:46:25 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:43334 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753046Ab2DNIqW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2012 04:46:22 -0400
Date: Sat, 14 Apr 2012 10:46:16 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, hpa@zytor.com,
        paulus@samba.org, eranian@google.com, linux-kernel@vger.kernel.org,
        efault@gmx.de, peterz@infradead.org, namhyung@gmail.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perf/core] perf ui annotate browser: Allow toggling addr
 offset view
Message-ID: <20120414084616.GA28505@gmail.com>
References: <tip-4zpgimmz8xv7b5c920el7s45@git.kernel.org>
 <CA+55aFxnv5Wrix=uREQsEg+tSBE8SFvy0v_76csv3hrnmPYG2A@mail.gmail.com>
 <20120414005921.GA22114@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120414005921.GA22114@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Arnaldo Carvalho de Melo <acme@redhat.com> wrote:

> > Now, fancy arrows etc might be too hard to do (especially 
> > without cluttering things up too much), but marking just the 
> > targets would already be lovely. IOW, turn this mess:
> > 
> > 
> >          :        ffffffff810d7e80 <kmem_cache_free>:
> >     1.91 :        ffffffff810d7e80:       push   %rbp
> >     0.05 :        ffffffff810d7e81:       mov    %rsp,%rbp
> >     2.02 :        ffffffff810d7e84:       push   %r12
> >     0.00 :        ffffffff810d7e86:       mov    %rdi,%r12
> >     0.55 :        ffffffff810d7e89:       push   %rbx
> >     0.00 :        ffffffff810d7e8a:       mov    %rsi,%rdi
> >     1.20 :        ffffffff810d7e8d:       mov    %rsi,%rbx
> >     1.64 :        ffffffff810d7e90:       callq  ffffffff8102a730 <__phys_addr>
> >     0.05 :        ffffffff810d7e95:       movabs $0xffffea0000000000,%rdi
> >     0.22 :        ffffffff810d7e9f:       shr    $0xc,%rax
> >     0.11 :        ffffffff810d7ea3:       shl    $0x6,%rax
> >     1.64 :        ffffffff810d7ea7:       lea    (%rax,%rdi,1),%rdi
> >    42.80 :        ffffffff810d7eab:       mov    (%rdi),%rax
> >     2.02 :        ffffffff810d7eae:       test   $0x80,%ah
> >     0.00 :        ffffffff810d7eb1:       jne    ffffffff810d7ef6
> > <kmem_cache_free+0x76>
> >     0.22 :        ffffffff810d7eb3:       mov    0x8(%rbp),%r9
> >     7.14 :        ffffffff810d7eb7:       mov    (%r12),%rax
> >     0.65 :        ffffffff810d7ebb:       add    %gs:0xcb88,%rax
> >     4.58 :        ffffffff810d7ec4:       mov    0x8(%rax),%rdx
> > 
> > (which has tons of unnecessary white-space too - shades of G+) into
> 
> Grin ;-)
> 
> Yeah, even the : column isn't needed I think.

Such delineators are sometimes useful visually, it emulates a 
vertical line and makes it easier for the brain to ignore the 
left or right side. We'll fine-tune it.

The occasional color highlighting is useful too, as long as it 
is used sparingly.

> > Sure, leave some magic keycombination to get the "full 
> > information", but ..
> 
> Yeah, we have o to toggle offset view + s to toggle source 
> code view, etc.

I suspect the default view should be the 'most intelligent' mode 
of assembly output we can offer - with easy toggles for the rare 
cases where someone would like to do something special, plus 
.perfconfig overrides for those with weird workflows and those 
with a taste different from ours.

Thanks,

	Ingo
