Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759913Ab2BJTAN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 14:00:13 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:46477 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759670Ab2BJTAL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 14:00:11 -0500
MIME-Version: 1.0
In-Reply-To: <1328895795.25989.29.camel@laptop>
References: <1328873119-21553-1-git-send-email-jolsa@redhat.com> <1328895795.25989.29.camel@laptop>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 10 Feb 2012 10:59:51 -0800
X-Google-Sender-Auth: LdwD0Vj6jymhu3MSXAnmsUWNSEI
Message-ID: <CA+55aFxgPXjGh0GSHaUGm6-Pfdjjk=PAP7HMuZHcFGE92VutUQ@mail.gmail.com>
Subject: Re: [RFC 0/5] kernel: backtrace unwind support
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Jiri Olsa <jolsa@redhat.com>, acme@redhat.com, mingo@elte.hu,
        paulus@samba.org, cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com,
        linux-kernel@vger.kernel.org,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        Jan Blunck <jblunck@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 10, 2012 at 9:43 AM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
>
> So I CC'ed Linus who has a strong here, jejb since he's the one that
> told me several time there's a number of literate dwarfs already in the
> kernel and Jan because I think it was him that tried last on x86.

I never *ever* want to see this code ever again.

Sorry, but last time was too f*cking painful. The whole (and *only*)
point of unwinders is to make debugging easy when a bug occurs. But
the f*cking dwarf unwinder had bugs itself, or our dwarf information
had bugs, and in either case it actually turned several "trivial" bugs
into a total undebuggable hell.

It was made doubly painful by the developers involved then several
times ignoring the problem, and claiming the code was bug-free when it
clearly wasn't, or trying to claim that the problem was that we set up
some random dwarf information wrong, when THAT GOES WITHOUT SAYING
(since dwarf is a complex mess that never gets any actual testing
except when things go wrong - at which point the code had better work
regardless of whether the dwarf info was correct or not).

So no. An unwinder that is several hundred lines long is simply not
even *remotely* interesting to me.

If you can mathematically prove that the unwinder is correct - even in
the presence of bogus and actively incorrect unwinding information -
and never ever follows a bad pointer, I'll reconsider.

In the absence of that, just follow the damn chain on the stack
*without* the "smarts" of an inevitably buggy piece of crap.

                    Linus
