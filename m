Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754728Ab0E1N1J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 09:27:09 -0400
Received: from smtp-out.google.com ([216.239.44.51]:15114 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753604Ab0E1N1H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 09:27:07 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:x-system-of-record;
	b=rt5RCjt0R1Vwvp5I+8gJlQUMVyTUUegDv/hPBYH/EflsWRp8QBdCHd7qm+bEXooG0
	xahJVhC5AzsAJleD5bJjA==
MIME-Version: 1.0
In-Reply-To: <4BFFC5DF.5030504@nokia.com>
References: <20100527222514.0a1710bf@lxorguk.ukuu.org.uk>
	<Pine.LNX.4.44L0.1005271730180.3239-100000@iolanthe.rowland.org>
	<20100527230806.4deb6de3@lxorguk.ukuu.org.uk>
	<20100527220949.GB10602@srcf.ucam.org>
	<20100527232357.6d14fdb2@lxorguk.ukuu.org.uk>
	<20100527223605.GB11364@srcf.ucam.org>
	<20100527235546.09f3ce8a@lxorguk.ukuu.org.uk>
	<20100528043114.GC26177@thunk.org>
	<20100528103713.0a7952d9@lxorguk.ukuu.org.uk>
	<20100528114123.GA22947@srcf.ucam.org>
	<4BFFB681.1000105@nokia.com>
	<AANLkTim04ZfMcPHRB2D_bqcAuguaGwySH2b6repuYLkk@mail.gmail.com>
	<4BFFC5DF.5030504@nokia.com>
Date: Fri, 28 May 2010 06:27:00 -0700
Message-ID: <AANLkTikKGeGHHL6AYC7uBuT7Zihj7lozfidWQ8zRHwab@mail.gmail.com>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
From: Brian Swetland <swetland@google.com>
To: Igor Stoppa <igor.stoppa@nokia.com>
Cc: ext Matthew Garrett <mjg59@srcf.ucam.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, "tytso@mit.edu" <tytso@mit.edu>,
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

On Fri, May 28, 2010 at 6:32 AM, Igor Stoppa <igor.stoppa@nokia.com> wrote:
>
> What I consider plain wrong i to claim that since there are this many units
> out, some code should be merged.

I've never suggested that we should get a get-out-of-code-review-free
card or be automatically merged based on shipping volume.

Hell, I never thought we should even bother trying to merge wakelocks
upstream, because I assumed that they'd be hated for not being the
linux way (tm).  Greg KH and others have spent a bunch of time
shouting at me (or Google) that we should be doing this, and here we
are giving it a go.  At this point we've spent more engineering time
on revising this one patchset (10 revisions to address various rounds
of feedback) and discussion of it than we have on rebasing our working
kernel trees to roughly every other linux release from 2.6.16 to
2.6.32 (which became much easier after switching to git).

> A company needs to cut corners sometimes when making a product but this
> should not affect upstream code.

I will disagree that wakelocks are "cutting corners" (we certainly
have some corner cutting code in our trees, because yeah, ship is
compromise, but I don't believe wakelocks are an example).  They're a
real solution for real problems faced on real devices.  Obviously not
a solution that everyone here likes, and maybe they'll never end up in
mainline as a result, but so far I haven't seen a counter proposed
solution that seems to solve the same problem, avoid races, and be
simpler/cleaner (at least to my eyes).

>> I am quite willing to state that on both MSM and OMAP based Android
>> platforms, we've found that the suspend blocker model allows us to
>> obtain a lower average power draw than if we don't use it -- Mike Chan
>> provided some numbers earlier in another thread in the trivial device
>> idle case, the win is of course much larger in the case of several
>> poorly behaved apps being active.
>
> That's very good. But if it is done in a conceptually flawed way, some
> better solution should be considered for upstream merge.

How is it flawed?  Serious question.

Brian
