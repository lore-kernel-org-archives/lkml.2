Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755041Ab2EOKNV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 06:13:21 -0400
Received: from casper.infradead.org ([85.118.1.10]:46096 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752032Ab2EOKNT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 06:13:19 -0400
Message-ID: <1337076781.27694.15.camel@twins>
Subject: Re: [PATCH v5 6/7] x86/tlb: optimizing flush_tlb_mm
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Nick Piggin <npiggin@gmail.com>
Cc: Alex Shi <alex.shi@intel.com>, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, arnd@arndb.de, rostedt@goodmis.org, fweisbec@gmail.com,
        jeremy@goop.org, riel@redhat.com, luto@mit.edu, avi@redhat.com,
        len.brown@intel.com, dhowells@redhat.com, fenghua.yu@intel.com,
        borislav.petkov@amd.com, yinghai@kernel.org, ak@linux.intel.com,
        cpw@sgi.com, steiner@sgi.com, akpm@linux-foundation.org,
        penberg@kernel.org, hughd@google.com, rientjes@google.com,
        kosaki.motohiro@jp.fujitsu.com, n-horiguchi@ah.jp.nec.com,
        tj@kernel.org, oleg@redhat.com, axboe@kernel.dk, jmorris@namei.org,
        kamezawa.hiroyu@jp.fujitsu.com, viro@zeniv.linux.org.uk,
        linux-kernel@vger.kernel.org, yongjie.ren@intel.com,
        linux-arch@vger.kernel.org
Date: Tue, 15 May 2012 12:13:01 +0200
In-Reply-To: <CAPa8GCDgg9EUKvDHXtybBKtBhbRK-NAALR5f7+UU=S6XvPL_cw@mail.gmail.com>
References: <1337072138-8323-1-git-send-email-alex.shi@intel.com>
	 <1337072138-8323-7-git-send-email-alex.shi@intel.com>
	 <CAPa8GCDsSOrzQwX2qRJyocYAZdGbwjD4t4fjxmWXV6=EoXjXZw@mail.gmail.com>
	 <1337073529.27694.8.camel@twins>
	 <CAPa8GCBaQhksvVT9DAgwzPPkCMrhcYnSdCtUHEe=cQS8_Cm7DQ@mail.gmail.com>
	 <1337076027.27694.13.camel@twins>
	 <CAPa8GCDgg9EUKvDHXtybBKtBhbRK-NAALR5f7+UU=S6XvPL_cw@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-05-15 at 20:06 +1000, Nick Piggin wrote:
> On 15 May 2012 20:00, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> > On Tue, 2012-05-15 at 19:52 +1000, Nick Piggin wrote:
> >>
> >> It could be warranted to change tlb_flush_mmu to a range API to
> >> avoid doing the per-entry tracking which those architectures do?
> >
> > The per-entry could result in a much smaller range, there's no point in
> > flushing tlbs for unpopulated pages.
> 
> Well common case for small ranges hopefully would be quite dense
> I think. It could be not worth the extra work (although maybe it would
> be).
> 
> >
> > Anyway, I don't think even think we'd need to change the API for that,
> > you could track the entire range through tlb_start_vma() if you wanted
> > (although nobody does that IIRC).
> 
> I'm not sure if you can do that very well, because the tlb might have to
> be flushed part way through a vma when we fill up the gather, so you
> don't want to flush the full range each time.


Fair enough. But that's still an entirely unrelated optimization and
should go with proper benchmarking and preferably across all archs that
have flush_tlb_range() :-)
