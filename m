Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756649Ab0EERms (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 13:42:48 -0400
Received: from mail-bw0-f225.google.com ([209.85.218.225]:56686 "EHLO
	mail-bw0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755800Ab0EERmq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 13:42:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=LKbMXHJRVapzG0OnBBQsyKUBBxTv8X4giw63x5qiQ6gxU7y9Wnixep1+1DrjqMp+bp
         yiYd9WUzVgdn0PqQLQKt5oF0MnprWDtQsx4khFKtc3KW13VJ+IqhNnW39Kd6byUdBBg4
         +hhGZRkZMdbyM/lPZxELnM397kPWO8j8VTwSY=
Date: Wed, 5 May 2010 21:42:34 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH -tip] x86,perf: P4 PMU -- protect sensible procedures
	from preemption
Message-ID: <20100505174234.GH5686@lenovo>
References: <20100505150740.GB5686@lenovo> <20100505165731.GA6320@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100505165731.GA6320@nowhere>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 05, 2010 at 06:57:34PM +0200, Frederic Weisbecker wrote:
...
> > @@ -741,7 +743,7 @@ static int p4_pmu_schedule_events(struct
> >  {
> >  	unsigned long used_mask[BITS_TO_LONGS(X86_PMC_IDX_MAX)];
> >  	unsigned long escr_mask[BITS_TO_LONGS(ARCH_P4_TOTAL_ESCR)];
> > -	int cpu = raw_smp_processor_id();
> > +	int cpu = get_cpu();
> >  	struct hw_perf_event *hwc;
> >  	struct p4_event_bind *bind;
> >  	unsigned int i, thread, num;
> > @@ -777,6 +779,7 @@ reserve:
> >  	}
> >  
> >  done:
> > +	put_cpu();
> >  	return num ? -ENOSPC : 0;
> >  }
> 
> That's no big deal. But I think the schedule_events() is called on
> pmu::enable() time, when preemption is already disabled.
> 

We'll be on a safe side using get/put_cpu here (ie in case
if something get changed one day).

	-- Cyrill
