Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754515Ab0DTLA3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Apr 2010 07:00:29 -0400
Received: from casper.infradead.org ([85.118.1.10]:48113 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754398Ab0DTLA1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Apr 2010 07:00:27 -0400
Date: Tue, 20 Apr 2010 04:02:07 -0700
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
Message-ID: <20100420040207.1be74046@infradead.org>
In-Reply-To: <201004201010.50725.tvrtko.ursulin@sophos.com>
References: <20100418115949.7b743898@infradead.org>
	<201004191629.39339.tvrtko.ursulin@sophos.com>
	<20100419174702.635ddad1@infradead.org>
	<201004201010.50725.tvrtko.ursulin@sophos.com>
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

On Tue, 20 Apr 2010 10:10:49 +0100
Tvrtko Ursulin <tvrtko.ursulin@sophos.com> wrote:
> >
> > it's better then to stay high longer... at least on modern machines
> > the inbetween states are pretty much either useless or actually
> > energy hurting compared to the higher state.
> 
> Why do you think it is not good for latency to stay at higher
> frequency for longer?

oh it will be. 

> governor it was much much better. That is why I proposed to have a
> gradual lowering as an option in on-demand. You said it already does
> that - I ask are you sure? And also now you are saying it would not
> be good for latency
> - above is an example when it clearly does help (a lot).

but the *gradual* lowering just does not make sense.
might as well just stay at the highest frequency for the duration for
which you do the gradual lowering, it's more efficient for power on most
modern machines.

The problem is if you do this gradual thing for long enough to help
you on desktop loads, or the stay-high thing, on server workloads the
power efficiency will completely and utterly tank. Been there tried
that ;-)


frankly, you're starting to touch at the more fundamental issues with
ondemand. I'm not trying to solve that in this small patch, they really
can only be solved in a complete redesign. While I'm doing such a
redesign, I was asked to at least fix this particular gap urgently.
Solving all of ondemand's issues needs a complete rethink of the core
assumptions it makes (which are not correct anymore nowadays).

-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
