Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753673Ab0DXSy1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Apr 2010 14:54:27 -0400
Received: from casper.infradead.org ([85.118.1.10]:53075 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751437Ab0DXSyZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Apr 2010 14:54:25 -0400
Date: Sat, 24 Apr 2010 11:56:16 -0700
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
Message-ID: <20100424115616.01aaa997@infradead.org>
In-Reply-To: <20100423195556.GD21997@Krystal>
References: <4BCFC3D0.5080904@codeaurora.org>
	<4BD0D9E5.3020606@codeaurora.org>
	<20100423184042.GA16190@Krystal>
	<20100423122259.49e0416a@infradead.org>
	<20100423195556.GD21997@Krystal>
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

> 
> I did an overview, back in 2007, of AMD and Intel processors that had
> either tsc rate depending on P state and/or tsc rate changed by idle
> and/or tsc values influenced by STPCLK-Throttling. Here are some
> notes, along with pointers to the reference documents (please excuse
> the ad-hoc style of these notes):
> 
> http://git.dorsal.polymtl.ca/?p=lttv.git;a=blob_plain;f=doc/developer/tsc.txt
> 
> So I might be missing something about your statement "all hardware
> that does coordination between cores/etc like this also has a tsc
> that is invariant of the actual P state.". Do you mean that all
> udelay callers do not rely on it to provide a guaranteed lower-bound,
> except for some sub-architectures ?

ok there's basically 3 cases

Case 1: single core, no hyperthreading. It does not matter what tsc
does, since the kernel knows what it does and will either scale it or
not for udelay depending on that.
(this case includes single core SMP configurations)

Case 2: multi core or HT, TSC is variable with CPU frequency.
This is the really sucky case, since logical CPU 0's tsc frequency in
part depends on what logical CPU 1 will do etc. No good answer
for this other than assuming the worst. Based on your document these do
actually exist in early P4 cpus.

Case 3: multi core/HT but with fixed rate TSC; no problem whatsoever,
tsc is a good measure for udelay.

Only case 2 sucks :-(


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
