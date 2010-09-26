Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757455Ab0IZKxw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Sep 2010 06:53:52 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:61648 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757272Ab0IZKxv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Sep 2010 06:53:51 -0400
Message-ID: <4C9F262F.7030709@biereigel-wb.de>
Date: Sun, 26 Sep 2010 12:53:35 +0200
From: Stefan Biereigel <security@biereigel-wb.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; de; rv:1.9.2.9) Gecko/20100915 Lightning/1.0b2 Thunderbird/3.1.4
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Vasily Khoruzhick <anarsoul@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sitsofe Wheeler <sitsofe@yahoo.com>,
        Venkatesh Pallipadi <venki@google.com>,
        intel-gfx@lists.freedesktop.org, Len Brown <lenb@kernel.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: Interrupt latency on some 945GM platforms
References: <201009132336.17310.anarsoul@gmail.com>	<201009162306.59508.anarsoul@gmail.com>	<20100924123901.243c85e1@jbarnes-desktop>	<201009242248.36554.anarsoul@gmail.com> <20100924125153.4fdf0c1b@jbarnes-desktop>
In-Reply-To: <20100924125153.4fdf0c1b@jbarnes-desktop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Provags-ID: V02:K0:4Rbqs1DlbEL8NLbKBYw4EiX1+OR8XlmIoIDHWWgw8IC
 n4PfoAtaSKHLmIvVQQFHkZEsxeQcBukk8/4PPL6pkHr9r+IAbi
 K1pyLyBdhR16Kxi6srMmPAChfp9ZvAmXxDdtVQ5IVz/W4RJ9K7
 M26mOGG2V8YuGy72VlFDA01Lrr5/QOERY6Gc1Ono+zLAZCrUEz
 fTBA725BSJWNgBoyDN4q1tQaPF41WHOuENakoSsK30=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Am 24.09.2010 21:51, schrieb Jesse Barnes:
> On Fri, 24 Sep 2010 22:48:36 +0300
> Vasily Khoruzhick<anarsoul@gmail.com>  wrote:
>
>> On 24 of September 2010 22:39:01 Jesse Barnes wrote:
>>> On Thu, 16 Sep 2010 23:06:46 +0300
>>>
>>> Vasily Khoruzhick<anarsoul@gmail.com>  wrote:
>>>> В сообщении от 16 of September 2010 21:50:50 автор Thomas Gleixner
>> написал:
>>>>> Ok. The problematic part of HPET was not the clocksource, it was the
>>>>> clock event device which failed to deliver interrupts occasionally. It
>>>>> was worth a try at least.
>>>> Hm, it seems that jerky glxgears is not related to jerky keyboard events.
>>>> Keyboard is jerky only in konsole (kde terminal emulator), it seems
>>>> something happened it seems that font rendering performance is much
>>>> worse in latest xf86-video-intel than in xf86-video-intel-2.12.0.
>>> Len just had me try a few things too:
>>>    - maxcpus=1 lets things work
>>>    - offlining cpu1 at runtime (echo 0
>>>
>>>      >  /sys/devices/system/cpu/cpu1/online) lets things work
>>>
>>>    - binding the i915 interrupt to cpu 0 does *not* help
>>>
>>> Vasily and Paolo, do you both have Atom CPUs with hyperthreading
>>> enabled?
>> Nope, I have Core2Duo T5500, dual-core, no hyperthreading :)
> Hm, well there goes the theory about Atom HT...
>

Hello Everyone,
just to add on to reports of this problem, there was a Thread here in 
LKML some months ago targeting the same problem (but not really 
attacking it at the Chipset driver). As I have one of those Laptops with 
a 945GM-Chipset and am stuck with the same Problem (disabled tickless 
now as a workaround and set ticks to 1000) I could maybe do some testing 
of patches.
So what I can summarize is what the others did before: Disabling CPU1 
helps, adding nohz=off helps, changing the Clocksource afterwards helps, 
binding the Interrupt does NOT help.
So here's the Link to the old Discussion with follow-ups, maybe you can 
get some furter information from there.
http://linux.derkeiler.com/Mailing-Lists/Kernel/2010-05/msg03696.html
We targeted the BIOS itself as everyone in this thread happened to own 
an Phoenix BIOS with some special version string.
best, Stefan
