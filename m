Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751915Ab0FWDIK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 23:08:10 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:44344 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750994Ab0FWDII (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jun 2010 23:08:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ncsvqv0/949qinNQKUjZnPCw7PIDWx9SYwCk12LP2o4wIfICGCqoIBklIJUXJH1/7F
         c3nTwvlNSx18JXQCb0xVkIRE0x/Dt7fZObUC8wIxA5kXsFqxuWn/tgF74suQR8fRwWmu
         eurdj2Y2Y6bHFFTK3TFvsT6/YeaJ78zTkLSSU=
Date: Wed, 23 Jun 2010 05:08:12 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Nobuhiro Iwamatsu <nobuhiro.iwamatsu.yj@renesas.com>,
       Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Paul Mackerras <paulus@samba.org>,
       David Miller <davem@davemloft.net>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH] perf: Fix argument of perf_arch_fetch_caller_regs
Message-ID: <20100623030810.GA5242@nowhere>
References: <AANLkTinKKFKEBQrZ3Hkj-XCaMwaTqulb-XnFzqEYiFRr@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTinKKFKEBQrZ3Hkj-XCaMwaTqulb-XnFzqEYiFRr@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 23, 2010 at 09:17:53AM +0900, Nobuhiro Iwamatsu wrote:
> "struct regs" was set to argument of perf_arch_fetch_caller_regs.
> "struct pt_regs" is correct.
> 
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: David Miller <davem@davemloft.net>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
> Signed-off-by: Nobuhiro Iwamatsu <nobuhiro.iwamatsu.yj@renesas.com>



Acked-by: Frederic Weisbecker <fweisbec@gmail.com>

This may fix CONFIG_PERF_EVENTS=y with archs that don't implement
perf_arch_fetch_caller_regs, namely ARM, alpha, frv, parisc, s390 and sh.

Ingo, can you please queue this for .36? (it only fixes perf/core)

Thanks.




> ---
>  include/linux/perf_event.h |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
> index 9073bde..b65736d 100644
> --- a/include/linux/perf_event.h
> +++ b/include/linux/perf_event.h
> @@ -934,7 +934,7 @@ extern void __perf_sw_event(u32, u64, int, struct
> pt_regs *, u64);
> 
>  #ifndef perf_arch_fetch_caller_regs
>  static inline void
> -perf_arch_fetch_caller_regs(struct regs *regs, unsigned long ip) { }
> +perf_arch_fetch_caller_regs(struct pt_regs *regs, unsigned long ip) { }
>  #endif
> 
>  /*
> -- 
> 1.7.1

