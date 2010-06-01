Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752442Ab0FAFYc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 01:24:32 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:34896 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751926Ab0FAFYb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 01:24:31 -0400
MIME-Version: 1.0
In-Reply-To: <20100601050914.GG31155@gvim.org>
References: <20100530200409.GA21632@gvim.org>
	<20100531095753.4c174f2d@notabene.brown>
	<20100531221035.GB31155@gvim.org>
	<201006010045.21382.rjw@sisk.pl>
	<20100601050914.GG31155@gvim.org>
Date: Mon, 31 May 2010 22:24:30 -0700
Message-ID: <AANLkTik4ixmtv5Ki7jds5gEspJAxBRAcJCR1Jv-V6ajR@mail.gmail.com>
Subject: Re: [linux-pm] [RFC] lp_events: an lternitive to suspend blocker user 
	mode and kernel API
From: =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
To: markgross@thegnar.org
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, mark.gross@intel.com,
       Neil Brown <neilb@suse.de>, Brian Swetland <swetland@google.com>,
       linux-kernel@vger.kernel.org, Arve@smtp1.linux-foundation.org,
       Thomas Gleixner <tglx@linutronix.de>,
       linux-pm@lists.linux-foundation.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 31, 2010 at 10:09 PM, mark gross <640e9920@gmail.com> wrote:
> On Tue, Jun 01, 2010 at 12:45:21AM +0200, Rafael J. Wysocki wrote:
>> On Tuesday 01 June 2010, mark gross wrote:
>> > On Mon, May 31, 2010 at 09:57:53AM +1000, Neil Brown wrote:
>> ...
>> > > So I would suggest modifying your proposal to simply create a new 'input'
>> > > device.  Any driver that supports wake-from-suspend queues an event to that
>> > > device when a wakeup event occurs.  If the device is open and has any queued
>> > > events, then a suspend request such as 'echo mem > /sys/power/state' completes
>> > > without going into full suspend.
>> >
>> > /me likes.
>> >
>> > > Then you just need to convince us that this mechanism can be used without any
>> > > race problems.  If it can, then it would certainly be a simple and
>> > > unobtrusive approach.
>> >
>> > Lets find out.
>>
>> Simple question: how is that better than the Alan Stern's proposed approach?
>>
> I just saw Alan Stern's proposal, and have gotten some input form some
> others.  I can't say my patch represents a better Idea than what Alan
> proposed.  However; what Alan (and Thomas) are talking about is
> effectively the same as the kenrel mode wakelock/suspend blocker thing,
> and although it reuses existing infrastructure, it doesn't solve the
> problem of needing overlapping blocking sections of code from ISR to
> user mode.
>

I don't think your solution solves this either.

-- 
Arve Hjønnevåg
