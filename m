Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932452Ab1BQUJb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 15:09:31 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:42058 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751763Ab1BQUJ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 15:09:29 -0500
X-Authority-Analysis: v=1.1 cv=3uSaImBeuprzHBlOOPjkqgu+7PcxSRW0m2Aphm9Zmck= c=1 sm=0 a=4UV-9Kl2S54A:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=i2tTwD48evmpC1tuHnwA:9 a=kjJaB1kMuWupgumXBe0Fd72Dh0wA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH 0/2] jump label: 2.6.38 updates
From: Steven Rostedt <rostedt@goodmis.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Will Newton <will.newton@gmail.com>, Will Simoneau <simoneau@ele.uri.edu>,
        David Miller <davem@davemloft.net>, hpa@zytor.com,
        matt@console-pimps.org, peterz@infradead.org, jbaron@redhat.com,
        mingo@elte.hu, tglx@linutronix.de, roland@redhat.com, rth@redhat.com,
        masami.hiramatsu.pt@hitachi.com, fweisbec@gmail.com, avi@redhat.com,
        sam@ravnborg.org, ddaney@caviumnetworks.com, michael@ellerman.id.au,
        linux-kernel@vger.kernel.org, vapier@gentoo.org, cmetcalf@tilera.com,
        dhowells@redhat.com, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com,
        benh@kernel.crashing.org
In-Reply-To: <BLU0-SMTP51D40A5B1DACA8883D6AB596D50@phx.gbl>
References: <4D59B891.8010300@zytor.com>
	 <AANLkTimp9xKbZdDZpONrxDkfMSAiQre0v=SOsJUnnoWA@mail.gmail.com>
	 <20110215211123.GA3094@ele.uri.edu>
	 <20110215.132702.39199169.davem@davemloft.net>
	 <20110215215604.GA3177@ele.uri.edu>
	 <AANLkTikXy+AJ3tdEkEN--xJPefbXJ4-OVS3cg6R7yXzc@mail.gmail.com>
	 <1297858734.23343.138.camel@gandalf.stny.rr.com>
	 <AANLkTinzr6rb=WwFs7QApsvdy5f7PHZ1qS9ZVrncEzZD@mail.gmail.com>
	 <BLU0-SMTP71BCB155CBAE79997EE08D96D20@phx.gbl>
	 <1297913774.23343.905.camel@gandalf.stny.rr.com>
	 <BLU0-SMTP51D40A5B1DACA8883D6AB596D50@phx.gbl>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Thu, 17 Feb 2011 15:09:25 -0500
Message-ID: <1297973365.23343.952.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-02-17 at 11:13 -0500, Mathieu Desnoyers wrote:

> > 
> > >                                  lfoo = foo;
> > 
> > IOW, will that smp_mb() really make lfoo read the new foo in memory? If
> > foo happens to still be in cache and no coherency has been performed to
> > flush it, would it just simply read foo straight from the cache?
> 
> If we were to deploy the Linux kernel on an architecture without
> coherent caches, I think smp_mb() should imply a cacheline invalidation,
> otherwise we completely mess up the order of data writes vs their
> observability from each invididual core POV.

Um but this thread is not about non-coherent caches. It's about a HW
that happens to do something stupid with ll/sc. That is, everything
deals with the cache except ll/sc which skips it.

Although, this was more or less answered in another email. That is, the
cache on this HW is not really coherent but all the CPUs just seem to
share the same cache. Thus a invalidate of the cache line affects all
CPUs which makes my question moot.

-- Steve


