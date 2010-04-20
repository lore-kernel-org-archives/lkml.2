Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752596Ab0DTApY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 20:45:24 -0400
Received: from casper.infradead.org ([85.118.1.10]:36798 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751676Ab0DTApW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 20:45:22 -0400
Date: Mon, 19 Apr 2010 17:47:02 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Tvrtko Ursulin <tvrtko.ursulin@sophos.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "mingo@elte.hu" <mingo@elte.hu>,
       "peterz@infradead.org" <peterz@infradead.org>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "davej@redhat.com" <davej@redhat.com>,
       "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>
Subject: Re: [PATCH 7/7] ondemand: Solve the big performance issue with
 ondemand during disk IO
Message-ID: <20100419174702.635ddad1@infradead.org>
In-Reply-To: <201004191629.39339.tvrtko.ursulin@sophos.com>
References: <20100418115949.7b743898@infradead.org>
	<201004191009.56859.tvrtko.ursulin@sophos.com>
	<20100419064617.519eb384@infradead.org>
	<201004191629.39339.tvrtko.ursulin@sophos.com>
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

On Mon, 19 Apr 2010 16:29:39 +0100
Tvrtko Ursulin <tvrtko.ursulin@sophos.com> wrote:

> On Monday 19 Apr 2010 14:46:17 Arjan van de Ven wrote:
> > On Mon, 19 Apr 2010 10:09:55 +0100
> > > Or in other words, does a pure IO workload benefit from now higher
> > > selected frequency?
> >
> > no.
> > Mixed workloads do.
> > but pure IO workloads also don't suffer since while idle, the
> > voltage goes down anyway.
> 
> You mean that higher frequency does not have effect on power use if
> CPU is idle? Is that true for all/most processors?

this is true for most processors that I'm aware of.
there's exceptions for things like where the idle time is really short,
where going up and down in voltage will take more energy than it'll
save and such.

> 
> > > One idea I had but a) never had time to implement it and b) was
> > > not sure it would be accepted anyway, was to modify ondemand
> > > governor to ramp up instantly, but slow down slowly (in a
> > > configurable way).
> >
> > that's what ondemand does already.
> 
> How and where in the code and how to enable that behaviour? From my
> experiments frequency goes down to minimum as soon as load goes away.
> What I was talking about is gradual lowering over a configurable
> period. It is not power efficient, but it could be good for latency
> in some workloads.

it's not even good for that ;-(

it's better then to stay high longer... at least on modern machines the
inbetween states are pretty much either useless or actually energy
hurting compared to the higher state.


> 
> Tvrtko
> 
> Sophos Plc, The Pentagon, Abingdon Science Park, Abingdon, OX14 3YP,
> United Kingdom. Company Reg No 2096520. VAT Reg No GB 348 3873 20.


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
