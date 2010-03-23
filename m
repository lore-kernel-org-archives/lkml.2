Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753932Ab0CWO3n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 10:29:43 -0400
Received: from casper.infradead.org ([85.118.1.10]:33438 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753899Ab0CWO3k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 10:29:40 -0400
Date: Tue, 23 Mar 2010 11:29:27 -0300
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Soeren Sandmann <sandmann@daimi.au.dk>, Joerg Roedel <joro@8bytes.org>,
       Ingo Molnar <mingo@elte.hu>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Avi Kivity <avi@redhat.com>,
       Sheng Yang <sheng@linux.intel.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
       Jes Sorensen <Jes.Sorensen@redhat.com>, Gleb Natapov <gleb@redhat.com>,
       Zachary Amsden <zamsden@redhat.com>, zhiteng.huang@intel.com,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH] Enhance perf to collect KVM guest os statistics from
	host side
Message-ID: <20100323142927.GF4066@ghostprotocols.net>
References: <20100319082122.GE12576@elte.hu> <20100319172903.GI13108@8bytes.org> <20100321184300.GB25922@elte.hu> <20100322101451.GK13108@8bytes.org> <20100322105927.GB3483@elte.hu> <20100322114744.GC1940@8bytes.org> <ye88w9j2n2y.fsf@camel23.daimi.au.dk> <878w9jdu7m.fsf@basil.nowhere.org> <ye84ok72kxi.fsf@camel23.daimi.au.dk> <87vdcnce78.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87vdcnce78.fsf@basil.nowhere.org>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Mar 23, 2010 at 03:20:11PM +0100, Andi Kleen escreveu:
> Soeren Sandmann <sandmann@daimi.au.dk> writes:
> > I don't think the oprofile JIT interface solves any of these
> > problems. (In fact, I don't see why the JIT problem is even hard. The
> > JIT compiler can just generate a little ELF file with symbols in it,
> > and the profiler can pick it up through the mmap events that you get
> > through the perf interface).
> 
> That would require keeping those temporary ELF files for
> potentially unlimited time around (profilers today look at the ELF
> files at the final analysis phase, which might be weeks away)

'perf record' will traverse the perf.data file just collected and, if the
binaries have build-ids, will stash them in ~/.debug/, keyed by build-id
just like the -debuginfo packages do.

So only the binaries with hits. Also one can use 'perf archive' to
create a tar.bz2 file with the files with hits for the specified
perf.data file, that can then be transfered to another machine, whatever
arch, untarred at ~/.debug and then the report can be done there.

As it is done by build-id, multiple 'perf record' sessions share files
in the cache.

Right now the whole ELF file (or /proc/kallsyms copy) is stored if
collected from the DSO directly, or the bits that are stored in
-debuginfo files if we find it installed (so smaller). We could strip
that down further by storing just the ELF sections needed to make sense
of the symtab.

- Arnaldo
