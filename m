Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751601Ab1GGVH1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 17:07:27 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:36656 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750756Ab1GGVH0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 17:07:26 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: MyungJoo Ham <myungjoo.ham@gmail.com>
Subject: Re: [PATCH v3 2/3] PM / DEVFREQ: add example governors
Date: Thu, 7 Jul 2011 23:08:38 +0200
User-Agent: KMail/1.13.6 (Linux/3.0.0-rc5+; KDE/4.6.0; x86_64; ; )
Cc: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        "Greg Kroah-Hartman" <gregkh@suse.de>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Jiejing Zhang <kzjeef@gmail.com>, Colin Cross <ccross@google.com>,
        Nishanth Menon <nm@ti.com>, Thomas Gleixner <tglx@linutronix.de>
References: <1306471995-4048-1-git-send-email-myungjoo.ham@samsung.com> <201107041043.25150.rjw@sisk.pl> <CAJ0PZbQ0ENk-vEebqiD=DGHZVtswHQkPre8wUqM2vwR_r+V=Uw@mail.gmail.com>
In-Reply-To: <CAJ0PZbQ0ENk-vEebqiD=DGHZVtswHQkPre8wUqM2vwR_r+V=Uw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201107072308.38622.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, July 04, 2011, MyungJoo Ham wrote:
> On Mon, Jul 4, 2011 at 5:43 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > On Monday, July 04, 2011, MyungJoo Ham wrote:
> >> Hello,
> >>
> >> 2011/7/3 Rafael J. Wysocki <rjw@sisk.pl>:
> >> > Hi,
> >> >
> >> > On Friday, May 27, 2011, MyungJoo Ham wrote:
> >> >> Three CPUFREQ-like governors are provided as examples.
> >> >>
> >> >> powersave: use the lowest frequency possible. The user (device) should
> >> >> set the polling_ms as 0 because polling is useless for this governor.
> >> >>
> >> >> performance: use the highest freqeuncy possible. The user (device)
> >> >> should set the polling_ms as 0 because polling is useless for this
> >> >> governor.
> >> >>
> >> >> simple_ondemand: simplified version of CPUFREQ's ONDEMAND governor.
> >> >>
> >> >> When a user updates OPP entries (enable/disable/add), OPP framework
> >> >> automatically notifies DEVFREQ to update operating frequency
> >> >> accordingly. Thus, DEVFREQ users (device drivers) do not need to update
> >> >> DEVFREQ manually with OPP entry updates or set polling_ms for powersave
> >> >> , performance, or any other "static" governors.
> >> >>
> >> >> Signed-off-by: MyungJoo Ham <myungjoo.ham@samsung.com>
> >> >> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> >> []
> >> >> +
> >> >> +     /* Set the desired frequency based on the load */
> >> >> +     a = (unsigned long long) stat.busy_time * stat.current_frequency;
> >> >
> >> > What's the purpose of the conversion?
> >>
> >> Assuming that the work speed of a device is proportional to its
> >> frequency, it measures the amount of work done.
> >> It's time * work/time. For example, during the last 10 second, if the
> >> busy_time was 5 sec and frequency was 10MHz,
> >> it's "50M", which is same as 20MHz and 2.5 sec.
> >
> > I understand that, but my question was why you're doing a forced conversion
> > to (unsigned long long).
> 
> Ah.. that was for the 64bit operations.
> 
> Both busy_time and current_frequency are 32bit and current_frequency
> may be a big number.
> 
> Thus, in order to get "freq" value without losing bits (e.g., if
> current_frequency = 1GHz and busy_time = 8000, we get an overflow
> without 64bit operations), I've inserted 64bit operations with the
> conversion. For the cosmetic reasons, it appears that "u64" looks
> better though.

You wouldn't need the explicit type casting if you did

a = stat.busy_time;
a *= stat.current_frequency;

Thanks,
Rafael
