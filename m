Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751806Ab1BAUUq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 15:20:46 -0500
Received: from smtp-out.google.com ([74.125.121.67]:63392 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751463Ab1BAUUo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 15:20:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=Z+mhRjJN0bZDejd/9x81BL+eoGmG+ZoDYCIAcyDZr/9DXif7WD2jM05+SCxANfG2FU
         pQL1Szf05QX1Jq8xS7dg==
MIME-Version: 1.0
In-Reply-To: <1296582252.26581.255.camel@laptop>
References: <1296244340-15173-1-git-send-email-glommer@redhat.com>
	<1296244340-15173-5-git-send-email-glommer@redhat.com>
	<4D45649A.4090709@redhat.com>
	<1296575618.5081.13.camel@mothafucka.localdomain>
	<1296577030.26581.236.camel@laptop>
	<1296579641.5081.27.camel@mothafucka.localdomain>
	<1296582252.26581.255.camel@laptop>
Date: Tue, 1 Feb 2011 12:20:39 -0800
Message-ID: <AANLkTinAa+SYE__enUpnuuQXJJweyBF4dFBEUsfhS41A@mail.gmail.com>
Subject: Re: [PATCH v2 4/6] KVM-GST: KVM Steal time registration
From: Venkatesh Pallipadi <venki@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Glauber Costa <glommer@redhat.com>, Avi Kivity <avi@redhat.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org, aliguori@us.ibm.com,
        Rik van Riel <riel@redhat.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 1, 2011 at 9:44 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Tue, 2011-02-01 at 15:00 -0200, Glauber Costa wrote:
>>
>> > What you can do is: steal_ticks = steal_time_clock() / TICK_NSEC, or
>> > simply keep a steal time delta and every time it overflows
>> > cputime_one_jiffy insert a steal-time tick.
>>
>> What do you think about keeping accounting in msec/usec resolution and
>> (thus allowing us to compute half a tick to user/system, other half to
>> steal time) only change it to cputime in the last minute?
>
> its only accounting full tick..
>

Yes. The way we ended up dealing with this in irq time case is track
it in fine granularity and accumulate over time (internally) but
account it (make it visible externally) only in terms of ticks, only
when the value being accumulated crosses the tick boundary. This does
has a hole when we use 99% of time on tick on irq and use 1% just
before the tick on some system, then whole tick will be system and on
next tick if there is 1% irq and 99% system then that will be
accounted as irq as our accumulated value crosses the tick boundary
then. But, such holes on avg should not be worse than not having fine
granularity.

Thanks,
Venki
