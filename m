Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964967Ab2JXAlh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 20:41:37 -0400
Received: from cantor2.suse.de ([195.135.220.15]:55060 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933591Ab2JXAlf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 20:41:35 -0400
From: Thomas Renninger <trenn@suse.de>
To: Pawel Moll <pawel.moll@arm.com>
Cc: Amit Daniel Kachhap <amit.kachhap@linaro.org>,
        Zhang Rui <rui.zhang@intel.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Jean Delvare <khali@linux-fr.org>, Guenter Roeck <linux@roeck-us.net>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Jesper Juhl <jj@chaosbits.net>, Jean Pihet <jean.pihet@newoldbits.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        lm-sensors@lm-sensors.org, linaro-dev@lists.linaro.org
Subject: Re: [RFC] Energy/power monitoring within the kernel
Date: Wed, 24 Oct 2012 02:41:09 +0200
Message-ID: <2863728.eWy5qxh2lp@hammer82.arch.suse.de>
User-Agent: KMail/4.8.5 (Linux/3.4.11-2.16-desktop; KDE/4.8.5; x86_64; ; )
In-Reply-To: <1351013449.9070.5.camel@hornet>
References: <1351013449.9070.5.camel@hornet>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tuesday, October 23, 2012 06:30:49 PM Pawel Moll wrote:
> Greetings All,
> 
> More and more of people are getting interested in the subject of power
> (energy) consumption monitoring. We have some external tools like
> "battery simulators", energy probes etc., but some targets can measure
> their power usage on their own.
> 
> Traditionally such data should be exposed to the user via hwmon sysfs
> interface, and that's exactly what I did for "my" platform - I have
> a /sys/class/hwmon/hwmon*/device/energy*_input and this was good
> enough to draw pretty graphs in userspace. Everyone was happy...
> 
> Now I am getting new requests to do more with this data. In particular
> I'm asked how to add such information to ftrace/perf output.
Why? What is the gain?

Perf events can be triggered at any point in the kernel.
A cpufreq event is triggered when the frequency gets changed.
CPU idle events are triggered when the kernel requests to enter an idle state
or exits one.

When would you trigger a thermal or a power event?
There is the possibility of (critical) thermal limits.
But if I understand this correctly you want this for debugging and
I guess you have everything interesting one can do with temperature
values:
  - read the temperature
  - draw some nice graphs from the results

Hm, I guess I know what you want to do:
In your temperature/energy graph, you want to have some dots
when relevant HW states (frequency, sleep states,  DDR power,...)
changed. Then you are able to see the effects over a timeline.

So you have to bring the existing frequency/idle perf events together
with temperature readings

Cleanest solution could be to enhance the exisiting userspace apps
(pytimechart/perf timechart) and let them add another line
(temperature/energy), but the data would not come from perf, but
from sysfs/hwmon.
Not sure whether this works out with the timechart tools.
Anyway, this sounds like a userspace only problem.

   Thomas
