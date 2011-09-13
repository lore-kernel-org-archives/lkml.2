Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754599Ab1IMOUT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Sep 2011 10:20:19 -0400
Received: from casper.infradead.org ([85.118.1.10]:37738 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754206Ab1IMOUQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Sep 2011 10:20:16 -0400
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
Date: Tue, 13 Sep 2011 16:19:39 +0200
In-Reply-To: <20110913041545.GD11100@linux.vnet.ibm.com>
References: <20110610181719.GA30330@linux.vnet.ibm.com>
	 <BANLkTimE1b8HP-q4jgsv5jPD5S-dRoUi_g@mail.gmail.com>
	 <20110615053716.GA390@linux.vnet.ibm.com>
	 <BANLkTi=7S2qdVjbJkDja+GAoD=pNo2gPsTFZMFkB8NWWkO1JVQ@mail.gmail.com>
	 <20110907152009.GA3868@linux.vnet.ibm.com>
	 <1315423342.11101.25.camel@twins>
	 <20110908151433.GB6587@linux.vnet.ibm.com> <1315571462.26517.9.camel@twins>
	 <20110912101722.GA28950@linux.vnet.ibm.com>
	 <1315830943.26517.36.camel@twins>
	 <20110913041545.GD11100@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1315923579.5977.14.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-09-13 at 09:45 +0530, Srivatsa Vaddagiri wrote:
> * Peter Zijlstra <a.p.zijlstra@chello.nl> [2011-09-12 14:35:43]:
> 
> > Of course it does.. and I bet you can improve that slightly if you
> > manage to fix some of the numerical nightmares that live in the cgroup
> > load-balancer (Paul, care to share your WIP?)
> 
> Booting with "nohz=off" also helps significantly.
> 
> With nohz=on, average idle time (over 1 min) is 10.3%
> With nohz=off, average idle time (over 1 min) is 3.9%

So we should put the cpufreq/idle governor into the nohz/idle path, it
already tries to predict the idle duration in order to pick a C state,
that same prediction should be used to determine if stopping the tick is
worth it.

This has come up previously, but I can't quite recollect in what
context.
