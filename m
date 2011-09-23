Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752500Ab1IWVF4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 17:05:56 -0400
Received: from casper.infradead.org ([85.118.1.10]:39892 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752364Ab1IWVFy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 17:05:54 -0400
Date: Fri, 23 Sep 2011 18:05:16 -0300
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
Message-ID: <20110923210516.GB27519@ghostprotocols.net>
References: <1316809586-28529-1-git-send-email-acme@infradead.org> <CA+55aFwVrvMa1z7P5q0kUN3QAwZzTdL1mhLaF7+etHYQm511vA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+55aFwVrvMa1z7P5q0kUN3QAwZzTdL1mhLaF7+etHYQm511vA@mail.gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, Sep 23, 2011 at 02:03:34PM -0700, Linus Torvalds escreveu:
> On Fri, Sep 23, 2011 at 1:26 PM, Arnaldo Carvalho de Melo
> <acme@infradead.org> wrote:
> >
> >        Please consider pulling from:
> >
> >  git://github.com/acmel/linux.git perf-tools-for-linus
> 
> Grr. I just did, and then (stupidly) pushed out after checking that my
> kernel compile was fine.
> 
> But it obviously doesn't affect the kernel compile. It *does* affect
> the perf tool compile, and util/python.c no longer compiles because
> the byte-swap flag isn't passed to it. So we get
> 
>   util/python.c: In function ‘pyrf_evlist__read_on_cpu’:
>   util/python.c:806:13: error: too few arguments to function
> ‘perf_event__parse_sample’
>   util/event.h:187:5: note: declared here
>   error: command 'gcc' failed with exit status 1
> 
> because apparently whoever did that used the new WERROR=0 while doing so.
> 
> Grr. So now that totally broken pull got pushed out.

Argh, fixing that...

- Arnaldo
