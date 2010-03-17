Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755418Ab0CQWzt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 18:55:49 -0400
Received: from mail-bw0-f212.google.com ([209.85.218.212]:61901 "EHLO
	mail-bw0-f212.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753879Ab0CQWzr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 18:55:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=AbBn1bqOVppGiEPNin35A+pT04LRg8ItWRC2pC7QFOhaJpWLac99v/J1bL51f7Gx9q
         Cka2GJQXn3kvZ9TYhK96YVZDxC05+il66fj1zKCXFkMAQDNUTGF90koqzpz3oWSt9tn6
         f5FY5bgsPRG4yQIxhB2I8KDS5MLdwcCaIqMjs=
MIME-Version: 1.0
In-Reply-To: <71cd59b01003170122h1ef767a3ma186e7ef278d73a1@mail.gmail.com>
References: <b637ec0b1003111328u5c1d7d7fw6c76c409740827c7@mail.gmail.com>
	 <71cd59b01003120049n1a9fbbf3qfd37f14f241a7f64@mail.gmail.com>
	 <b637ec0b1003121207g5d29ddb4k338f1768ed1c2759@mail.gmail.com>
	 <71cd59b01003130116h4265769v9e1dae95361629ce@mail.gmail.com>
	 <b637ec0b1003130450n3293ee78wc58e08a9bbcefe17@mail.gmail.com>
	 <71cd59b01003152354h64d18c0fq2083f60e399313c8@mail.gmail.com>
	 <b637ec0b1003161331y680418e0p6549504165a45701@mail.gmail.com>
	 <71cd59b01003170122h1ef767a3ma186e7ef278d73a1@mail.gmail.com>
Date: Wed, 17 Mar 2010 23:55:45 +0100
Message-ID: <b637ec0b1003171555j43a50997sb4f5a781b0037b0f@mail.gmail.com>
Subject: Re: Possible bug in eeepc-laptop.c - EeePC 900
From: Fabio Comolli <fabio.comolli@gmail.com>
To: Corentin Chary <corentin.chary@gmail.com>
Cc: ACPI mailing list <linux-acpi@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Len Brown <lenb@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Wed, Mar 17, 2010 at 9:22 AM, Corentin Chary
<corentin.chary@gmail.com> wrote:
> On Tue, Mar 16, 2010 at 9:31 PM, Fabio Comolli <fabio.comolli@gmail.com> wrote:
>> Hi.
>>
>> On Tue, Mar 16, 2010 at 7:54 AM, Corentin Chary
>> <corentin.chary@gmail.com> wrote:
>>> On Sat, Mar 13, 2010 at 1:50 PM, Fabio Comolli <fabio.comolli@gmail.com> wrote:
>>>> Well, I'm confused.
>>>>
>>>> I rebooted with the "vanilla" eeepc-laptop.c and I'm sorry to say that
>>>> the situation it's not like the one I described in the post I wrote 2
>>>> days ago. Actually the situation with the patch reverted is the same I
>>>> have with the patch applied.
>>>>
>>>> What I mean is that if I boot on AC power /proc/cpuinfo always reports
>>>> 900MHz and 1800 bogomips. It I boot on battery /proc/cpuinfo always
>>>> reports 630MHz and 1260 bogomips. Plugging / unplugging the AC does
>>>> not change the situation. Only reboot does.
>>>>
>>>> But the cpufv interface does indeed seem to work, as glxgears and
>>>> stellarium show the frame rate change accordingly to the powersave /
>>>> performance selection.
>>>>
>>>> So my question is: what does really the cpufv interface do? Is it
>>>> supposed to change the processor frequency? Or does it change
>>>> something else?
>>>>
>>>> And if the answer to the latest question is affirmative, why
>>>> /proc/cpuinfo seems to ignore it?
>>>>
>>>> Sorry for the confusion.
>>>> Regards,
>>>> Fabio
>>>>
>>>
>>> Here is what I can read in your DSDT:
>>>
>>> When INIT or _Q31 is called, the bios check the the battery is
>>> present, and call FSBA(0) or FSBA(1).
>>> _Q31 seems to be called by an hotkey, could you run "acpi_listen" and
>>> search the hotkey that generate 0x50 or 0x51 ?
>>
>> This is the output requested.
>>
>> hotkey ATKD 0000002e 00000000
>> hotkey ATKD 0000002f 00000000
>> hotkey ATKD 00000030 00000000
>> hotkey ATKD 00000012 00000000
>> hotkey ATKD 00000013 00000000
>> hotkey ATKD 00000014 00000000
>> hotkey ATKD 00000015 00000000
>> hotkey ATKD 00000010 00000000
>> button/sleep SLPB 00000080 00000001
>> hotkey ATKD 00000010 00000001
>
> None of thesed generate 0x50 or 0x51, may be somehting else :/
>
>

Found it!

Plugging the AC gives:

ac_adapter AC0 00000080 00000001
battery BAT0 00000080 00000001
hotkey ATKD 00000050 00000002

And unplugging gives:

battery BAT0 00000080 00000001
ac_adapter AC0 00000080 00000001
ac_adapter AC0 00000080 00000000
battery BAT0 00000080 00000001
hotkey ATKD 00000051 00000002
battery BAT0 00000080 00000001
ac_adapter AC0 00000080 00000000

However, the cpufv value is not affected at all.

>
> --
> Corentin Chary
> http://xf.iksaif.net
>

Regards,
Fabio
