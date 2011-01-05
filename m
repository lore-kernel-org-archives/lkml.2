Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751725Ab1AEJll (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 04:41:41 -0500
Received: from canuck.infradead.org ([134.117.69.58]:44638 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751319Ab1AEJlj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 04:41:39 -0500
Subject: Re: [Fwd: Re: [RFC -v3 PATCH 2/3] sched: add yield_to function]
From: Peter Zijlstra <peterz@infradead.org>
To: Tommaso Cucinotta <tommaso.cucinotta@sssup.it>
Cc: Dario Faggioli <faggioli@gandalf.sssup.it>,
        Dhaval Giani <dhaval@retis.sssup.it>,
        Fabio Checconi <fabio@gandalf.sssup.it>, riel@redhat.com,
        Hillf Danton <dhillf@gmail.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Avi Kiviti <avi@redhat.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Mike Galbraith <efault@gmx.de>, Chris Wright <chrisw@sous-sol.org>
In-Reply-To: <4D23AF8A.6080306@sssup.it>
References: <1294164920.6169.199.camel@Palantir> <4D23AF8A.6080306@sssup.it>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 05 Jan 2011 10:41:53 +0100
Message-ID: <1294220513.2016.196.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-01-05 at 00:38 +0100, Tommaso Cucinotta wrote:
> Il 04/01/2011 19:15, Dario Faggioli ha scritto:
> >
> > -------- Forwarded Message --------
> > From: Peter Zijlstra<a.p.zijlstra@chello.nl>
> > To: Rik van Riel<riel@redhat.com>
> > Cc: Hillf Danton<dhillf@gmail.com>,kvm@vger.kernel.org,
> > linux-kernel@vger.kernel.org, Avi Kiviti<avi@redhat.com>, Srivatsa
> > Vaddagiri<vatsa@linux.vnet.ibm.com>, Mike Galbraith<efault@gmx.de>,
> > Chris Wright<chrisw@sous-sol.org>
> > Subject: Re: [RFC -v3 PATCH 2/3] sched: add yield_to function
> > Date: Tue, 04 Jan 2011 19:05:54 +0100
> > RT guests don't make sense, there's nowhere near enough infrastructure
> > for that to work well.
> >
> > I'd argue that KVM running with RT priority is a bug.
> Peter, can I ask why did you state that ? In the IRMOS project, we
> are just deploying KVM VMs by using the Fabio's real-time scheduler
> (for others, a.k.a., the Fabio's EDF throttling patch, or IRMOS RT 
> scheduler)
> in order to let the VMs get precise CPU scheduling guarantees by the
> kernel. So, in this context we do have KVM running at RT priority, and
> we do have experimental results showing how this can improve stability
> of performance of the hosted guest VMs.
> Of course, don't misunderstand me: this is a necessary condition for a
> stable performance of KVM VMs, I'm not saying it is sufficient for

I was mostly referring to the existing RT cruft (SCHED_RR/FIFO), that's
utterly useless for KVM.

As to hosting vcpus with CBS this might maybe make sense, but RT-guests
are still miles away. Anyway, I'm not quite sure how you would want to
deal with the guest spinlock issue in CBS, ideally you'd use paravirt
guests to avoid that whole problem.

Anyway, /me goes do something useful, virt sucks and should be taken out
back and shot in the head.


