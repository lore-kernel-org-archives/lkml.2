Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752993Ab0HSMjh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 08:39:37 -0400
Received: from va3ehsobe006.messaging.microsoft.com ([216.32.180.16]:13854
	"EHLO VA3EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750817Ab0HSMje (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 08:39:34 -0400
X-SpamScore: 6
X-BigFish: VPS6(z3cfcs329eqzbb2cK1432N98dNzz1202hzzz32i2a8h62h)
X-Spam-TCS-SCL: 1:0
X-FB-SS: 0,
X-WSS-ID: 0L7EGHO-02-F6F-02
X-M-MSG: 
Date: Thu, 19 Aug 2010 14:39:26 +0200
From: Robert Richter <robert.richter@amd.com>
To: Peter Zijlstra <peterz@infradead.org>
CC: Don Zickus <dzickus@redhat.com>, Cyrill Gorcunov <gorcunov@gmail.com>,
        Lin Ming <ming.m.lin@intel.com>, Ingo Molnar <mingo@elte.hu>,
        "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Huang, Ying" <ying.huang@intel.com>, Yinghai Lu <yinghai@kernel.org>,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH -v3] perf, x86: try to handle unknown nmis with running
 perfctrs
Message-ID: <20100819123926.GW26154@erda.amd.com>
References: <20100804161046.GC5130@lenovo>
 <20100804162026.GU3353@redhat.com>
 <20100804163930.GE5130@lenovo>
 <20100804184806.GL26154@erda.amd.com>
 <20100804192634.GG5130@lenovo>
 <20100806065203.GR26154@erda.amd.com>
 <20100806142131.GA1874@redhat.com>
 <20100809194829.GB26154@erda.amd.com>
 <20100817152225.GQ26154@erda.amd.com>
 <1282214753.1926.4669.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1282214753.1926.4669.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19.08.10 06:45:53, Peter Zijlstra wrote:
> I queued it with that part changed to:
> 
> +       this_nmi = percpu_read(irq_stat.__nmi_count);
> +       if ((handled > 1) ||
> +               /* the next nmi could be a back-to-back nmi */
> +           ((__get_cpu_var(nmi).marked == this_nmi) &&
> +            (__get_cpu_var(nmi).handled > 1))) {
> +               /*
> +                * We could have two subsequent back-to-back nmis: The
> +                * first handles more than one counter, the 2nd
> +                * handles only one counter and the 3rd handles no
> +                * counter.
> +                *
> +                * This is the 2nd nmi because the previous was
> +                * handling more than one counter. We will mark the
> +                * next (3rd) and then drop it if unhandled.
> +                */
> +               __get_cpu_var(nmi).marked       = this_nmi + 1;
> +               __get_cpu_var(nmi).handled      = handled;
> +       }
> 
>         return NOTIFY_STOP;
>  }

I am fine with this. Thanks Peter.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

