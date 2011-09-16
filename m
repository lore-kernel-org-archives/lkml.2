Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754842Ab1IPI3G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Sep 2011 04:29:06 -0400
Received: from casper.infradead.org ([85.118.1.10]:53758 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754696Ab1IPI3A convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Sep 2011 04:29:00 -0400
Subject: Re: CFS Bandwidth Control - Test results of cgroups tasks pinned vs
 unpinnede
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Paul Turner <pjt@google.com>
Cc: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Vladimir Davydov <vdavydov@parallels.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Bharata B Rao <bharata@linux.vnet.ibm.com>,
        Dhaval Giani <dhaval.giani@gmail.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Pavel Emelianov <xemul@parallels.com>,
        Thomas Gleixner <tglx@linutronix.de>
Date: Fri, 16 Sep 2011 10:28:40 +0200
In-Reply-To: <4E730568.2030107@google.com>
References: <20110615053716.GA390@linux.vnet.ibm.com>
	  <BANLkTi=7S2qdVjbJkDja+GAoD=pNo2gPsTFZMFkB8NWWkO1JVQ@mail.gmail.com>
	  <20110907152009.GA3868@linux.vnet.ibm.com>
	  <1315423342.11101.25.camel@twins>
	  <20110908151433.GB6587@linux.vnet.ibm.com>
	 <1315571462.26517.9.camel@twins>
	  <20110912101722.GA28950@linux.vnet.ibm.com>
	  <1315830943.26517.36.camel@twins>
	  <20110913041545.GD11100@linux.vnet.ibm.com>
	  <1315923579.5977.14.camel@twins>
	  <20110913180146.GA12723@linux.vnet.ibm.com>
	 <1315938226.4226.11.camel@twins> <4E730568.2030107@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1316161720.10174.0.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-09-16 at 01:14 -0700, Paul Turner wrote:
> On 09/13/11 11:23, Peter Zijlstra wrote:
> > On Tue, 2011-09-13 at 23:31 +0530, Srivatsa Vaddagiri wrote:
> >> * Peter Zijlstra<a.p.zijlstra@chello.nl>  [2011-09-13 16:19:39]:
> >>
> >>>> Booting with "nohz=off" also helps significantly.
> >>>>
> >>>> With nohz=on, average idle time (over 1 min) is 10.3%
> >>>> With nohz=off, average idle time (over 1 min) is 3.9%
> 
> I think more compelling here is that it looks like nohz load-balance 
> needs more love.

Quite probable, although I do know we tend to go overboard in going into
nohz state too.

> > That's not what I said.. what I said is that the nohz code should also
> > use the idle time prognosis.. disabling the tick is a costly operation,
> > doing it only to have to undo it costs time, and will be accounted to
> > idle time, hence your improvement with nohz=off.
> >
> 
> Enabling Venki's CONFIG_IRQ_TIME_ACCOUNTING=y would discount to provide 
> a definitive answer here yes?

Ah, yes, its all (soft)irq context anyway, no need to also account
systemcalls.
