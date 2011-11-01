Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932184Ab1KARyQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 13:54:16 -0400
Received: from db3ehsobe005.messaging.microsoft.com ([213.199.154.143]:2727
	"EHLO DB3EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753752Ab1KARyP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 13:54:15 -0400
X-SpamScore: -12
X-BigFish: VPS-12(zz1432N98dK4015Lzz1202hzz8275bhz32i668h839h944h)
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-FB-SS: 13,
X-WSS-ID: 0LTZTQ5-02-5IO-02
X-M-MSG: 
Date: Tue, 1 Nov 2011 18:54:05 +0100
From: Robert Richter <robert.richter@amd.com>
To: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
        oprofile-list <oprofile-list@lists.sourceforge.net>
Subject: Re: [V2][PATCH 5/5] oprofile, x86: Reimplement nmi timer mode using
 perf event
Message-ID: <20111101175405.GP20173@erda.amd.com>
References: <1319050075-23901-1-git-send-email-robert.richter@amd.com>
 <1319050075-23901-6-git-send-email-robert.richter@amd.com>
 <20111023112728.GB5156@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20111023112728.GB5156@elte.hu>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23.10.11 07:27:28, Ingo Molnar wrote:
> 
> * Robert Richter <robert.richter@amd.com> wrote:
> 
> > The legacy x86 nmi watchdog code was removed with the implementation
> > of the perf based nmi watchdog. This broke Oprofile's nmi timer
> > mode. To run nmi timer mode we relied on a continuous ticking nmi
> > source which the nmi watchdog provided. The nmi tick was no longer
> > available and current watchdog can not be used anymore since it runs
> > with very long periods in the range of seconds. This patch
> > reimplements the nmi timer mode using a perf counter nmi source.
> > 
> > V2:
> > * removing pr_info()
> > * fix undefined reference to `__udivdi3' for 32 bit build
> > * fix section mismatch of .cpuinit.data:nmi_timer_cpu_nb
> > * removed nmi timer setup in arch/x86
> > * implemented function stubs for op_nmi_init/exit()
> > * made code more readable in oprofile_init()
> > 
> > Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > Signed-off-by: Robert Richter <robert.richter@amd.com>
> > ---
> >  arch/Kconfig                      |    4 +
> >  arch/x86/oprofile/Makefile        |    3 +-
> >  arch/x86/oprofile/init.c          |   30 ++-----
> >  arch/x86/oprofile/nmi_timer_int.c |   66 --------------
> >  drivers/oprofile/nmi_timer_int.c  |  173 +++++++++++++++++++++++++++++++++++++
> >  drivers/oprofile/oprof.c          |   24 +++---
> >  drivers/oprofile/oprof.h          |    9 ++
> >  kernel/events/core.c              |    2 +
> >  8 files changed, 208 insertions(+), 103 deletions(-)
> >  delete mode 100644 arch/x86/oprofile/nmi_timer_int.c
> >  create mode 100644 drivers/oprofile/nmi_timer_int.c
> 
> Looks clean to me. Peter, any objections?

Peter, I guess V2 is ok for you too?

Thanks,

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

