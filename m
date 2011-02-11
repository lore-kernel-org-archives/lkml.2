Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757494Ab1BKAmp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 19:42:45 -0500
Received: from mx1.redhat.com ([209.132.183.28]:31016 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751546Ab1BKAmo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 19:42:44 -0500
Date: Thu, 10 Feb 2011 22:42:32 -0200
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Arun Sharma <arun@sharma-home.net>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-perf-users@vger.kernel.org
Subject: Re: 2.6.37 kernel warning in perf_events code
Message-ID: <20110211004232.GA22440@ghostprotocols.net>
References: <AANLkTi=4_p73eHhQbj5DDDEzTWaLou+u2igiY+yNiPQ9@mail.gmail.com> <20110210190843.GE20676@ghostprotocols.net> <AANLkTi=WRrBnyiDqOeR7PnqVhh8wLFx5W0tgjNaPvkLg@mail.gmail.com> <20110210202023.GG20676@ghostprotocols.net> <AANLkTi=H9+rKjgkmfbS2jzfPjryah0cc9sajSgN8WOaQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTi=H9+rKjgkmfbS2jzfPjryah0cc9sajSgN8WOaQ@mail.gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Feb 10, 2011 at 12:46:07PM -0800, Arun Sharma escreveu:
> On Thu, Feb 10, 2011 at 12:20 PM, Arnaldo Carvalho de Melo wrote:
> >> >> perf record -g -p <pid> cs -o csw.data -- sleep 3

> > Arun, are you shure the above line is right? I guess it should read:

> > perf record -g -p <pid> -e cs -o csw.data -- sleep 3

> > To specify the context switches soft event, right?
> 
> You caught a cut and paste error. I'm pretty sure I had the -e in
> there when the warning triggered. I tried this command a few times,
> just to verify and here's what I found:

> * Under low loads, everything works fine.
> * Under a heavy work load - I'm not able to reproduce the warning, but
> hitting very similar symptoms:

> [ perf record: Captured and wrote 2.282 MB /tmp/junk.data (~99721 samples) ]
> [ perf record: Captured and wrote 1.734 MB /tmp/junk.data (~75740 samples) ]
> [ perf record: Captured and wrote 0.091 MB /tmp/junk.data (~3975
> samples) ]  <--- bad run

> The bad run made my shell unresponsive and took around 30-40 seconds
> to complete (whereas the good runs completed in less than 5 secs).
> Could this be some kind of a feedback loop where what the measurement
> machinery is perturbing what's being measured?

Is it possible for you to test this with 2.6.38-rc4? At least the user
level tools, just do:

[acme@felicio linux]$ make help | grep perf
  perf-tar-src-pkg    - Build perf-2.6.38-rc3.tar source tarball
  perf-targz-src-pkg  - Build perf-2.6.38-rc3.tar.gz source tarball
  perf-tarbz2-src-pkg - Build perf-2.6.38-rc3.tar.bz2 source tarball
[acme@felicio linux]$

Pick one of these targets on the source tree for 2.6.38-rc4, move the
tarball to the machine where you need to run the older kernel (.37,
right?) and try building and running it there.

Either or just build the new tools and run it on the older kernel.

There were several changes to better inform about lost events due to
heavy load that may be at play in your case.

- Arnaldo
