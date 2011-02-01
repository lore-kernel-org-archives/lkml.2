Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753687Ab1BAP7E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 10:59:04 -0500
Received: from mx1.redhat.com ([209.132.183.28]:16639 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751608Ab1BAP7C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 10:59:02 -0500
Subject: Re: [PATCH v2 3/6] KVM-GST: KVM Steal time accounting
From: Glauber Costa <glommer@redhat.com>
To: lidong chen <chen.lidong.kernel@gmail.com>
Cc: Avi Kivity <avi@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, aliguori@us.ibm.com,
        Rik van Riel <riel@redhat.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Peter Zijlstra <peterz@infradead.org>
In-Reply-To: <AANLkTi=-y7fk1HwiH8+_fSxbp_rif+MRzuhcNmwc38_V@mail.gmail.com>
References: <1296244340-15173-1-git-send-email-glommer@redhat.com>
	 <1296244340-15173-4-git-send-email-glommer@redhat.com>
	 <4D456FF9.2010309@redhat.com>
	 <AANLkTi=-y7fk1HwiH8+_fSxbp_rif+MRzuhcNmwc38_V@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Red Hat
Date: Tue, 01 Feb 2011 13:58:45 -0200
Message-ID: <1296575925.5081.19.camel@mothafucka.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-01-31 at 00:45 +0800, lidong chen wrote:
> I think we can use performance counter.
> use unhalted core cycles event, in the nmi callback funcation, count
> which process is running .
> if the vm exit is caused by nmi,discard it.
> the system time of qemu process is the time steal by kvm.

Performance counters are a scarce resource, so I'd rather not use them,
since it will mean forcing a context switch from whoever is using it at
the moment. Which is also an expensive operation anyway.

So even though it can be possible, in theory, I don't see why use it
in this particular case.

> 
> 
> 2011/1/30 Avi Kivity <avi@redhat.com>:
> > On 01/28/2011 09:52 PM, Glauber Costa wrote:
> >>
> >> This patch accounts steal time time in kernel/sched.
> >> I kept it from last proposal, because I still see advantages
> >> in it: Doing it here will give us easier access from scheduler
> >> variables such as the cpu rq. The next patch shows an example of
> >> usage for it.
> >>
> >> Since functions like account_idle_time() can be called from
> >> multiple places, not only account_process_tick(), steal time
> >> grabbing is repeated in each account function separatedely.
> >>
> >
> > I accept that steal time is worthwhile, but do you have some way to
> > demonstrate that the implementation actually works and is beneficial?
> >
> > Perhaps run two cpu-bound compute processes on one vcpu, overcommit that
> > vcpu, and see what happens to the processing rate with and without steal
> > time accounting.  I'd expect a fairer response with steal time accounting.
> >
> > --
> > error compiling committee.c: too many arguments to function
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe kvm" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >


