Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755647Ab0DWTVN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 15:21:13 -0400
Received: from casper.infradead.org ([85.118.1.10]:53550 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751394Ab0DWTVI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 15:21:08 -0400
Date: Fri, 23 Apr 2010 12:22:59 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Saravana Kannan <skannan@codeaurora.org>,
       cpufreq <cpufreq@vger.kernel.org>,
       linux-arm-msm <linux-arm-msm@vger.kernel.org>,
       Dave Jones <davej@redhat.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Thomas Renninger <trenn@suse.de>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Subject: Re: CPUfreq - udelay() interaction issues
Message-ID: <20100423122259.49e0416a@infradead.org>
In-Reply-To: <20100423184042.GA16190@Krystal>
References: <4BCFC3D0.5080904@codeaurora.org>
	<4BD0D9E5.3020606@codeaurora.org>
	<20100423184042.GA16190@Krystal>
Organization: Intel
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.16.6; i586-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 Apr 2010 14:40:42 -0400
Mathieu Desnoyers <mathieu.desnoyers@efficios.com> wrote:

> [CCing Arjan, who seems to have played a lot with ondemand lately]
> 
> * Saravana Kannan (skannan@codeaurora.org) wrote:
> > Resending email to "cc" the maintainers.
> >
> > Maintainers,
> >
> > Any comments?
> >
> > -Saravana
> >
> > Saravana Kannan wrote:
> >> Hi,
> >>
> >> I think there are a couple of issues with cpufreq and udelay  
> >> interaction. But that's based on my understanding of cpufreq. I
> >> have worked with it for sometime now, so hopefully I not
> >> completely wrong. So, I will list my assumptions and what I think
> >> is/are the issue(s) and their solutions.
> >>
> >> Please correct me if I'm wrong and let me know what you think.
> >>
> >> Assumptions:
> >> ============
> >> * Let's assume ondemand governor is being used.
> >> * Ondemand uses one timer per core and they have CPU affinity set.
> >> * For SMP, CPUfreq core expects the CPUfreq driver to adjust the 
> >> per-CPU jiffies.
> >> * P1 indicates for lower CPU perfomance levels and P2 indicates a
> >> much higher CPU pref level (say 10 times faster).
> >>


so in reality, all hardware that does coordination between cores/etc
like this also has a tsc that is invariant of the actual P state.
If there are exceptions, those have a problem, but I can't think of any
right now.
Once the TSC is invariant of P state, udelay() is fine, since that goes
of the tsc, not of some delay loop kind of thing....
