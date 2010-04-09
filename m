Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754029Ab0DIPFm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 11:05:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23129 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751998Ab0DIPFi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 11:05:38 -0400
Date: Fri, 9 Apr 2010 11:05:13 -0400
From: Don Zickus <dzickus@redhat.com>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, mingo@elte.hu,
       peterz@infradead.org, aris@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [watchdog] combine nmi_watchdog and softlockup
Message-ID: <20100409150513.GJ15159@redhat.com>
References: <20100323213338.GA29170@redhat.com>
 <20100406141321.GA8416@nowhere>
 <20100406153115.GB5744@lenovo>
 <20100409000036.GC6672@nowhere>
 <20100409145650.GA5602@lenovo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100409145650.GA5602@lenovo>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 09, 2010 at 06:56:50PM +0400, Cyrill Gorcunov wrote:
> On Fri, Apr 09, 2010 at 02:00:38AM +0200, Frederic Weisbecker wrote:
> > On Tue, Apr 06, 2010 at 07:31:15PM +0400, Cyrill Gorcunov wrote:
> > > > I fear the cpu clock is not going to help you detecting any hard lockups.
> > > > If you're stuck in an interrupt or an irq disabled loop, your cpu clock is
> > > > not going to fire.
> > > >
> > > 
> > > I guess it's not supposed to. For such cases only nmi irqs may help for which
> > > the perf events are there (/me need to check if we program apic timer for anything
> > > like that). But it should help for other deadlocks. Or I miss something?
> > 
> > 
> > Actually not. What the hardlockup detector does it to check the progression
> > of irqs.
> >
> 
> yup, i know what nmi-watchdog is doing. I guess you've misunderstood me. I meant
> that sw-driven detector is not supposed to guard against the cases you're
> referring to. I don't remember the details but someone proposed to make a
> fallback to sw-watchdog if there is no ability to use nmi from perf-events
> (for any reason) which eventually being implemented in Don's patch. And
> there will be a message that watchdog has been switched to sw-driven
> scaffold. So user will (or should) see this message and mark it I believe.
> This sw-watchdog is like "ok, we've been trying our best but there is a
> problem and the only solution we could offer -- is to use sw-watchdog".
> That is how I understand the reason for sw-watchdog there.

Correct.

> 
> > 
> > So it detects true hardlockups: stuck in an irq disabled section.
> > If you don't have NMI to detect that (here this made by hardware clock based
> > on cpu cycles overflows), then you're screwed. The hardlockup detector is
> > useless with a maskable irq based clock.
> > 
> 	-- Cyrill

Cheers,
Don

