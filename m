Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754015Ab0K3Rc7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 12:32:59 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:60847 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752052Ab0K3Rc6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 12:32:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=hHKlpi7wmFX2vyJcHLH4vSz8l1U3h2tSzZB1SIeY9MSs9DRgYpl3sCf3tEUgIHQIon
         I5ro29f9OinzBPQMiGv6hGQxbcNlfWsaWw/oo13/xJcfuT4thU6sGaZ58nbxY0k17xpo
         faV8sPNa7vw4ib5y6JJ1QN6atekajprUmP5Ss=
Date: Tue, 30 Nov 2010 20:32:54 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de,
        hpa@zytor.com, x86@kernel.org, eric.dumazet@gmail.com,
        yinghai@kernel.org, brgerst@gmail.com, penberg@kernel.org
Subject: Re: [PATCH UPDATED 04/16] x86: Use local variable to cache
	smp_processor_id() in setup_local_APIC()
Message-ID: <20101130173254.GA20818@lenovo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 30, 2010 at 05:17:19PM +0100, Tejun Heo wrote:
> Subject: x86: Use local variable to cache smp_processor_id() in setup_local_APIC()
> 
> This is a trivial clean up.
> 
> * Move initialization of @cpu inside preemption disabled region as
>   suggested by Cyrill Gorcunov.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Yinghai Lu <yinghai@kernel.org>
> Cc: Cyrill Gorcunov <gorcunov@gmail.com>
> ---
> Updated as suggested.  Git tree updated too.
> 
> Thanks.
> 

Thanks Tejun, but please don't modify the snippet below
(ie leave it with smp_processor_id). It happens when preempt
gets enabled again but cpu cached with preempt disabled.
So we should not mess this I believe. ok?

Other than that
Acked-by: Cyrill Gorcunov <gorcunov@gmail.com>

Thanks!

> @@ -1368,7 +1367,7 @@ void __cpuinit setup_local_APIC(void)
> 
>  #ifdef CONFIG_X86_MCE_INTEL
>  	/* Recheck CMCI information after local APIC is up on CPU #0 */
> -	if (smp_processor_id() == 0)
> +	if (cpu == 0)
>  		cmci_recheck();
>  #endif
>  }
> 
  Cyrill
