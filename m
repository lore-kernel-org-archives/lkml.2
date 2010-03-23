Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754486Ab0CWPXX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 11:23:23 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:57196 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754718Ab0CWPXU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 11:23:20 -0400
Subject: Re: [PATCH] Enhance perf to collect KVM guest os statistics from
 host side
From: Peter Zijlstra <peterz@infradead.org>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: Andi Kleen <andi@firstfloor.org>, Soeren Sandmann <sandmann@daimi.au.dk>,
       Joerg Roedel <joro@8bytes.org>, Ingo Molnar <mingo@elte.hu>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Avi Kivity <avi@redhat.com>, Sheng Yang <sheng@linux.intel.com>,
       linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
       Marcelo Tosatti <mtosatti@redhat.com>,
       Jes Sorensen <Jes.Sorensen@redhat.com>, Gleb Natapov <gleb@redhat.com>,
       Zachary Amsden <zamsden@redhat.com>, zhiteng.huang@intel.com,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>
In-Reply-To: <20100323141008.GE4066@ghostprotocols.net>
References: <1268717232.2813.36.camel@localhost>
	 <1268969929.2813.184.camel@localhost> <20100319082122.GE12576@elte.hu>
	 <20100319172903.GI13108@8bytes.org> <20100321184300.GB25922@elte.hu>
	 <20100322101451.GK13108@8bytes.org> <20100322105927.GB3483@elte.hu>
	 <20100322114744.GC1940@8bytes.org> <ye88w9j2n2y.fsf@camel23.daimi.au.dk>
	 <878w9jdu7m.fsf@basil.nowhere.org>
	 <20100323141008.GE4066@ghostprotocols.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 23 Mar 2010 16:23:01 +0100
Message-ID: <1269357781.5109.86.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-03-23 at 11:10 -0300, Arnaldo Carvalho de Melo wrote:
> Em Tue, Mar 23, 2010 at 02:49:01PM +0100, Andi Kleen escreveu:
> > Soeren Sandmann <sandmann@daimi.au.dk> writes:
> > > To fix that problem, it seems like we need some way to have python
> > > export what is going on. Maybe the same mechanism could be used to
> > > both access what is going on in qemu and python.
> > 
> > oprofile already has an interface to let JITs export
> > information about the JITed code. C Python is not a JIT,
> > but presumably one of the python JITs could do it.
> > 
> > http://oprofile.sourceforge.net/doc/devel/index.html
> > 
> > I know it's not envogue anymore and you won't be a approved 
> > cool kid if you do, but you could just use oprofile? 
> 
> perf also has supports for this and Pekka Enberg's jato uses it:
> 
> http://penberg.blogspot.com/2009/06/jato-has-profiler.html

Right, we need to move that into a library though (always meant to do
that, never got around to doing it).

That way the app can link against a dso with weak empty stubs and have
perf record LD_PRELOAD a version that has a suitable implementation.

That all has the advantage of not exposing the actual interface like we
do now.
