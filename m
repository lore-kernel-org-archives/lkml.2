Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753641Ab0LQPRR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 10:17:17 -0500
Received: from casper.infradead.org ([85.118.1.10]:37459 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753496Ab0LQPRQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 10:17:16 -0500
Subject: Re: [PATCH 1/3] Added runqueue clock normalized with cpufreq
From: Peter Zijlstra <peterz@infradead.org>
To: Harald Gustafsson <hgu1972@gmail.com>
Cc: Harald Gustafsson <harald.gustafsson@ericsson.com>,
        Dario Faggioli <faggioli@gandalf.sssup.it>,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Claudio Scordino <claudio@evidence.eu.com>,
        Michael Trimarchi <trimarchi@retis.sssup.it>,
        Fabio Checconi <fabio@gandalf.sssup.it>,
        Tommaso Cucinotta <cucinotta@sssup.it>,
        Juri Lelli <juri.lelli@gmail.com>, Dario Faggioli <raistlin@linux.it>
In-Reply-To: <AANLkTinGkf3a4_sw32b4UqAmpUU+i6fDmDUT8tXdw14D@mail.gmail.com>
References: <7997200675c1a53b1954fdc3f46dd208db5dea77.1292578808.git.harald.gustafsson@ericsson.com>
	 <1292596194.2266.283.camel@twins> <1292596369.2266.286.camel@twins>
	 <AANLkTinGkf3a4_sw32b4UqAmpUU+i6fDmDUT8tXdw14D@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 17 Dec 2010 16:16:47 +0100
Message-ID: <1292599007.2266.290.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-12-17 at 16:06 +0100, Harald Gustafsson wrote:
> 2010/12/17 Peter Zijlstra <peterz@infradead.org>:
> > This is all assuming lowering the frequency is sensible to begin with in
> > the first place... but that's all part of the CPUfreq governor, it needs
> > to find a way to lower energy usage while conforming to the system
> > constraints.
> 
> Yes, I and you have already suggested the safe way to not lower it below
> the total dl bandwidth. But for softer use cases it might be possible to
> e.g. exclude threads with longer periods than cpufreq change periods in the
> minimum frequency.

I was more hinting at the fact that CPUfreq is at best a controversial
approach to power savings. I much prefer the whole race-to-idle
approach, its much simpler.
