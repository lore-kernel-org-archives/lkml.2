Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755898Ab2DMSbQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 14:31:16 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:61849 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753220Ab2DMSbO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 14:31:14 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFxnv5Wrix=uREQsEg+tSBE8SFvy0v_76csv3hrnmPYG2A@mail.gmail.com>
References: <tip-4zpgimmz8xv7b5c920el7s45@git.kernel.org> <CA+55aFxnv5Wrix=uREQsEg+tSBE8SFvy0v_76csv3hrnmPYG2A@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 13 Apr 2012 11:30:52 -0700
X-Google-Sender-Auth: HGbSCEzt0Zc9pOVbN1peMSt4R4A
Message-ID: <CA+55aFwcf2uPCccCVrNdCENZVKyev=ARprNj=5zwp5vxD942pw@mail.gmail.com>
Subject: Re: [tip:perf/core] perf ui annotate browser: Allow toggling addr
 offset view
To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, efault@gmx.de, peterz@infradead.org,
        namhyung@gmail.com, fweisbec@gmail.com, dsahern@gmail.com,
        tglx@linutronix.de
Cc: linux-tip-commits@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 13, 2012 at 11:25 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> <kmem_cache_free>:
>    1.91 :          push   %rbp

Oh, btw, talking about kmem_cache_free: that one uses altinstructions,
and so perf report shows the hottest instruction wrong (and I'm not
talking about "ugly"):

   12.38 :        ffffffff810d7ee5:       lea    (%r8),%rsi
    0.71 :        ffffffff810d7ee8:       callq  ffffffff812d3df0
<this_cpu_cmpxchg16b_emu>

that "lea" really isn't very expensive. In reality, it's not
"lea+call", it's a "lock ; cmpxchg16b + setz" instruction. But "perf"
doesn't know about alternative instructions, and if somebody were to
try to teach it, that would be lovely.

Happily, x86-64 doesn't have quite as many of them as x86-32 does. But
they are there, sometimes in interesting functions.

                 Linus
