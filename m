Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756922Ab0GAPvm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 11:51:42 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:48732 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756703Ab0GAPvl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 11:51:41 -0400
Subject: Re: [RFC PATCH 3/6] perf: Generalize some arch callchain code
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>,
       Stephane Eranian <eranian@google.com>,
       David Miller <davem@davemloft.net>, Paul Mundt <lethal@linux-sh.org>,
       Will Deacon <will.deacon@arm.com>, Borislav Petkov <bp@amd64.org>
In-Reply-To: <20100701154922.GC10616@nowhere>
References: <1277998562-21366-1-git-send-regression-fweisbec@gmail.com>
	 <1277998562-21366-4-git-send-regression-fweisbec@gmail.com>
	 <1277999161.1917.216.camel@laptop>  <20100701154922.GC10616@nowhere>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 01 Jul 2010 17:51:22 +0200
Message-ID: <1277999482.1917.219.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-07-01 at 17:49 +0200, Frederic Weisbecker wrote:
> On Thu, Jul 01, 2010 at 05:46:01PM +0200, Peter Zijlstra wrote:
> > On Thu, 2010-07-01 at 17:35 +0200, Frederic Weisbecker wrote:
> > > - Most archs use one callchain buffer per cpu, except x86 that needs
> > >   to deal with NMIs. Provide a default perf_callchain_buffer()
> > >   implementation that x86 overrides. 
> > 
> > sparc and power also have NMI like contexts.
> 
> 
> Ah and the comments suggest it's because pmu interrupts can't nest or so.
> Anyway, that's notwithstanding the race that 5th patch fixes.

Right, but they could interrupt a software event or the like.

But yeah, the whole callchain thing can nest issue is real, thanks for
fixing that.
