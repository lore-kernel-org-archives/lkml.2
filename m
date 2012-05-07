Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756609Ab2EGLkM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 07:40:12 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:44891 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756489Ab2EGLkH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 07:40:07 -0400
Date: Mon, 7 May 2012 13:40:01 +0200
From: Ingo Molnar <mingo@kernel.org>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: x86@kernel.org, kvm@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, gleb@redhat.com,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC 0/5] apic: eoi optimization support
Message-ID: <20120507114001.GA15186@gmail.com>
References: <cover.1334833140.git.mst@redhat.com>
 <20120507103512.GG23002@gmail.com>
 <20120507105910.GA18943@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120507105910.GA18943@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Michael S. Tsirkin <mst@redhat.com> wrote:

> On Mon, May 07, 2012 at 12:35:12PM +0200, Ingo Molnar wrote:
> > > Michael S. Tsirkin (5):
> > >   apic: fix typo EIO_ACK -> EOI_ACK and document
> > >   apic: use symbolic APIC_EOI_ACK
> > >   x86: add apic->eoi_write callback
> > >   x86: eoi micro-optimization
> > >   kvm_para: guest side for eoi avoidance
> > > 
> > >  arch/x86/include/asm/apic.h            |   22 ++++++++++++--
> > >  arch/x86/include/asm/apicdef.h         |    2 +-
> > >  arch/x86/include/asm/bitops.h          |    6 ++-
> > >  arch/x86/include/asm/kvm_para.h        |    2 +
> > >  arch/x86/kernel/apic/apic_flat_64.c    |    2 +
> > >  arch/x86/kernel/apic/apic_noop.c       |    1 +
> > >  arch/x86/kernel/apic/apic_numachip.c   |    1 +
> > >  arch/x86/kernel/apic/bigsmp_32.c       |    1 +
> > >  arch/x86/kernel/apic/es7000_32.c       |    2 +
> > >  arch/x86/kernel/apic/numaq_32.c        |    1 +
> > >  arch/x86/kernel/apic/probe_32.c        |    1 +
> > >  arch/x86/kernel/apic/summit_32.c       |    1 +
> > >  arch/x86/kernel/apic/x2apic_cluster.c  |    1 +
> > >  arch/x86/kernel/apic/x2apic_phys.c     |    1 +
> > >  arch/x86/kernel/apic/x2apic_uv_x.c     |    1 +
> > >  arch/x86/kernel/kvm.c                  |   51 ++++++++++++++++++++++++++++++--
> > >  arch/x86/platform/visws/visws_quirks.c |    2 +-
> > >  17 files changed, 88 insertions(+), 10 deletions(-)
> > 
> > No objections from the x86 side.
> 
> Is kvm.git a good tree to merge this through?

Fine to me, but I haven't checked how widely it conflicts with 
existing bits: by the looks of it most of the linecount is on 
the core x86 side, while the kvm change is well concentrated.

> > In terms of advantages, could you please create perf stat 
> > runs that counts the number of MMIOs or so? That should show 
> > a pretty obvious improvement - and that is enough as proof, 
> > no need to try to reproduce the performance win in a noisy 
> > benchmark.
> 
> You mean with kvm PV, right? On real hardware the 
> micro-optimization removes branches and maybe cache-misses but 
> I don't see why would it reduce MMIOs.

Yeah, on KVM. On real hw I doubt it's measurable.

Thanks,

	Ingo
