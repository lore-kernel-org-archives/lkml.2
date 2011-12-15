Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759480Ab1LOVBg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 16:01:36 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:59892 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759225Ab1LOVBe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 16:01:34 -0500
MIME-Version: 1.0
X-Originating-IP: [197.176.112.38]
In-Reply-To: <20111206134431.GA10709@infradead.org>
References: <4E9F1AA0.4010706@gmail.com> <20111019192011.GG2229@ghostprotocols.net>
 <4E9F4B50.1060207@gmail.com> <20111020130041.GB1772@ghostprotocols.net>
 <CAHVUoiSwem2r9J==gmHPfst3_0ZB5bd0ykf9cPUMdhZFaXC9EA@mail.gmail.com>
 <CAHVUoiTeCuFLCkyEzCMJ6g1wAp+FWDR3qkSrqE3vJAYwLsRC9Q@mail.gmail.com>
 <20111130181011.GA4111@infradead.org> <CAHVUoiQC5RjuHUsfPVTQ_C+W0Khp=hQC+_csP0+fJgUnoaALAA@mail.gmail.com>
 <20111201141130.GA2323@infradead.org> <CAHVUoiR=gMcdLZcR+TmB6CiRhEP+x8aXjR5r5Wc4k6gZwzLAjg@mail.gmail.com>
 <20111206134431.GA10709@infradead.org>
From: Brian Gitonga Marete <marete@toshnix.com>
Date: Fri, 16 Dec 2011 00:01:13 +0300
Message-ID: <CAHVUoiSaOMeyZ45KF0B=aiqC5DGF0Jk+te7F=UNTN6t4QiPcRQ@mail.gmail.com>
Subject: Re: [PATCH] perf top: fix crash on annotate request
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: David Ahern <dsahern@gmail.com>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, peterz@infradead.org, fweisbec@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 6, 2011 at 4:44 PM, Arnaldo Carvalho de Melo
<acme@infradead.org> wrote:
>
> Em Tue, Dec 06, 2011 at 10:22:57AM +0300, Brian Gitonga Marete escreveu:
> > On Thu, Dec 1, 2011 at 5:11 PM, Arnaldo Carvalho de Melo <acme@infradead.org> wrote:
> > > Its just this one, can you try doing something like:
>
> > > perf top -vvv > /tmp/debug.top 2>&1
> > > bzip2 /tmp/debug.top
>
> > > That will print lots of information about symbols being loaded,
> > > overlapping maps, etc that can help me understand why that symbol name
> > > looks garbage.
>
> > > And send me in pvt the result together with a fresh backtrace with those
> > > symbols printed? Also which distro are you using?
>
> > Hello Arnaldo. Curiously, I am unable to reproduce the crash when
> > stdout is redirected to a file. I am able to capture lots of output if
>
> That is good input, so can you please try using just:
>
> perf top --stdio
>
> I.e. probably the problem is with the TUI code and running it in --stdio
> mode will help us pinpoint that. No need to redirect anything.
>

Indeed `--stdio' avoids the crash. See my bisection report below.

> > I redirect stdout to a file in verbose mode, but it won't crash when I
> > do that. Just the same, I am still able to always reproduce (within a
> > few seconds) with your perf/core branch on the tree you pointed me to.
> > This time, I did a `thread apply all bt' in gdb to show the trace for
> > the UI thread since it now seems to me to probably have something with
> > the UI output (because I cannot reproduce if o/put is to a file). The
> > trace is attached in the file gdb.txt.
>
> > Is the `perf top -vvv > /tmp/debug.top 2>&1' output useful even if it
> > is captured in a session that does not crash? If so will send the
> > output privately to you.
>
> please.

Coming in a separate email to you.

> > I am using Ubuntu 10.10
>

Hi. I have bisected this on Linus' tree and the commit that introduced
the crash is: 8b1bfdbdb30

commit 8b1bfdbdb3041c0503c42ef49bab25caabeaa558
Author: Arnaldo Carvalho de Melo <acme@redhat.com>
Date:   Wed Oct 5 19:41:31 2011 -0300

perf top: Use the TUI interface by default

It has to do with UI. Reverting it eliminates the crash. (As does
using --stdio as I have said above)

BGM.

--
Brian Gitonga Marete
Toshnix Systems
Tel: +254722151590
