Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751963Ab0FCGnN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 02:43:13 -0400
Received: from smtp-out.google.com ([74.125.121.35]:16487 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751054Ab0FCGnJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 02:43:09 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=GcUADVHyLKH8ImCY2v/bnrB1iuVBKbNyHtH7fL45ytXQlxnv2s0KeksjTMOV44M1Q
	IGjYBZueSzINfEnRU8cPw==
MIME-Version: 1.0
In-Reply-To: <20100603163307.721b1c23@notabene.brown>
References: <Pine.LNX.4.44L0.1005271303190.3239-100000@iolanthe.rowland.org>
	<201006010005.19554.rjw@sisk.pl>
	<20100601090023.788cabf4@notabene.brown>
	<201006010232.20263.rjw@sisk.pl>
	<20100601113309.609349fd@notabene.brown>
	<alpine.LFD.2.00.1006010340160.2933@localhost.localdomain>
	<20100601122012.1edeaf48@notabene.brown>
	<alpine.LFD.2.00.1006011243350.2933@localhost.localdomain>
	<20100602153235.340a7852@notabene.brown>
	<AANLkTikVjAf5nHdMx2bcHRAUSkq99s-b5YZCECXIJJLy@mail.gmail.com>
	<20100602180614.729246ea@notabene.brown>
	<AANLkTikXy__71nBNW0EFbyL_qNf0nQ68pW9KymWlTk7L@mail.gmail.com>
	<20100603163307.721b1c23@notabene.brown>
Date: Wed, 2 Jun 2010 23:43:06 -0700
Message-ID: <AANLkTikuf6bKVHoGRTjrM_2kPtZqUM6J76Z0hNUQxT_3@mail.gmail.com>
Subject: Re: [PATCH] - race-free suspend. Was: Re: [linux-pm] [PATCH 0/8] 
	Suspend block api (version 8)
From: Brian Swetland <swetland@google.com>
To: Neil Brown <neilb@suse.de>
Cc: =?UTF-8?B?QXJ2ZSBIasO4bm5ldsOlZw==?= <arve@android.com>,
       Thomas Gleixner <tglx@linutronix.de>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Alan Stern <stern@rowland.harvard.edu>,
       Felipe Balbi <felipe.balbi@nokia.com>,
       Peter Zijlstra <peterz@infradead.org>,
       "Paul@smtp1.linux-foundation.org" <Paul@smtp1.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Florian Mickler <florian@mickler.org>,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       James Bottomley <James.Bottomley@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 2, 2010 at 11:33 PM, Neil Brown <neilb@suse.de> wrote:
>>
>> The current suspend-blocker proposal already involves userspace
>> changes (it's different than our existing wakelock interface), and
>> we're certainly not opposed to any/all userspace changes on principle,
>> but on the other hand we're not interested in significant reworks of
>> userspace unless they actually improve the situation somehow.  I think
>> bottlenecking events through a central daemon would represent a step
>> backwards.
>
> I guess it becomes an question of economics for you then.  Does the cost of
> whatever user-space changes are required exceed the value of using an upstream
> kernel?  Both the cost and the value would be very hard to estimate in
> advance.  I don't envy you the decision...

Well, at this point we've invested more engineering hours in the
various rewrites of this (single) patchset and discussion around it
than we have spent on rebasing our trees on roughly every other
mainline release since 2.6.16 or so, across five years of Android
development.  We think there's some good value to be had (all the
usual reasons) by heading upstream, so we're still discussing these
patches and exploring alternatives, but yes, from one way of looking
at it, it'd certainly be cheaper to just keep maintaining our own
trees.

Brian
