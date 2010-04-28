Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753986Ab0D1OOM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 10:14:12 -0400
Received: from tomts13-srv.bellnexxia.net ([209.226.175.34]:63953 "EHLO
	tomts13-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750945Ab0D1OOK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 10:14:10 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEANfa10tGGNqG/2dsb2JhbACcbnK9OYUOBINX
Date: Wed, 28 Apr 2010 10:09:02 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Tony Breeds <tony@bakeyournoodle.com>, linux-kernel@vger.kernel.org,
       dank@kegel.com
Subject: Re: [PATCH 00/11] jump label v7
Message-ID: <20100428140902.GB4662@Krystal>
References: <cover.1271427118.git.jbaron@redhat.com> <20100422.161700.191166551.davem@davemloft.net> <20100427.175858.134109609.davem@davemloft.net> <20100428013951.GM12389@ozlabs.org> <20100428014941.GA8389@Krystal> <20100428020819.GN12389@ozlabs.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20100428020819.GN12389@ozlabs.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 09:57:37 up 20 days, 23:51,  3 users,  load average: 0.16, 0.18,
	0.18
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Tony Breeds (tony@bakeyournoodle.com) wrote:
> On Tue, Apr 27, 2010 at 09:49:41PM -0400, Mathieu Desnoyers wrote:
> 
> > The crosstool package from Dan Kegel did a good job for this. Not sure
> > it's currently maintained though. It was a very useful project, it's a
> > shame if it does not live on. It would be good to have up-to-date and
> > tested compilers for various architectures available on kernel.org,
> > ideally with access to a package that helps building compilers for
> > various architectures.
> 
> Trimmed the CC' as this is a bit of a tangent.
> 
> Crosstool did a good job but seems to be less current than we'd like for the
> kernel[1].

Ouch. The build failure ratio is surprisingly high.

>            When using crosstool in the past I found a lot of the complexity
> was in *libc to the toolcahins I've built don';t have a libc so they're only
> helpful for kernel (or similar) builds.

So maybe we could do something more specialized for kernel needs, e.g. a
kcrosstool ? It could be a "simplified" crosstool.

Personally, I built a set of cross-compilers with crosstool 0.43 a while
ago, but must now do a lot of trial and error to find new correct compiler
and toolchain versions for each architecture. It would be good to have a
kcrosstool git repository that would:

- Have scripts and documentation specialized for Linux kernel build.
- Contain an updated list of "working" and "non-working" toolchain
  versions for each arch.
- Could be easily updated; people would just have to report
  success/failure of their config so these could be added to the git
  repository. The build could probably prepare a report automatically to
  lessen the reporter job (I'm even thinking about a scheme that would
  give the option to report automatically).
- Optionally contain documentation on how to set up a cron job to
  automatically fetch a git tree and do a distributed multi-architecture
  build each day.

I think have this kind of updated tool would be of great value for
testing.

Thanks,

Mathieu

> 
> In terms of "testing", I build a kernel for each toolchain but I don't boot
> them and in the past I think blackfin said that what I had wouldn't actually be
> runable.  Last time I looked the wasn't a non-intel cross-toolchain for blackfin.
> 
> I shoudl also mention that a subset of these compilers are used to build test
> linux-next daily.
> 
> Yours Tony
> 
> [1] http://www.kegel.com/crosstool/crosstool-0.43/buildlogs/

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
