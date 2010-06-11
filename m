Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753307Ab0FKQYK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 12:24:10 -0400
Received: from mail-yw0-f204.google.com ([209.85.211.204]:44765 "EHLO
	mail-yw0-f204.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751997Ab0FKQYI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 12:24:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=wdtIsSD5pfeYpqjRYInOWyfPdmKq++TnKdfX3oq4AHMp6OfArs1ilGBmreGMssOgp4
         uKXbujUOclv75rP6HPOMsJ7GtF5Yf5XXP4d/azDF4wozukPDXfKB0jkHcKre+rYeD25e
         2z7kfwUnSOj1EsvkHdjT3geBXvwGQ3PiurF1s=
MIME-Version: 1.0
In-Reply-To: <4C115345.1060805@tmr.com>
References: <AANLkTinQatQEYahpkN3bT-S5C41HqRoH--gTrvIbGs_c@mail.gmail.com>
	<4C0D5DCD.5010201@sandeen.net>
	<AANLkTik1T2nJxsoK9UGIVy6q6pfSxniFfJXJY0InmuUh@mail.gmail.com>
	<AANLkTil4FMnGl7llR4N0PkXuNyEClQmTspNK6PT62PAi@mail.gmail.com>
	<889B6B31-A1F0-438D-B782-DBB855912854@sandeen.net>
	<AANLkTilrmEnLrxRSYNnwr8vFaZi7R9U5vY39NmBWUEMy@mail.gmail.com>
	<AANLkTil7toVuTbCExPtGMOqzqBVG3hG5JeEqzS6ZZ8T6@mail.gmail.com>
	<4C115345.1060805@tmr.com>
Date: Fri, 11 Jun 2010 10:23:58 -0600
Message-ID: <AANLkTinVaS0bjSvukl04-QSVOXTj1LrzlIHvQEbqr9Ig@mail.gmail.com>
Subject: Re: Fwd: EXT3 File System Corruption 2.6.34
From: Jeffrey Merkey <jeffmerkey@gmail.com>
To: Bill Davidsen <davidsen@tmr.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Well, I set the system to the default ordered mode and the problem
went away.  EXT3 recovers nicely now.  I run across this all the time
since I develop high speed kernel stuff and have a lot of cases where
a bug crashes the system.  This time it showed up while developing the
MDB debugger with the hw_breakpoint interface which caused the system
to crash until I figured out this newer interface had hooked the
notify_die handlers and was trapping breakpoints which caused a lot of
hangs until I fixed it, so it is something I ran across coincidently.
The default ordered mode makes ext3 robust again.

Jeff


On Thu, Jun 10, 2010 at 3:04 PM, Bill Davidsen <davidsen@tmr.com> wrote:
> Jeffrey Merkey wrote:
>>
>> ---------- Forwarded message ----------
>> From: Jeffrey Merkey <jeffmerkey@gmail.com>
>> Date: Mon, Jun 7, 2010 at 7:55 PM
>> Subject: Re: EXT3 File System Corruption 2.6.34
>> To: Eric Sandeen <sandeen@sandeen.net>
>>
>>
>>> On Jun 7, 2010, at 6:55 PM, Jeffrey Merkey <jeffmerkey@gmail.com> wrote:
>>>
>>>> ---------- Forwarded message ----------
>>>> From: Jeffrey Merkey <jeffmerkey@gmail.com>
>>>> Date: Mon, Jun 7, 2010 at 5:54 PM
>>>> Subject: Re: EXT3 File System Corruption 2.6.34
>>>> To: Eric Sandeen <sandeen@sandeen.net>
>>>>
>>>>
>>>> REPLY TO ALL
>>>>
>>>> CONFIG_EXT3_DEFAULTS_TO_ORDERED is not set
>>>>
>>>> Whether set this way or not, should not see corruption.
>>>
>>> Here you are mistaken.  Mount with data=ordered and see.  Writeback can
>>> expose stale data.
>>>
>>> -Eric
>>>
>>
>> OK.  I will set this up.  You may want to make this option the default
>> in the build scripts.  here is a corrupted file.  This was a .gif
>> image file I saved THEN AFTER SAVING THE FILE I pulled the power to
>> the machine and during recovery the file was FUCKED.  At any rate,
>> this does not happen with 2.6.28.
>>
> Having bad things happen when power is removed is not much of a surprise,
> and various options can fix that at the cost of speed. The fact that this
> didn't happen with 2.6.28 is bothersome.
>
> I actually take some care to avoid testing behavior in this area, not my
> normal intended mode of operation.
>
> --
> Bill Davidsen <davidsen@tmr.com>
>  "We have more to fear from the bungling of the incompetent than from
> the machinations of the wicked."  - from Slashdot
>
