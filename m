Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756243Ab0FCR1F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 13:27:05 -0400
Received: from smtp-out.google.com ([74.125.121.35]:24542 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752750Ab0FCR1C convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 13:27:02 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=Jf8oZ9YqIwV0zOyi1CvgnKxNPxWC1/QxM4w0GWJ75ObO2LVJGHPc8rLOLLYc3I5Hl
	3DJl4IEKRai3Hkl/NR2dg==
MIME-Version: 1.0
In-Reply-To: <20100603133646.GF15595@gvim.org>
References: <20100601113309.609349fd@notabene.brown>
	<alpine.LFD.2.00.1006010340160.2933@localhost.localdomain>
	<20100601122012.1edeaf48@notabene.brown>
	<alpine.LFD.2.00.1006011243350.2933@localhost.localdomain>
	<20100602153235.340a7852@notabene.brown>
	<AANLkTikVjAf5nHdMx2bcHRAUSkq99s-b5YZCECXIJJLy@mail.gmail.com>
	<20100602180614.729246ea@notabene.brown>
	<AANLkTikXy__71nBNW0EFbyL_qNf0nQ68pW9KymWlTk7L@mail.gmail.com>
	<20100603060444.GF11311@gvim.org>
	<AANLkTilml9GM2GmJhlB39oqDk6oPnLSSfiQAinpCpAbt@mail.gmail.com>
	<20100603133646.GF15595@gvim.org>
Date: Thu, 3 Jun 2010 10:26:58 -0700
Message-ID: <AANLkTinbLQNRyDC2PRUwoVXMF16RLHa2xZl3gJr-ftgB@mail.gmail.com>
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
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 3, 2010 at 6:36 AM, mark gross <640e9920@gmail.com> wrote:
> On Wed, Jun 02, 2010 at 11:12:39PM -0700, Brian Swetland wrote:
>> On Wed, Jun 2, 2010 at 11:04 PM, mark gross <640e9920@gmail.com> wrote:
>> >>
>> >> There are many wakeup events possible in a typical system --
>> >> keypresses or other input events, network traffic, telephony events,
>> >> media events (fill audio buffer, fill video decoder buffer, etc), and
>> >> I think requiring that all wakeup event processing bottleneck through
>> >> a single userspace process is non-optimal here.
>> >
>> > Um doesn't the android framework bottleneck the user mode lock
>> > processing through the powermanager and any wake up event processing
>> > eventually has to grab a lock through this bottleneck anyway?
>>
>> For "high level" framework/application level wakelocks, yes, but lower
>> level components beneath the java api layer use the kernel interface
>> directly.
>>
> Oh.  I thought everything went through
> hardware/libhardware_legacy/power/power.c
> who else is hitting /sys/power/* in the android user mode then?

I believe everything does -- that's the thin wrapper around the kernel
interface (which will have to change slightly to meet the
suspend_blocker device/fd vs wakelock proc/sys interface, etc), which
is used by the powermanager service, the RIL, and any other low level
code.  At the App/Service level, wakelocks are provided by a java
level API that is a remote interface to the powermanager.

Brian
