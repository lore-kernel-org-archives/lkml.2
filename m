Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932946Ab0FCGMs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 02:12:48 -0400
Received: from smtp-out.google.com ([216.239.44.51]:25515 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932651Ab0FCGMo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 02:12:44 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:x-system-of-record;
	b=EBWt8W/d4T4RTuUVZG01mUHfxjg01xdJ/acvnxwYEAvMCV4Sh/597O5GILoTBldEH
	nbYHh5vd9mXSC12LBKNLQ==
MIME-Version: 1.0
In-Reply-To: <20100603060444.GF11311@gvim.org>
References: <20100601090023.788cabf4@notabene.brown>
	<201006010232.20263.rjw@sisk.pl>
	<20100601113309.609349fd@notabene.brown>
	<alpine.LFD.2.00.1006010340160.2933@localhost.localdomain>
	<20100601122012.1edeaf48@notabene.brown>
	<alpine.LFD.2.00.1006011243350.2933@localhost.localdomain>
	<20100602153235.340a7852@notabene.brown>
	<AANLkTikVjAf5nHdMx2bcHRAUSkq99s-b5YZCECXIJJLy@mail.gmail.com>
	<20100602180614.729246ea@notabene.brown>
	<AANLkTikXy__71nBNW0EFbyL_qNf0nQ68pW9KymWlTk7L@mail.gmail.com>
	<20100603060444.GF11311@gvim.org>
Date: Wed, 2 Jun 2010 23:12:39 -0700
Message-ID: <AANLkTilml9GM2GmJhlB39oqDk6oPnLSSfiQAinpCpAbt@mail.gmail.com>
Subject: Re: [linux-pm] [PATCH] - race-free suspend. Was: Re: [PATCH 0/8] 
	Suspend block api (version 8)
From: Brian Swetland <swetland@google.com>
To: markgross@thegnar.org
Cc: Neil Brown <neilb@suse.de>, Peter Zijlstra <peterz@infradead.org>,
       "Paul@smtp1.linux-foundation.org" <Paul@smtp1.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Florian Mickler <florian@mickler.org>,
       James Bottomley <James.Bottomley@suse.de>,
       Linux PM <linux-pm@lists.linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Felipe Balbi <felipe.balbi@nokia.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 2, 2010 at 11:04 PM, mark gross <640e9920@gmail.com> wrote:
>>
>> There are many wakeup events possible in a typical system --
>> keypresses or other input events, network traffic, telephony events,
>> media events (fill audio buffer, fill video decoder buffer, etc), and
>> I think requiring that all wakeup event processing bottleneck through
>> a single userspace process is non-optimal here.
>
> Um doesn't the android framework bottleneck the user mode lock
> processing through the powermanager and any wake up event processing
> eventually has to grab a lock through this bottleneck anyway?

For "high level" framework/application level wakelocks, yes, but lower
level components beneath the java api layer use the kernel interface
directly.

Brian
