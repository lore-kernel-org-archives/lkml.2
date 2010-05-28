Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758491Ab0E1CrX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 22:47:23 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:52542 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755257Ab0E1CrV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 22:47:21 -0400
MIME-Version: 1.0
In-Reply-To: <20100527232357.6d14fdb2@lxorguk.ukuu.org.uk>
References: <20100527222514.0a1710bf@lxorguk.ukuu.org.uk>
	<Pine.LNX.4.44L0.1005271730180.3239-100000@iolanthe.rowland.org>
	<20100527230806.4deb6de3@lxorguk.ukuu.org.uk>
	<20100527220949.GB10602@srcf.ucam.org>
	<20100527232357.6d14fdb2@lxorguk.ukuu.org.uk>
Date: Thu, 27 May 2010 19:47:18 -0700
Message-ID: <AANLkTil6Bo7qZltbLzHJjIDyruKHFQEURpe5LPJEpTws@mail.gmail.com>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
From: =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Florian Mickler <florian@mickler.org>, felipe.balbi@nokia.com,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 27, 2010 at 3:23 PM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> On Thu, 27 May 2010 23:09:49 +0100
> Matthew Garrett <mjg59@srcf.ucam.org> wrote:
>
>> On Thu, May 27, 2010 at 11:08:06PM +0100, Alan Cox wrote:
>>
>> > This is I believe robust (and has been implemented on some non x86
>> > boxes). It depends on not forcing running tasks into suspend. That is the
>> > key.
>>
>> We've already established that ACPI systems require us to force running
>> tasks into suspend. How do we avoid the race in that situation?
>
> Android phones do not have ACPI. Embedded platforms do not have ACPI. MID
> x86 devices do not have ACPI.
>

Android does not only run on phones. It is possible that no android
devices have ACPI, but I don't know that for a fact. What I do know is
that people want to run Android on x86 hardware and supporting suspend
could be very benficial.

> I would imagine the existing laptops will handle power management limited
> by the functionality they have available. Just like any other piece of
> hardware.

I think existing laptops (and desktops) can benefit from opportunistic
suspend support. If opportunistic suspend is used for auto-sleep after
inactivity instead of forced suspend, the user space suspend blocker
api will allow an application to delay this auto sleep until for
instance a download completes. This part could also be done with a
user-space IPC call, but having a standard kernel interface for it may
make it more common. A less common case, but more critical, is RTC
alarms. I know my desktops can wakeup at a specific time by
programming an RTC alarm, but without suspend blockers how do you
ensure that the system does not suspend right after the alarm
triggered? I have a system that wakes up at specific times requested
by my DVR application, but I cannot use this system for anything else
unless I manually turn off the DVR application's auto-sleep feature.
With suspend blockers and something like the android alarm driver, I
could use this system for more than one application that have
scheduled tasks and it would be more usable for interactive
applications.

-- 
Arve Hjønnevåg
