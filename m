Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755978Ab1E3KQ1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 06:16:27 -0400
Received: from ch1ehsobe002.messaging.microsoft.com ([216.32.181.182]:13030
	"EHLO CH1EHSOBE014.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755536Ab1E3KQZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 06:16:25 -0400
X-SpamScore: -11
X-BigFish: VPS-11(zz146fK1432N98dKzz1202hzz8275bhz32i668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LM0778-02-1MZ-02
X-M-MSG: 
Date: Mon, 30 May 2011 12:16:19 +0200
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "oprofile-list@lists.sourceforge.net" 
	<oprofile-list@lists.sourceforge.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [GIT PULL] oprofile fixes for v2.6.40
Message-ID: <20110530101619.GC20052@erda.amd.com>
References: <20110526133948.GX20052@erda.amd.com>
 <20110527122301.GA32754@elte.hu>
 <20110530100039.GB20052@erda.amd.com>
 <20110530100956.GA17821@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20110530100956.GA17821@elte.hu>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 30.05.11 06:09:56, Ingo Molnar wrote:
> 
> * Robert Richter <robert.richter@amd.com> wrote:
> 
> > > But i really do not see how this can work. get_eilvt() twiddles 
> > > the APIC LVT of this current CPU. Does IBS only activate on a 
> > > single CPU? How will this LVT entry be cleared on deinit?
> > 
> > This is done on the current cpu to get the offset which is then 
> > used on all cpus of the system. The actually per-core setup for ibs 
> > is in op_amd_setup_ctrs(). Deinit is in op_amd_cpu_shutdown().
> 
> The way IBS is set up is not very obvious and atypical of existing 
> preempt_*() patters. Might be worth adding a comment to the 
> preempt_disable(), to unconfuse unsuspecting readers who are 
> wondering about its oddness?

Yes, will add some comments.

> Anyway, i suspected that it was correctly working code so i pulled it 
> and pushed it to Linus, it should all be in 3.0-rc1.

Have seen it, thanks Ingo,

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

