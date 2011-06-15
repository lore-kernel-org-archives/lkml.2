Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752446Ab1FORWC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 13:22:02 -0400
Received: from terminus.zytor.com ([198.137.202.10]:55553 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751617Ab1FORV7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 13:21:59 -0400
Message-ID: <4DF8EA26.2000301@zytor.com>
Date: Wed, 15 Jun 2011 10:21:42 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Cliff Wickman <cpw@sgi.com>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 1 of 6] x86, UV: smp_processor_id in a preemptable	region
References: <E1QWcgn-0004Mv-T6@eag09.americas.sgi.com> <BANLkTinpqPhTNRtqPGnfZznefESwD19iXA@mail.gmail.com> <20110615135213.GA29493@sgi.com> <20110615155445.GC4096@elte.hu> <20110615160743.GA32008@sgi.com> <20110615161518.GA24948@elte.hu> <20110615164027.GA32641@sgi.com>
In-Reply-To: <20110615164027.GA32641@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/15/2011 09:40 AM, Cliff Wickman wrote:
> 
> So would you say I should really widen the scope of the non-preemptible
> region to include everything done with the results of that call to
> smp_processor_id()?  
> Which in this case is the call to parse_tunables_write().
> Like this:
> 
>         preempt_disable();
>         bcp = &per_cpu(bau_control, smp_processor_id());
> 
>         ret = parse_tunables_write(bcp, instr, count);
>         preempt_enable_no_resched();
> 

Funny enough, this is such a common pattern that we have helpers for it.
We call this get_cpu() ... put_cpu().

	-hpa

