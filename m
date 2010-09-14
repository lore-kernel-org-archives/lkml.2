Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753040Ab0INJxO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 05:53:14 -0400
Received: from www.tglx.de ([62.245.132.106]:33081 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751581Ab0INJxL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 05:53:11 -0400
Date: Tue, 14 Sep 2010 11:52:57 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Vasily Khoruzhick <anarsoul@gmail.com>
cc: Venkatesh Pallipadi <venki@google.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: Re: Interrupt latency on some 945GM platforms
In-Reply-To: <201009141109.41596.anarsoul@gmail.com>
Message-ID: <alpine.LFD.2.00.1009141149380.2416@localhost6.localdomain6>
References: <201009132336.17310.anarsoul@gmail.com> <201009140104.03135.anarsoul@gmail.com> <AANLkTi=UCvj9prjv9WzurUg8Gb4i3LZxVJeNwvLtYieN@mail.gmail.com> <201009141109.41596.anarsoul@gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463795968-974713557-1284457979=:2416"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463795968-974713557-1284457979=:2416
Content-Type: TEXT/PLAIN; charset=utf-8
Content-Transfer-Encoding: 8BIT

On Tue, 14 Sep 2010, Vasily Khoruzhick wrote:

> В сообщении от 14 of September 2010 03:55:32 автор Venkatesh Pallipadi 
> написал:
> 
> > Whats the clockevent in this case ("Tick Device" section of
> > /proc/timer_list). clocksource= option only changes the clocksource used
> > to maintain
> > timeofday. But, timer interrupt (clockevent) source will not change.
> > Wondering how just the clocksource change is making the diff here..
> > 
> > Also, if clocksource tsc has a higher rating than HPET. The reason
> > HPET is getting used as clocksource in the first place seems to be due
> > to TSC is not a dependable clocksource on this platform (may be it
> > stops in C3). So, I am not sure forcing it to tsc will be a good
> > thing. May be clocksource=acpi_pm is a better thing to try.
> > 
> > Thanks,
> > Venki
> 
> I investigated it a bit and found out that single nohz=off option helps. Just 
> changing clocksource doesn't help, but it works smoothly with any clocksource 
> with nohz=off. So, it seems that something wrong with intel driver while 
> system is in tickless mode. 

Can you try with NOHZ enabled and the following on the kernel command line:

    processor.max_cstate=1

Make sure that CONFIG_ACPI_PROCESSOR is set to "y" and not to "m"

If that works, then try

    processor.max_cstate=2

Thanks,

	tglx
---1463795968-974713557-1284457979=:2416--
