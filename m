Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757421Ab0E1O3g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 10:29:36 -0400
Received: from smtp-out.google.com ([74.125.121.35]:13234 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750916Ab0E1O3e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 10:29:34 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:x-system-of-record;
	b=d/R4kJTNv6dt3VwmP3YK15E7btwEHNm+LdrFIGrSfdMR0FW9G9wY4EJiBc1+zHd4G
	8Vmpqq8j41FotBaTrXCsg==
MIME-Version: 1.0
In-Reply-To: <20100528142124.GA26733@srcf.ucam.org>
References: <20100527223605.GB11364@srcf.ucam.org>
	<20100527235546.09f3ce8a@lxorguk.ukuu.org.uk>
	<20100528043114.GC26177@thunk.org>
	<20100528103713.0a7952d9@lxorguk.ukuu.org.uk>
	<20100528114123.GA22947@srcf.ucam.org>
	<4BFFB681.1000105@nokia.com>
	<AANLkTim04ZfMcPHRB2D_bqcAuguaGwySH2b6repuYLkk@mail.gmail.com>
	<4BFFC5DF.5030504@nokia.com>
	<20100528133900.GG26177@thunk.org>
	<4BFFCFC7.7070302@nokia.com>
	<20100528142124.GA26733@srcf.ucam.org>
Date: Fri, 28 May 2010 07:29:27 -0700
Message-ID: <AANLkTilj6i7Qi-eh7e3WWeh4zxKALqr-0yhAvWKis52t@mail.gmail.com>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
From: Brian Swetland <swetland@google.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Igor Stoppa <igor.stoppa@nokia.com>, tytso@mit.edu,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Florian Mickler <florian@mickler.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       "Balbi Felipe (Nokia-D/Helsinki)" <felipe.balbi@nokia.com>
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 28, 2010 at 7:21 AM, Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> On Fri, May 28, 2010 at 05:14:31PM +0300, Igor Stoppa wrote:
>
>> I have seen very good proposals for saner solutions.
>>
>> Is that progress?
>
> The proposals so far involve either redefining the problem space or
> being inherently racey. It may be that we can redefine the problem space
> in such a way that everyone's happy, but it's not possible to do so by
> fiat.

I think the suggestion that has the closet fit with what we're trying
to accomplish is Ingo's (or perhaps Ingo's explanation of Alan's):
http://lkml.org/lkml/2010/5/28/106 where it's implemented as a
constraint of some sort.

Arve points out that qos constraint objects could work (but not if
specifically tied to apps): http://lkml.org/lkml/2010/5/28/120 though
he suggests that "latency" constraints don't represent this as well as
"state" constraints.

Though if you look at it that way, then suspend_blockers become qos
constraint objects, but their implementation and usage remain pretty
much the same as we have now, which does not address Alan's concern
regarding code turning up in drivers, etc.  I'm not sure how you can
solve this problem (avoiding races around entering/exiting the suspend
or suspend-like state) without having a means for drivers to prevent
entry to that state.

I need to think more about the cgroups approach, but I'm pretty sure
it still suffers from wakeup race situations, and due to the
complexity of userspace (at least ours), I suspect it would risk
livelock/deadlock/priority-inversion style issues due to interaction
between different processes in different groups.

Brian
