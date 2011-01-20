Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753917Ab1ATIbJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 03:31:09 -0500
Received: from freeflow.nu ([178.79.134.28]:46507 "EHLO freeflow.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751782Ab1ATIbH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 03:31:07 -0500
Message-ID: <4D37F2C9.8000906@kernel.org>
Date: Thu, 20 Jan 2011 10:31:05 +0200
From: Pekka Enberg <penberg@kernel.org>
User-Agent: Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.6; en-US; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Tejun Heo <tj@kernel.org>, Pekka Enberg <penberg@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: percpu related boot crash on x86
References: <AANLkTimajU0x1v6y3rH2+jr-bZ=tNLs1S_agXdGGAa3S@mail.gmail.com> <20110119120200.GA1057@elte.hu> <1295441307.28776.15.camel@laptop> <AANLkTi=gxMkzO63RAWiuFt9vp57dvi4d=TaT=NmuvyY2@mail.gmail.com> <20110119131329.GB14096@mtj.dyndns.org> <20110119205353.GA14810@elte.hu> <20110119231116.GA3896@elte.hu>
In-Reply-To: <20110119231116.GA3896@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/20/11 1:11 AM, Ingo Molnar wrote:
>
> * Ingo Molnar<mingo@elte.hu>  wrote:
>
>> Btw., based on Peter's suggestion i tried the limit-bumping hack below - but it
>> did not help, the crash still triggers on 5%-10% of all randconfig bootups.
>
> I'm now running tests with MAXSMP forcibly disabled - and there are no crashes after
> 69 randconfig iteration. Before it would crash within 10 iterations.
>
> So it seems the MAXSMP sizing tests triggers a new percpu regression.

It needs CONFIG_DEBUG_PAGEALLOC to trigger. As the comment in 
vmap_debug_free_range() already says "it's going to be slow" I wonder if 
we could just hack around the problem by adding a

   if (!irqs_disabled())

guard around the debugging code to make vfree() always work with IRQs 
disabled.

			Pekka
