Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756137Ab1E3KKE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 06:10:04 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:52118 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755361Ab1E3KKD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 06:10:03 -0400
Date: Mon, 30 May 2011 12:09:56 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Robert Richter <robert.richter@amd.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "oprofile-list@lists.sourceforge.net" 
	<oprofile-list@lists.sourceforge.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [GIT PULL] oprofile fixes for v2.6.40
Message-ID: <20110530100956.GA17821@elte.hu>
References: <20110526133948.GX20052@erda.amd.com>
 <20110527122301.GA32754@elte.hu>
 <20110530100039.GB20052@erda.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110530100039.GB20052@erda.amd.com>
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


* Robert Richter <robert.richter@amd.com> wrote:

> > But i really do not see how this can work. get_eilvt() twiddles 
> > the APIC LVT of this current CPU. Does IBS only activate on a 
> > single CPU? How will this LVT entry be cleared on deinit?
> 
> This is done on the current cpu to get the offset which is then 
> used on all cpus of the system. The actually per-core setup for ibs 
> is in op_amd_setup_ctrs(). Deinit is in op_amd_cpu_shutdown().

The way IBS is set up is not very obvious and atypical of existing 
preempt_*() patters. Might be worth adding a comment to the 
preempt_disable(), to unconfuse unsuspecting readers who are 
wondering about its oddness?

Anyway, i suspected that it was correctly working code so i pulled it 
and pushed it to Linus, it should all be in 3.0-rc1.

Thanks,

	Ingo
