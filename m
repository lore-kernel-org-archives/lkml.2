Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757386Ab0IJAOd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 20:14:33 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:56583 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757279Ab0IJAOc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 20:14:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=gcaYqNrKRvBS5U50+lEwvcRfaT4OX/dmUANEMqjatSe5Bc2SoQlbjZNWPEGioyJXZg
         C+1a/5dpMEoOMrC4bLtaDan4eBIiA2eosvgCVKZ02jMIwy4QYxKKxpjnVggJNBOINRGs
         sMwRDfmJ1UcDIaemagoIF/04nTiiZgkbbUyr0=
MIME-Version: 1.0
In-Reply-To: <AANLkTincCptbDWrXup9aej1YJuHXgy2xriyZgdW9ceFD@mail.gmail.com>
References: <87zkvx2ese.fsf@spindle.srvr.nix>
	<20100906053255.GA23340@brouette>
	<87iq2gyllg.fsf@spindle.srvr.nix>
	<87wrqu8s1u.fsf_-_@spindle.srvr.nix>
	<AANLkTinSr0xoRrtZ6R+sRyQbf0LXhqBJisQTcdHc+A8+@mail.gmail.com>
	<87iq2e8o80.fsf@spindle.srvr.nix>
	<AANLkTincCptbDWrXup9aej1YJuHXgy2xriyZgdW9ceFD@mail.gmail.com>
Date: Thu, 9 Sep 2010 20:14:31 -0400
Message-ID: <AANLkTi=R5Qkdgvt=Gb_EGg-i59z07WvfGY3fsM+unsBN@mail.gmail.com>
Subject: Re: [BISECTED] 2.6.35.*: horrible (exponential? >linear) slowdown to
 unusability (HPET)
From: John Drescher <drescherjm@gmail.com>
To: Nix <nix@esperi.org.uk>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Venkatesh Pallipadi <venki@google.com>,
        Damien Wyart <damien.wyart@free.fr>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 9, 2010 at 8:08 PM, John Drescher <drescherjm@gmail.com> wrote:
> On Thu, Sep 9, 2010 at 7:57 PM, Nix <nix@esperi.org.uk> wrote:
>> On 10 Sep 2010, John Drescher spake thusly:
>>
>>>> John, Damien, you seem to be experiencing this: are you using HPET as
>>>> your clocksource? Do you also have ICH10 82801JIs, or is this more
>>>> widespread?
>>>>
>>> I am not using hpet as my clocksource.
>>>
>>> jmd1 ~ # uname -a
>>> Linux jmd1 2.6.35-std160-amd64 #2 SMP Fri Aug 13 18:42:02 UTC 2010
>>> x86_64 Intel(R) Core(TM) i7 CPU 920 @ 2.67GHz GenuineIntel GNU/Linux
>>> jmd1 ~ # cat /sys/devices/system/clocksource/clocksource0/current_clocksource
>>> tsc
>>
>> Hm, interesting. Perhaps the HPET is needed anyway? (That would explain
>> why my other system, with identical specs to those above and using tsc
>> as clocksource, was seeing intermittent problems in this area.)
>>
>> But 82801JI looks like a common factor.
>
> Now the interesting part. I switched to acpi_pm 10 to 15 minutes ago
> using the following command
>
> jmd1 ~ # echo acpi_pm
>>/sys/devices/system/clocksource/clocksource0/current_clocksource
>
> and it was still slow. But now its running fast (well at lest as far
> as I can tell via a ssh connection).
>

I just booted with clocksource=acpi_pm
and its fast at boot. I have never seen that on any 2.6.35 kernel (or
3.6.36 rc). Thanks I will do some testing..

John
