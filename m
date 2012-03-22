Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756820Ab2CVLkz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 07:40:55 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:47149 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753023Ab2CVLky (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 07:40:54 -0400
Date: Thu, 22 Mar 2012 12:40:51 +0100
From: Borislav Petkov <bp@amd64.org>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: Borislav Petkov <bp@amd64.org>, Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] x86, mce: Add persistent MCE event
Message-ID: <20120322114051.GB30026@aftab>
References: <1332340496-21658-1-git-send-email-bp@amd64.org>
 <1332340496-21658-3-git-send-email-bp@amd64.org>
 <4F6AE48D.4070508@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F6AE48D.4070508@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 22, 2012 at 02:06:29PM +0530, Srivatsa S. Bhat wrote:
> > +err_unwind:
> > +	err = -EINVAL;
> > +	for (--cpu; cpu >= 0; cpu--)
> > +		perf_rm_persistent_on_cpu(cpu, &per_cpu(mce_ev, cpu));
> > +
> 
> 
> *Totally* theoretical question: How do you know that the cpu_online_mask isn't
> sparse? In other words, what if some CPUs weren't booted? Then this for-loop
> wouldn't be very good..
> 
> Oh, now I see that perf_rm_persistent_on_cpu() probably handles that case well..
> So no issues I guess.. ?

Right, this could theoretically come around to bite us in some obscure
cases, so we probably fix it from the get-go.

> (Moreover, we will probably have bigger issues at hand if some CPU didn't
> boot..)
> 
> (The code looked funny, so I thought of pointing it out, whether or not it
> actually is worrisome. Sorry for the noise, if any).

Right, no, thanks for pointing it out.

I'll probably do something like the following:

	for (--cpu; cpu >= 0; cpu--)
		if (cpu_online(cpu))
			perf_rm_persistent_on_cpu(cpu, &per_cpu(mce_ev, cpu));

to be on the safe side from that perspective.

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
