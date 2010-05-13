Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758638Ab0EMKwN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 06:52:13 -0400
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:57773 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751937Ab0EMKwK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 06:52:10 -0400
Date: Thu, 13 May 2010 16:22:04 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Dhaval Giani <dhaval.giani@gmail.com>
Cc: Paul Menage <menage@google.com>, peterz@infradead.org,
       lennart@poettering.net, jsafrane@redhat.com, tglx@linutronix.de,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH/RFC] Have sane default values for cpusets
Message-ID: <20100513105204.GT3296@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <1273669541.3086.24.camel@localhost>
 <j2n6599ad831005121201za5fd85bpfc4fa2304a81acaf@mail.gmail.com>
 <AANLkTilLXWEYHJZCoNk1Tb4P8qgjK-zoVZSg1pDhR-3I@mail.gmail.com>
 <h2z6599ad831005121220h7956eb62yeea13626093b4a6e@mail.gmail.com>
 <AANLkTikyXpXKhyy2oZxAF5ums2go2qie0ShOGt2dtHBH@mail.gmail.com>
 <m2x6599ad831005121236ufa1bff7fz78423b1fb6b513e7@mail.gmail.com>
 <AANLkTimxO3xWmr8jgyiwsLNyqTJ-4OWJ4zNROC9SE7XH@mail.gmail.com>
 <AANLkTikGZ9yFxbcaIbcAb-oiuRaRKsOAL-_n1lMe-ZU9@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <AANLkTikGZ9yFxbcaIbcAb-oiuRaRKsOAL-_n1lMe-ZU9@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Dhaval Giani <dhaval.giani@gmail.com> [2010-05-13 12:26:30]:

> On Wed, May 12, 2010 at 9:59 PM, Dhaval Giani <dhaval.giani@gmail.com> wrote:
> > On Wed, May 12, 2010 at 9:36 PM, Paul Menage <menage@google.com> wrote:
> >> On Wed, May 12, 2010 at 12:29 PM, Dhaval Giani <dhaval.giani@gmail.com> wrote:
> >>>> I think the idea is reasonable - the only way that I could see it
> >>>> breaking someone would be code that currently does something like:
> >>>>
> >>>> mkdir A
> >>>> mkdir B
> >>>> echo 1 > A/mem_exclusive
> >>>> echo 1 > B/mem_exclusive
> >>>> echo $mems_for_a > A/mems
> >>>> echo $mems_for_b > B/mems
> >>>>
> >>>> The attempts to set the mem_exclusive flags would fail, since A and B
> >>>> would both have all of the parent's mems.
> >>>>
> >>>
> >>> But would this not fail otherwise?
> >>>
> >>
> >> Assuming that mems_for_a and mems_for_b were disjoint, it would be
> >> fine currently.
> >>
> >
> > Ah my bad. I misread mems_for_a as taking the value from the parent.
> > You are right, that was a case I missed.
> >
> > Hmm, so how do we fix this? Any solutions? Not fixing the kernel
> > pushes the problem to the userspace, making it hard for tons of more
> > applications to use cgroups without jumping through a lot of hoops.
> >
> 
> OK, how about this. Introduce a new option, nodefaults (or some such
> name) which would retain the existing behaviour while the default
> mount options would moutn cpuset with the defaults. Also, make
> 
> mount -t cpuset cpuset /cpuset
> 
> equivalent to
> 
> mount -t cgroup -onoprefix,nodefaults,cpuset cpuset /cpuset
>

Does something like cpusetinherits make more sense.

-- 
	Three Cheers,
	Balbir
