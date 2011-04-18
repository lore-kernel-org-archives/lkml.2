Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752323Ab1DRUjm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 16:39:42 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:46316 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751418Ab1DRUjl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 16:39:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=iQ8n2LI55yFhJ9O1p1hCe0lQXYJjkT13dUxF2LQhDbfr9An/HxtqJGKl0PLHuEjBSX
         wCSYIGdZE6h4YFWRMUWBF7Clbq2chxtrmfVlUrfeghZjLOZCb+DhqynWhHP6cT/pm0Ak
         MnlqfzUNcTFufljlBKa4Le8g3WFLJZvbf4vdI=
MIME-Version: 1.0
In-Reply-To: <BANLkTimL+x+CwHKLkpMsY7kGsk3WkWHvpw@mail.gmail.com>
References: <BANLkTi=0gS2TSGgG15DbDPGttzCvEbEvaw@mail.gmail.com>
 <BANLkTi=UjQ5tenjbHpkNWGmFSd2JzOvOOw@mail.gmail.com> <BANLkTikEAro9mbrPys+iqUEJDvGFmRvwsA@mail.gmail.com>
 <BANLkTimL+x+CwHKLkpMsY7kGsk3WkWHvpw@mail.gmail.com>
From: Andrew Lutomirski <luto@mit.edu>
Date: Mon, 18 Apr 2011 16:39:21 -0400
X-Google-Sender-Auth: rFXVpwAMJt8tmX6ljtny3Q8JA98
Message-ID: <BANLkTikqCWVapeFgGe6OLS5+8N8OugirKA@mail.gmail.com>
Subject: Re: [RFT] Please test rdtsc on various x86-64 hardware (app included)
To: Colin Walters <walters@verbum.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>, x86 <x86@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 18, 2011 at 4:35 PM, Colin Walters <walters@verbum.org> wrote:
> On Mon, Apr 18, 2011 at 4:27 PM, Andrew Lutomirski <luto@mit.edu> wrote:
>
>> Well, crap.  Can you run:
>>  dmesg | grep -i tsc
>
> # dmesg|grep -i tsc
> [    0.000000] Fast TSC calibration using PIT
> [    0.098999] TSC synchronization [CPU#0 -> CPU#1]:
> [    0.098999] Measured 2399269672 cycles TSC warp between CPUs,
> turning off TSC clock.
> [    0.098999] Marking TSC unstable due to check_tsc_sync_source failed
>
>> There are two possible explanations:
>> 1. Your tscs are out of sync, and whether the test notices or not
>> depends on which cpus the scheduler sticks the threads on.
>
> Looks like that's the case?   But for what you want to do in kernel,
> the kernel already did this test and so would know to not use the TSC
> for vgettimeofday(), right?  (I only sort of followed the clock
> discussion earlier but I found it quite interesting, so decided to run
> the test).
>

Yes, the kernel won't run this code at all on your system.  That being
said, you have the constant_tsc flag and the error my tool measured is
pretty close to the error the kernel measured at boot, so it might be
interesting for the kernel to learn how to synchronize the TSCs
itself.  This is possible, abeit awkward, on newish Intel CPUs.  It's
possible but *really* awkward on older CPUs.

--Andy
