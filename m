Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755197Ab0HITc2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 15:32:28 -0400
Received: from smtp-out.google.com ([74.125.121.35]:37938 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754982Ab0HITc1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 15:32:27 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=tlqK9iXedf8xo0DYARodo/Hx7juM+LgOg4+1uOLtOFVEstj4glHaqdzeR+UHXOB7g
	DaTvg+kXFJfN2tWRA6Zyw==
MIME-Version: 1.0
In-Reply-To: <20100809201822.441905f7@lxorguk.ukuu.org.uk>
References: <20100806225453.GA3947@linux.vnet.ibm.com>
	<alpine.DEB.2.00.1008061651530.30564@asgard.lang.hm>
	<AANLkTikyRhtfX4R3x_NDgHnXssmfVuhjC5PbhRZ0a7su@mail.gmail.com>
	<alpine.DEB.2.00.1008062010510.30564@asgard.lang.hm>
	<20100807061558.GA28087@thunk.org>
	<AANLkTi=sMVjya9CH6UoZwJCXJTDRgBhnPXmApU_RHVTi@mail.gmail.com>
	<20100808155719.GB3635@thunk.org>
	<AANLkTinM5e2HGOFavODPZNzZx4KshDSjsvKN4pLpGGgr@mail.gmail.com>
	<20100808213821.GD3635@thunk.org>
	<20100809112453.77210acc@lxorguk.ukuu.org.uk>
	<20100809181638.GI3026@linux.vnet.ibm.com>
	<20100809201822.441905f7@lxorguk.ukuu.org.uk>
Date: Mon, 9 Aug 2010 12:32:21 -0700
Message-ID: <AANLkTimEQ9PMZ+D-U2M-SuejcuHhGk=_MrkFLBx9WtoC@mail.gmail.com>
Subject: Re: Attempted summary of suspend-blockers LKML thread, take three
From: Brian Swetland <swetland@google.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: paulmck@linux.vnet.ibm.com, "Ted Ts'o" <tytso@mit.edu>,
        Felipe Contreras <felipe.contreras@gmail.com>, david@lang.hm,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        arve@android.com, mjg59@srcf.ucam.org, pavel@ucw.cz,
        florian@mickler.org, rjw@sisk.pl, stern@rowland.harvard.edu,
        peterz@infradead.org, tglx@linutronix.de, menage@google.com,
        david-b@pacbell.net, James.Bottomley@suse.de, arjan@infradead.org,
        swmike@swm.pp.se, galibert@pobox.com, dipankar@in.ibm.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 9, 2010 at 12:18 PM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
>> But wouldn't an office suite run as a power-oblivious application on an
>> Android device?  After all, office applications do not need to run when
>
> I was waiting for soemone to leap down the pit I dug  Office suites have
> some quite important background activities. Consider the case of a power
> oblivious Open Office. You type a critical document, you suspend, your
> phone battery dies a bit later, you lost your document. Office suites do
> timed backing up as one simple obvious example. That could become a power
> aware behaviour but the truely power oblivious office suite is a myth.
>
>> the screen is turned off, so these the applications do not need to use
>> suspend blockers.  That said, I could easily imagine that significant
>> work would be required to make OpenOffice run on Android, not due to
>> suspend blockers, but rather due to Android's unusual user space.
>
> You are tightly linking suspend blockers with Android. If they were a
> sensible general solution they would be generic not tied closely to
> Android

Doesn't the same problem exist on my linux laptop?  I write out my
manifesto in open office, close the lid of my laptop, the system
suspends before my huge document finishes writing out, later my
battery dies or I foolishly remove it or whatnot...  the main
difference seems to be that laptops, with their big 'ol batteries, are
less aggressive about power management and the result is wider windows
before and less frequent wakeups from suspend and thus better odds at
missing the race condition.

As Arve has pointed out previously, there are a number of uses for
suspend blockers, even on plugged-into-the-wall systems -- take his
example of wanting his mythtv backend to power down when not busy, but
never power down when he happens to be using it on console, or issues
with multiple services that want to wake up and keep the device awake
while working.

Brian
