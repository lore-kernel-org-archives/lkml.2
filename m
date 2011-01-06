Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751816Ab1AFN2o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 08:28:44 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:62754 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751522Ab1AFN2m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 08:28:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=mykfI8WM8UAAJhuA8IRBTKVDFPcVZFkLfIu8nb+sXBF/SzAZVfsSDK0JX8EYevwViP
         a0XWtlyzRWFokEYBFv1vIaUMSaWNfN8c5IRoT7iQKGCYgOiIBtydeHuiOdqCgKT+0n2q
         75He3b0EYS+ZMeCDkeZcQLJjW/ZD4bBQ0QPmM=
MIME-Version: 1.0
In-Reply-To: <1294220513.2016.196.camel@laptop>
References: <1294164920.6169.199.camel@Palantir>
	<4D23AF8A.6080306@sssup.it>
	<1294220513.2016.196.camel@laptop>
Date: Thu, 6 Jan 2011 21:28:41 +0800
Message-ID: <AANLkTim-AUp7kv1wrH9EY1-BdpGTn2AUS3BJ48RS3q6O@mail.gmail.com>
Subject: Re: [Fwd: Re: [RFC -v3 PATCH 2/3] sched: add yield_to function]
From: Hillf Danton <dhillf@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Tommaso Cucinotta <tommaso.cucinotta@sssup.it>,
        Dario Faggioli <faggioli@gandalf.sssup.it>,
        Dhaval Giani <dhaval@retis.sssup.it>,
        Fabio Checconi <fabio@gandalf.sssup.it>, riel@redhat.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Avi Kiviti <avi@redhat.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Mike Galbraith <efault@gmx.de>, Chris Wright <chrisw@sous-sol.org>,
        Mike Christie <michaelc@cs.wisc.edu>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 5, 2011 at 5:41 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Wed, 2011-01-05 at 00:38 +0100, Tommaso Cucinotta wrote:
>> Il 04/01/2011 19:15, Dario Faggioli ha scritto:
>> >
>> > -------- Forwarded Message --------
>> > From: Peter Zijlstra<a.p.zijlstra@chello.nl>
>> > To: Rik van Riel<riel@redhat.com>
>> > Cc: Hillf Danton<dhillf@gmail.com>,kvm@vger.kernel.org,
>> > linux-kernel@vger.kernel.org, Avi Kiviti<avi@redhat.com>, Srivatsa
>> > Vaddagiri<vatsa@linux.vnet.ibm.com>, Mike Galbraith<efault@gmx.de>,
>> > Chris Wright<chrisw@sous-sol.org>
>> > Subject: Re: [RFC -v3 PATCH 2/3] sched: add yield_to function
>> > Date: Tue, 04 Jan 2011 19:05:54 +0100
>> > RT guests don't make sense, there's nowhere near enough infrastructure
>> > for that to work well.
>> >
>> > I'd argue that KVM running with RT priority is a bug.
>> Peter, can I ask why did you state that ? In the IRMOS project, we
>> are just deploying KVM VMs by using the Fabio's real-time scheduler
>> (for others, a.k.a., the Fabio's EDF throttling patch, or IRMOS RT
>> scheduler)
>> in order to let the VMs get precise CPU scheduling guarantees by the
>> kernel. So, in this context we do have KVM running at RT priority, and
>> we do have experimental results showing how this can improve stability
>> of performance of the hosted guest VMs.
>> Of course, don't misunderstand me: this is a necessary condition for a
>> stable performance of KVM VMs, I'm not saying it is sufficient for
>
> I was mostly referring to the existing RT cruft (SCHED_RR/FIFO), that's
> utterly useless for KVM.
>
> As to hosting vcpus with CBS this might maybe make sense, but RT-guests
> are still miles away. Anyway, I'm not quite sure how you would want to
> deal with the guest spinlock issue in CBS, ideally you'd use paravirt
> guests to avoid that whole problem.
>
> Anyway, /me goes do something useful, virt sucks and should be taken out
> back and shot in the head.
>

I dont think we are now still in the track of the patch from Rik, in
which Mike brought the yield_to method into scheduling.

The focus, as I see, is mainly on the effectiveness of the new method,
since it could also be utilized in other environments, though
currently it has nothing to do with the RT cruft but aims at easing
certain lock contention in KVM.

Another issue is that the change in the fair scheduling class,
accompanying the new method, is deserved, for any reason Rik hold.

Lets please return to the patch, and defer the RT.

thanks
Hillf
