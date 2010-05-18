Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755057Ab0ERWVM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 18:21:12 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:62787 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752141Ab0ERWVK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 18:21:10 -0400
MIME-Version: 1.0
In-Reply-To: <201005182314.08761.rjw@sisk.pl>
References: <1273810273-3039-1-git-send-email-arve@android.com>
	 <201005182138.04610.rjw@sisk.pl>
	 <AANLkTileYiu6pL4eX3lpvpYLuu76A8auZp4xrcDX94BQ@mail.gmail.com>
	 <201005182314.08761.rjw@sisk.pl>
Date: Tue, 18 May 2010 15:21:09 -0700
Message-ID: <AANLkTikm69OKbRUvqiqGh4KRMn7u166tyt4kx0-bjR3Z@mail.gmail.com>
Subject: Re: [PATCH 0/8] Suspend block api (version 7)
From: =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Brian Swetland <swetland@google.com>, linux-pm@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/5/18 Rafael J. Wysocki <rjw@sisk.pl>:
> On Tuesday 18 May 2010, Arve Hjønnevåg wrote:
>> 2010/5/18 Rafael J. Wysocki <rjw@sisk.pl>:
>> > On Tuesday 18 May 2010, Arve Hjønnevåg wrote:
>> >> On Mon, May 17, 2010 at 2:44 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>> >> > On Monday 17 May 2010, Brian Swetland wrote:
>> >> >> On Mon, May 17, 2010 at 1:40 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>> >> >> > On Monday 17 May 2010, Arve Hjønnevåg wrote:
>> >> >> >>
> ...
>>
>> > Now, to make it more "user-friendly", we can simply use
>> > queue_delayed_work() with a reasonable delay instead of queue_work() to queue
>> > the suspend work (the delay may be configurable via sysfs).
>> >
>>
>> I can add a delay (and the timeout support code does add a delay as an
>> optimization) to the unknown wakeup case, but this does not fix the
>> problem of a user turning on opportunistic suspend with a user space
>> framework that does not use suspend blockers. If the kernel uses
>> suspend blockers to make sure the wakeup event makes it to user space,
>> but user space does not block suspend, then the system will suspend
>> before the event is processed.
>
> But the user can still manually write to /sys/power/state. :-)
>

Does adding or removing a delay change this? It seems in only changes
how quickly the user can finish that write.

I'm not convinced adding a configurable delay here is necessary. Once
the driver that enabled the wakeup event has been updated to block
suspend until this event gets to user space, then this delay will
never be triggered. The kernel cannot tell the difference between a
user enabling opportunistic suspend but not wanting it and
opportunistic suspend aware user space code deciding that this wakeup
event should be ignored.

-- 
Arve Hjønnevåg
