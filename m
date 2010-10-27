Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760945Ab0J0LoU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 07:44:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13462 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753377Ab0J0LoR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 07:44:17 -0400
Date: Wed, 27 Oct 2010 09:43:11 -0200
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Len Brown <lenb@kernel.org>,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH] tools: add x86_energy_perf_policy to program
	MSR_IA32_ENERGY_PERF_BIAS
Message-ID: <20101027114310.GO3826@ghostprotocols.net>
References: <alpine.LFD.2.00.1006161659140.24913@localhost.localdomain> <alpine.LFD.2.00.1009281143070.14962@localhost.localdomain> <alpine.LFD.2.00.1010230035360.29399@localhost.localdomain> <20101026202307.c028e26c.akpm@linux-foundation.org> <20101027060139.GB5603@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101027060139.GB5603@elte.hu>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Oct 27, 2010 at 08:01:39AM +0200, Ingo Molnar escreveu:
> 
> * Andrew Morton <akpm@linux-foundation.org> wrote:
> > On Sat, 23 Oct 2010 00:40:18 -0400 (EDT) Len Brown <lenb@kernel.org> wrote:
> > tools/power/x86, eh?  It seems a better place than under
> > Documentation/, where such things have thus far landed!

> > I looked briefly, wondering about the kbuild situation.  It doesn't
> > appear to be wired up, so one has to manually enter that directory
> > and type `make'?

> > I guess that's OK as an interim thing but longer-term I suppose we
> > should have some more complete build and deployment system.  So
> > (thinking out loud) a `make' would invoke a `make tools', and that
> > `make tools' would build the tools which are specific to the target
> > arch[*], and any generic ones.  And a `make tools_install' would
> > install those tools in, I guess, /lib/modules/$(uname -r)/bin.
 
> In terms of build and documentation environment, tools/perf/ has one
> cloned/inherited from Git, which is rather good and functional.
 
> Sharing it with the kernel's build system depends on the kbuild
> developers being interested in it.

Yes, that is how it is today, I glued it to the main makefile in at
least one case:

[acme@doppio linux]$ make help | grep perf
  perf-tar-src-pkg    - Build perf-2.6.36-rc7.tar source tarball
  perf-targz-src-pkg  - Build perf-2.6.36-rc7.tar.gz source tarball
  perf-tarbz2-src-pkg - Build perf-2.6.36-rc7.tar.bz2 source tarball
[acme@doppio linux]$

I'd love to glue it some more, even using Kconfig and 'make toolsconfig'
for configuring the tools:

	. Want the TUI?
        . Want to link with DWARF? Needed for features x, y and z

Getting it done this way will provide examples that hopefully would lead
to more kernel coding practices and infrastructure being adopted by
(hell is freezing) userland programmers.

This is specially important now that there are more kernel programmers
writing userland code, lets hope that at least them continue to use
those practices and infrastructures ;-)

- Arnaldo
