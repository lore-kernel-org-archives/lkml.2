Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752352Ab0H1AKY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 20:10:24 -0400
Received: from smtp-out.google.com ([74.125.121.35]:26794 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751128Ab0H1AKW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 20:10:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=l8Nizix41uVR5cpKc1pRa0CsEB/06dmYKKFR0wbUrk+aMO+a09Xeboy1QIFEY7lPpV
         pkFocgVqDrvCZ3UzfqQA==
MIME-Version: 1.0
In-Reply-To: <1282932708.1946.8.camel@work-vm>
References: <AANLkTi=ivkOHRYwLy5FDg3RnK18+opjGd9XsxC7yZqi7@mail.gmail.com>
	<AANLkTik0ZGs3i_mHtB0s6iT6X0cLgxMjRN7Hi9FK_ZLF@mail.gmail.com>
	<AANLkTikTF9uvKw+48_jJKLAwqp7MJnypvvUsHN3qQ58+@mail.gmail.com>
	<AANLkTin80q4tGPZ1FefWCUMmhpNKj3_-KZZB12gZvwSA@mail.gmail.com>
	<AANLkTin5cLQG9ApxhCs92Twm958MP0J+u4GdBysJ3aNk@mail.gmail.com>
	<AANLkTikWTLeDLbWWi-LJDD5SRAFN60v5065Vc_wGoY5N@mail.gmail.com>
	<1282932708.1946.8.camel@work-vm>
Date: Fri, 27 Aug 2010 17:10:19 -0700
Message-ID: <AANLkTi=8MXx9L0+V-JqXoO5PCWq5EPRW9fqpr913OTyC@mail.gmail.com>
Subject: Re: System time drifts when processor idle.
From: Venkatesh Pallipadi <venki@google.com>
To: john stultz <johnstul@us.ibm.com>
Cc: jean-philippe francois <jp.francois@cynove.com>, Lin Ming <lin@ming.vg>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-acpi@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, jslaby@suse.cz
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 27, 2010 at 11:11 AM, john stultz <johnstul@us.ibm.com> wrote:
> On Fri, 2010-08-27 at 16:12 +0200, jean-philippe francois wrote:
>> My Timekeeping bug is still present, here is an updated script and log.
>> I am willing to make test, but I don't know what kind of debugging
>> info is needed.
>>
>> cat /sys/devices/system/clocksource/clocksource0/available_clocksource
>> hpet acpi_pm
>> cat /sys/devices/system/clocksource/clocksource0/current_clocksource
>> hpet
>
> Huh. hpet was not what I would have expected.
>
>
> So first, two experiments:
>
> 1) Does booting with "clock=acpi_pm" cause the issue to disappear?
>
> 2) Does booting with "nohz=off" cause the issue to disappear?
>
>
> Venkatesh: You have any experience with HPETs that halt in idle?
>

No. Haven't seen anything like this before with HPET.

The jump was

system | hardware(RTC)
15:48:43 | ven. 27 août 2010 15:48:44 CEST  -0.985908 secondes
15:49:04 | ven. 27 août 2010 15:54:04 CEST  -0.032800 secondes

We lost ~300 seconds and from dmesg
hpet0: 3 comparators, 64-bit 14.318180 MHz counter

Which is close to 2^32 HPET ticks. So, looks like we have some 32 bit
wraparound somewhere..

Thanks,
Venki
