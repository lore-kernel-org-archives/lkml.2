Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756813Ab1CWWeD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 18:34:03 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:58357 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756706Ab1CWWeA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 18:34:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=BZdAPCGud82VlRj56vEuF+W6TGyslpwgk92reM6+EnMDfiq6S1pnKX6Asdv3bHPUmL
         3oUB0ai/CxU9kgzuPUHAIjv16iT3iss+Wl4g8sBckhQlCk8oWA8R1muVJIJhk1Q0+aCq
         S0/gViNiyUaobis3j5MO7r3NW//wPms50Iy1Q=
MIME-Version: 1.0
In-Reply-To: <201103232311.38889.rjw@sisk.pl>
References: <AANLkTinRC1hXvaXDVV5pOA4YyCdXwAjziZsDzm=LuHqK@mail.gmail.com>
	<201103232136.19091.rjw@sisk.pl>
	<AANLkTimSyPiaq14yNP-KPxPcUaCqd4xr1xVNhefdK722@mail.gmail.com>
	<201103232311.38889.rjw@sisk.pl>
Date: Wed, 23 Mar 2011 23:33:59 +0100
Message-ID: <AANLkTimQuhRV-D3kcSJ_FYhe=U2da4qZM6xUw70PaQCh@mail.gmail.com>
Subject: Re: Corrupted files after suspend to disk
From: richard -rw- weinberger <richard.weinberger@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-pm@lists.linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 23, 2011 at 11:11 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Wednesday, March 23, 2011, richard -rw- weinberger wrote:
>> 2011/3/23 Rafael J. Wysocki <rjw@sisk.pl>:
>> > On Wednesday, March 23, 2011, richard -rw- weinberger wrote:
>> >> Hi,
>> >>
>> >> I'm facing a very strange problem on my netbook (Lenovo Ideapad S10)
>> >> running Linux 2.6.37.4.
>> >> After resuming from s2disk some files are corrupted.
>> >> But when I reboot my netbook everything seems good again.
>> >>
>> >> When I saw the problem the first time the ls command segfaulted always.
>> >> I did a reboot and it worked again.
>> >>
>> >> A few days later zypper crashed. After a reboot it worked again.
>> >> And today ssh crashed. I looked a bit closer and saw it crashed
>> >> somewhere within libcrypto.
>> >> So I made copy libcrypto and rebooted.
>> >> After the reboot ssh worked again but libcrypto and the copy of it hat
>> >> a different sha1 sum!
>> >> WTF?!
>> >>
>> >> Is this a known issue?
>> >
>> > No.
>> >
>> >> dmesgs and config are attached.
>> >>
>> >> The used distribution is openSUSE 11.4 with suspend-0.80.20100129-7.1
>> >> (default from suse).
>> >> I'm using ext3 as root filesystem.
>> >> What else do you need?
>> >
>> > Whatever you can do to narrow down the problem.  At the moment I only know
>> > that it's there.
>>
>> I can reproduce the problem now.
>> After ~20 suspend and resume iterations aide finds corrupted files in /lib/.
>> It's always a very basic lib like libcrypto, libglib which is used all
>> the time on my system.
>
> Those files are never intentionally modified, right?

Sorry, I've overlooked this question.
Yes, they have never been modified.
I've double checked it.

>> Maybe it's an issue like this one?
>> https://lkml.org/lkml/2010/12/2/339
>
> It might have if that patch hadn't been merged before 2.6.37.
>
> Is the system 32-bit or 64-bit?
>
> Rafael
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

-- 
Thanks,
//richard
