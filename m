Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752154Ab1DRUfV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 16:35:21 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:59986 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751570Ab1DRUfS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 16:35:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=i14eVx6WcO9JxsrNsjr8cFqiUcd5Jb7XFkqlnJk/G0UNoe0ETTQkURRL6OwwYioKjI
         +VcCbgdziqqgykV+ebGfRrxxZQ67sovXJ/1maTaYRJoWP6w9gjhNQBEue0VqFxRXeenw
         qvag2tfE9u/cDB1O8Kp9IfuFtJgc845r2Y5HM=
MIME-Version: 1.0
In-Reply-To: <BANLkTikEAro9mbrPys+iqUEJDvGFmRvwsA@mail.gmail.com>
References: <BANLkTi=0gS2TSGgG15DbDPGttzCvEbEvaw@mail.gmail.com>
	<BANLkTi=UjQ5tenjbHpkNWGmFSd2JzOvOOw@mail.gmail.com>
	<BANLkTikEAro9mbrPys+iqUEJDvGFmRvwsA@mail.gmail.com>
Date: Mon, 18 Apr 2011 16:35:17 -0400
X-Google-Sender-Auth: JFWwFnt_04SBhnkNw8ey3agP1oY
Message-ID: <BANLkTimL+x+CwHKLkpMsY7kGsk3WkWHvpw@mail.gmail.com>
Subject: Re: [RFT] Please test rdtsc on various x86-64 hardware (app included)
From: Colin Walters <walters@verbum.org>
To: Andrew Lutomirski <luto@mit.edu>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>, x86 <x86@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 18, 2011 at 4:27 PM, Andrew Lutomirski <luto@mit.edu> wrote:

> Well, crap.  Can you run:
>  dmesg | grep -i tsc

# dmesg|grep -i tsc
[    0.000000] Fast TSC calibration using PIT
[    0.098999] TSC synchronization [CPU#0 -> CPU#1]:
[    0.098999] Measured 2399269672 cycles TSC warp between CPUs,
turning off TSC clock.
[    0.098999] Marking TSC unstable due to check_tsc_sync_source failed

> There are two possible explanations:
> 1. Your tscs are out of sync, and whether the test notices or not
> depends on which cpus the scheduler sticks the threads on.

Looks like that's the case?   But for what you want to do in kernel,
the kernel already did this test and so would know to not use the TSC
for vgettimeofday(), right?  (I only sort of followed the clock
discussion earlier but I found it quite interesting, so decided to run
the test).
