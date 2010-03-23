Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753605Ab0CWOFF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 10:05:05 -0400
Received: from nfitmail.nfit.au.dk ([130.225.31.129]:7723 "EHLO
	smtp.nfit.au.dk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752258Ab0CWOFB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 10:05:01 -0400
To: Andi Kleen <andi@firstfloor.org>
Cc: Joerg Roedel <joro@8bytes.org>, Ingo Molnar <mingo@elte.hu>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Avi Kivity <avi@redhat.com>,
       Sheng Yang <sheng@linux.intel.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
       Jes Sorensen <Jes.Sorensen@redhat.com>, Gleb Natapov <gleb@redhat.com>,
       Zachary Amsden <zamsden@redhat.com>, zhiteng.huang@intel.com,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH] Enhance perf to collect KVM guest os statistics from host side
References: <1268717232.2813.36.camel@localhost>
	<1268969929.2813.184.camel@localhost> <20100319082122.GE12576@elte.hu>
	<20100319172903.GI13108@8bytes.org> <20100321184300.GB25922@elte.hu>
	<20100322101451.GK13108@8bytes.org> <20100322105927.GB3483@elte.hu>
	<20100322114744.GC1940@8bytes.org>
	<ye88w9j2n2y.fsf@camel23.daimi.au.dk>
	<878w9jdu7m.fsf@basil.nowhere.org>
From: Soeren Sandmann <sandmann@daimi.au.dk>
Date: 23 Mar 2010 15:04:57 +0100
In-Reply-To: <878w9jdu7m.fsf@basil.nowhere.org>
Message-ID: <ye84ok72kxi.fsf@camel23.daimi.au.dk>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.4
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-NFIT-RelayAddr: 130.225.16.142
X-Sim: 5bf2ef2800a0ab240943c089c6942709652bb8f349723604233f2a8ff631e4ef
X-NFIT-Solido-Score: 0.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen <andi@firstfloor.org> writes:

> Soeren Sandmann <sandmann@daimi.au.dk> writes:
> >
> > To fix that problem, it seems like we need some way to have python
> > export what is going on. Maybe the same mechanism could be used to
> > both access what is going on in qemu and python.
> 
> oprofile already has an interface to let JITs export
> information about the JITed code. C Python is not a JIT,
> but presumably one of the python JITs could do it.
> 
> http://oprofile.sourceforge.net/doc/devel/index.html

It's not that I personally want to profile a particular python
program. I'm interested in the more general problem of extracting more
information from profiled user space programs than just stack traces.

Examples:

        - What is going on inside QEMU? 

        - Which client is the X server servicing?

        - What parts of a python/shell/scheme/javascript program is
          taking the most CPU time?

I don't think the oprofile JIT interface solves any of these
problems. (In fact, I don't see why the JIT problem is even hard. The
JIT compiler can just generate a little ELF file with symbols in it,
and the profiler can pick it up through the mmap events that you get
through the perf interface).

> I know it's not envogue anymore and you won't be a approved 
> cool kid if you do, but you could just use oprofile? 

I am bringing this up because I want to extend sysprof to be more
useful. 


Soren
