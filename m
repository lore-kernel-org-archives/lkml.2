Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932197Ab1IMSYS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Sep 2011 14:24:18 -0400
Received: from casper.infradead.org ([85.118.1.10]:41176 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932095Ab1IMSYQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Sep 2011 14:24:16 -0400
Subject: Re: CFS Bandwidth Control - Test results of cgroups tasks pinned vs
 unpinnede
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Cc: Paul Turner <pjt@google.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Vladimir Davydov <vdavydov@parallels.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Bharata B Rao <bharata@linux.vnet.ibm.com>,
        Dhaval Giani <dhaval.giani@gmail.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Pavel Emelianov <xemul@parallels.com>,
        Thomas Gleixner <tglx@linutronix.de>
Date: Tue, 13 Sep 2011 20:23:46 +0200
In-Reply-To: <20110913180146.GA12723@linux.vnet.ibm.com>
References: <20110615053716.GA390@linux.vnet.ibm.com>
	 <BANLkTi=7S2qdVjbJkDja+GAoD=pNo2gPsTFZMFkB8NWWkO1JVQ@mail.gmail.com>
	 <20110907152009.GA3868@linux.vnet.ibm.com>
	 <1315423342.11101.25.camel@twins>
	 <20110908151433.GB6587@linux.vnet.ibm.com> <1315571462.26517.9.camel@twins>
	 <20110912101722.GA28950@linux.vnet.ibm.com>
	 <1315830943.26517.36.camel@twins>
	 <20110913041545.GD11100@linux.vnet.ibm.com>
	 <1315923579.5977.14.camel@twins>
	 <20110913180146.GA12723@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1315938226.4226.11.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-09-13 at 23:31 +0530, Srivatsa Vaddagiri wrote:
> * Peter Zijlstra <a.p.zijlstra@chello.nl> [2011-09-13 16:19:39]:
> 
> > > Booting with "nohz=off" also helps significantly.
> > > 
> > > With nohz=on, average idle time (over 1 min) is 10.3%
> > > With nohz=off, average idle time (over 1 min) is 3.9%
> >
> > So we should put the cpufreq/idle governor into the nohz/idle path, it
> > already tries to predict the idle duration in order to pick a C state,
> > that same prediction should be used to determine if stopping the tick is
> > worth it.
> 
> Hmm ..I tried performance governor and found that it slightly increases
> idle time.
> 
>   With nohz=off && ondemand governor, idle time = 4%
>   With nohz=off && performance governor on all cpus, idle time = 6%
> 
> I can't see obvious reasons for that ..afaict bandwidth capping should
> be independent of frequency (i.e task gets capped by "used" time,
> irrespective of frequency at which it was "using" the cpu)?

That's not what I said.. what I said is that the nohz code should also
use the idle time prognosis.. disabling the tick is a costly operation,
doing it only to have to undo it costs time, and will be accounted to
idle time, hence your improvement with nohz=off.


