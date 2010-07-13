Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757180Ab0GMSA2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 14:00:28 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35208 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752654Ab0GMSA0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 14:00:26 -0400
MIME-Version: 1.0
In-Reply-To: <AANLkTini61PZO1_icO2jRcBmMvWm24splgjZA1lUgab2@mail.gmail.com>
References: <20100707124731.GJ15122@anguilla.noreply.org>
	<4C359D5A.1050906@redhat.com>
	<20100713102350.GW15122@anguilla.noreply.org>
	<4C3C68C8.4060409@redhat.com>
	<20100713141902.GB15122@anguilla.noreply.org>
	<4C3C8CE5.1080705@redhat.com>
	<20100713162207.GC15122@anguilla.noreply.org>
	<4C3C9589.4090602@redhat.com>
	<4C3C96EC.8060901@redhat.com>
	<4C3C9839.4090404@redhat.com>
	<20100713172526.GE15122@anguilla.noreply.org>
	<AANLkTini61PZO1_icO2jRcBmMvWm24splgjZA1lUgab2@mail.gmail.com>
Date: Tue, 13 Jul 2010 10:59:49 -0700
Message-ID: <AANLkTikDo0UsJxGekCdFgDMEHOONLiRe7ZOSf_j0ZKjf@mail.gmail.com>
Subject: Re: [patch 134/149] x86, paravirt: Add a global synchronization point 
	for pvclock
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Peter Palfrader <peter@palfrader.org>, Avi Kivity <avi@redhat.com>,
        Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org,
        stable@kernel.org, stable-review@kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Glauber Costa <glommer@redhat.com>,
        Zachary Amsden <zamsden@redhat.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        Marcelo Tosatti <mtosatti@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 13, 2010 at 10:50 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> No, you didn't back-port it wrong. I just didn't fix the right part. I
> thought the PV code used xchg, not cmpxchg, so I only patched that.
> But cmpxchg has the exact same issue.
>
> Does this fix it?

Btw, this second patch was a bit more aggressive than the first one,
and actually removes the "memory" clobber entirely, and the fake cast
of the target type.

That shouldn't matter _except_ if people actually use cmpxchg to
implement their own locking, since now the compiler could potentially
move unrelated memory references around the lock. Of course, if you
use cmpxchg to implement your own locking, you're probably doing
something wrong anyway (ie you'll get the wrong memory barriers on
various architectures), so it should all be fine.

But I thought I'd mention it. And I don't really know how much gcc
moves memory accesses around a "asm volatile" - the gcc docs are
historically very vague ("volatile asms aren't moved around
'significantly'", whatever 'significant' means)

And btw, none of the above should be taken to mean that I have tested
the patch or found it to be otherwise good. It might be totally broken
for other reasons. Caveat emptor.

                             Linus
