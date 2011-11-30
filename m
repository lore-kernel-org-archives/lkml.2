Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751360Ab1K3RoY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 12:44:24 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:46614 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751104Ab1K3RoX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 12:44:23 -0500
MIME-Version: 1.0
In-Reply-To: <1322654092.2921.256.camel@twins>
References: <alpine.DEB.2.00.1111300011260.7107@cl320.eecs.utk.edu> <1322654092.2921.256.camel@twins>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 30 Nov 2011 09:44:01 -0800
X-Google-Sender-Auth: n398LtoIxicQLcefDD6ZihdtSbQ
Message-ID: <CA+55aFwyYdN7HOkP0xanUOWd12zZhdqHCjnsWtdrs5LOxjg+Gg@mail.gmail.com>
Subject: Re: perf_event self-monitoring overhead regression
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Vince Weaver <vweaver1@eecs.utk.edu>, Ingo Molnar <mingo@elte.hu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Stephane Eranian <eranian@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 30, 2011 at 3:54 AM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
>
> I CC'ed Linus since he's way too skilled at this git thing and always
> has good advice. There might be very good bisect advice in the lkml
> archives but I'm not sure there's anything like a HOWTO/FAQ on the
> subject other than the git-bisect manpage (ought there be one?).

Basically, "git bisect" will never really work unless you have a very
un-ambiguous case: the way bisection works (and the reason it is so
efficient) really requires that the good/bad decision be entirely
black-and-white with absolutely no room for error.

I suspect that in some performance-related thing like this, that kind
of black-and-white situation simply doesn't end up existing. For all
we know, it could be at least partly about cache layout etc, and
trying to bisect it is likely futile, unless you have a *really* good
testcase.

So bisect works really well for clear bugs that are 100% repeatable
and have a very clear "did it happen or not" signature, but I'd be
very leery indeed of using it with some performance anomaly.

That said, maybe you can get the timings to be unambiguous enough by
using 'rdtsc' in user space, and try the bisect again.

                        Linus
