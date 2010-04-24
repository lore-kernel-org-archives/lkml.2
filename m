Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754149Ab0DXXSs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Apr 2010 19:18:48 -0400
Received: from casper.infradead.org ([85.118.1.10]:38604 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754109Ab0DXXSq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Apr 2010 19:18:46 -0400
Date: Sat, 24 Apr 2010 16:20:36 -0700
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
Message-ID: <20100424162036.47cba620@infradead.org>
In-Reply-To: <20100424210042.GA2371@Krystal>
References: <4BCFC3D0.5080904@codeaurora.org>
	<4BD0D9E5.3020606@codeaurora.org>
	<20100423184042.GA16190@Krystal>
	<20100423122259.49e0416a@infradead.org>
	<20100423195556.GD21997@Krystal>
	<20100424115616.01aaa997@infradead.org>
	<20100424210042.GA2371@Krystal>
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

On Sat, 24 Apr 2010 17:00:42 -0400
Mathieu Desnoyers <mathieu.desnoyers@efficios.com> wrote:
> > Case 2: multi core or HT, TSC is variable with CPU frequency.
> > This is the really sucky case, since logical CPU 0's tsc frequency
> > in part depends on what logical CPU 1 will do etc. No good answer
> > for this other than assuming the worst. Based on your document
> > these do actually exist in early P4 cpus.
> 
> Keeping track of the cpu frequency changes can help here. Along with
> periodic resynchronization if cpu clocks drift too far apart. I've
> done that for the LTTng omap3 trace clock.

it's not enough; voting does not work that way.
the way voting ends up working is that the hardware runs the maximum of
the various frequency requests ... but for the threads that are not
idle.

so if cpu 1 goes to a high frequency, cpu 0 goes up to.. until cpu 1
goes idle; then only cpu 0's value is in use.


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
