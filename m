Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758583Ab0I0Aq1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Sep 2010 20:46:27 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:45866 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758549Ab0I0AqZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Sep 2010 20:46:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=uxbRFVSCc1ljgb/fj5g6V82QUG2pN6PdsI+MAHTT2abjKVynjdXM4ynJwZpLyO1Gse
         v/1KrOO1beMcVjzwwXoWkIpd7pTFrDiInWRj2OQjD90kBe2+qm29k6tTZnJMCSjZ4hgh
         RLvYBTg5GHpKAm0Mm4rSUNgWQRaTDg0KiTvhA=
MIME-Version: 1.0
In-Reply-To: <4C9F262F.7030709@biereigel-wb.de>
References: <201009132336.17310.anarsoul@gmail.com>
	<201009162306.59508.anarsoul@gmail.com>
	<20100924123901.243c85e1@jbarnes-desktop>
	<201009242248.36554.anarsoul@gmail.com>
	<20100924125153.4fdf0c1b@jbarnes-desktop>
	<4C9F262F.7030709@biereigel-wb.de>
Date: Mon, 27 Sep 2010 08:46:23 +0800
X-Google-Sender-Auth: GANP5xVMJ73kfUJ8yPPAYGYO7B4
Message-ID: <AANLkTinZ-A-D=yEsN00dGB=fpTgV72BgrEra9UpkmVHX@mail.gmail.com>
Subject: Re: Interrupt latency on some 945GM platforms
From: Shaohua Li <shaohua.li@intel.com>
To: Stefan Biereigel <security@biereigel-wb.de>
Cc: linux-kernel@vger.kernel.org, Vasily Khoruzhick <anarsoul@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sitsofe Wheeler <sitsofe@yahoo.com>,
        Venkatesh Pallipadi <venki@google.com>,
        intel-gfx@lists.freedesktop.org, Len Brown <lenb@kernel.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>
Content-Type: text/plain; charset=KOI8-R
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/9/26 Stefan Biereigel <security@biereigel-wb.de>:
> šAm 24.09.2010 21:51, schrieb Jesse Barnes:
>>
>> On Fri, 24 Sep 2010 22:48:36 +0300
>> Vasily Khoruzhick<anarsoul@gmail.com> šwrote:
>>
>>> On 24 of September 2010 22:39:01 Jesse Barnes wrote:
>>>>
>>>> On Thu, 16 Sep 2010 23:06:46 +0300
>>>>
>>>> Vasily Khoruzhick<anarsoul@gmail.com> šwrote:
>>>>>
>>>>> ÷ ÓÏÏÂÝÅÎÉÉ ÏÔ 16 of September 2010 21:50:50 Á×ÔÏÒ Thomas Gleixner
>>>
>>> ÎÁÐÉÓÁÌ:
>>>>>>
>>>>>> Ok. The problematic part of HPET was not the clocksource, it was the
>>>>>> clock event device which failed to deliver interrupts occasionally. It
>>>>>> was worth a try at least.
>>>>>
>>>>> Hm, it seems that jerky glxgears is not related to jerky keyboard
>>>>> events.
>>>>> Keyboard is jerky only in konsole (kde terminal emulator), it seems
>>>>> something happened it seems that font rendering performance is much
>>>>> worse in latest xf86-video-intel than in xf86-video-intel-2.12.0.
>>>>
>>>> Len just had me try a few things too:
>>>> š - maxcpus=1 lets things work
>>>> š - offlining cpu1 at runtime (echo 0
>>>>
>>>> š š > š/sys/devices/system/cpu/cpu1/online) lets things work
>>>>
>>>> š - binding the i915 interrupt to cpu 0 does *not* help
>>>>
>>>> Vasily and Paolo, do you both have Atom CPUs with hyperthreading
>>>> enabled?
>>>
>>> Nope, I have Core2Duo T5500, dual-core, no hyperthreading :)
>>
>> Hm, well there goes the theory about Atom HT...
>>
>
> Hello Everyone,
> just to add on to reports of this problem, there was a Thread here in LKML
> some months ago targeting the same problem (but not really attacking it at
> the Chipset driver). As I have one of those Laptops with a 945GM-Chipset and
> am stuck with the same Problem (disabled tickless now as a workaround and
> set ticks to 1000) I could maybe do some testing of patches.
> So what I can summarize is what the others did before: Disabling CPU1 helps,
> adding nohz=off helps, changing the Clocksource afterwards helps, binding
> the Interrupt does NOT help.
> So here's the Link to the old Discussion with follow-ups, maybe you can get
> some furter information from there.
> http://linux.derkeiler.com/Mailing-Lists/Kernel/2010-05/msg03696.html
> We targeted the BIOS itself as everyone in this thread happened to own an
> Phoenix BIOS with some special version string.
> best, Stefan
does disable msi help with 'pci=nomsi'?
