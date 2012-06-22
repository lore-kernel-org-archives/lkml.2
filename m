Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758444Ab2FVTGf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 15:06:35 -0400
Received: from alternativer.internetendpunkt.de ([88.198.24.89]:37292 "EHLO
	geheimer.internetendpunkt.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754002Ab2FVTGe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 15:06:34 -0400
Date: Fri, 22 Jun 2012 21:06:32 +0200
From: Hagen Paul Pfeifer <hagen@jauu.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
        linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] perf fixes
Message-ID: <20120622190632.GB8014@virgo.local>
References: <20120622133650.GA24136@gmail.com>
 <CA+55aFySaZ4huXgPM0yGPezAhnE9zT81tucC9WnDs5Ps+7+hGA@mail.gmail.com>
 <20120622183827.GA8014@virgo.local>
 <CA+55aFzpNtLSQvcOOut--2UkkMyqSb9e0_VO3JAxvZRTv7YT1g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFzpNtLSQvcOOut--2UkkMyqSb9e0_VO3JAxvZRTv7YT1g@mail.gmail.com>
X-Key-Id: 98350C22
X-Key-Fingerprint: 490F 557B 6C48 6D7E 5706 2EA2 4A22 8D45 9835 0C22
X-GPG-Key: gpg --recv-keys --keyserver wwwkeys.eu.pgp.net 98350C22
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Linus Torvalds | 2012-06-22 11:52:43 [-0700]:

>So even stubbed out, it's quite noticeable. The call causes the
>function prologue to change quite a bit.
>
>That's actually especially true with newer versions of gcc that
>*finally* seem to have done the "don't always generate the full
>prologue if some case doesn't need it" optimization. So functions that
>have early-out conditions (quite common) will exit before even having
>done the prologue, and without doing the whole frame pointer setup
>etc.
>
>Except if mcount generation is on. Then gcc will always do the
>prologue and frame pointer setup before doing the mcount, because
>mcount wants it.
>
>So it really isn't just the extra call instruction.
>
>I may be more sensitive to this than most, because I look at profiles
>and the function prologue just looks very ugly with the call mcount
>thing. Ugh.

Yes, ugh. Even Stevens -mfentry replacement do not change things here. Maybe
this performance problem should addressed on another level: distributors
should build there kernel with disabled ftrace support. Kprobes and function
tracing should be sufficient for 98% of their customers.

I see no compiler (gcc) way around this performance issue. Maybe you/Steven
should restart a G+ poll ... ;)

Hagen

