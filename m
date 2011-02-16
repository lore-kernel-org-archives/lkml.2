Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758964Ab1BPMTB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 07:19:01 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:54215 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754761Ab1BPMS7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 07:18:59 -0500
X-Authority-Analysis: v=1.1 cv=+c36koQ5Dcj/1qolKHjtkYAGXvrVJRRiKMp+84F5sLg= c=1 sm=0 a=4UV-9Kl2S54A:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=bZSih4UtgmnRTX-y6tAA:9 a=6LJMykJkeSWPHUueayiYEawzLXQA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH 0/2] jump label: 2.6.38 updates
From: Steven Rostedt <rostedt@goodmis.org>
To: Will Newton <will.newton@gmail.com>
Cc: Will Simoneau <simoneau@ele.uri.edu>, David Miller <davem@davemloft.net>,
        hpa@zytor.com, matt@console-pimps.org, peterz@infradead.org,
        jbaron@redhat.com, mathieu.desnoyers@polymtl.ca, mingo@elte.hu,
        tglx@linutronix.de, andi@firstfloor.org, roland@redhat.com,
        rth@redhat.com, masami.hiramatsu.pt@hitachi.com, fweisbec@gmail.com,
        avi@redhat.com, sam@ravnborg.org, ddaney@caviumnetworks.com,
        michael@ellerman.id.au, linux-kernel@vger.kernel.org,
        vapier@gentoo.org, cmetcalf@tilera.com, dhowells@redhat.com,
        schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com,
        benh@kernel.crashing.org
In-Reply-To: <AANLkTikXy+AJ3tdEkEN--xJPefbXJ4-OVS3cg6R7yXzc@mail.gmail.com>
References: <4D59B891.8010300@zytor.com>
	 <AANLkTimp9xKbZdDZpONrxDkfMSAiQre0v=SOsJUnnoWA@mail.gmail.com>
	 <20110215211123.GA3094@ele.uri.edu>
	 <20110215.132702.39199169.davem@davemloft.net>
	 <20110215215604.GA3177@ele.uri.edu>
	 <AANLkTikXy+AJ3tdEkEN--xJPefbXJ4-OVS3cg6R7yXzc@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Wed, 16 Feb 2011 07:18:54 -0500
Message-ID: <1297858734.23343.138.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-02-16 at 10:15 +0000, Will Newton wrote:

> > That's some really crippled hardware... it does seem like *any* loads
> > from *any* address updated by an sc would have to be done with ll as
> > well, else they may load stale values. One could work this into
> > atomic_read(), but surely there are other places that are problems.
> 
> I think it's actually ok, atomics have arch implemented accessors, as
> do spinlocks and atomic bitops. Those are the only place we do sc so
> we can make sure we always ll or invalidate manually.

I'm curious, how is cmpxchg() implemented on this architecture? As there
are several places in the kernel that uses this on regular variables
without any "accessor" functions.

-- Steve


