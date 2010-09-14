Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752724Ab0INAzi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 20:55:38 -0400
Received: from smtp-out.google.com ([216.239.44.51]:54660 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752129Ab0INAzg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 20:55:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=dSJwMufWXG4qmZJjYiha8UBhu+vtTi97JeZ8e3RtthGV3tgoRDb5oaDG7eQBsrDs9w
         PC0RIvbJvxwutmNYtK2Q==
MIME-Version: 1.0
In-Reply-To: <201009140104.03135.anarsoul@gmail.com>
References: <201009132336.17310.anarsoul@gmail.com>
	<201009140052.36670.anarsoul@gmail.com>
	<20100913145952.2646a2f8@jbarnes-desktop>
	<201009140104.03135.anarsoul@gmail.com>
Date: Mon, 13 Sep 2010 17:55:32 -0700
Message-ID: <AANLkTi=UCvj9prjv9WzurUg8Gb4i3LZxVJeNwvLtYieN@mail.gmail.com>
Subject: Re: Interrupt latency on some 945GM platforms
From: Venkatesh Pallipadi <venki@google.com>
To: Vasily Khoruzhick <anarsoul@gmail.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, intel-gfx@lists.freedesktop.org,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=KOI8-R
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 13, 2010 at 3:03 PM, Vasily Khoruzhick <anarsoul@gmail.com> wrote:
> В сообщении от 14 of September 2010 00:59:52 автор Jesse Barnes написал:
>> On Tue, 14 Sep 2010 00:52:31 +0300
>>
>> Vasily Khoruzhick <anarsoul@gmail.com> wrote:
>> > В сообщении от 14 of September 2010 00:46:32 автор Jesse Barnes написал:
>> > > Yes, you can set vblank_mode=0 in your environment or drirc.  At least
>> > > I think 0 is no vsync. :)
>> >
>> > That doesn't help, glxgears shows ~1000fps, but it's output is jerky.
>>
>> Is it smooth with clocksource=tsc?  I wonder if the GPU batch
>> interrupts are also getting delayed, and possibly timer ticks...
>
>
> Yes, it's smooth with clocksource=tsc nohz=off
>

Whats the clockevent in this case ("Tick Device" section of /proc/timer_list).
clocksource= option only changes the clocksource used to maintain
timeofday. But, timer interrupt (clockevent) source will not change.
Wondering how just the clocksource change is making the diff here..

Also, if clocksource tsc has a higher rating than HPET. The reason
HPET is getting used as clocksource in the first place seems to be due
to TSC is not a dependable clocksource on this platform (may be it
stops in C3). So, I am not sure forcing it to tsc will be a good
thing. May be clocksource=acpi_pm is a better thing to try.

Thanks,
Venki
