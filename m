Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753736Ab0HSRnj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 13:43:39 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:61253 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751530Ab0HSRni (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 13:43:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=UE+nYTzucJ/AzKzzYgaUAOQWaFa7rPFoD0+hNEBNClMLq+xCwNueI8RbQkuatnyIdU
         ugM5+lTd8ymmrckqju59vO+92gLjAqQDj0AMvVTfTVdvvF2Jwn6SO+wlFbZweMZT4/oT
         5H+13RMme1/ap1fcaslPWwTe/CI8q2v/a311s=
Date: Thu, 19 Aug 2010 21:43:31 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Don Zickus <dzickus@redhat.com>, Robert Richter <robert.richter@amd.com>,
        Lin Ming <ming.m.lin@intel.com>, Ingo Molnar <mingo@elte.hu>,
        "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Huang, Ying" <ying.huang@intel.com>, Yinghai Lu <yinghai@kernel.org>,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH -v3] perf, x86: try to handle unknown nmis with running
	perfctrs
Message-ID: <20100819174331.GB8268@lenovo>
References: <20100804163930.GE5130@lenovo> <20100804184806.GL26154@erda.amd.com> <20100804192634.GG5130@lenovo> <20100806065203.GR26154@erda.amd.com> <20100806142131.GA1874@redhat.com> <20100809194829.GB26154@erda.amd.com> <20100817152225.GQ26154@erda.amd.com> <1282214753.1926.4669.camel@laptop> <20100819141240.GO4879@redhat.com> <1282228033.2605.204.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1282228033.2605.204.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 19, 2010 at 04:27:13PM +0200, Peter Zijlstra wrote:
...
> Index: linux-2.6/arch/x86/kernel/cpu/perf_event_p4.c
> ===================================================================
> --- linux-2.6.orig/arch/x86/kernel/cpu/perf_event_p4.c
> +++ linux-2.6/arch/x86/kernel/cpu/perf_event_p4.c
> @@ -673,7 +673,7 @@ static int p4_pmu_handle_irq(struct pt_r
>  		if (!overflow && (val & (1ULL << (x86_pmu.cntval_bits - 1))))
>  			continue;
>  
> -		handled += overflow;
> +		handled += !!overflow;

No need to !! here, overflowed returns [0;1] though a small nit
and could be updated later :)

>  
>  		/* event overflow for sure */
>  		data.period = event->hw.last_period;
> @@ -690,7 +690,7 @@ static int p4_pmu_handle_irq(struct pt_r
>  		inc_irq_stat(apic_perf_irqs);
>  	}
>  
> -	return handled > 0;
> +	return handled;
>  }
>  
>  /*
> 
	-- Cyrill
