Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752518Ab0H1PVF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Aug 2010 11:21:05 -0400
Received: from smtp-out.google.com ([216.239.44.51]:37975 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752260Ab0H1PVC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Aug 2010 11:21:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=byit85BLALikJ2yreRT5qt3blKvwAunCkexKZdywiyU96IYdXz35XyQLpPiKcHD9Rp
         hSL3qCKh2Cc21NJ6MY6w==
MIME-Version: 1.0
In-Reply-To: <AANLkTinh6E1mjyDK6Oud_tkL409xrsZRDA7gX+uGZ+Pc@mail.gmail.com>
References: <AANLkTi=ivkOHRYwLy5FDg3RnK18+opjGd9XsxC7yZqi7@mail.gmail.com>
	<AANLkTik0ZGs3i_mHtB0s6iT6X0cLgxMjRN7Hi9FK_ZLF@mail.gmail.com>
	<AANLkTikTF9uvKw+48_jJKLAwqp7MJnypvvUsHN3qQ58+@mail.gmail.com>
	<AANLkTin80q4tGPZ1FefWCUMmhpNKj3_-KZZB12gZvwSA@mail.gmail.com>
	<AANLkTin5cLQG9ApxhCs92Twm958MP0J+u4GdBysJ3aNk@mail.gmail.com>
	<AANLkTikWTLeDLbWWi-LJDD5SRAFN60v5065Vc_wGoY5N@mail.gmail.com>
	<1282932708.1946.8.camel@work-vm>
	<AANLkTi=8MXx9L0+V-JqXoO5PCWq5EPRW9fqpr913OTyC@mail.gmail.com>
	<1282957741.1946.27.camel@work-vm>
	<AANLkTinh6E1mjyDK6Oud_tkL409xrsZRDA7gX+uGZ+Pc@mail.gmail.com>
Date: Sat, 28 Aug 2010 08:19:19 -0700
Message-ID: <AANLkTi=2aqSrczTLerfvkkF_yZkyYZ29Bb=exrq8EecX@mail.gmail.com>
Subject: Re: System time drifts when processor idle.
From: Venkatesh Pallipadi <venki@google.com>
To: jean-philippe francois <jp.francois@cynove.com>
Cc: john stultz <johnstul@us.ibm.com>, Lin Ming <lin@ming.vg>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-acpi@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, jslaby@suse.cz
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 28, 2010 at 5:45 AM, jean-philippe francois
<jp.francois@cynove.com> wrote:
> 2010/8/28 john stultz <johnstul@us.ibm.com>:
>
>>> > Huh. hpet was not what I would have expected.
>>> >
>>> >
>>> > So first, two experiments:
>>> >
>>> > 1) Does booting with "clock=acpi_pm" cause the issue to disappear?
>>> >
>
> Yes, the problem usually show up quite quickly, and I think I have let
> my script run
> for a long enough time to say it does not occur with clock=acpi_pm
>
>>> > 2) Does booting with "nohz=off" cause the issue to disappear?
>>> >
> Not tested yet.
>
>>
>> jean-philippe: Is the drift always in 5 minute increments? Can you leave
>> it idle for 3 minutes and see a similar 3 minute delay, or is it always
>> in units of 5 ?
>>
> That is interesting !
> I think I have always seen 5 minutes or multiples of this delay. I
> will try to leave it running for a longer
> period of time and come back to you with more results. If you look at
> the first message of this thread
> (on linux-acpi) the delay is first 5, then 10 minutes.
>

OK. So, the problem seems to be limited to HPET and 5 min multiples.

> john stultz <johnstul@us.ibm.com>:
> Huh. So you're thinking the timer tick scheduler is pushing way past the
> HPET wrap length, and then we're missing an accumulation point and
> things wrap under us?

John: I don't think it is that we are going tickless beyond HPET wrap
length. HPET max delta should be preventing that.
We probably need to read out HPET hardware counter to see whether
things are OK there. Even if we miss the interrupt, time update should
notice that. One potential problem may be that HPET hardware can only
do 32 bit mode, but advertising 64 bit mode and we are getting
confused when we update time?

jean-philippe: What does hpet section of "cat /proc/timer_list" look
like? Also, can you boot with "hpet=verbose" option and send the
dmesg.

Thanks,
Venki
