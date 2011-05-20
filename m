Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935340Ab1ETFgq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 01:36:46 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:60640 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935210Ab1ETFgo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 01:36:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=J54amCb3yW/essOI2VyLHJrVvWZ9pwW4TC9prulDtHPz6m7wpffsMfYhpY+sXzMUj7
         fXuwxBg/hTbGiFQBo8PWvibZKed65+H7sG19qbmdt6tBtFAdOZQh+GM8LUlysYv2h9dZ
         +jZKIYMEkThpAJqB8ZvrdzV99HqlbG92rGFp8=
MIME-Version: 1.0
In-Reply-To: <201105182202.46820.rjw@sisk.pl>
References: <1305100723-29161-1-git-send-email-myungjoo.ham@samsung.com>
	<201105180036.03836.rjw@sisk.pl>
	<BANLkTi=_1DJPS+6goLA-UvdHJXEoPWBF2w@mail.gmail.com>
	<201105182202.46820.rjw@sisk.pl>
Date: Fri, 20 May 2011 14:36:43 +0900
Message-ID: <BANLkTi=Bf0A14iDEyYBtJNOYnSuUjmsFyw@mail.gmail.com>
Subject: Re: [PATCH v2 1/3] PM: Introduce DEVFREQ: generic DVFS framework with
 device-specific OPPs
From: MyungJoo Ham <myungjoo.ham@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Mark Brown <broonie@sirena.org.uk>, Jiejing Zhang <kzjeef@gmail.com>,
        Pavel Machek <pavel@ucw.cz>, Colin Cross <ccross@google.com>,
        Nishanth Menon <nm@ti.com>, Thomas Gleixner <tglx@linutronix.de>,
        Len Brown <len.brown@intel.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, May 19, 2011 at 5:02 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Wednesday, May 18, 2011, MyungJoo Ham wrote:
>> 2011/5/18 Rafael J. Wysocki <rjw@sisk.pl>:
>> > Hi,
>
> Hi,
>
> ...
[]
>>
>> Umm... yeah.. that option (calling devfreq_remove_device() for errors)
>> is also possible, which will also remove the need for the macro you've
>> mentioned.
>
> Yes.
>
>> However, when the error is temporary or the device has blocked
>> changing frequencies temporarily from target callback or governor, it
>> could be not so desirable.
>
> I guess we need some experience here.  Namely, it's difficult to say
> what's going to be more frequent, devices that have temporary failures
> or such that either work or not work at all.
>
> That said, I think the simpler approach is to drop devices from the list
> on errors (perhaps depending on the type of the error).
>
>> So, I'm considering to call devfreq_remove_device() at error if the
>> error is not "EAGAIN". That will also remove the need for the macro
>> and debug messages above. How about that?
>
> Sounds reasonable.

Alright, I'll try this in the next revision.

>
> ...
>> >> @@ -225,3 +225,28 @@ config PM_OPP
>> >>         representing individual voltage domains and provides SOC
>> >>         implementations a ready to use framework to manage OPPs.
>> >>         For more information, read <file:Documentation/power/opp.txt>
>> >> +
>> >> +config PM_DEVFREQ
>> >> +     bool "Generic Dynamic Voltage and Frequency Scaling (DVFS) Framework"
>> >> +     depends on PM_OPP
>> >
>> > This assumes the user will know if his/her platform uses that code.
>> > It may be a good idea to make it depend on a user-invisible option that
>> > can be selected by the platform.
>>
>> I think that like CPUFREQ, users will want to enable and disable
>> DEVFREQ feature by choice although they cannot choose the governor
>> directly. I'm also considering to allow users to set governors
>> forcibly and globally at menuconfig (like CPUFREQ does). With CPUFREQ,
>> such options helped a lot in troubleshooting of CPU related issues.
>>
>> Do you think it'd be better to have DEVFREQ enabled unconditionally
>> (if PM_OPP is available) nonetheless?
>
> First off, it doesn't make sense to enable it if the platform is not going to
> use it.  That's why I think it should depend on a platform-selected option.
> Only if that option is set the user should be given the choice to select
> DEVFREQ.
>
> Second, I'm not sure if that's a good idea to force DEVFREQ is the platform
> is going to use it.  Perhaps in the future if there are no major issues with
> it, we can do that.
>
> Thanks,
> Rafael
>

I see.

I'll open an option to enable/diable DEVFREQ and will make it depends
on OPP and add platform-selected option like OPP does.


Thank you.


Cheers! It's Friday :)
- MyungJoo

-- 
MyungJoo Ham, Ph.D.
Mobile Software Platform Lab,
Digital Media and Communications (DMC) Business
Samsung Electronics
cell: 82-10-6714-2858
