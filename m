Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756851Ab1ELMGQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 08:06:16 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:44107 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756549Ab1ELMGP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 08:06:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=VYSV2VooSuopVQWLh5rmQ9sOpFJJ49R3YChIL1iVR/f3M9cc63JIjs5ITD/iSoIA5k
         7egV/3UnqBCb7pt+7AZLpSzq2hB/Ozggn2oSVPwPax4QSxL79NXrCHzlR4mh+J1J8wii
         DUq+0xflIkKlhayfkIvKJ1OCP8FE8pkvDmQ/I=
Date: Thu, 12 May 2011 20:06:06 +0800
From: Yong Zhang <yong.zhang0@gmail.com>
To: Hillf Danton <dhillf@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>, Mike Galbraith <efault@gmx.de>
Subject: Re: [PATCH] sched: correct how RT task is picked
Message-ID: <20110512120606.GA3639@zhy>
Reply-To: Yong Zhang <yong.zhang0@gmail.com>
References: <BANLkTikkeR_yf1HGhgq7WEO-kEvDGkV_tw@mail.gmail.com>
 <BANLkTim4n-WA_6nJpg4Nd99yuc3f+VWkcw@mail.gmail.com>
 <BANLkTikOecxhb8pZfAd19FLrPAPY4zacDQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <BANLkTikOecxhb8pZfAd19FLrPAPY4zacDQ@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 11, 2011 at 09:44:04PM +0800, Hillf Danton wrote:
> On Wed, May 11, 2011 at 4:43 PM, Yong Zhang <yong.zhang0@gmail.com> wrote:
> > On Tue, May 10, 2011 at 9:04 PM, Hillf Danton <dhillf@gmail.com> wrote:
> >> When picking RT task for given CPU,
> >> [1] if the cpu is invalid for cpumask test, right result could not be
> >
> > 'cpu is invalid' means weather we care it or not, it's not real 'invalid'
> >
> If cpu is not cared, how to determine whether it is allowed for task to run?

pick_next_highest_task_rt() can be used to get the next highest pullable
task on a certain rq(regradless on which cpu that task could run). but
currently we have no such kind of caller.

> 
> >> reached even by further checking nr_cpus_allowed,
> >> on the other hand, the input cpu is valid in two cases that
> >> pick_next_highest_task_rt() is called, thus the invalid input cpu
> >> looks over-concern.
> >> [2] if the cpu is valid for cpumask test, further checking
> >> nr_cpus_allowed looks overwork, since it is computed based on
> >> cpus_allowed,
> >
> > No, cpumask_test_cpu(cpu, &p->cpus_allowed) doesn't mean
> > p->rt.nr_cpus_allowed > 1.
> >
> If cpu is allowed for task to run, then why more cpus are enforced?

I think you can take a look at next_prio(), it just calculate the
next highest task on the current cpu; in this case,
cpumask_test_cpu(cpu, &p->cpus_allowed) will be true for the most
of time, but maybe that task is bound to this cpu.

Thanks,
Yong
> 
> thanks
>           Hillf
