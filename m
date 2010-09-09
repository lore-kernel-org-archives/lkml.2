Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755167Ab0IIRmQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 13:42:16 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:58993 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752101Ab0IIRmN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 13:42:13 -0400
Subject: Re: System time drifts when processor idle.
From: john stultz <johnstul@us.ibm.com>
To: jean-philippe francois <jp.francois@cynove.com>
Cc: Lin Ming <lin@ming.vg>, venki@google.com, "H. Peter Anvin" <hpa@zytor.com>,
        linux-acpi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        jslaby@suse.cz
In-Reply-To: <AANLkTina8xAwnGVuPKywsf1qEzpu+rWNbv7JjqAgLqp1@mail.gmail.com>
References: <AANLkTi=ivkOHRYwLy5FDg3RnK18+opjGd9XsxC7yZqi7@mail.gmail.com>
	 <AANLkTik0ZGs3i_mHtB0s6iT6X0cLgxMjRN7Hi9FK_ZLF@mail.gmail.com>
	 <AANLkTikTF9uvKw+48_jJKLAwqp7MJnypvvUsHN3qQ58+@mail.gmail.com>
	 <AANLkTin80q4tGPZ1FefWCUMmhpNKj3_-KZZB12gZvwSA@mail.gmail.com>
	 <AANLkTin5cLQG9ApxhCs92Twm958MP0J+u4GdBysJ3aNk@mail.gmail.com>
	 <AANLkTikWTLeDLbWWi-LJDD5SRAFN60v5065Vc_wGoY5N@mail.gmail.com>
	 <1282932708.1946.8.camel@work-vm>
	 <AANLkTina8xAwnGVuPKywsf1qEzpu+rWNbv7JjqAgLqp1@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 09 Sep 2010 10:42:05 -0700
Message-ID: <1284054125.2762.47.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-09-03 at 14:23 +0200, jean-philippe francois wrote:
> 2010/8/27 john stultz <johnstul@us.ibm.com>:
> > On Fri, 2010-08-27 at 16:12 +0200, jean-philippe francois wrote:
> >> My Timekeeping bug is still present, here is an updated script and log.
> >> I am willing to make test, but I don't know what kind of debugging
> >> info is needed.
> >>
> >> cat /sys/devices/system/clocksource/clocksource0/available_clocksource
> >> hpet acpi_pm
> >> cat /sys/devices/system/clocksource/clocksource0/current_clocksource
> >> hpet
> >
> > Huh. hpet was not what I would have expected.
> >
> >
> > So first, two experiments:
> >
> > 1) Does booting with "clock=acpi_pm" cause the issue to disappear?
> >
> 
> Hi,
> 
> The same bug happens with clock=acpi_pm.
> My apologies for a previous mail where I said it was not hapenning with acpi_pm.
> 
> With both clock, the timekeeping gap augments by amount of 5 minutes.

Huh. So this still seems strange, but assuming we're still using the
hpet for irqs, its possible the event somehow gets pushed back 5 minutes
and we miss an timekeeping interval accumulation (with acpi_pm, the
counter wraps ever 5 seconds or so, so we could miss many accumulation
intervals and still be 5 minutes off if the tick timer was late).

Again, seeing if the issue goes away with nohz=off would be helpful.

thanks
-john


