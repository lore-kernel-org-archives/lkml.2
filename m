Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755573Ab1BPMmH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 07:42:07 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:53707 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752679Ab1BPMmF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 07:42:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=P2ltIzJU/z6DbXIcSdvC8XH5tD1WAdk4IGueu2FkwFZlgBG/zx5oVB0QkdoPplp2VJ
         5L3sJI0z9rNXtxxVHMHCd5hlORNi0mdus2/xeNx4zcz2JH0YKnCtJ2et6ogXx+0FCTkl
         +PJ3LPVzUOjORJESFLEGxaABD0FCABWq4C0NY=
MIME-Version: 1.0
In-Reply-To: <1297858734.23343.138.camel@gandalf.stny.rr.com>
References: <4D59B891.8010300@zytor.com>
	<AANLkTimp9xKbZdDZpONrxDkfMSAiQre0v=SOsJUnnoWA@mail.gmail.com>
	<20110215211123.GA3094@ele.uri.edu>
	<20110215.132702.39199169.davem@davemloft.net>
	<20110215215604.GA3177@ele.uri.edu>
	<AANLkTikXy+AJ3tdEkEN--xJPefbXJ4-OVS3cg6R7yXzc@mail.gmail.com>
	<1297858734.23343.138.camel@gandalf.stny.rr.com>
Date: Wed, 16 Feb 2011 12:41:59 +0000
Message-ID: <AANLkTinzr6rb=WwFs7QApsvdy5f7PHZ1qS9ZVrncEzZD@mail.gmail.com>
Subject: Re: [PATCH 0/2] jump label: 2.6.38 updates
From: Will Newton <will.newton@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
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
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 16, 2011 at 12:18 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Wed, 2011-02-16 at 10:15 +0000, Will Newton wrote:
>
>> > That's some really crippled hardware... it does seem like *any* loads
>> > from *any* address updated by an sc would have to be done with ll as
>> > well, else they may load stale values. One could work this into
>> > atomic_read(), but surely there are other places that are problems.
>>
>> I think it's actually ok, atomics have arch implemented accessors, as
>> do spinlocks and atomic bitops. Those are the only place we do sc so
>> we can make sure we always ll or invalidate manually.
>
> I'm curious, how is cmpxchg() implemented on this architecture? As there
> are several places in the kernel that uses this on regular variables
> without any "accessor" functions.

We can invalidate the cache manually. The current cpu will see the new
value (post-cache invalidate) and the other cpus will see either the
old value or the new value depending on whether they read before or
after the invalidate, which is racy but I don't think it is
problematic. Unless I'm missing something...
