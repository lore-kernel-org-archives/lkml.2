Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752657Ab1K1O7c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 09:59:32 -0500
Received: from casper.infradead.org ([85.118.1.10]:55629 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750981Ab1K1O7b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 09:59:31 -0500
Date: Mon, 28 Nov 2011 12:59:17 -0200
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Robert Richter <robert.richter@amd.com>,
        Andrew Vagin <avagin@openvz.org>, linux-kernel@vger.kernel.org,
        paulus@samba.org, mingo@elte.hu, asharma@fb.com, devel@openvz.org,
        dsahern@gmail.com, linux-perf-users@vger.kernel.org
Subject: Re: [PATCH 7/7] event: add tracepoint for accounting block time
Message-ID: <20111128145917.GB12377@infradead.org>
References: <1322471015-107825-1-git-send-email-avagin@openvz.org>
 <1322471015-107825-8-git-send-email-avagin@openvz.org>
 <1322480531.2921.107.camel@twins>
 <4ED39473.9080600@linux.intel.com>
 <20111128143140.GA12377@infradead.org>
 <4ED39E17.7050807@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4ED39E17.7050807@linux.intel.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Nov 28, 2011 at 06:43:35AM -0800, Arjan van de Ven escreveu:
> > perf_evlist is what you call perf_bundle and perf_evsel is what you call
> > perf_event in powertop.

> > That part of the API should be ok for wider use and is in fact exported
> > in the python binding.
> 
> I don't care about the snake language.

I haven't suggested that you use any other language than C.

What I tried to say was that the way the python binding was written
provides an initial libperf.so, just that it is not exposed yet.

That is, the subset of C files there is (or should be) untangled from
all the rest of tools/perf.
 
> frankly all that's missing is a "safe" accessor library as Steve has
> promised will appear.

> that library really needs to be a proper shared library and not come
> from/with the kernel package, so that distributions can independently
> package it properly.

I can probably have something like:

[acme@emilia linux]$ make help | grep perf
  perf-tar-src-pkg    - Build perf-3.2.0-rc1.tar source tarball
  perf-targz-src-pkg  - Build perf-3.2.0-rc1.tar.gz source tarball
  perf-tarbz2-src-pkg - Build perf-3.2.0-rc1.tar.bz2 source tarball
  perf-tarxz-src-pkg  - Build perf-3.2.0-rc1.tar.xz source tarball
[acme@emilia linux]$ 

i.e.:

$ make libperf-tar-src.pkg

> (and this obviously needs to at least look at the things that the
> systemd guys pointed us at at the kernel summit)

Yes, I'll take that into account.
 
> I'm not interested if the code for a library is somewhere deep in the
> kernel source code, not installed by default in distros (or tied in with
> loads of other mess) and/or uses the kernel makefiles/etc like perf does.

Right, I'm working on that, don't know when it will get to the point
you'd consider using it, but I'll try to address your concerns in the
process.

- Arnaldo
