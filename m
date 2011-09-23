Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752590Ab1IWVZz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 17:25:55 -0400
Received: from casper.infradead.org ([85.118.1.10]:40199 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752105Ab1IWVZy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 17:25:54 -0400
Date: Fri, 23 Sep 2011 18:25:23 -0300
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Anton Blanchard <anton@samba.org>,
        Darren Hart <dvhart@linux.intel.com>, David Ahern <dsahern@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric B Munson <emunson@mgebm.net>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ian Munsie <imunsie@au1.ibm.com>, Ingo Molnar <mingo@elte.hu>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Pekka Enberg <penberg@cs.helsinki.fi>,
        Peter Zijlstra <peterz@infradead.org>,
        Robert Richter <robert.richter@amd.com>,
        Stephane Eranian <eranian@google.com>,
        Thomas Gleixner <tglx@linutronix.de>, yrl.pp-manager.tt@hitachi.com
Subject: Re: [GIT PULL 00/12] perf tools fixes
Message-ID: <20110923212523.GD27519@ghostprotocols.net>
References: <1316809586-28529-1-git-send-email-acme@infradead.org> <CA+55aFwVrvMa1z7P5q0kUN3QAwZzTdL1mhLaF7+etHYQm511vA@mail.gmail.com> <CA+55aFysPyDCjs3MTwHBRWVq5OTU=-aWCRiJP=VZL-EdCGNU0w@mail.gmail.com> <20110923211158.GC27519@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110923211158.GC27519@ghostprotocols.net>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, Sep 23, 2011 at 06:11:58PM -0300, Arnaldo Carvalho de Melo escreveu:
> Em Fri, Sep 23, 2011 at 02:05:25PM -0700, Linus Torvalds escreveu:
> > On Fri, Sep 23, 2011 at 2:03 PM, Linus Torvalds
> > <torvalds@linux-foundation.org> wrote:
> > >
> > > But it obviously doesn't affect the kernel compile. It *does* affect
> > > the perf tool compile, and util/python.c no longer compiles because
> > > the byte-swap flag isn't passed to it.
> > 
> > This stupid patch makes it compile. But see the comment..
> 
> Yes, this is what I was going to push and will if you haven't already
> done so, did you?

Well, its in that branch now.

It should be 0 or false for that last parm (swapped) because in the
python binding we're not processing perf.data files that may have been
captured on another machine of a different endianness, but an events
stream in the same machine.

Sorry about the noise, there is a problem in the way the python binding
is built, i.e. it should notice that the header changed and rebuild the
python binding, I bet this was what made David not notice it :-\

You noticed it probably because it was the first build of the tool on
your local repo or used a new O= output dir.

- Arnaldo
