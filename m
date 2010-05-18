Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757144Ab0ERWAd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 18:00:33 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:38301 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752633Ab0ERWAa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 18:00:30 -0400
Date: Wed, 19 May 2010 00:00:02 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Tony Luck <tony.luck@intel.com>
Cc: Joe Perches <joe@perches.com>, Mauro Carvalho Chehab <mchehab@redhat.com>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "bluesmoke-devel@lists.sourceforge.net" 
	<bluesmoke-devel@lists.sourceforge.net>,
       Linux Edac Mailing List <linux-edac@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       Ben Woodard <woodard@redhat.com>, Matt Domsch <Matt_Domsch@dell.com>,
       Doug Thompson <dougthompson@xmission.com>,
       Borislav Petkov <bp@amd64.org>, "Young, Brent" <brent.young@intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: Hardware Error Kernel Mini-Summit
Message-ID: <20100518220002.GA23739@elte.hu>
References: <4BF18995.6070008@redhat.com>
 <4BF2392A.9040409@jp.fujitsu.com>
 <4BF2C3D1.10009@redhat.com>
 <1274204560.17703.82.camel@Joe-Laptop.home>
 <20100518185305.GA23921@elte.hu>
 <987664A83D2D224EAE907B061CE93D53C61D1C57@orsmsx505.amr.corp.intel.com>
 <20100518193022.GB30936@elte.hu>
 <20100518204204.GA23204@elte.hu>
 <AANLkTimPRvuoW5-OcPlPx5cvnCTJa7xhAQDSLrYziB4j@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTimPRvuoW5-OcPlPx5cvnCTJa7xhAQDSLrYziB4j@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.5 required=5.9 tests=BAYES_40 autolearn=no SpamAssassin version=3.2.5
	0.5 BAYES_40               BODY: Bayesian spam probability is 20 to 40%
	[score: 0.2463]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Tony Luck <tony.luck@intel.com> wrote:

> > This gives us a broad platform to add various RAS 
> > events as well, beyond raw hardware events: we could 
> > for example events for various system anomalies such 
> > as lockup messages, kernel warnings/oopses, IOMMU 
> > exceptions - maybe even pure software concepts such as 
> > fatal segmentation fault events, etc. etc.
> 
> This looks like sticky ground.  I can see the event 
> mechanism passing data to a user daemon working well for 
> all kinds of corrected and minor errors. But when you 
> start talking about lockups and fatal errors things get 
> a lot trickier. Often the main concern at this point is 
> error containment. Making sure that the flaky data 
> doesn't become visible (saved to storage, transmitted to 
> the network, etc.). [...]

I was pointing beyond the narrow hardware (memory) error 
point of view, towards a more generic 'system health' 
thinking.

In the broader view it may makes sense to for example 
define policy over excessive number of segfaults on a 
server system (where excessive segfaults are an anomaly), 
or a suspiciously large number of soft IO errors, etc.

But yes, of course, when it comes to hard memory errors, 
those take precedence, and handling them (and 
saving/propagating information about them while we still 
can) is a priority.

> [...] Getting from a machine check handler through some 
> context switches (and page faults etc.) to a user level 
> daemon before the error gets recorded looks to be really 
> hard.

As Boris mentioned it too, critical policy action can and 
will be done straight in the kernel.

	Ingo
