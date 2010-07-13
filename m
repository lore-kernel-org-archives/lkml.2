Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754805Ab0GMSVI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 14:21:08 -0400
Received: from claw.goop.org ([74.207.240.146]:33861 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752725Ab0GMSVG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 14:21:06 -0400
Message-ID: <4C3CAE8F.10900@goop.org>
Date: Tue, 13 Jul 2010 11:21:03 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100621 Fedora/3.0.5-1.fc13 Lightning/1.0b2pre Thunderbird/3.0.5
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Peter Palfrader <peter@palfrader.org>, Avi Kivity <avi@redhat.com>,
        Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org,
        stable@kernel.org, stable-review@kernel.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Glauber Costa <glommer@redhat.com>,
        Zachary Amsden <zamsden@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
Subject: Re: [patch 134/149] x86, paravirt: Add a global synchronization point
 	for pvclock
References: <20100707124731.GJ15122@anguilla.noreply.org>	<4C359D5A.1050906@redhat.com>	<20100713102350.GW15122@anguilla.noreply.org>	<4C3C68C8.4060409@redhat.com>	<20100713141902.GB15122@anguilla.noreply.org>	<4C3C8CE5.1080705@redhat.com>	<20100713162207.GC15122@anguilla.noreply.org>	<4C3C9589.4090602@redhat.com>	<4C3C96EC.8060901@redhat.com>	<4C3C9839.4090404@redhat.com>	<20100713172526.GE15122@anguilla.noreply.org>	<AANLkTini61PZO1_icO2jRcBmMvWm24splgjZA1lUgab2@mail.gmail.com> <AANLkTikDo0UsJxGekCdFgDMEHOONLiRe7ZOSf_j0ZKjf@mail.gmail.com>
In-Reply-To: <AANLkTikDo0UsJxGekCdFgDMEHOONLiRe7ZOSf_j0ZKjf@mail.gmail.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/13/2010 10:59 AM, Linus Torvalds wrote:
> Btw, this second patch was a bit more aggressive than the first one,
> and actually removes the "memory" clobber entirely, and the fake cast
> of the target type.
>
> That shouldn't matter _except_ if people actually use cmpxchg to
> implement their own locking, since now the compiler could potentially
> move unrelated memory references around the lock. Of course, if you
> use cmpxchg to implement your own locking, you're probably doing
> something wrong anyway (ie you'll get the wrong memory barriers on
> various architectures), so it should all be fine.
>   

There are some places which rely on xchg/cmpxchg being a barrier in
arch-specific code.  For example, the Xen code uses as part of the
shared memory protocol with the hypervisor.

> But I thought I'd mention it. And I don't really know how much gcc
> moves memory accesses around a "asm volatile" - the gcc docs are
> historically very vague ("volatile asms aren't moved around
> 'significantly'", whatever 'significant' means)
>   

"asm volatile"'s only real meaning is that it will not get elided if it
appears its output is unused (assuming it is reachable at all).  I don't
think you can consider it having any meaningful effects on ordering.

    J
