Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752451Ab0FFSoZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jun 2010 14:44:25 -0400
Received: from smtp-out.google.com ([74.125.121.35]:47984 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751020Ab0FFSoW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jun 2010 14:44:22 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type;
	b=B0A9Ec8qW7j2Z9X45ifsQtmJgZLim0gYAZ7QvSlXxMoJU/J478KIDZAUn69aAsIi7
	MMa9ekK+urqndXfc+aNEg==
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.1006061932240.2933@localhost.localdomain>
References: <1275834706.7227.545.camel@mulgrave.site>
	<alpine.LFD.2.00.1006061725000.2933@localhost.localdomain>
	<1275844114.7227.552.camel@mulgrave.site>
	<alpine.LFD.2.00.1006061932240.2933@localhost.localdomain>
Date: Sun, 6 Jun 2010 11:44:16 -0700
Message-ID: <AANLkTilRbTVbjAt9uodpzecHLUmcDQEKT_EVpjyrSIwn@mail.gmail.com>
Subject: Re: [linux-pm] suspend blockers & Android integration
From: Brian Swetland <swetland@google.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: James Bottomley <James.Bottomley@suse.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Florian Mickler <florian@mickler.org>,
       Vitaly Wool <vitalywool@gmail.com>,
       =?UTF-8?B?QXJ2ZSBIasO4bm5ldsOlZw==?= <arve@android.com>,
       Arjan van de Ven <arjan@infradead.org>, tytso@mit.edu,
       Peter Zijlstra <peterz@infradead.org>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>, Neil Brown <neilb@suse.de>,
       Linux PM <linux-pm@lists.linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Felipe Balbi <felipe.balbi@nokia.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 6, 2010 at 11:04 AM, Thomas Gleixner <tglx@linutronix.de> wrote:
>>
>> Right, so the sooner we make it easier for the drivers to use the kernel
>> as their main repository, the better.
>
> Yep, the fastest way is to provide two stub inlines in pm.h and let
> the driver flood come in.

As mentioned previously, we didn't know this was an option (stubs
without an implementation behind them).  If it is, and thus we can
simplify the driver merging process short-term while sorting out a
long-term implementation or replacement for suspend blockers, then I
think we're making real progress.

There is no reason that drivers that support suspend blockers cannot
(or should not) support regular suspend/resume or runtime
suspend/resume, so that shouldn't be a worry.  The various operating
modes complement, not compete with each other (we want the lowest
possible power consumption in all states, be that fully active, fully
suspended, or anything in between -- I think everyone involved agrees
with this).

> I think all of us involved in that can do with a break, where we sit
> back, calm down and rethink w/o time pressure.

Total agreement.

Brian
