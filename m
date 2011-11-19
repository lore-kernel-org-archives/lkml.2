Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756935Ab1KSEPI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 23:15:08 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:34409 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752084Ab1KSEPH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 23:15:07 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19Aa6EExwtAu0MZ5riAdiAfziL1KSWC2HT26yQiDk
	ZI9qvEIXFOc2XT
Subject: RE: [patch 3/6] sched: use rq->avg_event to resurrect nohz
 ratelimiting
From: Mike Galbraith <efault@gmx.de>
To: "Van De Ven, Arjan" <arjan.van.de.ven@intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Paul Turner <pjt@google.com>
In-Reply-To: <26E9B811E137AB4B95200FD4C950886BFF9781E8@orsmsx507.amr.corp.intel.com>
References: <1321350377.1421.55.camel@twins>
	 <1321406062.16760.60.camel@sbsiddha-desk.sc.intel.com>
	 <1321435455.5072.64.camel@marge.simson.net>
	 <1321468646.11680.2.camel@sbsiddha-desk.sc.intel.com>
	 <1321495153.5100.7.camel@marge.simson.net>
	 <1321544313.6308.25.camel@marge.simson.net>
	 <1321545376.2495.1.camel@laptop>
	 <1321547917.6308.48.camel@marge.simson.net>
	 <1321551381.15339.21.camel@sbsiddha-desk.sc.intel.com>
	 <1321629267.7080.13.camel@marge.simson.net>
	 <1321629562.7080.17.camel@marge.simson.net>
	 <1321630619.2197.16.camel@twins>
	 <1321638146.6238.20.camel@marge.simson.net>
	 <26E9B811E137AB4B95200FD4C950886BFF9781E8@orsmsx507.amr.corp.intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 19 Nov 2011 05:15:01 +0100
Message-ID: <1321676101.6307.3.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-11-18 at 16:51 -0800, Van De Ven, Arjan wrote:
> > > Arjan, can we do something smart with the idle governor which already
> > > guestimates the idle duration for us?
> > 
> > That would be great.  Won't help my Intel Q6600 though, the intel_idle
> > governor doesn't support it.  Other idle_governor gizmos really need to
> > get smarter too.
> 
> 
> you're confusing the governor (menu) and the low level hardware driver.

Ok, I just saw that intel_idle_probe() says go away.

[    2.479695] intel_idle: MWAIT substates: 0x20
[    2.484144] intel_idle: does not run on family 6 model 15

	-Mike

