Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756532Ab2EOJTT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 05:19:19 -0400
Received: from casper.infradead.org ([85.118.1.10]:45174 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754608Ab2EOJTS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 05:19:18 -0400
Message-ID: <1337073529.27694.8.camel@twins>
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
Date: Tue, 15 May 2012 11:18:49 +0200
In-Reply-To: <CAPa8GCDsSOrzQwX2qRJyocYAZdGbwjD4t4fjxmWXV6=EoXjXZw@mail.gmail.com>
References: <1337072138-8323-1-git-send-email-alex.shi@intel.com>
	 <1337072138-8323-7-git-send-email-alex.shi@intel.com>
	 <CAPa8GCDsSOrzQwX2qRJyocYAZdGbwjD4t4fjxmWXV6=EoXjXZw@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-05-15 at 19:15 +1000, Nick Piggin wrote:
> So this should go to linux-arch...
> 
> On 15 May 2012 18:55, Alex Shi <alex.shi@intel.com> wrote:
> > Not every flush_tlb_mm execution moment is really need to evacuate all
> > TLB entries, like in munmap, just few 'invlpg' is better for whole
> > process performance, since it leaves most of TLB entries for later
> > accessing.
> >
> > This patch is changing flush_tlb_mm(mm) to flush_tlb_mm(mm, start, end)
> > in cases.
> 
> What happened with Peter's comment about using flush_tlb_range for this?
> 
> flush_tlb_mm() API should just stay unchanged AFAIKS.
> 
> Then you need to work out the best way to give range info to the tlb/mmu gather
> API. Possibly passing in the rage for that guy is OK, which x86 can
> then implement
> as flush range.

Right, most archs that have tlb_flush_range() do range tracking in
mmu_gather. Our TLB ops fully support that, there's absolutely no need
to go change the interface for thos.
