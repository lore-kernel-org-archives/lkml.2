Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757220Ab0HaLYT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 07:24:19 -0400
Received: from tx2ehsobe005.messaging.microsoft.com ([65.55.88.15]:32646 "EHLO
	TX2EHSOBE010.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756973Ab0HaLYQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 07:24:16 -0400
X-SpamScore: 1
X-BigFish: VPS1(zzbb2cK1432N98dN4015Lzz1202hzz8275dhz32i5bep5bfs61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0L80K4R-02-5JS-02
X-M-MSG: 
Date: Tue, 31 Aug 2010 13:05:17 +0200
From: Robert Richter <robert.richter@amd.com>
To: Matt Fleming <matt@console-pimps.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Will Deacon <will.deacon@arm.com>, Paul Mundt <lethal@linux-sh.org>,
        Russell King <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-sh@vger.kernel.org" <linux-sh@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>
Subject: Re: [PATCH V2 0/4] Generalise ARM perf-events backend for oprofile
Message-ID: <20100831110517.GE22783@erda.amd.com>
References: <cover.1282848651.git.matt@console-pimps.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <cover.1282848651.git.matt@console-pimps.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26.08.10 15:09:15, Matt Fleming wrote:
> The perf-events backend for OProfile that Will Deacon wrote in
> 8c1fc96f6fd1f361428ba805103af0d0eee65179 ("ARM: 6072/1: oprofile: use
> perf-events framework as backend") is of use to more architectures
> than just ARM. Move the code into drivers/oprofile/ so that SH can use
> it instead of the nearly identical copy of its OProfile code.
> 
> The benefit of the backend is that it becomes necessary to only
> maintain one copy of the PMU accessor functions for each architecture,
> with bug fixes and new features benefiting both OProfile and perf.
> 
> Note that I haven't been able to test these patches on an ARM board to
> see if I've caused any regressions. If anyone else could do that I'd
> appreciate it. Though, I have been able to compile this version of the
> series.
> 
> This patch series is based on tip/master.

Matt,

please rebase your next version of this patch set to

 git://git.kernel.org/pub/scm/linux/kernel/git/rric/oprofile.git core

It contains Will's patches.

Thanks,

-Robert

> 
> Changes from v1:
>  - Prefix the new functons with "oprofile_" instead of "op_".
>  - Fix ARM compilation errors
>  - Move all the oprofile-perf logic into oprofile_perf.c
>  - Include cleanup patch from Will
> 
> Matt Fleming (3):
>   sh: Accessor functions for the sh_pmu state
>   oprofile: Abstract the perf-events backend
>   sh: Use the perf-events backend for oprofile
> 
> Will Deacon (1):
>   oprofile: Handle initialisation failure more gracefully
> 
>  arch/arm/oprofile/Makefile       |    4 +
>  arch/arm/oprofile/common.c       |  228 ++++----------------------------------
>  arch/sh/include/asm/perf_event.h |    2 +
>  arch/sh/kernel/perf_event.c      |   13 ++
>  arch/sh/oprofile/Makefile        |    2 +-
>  arch/sh/oprofile/common.c        |   96 +++-------------
>  arch/sh/oprofile/op_impl.h       |   33 ------
>  drivers/oprofile/oprofile_perf.c |  209 ++++++++++++++++++++++++++++++++++
>  include/linux/oprofile.h         |   12 ++
>  9 files changed, 283 insertions(+), 316 deletions(-)
>  delete mode 100644 arch/sh/oprofile/op_impl.h
>  create mode 100644 drivers/oprofile/oprofile_perf.c
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

