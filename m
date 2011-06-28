Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752143Ab1F1WCG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 18:02:06 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:50284 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751226Ab1F1WCB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 18:02:01 -0400
X-Authenticated: #12510340
X-Provags-ID: V01U2FsdGVkX18NeKMtYiQNpIQ0Lx8sAXjI/CMc1sKVjzI/L8zpul
	nS14E/FcvUTwos
Message-ID: <4E0A4F56.90806@gmx.net>
Date: Wed, 29 Jun 2011 00:01:58 +0200
From: Olaf Freyer <aaron667@gmx.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110623 Lightning/1.0b3pre Thunderbird/3.1.11
MIME-Version: 1.0
To: Jesse Barnes <jbarnes@virtuousgeek.org>
CC: Florian Mickler <florian@mickler.org>, linux-kernel@vger.kernel.org,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Keith Packard <keithp@keithp.com>, dri-devel@lists.freedesktop.org
Subject: Re: Erroneous package power limit notification since kernel 2.6.39
References: <4DD9092A.4080507@gmx.net>	<loom.20110525T172412-101@post.gmane.org>	<20110626182725.3f2eac8d@schatten.dmk.lab>	<4E0A3DB1.8000202@gmx.net>	<20110628135936.297293b4@jbarnes-desktop>	<4E0A4319.6040309@gmx.net> <20110628141831.55502d76@jbarnes-desktop>
In-Reply-To: <20110628141831.55502d76@jbarnes-desktop>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 28.06.2011 23:18, schrieb Jesse Barnes:
> On Tue, 28 Jun 2011 23:09:45 +0200
> Olaf Freyer <aaron667@gmx.net> wrote:
>>>>> I'd guess ccab5c82759e2ace74b2e84f82d1e0eedd932571 could be the
>>>>> cause. Can you check if the appended revert of that commit makes
>>>>> things disappear? 
>>>> It seems like you guessed perfectly correct - reverting the commit makes
>>>> those notifications go away at once.
>>>>
>>> Without this reverted you see messages?  I missed the earlier stuff,
>>> what message are you seeing?
>>>
>> Since 2.6.39 I saw those as soon as I start up the xserver:
>>
>> May 22 14:41:34 localhost kernel: [   57.525848] CPU0: Package power
>> limit notification (total events = 1)
>> May 22 14:41:34 localhost kernel: [   57.536904] CPU0: Package power
>> limit normal
> Ok interesting, didn't realize X startup was so GPU intensive. :)
>
> The patch you reverted will definitely cause the GPU to ramp up its
> frequency much faster than before, but it sounds like on your system
> you might also see it with the revert if you run something GPU
> intensive like nexuiz.
>
> The CPU (and by extension the GPU) will take care of itself though; if
> things get too hot or over power, it will clock throttle to keep itself
> in a safe range.
I also see the message alot during my daily average usage of my computer
(just using Firefox, Thunderbird and IntelliJ) - seeing things like
CPU3: Package power limit notification (total events = 90809)
after a normal day in the office became normal since 2.6.39.

I just gave nexuiz a try for about 30 minutes with the reversal patch
applied -
and not a single message appeared in my logs.

