Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755334Ab0LQPoL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 10:44:11 -0500
Received: from www.tglx.de ([62.245.132.106]:54019 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754020Ab0LQPoJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 10:44:09 -0500
Date: Fri, 17 Dec 2010 16:43:53 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Peter Zijlstra <peterz@infradead.org>
cc: Harald Gustafsson <hgu1972@gmail.com>,
        Harald Gustafsson <harald.gustafsson@ericsson.com>,
        Dario Faggioli <faggioli@gandalf.sssup.it>,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Claudio Scordino <claudio@evidence.eu.com>,
        Michael Trimarchi <trimarchi@retis.sssup.it>,
        Fabio Checconi <fabio@gandalf.sssup.it>,
        Tommaso Cucinotta <cucinotta@sssup.it>,
        Juri Lelli <juri.lelli@gmail.com>, Dario Faggioli <raistlin@linux.it>
Subject: Re: [PATCH 1/3] Added runqueue clock normalized with cpufreq
In-Reply-To: <1292599007.2266.290.camel@twins>
Message-ID: <alpine.LFD.2.00.1012171630330.12146@localhost6.localdomain6>
References: <7997200675c1a53b1954fdc3f46dd208db5dea77.1292578808.git.harald.gustafsson@ericsson.com>  <1292596194.2266.283.camel@twins> <1292596369.2266.286.camel@twins>  <AANLkTinGkf3a4_sw32b4UqAmpUU+i6fDmDUT8tXdw14D@mail.gmail.com>
 <1292599007.2266.290.camel@twins>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 17 Dec 2010, Peter Zijlstra wrote:
> On Fri, 2010-12-17 at 16:06 +0100, Harald Gustafsson wrote:
> > 2010/12/17 Peter Zijlstra <peterz@infradead.org>:
> > > This is all assuming lowering the frequency is sensible to begin with in
> > > the first place... but that's all part of the CPUfreq governor, it needs
> > > to find a way to lower energy usage while conforming to the system
> > > constraints.
> > 
> > Yes, I and you have already suggested the safe way to not lower it below
> > the total dl bandwidth. But for softer use cases it might be possible to
> > e.g. exclude threads with longer periods than cpufreq change periods in the
> > minimum frequency.
> 
> I was more hinting at the fact that CPUfreq is at best a controversial
> approach to power savings. I much prefer the whole race-to-idle
> approach, its much simpler.

There's that and I have yet to see a proof that running code with
lower frequency and not going idle saves more power than running full
speed and going into low power states for longer time.

Also if you want to have your deadline scheduler aware of cpu
frequency changes, then simply limit the total bandwith based on the
lowest possible frequency and it works always. This whole dynamic
bandwith expansion is more an academic exercise than a practical
necessity.

Thanks,

	tglx
