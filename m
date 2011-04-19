Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753213Ab1DSRBw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 13:01:52 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:47781 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752081Ab1DSRBv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 13:01:51 -0400
Date: Tue, 19 Apr 2011 19:01:21 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Youquan Song <youquan.song@intel.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        tglx@linutronix.de, hpa@zytor.com, hpa@linux.intel.com,
        suresh.b.siddha@intel.com, yong.y.wang@linux.intel.com,
        joe@perches.com, jbaron@redhat.com, trenn@suse.de, kent.liu@intel.com,
        chaohong.guo@intel.com, Youquan Song <youquan.song@linux.intel.com>
Subject: Re: [PATCH v4 1/2] apic: Fix error interrupt report at all APs
Message-ID: <20110419170121.GA6640@elte.hu>
References: <1302762968-24380-1-git-send-email-youquan.song@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1302762968-24380-1-git-send-email-youquan.song@intel.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
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


* Youquan Song <youquan.song@intel.com> wrote:

> Recently, customer report that once machine boot, there are many error interrupt
> reported with exact number of all APs. 
> 
> The root cause is Local APIC will generate error interrupt when it detect
> the illegal vector (one in 0 ~ 15) in an interrupt message received or
> interrupt generate from local vector table or self IPI. SDM3A.chapter 10.
> 
> AP LAPIC thermal sensor register will be reset to 0x10000, if thermal throttling
> interrupt take over by BIOS, it need restore AP with the thermal sensor register
> value of geting from BSP, otherwise cause system issue. If BIOS does not take
> over the thermal interrupt, The restore value will be CPU rest value of 0x10000,
> which means the interrupt vector is zero. After writing 0x10000 to thermal
> sensor LVT, the processor will recieve the error interrupt report if the APIC
> error interrupt is also set.
> 
> This patch add check the BIOS whether take over the thermal interrupt by look
> at interrupt delivery mode not fixed mode(BIOS handle will be SMI mode) before
> restore AP's thermal LVT. So the agony noise of error interrupt will dismiss
> when boot on machine that BIOS does not handle thermal interrupt..  
> 
> 
> Signed-off-by: Youquan Song <youquan.song@intel.com>
> Acked-by: Suresh Siddha <suresh.b.siddha@intel.com>
> Acked-by: Yong Wang <yong.y.wang@intel.com>
> ---
>  arch/x86/include/asm/apicdef.h           |    1 +
>  arch/x86/kernel/cpu/mcheck/therm_throt.c |   12 +++++++-----
>  2 files changed, 8 insertions(+), 5 deletions(-)

I don't disagree with this change, but unfortunately the changelog is in 
absolutely unreadable English. Please fix it or find someone who can fix it for 
you.

I decoded and fixed the changelog of the 2/2 patch of your series so no need to 
do it for that patch.

Thanks,

	Ingo
