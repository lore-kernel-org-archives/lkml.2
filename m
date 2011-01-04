Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752398Ab1ADRCN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 12:02:13 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:46991 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752048Ab1ADRCL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 12:02:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=ebECN9lO1J3f2t9QpQjLRUyxy3Eiw3vOmx6aoFVZq1E4TlK2UozpOxBgMGCMtNhDTx
         Xzx+MXp9O86f8iEp3c8CxN2C4gBERpyhkPtRpg16sgm5o+ziC+zZO3k2AMUss754Jo2i
         layJe/sw6Tp0CGAS2kA4Vx0UfYUhtg4UGNL7E=
MIME-Version: 1.0
In-Reply-To: <4D2350AE.60302@redhat.com>
References: <20110103162637.29f23c40@annuminas.surriel.com>
	<20110103162918.577a9620@annuminas.surriel.com>
	<AANLkTim1UFzHjBv52p7tyVyXerCVUVOBSAa3ajwQveuN@mail.gmail.com>
	<4D234E60.3010804@redhat.com>
	<AANLkTim8zmhKjPs-fVdR=65VPd6hybD8HA8pKEyKzm13@mail.gmail.com>
	<4D2350AE.60302@redhat.com>
Date: Wed, 5 Jan 2011 01:02:09 +0800
Message-ID: <AANLkTinm1_GPDAWcxpyf2NV8B35mp30e3XWEk5TPdH7+@mail.gmail.com>
Subject: Re: [RFC -v3 PATCH 2/3] sched: add yield_to function
From: Hillf Danton <dhillf@gmail.com>
To: Rik van Riel <riel@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Avi Kiviti <avi@redhat.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mike Galbraith <efault@gmx.de>, Chris Wright <chrisw@sous-sol.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 5, 2011 at 12:54 AM, Rik van Riel <riel@redhat.com> wrote:
> On 01/04/2011 11:51 AM, Hillf Danton wrote:
>
>>> Wouldn't that break for FIFO and RR tasks?
>>>
>>> There's a reason all the scheduler folks wanted a
>>> per-class yield_to_task function :)
>>>
>>
>> Where is the yield_to callback in the patch for RT schedule class?
>> If @p is RT, what could you do?
>
> If the user chooses to overcommit the CPU with realtime
> tasks, the user cannot expect realtime response.
>
> For realtime, I have not implemented the yield_to callback
> at all because it would probably break realtime semantics
> and I assume people will not overcommit the CPU with realtime
> tasks anyway.
>
> I could see running a few realtime guests on a system, with
> the number of realtime VCPUs not exceeding the number of
> physical CPUs.
>
Then it looks curr->sched_class != p->sched_class is not enough,
and yield_to can not ease the lock contention in KVM in case where
p->rq->curr is RT.
