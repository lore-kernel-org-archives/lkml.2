Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755594Ab2EGK7M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 06:59:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5374 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752387Ab2EGK7K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 06:59:10 -0400
Date: Mon, 7 May 2012 13:59:11 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: x86@kernel.org, kvm@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, gleb@redhat.com,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC 0/5] apic: eoi optimization support
Message-ID: <20120507105910.GA18943@redhat.com>
References: <cover.1334833140.git.mst@redhat.com>
 <20120507103512.GG23002@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120507103512.GG23002@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 07, 2012 at 12:35:12PM +0200, Ingo Molnar wrote:
> > Michael S. Tsirkin (5):
> >   apic: fix typo EIO_ACK -> EOI_ACK and document
> >   apic: use symbolic APIC_EOI_ACK
> >   x86: add apic->eoi_write callback
> >   x86: eoi micro-optimization
> >   kvm_para: guest side for eoi avoidance
> > 
> >  arch/x86/include/asm/apic.h            |   22 ++++++++++++--
> >  arch/x86/include/asm/apicdef.h         |    2 +-
> >  arch/x86/include/asm/bitops.h          |    6 ++-
> >  arch/x86/include/asm/kvm_para.h        |    2 +
> >  arch/x86/kernel/apic/apic_flat_64.c    |    2 +
> >  arch/x86/kernel/apic/apic_noop.c       |    1 +
> >  arch/x86/kernel/apic/apic_numachip.c   |    1 +
> >  arch/x86/kernel/apic/bigsmp_32.c       |    1 +
> >  arch/x86/kernel/apic/es7000_32.c       |    2 +
> >  arch/x86/kernel/apic/numaq_32.c        |    1 +
> >  arch/x86/kernel/apic/probe_32.c        |    1 +
> >  arch/x86/kernel/apic/summit_32.c       |    1 +
> >  arch/x86/kernel/apic/x2apic_cluster.c  |    1 +
> >  arch/x86/kernel/apic/x2apic_phys.c     |    1 +
> >  arch/x86/kernel/apic/x2apic_uv_x.c     |    1 +
> >  arch/x86/kernel/kvm.c                  |   51 ++++++++++++++++++++++++++++++--
> >  arch/x86/platform/visws/visws_quirks.c |    2 +-
> >  17 files changed, 88 insertions(+), 10 deletions(-)
> 
> No objections from the x86 side.

Is kvm.git a good tree to merge this through?

> In terms of advantages, could you please create perf stat runs 
> that counts the number of MMIOs or so? That should show a pretty 
> obvious improvement - and that is enough as proof, no need to 
> try to reproduce the performance win in a noisy benchmark.

You mean with kvm PV, right? On real hardware the micro-optimization
removes branches and maybe cache-misses but I don't see why would it
reduce MMIOs.

-- 
MST
