Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753435Ab1AYUDH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 15:03:07 -0500
Received: from mx1.redhat.com ([209.132.183.28]:15157 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751827Ab1AYUDF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 15:03:05 -0500
Subject: Re: [PATCH 16/16] KVM-GST: adjust scheduler cpu power
From: Glauber Costa <glommer@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, aliguori@us.ibm.com,
        Rik van Riel <riel@redhat.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Avi Kivity <avi@redhat.com>
In-Reply-To: <1295898690.28776.472.camel@laptop>
References: <1295892397-11354-1-git-send-email-glommer@redhat.com>
	 <1295892397-11354-17-git-send-email-glommer@redhat.com>
	 <1295893920.28776.468.camel@laptop>
	 <1295895083.15920.9.camel@mothafucka.localdomain>
	 <1295898690.28776.472.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
Organization: Red Hat
Date: Tue, 25 Jan 2011 18:02:36 -0200
Message-ID: <1295985756.15920.33.camel@mothafucka.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-01-24 at 20:51 +0100, Peter Zijlstra wrote:
> On Mon, 2011-01-24 at 16:51 -0200, Glauber Costa wrote:
> > > I would really much rather see you change update_rq_clock_task() and
> > > subtract your ns resolution steal time from our wall-time,
> > > update_rq_clock_task() already updates the cpu_power relative to the
> > > remaining time available.
> > 
> > But then we get into the problems we already discussed in previous
> > submissions, which is, we don't really want to alter any notion of
> > wallclock time. Could you list any more concrete advantages of the
> > specific way you proposed? 
> 
> clock_task is the time spend on the task, by not taking steal time into
> account all steal time is accounted as service to whatever task was
> current when the vcpu wasn't running.
> 
> It doesn't change wall-time in the sense of gtod, only the service time
> to tasks.
I fail to see how does clock_task influence cpu power.
If we also have to touch clock_task for better accounting of other
stuff, it is a separate story.
But for cpu_power, I really fail. Please enlighten me.

I did have slightly better results accounting the whole steal time
period away from total_"ticks"(*) than just with units.

* Please note again that ticks here is just a (bad, I admit) name.
This is not tick accounting, is just an estimate of how much useful work
your cpu did.


