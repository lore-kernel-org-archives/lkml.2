Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756439Ab2ELUkc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2012 16:40:32 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:64613 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756074Ab2ELUk3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2012 16:40:29 -0400
MIME-Version: 1.0
In-Reply-To: <1336852387-16322-1-git-send-email-acme@infradead.org>
References: <1336852387-16322-1-git-send-email-acme@infradead.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 12 May 2012 13:40:07 -0700
X-Google-Sender-Auth: yObP55E7PfOrDKzm8nUr7m91byg
Message-ID: <CA+55aFxeqrCj71fSe2r9kwzyO9q2BT9A89f7nLUgbrTG_uPP2g@mail.gmail.com>
Subject: Re: [GIT PULL 0/8] Annotation weekly ponies delivery
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        Arjan van de Ven <arjan@infradead.org>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>, arnaldo.melo@gmail.com,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 12, 2012 at 12:52 PM, Arnaldo Carvalho de Melo
<acme@infradead.org> wrote:
>
> Arjan & Linus Annotation Edition

I pulled this into my current git tree just for testing.

It's horribly broken, but it's not the annotation that is broken.

The whole "-e cycles:pp" doesn't work any more. I don't get any nice
PEBS information, I get the totally useless irq-based profiling.

The difference for a "make -j" profile is quite stunning:

Doing "perf record -f -e cycles:pp -F 20000 make -j"

 - my current git:

    [ perf record: Woken up 47 times to write data ]
    [ perf record: Captured and wrote 11.890 MB perf.data (~519462 samples) ]

 - with the above tree pulled into my current git tree (but compiling
the same old tree):

    [ perf record: Woken up 1 times to write data ]
    [ perf record: Captured and wrote 0.031 MB perf.data (~1375 samples) ]

and not suprisingly, the resulting profiles are crap due to lack of
reasonable sample coverage.

I don't think this has anything to do with your changes, but I thought
I'd report it anyway. Something in 'perf' land is broken.

                   Linus

>
> More like Linus', but hey at least an attempt at implementing a suggestion by
> Arjan made this time around!
>
> . Fix indirect calls beautifier, reported by Linus.
>
> . Use the objdump comments to nuke specificities about how access to a well
>  know variable is encoded, suggested by Linus.
>
> . Show the number of places that jump to a target, requested by Arjan.
>
> Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
>
> ----------------------------------------------------------------
> Arnaldo Carvalho de Melo (8):
>      perf annotate: Use raw form for register indirect call instructions
>      perf annotate: Resolve symbols using objdump comment
>      perf annotate: Resolve symbols using objdump comment for single op ins
>      perf annotate: Augment lock instruction output
>      perf annotate: Introduce ->free() method in ins_ops
>      perf annotate browser: Count the numbers of jump sources to a target
>      perf annotate browser: Show 'jumpy' functions
>      perf annotate browser: Add key bindings help window
>
>  tools/perf/ui/browsers/annotate.c |   94 ++++++++++--
>  tools/perf/util/annotate.c        |  303 +++++++++++++++++++++++++++++++++----
>  tools/perf/util/annotate.h        |   15 +-
>  3 files changed, 369 insertions(+), 43 deletions(-)
