Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759436Ab1DNT6I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 15:58:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44780 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755381Ab1DNT6F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 15:58:05 -0400
Date: Thu, 14 Apr 2011 15:57:48 -0400
From: Don Zickus <dzickus@redhat.com>
To: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Ingo Molnar <mingo@elte.hu>, Lin Ming <ming.m.lin@intel.com>,
        Shaun Ruffell <sruffell@digium.com>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>,
        Robert Richter <robert.richter@amd.com>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -tip] perf, x86: fix unknown NMIs on a Pentium4 box
Message-ID: <20110414195748.GO16939@redhat.com>
References: <4DA70950.3060102@openvz.org>
 <20110414174327.GA8863@elte.hu>
 <20110414183231.GN16939@redhat.com>
 <20110414184606.GD16064@elte.hu>
 <4DA74E5D.4060002@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DA74E5D.4060002@openvz.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 14, 2011 at 11:43:25PM +0400, Cyrill Gorcunov wrote:
> On 04/14/2011 10:46 PM, Ingo Molnar wrote:
> > 
> > btw., the bug went away once i removed your patch so it's 100% sure caused by 
> > this change.
> > 
> > Thanks,
> > 
> > 	Ingo
> 
> Ingo if you have a chance mind to give this patch a shot please? Seems we might miss unmasking
> for inflight nmis.

I don't think this patch will work.  It would make sense if the unmasking
happened _after_ the "if (!handled)" path, but that is not the path Ingo
wanted for v1.

Cheers,
Don

> -	apic_write(APIC_LVTPC, APIC_DM_NMI);
> 
>  	handled = x86_pmu.handle_irq(args->regs);
> +	apic_write(APIC_LVTPC, APIC_DM_NMI);

^^^^ all handled/unhandled NMIs hit that apic_write
>  	if (!handled)
>  		return NOTIFY_DONE;
> 
