Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754969Ab1BQKz2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 05:55:28 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:33722 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752810Ab1BQKz0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 05:55:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=WbQaHBtOWYKVA/QyjggMev0MLWvAvkBu+AgM0jrwxI+AaZJG5WBe2DVRElAEVW28/p
         BpS5+N0tIOu3T4XileKA/Bkuam20ltDLkV8LV/FYA8BqX3xgWqhyiTgV06TsADrGKAtg
         DYgIrJ7bLmX9ma+1pTfpoW2yizFw3p28usBZ0=
MIME-Version: 1.0
In-Reply-To: <20110216225151.GA10435@ele.uri.edu>
References: <4D59B891.8010300@zytor.com>
	<AANLkTimp9xKbZdDZpONrxDkfMSAiQre0v=SOsJUnnoWA@mail.gmail.com>
	<20110215211123.GA3094@ele.uri.edu>
	<20110215.132702.39199169.davem@davemloft.net>
	<20110215215604.GA3177@ele.uri.edu>
	<AANLkTikXy+AJ3tdEkEN--xJPefbXJ4-OVS3cg6R7yXzc@mail.gmail.com>
	<1297858734.23343.138.camel@gandalf.stny.rr.com>
	<AANLkTinzr6rb=WwFs7QApsvdy5f7PHZ1qS9ZVrncEzZD@mail.gmail.com>
	<20110216225151.GA10435@ele.uri.edu>
Date: Thu, 17 Feb 2011 10:55:25 +0000
Message-ID: <AANLkTinbGYo=mLgseXTR-k1Cns+GFBGPm0VXVgtS02L0@mail.gmail.com>
Subject: Re: [PATCH 0/2] jump label: 2.6.38 updates
From: Will Newton <will.newton@gmail.com>
To: Will Simoneau <simoneau@ele.uri.edu>
Cc: Steven Rostedt <rostedt@goodmis.org>, David Miller <davem@davemloft.net>,
        hpa@zytor.com, matt@console-pimps.org, peterz@infradead.org,
        jbaron@redhat.com, mathieu.desnoyers@polymtl.ca, mingo@elte.hu,
        tglx@linutronix.de, roland@redhat.com, rth@redhat.com,
        masami.hiramatsu.pt@hitachi.com, fweisbec@gmail.com, avi@redhat.com,
        sam@ravnborg.org, ddaney@caviumnetworks.com, michael@ellerman.id.au,
        linux-kernel@vger.kernel.org, vapier@gentoo.org, cmetcalf@tilera.com,
        dhowells@redhat.com, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com,
        benh@kernel.crashing.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 16, 2011 at 10:51 PM, Will Simoneau <simoneau@ele.uri.edu> wrote:
> On 12:41 Wed 16 Feb     , Will Newton wrote:
>> On Wed, Feb 16, 2011 at 12:18 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
>> > I'm curious, how is cmpxchg() implemented on this architecture? As there
>> > are several places in the kernel that uses this on regular variables
>> > without any "accessor" functions.
>>
>> We can invalidate the cache manually. The current cpu will see the new
>> value (post-cache invalidate) and the other cpus will see either the
>> old value or the new value depending on whether they read before or
>> after the invalidate, which is racy but I don't think it is
>> problematic. Unless I'm missing something...
>
> If I understand this correctly, the manual invalidates must propagate to
> all CPUs that potentially read the value, even if there is no
> contention. Doesn't this involve IPIs? How does it not suck?

The cache is shared between cores (in that regard it's more like a
hyper-threaded core than a true multi-core) so is completely coherent,
so this is the one bit that doesn't really suck! Having spoken to our
hardware guys I'm confident that we'll only ever build a handful of
chip designs with the current way of doing ll/sc and hopefully future
cores will do this the "right" way.
