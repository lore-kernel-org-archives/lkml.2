Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755412Ab1JWL3B (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Oct 2011 07:29:01 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:32954 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754586Ab1JWL3A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Oct 2011 07:29:00 -0400
Date: Sun, 23 Oct 2011 13:27:28 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Robert Richter <robert.richter@amd.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: LKML <linux-kernel@vger.kernel.org>,
        oprofile-list <oprofile-list@lists.sourceforge.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [V2][PATCH 5/5] oprofile, x86: Reimplement nmi timer mode using
 perf event
Message-ID: <20111023112728.GB5156@elte.hu>
References: <1319050075-23901-1-git-send-email-robert.richter@amd.com>
 <1319050075-23901-6-git-send-email-robert.richter@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1319050075-23901-6-git-send-email-robert.richter@amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Robert Richter <robert.richter@amd.com> wrote:

> The legacy x86 nmi watchdog code was removed with the implementation
> of the perf based nmi watchdog. This broke Oprofile's nmi timer
> mode. To run nmi timer mode we relied on a continuous ticking nmi
> source which the nmi watchdog provided. The nmi tick was no longer
> available and current watchdog can not be used anymore since it runs
> with very long periods in the range of seconds. This patch
> reimplements the nmi timer mode using a perf counter nmi source.
> 
> V2:
> * removing pr_info()
> * fix undefined reference to `__udivdi3' for 32 bit build
> * fix section mismatch of .cpuinit.data:nmi_timer_cpu_nb
> * removed nmi timer setup in arch/x86
> * implemented function stubs for op_nmi_init/exit()
> * made code more readable in oprofile_init()
> 
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Signed-off-by: Robert Richter <robert.richter@amd.com>
> ---
>  arch/Kconfig                      |    4 +
>  arch/x86/oprofile/Makefile        |    3 +-
>  arch/x86/oprofile/init.c          |   30 ++-----
>  arch/x86/oprofile/nmi_timer_int.c |   66 --------------
>  drivers/oprofile/nmi_timer_int.c  |  173 +++++++++++++++++++++++++++++++++++++
>  drivers/oprofile/oprof.c          |   24 +++---
>  drivers/oprofile/oprof.h          |    9 ++
>  kernel/events/core.c              |    2 +
>  8 files changed, 208 insertions(+), 103 deletions(-)
>  delete mode 100644 arch/x86/oprofile/nmi_timer_int.c
>  create mode 100644 drivers/oprofile/nmi_timer_int.c

Looks clean to me. Peter, any objections?

Thanks,

	Ingo
